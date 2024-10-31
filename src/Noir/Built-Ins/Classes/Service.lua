--------------------------------------------------------
-- [Noir] Classes - Service
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
    Represents a Noir service.
]]
---@class NoirService: NoirClass
---@field New fun(self: NoirService, name: string, isBuiltIn: boolean, shortDescription: string, longDescription: string, authors: table<integer, string>): NoirService
---@field Name string The name of this service
---@field IsBuiltIn boolean Whether or not this service comes with Noir
---@field Initialized boolean Whether or not this service has been initialized
---@field Started boolean Whether or not this service has been started
---@field InitPriority integer The priority of this service when it is initialized
---@field StartPriority integer The priority of this service when it is started
---@field ShortDescription string A short description of this service
---@field LongDescription string A long description of this service
---@field Authors table<integer, string> The authors of this service
---
---@field ServiceInit fun(self: NoirService) A method that is called when the service is initialized
---@field ServiceStart fun(self: NoirService) A method that is called when the service is started
Noir.Classes.Service = Noir.Class("Service")

--[[
    Initializes service class objects.
]]
---@param name string
---@param isBuiltIn boolean
---@param shortDescription string
---@param longDescription string
---@param authors table<integer, string>
function Noir.Classes.Service:Init(name, isBuiltIn, shortDescription, longDescription, authors)
    Noir.TypeChecking:Assert("Noir.Classes.Service:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Service:Init()", "isBuiltIn", isBuiltIn, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Service:Init()", "shortDescription", shortDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Service:Init()", "longDescription", longDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Service:Init()", "authors", authors, "table")

    self.Name = name
    self.IsBuiltIn = isBuiltIn
    self.Initialized = false
    self.Started = false

    self.InitPriority = nil
    self.StartPriority = nil

    self.ShortDescription = shortDescription
    self.LongDescription = longDescription
    self.Authors = authors
end

--[[
    Initialize this service.<br>
    Used internally.
]]
function Noir.Classes.Service:_Initialize()
    -- Checks
    if self.Initialized then
        Noir.Debugging:RaiseError("Noir.Classes.Service:_Initialize()", "%s: Attempted to initialize this service when it has already initialized.", self.Name)
    end

    -- Set initialized
    self.Initialized = true

    -- Call ServiceInit
    if not self.ServiceInit then
        return
    end

    self:ServiceInit()
end

--[[
    Start this service.<br>
    Used internally.
]]
function Noir.Classes.Service:_Start()
    -- Checks
    if self.Started then
        Noir.Debugging:RaiseError("Noir.Classes.Service:_Start()", "%s: Attempted to start this service when it has already started.", self.Name)
        return
    end

    if not self.Initialized then
        Noir.Debugging:RaiseError("Noir.Classes.Service:_Start()", "%s: Attempted to start this service when it has not initialized yet.", self.Name)
        return
    end

    -- Set started
    self.Started = true

    -- Call ServiceStart
    if not self.ServiceStart then
        return
    end

    self:ServiceStart()
end

--[[
    Checks if g_savedata is intact.<br>
    Used internally.
]]
function Noir.Classes.Service:_CheckSaveData()
    -- Checks
    if not g_savedata then
        Noir.Debugging:RaiseError("Noir.Classes.Service:_CheckSaveData()", "g_savedata doesn't exist.")
    end

    if not g_savedata.Noir then
        Noir.Debugging:RaiseError("Noir.Classes.Service:_CheckSaveData()", "g_savedata.Noir doesn't exist.")
    end

    if not g_savedata.Noir.Services then
        Noir.Debugging:RaiseError("Noir.Classes.Service:_CheckSaveData()", "g_savedata.Noir.Services doesn't exist.")
    end

    if not g_savedata.Noir.Services[self.Name] then
        g_savedata.Noir.Services[self.Name] = {}
    end
end

--[[
    Save a value to g_savedata under this service.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        self:Save("MyKey", "MyValue")
    end
]]
---@param index string
---@param data any
function Noir.Classes.Service:Save(index, data)
    Noir.TypeChecking:Assert("Noir.Classes.Service:Save()", "index", index, "string")
    self:GetSaveData()[index] = data
end

--[[
    Load data from this service's g_savedata entry that was saved via the :Save() method.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        local MyValue = self:Load("MyKey")
    end
]]
---@param index string
---@param default any
---@return any
function Noir.Classes.Service:Load(index, default)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Service:Load()", "index", index, "string")

    -- Get the value
    local value = self:GetSaveData()[index]

    -- Return the default if it's nil
    if value == nil then
        return default
    end

    -- Return the value
    return value
end

--[[
    Similar to `:Load()`, this method loads a value from this service's g_savedata entry.<br>
    However, if the value doesn't exist, the default value provided to this method is saved then returned.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        local MyValue = self:EnsuredLoad("MyKey", "MyDefault")
    end
]]
---@param index string
---@param default any
---@return any
function Noir.Classes.Service:EnsuredLoad(index, default)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Service:EnsuredLoad()", "index", index, "string")

    -- Get the value
    local value = self:Load(index)

    -- If the value doesn't exist, save default and return default
    if value == nil then
        self:Save(index, default)
        return default
    end

    -- Return the value
    return value
end

--[[
    Remove data from this service's g_savedata entry that was saved.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        MyService:Remove("MyKey")
    end
]]
---@param index string
function Noir.Classes.Service:Remove(index)
    Noir.TypeChecking:Assert("Noir.Classes.Service:Remove()", "index", index, "string")
    self:GetSaveData()[index] = nil
end

--[[
    Returns this service's g_savedata table for direct modification.<br>

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        self:GetSaveData().MyKey = "MyValue"
        -- Equivalent to: self:Save("MyKey", "MyValue")
    end
]]
---@return table
function Noir.Classes.Service:GetSaveData()
    -- Check g_savedata
    self:_CheckSaveData()

    -- Return
    return g_savedata.Noir.Services[self.Name]
end