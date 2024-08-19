--------------------------------------------------------
-- [Noir] Services - Object Service
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
    A service for wrapping SW objects in classes.

    local object_id = 5
    local object = Noir.Services.ObjectService:GetObject(object_id)

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
---@field _OnObjectLoadConnection NoirConnection A connection to the onObjectLoad game callback
---@field _OnObjectUnloadConnection NoirConnection A connection to the onObjectUnload game callback
Noir.Services.ObjectService = Noir.Services:CreateService(
    "ObjectService",
    true,
    "A service for wrapping SW objects in classes.",
    "A service for wrapping SW objects in classes as well as providing useful object-related utilities.",
    {"Cuh4"}
)

function Noir.Services.ObjectService:ServiceInit()
    self.Objects = {}

    self.OnRegister = Noir.Libraries.Events:Create()
    self.OnUnregister = Noir.Libraries.Events:Create()
    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()

    -- Load saved objects
    self:_LoadObjects()
end

function Noir.Services.ObjectService:ServiceStart()
    -- Listen for object loading/unloading
    self._OnObjectLoadConnection = Noir.Callbacks:Connect("onObjectLoad", function(object_id)
        -- Get object
        local object = self:GetObject(object_id) -- creates an object if it doesn't already exist

        if not object then
            Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in OnObjectLoadConnection callback.", false)
            return
        end

        -- Call method
        self:_OnObjectLoad(object)
    end)

    self._OnObjectUnloadConnection = Noir.Callbacks:Connect("onObjectUnload", function(object_id)
        -- Get object
        local object = self:GetObject(object_id)

        if not object then
            Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in OnObjectUnloadConnection callback.", false)
            return
        end

        -- Call method
        self:_OnObjectUnload(object)
    end)
end

--[[
    Load saved objects.<br>
    Used internally. Do not use in your code.
]]
function Noir.Services.ObjectService:_LoadObjects()
    for _, object in pairs(self:_GetSavedObjects()) do
        self:RegisterObject(object.ID, true)
    end
end

--[[
    Run code that would normally be ran when an object is loaded.<br>
    Used internally. Do not use in your code.
]]
---@param object NoirObject
function Noir.Services.ObjectService:_OnObjectLoad(object)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_OnObjectLoad()", "object", object, Noir.Classes.ObjectClass)

    -- Fire event, set loaded
    object.Loaded = true
    object.OnLoad:Fire()
    self.OnLoad:Fire(object)

    -- Save
    self:_SaveObjectSavedata(object)
end

--[[
    Run code that would normally be ran when an object is unloaded.<br>
    Used internally. Do not use in your code.
]]
---@param object NoirObject
function Noir.Services.ObjectService:_OnObjectUnload(object)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_OnObjectUnload()", "object", object, Noir.Classes.ObjectClass)

    -- Fire events, set loaded
    object.Loaded = false
    object.OnUnload:Fire()
    self.OnUnload:Fire(object)

    -- Remove from g_savedata if the object was removed and unloaded, otherwise save
    Noir.Services.TaskService:AddTask(function()
        if not object:Exists() then
            self:_RemoveObjectSavedata(object.ID)
        else
            self:_SaveObjectSavedata(object)
        end
    end, 0.01) -- untested, but this delay might be needed in case the object is unloaded first, then removed
end

--[[
    Overwrite saved objects.<br>
    Used internally. Do not use in your code.
]]
---@param objects table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_SaveObjects(objects)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_SaveObjects()", "objects", objects, "table")

    -- Save to g_savedata
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
    Save an object to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param object NoirObject
function Noir.Services.ObjectService:_SaveObjectSavedata(object)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_SaveObjectSavedata()", "object", object, Noir.Classes.ObjectClass)

    -- Save to g_savedata
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_RemoveObjectSavedata()", "object_id", object_id, "number")

    -- Remove from g_savedata
    local saved = self:_GetSavedObjects()
    saved[object_id] = nil

    self:_SaveObjects(saved)
end

--[[
    Get all objects.
]]
---@return table<integer, NoirObject>
function Noir.Services.ObjectService:GetObjects()
    return Noir.Libraries.Table:Copy(self.Objects)
end

--[[
    Registers an object by ID.
]]
---@param object_id integer
---@param _preventEventTrigger boolean|nil
---@return NoirObject|nil
function Noir.Services.ObjectService:RegisterObject(object_id, _preventEventTrigger)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:RegisterObject()", "object_id", object_id, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:RegisterObject()", "_preventEventTrigger", _preventEventTrigger, "boolean", "nil")

    -- Check if the object exists and is loaded
    local loaded, exists = server.getObjectSimulating(object_id)

    if not exists then
        self:_RemoveObjectSavedata(object_id) -- prevent memory leak
        return
    end

    -- Create object
    local object = Noir.Classes.ObjectClass:New(object_id)
    object.Loaded = loaded

    self.Objects[object_id] = object

    -- Fire event
    if not _preventEventTrigger then -- this is here for objects that are being registered from g_savedata
        self.OnRegister:Fire(object)
    end

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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:GetObject()", "object_id", object_id, "number")

    -- Get object
    return self.Objects[object_id] or self:RegisterObject(object_id)
end

--[[
    Removes the object with the given ID.
]]
---@param object_id integer
function Noir.Services.ObjectService:RemoveObject(object_id)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:RemoveObject()", "object_id", object_id, "number")

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

--[[
    Spawn an object.
]]
---@param objectType SWObjectTypeEnum
---@param position SWMatrix
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnObject(objectType, position)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnObject()", "objectType", objectType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnObject()", "position", position, "table")

    -- Spawn the object
    local object_id, success = server.spawnObject(position, objectType)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnObject() failed due to server.spawnObject() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnObject().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn a character.
]]
---@param outfitType SWOutfitTypeEnum
---@param position SWMatrix
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnCharacter(outfitType, position)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCharacter()", "outfitType", outfitType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCharacter()", "position", position, "table")

    -- Spawn the character
    local object_id, success = server.spawnCharacter(position, outfitType)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnCharacter() failed due to server.spawnCharacter() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnCharacter().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn a creature.
]]
---@param creatureType SWCreatureTypeEnum
---@param position SWMatrix
---@param sizeMultiplier number|nil Default: 1
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnCreature(creatureType, position, sizeMultiplier)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCreature()", "creatureType", creatureType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCreature()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCreature()", "sizeMultiplier", sizeMultiplier, "number", "nil")

    -- Spawn the creature
    local object_id, success = server.spawnCreature(position, creatureType, sizeMultiplier or 1)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnCreature() failed due to server.spawnCreature() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnCreature().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn an animal.
]]
---@param animalType SWAnimalTypeEnum
---@param position SWMatrix
---@param sizeMultiplier number|nil Default: 1
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnAnimal(animalType, position, sizeMultiplier)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnAnimal()", "animalType", animalType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnAnimal()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnAnimal()", "sizeMultiplier", sizeMultiplier, "number", "nil")

    -- Spawn the animal
    local object_id, success = server.spawnAnimal(position, animalType, sizeMultiplier or 1)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnAnimal() failed due to server.spawnAnimal() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnAnimal().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn an equipment item.
]]
---@param equipmentType SWEquipmentTypeEnum
---@param position SWMatrix
---@param int integer
---@param float integer
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnEquipment(equipmentType, position, int, float)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "equipmentType", equipmentType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "int", int, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "float", float, "number")

    -- Spawn the equipment
    local object_id, success = server.spawnEquipment(position, equipmentType, int, float)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnEquipment() failed due to server.spawnEquipment() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnEquipment().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn a fire.
]]
---@param position SWMatrix
---@param size number 0 - 10
---@param magnitude number -1 explodes instantly. Nearer to 0 means the explosion takes longer to happen. Must be below 0 for explosions to work.
---@param isLit boolean Lights the fire. If the magnitude is >1, this will need to be true for the fire to first warm up before exploding.
---@param isExplosive boolean
---@param parentVehicleID integer|nil
---@param explosionMagnitude number The size of the explosion (0-5)
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnFire(position, size, magnitude, isLit, isExplosive, parentVehicleID, explosionMagnitude)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "size", size, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "magnitude", magnitude, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "isLit", isLit, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "isExplosive", isExplosive, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "parentVehicleID", parentVehicleID, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "explosionMagnitude", explosionMagnitude, "number")

    -- Spawn the fire
    local object_id, success = server.spawnFire(position, size, magnitude, isLit, isExplosive, parentVehicleID or 0, explosionMagnitude)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnFire() failed due to server.spawnFire() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnFire().", false)
        return
    end

    -- Return
    return object
end