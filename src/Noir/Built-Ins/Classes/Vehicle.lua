--------------------------------------------------------
-- [Noir] Classes - Vehicle
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
    Represents a vehicle.<br>
    In Stormworks, this is actually a vehicle group.
]]
---@class NoirVehicle: NoirClass
---@field New fun(self: NoirVehicle, ID: integer, owner: NoirPlayer|nil, spawnPosition: SWMatrix, cost: number): NoirVehicle
---@field ID integer
---@field Owner NoirPlayer|nil
---@field SpawnPosition SWMatrix
---@field Cost number
---@field Bodies table<integer, NoirBody>
---@field PrimaryBody NoirBody
---@field OnDespawn NoirEvent
Noir.Classes.VehicleClass = Noir.Class("NoirVehicle")

--[[
    Initializes vehicle class objects.
]]
---@param ID any
---@param owner NoirPlayer|nil
---@param spawnPosition SWMatrix
---@param cost number
function Noir.Classes.VehicleClass:Init(ID, owner, spawnPosition, cost)
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:Init()", "owner", owner, Noir.Classes.PlayerClass, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:Init()", "spawnPosition", spawnPosition, "table")
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:Init()", "cost", cost, "number")

    self.ID = ID
    self.Owner = owner
    self.SpawnPosition = spawnPosition
    self.Cost = cost
    self.Bodies = {}
    self.PrimaryBody = nil

    self.OnDespawn = Noir.Libraries.Events:Create()
end

--[[
    Serialize the vehicle.<br>
    Used internally.
]]
---@return NoirSerializedVehicle
function Noir.Classes.VehicleClass:_Serialize()
    local bodies = {}

    for _, body in pairs(self.Bodies) do
        bodies[body.ID] = body.ID
    end

    return {
        ID = self.ID,
        Owner = self.Owner and self.Owner.ID,
        SpawnPosition = self.SpawnPosition,
        Cost = self.Cost,
        Bodies = bodies
    }
end

--[[
    Deserialize a serialized vehicle.<br>
]]
---@param serializedVehicle NoirSerializedVehicle
---@param addBodies boolean|nil
---@return NoirVehicle
function Noir.Classes.VehicleClass:_Deserialize(serializedVehicle, addBodies)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:_Deserialize()", "serializedVehicle", serializedVehicle, "table")
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:_Deserialize()", "addBodies", addBodies, "boolean", "nil")

    -- Deserialize
    local vehicle = self:New(
        serializedVehicle.ID,
        serializedVehicle.Owner and Noir.Services.PlayerService:GetPlayer(serializedVehicle.Owner),
        serializedVehicle.SpawnPosition,
        serializedVehicle.Cost
    )

    if addBodies then
        for _, bodyID in pairs(serializedVehicle.Bodies) do
            local body = Noir.Services.VehicleService:GetBody(bodyID)

            if not body then
                Noir.Libraries.Logging:Error("NoirVehicle", "Couldn't find a body for a deserialized vehicle.", false)
                goto continue
            end

            vehicle:_AddBody(body)

            ::continue::
        end
    end

    -- Return
    return vehicle
end

--[[
    Calculate the primary body.<br>
    Used internally.
]]
function Noir.Classes.VehicleClass:_CalculatePrimaryBody()
    local previousBody, previousID

    for _, body in pairs(self.Bodies) do
        if not previousBody then
            previousBody, previousID = body, body.ID
            goto continue
        end

        if body.ID < previousID then
            previousBody, previousID = body, body.ID
        end

        ::continue::
    end

    self.PrimaryBody = previousBody
end

--[[
    Add a body to the vehicle.<br>
    Used internally.
]]
---@param body NoirBody
function Noir.Classes.VehicleClass:_AddBody(body)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:_AddBody()", "body", body, Noir.Classes.BodyClass)

    -- Add body
    self.Bodies[body.ID] = body
    body.ParentVehicle = self
    self:_CalculatePrimaryBody()
end

--[[
    Remove a body from the vehicle.<br>
    Used internally.
]]
---@param body NoirBody
function Noir.Classes.VehicleClass:_RemoveBody(body)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:_RemoveBody()", "body", body, Noir.Classes.BodyClass)

    -- Remove body
    self.Bodies[body.ID] = nil
    body.ParentVehicle = nil
    self:_CalculatePrimaryBody()
end

--[[
    Return this vehicle's position.<br>
    Uses the vehicle's primary body internally.
]]
---@param voxelX integer|nil
---@param voxelY integer|nil
---@param voxelZ integer|nil
---@return SWMatrix
function Noir.Classes.VehicleClass:GetPosition(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:GetPosition()", "voxelX", voxelX, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:GetPosition()", "voxelY", voxelY, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:GetPosition()", "voxelZ", voxelZ, "number", "nil")

    -- Get and return position
    return self.PrimaryBody:GetPosition(voxelX, voxelY, voxelZ)
end

--[[
    Get a body by its ID.
]]
---@param ID integer
---@return NoirBody|nil
function Noir.Classes.VehicleClass:GetBody(ID)
    Noir.TypeChecking:Assert("Noir.Classes.VehicleClass:GetBody()", "ID", ID, "number")
    return self.Bodies[ID]
end

--[[
    Despawn the vehicle.
]]
function Noir.Classes.VehicleClass:Despawn()
    server.despawnVehicleGroup(self.ID, true)
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirSerializedVehicle
---@field ID integer
---@field Owner integer
---@field SpawnPosition SWMatrix
---@field Cost number
---@field Bodies table<integer, integer>