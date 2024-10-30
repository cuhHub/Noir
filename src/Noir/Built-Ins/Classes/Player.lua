--------------------------------------------------------
-- [Noir] Classes - Player
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
    Represents a player.

    local character = player:GetCharacter() -- NoirObject
    character:SetTooltip("A Tooltip")

    player:SetPermission("Awesome")
    player:HasPermission("Awesome") -- true
]]
---@class NoirPlayer: NoirClass
---@field New fun(self: NoirPlayer, name: string, ID: integer, steam: string, admin: boolean, auth: boolean, permissions: table<string, boolean>): NoirPlayer
---@field Name string The name of this player
---@field ID integer The ID of this player
---@field Steam string The Steam ID of this player
---@field Admin boolean Whether or not this player is an admin
---@field Auth boolean Whether or not this player is authed
---@field Permissions table<string, boolean> The permissions this player has
---@field InGame boolean Whether or not this player is in the game. This is set to false when the player leaves
Noir.Classes.Player = Noir.Class("Player")

--[[
    Initializes player class objects.
]]
---@param name string
---@param ID integer
---@param steam string
---@param admin boolean
---@param auth boolean
---@param permissions table<string, boolean>
function Noir.Classes.Player:Init(name, ID, steam, admin, auth, permissions)
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "steam", steam, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "admin", admin, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "auth", auth, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Player:Init()", "permissions", permissions, "table")

    self.Name = name
    self.ID = math.floor(ID)
    self.Steam = steam
    self.Admin = admin
    self.Auth = auth
    self.Permissions = permissions
    self.InGame = true
end

--[[
    Give this player a permission.
]]
---@param permission string
function Noir.Classes.Player:SetPermission(permission)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Player:SetPermission()", "permission", permission, "string")

    -- Set permission
    self.Permissions[permission] = true

    -- Save changes
    Noir.Services.PlayerService:_SaveProperty(self, "Permissions")
end

--[[
    Returns whether or not this player has a permission.
]]
---@param permission string
---@return boolean
function Noir.Classes.Player:HasPermission(permission)
    Noir.TypeChecking:Assert("Noir.Classes.Player:HasPermission()", "permission", permission, "string")
    return self.Permissions[permission] ~= nil
end

--[[
    Remove a permission from this player.
]]
---@param permission string
function Noir.Classes.Player:RemovePermission(permission)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Player:RemovePermission()", "permission", permission, "string")

    -- Remove permission
    self.Permissions[permission] = nil

    -- Save changes
    Noir.Services.PlayerService:_SaveProperty(self, "Permissions")
end

--[[
    Returns a table containing the player's permissions.
]]
---@return table<integer, string>
function Noir.Classes.Player:GetPermissions()
    return Noir.Libraries.Table:Keys(self.Permissions)
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
    local character = server.getPlayerCharacterID(self.ID)

    if not character then
        Noir.Libraries.Logging:Error("Player", ":GetCharacter() failed for player %s (%d, %s)", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Get or create object for character
    local object = Noir.Services.ObjectService:GetObject(character)

    if not object then
        Noir.Libraries.Logging:Error("Player", ":GetCharacter() failed for player %s (%d, %s) due to object being nil", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Return
    return object
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