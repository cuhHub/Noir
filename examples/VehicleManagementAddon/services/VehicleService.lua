--------------------------------------------------------
-- [Noir] Example - Vehicle Management Addon
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

---@alias PlayerVehicles table<integer, boolean>

-- Create the service
---@class VehicleService: NoirService
---@field vehicles table<NoirPlayer, PlayerVehicles> A table containing vehicles belonging to a player
---@field onSpawn NoirEvent An event that fires when a vehicle spawns. Args: player, vehicle_id
---@field onDespawn NoirEvent An event that fires when a vehicle despawns. Args: player, vehicle_id
local VehicleService = Noir.Services:CreateService("VehicleService")

-- Called when the service is initialized. This is to be used for setting up the service
function VehicleService:ServiceInit()
    self.vehicles = {}

    self.onSpawn = Noir.Libraries.Events:Create()
    self.onDespawn = Noir.Libraries.Events:Create()
end

-- Called when the service is started and when we can safely get other services. This is to be used for setting up things that may require event connections, etc
function VehicleService:ServiceStart()
    -- Listen for vehicles spawning
    Noir.Callbacks:Connect("onVehicleSpawn", function(vehicle_id, peer_id)
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Info("VehicleService", "Player doesn't exist for a vehicle that was spawned")
            return
        end

        if not self.vehicles[player] then
            self.vehicles[player] = {}
        end

        table.insert(self.vehicles[player], vehicle_id)
        self.onSpawn:Fire(player, vehicle_id)
    end)

    -- Listen for vehicles despawning
    Noir.Callbacks:Connect("onVehicleDespawn", function(vehicle_id, peer_id)
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Info("VehicleService", "Player doesn't exist for a vehicle that was despawned")
            return
        end

        if not self.vehicles[player] then
            return
        end

        self.vehicles[player][vehicle_id] = nil
        self.onDespawn:Fire(player, vehicle_id)
    end)
end

-- Get the vehicles belonging to a player
---@param player NoirPlayer
---@return table<integer, integer>
function VehicleService:GetVehicles(player)
    return Noir.Libraries.Table:Keys(self.vehicles[player] or {})
end

-- Get the player a vehicle belongs to
---@param vehicle_id integer
function VehicleService:GetPlayer(vehicle_id)
    for player, vehicles in pairs(self.vehicles) do
        if vehicles[vehicle_id] then
            return player
        end
    end
end

-- Despawn all vehicles belonging to a player
---@param player NoirPlayer
function VehicleService:DespawnVehicles(player)
    for _, vehicle_id in pairs(self:GetVehicles(player)) do
        self:DespawnVehicle(vehicle_id)
    end
end

-- Despawn a vehicle
---@param vehicle_id integer
function VehicleService:DespawnVehicle(vehicle_id)
    server.despawnVehicle(vehicle_id, true)
end