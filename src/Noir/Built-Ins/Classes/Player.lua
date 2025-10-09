--------------------------------------------------------
-- [Noir] Classes - Player
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
    Represents a player.

    local character = player:GetCharacter() -- NoirObject

    if character then -- Can be nil if the player's character hasn't loaded
        character:SetTooltip("A Tooltip")
    end
]]
---@class NoirPlayer: NoirClass
---@field New fun(self: NoirPlayer, name: string, ID: integer, steam: string, admin: boolean, auth: boolean): NoirPlayer
---@field Name string The name of this player
---@field ID integer The ID of this player
---@field Steam string The Steam ID of this player
---@field Admin boolean Whether or not this player is an admin
---@field Auth boolean Whether or not this player is authed
---@field InGame boolean Whether or not this player is in the game. This is set to false when the player leaves
---
---@field OnCharacterLoad NoirEvent Arguments: character (NoirObject) | Fired when this player's character is loaded
Noir.Classes.Player = Noir.Class("Player")

--[[
    Initializes player class objects.
]]
---@param name string
---@param ID integer
---@param steam string
---@param admin boolean
---@param auth boolean
function Noir.Classes.Player:Init(name, ID, steam, admin, auth)
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "steam", steam, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "admin", admin, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "auth", auth, "boolean")

    self.Name = name
    self.ID = math.floor(ID)
    self.Steam = steam
    self.Admin = admin
    self.Auth = auth
    self.InGame = true

    self.OnCharacterLoad = Noir.Libraries.Events:Create()
end

--[[
    Triggers `OnCharacterLoad`.<br>
    Used internally.
]]
---@param character NoirObject
function Noir.Classes.Player:_CharacterLoad(character)
    self.OnCharacterLoad:Fire(character)
end

--[[
    Sets whether or not this player is authed.
]]
---@param auth boolean
function Noir.Classes.Player:SetAuth(auth)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Player:SetAuth()", "auth", auth, "boolean")

    -- Add/remove auth
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
function Noir.Classes.Player:SetAdmin(admin)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Player:SetAdmin()", "admin", admin, "boolean")

    -- Add/remove admin
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
function Noir.Classes.Player:Kick()
    server.kickPlayer(self.ID)
end

--[[
    Bans this player.
]]
function Noir.Classes.Player:Ban()
    server.banPlayer(self.ID)
end

--[[
    Teleports this player.
]]
---@param pos SWMatrix
function Noir.Classes.Player:Teleport(pos)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Player:Teleport()", "pos", pos, "table")

    -- Teleport the player
    server.setPlayerPos(self.ID, pos)
end

--[[
    Returns this player's position.
]]
---@return SWMatrix
function Noir.Classes.Player:GetPosition()
    local pos, success = server.getPlayerPos(self.ID)

    if not success then
        return matrix.translation(0, 0 ,0)
    end

    return pos
end

--[[
    Set the player's audio mood.
]]
---@param mood SWAudioMoodEnum
function Noir.Classes.Player:SetAudioMood(mood)
    Noir.TypeChecking:Assert("Noir.Classes.Player:SetAudioMood()", "mood", mood, "number")
    server.setAudioMood(self.ID, mood)
end

--[[
    Returns this player's character as a NoirObject.
]]
---@return NoirObject|nil
function Noir.Classes.Player:GetCharacter()
    -- Get the character
    local object_id, success = server.getPlayerCharacterID(self.ID)

    if not success then
        return
    end

    return Noir.Services.ObjectService:GetObject(object_id)
end

--[[
    Returns this player's look direction.
]]
---@return number LookX
---@return number LookY
---@return number LookZ
function Noir.Classes.Player:GetLook()
    local x, y, z, success = server.getPlayerLookDirection(self.ID)

    if not success then
        return 0, 0, 0
    end

    return x, y, z
end

--[[
    Send this player a notification.
]]
---@param title string
---@param message string
---@param notificationType SWNotificationTypeEnum
function Noir.Classes.Player:Notify(title, message, notificationType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Player:Notify()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Notify()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Notify()", "notificationType", notificationType, "number")

    -- Send notification
    server.notify(self.ID, title, message, notificationType)
end