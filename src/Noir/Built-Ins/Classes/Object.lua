--------------------------------------------------------
-- [Noir] Classes - Object
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
---@field OnDespawn NoirEvent Fired when this object is despawned
Noir.Classes.ObjectClass = Noir.Class("NoirObject")

--[[
    Initializes object class objects.
]]
---@param ID integer
function Noir.Classes.ObjectClass:Init(ID)
    self.ID = ID
    self.Loaded = false

    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
    self.OnDespawn = Noir.Libraries.Events:Create()
end

--[[
    Serializes this object into g_savedata format.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSerializedObject
function Noir.Classes.ObjectClass:_Serialize()
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
function Noir.Classes.ObjectClass._Deserialize(serializedObject)
    local object = Noir.Classes.ObjectClass:New(serializedObject.ID)
    return object
end

--[[
    Returns the data of this object.
]]
---@return SWObjectData|nil
function Noir.Classes.ObjectClass:GetData()
    local data = server.getObjectData(self.ID)

    if not data then
        Noir.Libraries.Logging:Error("ObjectService", ":GetData() failed for object %d. Data is nil", false, self.ID)
        return
    end

    return data
end

--[[
    Returns whether or not this object is simulating.
]]
---@return boolean
function Noir.Classes.ObjectClass:IsSimulating()
    local simulating, success = server.getObjectSimulating(self.ID)
    return simulating and success
end

--[[
    Despawn this object.
]]
function Noir.Classes.ObjectClass:Despawn()
    server.despawnObject(self.ID, true)
    self.OnDespawn:Fire()
end

--[[
    Get this object's position.
]]
---@return SWMatrix
function Noir.Classes.ObjectClass:GetPosition()
    return (server.getObjectPos(self.ID))
end

--[[
    Teleport this object.
]]
---@param position SWMatrix
function Noir.Classes.ObjectClass:Teleport(position)
    server.setObjectPos(self.ID, position)
end

--[[
    Revive this character (if character).
]]
function Noir.Classes.ObjectClass:Revive()
    server.reviveCharacter(self.ID)
end

--[[
    Set this object's data (if character).
]]
---@param hp number
---@param interactable boolean
---@param AI boolean
function Noir.Classes.ObjectClass:SetData(hp, interactable, AI)
    server.setCharacterData(self.ID, hp, interactable, AI)
end

--[[
    Returns this character's health (if character).
]]
---@return number
function Noir.Classes.ObjectClass:GetHealth()
    -- Get character data
    local data = self:GetData()

    if not data then
        Noir.Libraries.Logging:Error("Object", ":GetHealth() failed as data is nil. Returning 100 as default.", false)
        return 100
    end

    -- Return
    return data.hp
end

--[[
    Set this character's tooltip (if character).
]]
---@param tooltip string
function Noir.Classes.ObjectClass:SetTooltip(tooltip)
    server.setCharacterTooltip(self.ID, tooltip)
end

--[[
    Set this character's AI state (if character).
]]
---@param state integer 0 = none, 1 = path to destination
function Noir.Classes.ObjectClass:SetAIState(state)
    server.setAIState(self.ID, state)
end

--[[
    Set this character's AI character target (if character).
]]
---@param target NoirObject
function Noir.Classes.ObjectClass:SetAICharacterTarget(target)
    server.setAITargetCharacter(self.ID, target.ID)
end

--[[
    Set this character's AI vehicle target (if character).
]]
---@param vehicle_id integer
function Noir.Classes.ObjectClass:SetAIVehicleTarget(vehicle_id)
    server.setAITargetVehicle(self.ID, vehicle_id)
end

--[[
    Kills this character (if character).
]]
function Noir.Classes.ObjectClass:Kill()
    server.killCharacter(self.ID)
end

--[[
    Returns the vehicle this character is sat in (if character).
]]
---@return integer|nil
function Noir.Classes.ObjectClass:GetVehicle()
    local vehicle_id, success = server.getCharacterVehicle(self.ID)

    if not success then
        Noir.Libraries.Logging:Error("Object", "server.getCharacterVehicle(...) was unsuccessful.", false)
        return
    end

    return vehicle_id
end

--[[
    Returns the item this character is holding in the specified slot (if character).
]]
---@param slot SWSlotNumberEnum
---@return integer|nil
function Noir.Classes.ObjectClass:GetItem(slot)
    local item, success = server.getCharacterItem(self.ID, slot)

    if not success then
        Noir.Libraries.Logging:Error("Object", "server.getCharacterItem(...) was unsuccessful.", false)
        return
    end

    return item
end

--[[
    Returns whether or not this character is downed (dead, incapaciated, or hp <= 0) (if character).
]]
---@return boolean
function Noir.Classes.ObjectClass:IsDowned()
    -- Get data
    local data = self:GetData()

    if not data then
        Noir.Libraries.Logging:Error("Object", ":IsDowned() failed due to data being nil.", false)
        return false
    end

    -- Return
    return data.dead or data.incapacitated or data.hp <= 0
end

--[[
    Seat this character in a seat (if character).
]]
---@param vehicle_id integer
---@param name string|nil
---@param voxelX integer|nil
---@param voxelY integer|nil
---@param voxelZ integer|nil
function Noir.Classes.ObjectClass:Seat(vehicle_id, name, voxelX, voxelY, voxelZ)
    if name then
        server.setSeated(self.ID, vehicle_id, name)
    elseif voxelX and voxelY and voxelZ then
        server.setSeated(self.ID, vehicle_id, voxelX, voxelY, voxelZ)
    else
        Noir.Libraries.Logging:Error("Object", "Name, or voxelX and voxelY and voxelZ must be provided to NoirObject:Seat().", true)
    end
end

--[[
    Set the move target of this character (if creature).
]]
---@param position SWMatrix
function Noir.Classes.ObjectClass:SetMoveTarget(position)
    server.setCreatureMoveTarget(self.ID, position)
end

--[[
    Damage this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.ObjectClass:Damage(amount)
    -- Get health
    local health = self:GetHealth()

    -- Damage
    self:SetData(health - amount, false, false)
end

--[[
    Heal this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.ObjectClass:Heal(amount)
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
function Noir.Classes.ObjectClass:GetFireData()
    local isLit, success = server.getFireData(self.ID)

    if not success then
        Noir.Libraries.Logging:Error("Object", "server.getFireData(...) was unsuccessful. Returning false.", false)
        return false
    end

    return isLit
end

--[[
    Set this fire's data (if fire).
]]
---@param isLit boolean
---@param isExplosive boolean
function Noir.Classes.ObjectClass:SetFireData(isLit, isExplosive)
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