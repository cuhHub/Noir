--------------------------------------------------------
-- [Noir] Classes - Object
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
    Represents a Stormworks object.

    object:IsSimulating() -- true
    object:Teleport(matrix.translation(0, 0, 0))
]]
---@class NoirObject: NoirClass
---@field New fun(self: NoirObject, ID: integer): NoirObject
---@field ID integer The ID of this object
---@field Loaded boolean Whether or not this object is loaded
---@field OnLoad NoirEvent Fired when this object is loaded
---@field OnUnload NoirEvent Fired when this object is unloaded
---@field OnUnregister NoirEvent Fired when this object is unregistered from the ObjectService (mostly on despawn)
Noir.Classes.Object = Noir.Class("Object")

--[[
    Initializes object class objects.
]]
---@param ID integer
function Noir.Classes.Object:Init(ID)
    Noir.TypeChecking:Assert("Noir.Classes.Object:Init()", "ID", ID, "number")

    self.ID = math.floor(ID)
    self.Loaded = false

    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
    self.OnUnregister = Noir.Libraries.Events:Create()
end

--[[
    Serializes this object into g_savedata format.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSerializedObject
function Noir.Classes.Object:_Serialize()
    return {
        ID = self.ID
    }
end

--[[
    Deserializes this object from g_savedata format.<br>
    Used internally. Do not use in your code.
]]
---@param serializedObject NoirSerializedObject
---@return NoirObject
function Noir.Classes.Object:_Deserialize(serializedObject)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:_Deserialize()", "serializedObject", serializedObject, "table")

    -- Create object from serialized object
    local object = self:New(serializedObject.ID)

    -- Return it
    return object
end

--[[
    Returns the data of this object.
]]
---@return SWObjectData
function Noir.Classes.Object:GetData()
    -- Get the data
    local data = server.getObjectData(self.ID)

    if not data then
        Noir.Debugging:RaiseError("Noir.Classes.Object:GetData()", ":GetData() failed for object %d. Data is nil", self.ID)
    end

    -- Return the data
    return data
end

--[[
    Returns whether or not this object is simulating.
]]
---@return boolean
function Noir.Classes.Object:IsSimulating()
    local simulating, success = server.getObjectSimulating(self.ID)
    return simulating and success
end

--[[
    Returns whether or not this object exists.
]]
---@return boolean
function Noir.Classes.Object:Exists()
    local _, exists = server.getObjectSimulating(self.ID)
    return exists
end

--[[
    Despawn this object.
]]
function Noir.Classes.Object:Despawn()
    server.despawnObject(self.ID, true)
    Noir.Services.ObjectService:_RemoveObject(self)
end

--[[
    Get this object's position.
]]
---@return SWMatrix
function Noir.Classes.Object:GetPosition()
    return (server.getObjectPos(self.ID))
end

--[[
    Teleport this object.
]]
---@param position SWMatrix
function Noir.Classes.Object:Teleport(position)
    Noir.TypeChecking:Assert("Noir.Classes.Object:Teleport()", "position", position, "table")
    server.setObjectPos(self.ID, position)
end

--[[
    Revive this character (if character).
]]
function Noir.Classes.Object:Revive()
    server.reviveCharacter(self.ID)
end

--[[
    Set this object's data (if character).
]]
---@param hp number
---@param interactable boolean
---@param AI boolean
function Noir.Classes.Object:SetData(hp, interactable, AI)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetData()", "hp", hp, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetData()", "interactable", interactable, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetData()", "AI", AI, "boolean")

    -- Set data
    server.setCharacterData(self.ID, hp, interactable, AI)
end

--[[
    Returns this character's health (if character).
]]
---@return number
function Noir.Classes.Object:GetHealth()
    -- Get character data
    local data = self:GetData()

    if not data then
        Noir.Debugging:RaiseError("Noir.Classes.Object:GetHealth()", ":GetData() returned nil.")
    end

    -- Return
    return data.hp
end

--[[
    Set this character's/creature's tooltip (if character or creature).
]]
---@param tooltip string
function Noir.Classes.Object:SetTooltip(tooltip)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetTooltip()", "tooltip", tooltip, "string")
    server.setCharacterTooltip(self.ID, tooltip)
end

--[[
    Set this character's AI state (if character).
]]
---@param state integer **Ship Pilot**: 0 = none, 1 = path to destination<br>**Heli Pilot**: 0 = None, 1 = path to destination, 2 = path to destination (accurate), 3 = gun run<br>**Plane Pilot**: 0 = none, 1 = path to destination, 2 = gun run<br>**Gunner**: 0 = none, 1 = fire at target<br>**Designator**: 0 = none, 1 = aim at target
function Noir.Classes.Object:SetAIState(state)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetAIState()", "state", state, "number")
    server.setAIState(self.ID, state)
end

--[[
    Returns this character's AI target (if character).
]]
---@return NoirAITarget|nil
function Noir.Classes.Object:GetAITarget()
    local data = server.getAITarget(self.ID)

    if not data then
        return
    end

    return Noir.Classes.AITarget:New(data)
end

--[[
    Set this character's AI character target (if character).
]]
---@param target NoirObject
function Noir.Classes.Object:SetAICharacterTarget(target)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetAICharacterTarget()", "target", target, Noir.Classes.Object)
    server.setAITargetCharacter(self.ID, target.ID)
end

--[[
    Set this character's AI body target (if character).
]]
---@param body NoirBody
function Noir.Classes.Object:SetAIBodyTarget(body)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetAIBodyTarget()", "body", body, Noir.Classes.Body)
    server.setAITargetVehicle(self.ID, body.ID)
end

--[[
    Set this character's AI position target (if character).
]]
---@param position SWMatrix
function Noir.Classes.Object:SetAIPositionTarget(position)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetAIPositionTarget()", "position", position, "table")
    server.setAITarget(self.ID, position)
end

--[[
    Kills this character (if character).
]]
function Noir.Classes.Object:Kill()
    server.killCharacter(self.ID)
end

--[[
    Returns the vehicle this character is sat in (if character).
]]
---@return NoirBody|nil
function Noir.Classes.Object:GetVehicle()
    -- Get the vehicle ID
    local vehicle_id, success = server.getCharacterVehicle(self.ID)

    if not success then
        return
    end

    -- Get the body
    return Noir.Services.VehicleService:GetBody(vehicle_id)
end

--[[
    Returns the item this character is holding in the specified slot (if character).
]]
---@param slot SWSlotNumberEnum
---@return integer|nil
function Noir.Classes.Object:GetItem(slot)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:GetItem()", "slot", slot, "number")

    -- Get the item
    local item, success = server.getCharacterItem(self.ID, slot)

    if not success then
        Noir.Debugging:RaiseError("Noir.Classes.Object:GetItem()", "server.getCharacterItem(...) was unsuccessful.")
        return
    end

    -- Return it
    return item
end

--[[
    Give this character an item (if character).
]]
---@param slot SWSlotNumberEnum
---@param equipmentID SWEquipmentTypeEnum
---@param isActive boolean|nil
---@param int integer|nil
---@param float number|nil
function Noir.Classes.Object:GiveItem(slot, equipmentID, isActive, int, float)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:GiveItem()", "slot", slot, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Object:GiveItem()", "equipmentID", equipmentID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Object:GiveItem()", "isActive", isActive, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Object:GiveItem()", "int", int, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Object:GiveItem()", "float", float, "number", "nil")

    -- Give the item
    server.setCharacterItem(self.ID, slot, equipmentID, isActive or false, int or 0, float or 0)
end

--[[
    Returns whether or not this character is downed (dead, incapaciated, or hp <= 0) (if character).
]]
---@return boolean
function Noir.Classes.Object:IsDowned()
    -- Get data
    local data = self:GetData()

    if not data then
        Noir.Debugging:RaiseError("Noir.Classes.Object:IsDowned()", ":GetData() returned nil.")
        return false
    end

    -- Return
    return data.dead or data.incapacitated or data.hp <= 0
end

--[[
    Seat this character in a seat (if character).
]]
---@param body NoirBody
---@param name string|nil
---@param voxelX integer|nil
---@param voxelY integer|nil
---@param voxelZ integer|nil
function Noir.Classes.Object:Seat(body, name, voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:Seat()", "body", body, Noir.Classes.Body)
    Noir.TypeChecking:Assert("Noir.Classes.Object:Seat()", "name", name, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Object:Seat()", "voxelX", voxelX, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Object:Seat()", "voxelY", voxelY, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Object:Seat()", "voxelZ", voxelZ, "number", "nil")

    -- Set seated
    if name then
        server.setSeated(self.ID, body.ID, name)
    elseif voxelX and voxelY and voxelZ then
        server.setSeated(self.ID, body.ID, voxelX, voxelY, voxelZ)
    else
        Noir.Debugging:RaiseError("Noir.Classes.Object:Seat()", "Name, or voxelX and voxelY and voxelZ must be provided to NoirObject:Seat().")
    end
end

--[[
    Set the move target of this character (if creature).
]]
---@param position SWMatrix
function Noir.Classes.Object:SetMoveTarget(position)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetMoveTarget()", "position", position, "table")
    server.setCreatureMoveTarget(self.ID, position)
end

--[[
    Damage this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.Object:Damage(amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:Damage()", "amount", amount, "number")

    -- Get health
    local health = self:GetHealth()

    -- Damage
    self:SetData(health - amount, false, false)
end

--[[
    Heal this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.Object:Heal(amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:Heal()", "amount", amount, "number")

    -- Get health
    local health = self:GetHealth()

    -- Prevent soft-lock
    if health <= 0 and amount > 0 then
        self:Revive()
    end

    -- Heal
    self:SetData(health + amount, false, false)
end

--[[
    Get this fire's data (if fire).
]]
---@return boolean isLit
function Noir.Classes.Object:GetFireData()
    -- Get fire data
    local isLit, success = server.getFireData(self.ID)

    if not success then
        Noir.Debugging:RaiseError("Noir.Classes.Object:GetFireData()", "server.getFireData() was unsuccessful.")
        return false
    end

    -- Return
    return isLit
end

--[[
    Set this fire's data (if fire).
]]
---@param isLit boolean
---@param isExplosive boolean
function Noir.Classes.Object:SetFireData(isLit, isExplosive)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetFireData()", "isLit", isLit, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetFireData()", "isExplosive", isExplosive, "boolean")

    -- Set fire data
    server.setFireData(self.ID, isLit, isExplosive)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents an object class object that has been serialized.
]]
---@class NoirSerializedObject
---@field ID integer The object ID