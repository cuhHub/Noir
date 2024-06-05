--------------------------------------------------------
-- [Noir] Classes - Player
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
    A class that represents a player for the built-in PlayerService.
]]
---@class NoirPlayer: NoirClass
---@field Name string The name of this player
---@field ID integer The ID of this player
---@field Steam string The Steam ID of this player
---@field Admin boolean Whether or not this player is an admin
---@field Auth boolean Whether or not this player is authed
Noir.Classes.PlayerClass = Noir.Class("NoirPlayer")

--[[
    Initializes player class objects.
]]
---@param name string
---@param ID integer
---@param steam string
---@param admin boolean
---@param auth boolean
function Noir.Classes.PlayerClass:Init(name, ID, steam, admin, auth)
    self.Name = name
    self.ID = ID
    self.Steam = steam
    self.Admin = admin
    self.Auth = auth
end

--[[
    Serializes this player for g_savedata.
]]
---@deprecated
function Noir.Classes.PlayerClass:_Serialize()
    return {
        Name = self.Name,
        ID = self.ID,
        Steam = self.Steam,
        Admin = self.Admin,
        Auth = self.Auth
    }
end

--[[
    Deserializes a player from g_savedata into a player class object.
]]
---@deprecated
---@param serializedPlayer NoirSerializedPlayer
---@return NoirPlayer
function Noir.Classes.PlayerClass._Deserialize(serializedPlayer)
    local player = Noir.Classes.PlayerClass:New( ---@type NoirPlayer
        serializedPlayer.Name,
        serializedPlayer.ID,
        serializedPlayer.Steam,
        serializedPlayer.Admin,
        serializedPlayer.Auth
    )

    return player
end

--[[
    Sets whether or not this player is authed.
]]
---@param auth boolean
function Noir.Classes.PlayerClass:SetAuth(auth)
    if auth then
        server.addAuth(self.ID)
    else
        server.removeAuth(self.ID)
    end

    self.Auth = auth
end

--[[
    Sets whether or not this player is an admin.
]]
---@param admin boolean
function Noir.Classes.PlayerClass:SetAdmin(admin)
    if admin then
        server.addAdmin(self.ID)
    else
        server.removeAdmin(self.ID)
    end

    self.Admin = admin
end

--[[
    Kicks this player.
]]
function Noir.Classes.PlayerClass:Kick()
    server.kickPlayer(self.ID)
end

--[[
    Bans this player.
]]
function Noir.Classes.PlayerClass:Ban()
    server.banPlayer(self.ID)
end

--[[
    Teleports this player.
]]
function Noir.Classes.PlayerClass:Teleport(pos)
    server.setPlayerPos(self.ID, pos)
end

--[[
    Returns this player's position.
]]
function Noir.Classes.PlayerClass:GetPosition()
    return (server.getPlayerPos(self.ID)) or matrix.translation(0, 0, 0)
end

--[[
    Sets the character data for this player.
]]
---@param health number
---@param interactable boolean
---@param AI boolean
function Noir.Classes.PlayerClass:SetCharacterData(health, interactable, AI)
    -- Get the character
    local character = self:GetCharacter()

    if not character then
        Noir.Libraries.Logging:Error("PlayerService", ":SetCharacterData() failed for player %s (%d, %s) due to character being nil", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Set the data
    server.setCharacterData(character, health, interactable, AI)
end

--[[
    Heals this player by a certain amount.
]]
---@param amount number
function Noir.Classes.PlayerClass:Heal(amount)
    -- Get health
    local health = self:GetHealth()

    -- Prevent soft-lock
    if health <= 0 and amount > 0 then
        self:Revive()
    end

    -- Heal
    self:SetCharacterData(health + amount, false, false)
end

--[[
    Damages this player by a certain amount.
]]
---@param amount number
function Noir.Classes.PlayerClass:Damage(amount)
    -- Get health
    local health = self:GetHealth()

    -- Damage
    self:SetCharacterData(health - amount, false, false)
end

--[[
    Returns this player's character object ID.
]]
---@return integer|nil
function Noir.Classes.PlayerClass:GetCharacter()
    -- Get the character
    local character = server.getPlayerCharacterID(self.ID)

    if not character then
        Noir.Libraries.Logging:Error("PlayerService", ":GetCharacter() failed for player %s (%d, %s)", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Return
    return character
end

--[[
    Revives this player.
]]
function Noir.Classes.PlayerClass:Revive()
    -- Get the character
    local character = self:GetCharacter()

    if not character then
        Noir.Libraries.Logging:Error("PlayerService", ":Revive() failed for player %s (%d, %s) due to character being nil", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Revive the character
    server.reviveCharacter(character)
end

--[[
    Returns this player's character data.
]]
---@return SWObjectData|nil
function Noir.Classes.PlayerClass:GetCharacterData()
    -- Get the character
    local character = self:GetCharacter()

    if not character then
        Noir.Libraries.Logging:Error("PlayerService", ":GetCharacterData() failed for player %s (%d, %s) due to character being nil", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Get the character data
    local data = server.getCharacterData(character)

    if not data then
        Noir.Libraries.Logging:Error("PlayerService", ":GetCharacterData() failed for player %s (%d, %s). Data is nil", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Return
    return data
end

--[[
    Returns this player's health.
]]
---@return number
function Noir.Classes.PlayerClass:GetHealth()
    -- Get character data
    local data = self:GetCharacterData()

    if not data then
        Noir.Libraries.Logging:Error("PlayerService", ":GetHealth() failed for player %s (%d, %s) due to data being nil. Returning 100 instead", false, self.Name, self.ID, self.Steam)
        return 100
    end

    -- Return
    return data.hp
end

--[[
    Returns whether or not this player is downed.
]]
---@return boolean
function Noir.Classes.PlayerClass:IsDowned()
    -- Get character data
    local data = self:GetCharacterData()

    if not data then
        Noir.Libraries.Logging:Error("PlayerService", ":IsDowned() failed for player %s (%d, %s) due to data being nil. Returning false instead", false, self.Name, self.ID, self.Steam)
        return false
    end

    -- Return
    return data.dead or data.incapacitated or data.hp <= 0
end

--[[
    Returns this player's look direction.
]]
---@return number LookX
---@return number LookY
---@return number LookZ
function Noir.Classes.PlayerClass:GetLook()
    local x, y, z, success = server.getPlayerLookDirection(self.ID)

    if not success then
        return 0, 0, 0
    end

    return x, y, z
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a player class that has been serialized.
]]
---@class NoirSerializedPlayer
---@field Name string The name of the player
---@field ID integer The peer ID of the player
---@field Steam string The Steam ID of the player
---@field Admin boolean Whether or not the player is an admin
---@field Auth boolean Whether or not the player is authed