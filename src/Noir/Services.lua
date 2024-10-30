--------------------------------------------------------
-- [Noir] Services
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

--[[
    A module of Noir that allows you to create organized services.<br>
    These services can be used to hold methods that are all designed for a specific purpose.

    local service = Noir.Services:GetService("MyService")
    service.initPriority = 1 -- Initialize before any other services

    function service:ServiceInit()
        -- Do something
    end

    function service:ServiceStart()
        -- Do something
    end
]]
Noir.Services = {}

--[[
    A table containing created services.<br>
    You probably do not need to modify or access this table directly. Please use `Noir.Services:GetService(name)` instead.
]]
Noir.Services.CreatedServices = {} ---@type table<string, NoirService>

--[[
    Create a service.<br>
    This service will be initialized and started after `Noir:Start()` is called.

    local service = Noir.Services:CreateService("MyService")
    service.initPriority = 1 -- Initialize before any other services

    function service:ServiceInit()
        Noir.Services:GetService("MyOtherService") -- This will likely error if the other service hasn't initialized yet. Use :GetService() in :ServiceStart() always!
        self.saveSomething = "something"
    end

    function service:ServiceStart()
        print(self.saveSomething)
    end
]]
---@param name string
---@param isBuiltIn boolean|nil
---@param shortDescription string|nil
---@param longDescription string|nil
---@param authors table<integer, string>|nil
---@return NoirService
function Noir.Services:CreateService(name, isBuiltIn, shortDescription, longDescription, authors)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "isBuiltIn", isBuiltIn, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "shortDescription", shortDescription, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "longDescription", longDescription, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "authors", authors, "table", "nil")

    -- Check if service already exists
    if self.CreatedServices[name] then
        Noir.Libraries.Logging:Error("Service Creation", "Attempted to create a service that already exists. The already existing service has been returned instead.", false)
        return self.CreatedServices[name]
    end

    -- Create service
    local service = Noir.Classes.Service:New(name, isBuiltIn or false, shortDescription or "N/A", longDescription or "N/A", authors or {})

    -- Register service internally
    self.CreatedServices[name] = service

    -- Return service
    return service
end

--[[
    Retrieve a service by its name.<br>
    This will error if the service hasn't initialized yet.

    local service = Noir.Services:GetService("MyService")
    print(service.name) -- "MyService"
]]
---@param name string
---@return NoirService|nil
function Noir.Services:GetService(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:GetService()", "name", name, "string")

    -- Get service
    local service = self.CreatedServices[name]

    -- Check if service exists
    if not service then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that doesn't exist ('%s').", true, name)
        return
    end

    -- Check if service has been initialized
    if not service.Initialized then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that hasn't initialized yet ('%s').", false, service.Name)
        return
    end

    return service
end

--[[
    Remove a service.
]]
---@param name string
function Noir.Services:RemoveService(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:RemoveService()", "name", name, "string")

    -- Check if service exists
    if not self.CreatedServices[name] then
        Noir.Libraries.Logging:Error("Service Removal", "Attempted to remove a service that doesn't exist ('%s').", true, name)
        return
    end

    -- Remove service
    self.CreatedServices[name] = nil
end

--[[
    Format a service into a string.<br>
    Returns the service name as well as the author(s) if any.
]]
---@param service NoirService
---@return string
function Noir.Services:FormatService(service)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:FormatService()", "service", service, Noir.Classes.Service)

    -- Format service
    return ("'%s'%s%s"):format(service.Name, #service.Authors >= 1 and " by "..table.concat(service.Authors, ", ") or "", service.IsBuiltIn and " (Built-In)" or "")
end

--[[
    Returns all built-in Noir services.
]]
---@return table<string, NoirService>
function Noir.Services:GetBuiltInServices()
    local services = {}

    for index, service in pairs(self.CreatedServices) do
        if service.IsBuiltIn then
            services[index] = service
        end
    end

    return services
end

--[[
    Removes built-in services from Noir. This may give a very slight performance increase.<br>
    **Use before calling Noir:Start().**
]]
---@param exceptions table<integer, string> A table containing exact names of services to not remove
function Noir.Services:RemoveBuiltInServices(exceptions)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:RemoveBuiltInServices()", "exceptions", exceptions, "table")

    -- Remove built-in services
    for _, service in pairs(self:GetBuiltInServices()) do
        if Noir.Libraries.Table:Find(exceptions, service.Name) then
            goto continue
        end

        self:RemoveService(service.Name)

        ::continue::
    end
end