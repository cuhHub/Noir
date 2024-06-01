--------------------------------------------------------
-- [Noir] Example - Welcome Addon
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

---@class WelcomeService: NoirService
---@field greetingMessage string The greeting message
---@field farewellMessage string The farewell message
---
---@field SetMessages fun(self: WelcomeService, greet: string, farewell: string) A method that sets the greeting and farewell messages
---@field Greet fun(self: WelcomeService, peer_id: integer) A method that greets a player to everyone
---@field Farewell fun(self: WelcomeService, name: string) A method that sends a farewell message to everyone about a player

-- Create the service
local WelcomeService = Noir.Services:CreateService("WelcomeService") ---@type WelcomeService

-- Called when the service is initialized. This is to be used for setting up the service
function WelcomeService:ServiceInit()
    self:SetMessages("Hello!", "Goodbye!") -- default
end

-- Called when the service is started and when we can safely get other services. This is to be used for setting up things that may require event connections, etc
function WelcomeService:ServiceStart()

end

-- Set the greeting and farewell messages
function WelcomeService:SetMessages(hello, bye)
    self.greetingMessage = hello
    self.farewellMessage = bye
end

-- Greet a player
function WelcomeService:Greet(peer_id)
    local name = server.getPlayerName(peer_id)
    server.announce("Greeting", self.greetingMessage:format(name))
end

-- Farewell a player
function WelcomeService:Farewell(name)
    server.announce("Farewell", self.farewellMessage:format(name))
end