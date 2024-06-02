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
    self.Name = name
    self.Initialized = false
    self.Started = false

    self.InitPriority = nil
    self.StartPriority = nil
end

function Noir.Services.ServiceClass:Initialize()
    -- Checks
    if self.Initialized then
        Noir.Libraries.Logging:Error(self.Name, "Attempted to initialize this service when it has already initialized.")
        return
    end

    if self.Started then
        Noir.Libraries.Logging:Error(self.Name, "Attempted to start this service when it has already started.")
        return
    end

    -- Set initialized
    self.Initialized = true

    -- Call ServiceInit
    if not self.ServiceInit then
        Noir.Libraries.Logging:Error(self.Name, "This service is missing a ServiceInit method.")
        return
    end

    self:ServiceInit()
end

function Noir.Services.ServiceClass:Start()
    -- Checks
    if self.Started then
        Noir.Libraries.Logging:Error(self.Name, "Attempted to start this service when it has already started.")
        return
    end

    if not self.Initialized then
        Noir.Libraries.Logging:Error(self.Name, "Attempted to start this service when it has not initialized yet.")
        return
    end

    -- Set started
    self.Started = true

    -- Call ServiceStart
    if not self.ServiceStart then
        Noir.Libraries.Logging:Warning(self.Name, "This service is missing a ServiceStart method. You can ignore this if your service doesn't require it.")
        return
    end

    self:ServiceStart()
end

function Noir.Services.ServiceClass:CheckSaveData()
    -- Checks
    if not g_savedata then
        Noir.Libraries.Logging:Error("Service Save", "Attempted to save data to a service when g_savedata is nil.")
        return false
    end

    if not g_savedata.Noir then
        Noir.Libraries.Logging:Error("Service Save", "Attempted to save data to a service when g_savedata.Noir is nil. Something might have gone wrong with the Noir bootstrapper.")
        return false
    end

    if not g_savedata.Noir.Services then
        Noir.Libraries.Logging:Error("Service Save", "Attempted to save data to a service when g_savedata.Noir.Services is nil. Something might have gone wrong with the Noir bootstrapper.")
        return false
    end

    -- All good!
    return true
end

function Noir.Services.ServiceClass:Save(index, data)
    -- Check g_savedata
    if not self:CheckSaveData() then
        return
    end

    -- Save
    g_savedata.Noir.Services[index] = data
end

function Noir.Services.ServiceClass:Load(index, default)
    -- Check g_savedata
    if not self:CheckSaveData() then
        return
    end

    -- Load
    return g_savedata.Noir.Services[index] or default
end

function Noir.Services.ServiceClass:Remove(index)
    -- Check g_savedata
    if not self:CheckSaveData() then
        return
    end

    -- Remove
    g_savedata.Noir.Services[index] = nil
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
    if not service.Initialized then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that hasn't initialized yet ('%s').", name)
        return
    end

    return service
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirService: NoirClass
---@field Name string
---@field Initialized boolean
---@field Started boolean
---@field InitPriority integer
---@field StartPriority integer
---
---@field Initialize fun(self: NoirService) Initialize this service.<br>Used internally. Do not use this in your code.
---@field Start fun(self: NoirService) Start this service.<br>Used internally. Do not use this in your code.
---
---@field CheckSaveData fun(self: NoirService): boolean Check if the service can save data.<br>Used internally. You can use this in your code, but there usually isn't a need.
---@field Save fun(self: NoirService, index: string, data: any) Save data that persists between reloads and in the save.
---@field Load fun(self: NoirService, index: string, default: any): any Load data that was saved.
---@field Remove fun(self: NoirService, index: string) Remove data that was saved.
---@field ServiceInit fun(self: NoirService) A method that initializes the service
---@field ServiceStart fun(self: NoirService)|nil A method that starts the service