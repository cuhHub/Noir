--------------------------------------------------------
-- [Noir] Services - Vehicle Service
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
    A service for interacting with vehicles.
]]
---@class NoirVehicleService: NoirService
---@field Vehicles table<integer, NoirVehicle> A table of all spawned vehicles (in SW: vehicle groups)
---@field _SavedVehicles table<integer, NoirSerializedVehicle> A table of all saved vehicles
---@field Bodies table<integer, NoirBody> A table of all spawned bodies (in SW: vehicles)
---@field _SavedBodies table<integer, NoirSerializedBody> A table of all saved bodies
---
---@field OnVehicleSpawn NoirEvent Arguments: NoirVehicle | Fired when a vehicle is spawned
---@field OnVehicleDespawn NoirEvent Arguments: NoirVehicle | Fired when a vehicle is despawned
---@field OnBodySpawn NoirEvent Arguments: NoirBody | Fired when a body is spawned
---@field OnBodyDespawn NoirEvent Arguments: NoirBody | Fired when a body is despawned
---@field OnBodyLoad NoirEvent Arguments: NoirBody | Fired when a body is loaded
---@field OnBodyUnload NoirEvent Arguments: NoirBody | Fired when a body is unloaded
---
---@field _OnGroupSpawnConnection NoirConnection A connection to the onGroupSpawn event
---@field _OnBodySpawnConnection NoirConnection A connection to the onVehicleSpawn event
---@field _OnBodyDespawnConnection NoirConnection A connection to the onVehicleDespawn event
---@field _OnBodyLoadConnection NoirConnection A connection to the onVehicleLoad event
---@field _OnBodyUnloadConnection NoirConnection A connection to the onVehicleUnload event
Noir.Services.VehicleService = Noir.Services:CreateService(
    "VehicleService",
    true,
    "A service for interacting with vehicles.",
    "A service for interacting with vehicles in an OOP-like manner.",
    {"Cuh4"}
)

function Noir.Services.VehicleService:ServiceInit()
    self.Vehicles = {}
    self._SavedVehicles = self:Load("SavedVehicles", {})

    self.Bodies = {}
    self._SavedBodies = self:Load("SavedBodies", {})

    self.OnVehicleSpawn = Noir.Libraries.Events:Create()
    self.OnVehicleDespawn = Noir.Libraries.Events:Create()

    self.OnBodySpawn = Noir.Libraries.Events:Create()
    self.OnBodyDespawn = Noir.Libraries.Events:Create()
    self.OnBodyLoad = Noir.Libraries.Events:Create()
    self.OnBodyUnload = Noir.Libraries.Events:Create()
end

function Noir.Services.VehicleService:ServiceStart()
    -- Load saved vehicles and bodies
    self:_LoadSavedBodies()
    self:_LoadSavedVehicles()

    -- Listen for vehicles spawning
    self._OnGroupSpawnConnection = Noir.Callbacks:Connect("onGroupSpawn", function(group_id, peer_id, x, y, z, group_cost)
        local player = Noir.Services.PlayerService:GetPlayer(peer_id)
        self:_RegisterVehicle(group_id, player, matrix.translation(x, y, z), group_cost, true)
    end)

    -- Listen for bodies spawning
    self._OnBodySpawnConnection = Noir.Callbacks:Connect("onVehicleSpawn", function(vehicle_id, peer_id, x, y, z, group_cost, group_id)
        local player = Noir.Services.PlayerService:GetPlayer(peer_id)
        self:_RegisterBody(vehicle_id, player, matrix.translation(x, y, z), group_cost, true)
    end)

    -- Listen for bodies despawning
    self._OnBodyDespawnConnection = Noir.Callbacks:Connect("onVehicleDespawn", function(vehicle_id, peer_id)
        local body = self:GetBody(vehicle_id)

        if not body then
            Noir.Libraries.Logging:Error("VehicleService", "A body was despawned that isn't recognized.", false)
            return
        end

        self:_UnregisterBody(body, true, true)
    end)

    -- Listen for bodies loading
    self._OnBodyLoadConnection = Noir.Callbacks:Connect("onVehicleLoad", function(vehicle_id)
        local body = self:GetBody(vehicle_id)

        if not body then
            Noir.Libraries.Logging:Error("VehicleService", "A body was loaded that isn't recognized.", false)
            return
        end

        self:_LoadBody(body, true)
    end)

    -- Listen for bodies unloading
    self._OnBodyUnloadConnection = Noir.Callbacks:Connect("onVehicleUnload", function(vehicle_id)
        local body = self:GetBody(vehicle_id)

        if not body then
            Noir.Libraries.Logging:Error("VehicleService", "A body was unloaded that isn't recognized.", false)
            return
        end

        self:_UnloadBody(body, true)
    end)
end

--[[
    Load all saved vehicles. It is important bodies are loaded beforehand. If this is not the case, they will be created automatically but possibly with incorrect data.<br>
    Used internally.
]]
function Noir.Services.VehicleService:_LoadSavedVehicles()
    print("LOADING SAVED VEHICLES")
    for _, vehicle in pairs(self._SavedVehicles) do
        print("LOADING VEHICLE #"..vehicle.ID)
        self:_RegisterVehicle(vehicle.ID, vehicle.Owner and Noir.Services.PlayerService:GetPlayer(vehicle.Owner), vehicle.SpawnPosition, vehicle.Cost, false)
    end
end

--[[
    Load all saved bodies.<br>
    Used internally.
]]
function Noir.Services.VehicleService:_LoadSavedBodies()
    print("LOADING SAVED BODIES")
    for _, body in pairs(self._SavedBodies) do
        print("LOADING BODY #"..body.ID)
        self:_RegisterBody(body.ID, body.Owner and Noir.Services.PlayerService:GetPlayer(body.Owner), body.SpawnPosition, body.Cost, false)
    end
end

--[[
    Register a vehicle to the vehicle service.<br>
    Used internally.
]]
---@param ID integer
---@param player NoirPlayer|nil
---@param spawnPosition SWMatrix
---@param cost number
---@param fireEvent boolean
---@return NoirVehicle|nil
function Noir.Services.VehicleService:_RegisterVehicle(ID, player, spawnPosition, cost, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterVehicle()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterVehicle()", "player", player, Noir.Classes.PlayerClass, "nil")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterVehicle()", "spawnPosition", spawnPosition, "table")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterVehicle()", "cost", cost, "number")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterVehicle()", "fireEvent", fireEvent, "boolean")

    -- Check if already registered
    if self:GetVehicle(ID) then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to register a vehicle because it's already registered.", false)
        return
    end

    -- Get bodies
    local bodyIDs, success = server.getVehicleGroup(ID)

    if not success then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to get bodies for a vehicle.", false)
        return
    end

    -- Create bodies
    local bodies = {} ---@type table<integer, NoirBody>

    for _, bodyID in pairs(bodyIDs) do
        local body = self:GetBody(bodyID) or self:_RegisterBody(bodyID, player, spawnPosition, cost, fireEvent)

        if not body then
            goto continue
        end

        table.insert(bodies, body)

        ::continue::
    end

    -- Create vehicle
    local vehicle = Noir.Classes.VehicleClass:New(ID, player, spawnPosition, cost)
    self.Vehicles[vehicle.ID] = vehicle

    -- Add bodies
    for _, body in pairs(bodies) do
        vehicle:_AddBody(body)
    end

    -- Save
    self:_SaveVehicle(vehicle)

    -- Fire event
    if fireEvent then
        self.OnVehicleSpawn:Fire(vehicle)
    end

    -- Return vehicle
    return vehicle
end

--[[
    Save a vehicle.<br>
    Used internally.
]]
---@param vehicle NoirVehicle
function Noir.Services.VehicleService:_SaveVehicle(vehicle)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_SaveVehicle()", "vehicle", vehicle, Noir.Classes.VehicleClass)

    -- Save
    self._SavedVehicles[vehicle.ID] = vehicle:_Serialize()
    self:Save("SavedVehicles", self._SavedVehicles)
end

--[[
    Unsave a vehicle.<br>
    Used internally.
]]
---@param vehicle NoirVehicle
function Noir.Services.VehicleService:_UnsaveVehicle(vehicle)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnsaveVehicle()", "vehicle", vehicle, Noir.Classes.VehicleClass)

    -- Unsave
    self._SavedVehicles[vehicle.ID] = nil
    self:Save("SavedVehicles", self._SavedVehicles)
end

--[[
    Unregister a vehicle from the vehicle service.<br>
    Used internally.
]]
---@param vehicle NoirVehicle
---@param fireEvent boolean
function Noir.Services.VehicleService:_UnregisterVehicle(vehicle, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnregisterVehicle()", "vehicle", vehicle, Noir.Classes.VehicleClass)
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnregisterVehicle()", "fireEvent", fireEvent, "boolean")

    -- Check if exists
    if not self:GetVehicle(vehicle.ID) then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to unregister a vehicle because it doesn't exist.", false)
        return
    end

    -- Remove vehicle
    self.Vehicles[vehicle.ID] = nil

    -- Remove bodies
    for _, body in pairs(vehicle.Bodies) do
        self:_UnregisterBody(body, false, fireEvent)
    end

    -- Remove from saved
    self:_UnsaveVehicle(vehicle)

    -- Fire event
    if fireEvent then
        self.OnVehicleDespawn:Fire(vehicle)
        vehicle.OnDespawn:Fire()
    end
end

--[[
    Register a body to the vehicle service.<br>
    Used internally.
]]
---@param ID integer
---@param player NoirPlayer|nil
---@param spawnPosition SWMatrix
---@param cost number
---@param fireEvent boolean
---@return NoirBody|nil
function Noir.Services.VehicleService:_RegisterBody(ID, player, spawnPosition, cost, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterBody()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterBody()", "player", player, Noir.Classes.PlayerClass, "nil")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterBody()", "spawnPosition", spawnPosition, "table")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterBody()", "cost", cost, "number")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_RegisterBody()", "fireEvent", fireEvent, "boolean")

    -- Check if already registered
    if self:GetBody(ID) then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to register a body because it's already registered.", false)
        return
    end

    -- Create body
    local body = Noir.Classes.BodyClass:New(ID, player, spawnPosition, cost)
    self.Bodies[body.ID] = body

    -- Save
    self:_SaveBody(body)

    -- Fire event
    if fireEvent then
        self.OnBodySpawn:Fire(body)
    end

    -- Return body
    return body
end

--[[
    Save a body.<br>
    Used internally.
]]
---@param body NoirBody
function Noir.Services.VehicleService:_SaveBody(body)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_SaveBody()", "body", body, Noir.Classes.BodyClass)

    -- Save
    self._SavedBodies[body.ID] = body:_Serialize()
    self:Save("SavedBodies", self._SavedBodies)
end

--[[
    Unsave a body.<br>
    Used internally.
]]
---@param body NoirBody
function Noir.Services.VehicleService:_UnsaveBody(body)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnsaveBody()", "body", body, Noir.Classes.BodyClass)

    -- Unsave
    self._SavedBodies[body.ID] = nil
    self:Save("SavedBodies", self._SavedBodies)
end

--[[
    Load a body internally.<br>
    Used internally.
]]
---@param body NoirBody
---@param fireEvent boolean
function Noir.Services.VehicleService:_LoadBody(body, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_LoadBody()", "body", body, Noir.Classes.BodyClass)
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_LoadBody()", "fireEvent", fireEvent, "boolean")

    -- Check if exists
    if not self:GetBody(body.ID) then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to load a body because it doesn't exist.", false)
        return
    end

    -- Load body
    body.Loaded = true

    -- Save
    self:_SaveBody(body)

    -- Fire event
    if fireEvent then
        body.OnLoad:Fire()
        self.OnBodyLoad:Fire(body)
    end
end

--[[
    Unload a body internally.<br>
    Used internally.
]]
---@param body NoirBody
---@param fireEvent boolean
function Noir.Services.VehicleService:_UnloadBody(body, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnloadBody()", "body", body, Noir.Classes.BodyClass)
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnloadBody()", "fireEvent", fireEvent, "boolean")

    -- Check if exists
    if not self:GetBody(body.ID) then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to unload a body because it doesn't exist.", false)
        return
    end

    -- Unload body
    body.Loaded = false

    -- Save
    self:_SaveBody(body)

    -- Fire event
    if fireEvent then
        body.OnUnload:Fire()
        self.OnBodyUnload:Fire(body)
    end
end

--[[
    Unregister a body from the vehicle service.<br>
    Used internally.
]]
---@param body NoirBody
---@param autoDespawnParentVehicle boolean
---@param fireEvent boolean
function Noir.Services.VehicleService:_UnregisterBody(body, autoDespawnParentVehicle, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnregisterBody()", "body", body, Noir.Classes.BodyClass)
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnregisterBody()", "autoDespawnParentVehicle", autoDespawnParentVehicle, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.VehicleService:_UnregisterBody()", "fireEvent", fireEvent, "boolean")

    -- Check if exists
    if not self:GetBody(body.ID) then
        Noir.Libraries.Logging:Error("VehicleService", "Failed to unregister a body because it doesn't exist.", false)
        return
    end

    -- Remove body
    self.Bodies[body.ID] = nil
    body.ParentVehicle.Bodies[body.ID] = nil

    -- If the parent vehicle has no more bodies, unregister it
    if autoDespawnParentVehicle then
        local bodyCount = Noir.Libraries.Table:Length(body.ParentVehicle.Bodies) -- questionable variable name

        if bodyCount <= 0 then
            self:_UnregisterVehicle(body.ParentVehicle, fireEvent)
        end
    end

    -- Unsave
    self:_UnsaveBody(body)

    -- Fire event
    if fireEvent then
        self.OnBodyDespawn:Fire(body)
        body.OnDespawn:Fire()
    end
end

--[[
    Get a vehicle from the vehicle service.
]]
---@param ID integer
---@return NoirVehicle|nil
function Noir.Services.VehicleService:GetVehicle(ID)
    return self.Vehicles[ID]
end

--[[
    Get a body from the vehicle service.
]]
---@param ID integer
---@return NoirBody|nil
function Noir.Services.VehicleService:GetBody(ID)
    return self.Bodies[ID]
end

--[[
    Get all spawned vehicles.
]]
---@return table<integer, NoirVehicle>
function Noir.Services.VehicleService:GetVehicles()
    return self.Vehicles
end

--[[
    Get all spawned bodies.
]]
---@return table<integer, NoirBody>
function Noir.Services.VehicleService:GetBodies()
    return self.Bodies
end