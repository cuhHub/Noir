--------------------------------------------------------
-- [Noir] Classes - Vehicle
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2025 Cuh4

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
---@field ID integer The ID of this vehicle
---@field Owner NoirPlayer|nil The owner of this vehicle, or nil if spawned by an addon OR if the player who owns the vehicle left before Noir starts again (eg: after save load or addon reload)
---@field SpawnPosition SWMatrix The position this vehicle was spawned at
---@field Cost number The cost of this vehicle
---@field Bodies table<integer, NoirBody> A table of all of the the bodies apart of this vehicle
---@field PrimaryBody NoirBody|nil This will be nil if there are no bodies (occurs when the vehicle is despawned)
---@field Spawned boolean Whether or not this vehicle is spawned. This is set to false when the vehicle is despawned
---@field OnDespawn NoirEvent Fired when this vehicle is despawned
Noir.Classes.Vehicle = Noir.Class("Vehicle")

--[[
    Initializes vehicle class objects.
]]
---@param ID any
---@param owner NoirPlayer|nil
---@param spawnPosition SWMatrix
---@param cost number
function Noir.Classes.Vehicle:Init(ID, owner, spawnPosition, cost)
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:Init()", "owner", owner, Noir.Classes.Player, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:Init()", "spawnPosition", spawnPosition, "table")
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:Init()", "cost", cost, "number")

    self.ID = math.floor(ID)
    self.Owner = owner
    self.SpawnPosition = spawnPosition
    self.Cost = cost
    self.Bodies = {}
    self.PrimaryBody = nil
    self.Spawned = true

    self.OnDespawn = Noir.Libraries.Events:Create()
end

--[[
    Serialize the vehicle.<br>
    Used internally.
]]
---@return NoirSerializedVehicle
function Noir.Classes.Vehicle:_Serialize()
    local bodies = {}

    for _, body in pairs(self.Bodies) do
        table.insert(bodies, body.ID)
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
function Noir.Classes.Vehicle:_Deserialize(serializedVehicle, addBodies)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:_Deserialize()", "serializedVehicle", serializedVehicle, "table")
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:_Deserialize()", "addBodies", addBodies, "boolean", "nil")

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
function Noir.Classes.Vehicle:_CalculatePrimaryBody()
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
function Noir.Classes.Vehicle:_AddBody(body)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:_AddBody()", "body", body, Noir.Classes.Body)

    -- Add body
    self.Bodies[body.ID] = body
    body.ParentVehicle = self

    -- Recalculate primary body
    self:_CalculatePrimaryBody()
end

--[[
    Remove a body from the vehicle.<br>
    Used internally.
]]
---@param body NoirBody
function Noir.Classes.Vehicle:_RemoveBody(body)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:_RemoveBody()", "body", body, Noir.Classes.Body)

    -- Remove body
    self.Bodies[body.ID] = nil
    body.ParentVehicle = nil

    -- Recalculate primary body
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
function Noir.Classes.Vehicle:GetPosition(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:GetPosition()", "voxelX", voxelX, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:GetPosition()", "voxelY", voxelY, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:GetPosition()", "voxelZ", voxelZ, "number", "nil")

    -- Get and return position
    return self.PrimaryBody and self.PrimaryBody:GetPosition(voxelX, voxelY, voxelZ) or matrix.translation(0, 0, 0)
end

--[[
    Get a child body by its ID.
]]
---@param ID integer
---@return NoirBody|nil
function Noir.Classes.Vehicle:GetBody(ID)
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:GetBody()", "ID", ID, "number")
    return self.Bodies[ID]
end

--[[
    Teleport the vehicle to a new position.
]]
---@param position SWMatrix
function Noir.Classes.Vehicle:Teleport(position)
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:Teleport()", "position", position, "table")
    server.setGroupPos(self.ID, position)
end

--[[
    Move the vehicle to a new position, essentially teleports without reloading the vehicle.<br>
    Note that rotation is ignored.
]]
---@param position SWMatrix
function Noir.Classes.Vehicle:Move(position)
    Noir.TypeChecking:Assert("Noir.Classes.Vehicle:Move()", "position", position, "table")
    server.moveGroup(self.ID, position)
end

--[[
    Despawn the vehicle.
]]
function Noir.Classes.Vehicle:Despawn()
    server.despawnVehicleGroup(self.ID, true)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of the NoirVehicle class.
]]
---@class NoirSerializedVehicle
---@field ID integer The ID of this vehicle
---@field Owner integer The peer ID of the owner of this vehicle, or -1 if addon vehicle
---@field SpawnPosition SWMatrix The position this vehicle was spawned at
---@field Cost number The cost of this vehicle
---@field Bodies table<integer, integer> A table containing the IDs of this vehicle's bodies