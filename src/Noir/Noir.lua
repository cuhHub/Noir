--------------------------------------------------------
-- [Noir] Noir
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

--[[
    The current version of Noir.<br>
    Follows [Semantic Versioning.](https://semver.org)
]]
Noir.Version = "1.7.3"

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
    This represents whether or not the addon was:<br>
    - Reloaded<br>
    - Started via a save being loaded<br>
    - Started via a save creation
]]
Noir.AddonReason = "AddonReload" ---@type NoirAddonReason

--[[
    Starts the framework.<br>
    This will initialize all services, then upon completion, all services will be started.<br>
    Use the `Noir.Started` event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)

    Noir:Start()
]]
function Noir:Start()
    -- Checks
    if self.IsStarting then
        self.Libraries.Logging:Error("Start", "The addon attempted to start Noir when it is in the process of starting.", true)
        return
    end

    if self.HasStarted then
        self.Libraries.Logging:Error("Start", "The addon attempted to start Noir more than once.", true)
        return
    end

    -- Function to setup everything
    ---@param startTime number
    ---@param isSaveCreate boolean
    local function setup(startTime, isSaveCreate)
        -- Wait until onTick is first called to determine if the addon was reloaded, or if a save with the addon was loaded/created
        self.Callbacks:Once("onTick", function()
            local took = server.getTimeMillisec() - startTime
            Noir.AddonReason = isSaveCreate and "SaveCreate" or (took < 1000 and "AddonReload" or "SaveLoad")

            self.IsStarting = false
            self.HasStarted = true

            -- Initialize g_savedata
            self.Bootstrapper:InitializeSavedata()

            -- Initialize services, then start them
            self.Bootstrapper:InitializeServices()
            self.Bootstrapper:StartServices()

            -- Fire event
            self.Started:Fire()

            -- Send log
            self.Libraries.Logging:Success("Start", "Noir v%s has started. Bootstrapper has initialized and started all services.\nTook: %sms | Addon Reason: %s", self.Version, took, Noir.AddonReason)

            -- Send log on addon stop
            self.Callbacks:Once("onDestroy", function()
                local addonData = server.getAddonData((server.getAddonIndex()))
                self.Libraries.Logging:Info("Stop", "%s, using Noir v%s, has stopped.", addonData.name, self.Version)
            end)
        end, true)
    end

    self.IsStarting = true

    -- Wait for onCreate, then setup
    ---@param isSaveCreate boolean
    self.Callbacks:Once("onCreate", function(isSaveCreate)
        setup(server.getTimeMillisec(), isSaveCreate)
    end, true)

    -- Send log
    self.Libraries.Logging:Info("Start", "Waiting for onCreate game event to fire before setting up Noir.")
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirAddonReason
---| "AddonReload"
---| "SaveCreate"
---| "SaveLoad"