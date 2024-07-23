--------------------------------------------------------
-- [Noir] Example - Welcome Addon
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

-- Create the service
---@class WelcomeService: NoirService
---@field greetingMessage string The greeting message
---@field farewellMessage string The farewell message
local WelcomeService = Noir.Services:CreateService("WelcomeService")

-- Called when the service is initialized. This is to be used for setting up the service
function WelcomeService:ServiceInit()
    self:SetMessages("Hello!", "Goodbye!") -- default
end

-- Called when the service is started and when we can safely get other services. This is to be used for setting up things that may require event connections, etc
function WelcomeService:ServiceStart()

end

-- Set the greeting and farewell messages
---@param hello string
---@param bye string
function WelcomeService:SetMessages(hello, bye)
    self.greetingMessage = hello
    self.farewellMessage = bye
end

-- Greet a player
---@param player NoirPlayer
function WelcomeService:Greet(player)
    server.announce("Greeting", self.greetingMessage:format(player.Name))
end

-- Farewell a player
---@param player NoirPlayer
function WelcomeService:Farewell(player)
    server.announce("Farewell", self.farewellMessage:format(player.Name))
end