--------------------------------------------------------
-- [Noir] Classes - Body
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
    Represents a body which is apart of a vehicle.<br>
    In Stormworks, this is actually a vehicle apart of a vehicle group.
]]
---@class NoirBody: NoirClass
---@field New fun(self: NoirBody, ID: integer, owner: NoirPlayer|nil, spawnPosition: SWMatrix, cost: number): NoirBody
---@field ID integer
---@field Owner NoirPlayer|nil
---@field SpawnPosition SWMatrix
---@field Cost number
---@field ParentVehicle NoirVehicle|nil This will be nil if the parent vehicle doesn't exist (occurs when the parent vehicle or body despawns)
---@field Loaded boolean
---@field OnDespawn NoirEvent
---@field OnLoad NoirEvent
---@field OnUnload NoirEvent
Noir.Classes.BodyClass = Noir.Class("NoirBody")

--[[
    Initializes body class objects.
]]
---@param ID any
---@param owner NoirPlayer|nil
---@param spawnPosition SWMatrix
---@param cost number
function Noir.Classes.BodyClass:Init(ID, owner, spawnPosition, cost)
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "owner", owner, Noir.Classes.PlayerClass, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "spawnPosition", spawnPosition, "table")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "cost", cost, "number")

    self.ID = ID
    self.Owner = owner
    self.SpawnPosition = spawnPosition
    self.Cost = cost
    self.ParentVehicle = nil
    self.Loaded = false

    self.OnDespawn = Noir.Libraries.Events:Create()
    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
end

--[[
    Serialize the body.<br>
    Used internally.
]]
---@return NoirSerializedBody
function Noir.Classes.BodyClass:_Serialize()
    return {
        ID = self.ID,
        Owner = self.Owner and self.Owner.ID,
        SpawnPosition = self.SpawnPosition,
        Cost = self.Cost,
        ParentVehicle = self.ParentVehicle and self.ParentVehicle.ID
    }
end

--[[
    Deserialize the body.<br>
    Used internally.
]]
---@param serializedBody NoirSerializedBody
---@param setParentVehicle boolean|nil
---@return NoirBody|nil
function Noir.Classes.BodyClass:_Deserialize(serializedBody, setParentVehicle)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:_Deserialize()", "serializedBody", serializedBody, "table")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:_Deserialize()", "setParentVehicle", setParentVehicle, "boolean", "nil")

    -- Deserialize
    local body = self:New(
        serializedBody.ID,
        serializedBody.Owner and Noir.Services.PlayerService:GetPlayer(serializedBody.Owner),
        serializedBody.SpawnPosition,
        serializedBody.Cost
    )

    -- Set parent vehicle
    if setParentVehicle and serializedBody.ParentVehicle then
        local parentVehicle = Noir.Services.VehicleService:GetVehicle(serializedBody.ParentVehicle)

        if not parentVehicle then
            Noir.Libraries.Logging:Error("NoirBody", "Could not find parent vehicle for a deserialized body.", false)
            return
        end

        body.ParentVehicle = parentVehicle
    end

    -- Return body
    return body
end

--[[
    Returns the position of this body.
]]
---@param voxelX integer|nil
---@param voxelY integer|nil
---@param voxelZ integer|nil
function Noir.Classes.BodyClass:GetPosition(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetPosition()", "voxelX", voxelX, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetPosition()", "voxelY", voxelY, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetPosition()", "voxelZ", voxelZ, "number", "nil")

    -- Get and return position
    return (server.getVehiclePos(self.ID))
end

--[[
    Despawn the body.
]]
function Noir.Classes.BodyClass:Despawn()
    server.despawnVehicle(self.ID, true)
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirSerializedBody
---@field ID integer
---@field Owner integer
---@field SpawnPosition SWMatrix
---@field Cost number
---@field ParentVehicle integer