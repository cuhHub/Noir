--------------------------------------------------------
-- [Noir] Callbacks
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
    A module of Noir that allows you to attach multiple functions to game callbacks.<br>
    These functions can be disconnected from the game callbacks at any time.

    Noir.Callbacks:Connect("onPlayerJoin", function()
        server.announce("Server", "A player joined!")
    end)

    Noir.Callbacks:Once("onPlayerJoin", function()
        server.announce("Server", "A player joined! (once) This will never be shown again.")
    end)
]]
Noir.Callbacks = {}

--[[
    A table of events assigned to game callbacks.<br>
    Do not directly modify this table.
]]
Noir.Callbacks.Events = {} ---@type table<string, NoirEvent>

--[[
    Connect to a game callback.

    Noir.Callbacks:Connect("onPlayerJoin", function()
        -- Code here
    end)
]]
---@param name string
---@param callback function
---@param hideStartWarning boolean|nil
---@return NoirConnection
---@overload fun(self, name: "onClearOilSpill", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTick", callback: fun(game_ticks: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreate", callback: fun(is_world_create: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onDestroy", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCustomCommand", callback: fun(full_message: string, peer_id: number, is_admin: boolean, is_auth: boolean, command: string, ...: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onChatMessage", callback: fun(peer_id: number, sender_name: string, message: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerJoin", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerSit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerUnsit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterPickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreaturePickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentPickup", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentDrop", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerRespawn", callback: fun(peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerLeave", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onToggleMap", callback: fun(peer_id: number, is_open: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerDie", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleSpawn", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number, group_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onGroupSpawn", callback: fun(group_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDespawn", callback: fun(vehicle_id: integer, peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleLoad", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleUnload", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleTeleport", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectLoad", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectUnload", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onButtonPress", callback: fun(vehicle_id: integer, peer_id: number, button_name: string, is_pressed: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onSpawnAddonComponent", callback: fun(vehicle_or_object_id: integer, component_name: string, type_string: string, addon_index: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDamaged", callback: fun(vehicle_id: integer, damage_amount: number, voxel_x: number, voxel_y: number, voxel_z: number, body_index: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "httpReply", callback: fun(port: number, request: string, reply: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onFireExtinguished", callback: fun(fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireSpawned", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireExtinguished", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTornado", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onMeteor", callback: fun(transform: SWMatrix, magnitude), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTsunami", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onWhirlpool", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVolcano", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onOilSpill", callback: fun(tile_x: number, tile_z: number, delta: number, total: number, vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
function Noir.Callbacks:Connect(name, callback, hideStartWarning)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:Connect()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Callbacks:Connect()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Callbacks:Connect()", "hideStartWarning", hideStartWarning, "boolean", "nil")

    -- Get or create event
    local event = self:_InstantiateCallback(name, hideStartWarning or false)

    -- Connect callback to event
    return event:Connect(callback)
end

--[[
    Connect to a game callback, but disconnect after the game callback has been called.

    Noir.Callbacks:Once("onPlayerJoin", function()
        -- Code here
    end)
]]
---@param name string
---@param callback function
---@param hideStartWarning boolean|nil
---@return NoirConnection
---@overload fun(self, name: "onClearOilSpill", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTick", callback: fun(game_ticks: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreate", callback: fun(is_world_create: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onDestroy", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCustomCommand", callback: fun(full_message: string, peer_id: number, is_admin: boolean, is_auth: boolean, command: string, ...: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onChatMessage", callback: fun(peer_id: number, sender_name: string, message: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerJoin", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerSit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerUnsit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterPickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreaturePickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentPickup", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentDrop", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerRespawn", callback: fun(peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerLeave", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onToggleMap", callback: fun(peer_id: number, is_open: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerDie", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleSpawn", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number, group_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onGroupSpawn", callback: fun(group_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDespawn", callback: fun(vehicle_id: integer, peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleLoad", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleUnload", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleTeleport", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectLoad", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectUnload", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onButtonPress", callback: fun(vehicle_id: integer, peer_id: number, button_name: string, is_pressed: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onSpawnAddonComponent", callback: fun(vehicle_or_object_id: integer, component_name: string, type_string: string, addon_index: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDamaged", callback: fun(vehicle_id: integer, damage_amount: number, voxel_x: number, voxel_y: number, voxel_z: number, body_index: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "httpReply", callback: fun(port: number, request: string, reply: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onFireExtinguished", callback: fun(fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireSpawned", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireExtinguished", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTornado", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onMeteor", callback: fun(transform: SWMatrix, magnitude), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTsunami", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onWhirlpool", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVolcano", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onOilSpill", callback: fun(tile_x: number, tile_z: number, delta: number, total: number, vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
function Noir.Callbacks:Once(name, callback, hideStartWarning)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:Once()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Callbacks:Once()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Callbacks:Once()", "hideStartWarning", hideStartWarning, "boolean", "nil")

    -- Get or create event
    local event = self:_InstantiateCallback(name, hideStartWarning or false)

    -- Connect callback to event
    return event:Once(callback)
end

--[[
    Get a game callback event. These events may not exist if `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` was not called for them.<br>
    It's best to use `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` instead of getting a callback event directly and connecting to it.

    local event = Noir.Callbacks:Get("onPlayerJoin") -- can be nil! use Noir.Callbacks:Connect() or Noir.Callbacks:Once() instead to guarantee an event

    event:Connect(function()
        server.announce("Server", "A player joined!")
    end)
]]
---@param name string
---@return NoirEvent
function Noir.Callbacks:Get(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:Get()", "name", name, "string")

    -- Return
    return self.Events[name]
end

--[[
    Creates an event and an _ENV function for a game callback.<br>
    Used internally, do not use this in your addon.
]]
---@param name string
---@param hideStartWarning boolean
---@return NoirEvent
function Noir.Callbacks:_InstantiateCallback(name, hideStartWarning)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:_InstantiateCallback()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Callbacks:_InstantiateCallback()", "hideStartWarning", hideStartWarning, "boolean")

    -- Check if Noir has started
    if not Noir.HasStarted and not hideStartWarning then
        Noir.Libraries.Logging:Warning("Callbacks", "Noir has not started yet. It is not recommended to connect to callbacks before `Noir:Start()` is called and finalized. Please connect to the `Noir.Started` event and attach to game callbacks in that.")
    end

    -- For later
    local event = Noir.Callbacks.Events[name]

    -- Stop here if the event already exists
    if event then
        return event
    end

    -- Create event if it doesn't exist
    if not event then
        event = Noir.Libraries.Events:Create()
        self.Events[name] = event
    end

    -- Create function for game callback if it doesn't exist. If the user created the callback themselves, overwrite it
    local existing = _ENV[name]

    if existing then
        -- Inform developer that a function for a game callback already exists
        Noir.Libraries.Logging:Warning("Callbacks", "Your addon has a function for the game callback '%s'. Noir will wrap around it to prevent overwriting. Please use `Noir.Callbacks:Connect(\"%s\", function(...) end)` instead of `function %s(...) end` function to avoid this warning.", name, name, name)

        -- Wrap around existing function
        _ENV[name] = function(...)
            existing(...)
            event:Fire(...)
        end
    else
        -- Create function for game callback
        _ENV[name] = function(...)
            event:Fire(...)
        end
    end

    -- Return event
    return event
end