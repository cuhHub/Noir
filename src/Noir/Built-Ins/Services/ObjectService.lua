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
    local object = Service:GetObject(object_id)

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
---@field Objects table<integer, NoirObject> A table containing all objects
---@field OnRegister NoirEvent Fired when an object is registered (first arg: NoirObject)
---@field OnUnregister NoirEvent Fired when an object is unregistered (first arg: NoirObject)
---@field OnLoad NoirEvent Fired when an object is loaded (first arg: NoirObject)
---@field OnUnload NoirEvent Fired when an object is unloaded (first arg: NoirObject)
---
---@field OnLoadConnection NoirConnection A connection to the onObjectLoad game callback
---@field OnUnloadConnection NoirConnection A connection to the onObjectUnload game callback
Noir.Services.ObjectService = Noir.Services:CreateService("ObjectService")

function Noir.Services.ObjectService:ServiceInit()
    self.Objects = {}

    self.OnRegister = Noir.Libraries.Events:Create()
    self.OnUnregister = Noir.Libraries.Events:Create()
    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
end

function Noir.Services.ObjectService:ServiceStart()
    -- Load saved objects
    for _, object in pairs(self:_GetSavedObjects()) do -- important to copy, because :RegisterObject() modifies the saved objects table
        -- Register object
        local registeredObject = self:RegisterObject(object.ID)

        if not registeredObject then
            goto continue
        end

        -- Update attributes
        registeredObject.Loaded = object.Loaded
        self:_SaveObjectSavedata(registeredObject)

        -- Log
        Noir.Libraries.Logging:Info("ObjectService", "Loading object: %s", object.ID)

        ::continue::
    end

    -- Listen for object loading/unloading
    ---@param object_id integer
    self.OnLoadConnection = Noir.Callbacks:Connect("onObjectLoad", function(object_id)
        -- Get object
        local object = self:GetObject(object_id)

        if not object then
            Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in OnLoadConnection callback.", false)
            return
        end

        -- Fire event, set loaded
        object.Loaded = true
        object.OnLoad:Fire()
        self.OnLoad:Fire(object)

        -- Save
        self:_SaveObjectSavedata(object)
    end)

    ---@param object_id integer
    self.OnUnloadConnection = Noir.Callbacks:Connect("onObjectUnload", function(object_id)
        -- Get object
        local object = self:GetObject(object_id)

        if not object then
            Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in OnUnloadConnection callback.", false)
            return
        end

        -- Fire events, set loaded
        object.Loaded = false
        object.OnUnload:Fire()
        self.OnUnload:Fire(object)

        -- Save
        self:_SaveObjectSavedata(object)
    end)
end

--[[
    Overwrite saved objects.<br>
    Used internally. Do not use in your code.
]]
---@param objects table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_SaveObjects(objects)
    self:Save("objects", objects)
end

--[[
    Get saved objects.<br>
    Used internally. Do not use in your code.
]]
---@return table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_GetSavedObjects()
    return Noir.Libraries.Table:Copy(self:Load("objects", {}))
end

--[[
    Get all objects.
]]
---@return table<integer, NoirObject>
function Noir.Services.ObjectService:GetObjects()
    return Noir.Libraries.Table:Copy(self.Objects)
end

--[[
    Save an object to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param object NoirObject
function Noir.Services.ObjectService:_SaveObjectSavedata(object)
    local saved = self:_GetSavedObjects()
    saved[object.ID] = object:_Serialize()

    self:_SaveObjects(saved)
end

--[[
    Remove an object from g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param object_id integer
function Noir.Services.ObjectService:_RemoveObjectSavedata(object_id)
    local saved = self:_GetSavedObjects()
    saved[object_id] = nil

    self:_SaveObjects(saved)
end

--[[
    Registers an object by ID.
]]
---@param object_id integer
---@return NoirObject|nil
function Noir.Services.ObjectService:RegisterObject(object_id)
    -- Create object
    local object = Noir.Classes.ObjectClass:New(object_id)
    self.Objects[object_id] = object
    self.OnRegister:Fire(object)

    -- Save to g_savedata
    self:_SaveObjectSavedata(object)

    -- Remove on object despawn
    object.OnDespawn:Once(function()
        self:RemoveObject(object_id)
    end)

    -- Return
    return object
end

--[[
    Returns the object with the given ID.
]]
---@param object_id integer
---@return NoirObject|nil
function Noir.Services.ObjectService:GetObject(object_id)
    return self.Objects[object_id] or self:RegisterObject(object_id)
end

--[[
    Removes the object with the given ID.
]]
---@param object_id integer
function Noir.Services.ObjectService:RemoveObject(object_id)
    -- Get object
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in :RemoveObject().", false)
        return
    end

    -- Fire event
    self.OnUnregister:Fire(object)

    -- Remove object
    self.Objects[object_id] = nil

    -- Remove from g_savedata
    self:_RemoveObjectSavedata(object_id)
end