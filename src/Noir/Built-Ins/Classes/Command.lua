--------------------------------------------------------
-- [Noir] Classes - Command
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2026 Cuh4

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
    Represents a command trigger callback.
]]
---@alias NoirCommandCallback fun(context: NoirCommandContext)

--[[
    Represents a command.
]]
---@class NoirCommand: NoirClass
---@field New fun(self: NoirCommand, name: string, aliases: table<integer, string>, requiresAuth: boolean, requiresAdmin: boolean, capsSensitive: boolean, description: string): NoirCommand
---@field Name string The name of this command
---@field Aliases table<integer, string> The aliases of this command
---@field RequiresAuth boolean Whether or not this command requires auth
---@field RequiresAdmin boolean Whether or not this command requires admin
---@field CapsSensitive boolean Whether or not this command is case-sensitive
---@field Description string The description of this command
---@field OnUse NoirEvent Arguments: context (NoirCommandContext) | Fired when this command is used
Noir.Classes.Command = Noir.Class("Command")

--[[
    Initializes command class objects.
]]
---@param name string
---@param aliases table<integer, string>
---@param requiresAuth boolean
---@param requiresAdmin boolean
---@param capsSensitive boolean
---@param description string
function Noir.Classes.Command:Init(name, aliases, requiresAuth, requiresAdmin, capsSensitive, description)
    Noir.TypeChecking:Assert("Noir.Classes.Command:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Command:Init()", "aliases", aliases, "table")
    Noir.TypeChecking:Assert("Noir.Classes.Command:Init()", "requiresAuth", requiresAuth, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Command:Init()", "requiresAdmin", requiresAdmin, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Command:Init()", "capsSensitive", capsSensitive, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Command:Init()", "description", description, "string")

    self.Name = name
    self.Aliases = aliases
    self.RequiresAuth = requiresAuth
    self.RequiresAdmin = requiresAdmin
    self.CapsSensitive = capsSensitive
    self.Description = description

    self.OnUse = Noir.Libraries.Events:Create()
end

--[[
    Trigger this command.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@param message string
---@param args table
function Noir.Classes.Command:_Use(player, message, args)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Command:_Use()", "player", player, Noir.Classes.Player)
    Noir.TypeChecking:Assert("Noir.Classes.Command:_Use()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Command:_Use()", "args", args, "table")

    -- Fire event
    self.OnUse:Fire(Noir.Classes.CommandContext:New(
        player,
        args,
        message,
        self:CanUse(player)
    ))
end

--[[
    Returns whether or not the string matches this command.<br>
    Used internally. Do not use in your code.
]]
---@param query string
---@return boolean
function Noir.Classes.Command:_Matches(query)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Command:_Matches()", "query", query, "string")

    -- Check if the string matches this command's name/aliases
    if not self.CapsSensitive then
        if self.Name:lower() == query:lower() then
            return true
        end

        for _, alias in ipairs(self.Aliases) do
            if alias:lower() == query:lower() then
                return true
            end
        end

        return false
    else
        if self.Name == query then
            return true
        end

        for _, alias in ipairs(self.Aliases) do
            if alias == query then
                return true
            end
        end

        return false
    end
end

--[[
    Returns whether or not the player can use this command.
]]
---@param player NoirPlayer
---@return boolean
function Noir.Classes.Command:CanUse(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Command:CanUse()", "player", player, Noir.Classes.Player)

    -- Check if the player can use this command via auth
    if self.RequiresAuth and not player.Auth then
        return false
    end

    -- Check if the player can use this command via admin
    if self.RequiresAdmin and not player.Admin then
        return false
    end

    -- Woohoo!
    return true
end