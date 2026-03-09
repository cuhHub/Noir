--------------------------------------------------------
-- [Noir] Noir
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
    The current version of Noir.<br>
    Follows [Semantic Versioning.](https://semver.org)
]]
Noir.Version = "{VERSION_MAJOR}.{VERSION_MINOR}.{VERSION_PATCH}"

--[[
    Returns the MAJOR, MINOR, and PATCH of the current Noir version.

    major, minor, patch = Noir:GetVersion()
]]
---@return string major The MAJOR part of the version
---@return string minor The MINOR part of the version
---@return string patch The PATCH part of the version
function Noir:GetVersion()
    local major, minor, patch = table.unpack(Noir.Libraries.String:Split(self.Version, "."))
    return major, minor, patch
end

--[[
    This event is called when the framework is started.<br>
    Use this event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)
]]
Noir.Started = Noir.Libraries.Events:Create()

--[[
    The name of this addon.
]]
Noir.AddonName = ""

--[[
    This represents whether or not the framework has started.
]]
Noir.HasStarted = false

--[[
    This represents whether or not the framework is starting.
]]
Noir.IsStarting = false

--[[
    This represents whether or not the addon is being ran in a dedicated server.
]]
Noir.IsDedicatedServer = false

--[[
    This represents whether or not the addon was:<br>
    - Reloaded<br>
    - Started via a save load<br>
    - Started via a save creation
]]
Noir.AddonReason = Noir.Enums.AddonReason.ADDON_RELOAD ---@type NoirAddonReason

--[[
    The main logger for Noir.<br>
    This should only be used by Noir. It is recommended to create your own logger for your addon.
]]
Noir.Logger = Noir.Libraries.Logging:CreateLogger("Noir")
Noir.Logger:AttachMiddleware(Noir.Classes.DebugLogLoggerMiddleware:New())

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
        self.Debugging:RaiseError("Noir:Start()", "The addon attempted to start Noir when it is in the process of starting.")
        return
    end

    if self.HasStarted then
        self.Debugging:RaiseError("Noir:Start()", "The addon attempted to start Noir more than once.")
        return
    end

    -- Function to setup everything
    ---@param startTime number
    ---@param isSaveCreate boolean
    local function setup(startTime, isSaveCreate)
        -- Wait until onTick is first called to determine if the addon was reloaded, or if a save with the addon was loaded/created
        self.Callbacks:Once("onTick", function()
            -- Determine the addon reason
            local took = server.getTimeMillisec() - startTime
            self.AddonReason = isSaveCreate and Noir.Enums.AddonReason.SAVE_CREATE or (took < 1000 and Noir.Enums.AddonReason.ADDON_RELOAD or Noir.Enums.AddonReason.SAVE_LOAD)

            self.IsStarting = false
            self.HasStarted = true

            -- Set Noir.x
            self.Bootstrapper:SetIsDedicatedServer()
            self.Bootstrapper:SetAddonName()

            -- Initialize services
            self.Bootstrapper:InitializeServices()

            -- Fire event
            self.Started:Fire()

            -- Start services
            self.Bootstrapper:StartServices()

            -- Send log
            self.Logger:Success("Noir v%s has started. Bootstrapper has initialized and started all services.\nTook: %sms | Addon Reason: %s", self.Version, took, Noir.AddonReason)

            -- Send log on addon stop
            self.Callbacks:Once("onDestroy", function()
                self.Logger:Warning("%s, using Noir v%s, has stopped.", self.AddonName, Noir.Version)
            end)
        end, true)
    end

    -- Wait for onCreate, then setup
    self.Callbacks:Once("onCreate", function(isSaveCreate)
        setup(server.getTimeMillisec(), isSaveCreate)
    end, true)

    self.IsStarting = true
end

-- Prevent user-created methods in services from being called before the service has been initialized
Noir.Bootstrapper:WrapServiceMethodsForAllServices()