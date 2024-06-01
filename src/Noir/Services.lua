--------------------------------------------------------
-- [Noir] Services
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
    Do not modify this table directly. Please use `Noir.Services:GetService(name)` instead.
]]
Noir.Services.CreatedServices = {} ---@type table<string, NoirService>

--[[
    A class that represents a service.<br>
    Do not use this in your code.
]]
Noir.Services.ServiceClass = Noir.Libraries.Class:Create("NoirService") ---@type NoirService

function Noir.Services.ServiceClass:Init(name)
    -- Create attributes
    self.name = name
    self.initialized = false
    self.started = false

    self.initPriority = nil
    self.startPriority = nil
end

function Noir.Services.ServiceClass:Initialize()
    -- Checks
    if self.initialized then
        Noir.Libraries.Logging:Error(self.name, "Attempted to initialize this service when it has already initialized.")
        return
    end

    if self.started then
        Noir.Libraries.Logging:Error(self.name, "Attempted to start this service when it has already started.")
        return
    end

    -- Set initialized
    self.initialized = true

    -- Call ServiceInit
    if not self.ServiceInit then
        Noir.Libraries.Logging:Error(self.name, "This service is missing a ServiceInit method.")
        return
    end

    self:ServiceInit()
end

function Noir.Services.ServiceClass:Start()
    -- Checks
    if self.started then
        Noir.Libraries.Logging:Error(self.name, "Attempted to start this service when it has already started.")
        return
    end

    if not self.initialized then
        Noir.Libraries.Logging:Error(self.name, "Attempted to start this service when it has not initialized yet.")
        return
    end

    -- Set started
    self.started = true

    -- Call ServiceStart
    if not self.ServiceStart then
        Noir.Libraries.Logging:Warning(self.name, "This service is missing a ServiceStart method. You can ignore this if your service doesn't require it.")
        return
    end

    self:ServiceStart()
end

--[[
    Create a service.<br>
    This service will be initialized and started after `Noir:Start()` is called.

    local service = Noir.Services:CreateService("MyService")
    service.initPriority = 1 -- Initialize before any other services

    function service:ServiceInit()
        Noir.Services:GetService("MyOtherService") -- This will error since the other service hasn't started yet
        self.saveSomething = "something"
    end

    function service:ServiceStart()
        print(self.saveSomething)
    end
]]
---@param name string
---@return NoirService|nil
function Noir.Services:CreateService(name)
    -- Check if service already exists
    if self.CreatedServices[name] then
        Noir.Libraries.Logging:Error("Service Creation", "Attempted to create a service that already exists.")
        return
    end

    -- Create service
    local service = self.ServiceClass:New(name) ---@type NoirService

    -- Register service internally
    self.CreatedServices[name] = service

    -- Return service
    return service
end

--[[
    Retrieve a service by its name.<br>
    This will error if the service hasn't started yet.

    local service = Noir.Services:GetService("MyService")
    print(service.name) -- "MyService"
]]
---@param name string
---@return NoirService|nil
function Noir.Services:GetService(name)
    -- Get service
    local service = self.CreatedServices[name]

    -- Check if service exists
    if not service then
        Noir.Libraries.Logging:Error(name, "Attempted to retrieve a service that doesn't exist ('%s').", name)
        return
    end

    -- Check if service has been initialized
    if not service.initialized then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that hasn't initialized yet ('%s').", name)
        return
    end

    return service
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirService: NoirClass
---@field name string
---@field initialized boolean
---@field started boolean
---@field initPriority integer
---@field startPriority integer
---
---@field Initialize fun(self: NoirService) Initialize this service.<br>Used internally. Do not use this in your code.
---@field Start fun(self: NoirService) Start this service.<br>Used internally. Do not use this in your code.
---@field ServiceInit fun(self: NoirService) A method that initializes the service
---@field ServiceStart fun(self: NoirService)|nil A method that starts the service