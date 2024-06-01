--------------------------------------------------------
-- [Noir] Example - Vehicle Management Addon
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

---@alias PlayerVehicles table<integer, boolean>

---@class VehicleService: NoirService
---@field vehicles table<integer, PlayerVehicles> A table containing vehicles belonging to a player
---@field onSpawn NoirEvent An event that fires when a vehicle spawns. Args: peer_id, vehicle_id
---@field onDespawn NoirEvent An event that fires when a vehicle despawns. Args: peer_id, vehicle_id
---
---@field GetVehicles fun(self: VehicleService, peer_id: integer): table<integer, integer> A method that returns the vehicles belonging to a player
---@field GetPlayer fun(self: VehicleService, vehicle_id: integer): integer|nil A method that returns the peer_id of the player a vehicle belongs to
---@field DespawnVehicles fun(self: VehicleService, peer_id: integer) A method that despawns all vehicles belonging to a player
---@field DespawnVehicle fun(self: VehicleService, vehicle_id: integer) A method that despawns a vehicle

-- Create the service
local VehicleService = Noir.Services:CreateService("VehicleService") ---@type VehicleService

-- Called when the service is initialized. This is to be used for setting up the service
function VehicleService:ServiceInit()
    self.vehicles = {}

    self.onSpawn = Noir.Libraries.Events:Create()
    self.onDespawn = Noir.Libraries.Events:Create()
end

-- Called when the service is started and when we can safely get other services. This is to be used for setting up things that may require event connections, etc
function VehicleService:ServiceStart()
    -- Listen for vehicles spawning
    server.listen("onVehicleSpawn", function(vehicle_id, peer_id)
        if not self.vehicles[peer_id] then
            self.vehicles[peer_id] = {}
        end

        table.insert(self.vehicles[peer_id], vehicle_id)
        self.onSpawn:Fire(peer_id, vehicle_id)
    end)

    -- Listen for vehicles despawning
    server.listen("onVehicleDespawn", function(vehicle_id, peer_id)
        if not self.vehicles[peer_id] then
            return
        end

        self.vehicles[peer_id][vehicle_id] = nil
        self.onDespawn:Fire(peer_id, vehicle_id)
    end)
end

-- Get the vehicles belonging to a player
function VehicleService:GetVehicles(peer_id)
    return Noir.Libraries.Table:Keys(self.vehicles[peer_id] or {})
end

-- Get the player a vehicle belongs to
function VehicleService:GetPlayer(vehicle_id)
    for peer_id, vehicles in pairs(self.vehicles) do
        if vehicles[vehicle_id] then
            return peer_id
        end
    end
end

-- Despawn all vehicles belonging to a player
function VehicleService:DespawnVehicles(peer_id)
    for _, vehicle_id in pairs(self:GetVehicles(peer_id)) do
        self:DespawnVehicle(vehicle_id)
    end
end

-- Despawn a vehicle
function VehicleService:DespawnVehicle(vehicle_id)
    server.despawnVehicle(vehicle_id, true)
end