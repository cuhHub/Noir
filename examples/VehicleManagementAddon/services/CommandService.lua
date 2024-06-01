--------------------------------------------------------
-- [Noir] Example - Vehicle Management Addon
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

---@class CommandService: NoirService
---@field commands table<string, NoirEvent>
---
---@field CreateCommand fun(self: CommandService, command: string, callback: fun(peer_id: integer, args: table<integer, string>)) Creates a command

-- Create the service
local CommandService = Noir.Services:CreateService("CommandService") ---@type CommandService

-- Called when the service is initialized. This is to be used for setting up the service
function CommandService:ServiceInit()
    self.commands = {}
end

-- Called when the service is started and when we can safely get other services. This is to be used for setting up things that may require event connections, etc
function CommandService:ServiceStart()
    -- Listen for command callback
    Noir.Callbacks:Connect("onCustomCommand", function(_, peer_id, _, _, command, ...)
        if not self.commands[command] then
            Notifications:SendWarningNotification("Commands", "Unrecognized command", peer_id)
            return
        end

        self.commands[command]:Fire(peer_id, {...})
    end)
end

-- Create a command
function CommandService:CreateCommand(command, callback)
    -- Validate
    command = command:lower()

    -- If the command event exists, connect to it
    if self.commands[command] then
        self.commands[command]:Connect(callback)
        return
    end

    -- Create the event for the command
    self.commands[command] = Noir.Libraries.Events:Create()

    -- Re-execute this function to connect to command event
    self:CreateCommand(command, callback)
end