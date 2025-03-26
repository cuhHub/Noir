--------------------------------------------------------
-- [Noir] Services - Player Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2025 Cuh4

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
---@field OnSit NoirEvent Arguments: player (NoirPlayer), body (NoirBody|nil), seatName (string) | Fired when a player sits in a seat (body can be nil if the player sat on a map object, etc)
---@field OnUnsit NoirEvent Arguments: player (NoirPlayer), body (NoirBody|nil), seatName (string) | Fired when a player unsits in a seat (body can be nil if the player sat on a map object, etc)
---@field OnRespawn NoirEvent Arguments: player (NoirPlayer) | Fired when a player respawns
---@field Players table<integer, NoirPlayer> The players in the server
---@field _JoinCallback NoirConnection A connection to the onPlayerDie event
---@field _LeaveCallback NoirConnection A connection to the onPlayerLeave event
---@field _DieCallback NoirConnection A connection to the onPlayerDie event
---@field _RespawnCallback NoirConnection A connection to the onPlayerRespawn event
---@field _SitCallback NoirConnection A connection to the onPlayerSit event
---@field _UnsitCallback NoirConnection A connection to the onPlayerUnsit event
Noir.Services.PlayerService = Noir.Services:CreateService(
    "PlayerService",
    true,
    "A service that wraps SW players in a class.",
    "A service that wraps SW players in a class following an OOP format. Player data persistence across addon reloads is also handled, and player-related events are provided.",
    {"Cuh4"}
)

Noir.Services.PlayerService.InitPriority = 1

function Noir.Services.PlayerService:ServiceInit()
    self.OnJoin = Noir.Libraries.Events:Create()
    self.OnLeave = Noir.Libraries.Events:Create()
    self.OnDie = Noir.Libraries.Events:Create()
    self.OnRespawn = Noir.Libraries.Events:Create()
    self.OnSit = Noir.Libraries.Events:Create()
    self.OnUnsit = Noir.Libraries.Events:Create()

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

        if not player then -- likely unnamed client
            return
        end

        -- Remove player
        self:_RemovePlayerData(player)

        -- Call leave event
        self.OnLeave:Fire(player)
    end)

    self._DieCallback = Noir.Callbacks:Connect("onPlayerDie", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Debugging:RaiseError("PlayerService", "A player just died, but they don't have data.")
            return
        end

        -- Call die event
        self.OnDie:Fire(player)
    end)

    self._RespawnCallback = Noir.Callbacks:Connect("onPlayerRespawn", function(peer_id)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Debugging:RaiseError("PlayerService", "A player just respawned, but they don't have data.")
            return
        end

        -- Call respawn event
        self.OnRespawn:Fire(player)
    end)

    self._SitCallback = Noir.Callbacks:Connect("onPlayerSit", function(peer_id, vehicle_id, seat_name)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Debugging:RaiseError("PlayerService", "A player just sat in a body, but they don't have data.")
            return
        end

        -- Get body
        local body = Noir.Services.VehicleService:GetBody(vehicle_id) -- can be nil if the player sat on a bed on the map

        -- Call sit event
        self.OnSit:Fire(player, body, seat_name)
    end)

    self._UnsitCallback = Noir.Callbacks:Connect("onPlayerUnsit", function(peer_id, vehicle_id, seat_name)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Debugging:RaiseError("PlayerService", "A player just got up from a body seat, but they don't have data.")
            return
        end

        -- Get body
        local body = Noir.Services.VehicleService:GetBody(vehicle_id) -- can be nil if the player sat on a bed on the map

        -- Call unsit event
        self.OnUnsit:Fire(player, body, seat_name)
    end)
end

--[[
    Load players current in-game.
]]
function Noir.Services.PlayerService:_LoadPlayers()
    for _, player in pairs(server.getPlayers()) do
        -- Check if server
        if player.steam_id == 0 then
            goto continue
        end

        -- Check if unnamed client
        if player.name == "unnamed client" and not player.object_id then -- i don't like this. what if a player actually has their name as unnamed client? i'm also not entirely sure if actual players have an object_id when loading in
            return
        end

        -- Check if already loaded
        if self:GetPlayer(player.id) then
            goto continue
        end

        -- Give data
        local createdPlayer = self:_GivePlayerData(player.steam_id, player.name, player.id, player.admin, player.auth)

        if not createdPlayer then
            Noir.Debugging:RaiseError("PlayerService:_LoadPlayers()", "Player data creation failed.")
            goto continue -- purely for lua lsp to stop bitching. this `goto` statement doesn't actually execute
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

    self:_ClearRecognized() -- prevent table getting massive over time, especially on popular saves
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
        Noir.Debugging:RaiseError("PlayerService:_GivePlayerData()", "Attempted to give data to a player that already exists.")
        return
    end

    -- Create player
    local player = Noir.Classes.Player:New(
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
function Noir.Services.PlayerService:_RemovePlayerData(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_RemovePlayerData()", "player", player, Noir.Classes.Player)

    -- Check if player exists in this service
    if not self:GetPlayer(player.ID) then
        Noir.Debugging:RaiseError("PlayerService:_RemovePlayerData()", "Attempted to remove a player from the service that isn't in the service.")
    end

    -- Remove player
    player.InGame = false
    self.Players[player.ID] = nil

    -- Remove saved properties
    self:_RemoveSavedProperties(player)

    -- Unmark as recognized
    self:_UnmarkRecognized(player)
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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_MarkRecognized()", "player", player, Noir.Classes.Player)

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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_IsRecognized()", "player", player, Noir.Classes.Player)

    -- Return true if recognized
    return self:GetSaveData().RecognizedIDs[player.ID] ~= nil
end

--[[
    Clear the list of recognized players.<br>
    Used internally.
]]
function Noir.Services.PlayerService:_ClearRecognized()
    self:GetSaveData().RecognizedIDs = {}
end

--[[
    Mark a player as not recognized.<br>
    Used internally.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_UnmarkRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_UnmarkRecognized()", "player", player, Noir.Classes.Player)

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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_SaveProperty()", "player", player, Noir.Classes.Player)
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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GetSavedPropertiesForPlayer()", "player", player, Noir.Classes.Player)

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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_RemoveSavedProperties()", "player", player, Noir.Classes.Player)

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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayerByCharacter()", "character", character, Noir.Classes.Object)

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
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:IsSamePlayer()", "playerA", playerA, Noir.Classes.Player)
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:IsSamePlayer()", "playerB", playerB, Noir.Classes.Player)

    -- Return if both players are the same
    return playerA.ID == playerB.ID
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirSavedPlayerProperties table<integer, table<string, any>>