--------------------------------------------------------
-- [Noir] Bootstrapper
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
    An internal module of Noir that is used to initialize and start services.<br>
    Do not use this in your code.
]]
Noir.Bootstrapper = {}

--[[
    Initialize all services.<br>
    This will order services by their `initPriority` and then initialize them.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:InitializeServices()
    -- Calculate order of service initialization
    local servicesToInit = Noir.Libraries.Table:Values(Noir.Services.CreatedServices) ---@type table<integer, NoirService>
    local lowestInitPriority = 0

    for _, service in pairs(servicesToInit) do
        local priority = service.initPriority ~= nil and service.initPriority or 0

        if priority >= lowestInitPriority then
            lowestInitPriority = priority
        end
    end

    for _, service in pairs(servicesToInit) do
        if not service.initPriority then
            service.initPriority = lowestInitPriority + 1
            lowestInitPriority = lowestInitPriority + 1
        end
    end

    table.sort(servicesToInit, function(serviceA, serviceB)
        return serviceA.initPriority < serviceB.initPriority
    end)

    -- Initialize services
    for _, service in pairs(servicesToInit) do
        service:Initialize()
    end
end

--[[
    Start all services.<br>
    This will order services by their `startPriority` and then start them.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:StartServices()
    -- Calculate order of service start
    local servicesToStart = Noir.Libraries.Table:Values(Noir.Services.CreatedServices) ---@type table<integer, NoirService>
    local lowestStartPriority = 0

    for _, service in pairs(servicesToStart) do
        local priority = service.startPriority ~= nil and service.startPriority or 0

        if priority >= lowestStartPriority then
            lowestStartPriority = priority
        end
    end

    for _, service in pairs(servicesToStart) do
        if not service.startPriority then
            service.startPriority = lowestStartPriority + 1
            lowestStartPriority = lowestStartPriority + 1
        end
    end

    table.sort(servicesToStart, function(serviceA, serviceB)
        return serviceA.startPriority < serviceB.startPriority
    end)

    -- Start services
    for _, service in pairs(servicesToStart) do
        service:Start()
    end
end