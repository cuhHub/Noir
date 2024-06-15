--------------------------------------------------------
-- [Noir] Services - Player Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2024 Cuh4

        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------

--[[
    A service that wraps SW players in a class. Essentially makes players OOP.

    local player = Noir.Services.PlayerService:GetPlayer(0)
    player:IsAdmin() -- true
    player:Teleport(matrix.translation(10, 0, 10))

    ---@param player NoirPlayer
    Noir.Services.PlayerService.OnJoin:Once(function(player) -- Ban the first player who joins
        player:Ban()
    end)
]]
---@class NoirPlayerService: NoirService
---@field OnJoin NoirEvent Arguments: player | Fired when a player joins the server
---@field OnLeave NoirEvent Arguments: player | Fired when a player leaves the server
---@field OnDie NoirEvent Arguments: player | Fired when a player dies
---@field OnRespawn NoirEvent Arguments: player | Fired when a player respawns
---@field Players table<integer, NoirPlayer>
---@field JoinCallback NoirConnection A connection to the onPlayerDie event
---@field LeaveCallback NoirConnection A connection to the onPlayerLeave event
---@field DieCallback NoirConnection A connection to the onPlayerDie event
---@field RespawnCallback NoirConnection A connection to the onPlayerRespawn event
---@field DestroyCallback NoirConnection A connection to the onDestroy event
Noir.Services.PlayerService = Noir.Services:CreateService("PlayerService")
Noir.Services.PlayerService.InitPriority = 2
Noir.Services.PlayerService.StartPriority = 2

function Noir.Services.PlayerService:ServiceInit()
    self.OnJoin = Noir.Libraries.Events:Create()
    self.OnLeave = Noir.Libraries.Events:Create()
    self.OnDie = Noir.Libraries.Events:Create()
    self.OnRespawn = Noir.Libraries.Events:Create()

    self.Players = {}
end

function Noir.Services.PlayerService:ServiceStart()
    -- Create callbacks
    ---@param steam_id string
    ---@param name string
    ---@param peer_id integer
    ---@param admin boolean
    ---@param auth boolean
    self.JoinCallback = Noir.Callbacks:Connect("onPlayerJoin", function(steam_id, name, peer_id, admin, auth)
        -- Check if player was loaded via save data. This happens because onPlayerJoin runs for the host after Noir fully starts
        if self:GetPlayer(peer_id) then
            return
        end

        -- Give data
        local player = self:_GivePlayerData(steam_id, name, peer_id, admin, auth)

        if not player then
            return
        end

        -- Call join event
        self.OnJoin:Fire(player)
    end)

    ---@param steam_id string
    ---@param name string
    ---@param peer_id integer
    ---@param admin boolean
    ---@param auth boolean
    self.LeaveCallback = Noir.Callbacks:Connect("onPlayerLeave", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just left, but their data couldn't be found.", false)
            return
        end

        -- Remove player
        local success = self:_RemovePlayerData(player)

        if not success then
            Noir.Libraries.Logging:Error("PlayerService", "onPlayerLeave player data removal failed.", false)
            return
        end

        -- Call leave event
        self.OnLeave:Fire(player)
    end)

    ---@param steam_id string
    ---@param name string
    ---@param peer_id integer
    ---@param admin boolean
    ---@param auth boolean
    self.DieCallback = Noir.Callbacks:Connect("onPlayerDie", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just died, but they don't have data.", false)
            return
        end

        -- Call die event
        self.OnDie:Fire(player)
    end)

    ---@param peer_id integer
    self.RespawnCallback = Noir.Callbacks:Connect("onPlayerRespawn", function(peer_id)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just respawned, but they don't have data.", false)
            return
        end

        -- Call respawn event
        self.OnRespawn:Fire(player)
    end)

    -- Remove all players when the world exists
    self.DestroyCallback = Noir.Callbacks:Connect("onDestroy", function()
        for _, player in pairs(self:GetPlayers()) do
            self.LeaveCallback:Fire(nil, nil, player.ID) -- TODO: probably add service methods that handles onPlayerJoin and onPlayerLeave, that way we can trigger the onPlayerLeave handler code cleanly here
        end
    end)

    -- Load players in game
    if Noir.AddonReason == "AddonReload" then -- Only load players in-game if the addon was reloaded, otherwise onPlayerJoin will be called for the players that join when the save is loaded/created and we can just listen for that
        for _, player in pairs(server.getPlayers()) do
            -- Check if unnamed client
            if player.steam_id == 0 then
                goto continue
            end

            -- Log
            Noir.Libraries.Logging:Info("PlayerService", "server.getPlayers(): Loading player in game: %s (%d, %s)", player.name, player.id, player.steam_id)

            -- Check if already loaded
            if self:GetPlayer(player.id) then
                Noir.Libraries.Logging:Info("PlayerService", "server.getPlayers(): %s already has data. Ignoring.", player.name)
                goto continue
            end

            -- Give data
            local createdPlayer = self:_GivePlayerData(tostring(player.steam_id), player.name, player.id, player.admin, player.auth)

            if not createdPlayer then
                Noir.Libraries.Logging:Error("PlayerService", "server.getPlayers(): Player data creation failed.", false)
                goto continue
            end

            -- Load saved properties
            local savedProperties = self:_GetSavedPropertiesForPlayer(createdPlayer)

            if savedProperties then
                for property, value in pairs(savedProperties) do
                    createdPlayer[property] = value
                end
            end

            ::continue::
        end
    end
end

--[[
    Gives data to a player.<br>
    Used internally.
]]
---@param steam_id string
---@param name string
---@param peer_id integer
---@param admin boolean
---@param auth boolean
---@return NoirPlayer|nil
function Noir.Services.PlayerService:_GivePlayerData(steam_id, name, peer_id, admin, auth)
    -- Check if player already exists
    if self:GetPlayer(peer_id) then
        Noir.Libraries.Logging:Error("PlayerService", "Attempted to give player data to an existing player. This player has been ignored.", false)
        return
    end

    -- Create player
    local player = Noir.Classes.PlayerClass:New(
        name,
        peer_id,
        tostring(steam_id),
        admin,
        auth,
        {}
    )

    -- Save player
    self.Players[peer_id] = player

    -- Return
    return player
end

--[[
    Overwrite saved properties.<br>
    Used internally. Do not use in your code.
]]
---@param properties NoirSavedPlayerProperties
function Noir.Services.PlayerService:_OverwriteSavedProperties(properties)
    self:Save("PlayerProperties", properties)
end

--[[
    Returns all saved player properties saved in g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSavedPlayerProperties
function Noir.Services.PlayerService:_GetSavedProperties()
    return self:Load("PlayerProperties", {})
end

--[[
    Removes data for a player.<br>
    Used internally.
]]
---@param player NoirPlayer
---@return boolean success Whether or not the operation was successful
function Noir.Services.PlayerService:_RemovePlayerData(player)
    -- Check if player exists in this service
    if not self:GetPlayer(player.ID) then
        Noir.Libraries.Logging:Error("PlayerService", "Attempted to remove player data from a non-existent player.", false)
        return false
    end

    -- Remove player
    self.Players[player.ID] = nil

    -- Remove saved properties
    self:_RemoveSavedProperties(player)

    return true
end

--[[
    Save a player's property to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@param property string
function Noir.Services.PlayerService:_SaveProperty(player, property)
    local properties = self:_GetSavedProperties()

    if not properties[player.ID] then
        Noir.Libraries.Logging:Error("PlayerService", "%s is missing a properties savedata table, causing PlayerService:_SaveProperty() to fail.", false, player.Name)
        return
    end

    properties[player.ID][property] = player[property]
    self:_OverwriteSavedProperties(properties)
end

--[[
    Get a player's saved properties.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_GetSavedPropertiesForPlayer(player)
    return self:_GetSavedProperties()[player.ID]
end

--[[
    Removes a player's saved properties from g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_RemoveSavedProperties(player)
    local properties = self:_GetSavedProperties()
    properties[player.ID] = nil
    self:_OverwriteSavedProperties(properties)
end

--[[
    Returns all players.<br>
    This is the preferred way to get all players instead of using `Noir.Services.PlayerService.Players`.
]]
---@return table<integer, NoirPlayer>
function Noir.Services.PlayerService:GetPlayers()
    return self.Players
end

--[[
    Returns a player by their peer ID.<br>
    This is the preferred way to get a player.
]]
---@param ID integer
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayer(ID)
    return self:GetPlayers()[ID]
end

--[[
    Returns a player by their Steam ID.<br>
    Note that two players or more can have the same Steam ID if they spoof their Steam ID or join the server on two Stormworks instances.
]]
---@param steam string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerBySteam(steam)
    for _, player in pairs(self:GetPlayers()) do
        if player.Steam == steam then
            return player
        end
    end
end

--[[
    Returns a player by their exact name.<br>
    Consider using `:SearchPlayerByName()` if you want to search and not directly fetch.
]]
---@param name string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerByName(name)
    for _, player in pairs(self:GetPlayers()) do
        if player.Name == name then
            return player
        end
    end
end

--[[
    Searches for a player by their name, similar to a Google search but way simpler under the hood.
]]
---@param name string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:SearchPlayerByName(name)
    for _, player in pairs(self:GetPlayers()) do
        if player.Name:lower():gsub(" ", ""):find(name:lower():gsub(" ", "")) then
            return player
        end
    end
end

--[[
    Returns whether or not two players are the same.
]]
---@param playerA NoirPlayer
---@param playerB NoirPlayer
---@return boolean
function Noir.Services.PlayerService:IsSamePlayer(playerA, playerB)
    return playerA.ID == playerB.ID
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirSavedPlayerProperties table<integer, table<string, any>>