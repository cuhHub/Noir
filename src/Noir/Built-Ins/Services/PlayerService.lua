--------------------------------------------------------
-- [Noir] Services - Player Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
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
---@field OnJoin NoirEvent Arguments: player (NoirPlayer) | Fired when a player joins the server
---@field OnLeave NoirEvent Arguments: player (NoirPlayer) | Fired when a player leaves the server
---@field OnDie NoirEvent Arguments: player (NoirPlayer) | Fired when a player dies
---@field OnRespawn NoirEvent Arguments: player (NoirPlayer) | Fired when a player respawns
---@field Players table<integer, NoirPlayer> The players in the server
---@field _JoinCallback NoirConnection A connection to the onPlayerDie event
---@field _LeaveCallback NoirConnection A connection to the onPlayerLeave event
---@field _DieCallback NoirConnection A connection to the onPlayerDie event
---@field _RespawnCallback NoirConnection A connection to the onPlayerRespawn event
Noir.Services.PlayerService = Noir.Services:CreateService(
    "PlayerService",
    true,
    "A service that wraps SW players in a class.",
    "A service that wraps SW players in a class following an OOP format. Player data persistence across addon reloads is also handled, and player-related events are provided.",
    {"Cuh4"}
)

function Noir.Services.PlayerService:ServiceInit()
    self.OnJoin = Noir.Libraries.Events:Create()
    self.OnLeave = Noir.Libraries.Events:Create()
    self.OnDie = Noir.Libraries.Events:Create()
    self.OnRespawn = Noir.Libraries.Events:Create()

    self.Players = {}

    self:GetSaveData().PlayerProperties = self:_GetSavedProperties() or {}
    self:GetSaveData().RecognizedIDs = self:GetSaveData().RecognizedIDs or {}

    -- Load players in game
    if Noir.AddonReason == "AddonReload" then -- Only load players in-game if the addon was reloaded, otherwise onPlayerJoin will be called for the players that join when the save is loaded/created and we can just listen for that
        self:_LoadPlayers()
    end
end

function Noir.Services.PlayerService:ServiceStart()
    -- Create callbacks
    self._JoinCallback = Noir.Callbacks:Connect("onPlayerJoin", function(steam_id, name, peer_id, admin, auth)
        -- Give data
        local player = self:_GivePlayerData(steam_id, name, peer_id, admin, auth)

        if not player then
            return
        end

        -- Call join event
        self.OnJoin:Fire(player)
    end)

    self._LeaveCallback = Noir.Callbacks:Connect("onPlayerLeave", function(steam_id, name, peer_id, admin, auth)
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

    self._DieCallback = Noir.Callbacks:Connect("onPlayerDie", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just died, but they don't have data.", false)
            return
        end

        -- Call die event
        self.OnDie:Fire(player)
    end)

    self._RespawnCallback = Noir.Callbacks:Connect("onPlayerRespawn", function(peer_id)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just respawned, but they don't have data.", false)
            return
        end

        -- Call respawn event
        self.OnRespawn:Fire(player)
    end)
end

--[[
    Load players current in-game.
]]
function Noir.Services.PlayerService:_LoadPlayers()
    for _, player in pairs(server.getPlayers()) do
        -- Check if unnamed client
        if player.steam_id == 0 then
            goto continue
        end

        -- Check if already loaded
        if self:GetPlayer(player.id) then
            Noir.Libraries.Logging:Info("PlayerService", "server.getPlayers(): %s already has data. Ignoring.", player.name)
            goto continue
        end

        -- Give data
        local createdPlayer = self:_GivePlayerData(player.steam_id, player.name, player.id, player.admin, player.auth)

        if not createdPlayer then
            Noir.Libraries.Logging:Error("PlayerService", "server.getPlayers(): Player data creation failed.", false)
            goto continue
        end

        -- Load saved properties (eg: permissions)
        local savedProperties = self:_GetSavedPropertiesForPlayer(createdPlayer)

        if savedProperties then
            for property, value in pairs(savedProperties) do
                createdPlayer[property] = value
            end
        end

        -- Call onJoin if unrecognized
        if not self:_IsRecognized(createdPlayer) then
            self.OnJoin:Fire(createdPlayer)
        end

        ::continue::
    end
end

--[[
    Gives data to a player.<br>
    Used internally.
]]
---@param steam_id integer|string
---@param name string
---@param peer_id integer
---@param admin boolean
---@param auth boolean
---@return NoirPlayer|nil
function Noir.Services.PlayerService:_GivePlayerData(steam_id, name, peer_id, admin, auth)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "steam_id", steam_id, "number", "string")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "peer_id", peer_id, "number")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "admin", admin, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "auth", auth, "boolean")

    -- Check if the player is the server itself (applies to dedicated servers)
    if self:_IsHost(peer_id) then
        return
    end

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

    -- Save peer ID so we know if we can call onJoin for this player or not if the addon reloads
    self:_MarkRecognized(player)

    -- Return
    return player
end

--[[
    Removes data for a player.<br>
    Used internally.
]]
---@param player NoirPlayer
---@return boolean success Whether or not the operation was successful
function Noir.Services.PlayerService:_RemovePlayerData(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_RemovePlayerData()", "player", player, Noir.Classes.PlayerClass)

    -- Check if player exists in this service
    if not self:GetPlayer(player.ID) then
        Noir.Libraries.Logging:Error("PlayerService", "Attempted to remove player data from a non-existent player.", false)
        return false
    end

    -- Remove player
    self.Players[player.ID] = nil

    -- Remove saved properties
    self:_RemoveSavedProperties(player)

    -- Unmark as recognized
    self:_UnmarkRecognized(player)

    return true
end

--[[
    Returns whether or not a player is the server's host. Only applies in dedicated servers.<br>
    Used internally.
]]
---@param peer_id integer
---@return boolean
function Noir.Services.PlayerService:_IsHost(peer_id)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_IsHost()", "peer_id", peer_id, "number")

    -- Return true if the provided peer_id is that of the server host player
    return peer_id == 0 and Noir.IsDedicatedServer
end

--[[
    Mark a player as recognized to prevent onJoin being called for them after an addon reload.<br>
    Used internally.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_MarkRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_MarkRecognized()", "player", player, Noir.Classes.PlayerClass)

    -- Mark as recognized
    self:GetSaveData().RecognizedIDs[player.ID] = true
end

--[[
    Returns whether or not a player is recognized.<br>
    Used internally.
]]
---@param player NoirPlayer
---@return boolean
function Noir.Services.PlayerService:_IsRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_IsRecognized()", "player", player, Noir.Classes.PlayerClass)

    -- Return true if recognized
    return self:GetSaveData().RecognizedIDs[player.ID] ~= nil
end

--[[
    Mark a player as not recognized.<br>
    Used internally.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_UnmarkRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_UnmarkRecognized()", "player", player, Noir.Classes.PlayerClass)

    -- Remove from recognized
    self:GetSaveData().RecognizedIDs[player.ID] = nil
end

--[[
    Returns all saved player properties saved in g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSavedPlayerProperties
function Noir.Services.PlayerService:_GetSavedProperties()
    return self:GetSaveData().PlayerProperties
end

--[[
    Save a player's property to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@param property string
function Noir.Services.PlayerService:_SaveProperty(player, property)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_SaveProperty()", "player", player, Noir.Classes.PlayerClass)
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_SaveProperty()", "property", property, "string")

    -- Property saving
    local properties = self:_GetSavedProperties()

    if not properties[player.ID] then
        properties[player.ID] = {}
    end

    properties[player.ID][property] = player[property]
end

--[[
    Get a player's saved properties.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@return table<string, boolean>|nil
function Noir.Services.PlayerService:_GetSavedPropertiesForPlayer(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GetSavedPropertiesForPlayer()", "player", player, Noir.Classes.PlayerClass)

    -- Return saved properties for player
    return self:_GetSavedProperties()[player.ID]
end

--[[
    Removes a player's saved properties from g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_RemoveSavedProperties(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_RemoveSavedProperties()", "player", player, Noir.Classes.PlayerClass)

    -- Remove saved properties
    local properties = self:_GetSavedProperties()
    properties[player.ID] = nil
end

--[[
    Returns all players.<br>
    This is the preferred way to get all players instead of using `Noir.Services.PlayerService.Players`.
]]
---@param usePeerIDsAsIndex boolean|nil If true, the indices of the returned table will match the peer ID of the value (player) matched to the index. Having this as true is slightly faster
---@return table<integer, NoirPlayer>
function Noir.Services.PlayerService:GetPlayers(usePeerIDsAsIndex)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayers()", "usePeerIDsAsIndex", usePeerIDsAsIndex, "boolean", "nil")

    -- Return players
    return usePeerIDsAsIndex and self.Players or Noir.Libraries.Table:Values(self.Players)
end

--[[
    Returns a player by their peer ID.<br>
    This is the preferred way to get a player.
]]
---@param ID integer
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayer(ID)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayer()", "ID", ID, "number")

    -- Return player if any
    return self:GetPlayers(true)[ID]
end

--[[
    Returns a player by their Steam ID.<br>
    Note that two players or more can have the same Steam ID if they spoof their Steam ID or join the server on two Stormworks instances.
]]
---@param steam string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerBySteam(steam)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayerBySteam()", "steam", steam, "string")

    -- Get player
    for _, player in pairs(self:GetPlayers(true)) do
        if player.Steam == steam then
            return player
        end
    end
end

--[[
    Returns a player by their exact name.<br>
    Consider using `:SearchPlayerByName()` if the player name only needs to match partially.
]]
---@param name string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerByName(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayerByName()", "name", name, "string")

    -- Get player
    for _, player in pairs(self:GetPlayers(true)) do
        if player.Name == name then
            return player
        end
    end
end

--[[
    Get a player by their character.
]]
---@param character NoirObject
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerByCharacter(character)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayerByCharacter()", "character", character, Noir.Classes.ObjectClass)

    -- Get player
    for _, player in pairs(self:GetPlayers(true)) do
        if player:GetCharacter() == character then
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:SearchPlayerByName()", "name", name, "string")

    -- Get player
    for _, player in pairs(self:GetPlayers(true)) do
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:IsSamePlayer()", "playerA", playerA, Noir.Classes.PlayerClass)
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:IsSamePlayer()", "playerB", playerB, Noir.Classes.PlayerClass)

    -- Return if both players are the same
    return playerA.ID == playerB.ID
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirSavedPlayerProperties table<integer, table<string, any>>