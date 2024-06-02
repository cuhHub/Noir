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

    ---@param player NoirPlayerServicePlayer
    Noir.Services.PlayerService.OnJoin:Once(function(player) -- Ban the first player who joins
        player:Ban()
    end)
]]
Noir.Services.PlayerService = Noir.Services:CreateService("PlayerService") ---@type NoirPlayerService
Noir.Services.PlayerService.initPriority = 2
Noir.Services.PlayerService.startPriority = 2

function Noir.Services.PlayerService:ServiceInit()
    -- Create attributes
    self.OnJoin = Noir.Libraries.Events:Create()
    self.OnLeave = Noir.Libraries.Events:Create()
    self.OnDie = Noir.Libraries.Events:Create()
    self.OnRespawn = Noir.Libraries.Events:Create()

    self.players = {}

    -- Create callbacks
    ---@param steam_id string
    ---@param name string
    ---@param peer_id integer
    ---@param admin boolean
    ---@param auth boolean
    self.joinCallback = Noir.Callbacks:Connect("onPlayerJoin", function(steam_id, name, peer_id, admin, auth)
        -- Give data
        local player = self:GivePlayerData(steam_id, name, peer_id, admin, auth)

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
    self.leaveCallback = Noir.Callbacks:Connect("onPlayerLeave", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Warning("PlayerService", "A player just left, but their data couldn't be found (doesn't exist for some reason).")
            return
        end

        -- Remove player
        local success = self:RemovePlayerData(player)

        if not success then
            Noir.Libraries.Logging:Warning("PlayerService", "onPlayerLeave player data removal failed.")
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
    self.dieCallback = Noir.Callbacks:Connect("onPlayerDie", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Warning("PlayerService", "A player just died, but they don't have data. This player has been ignored.")
            return
        end

        -- Call die event
        self.OnDie:Fire(player)
    end)

    ---@param peer_id integer
    self.respawnCallback = Noir.Callbacks:Connect("onPlayerRespawn", function(peer_id)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Warning("PlayerService", "A player just respawned, but they don't have data. This player has been ignored.")
            return
        end

        -- Call respawn event
        self.OnRespawn:Fire(player)
    end)

    -- Create player class
    self.PlayerClass = Noir.Libraries.Class:Create("NoirPlayerServicePlayer") ---@type NoirPlayerServicePlayer

    ---@param player NoirPlayerServicePlayer
    ---@param name string
    ---@param ID integer
    ---@param steam string
    ---@param admin boolean
    ---@param auth boolean
    function self.PlayerClass.Init(player, name, ID, steam, admin, auth)
        player.name = name
        player.ID = ID
        player.steam = steam
        player.admin = admin
        player.auth = auth
    end

    function self.PlayerClass.Serialize(player)
        return {
            name = player.name,
            ID = player.ID,
            steam = player.steam,
            admin = player.admin,
            auth = player.auth
        }
    end

    function self.PlayerClass.Deserialize(serializedPlayer)
        local player = self.PlayerClass:New( ---@type NoirPlayerServicePlayer
            serializedPlayer.name,
            serializedPlayer.ID,
            serializedPlayer.steam,
            serializedPlayer.admin,
            serializedPlayer.auth
        )

        return player
    end

    function self.PlayerClass.SetAuth(player, auth)
        if auth then
            server.addAuth(player.ID)
        else
            server.removeAuth(player.ID)
        end

        player.auth = auth
    end

    function self.PlayerClass.SetAdmin(player, admin)
        if admin then
            server.addAdmin(player.ID)
        else
            server.removeAdmin(player.ID)
        end

        player.admin = admin
    end

    function self.PlayerClass.Kick(player)
        server.kickPlayer(player.ID)
    end

    function self.PlayerClass.Ban(player)
        server.banPlayer(player.ID)
    end

    function self.PlayerClass.Teleport(player, pos)
        server.setPlayerPos(player.ID, pos)
    end

    function self.PlayerClass.GetPosition(player)
        return (server.getPlayerPos(player.ID)) or matrix.translation(0, 0, 0)
    end

    function self.PlayerClass.SetCharacterData(player, hp, interactable, AI)
        -- Get the character
        local character = player:GetCharacter()

        if not character then
            Noir.Libraries.Logging:Error("PlayerService", ":SetCharacterData() failed for player %s (%d, %s) due to character being nil", player.name, player.ID, player.steam)
            return
        end

        -- Set the data
        server.setCharacterData(character, hp, interactable, AI)
    end

    function self.PlayerClass.Heal(player, amount)
        -- Get health
        local health = player:GetHealth()

        -- Heal
        player:SetCharacterData(health + amount, false, false)
    end

    function self.PlayerClass.Damage(player, amount)
        -- Get health
        local health = player:GetHealth()

        -- Damage
        player:SetCharacterData(health - amount, false, false)
    end

    function self.PlayerClass.GetCharacter(player)
        -- Get the character
        local character = server.getPlayerCharacterID(player.ID)

        if not character then
            Noir.Libraries.Logging:Error("PlayerService", ":GetCharacter() failed for player %s (%d, %s)", player.name, player.ID, player.steam)
            return
        end

        -- Return
        return character
    end

    function self.PlayerClass.Revive(player)
        -- Get the character
        local character = player:GetCharacter()

        if not character then
            Noir.Libraries.Logging:Error("PlayerService", ":Revive() failed for player %s (%d, %s) due to character being nil", player.name, player.ID, player.steam)
            return
        end

        -- Revive the character
        server.reviveCharacter(character)
    end

    function self.PlayerClass.GetCharacterData(player)
        -- Get the character
        local character = player:GetCharacter()

        if not character then
            Noir.Libraries.Logging:Error("PlayerService", ":GetCharacterData() failed for player %s (%d, %s) due to character being nil", player.name, player.ID, player.steam)
            return
        end

        -- Get the character data
        local data = server.getCharacterData(character)

        if not data then
            Noir.Libraries.Logging:Error("PlayerService", ":GetCharacterData() failed for player %s (%d, %s). Data is nil", player.name, player.ID, player.steam)
            return
        end

        -- Return
        return data
    end

    function self.PlayerClass.GetHealth(player)
        -- Get character data
        local data = player:GetCharacterData()

        if not data then
            Noir.Libraries.Logging:Error("PlayerService", ":GetHealth() failed for player %s (%d, %s) due to data being nil. Returning 100 instead", player.name, player.ID, player.steam)
            return 100
        end

        -- Return
        return data.hp
    end

    function self.PlayerClass.IsDowned(player)
        -- Get character data
        local data = player:GetCharacterData()

        if not data then
            Noir.Libraries.Logging:Error("PlayerService", ":IsDowned() failed for player %s (%d, %s) due to data being nil. Returning false instead", player.name, player.ID, player.steam)
            return false
        end

        -- Return
        return data.dead or data.incapacitated or data.hp <= 0
    end
end

function Noir.Services.PlayerService:ServiceStart()
    -- Load players from save
    local players = self:GetSavedPlayers()

    for _, player in pairs(players) do
        -- Log
        Noir.Libraries.Logging:Info("PlayerService", "Loading player from save data: %s (%d, %s)", player.name, player.ID, player.steam)

        -- Give data
        self:GivePlayerData(player.steam, player.name, player.ID, player.admin, player.auth)
    end

    -- Load players in game
    for _, player in pairs(server.getPlayers()) do
        -- Check if unnamed client
        if player.steam_id == 0 then
            goto continue
        end

        -- Log
        Noir.Libraries.Logging:Info("PlayerService", "Loading player in game: %s (%d, %s)", player.name, player.id, player.steam_id)

        -- Check if already loaded
        if self:GetPlayer(player.id) then
            Noir.Libraries.Logging:Info("PlayerService", "%s already has data. Ignoring.", player.name)
            goto continue
        end

        -- Give data
        self:GivePlayerData(tostring(player.steam_id), player.name, player.id, player.admin, player.auth)

        ::continue::
    end
end

function Noir.Services.PlayerService:GetSavedPlayers()
    return self:Load("players", {})
end

function Noir.Services.PlayerService:GivePlayerData(steam_id, name, peer_id, admin, auth)
    -- Check if player already exists
    if self:GetPlayer(peer_id) then
        Noir.Libraries.Logging:Warning("PlayerService", "Attempted to give player data to an existing player. This player has been ignored.")
        return
    end

    -- Create player
    ---@type NoirPlayerServicePlayer
    local player = self.PlayerClass:New(
        name,
        peer_id,
        tostring(steam_id),
        admin,
        auth
    )

    -- Save player
    self.players[peer_id] = player
    self:GetSavedPlayers()[peer_id] = player:Serialize()
    self:Save("players", self:GetSavedPlayers())

    -- Return
    return player
end

function Noir.Services.PlayerService:RemovePlayerData(player)
    -- Check if player exists in this service
    if not self:GetPlayer(player.ID) then
        Noir.Libraries.Logging:Warning("PlayerService", "Attempted to remove player data from a non-existent player. This player has been ignored.")
        return false
    end

    -- Remove player
    self.players[player.ID] = nil
    self:GetSavedPlayers()[player.ID] = nil

    return true
end

function Noir.Services.PlayerService:GetPlayers()
    return self.players
end

function Noir.Services.PlayerService:GetPlayer(ID)
    return self.players[ID]
end

function Noir.Services.PlayerService:GetPlayerBySteam(steam)
    for _, player in pairs(self:GetPlayers()) do
        if player.steam == steam then
            return player
        end
    end
end

function Noir.Services.PlayerService:GetPlayerByName(name)
    for _, player in pairs(self:GetPlayers()) do
        if player.name == name then
            return player
        end
    end
end

function Noir.Services.PlayerService:SearchPlayerByName(name)
    for _, player in pairs(self:GetPlayers()) do
        if player.name:lower():gsub(" ", ""):find(name:lower():gsub(" ", "")) then
            return player
        end
    end
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirPlayerService: NoirService
---@field PlayerClass NoirPlayerServicePlayer The class that represents a task. Used internally
---@field OnJoin NoirEvent player | Fired when a player joins the server
---@field OnLeave NoirEvent player | Fired when a player leaves the server
---@field OnDie NoirEvent player | Fired when a player dies
---@field OnRespawn NoirEvent player | Fired when a player respawns
---@field players table<integer, NoirPlayerServicePlayer>
---
---@field joinCallback NoirConnection A connection to the OnJoin event
---@field leaveCallback NoirConnection A connection to the OnLeave event
---@field dieCallback NoirConnection A connection to the OnDie event
---@field respawnCallback NoirConnection A connection to the OnRespawn event
---
---@field GetSavedPlayers fun(self: NoirPlayerService): table<integer, NoirPlayerServiceSerializedPlayer>
---@field GivePlayerData fun(self: NoirPlayerService, steam_id: string, name: string, peer_id: integer, admin: boolean, auth: boolean): NoirPlayerServicePlayer|nil A method that gives a player data
---@field RemovePlayerData fun(self: NoirPlayerService, player: NoirPlayerServicePlayer): boolean A method that removes a player data
---@field GetPlayers fun(self: NoirPlayerService): table<integer, NoirPlayerServicePlayer> A method that returns all players
---@field GetPlayer fun(self: NoirPlayerService, ID: integer): NoirPlayerServicePlayer|nil A method that gets a player by their ID
---@field GetPlayerBySteam fun(self: NoirPlayerService, steam: string): NoirPlayerServicePlayer|nil A method that gets a player by their Steam ID
---@field GetPlayerByName fun(self: NoirPlayerService, name: string): NoirPlayerServicePlayer|nil A method that gets a player by their name
---@field SearchPlayerByName fun(self: NoirPlayerService, query: string): NoirPlayerServicePlayer|nil A method that searches for a player. Caps insensitive

---@class NoirPlayerServiceSerializedPlayer
---@field name string
---@field ID integer
---@field steam string
---@field admin boolean
---@field auth boolean

---@class NoirPlayerServicePlayer: NoirClass
---@field name string The name of this player
---@field ID integer The ID of this player
---@field steam string The Steam ID of this player
---@field admin boolean Whether or not this player is an admin
---@field auth boolean Whether or not this player is authed
---
---@field Serialize fun(selF: NoirPlayerServicePlayer): NoirPlayerServiceSerializedPlayer A method that serializes this player into a g_savedata appropriate format
---@field Deserialize fun(serializedPlayer: NoirPlayerServiceSerializedPlayer): NoirPlayerServicePlayer A method that deserializes the serialized player into a player object 
---@field SetAuth fun(self: NoirPlayerServicePlayer, auth: boolean) A method that sets whether or not this player is authed
---@field SetAdmin fun(self: NoirPlayerServicePlayer, admin: boolean) A method that sets whether or not this player is an admin
---@field Kick fun(self: NoirPlayerServicePlayer) A method that kicks this player
---@field Ban fun(self: NoirPlayerServicePlayer) A method that bans this player
---@field Teleport fun(self: NoirPlayerServicePlayer, pos: SWMatrix) A method that teleports this player
---@field GetPosition fun(self: NoirPlayerServicePlayer): SWMatrix A method that returns the position of this player
---@field SetCharacterData fun(self: NoirPlayerServicePlayer, hp: number, interactable: boolean, AI: boolean)
---@field Heal fun(self: NoirPlayerServicePlayer, amount: number) Heal this player by a certain amount
---@field Damage fun(self: NoirPlayerServicePlayer, amount: number) Damages this player by a certain amount
---@field GetCharacter fun(self: NoirPlayerServicePlayer): integer|nil A method that returns the character of this player
---@field Revive fun(self: NoirPlayerServicePlayer) Revive this player
---@field GetCharacterData fun(self: NoirPlayerServicePlayer): SWObjectData|nil Get this player's character data
---@field GetHealth fun(self: NoirPlayerServicePlayer): integer Get this player's health
---@field IsDowned fun(self: NoirPlayerServicePlayer): boolean Check if this player is downed (dead or incapacitated)