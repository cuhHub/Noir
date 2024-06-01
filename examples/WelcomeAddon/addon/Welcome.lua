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

-- Connect to the Noir Started event. It's important we place our code in this event
Noir.Started:Once(function()
    -- Get the Welcome Service
    local WelcomeService = Noir.Services:GetService("WelcomeService") ---@type WelcomeService

    -- Set the welcome and farewell messages
    WelcomeService:SetMessages("Hello, %s!", "Bye, %s!")

    -- Connect to the onPlayerJoin and onPlayerLeave events, and use the Welcome Service
    Noir.Callbacks:Connect("onPlayerJoin", function(_, _, peer_id)
        WelcomeService:Greet(peer_id)
    end)

    Noir.Callbacks:Connect("onPlayerLeave", function(_, name)
        WelcomeService:Farewell(name)
    end)
end)