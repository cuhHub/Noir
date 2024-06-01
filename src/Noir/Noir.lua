--------------------------------------------------------
-- [Noir] Noir
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/NoirFramework

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
    This event is called when the framework is started.<br>
    Use this event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)
]]
Noir.Started = Noir.Libraries.Events:Create()

--[[
    Starts the framework.<br>
    This will initalize all services, then upon completion, all services will be started.
    Use the `Noir.Started` event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)

    Noir:Start()
]]
function Noir:Start()
    if self.started then
        -- TODO: error
        return
    end

    -- TODO: bootstrapper
end