--------------------------------------------------------
-- [Noir] Bootstrapper
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
    An internal module of Noir that is used to initialize and start services.<br>
    Do not use this in your code.
]]
Noir.Bootstrapper = {}

--[[
    Set up g_savedata.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:InitializeSavedata()
    -- Setup g_savedata
    g_savedata.Noir = g_savedata.Noir or {}
    Noir.Libraries.Logging:Info("Bootstrapper", "'Noir' has been defined in g_savedata.")

    g_savedata.Noir.Services = g_savedata.Noir.Services or {}
    Noir.Libraries.Logging:Info("Bootstrapper", "'Services' has been defined in Noir savedata.")
end

--[[
    Initialize all services.<br>
    This will order services by their `InitPriority` and then initialize them.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:InitializeServices()
    -- Calculate order of service initialization
    local servicesToInit = Noir.Libraries.Table:Values(Noir.Services.CreatedServices)
    local lowestInitPriority = 0

    for _, service in pairs(servicesToInit) do
        local priority = service.InitPriority ~= nil and service.InitPriority or 0

        if priority >= lowestInitPriority then
            lowestInitPriority = priority
        end
    end

    for _, service in pairs(servicesToInit) do
        if not service.InitPriority then
            service.InitPriority = lowestInitPriority + 1
            lowestInitPriority = lowestInitPriority + 1
        end
    end

    ---@param serviceA NoirService
    ---@param serviceB NoirService
    table.sort(servicesToInit, function(serviceA, serviceB)
        return serviceA.InitPriority < serviceB.InitPriority
    end)

    -- Initialize services
    for _, service in pairs(servicesToInit) do
        Noir.Libraries.Logging:Info("Bootstrapper", "Initializing %s of priority %d.", Noir.Services:FormatService(service), service.InitPriority)
        service:_Initialize()
    end
end

--[[
    Start all services.<br>
    This will order services by their `StartPriority` and then start them.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:StartServices()
    -- Calculate order of service start
    local servicesToStart = Noir.Libraries.Table:Values(Noir.Services.CreatedServices)
    local lowestStartPriority = 0

    for _, service in pairs(servicesToStart) do
        local priority = service.StartPriority ~= nil and service.StartPriority or 0

        if priority >= lowestStartPriority then
            lowestStartPriority = priority
        end
    end

    for _, service in pairs(servicesToStart) do
        if not service.StartPriority then
            service.StartPriority = lowestStartPriority + 1
            lowestStartPriority = lowestStartPriority + 1
        end
    end

    ---@param serviceA NoirService
    ---@param serviceB NoirService
    table.sort(servicesToStart, function(serviceA, serviceB)
        return serviceA.StartPriority < serviceB.StartPriority
    end)

    -- Start services
    for _, service in pairs(servicesToStart) do
        Noir.Libraries.Logging:Info("Bootstrapper", "Starting %s of priority %d.", Noir.Services:FormatService(service), service.StartPriority)
        service:_Start()
    end
end

--[[
    Determines whether or not the server this addon is being ran in is a dedicated server.<br>
    This evaluation is then used to set `Noir.IsDedicatedServer`.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:SetIsDedicatedServer()
    local host = server.getPlayers()[1]
    Noir.IsDedicatedServer = host and (host.steam_id == 0 and host.object_id == nil)
end