--------------------------------------------------------
-- [Noir] Services
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
    A module of Noir that allows you to create organized services.<br>
    These services can be used to hold methods that are all designed for a specific purpose.

    TODO: service example
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
    -- create attributes
    self.name = name
    self.initialized = false
    self.started = false

    self.initPriority = nil
    self.startPriority = nil
end

function Noir.Services.ServiceClass:Initialize()
    if self.initialized then
        -- TODO: error
        return
    end

    if self.started then
        -- TODO: error
        return
    end

    -- set initialized
    self.initialized = true

    -- call ServiceInit
    if not self.ServiceInit then
        -- TODO: warning
        return
    end

    self:ServiceInit()
end

function Noir.Services.ServiceClass:Start()
    if self.started then
        -- TODO: error
        return
    end

    if not self.initialized then
        -- TODO: error
        return
    end

    -- set started
    self.started = true

    -- call ServiceStart
    if not self.ServiceStart then
        -- TODO: warning
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
---@return NoirService
function Noir.Services:CreateService(name)
    -- Check if service already exists
    if self.CreatedServices[name] then
        -- TODO: error
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
---@return NoirService
function Noir.Services:GetService(name)
    local service = self.CreatedServices[name]

    if not service.started then
        -- TODO: error
        return
    end

    return service
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirService: NoirLib_Class
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