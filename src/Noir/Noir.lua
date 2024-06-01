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
    The version of Noir.
    Version history can be found here: https://github.com/cuhHub/NoirFramework/blob/master/CHANGELOG.md
]]

--[[
    This event is called when the framework is started.<br>
    Use this event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)
]]
Noir.Started = Noir.Libraries.Events:Create()

--[[
    This represents whether or not the framework has started.
]]
Noir.HasStarted = false

--[[
    This represents whether or not the framework is starting.
]]
Noir.IsStarting = false

--[[
    Starts the framework.<br>
    This will initalize all services, then upon completion, all services will be started.<br>
    Use the `Noir.Started` event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)

    Noir:Start()
]]
function Noir:Start()
    -- Checks
    if self.IsStarting then
        -- TODO: error
        return
    end

    if self.HasStarted then
        -- TODO: error
        return
    end

    -- Function to setup everything
    local function setup()
        -- Set started
        self.IsStarting = false
        self.HasStarted = true

        -- Initialize services, then start them
        self.Bootstrapper:InitializeServices()
        self.Bootstrapper:StartServices()

        -- Fire event
        self.Started:Fire()
    end

    -- Wait for onCreate
    local onCreate = self.Callbacks:Get("onCreate")

    if not onCreate then -- TODO: add info log
        self.Callbacks:Once("onCreate", setup) -- setup things when onCreate fires
        return
    end

    if onCreate.hasFiredOnce then -- TODO: add info log
        setup() -- onCreate has fired, so setup now
        return
    end
    -- TODO: add info log
    self.Callbacks:Once("onCreate", setup) -- setup things when onCreate fires
end