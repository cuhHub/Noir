--------------------------------------------------------
-- [Noir] Classes - Service
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
    Represents a Noir service.
]]
---@class NoirService: NoirClass
---@field New fun(self: NoirService, name: string): NoirService
---@field Name string The name of this service
---@field Initialized boolean Whether or not this service has been initialized
---@field Started boolean Whether or not this service has been started
---@field InitPriority integer The priority of this service when it is initialized
---@field StartPriority integer The priority of this service when it is started
---
---@field ServiceInit fun(self: NoirService) A method that is called when the service is initialized
---@field ServiceStart fun(self: NoirService) A method that is called when the service is started
Noir.Classes.ServiceClass = Noir.Class("NoirService")

--[[
    Initializes service class objects.
]]
---@param name string
function Noir.Classes.ServiceClass:Init(name)
    -- Create attributes
    self.Name = name
    self.Initialized = false
    self.Started = false

    self.InitPriority = nil
    self.StartPriority = nil
end

--[[
    Start this service.<br>
    Used internally.
]]
function Noir.Classes.ServiceClass:_Initialize()
    -- Checks
    if self.Initialized then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to initialize this service when it has already initialized.", true, self.Name)
        return
    end

    if self.Started then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to start this service when it has already started.", true, self.Name)
        return
    end

    -- Set initialized
    self.Initialized = true

    -- Call ServiceInit
    if not self.ServiceInit then
        Noir.Libraries.Logging:Error("Service", "%s: This service is missing a ServiceInit method.", true, self.Name)
        return
    end

    self:ServiceInit()
end

--[[
    Start this service.<br>
    Used internally.
]]
function Noir.Classes.ServiceClass:_Start()
    -- Checks
    if self.Started then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to start this service when it has already started.", true, self.Name)
        return
    end

    if not self.Initialized then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to start this service when it has not initialized yet.", true, self.Name)
        return
    end

    -- Set started
    self.Started = true

    -- Call ServiceStart
    if not self.ServiceStart then
        Noir.Libraries.Logging:Warning("Service", "%s: This service is missing a ServiceStart method. You can ignore this if your service doesn't require it.", self.Name)
        return
    end

    self:ServiceStart()
end

--[[
    Checks if g_savedata is intact.<br>
    Used internally.
]]
---@return boolean
function Noir.Classes.ServiceClass:_CheckSaveData()
    -- Checks
    if not g_savedata then
        Noir.Libraries.Logging:Error("Service", "_CheckSaveData(): g_savedata is nil.", true)
        return false
    end

    if not g_savedata.Noir then
        Noir.Libraries.Logging:Error("Service", "._CheckSaveData(): g_savedata.Noir is nil.", true)
        return false
    end

    if not g_savedata.Noir.Services then
        Noir.Libraries.Logging:Error("Service", "._CheckSaveData(): g_savedata.Noir.Services is nil.", true)
        return false
    end

    if not g_savedata.Noir.Services[self.Name] then
        Noir.Libraries.Logging:Info("Service", "_CheckSaveData(): %s is missing a table in g_savedata.Noir.Services. Creating one.", self.Name)
        g_savedata.Noir.Services[self.Name] = {}
    end

    -- All good!
    return true
end

--[[
    Save a value to g_savedata under this service.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        MyService:Save("MyKey", "MyValue")
    end
]]
---@param index string
---@param data any
function Noir.Classes.ServiceClass:Save(index, data)
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return
    end

    -- Save
    g_savedata.Noir.Services[self.Name][index] = data
end

--[[
    Load data from g_savedata that was saved via the :Save() method.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        local MyValue = MyService:Load("MyKey")
    end
]]
---@param index string
---@param default any
---@return any
function Noir.Classes.ServiceClass:Load(index, default)
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return
    end

    -- Load
    return g_savedata.Noir.Services[self.Name][index] or default
end

--[[
    Remove data from g_savedata that was saved via the :Save() method.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        MyService:Remove("MyKey")
    end
]]
---@param index string
function Noir.Classes.ServiceClass:Remove(index)
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return
    end

    -- Remove
    g_savedata.Noir.Services[self.Name][index] = nil
end