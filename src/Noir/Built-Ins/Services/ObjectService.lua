--------------------------------------------------------
-- [Noir] Services - Object Service
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
    A service for wrapping SW objects in classes.

    local object_id = 5
    local object = Service:GetOrCreateObject(object_id)

    object:GetData()
    object:Despawn()
    object:GetPosition()
    object:Teleport()

    object.OnLoad:Connect(function()
        -- Code
    end)

    object.OnUnload:Connect(function()
        -- Code
    end)
]]
---@class NoirObjectService: NoirService
---@field objects table<integer, NoirObject> A table containing all objects
---@field OnObjectRegister NoirEvent Fired when an object is registered
---@field OnObjectUnregister NoirEvent Fired when an object is unregistered
---@field OnObjectLoad NoirEvent Fired when an object is loaded (first arg: NoirObject)
---@field OnObjectUnload NoirEvent Fired when an object is unloaded (first arg: NoirObject)
---
---@field OnLoadConnection NoirConnection A connection to the onObjectLoad game callback
---@field OnUnloadConnection NoirConnection A connection to the onObjectUnload game callback
Noir.Services.ObjectService = Noir.Services:CreateService("ObjectService")

function Noir.Services.ObjectService:ServiceInit()
    self.objects = {}

    self.OnObjectRegister = Noir.Libraries.Events:Create()
    self.OnObjectUnregister = Noir.Libraries.Events:Create()
    self.OnObjectLoad = Noir.Libraries.Events:Create()
    self.OnObjectUnload = Noir.Libraries.Events:Create()
end

function Noir.Services.ObjectService:ServiceStart()
    -- Load saved objects
    for _, object in pairs(self:_GetSavedObjects()) do
        local obj = self:RegisterObject(object.ID)

        if not obj then
            goto continue
        end

        obj.Loaded = object.loaded

        ::continue::
    end

    -- Listen for object loading/unloading
    ---@param object_id integer
    self.OnLoadConnection = Noir.Callbacks:Connect("onObjectLoad", function(object_id)
        -- Get object
        local object = self:GetOrCreateObject(object_id)

        if not object then
            return
        end

        -- Fire event, set loaded
        object.Loaded = true
        object.OnLoad:Fire()
        self.OnObjectLoad:Fire(object)
    end)

    ---@param object_id integer
    self.OnUnloadConnection = Noir.Callbacks:Connect("onObjectUnload", function(object_id)
        -- Get object
        local object = self:GetOrCreateObject(object_id)

        if not object then
            return
        end

        -- Fire events, set loaded
        object.Loaded = false
        object.OnUnload:Fire()
        self.OnObjectUnload:Fire(object)
    end)
end

--[[
    Overwrite saved objects.<br>
    Used internally. Do not use in your code.
]]
---@param objects table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:SaveObjects(objects)
    self:Save("objects", objects)
end

--[[
    Get saved objects.<br>
    Used internally. Do not use in your code.
]]
---@return table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_GetSavedObjects()
    return self:Load("objects", {})
end

--[[
    Get all objects.
]]
---@return table<integer, NoirObject>
function Noir.Services.ObjectService:GetObjects()
    return self.objects
end

--[[
    Registers an object by ID.
]]
---@param object_id integer
---@return NoirObject|nil
function Noir.Services.ObjectService:RegisterObject(object_id)
    -- Check if already exists
    if self:GetObject(object_id) then
        Noir.Libraries.Logging:Error("ObjectService", "Attempted to register an object that already exists.", true)
        return
    end

    -- Create object
    local object = Noir.Classes.ObjectClass:New(object_id)
    self.objects[object_id] = object
    self.OnObjectRegister:Fire(object)

    -- Save to g_savedata
    local saved = self:_GetSavedObjects()
    saved[object_id] = object:_Serialize()

    self:SaveObjects(saved)

    -- Remove on object despawn
    object.OnDespawn:Once(function()
        self:RemoveObject(object_id)
    end)

    -- Return
    return object
end

--[[
    Returns the object with the given ID, or creates a new class object wrapping around the object if it doesn't exist.
]]
---@param object_id integer
---@return NoirObject|nil
function Noir.Services.ObjectService:GetOrCreateObject(object_id)
    local object = self:GetObject(object_id)

    if not object then
        return self:RegisterObject(object_id)
    end

    return object
end

--[[
    Returns the object with the given ID.
]]
---@param object_id integer
---@return NoirObject|nil
function Noir.Services.ObjectService:GetObject(object_id)
    return self.objects[object_id]
end

--[[
    Removes the object with the given ID.
]]
---@param object_id integer
function Noir.Services.ObjectService:RemoveObject(object_id)
    -- Get object
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Warning("ObjectService", "Attempted to remove an object that doesn't exist, ID: %s (:RemoveObject() method)", object_id)
        return
    end

    -- Fire event
    self.OnObjectUnregister:Fire(object)

    -- Remove object
    self.objects[object_id] = nil

    -- Remove from g_savedata
    local saved = self:_GetSavedObjects()
    saved[object_id] = nil

    self:SaveObjects(saved)
end