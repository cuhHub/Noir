--------------------------------------------------------
-- [Noir] Services - Command Service
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
    A service for easily creating commands with support for command aliases, permissions, etc.

    Noir.Services.CommandService:CreateCommand("info", {"i"}, {"Nerd"}, false, false, false, "Shows random information.", function(player, message, args, hasPermission)
        if not hasPermission then
            server.announce("Server", "Sorry, you don't have permission to use this command. Try again though.", player.ID)
            player:SetPermission("Nerd")
            return
        end

        server.announce("Info", "This addon uses Noir!")
    end)
]]
---@class NoirCommandService: NoirService
---@field Commands table<string, NoirCommand> A table of registered commands
---@field _OnCustomCommandConnection NoirConnection Represents the connection to the OnCustomCommand game callback
Noir.Services.CommandService = Noir.Services:CreateService(
    "CommandService",
    true,
    "A service that allows you to create commands.",
    "A service that allows you to create commands with support for aliases, permissions, etc.",
    {"Cuh4"}
)

function Noir.Services.CommandService:ServiceInit()
    self.Commands = {}
end

function Noir.Services.CommandService:ServiceStart()
    self._OnCustomCommandConnection = Noir.Callbacks:Connect("onCustomCommand", function(message, peer_id, _, _, commandName, ...)
        -- Get the player
        local player = Noir.Services.PlayerService:GetPlayer(peer_id)

        if not player then -- can occur because of `server.command` calls
            return
        end

        -- Remove ? prefix
        commandName = commandName:sub(2)

        -- Get the command
        local command = self:FindCommand(commandName)

        if not command then
            return
        end

        -- Trigger the command
        command:_Use(player, message, {...})
    end)
end

--[[
    Get a command by the name or alias.
]]
---@param query string
---@return NoirCommand|nil
function Noir.Services.CommandService:FindCommand(query)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:FindCommand()", "query", query, "string")

    -- Find the command
    for _, command in pairs(self:GetCommands()) do
        if command:_Matches(query) then
            return command
        end
    end
end

--[[
    Create a new command.

    Noir.Services.CommandService:CreateCommand("help", {"h"}, {"Nerd"}, false, false, false, "Example Command", function(player, message, args, hasPermission)
        if not hasPermission then
            player:Notify("Lacking Permissions", "Sorry, you don't have permission to run this command. Try again.", 3)
            player:SetPermission("Nerd")
            return
        end

        player:Notify("Help", "TODO: Add a help message", 4)
    end)
]]
---@param name string The name of the command (eg: if you provided "help", the player would need to type "?help" in chat)
---@param aliases table<integer, string> The aliases of the command
---@param requiredPermissions table<integer, string>|nil The required permissions for this command
---@param requiresAuth boolean|nil Whether or not this command requires auth
---@param requiresAdmin boolean|nil Whether or not this command requires admin
---@param capsSensitive boolean|nil Whether or not this command is case-sensitive
---@param description string|nil The description of this command
---@param callback fun(player: NoirPlayer, message: string, args: table<integer, string>, hasPermission: boolean)
---@return NoirCommand
function Noir.Services.CommandService:CreateCommand(name, aliases, requiredPermissions, requiresAuth, requiresAdmin, capsSensitive, description, callback)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "aliases", aliases, "table")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "requiredPermissions", requiredPermissions, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "requiresAuth", requiresAuth, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "requiresAdmin", requiresAdmin, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "capsSensitive", capsSensitive, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "description", description, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "callback", callback, "function")

    -- Create command
    local command = Noir.Classes.Command:New(name, aliases, requiredPermissions or {}, requiresAuth or false, requiresAdmin or false, capsSensitive or false, description or "")

    -- Connect to event
    command.OnUse:Connect(callback)

    -- Save and return
    self.Commands[name] = command
    return command
end

--[[
    Get a command by the name.
]]
---@param name string
---@return NoirCommand|nil
function Noir.Services.CommandService:GetCommand(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:GetCommand()", "name", name, "string")

    -- Return the command
    return self.Commands[name]
end

--[[
    Remove a command.
]]
---@param name string
function Noir.Services.CommandService:RemoveCommand(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:RemoveCommand()", "name", name, "string")

    -- Remove the command
    self.Commands[name] = nil
end

--[[
    Returns all commands.
]]
---@return table<string, NoirCommand>
function Noir.Services.CommandService:GetCommands()
    return self.Commands
end