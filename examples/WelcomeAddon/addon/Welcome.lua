--------------------------------------------------------
-- [Noir] Example - Welcome Addon
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

-- Connect to the Noir Started event. It's important we place our code in this event
Noir.Started:Once(function()
    -- Get the WelcomeService
    local WelcomeService = Noir.Services:GetService("WelcomeService") ---@type WelcomeService

    -- Set the welcome and farewell messages
    WelcomeService:SetMessages("Hello, %s!", "Bye, %s!")

    -- Connect to the PlayerService events, and use the WelcomeService
    ---@param player NoirPlayer
    Noir.Services.PlayerService.OnJoin:Connect(function(player)
        WelcomeService:Greet(player)
    end)

    ---@param player NoirPlayer
    Noir.Services.PlayerService.OnLeave("onPlayerLeave", function(player)
        WelcomeService:Farewell(player)
    end)
end)