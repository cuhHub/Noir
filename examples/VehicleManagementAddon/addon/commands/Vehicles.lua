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

-- Create ?vehicles command
local CommandService = Noir.Services:GetService("CommandService") ---@type CommandService
local VehicleService = Noir.Services:GetService("VehicleService") ---@type VehicleService

CommandService:CreateCommand("vehicles", function(player, args)
    -- Get the player's vehicles
    local vehicles = VehicleService:GetVehicles(player)

    -- Send the player their vehicles
    Notifications:SendInfoNotification("Vehicles", "IDs:\n"..table.concat(vehicles, "\n"), player)
end)