--------------------------------------------------------
-- [Noir] Classes - Command Context
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
    Represents the context for a command callback.
]]
---@class NoirCommandContext: NoirClass
---@field New fun(self: NoirCommandContext, player: NoirPlayer, args: table<integer, string>, message: string, hasPermission: boolean, command: NoirCommand): NoirCommandContext
---@field Player NoirPlayer The player who triggered the command
---@field Args table<integer, string> The arguments of the command
---@field Message string The full message the player provided
---@field HasPermission boolean Whether the player has permission to run this command
---@field Command NoirCommand The command that was used
Noir.Classes.CommandContext = Noir.Class("CommandContext")

--[[
    Initializes class objects from this class.
]]
---@param player NoirPlayer
---@param args table<integer, string>
---@param message string
---@param hasPermission boolean
---@param command NoirCommand
function Noir.Classes.CommandContext:Init(player, args, message, hasPermission, command)
    Noir.TypeChecking:Assert("Noir.Classes.CommandContext:Init()", "player", player, Noir.Classes.Player)
    Noir.TypeChecking:Assert("Noir.Classes.CommandContext:Init()", "args", args, "table")
    Noir.TypeChecking:Assert("Noir.Classes.CommandContext:Init()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Classes.CommandContext:Init()", "hasPermission", hasPermission, "boolean")

    self.Player = player
    self.Args = args
    self.Message = message
    self.HasPermission = hasPermission
    self.Command = command
end