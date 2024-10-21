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
---@field New fun(self: NoirBody, ID: integer, owner: NoirPlayer|nil, spawnPosition: SWMatrix, cost: number, loaded: boolean): NoirBody
---@field ID integer The ID of this body
---@field Owner NoirPlayer|nil The owner of this body, or nil if spawned by an addon OR if the player who owns the body left before Noir starts again (eg: after save load or addon reload)
---@field SpawnPosition SWMatrix The position this body was spawned at
---@field Cost number The cost of this body
---@field ParentVehicle NoirVehicle|nil The vehicle this body belongs to. This can be nil if the body or vehicle is despawned
---@field Loaded boolean Whether or not this body is loaded
---@field Spawned boolean Whether or not this body is spawned. This is set to false when the body is despawned
---@field OnDespawn NoirEvent Fired when this body is despawned
---@field OnLoad NoirEvent Fired when this body is loaded
---@field OnUnload NoirEvent Fired when this body is unloaded
---@field OnDamage NoirEvent Arguments: damage (number), voxelX (number), voxelY (number), voxelZ (number) | Fired when this body is damaged
Noir.Classes.BodyClass = Noir.Class("NoirBody")

--[[
    Initializes body class objects.
]]
---@param ID any
---@param owner NoirPlayer|nil
---@param spawnPosition SWMatrix
---@param cost number
---@param loaded boolean
function Noir.Classes.BodyClass:Init(ID, owner, spawnPosition, cost, loaded)
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "owner", owner, Noir.Classes.PlayerClass, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "spawnPosition", spawnPosition, "table")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "cost", cost, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Init()", "loaded", loaded, "boolean")

    self.ID = math.floor(ID)
    self.Owner = owner
    self.SpawnPosition = spawnPosition
    self.Cost = cost
    self.ParentVehicle = nil
    self.Loaded = loaded
    self.Spawned = true

    self.OnDespawn = Noir.Libraries.Events:Create()
    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
    self.OnDamage = Noir.Libraries.Events:Create()
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
        ParentVehicle = self.ParentVehicle and self.ParentVehicle.ID,
        Loaded = self.Loaded
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
        serializedBody.Cost,
        serializedBody.Loaded
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
    Damage this body at the provided voxel.
]]
---@param damageAmount number
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param radius number
function Noir.Classes.BodyClass:Damage(damageAmount, voxelX, voxelY, voxelZ, radius)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Damage()", "damageAmount", damageAmount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Damage()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Damage()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Damage()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Damage()", "radius", radius, "number")

    -- Add damage
    server.addDamage(self.ID, damageAmount, voxelX, voxelY, voxelZ, radius)
end

--[[
    Makes the body invulnerable/vulnerable to damage.
]]
---@param invulnerable boolean
function Noir.Classes.BodyClass:SetInvulnerable(invulnerable)
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetInvulnerable()", "invulnerable", invulnerable, "boolean")
    server.setVehicleInvulnerable(self.ID, invulnerable)
end

--[[
    Makes the body editable/non-editable (dictates whether or not the body can be brought back to the workbench).
]]
---@param editable boolean
function Noir.Classes.BodyClass:SetEditable(editable)
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetEditable()", "editable", editable, "boolean")
    server.setVehicleEditable(self.ID, editable)
end

--[[
    Teleport the body to the specified position.
]]
---@param position SWMatrix
function Noir.Classes.BodyClass:Teleport(position)
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Teleport()", "position", position, "table")
    server.setVehiclePos(self.ID, position)
end

--[[
    Move the body to the specified position. Essentially teleports the body without reloading it.<br>
    Rotation is ignored.
]]
---@param position SWMatrix
function Noir.Classes.BodyClass:Move(position)
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:Move()", "position", position, "table")
    server.moveVehicle(self.ID, position)
end

--[[
    Set a battery's charge (by name).
]]
---@param batteryName string
---@param amount number
function Noir.Classes.BodyClass:SetBattery(batteryName, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetBattery()", "batteryName", batteryName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetBattery()", "amount", amount, "number")

    -- Set battery
    server.setVehicleBattery(self.ID, batteryName, amount)
end

--[[
    Set a battery's charge (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param amount number
function Noir.Classes.BodyClass:SetBatteryByVoxel(voxelX, voxelY, voxelZ, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetBatteryByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetBatteryByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetBatteryByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetBatteryByVoxel()", "amount", amount, "number")

    -- Set battery
    server.setVehicleBattery(self.ID, voxelX, voxelY, voxelZ, amount)
end

--[[
    Set a hopper's amount (by name).
]]
---@param hopperName string
---@param amount number
---@param resourceType SWResourceTypeEnum
function Noir.Classes.BodyClass:SetHopper(hopperName, amount, resourceType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopper()", "hopperName", hopperName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopper()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopper()", "resourceType", resourceType, "number")

    -- Set hopper
    server.setVehicleHopper(self.ID, hopperName, amount, resourceType)
end

--[[
    Set a hopper's amount (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param amount number
---@param resourceType SWResourceTypeEnum
function Noir.Classes.BodyClass:SetHopperByVoxel(voxelX, voxelY, voxelZ, amount, resourceType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopperByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopperByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopperByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopperByVoxel()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetHopperByVoxel()", "resourceType", resourceType, "number")

    -- Set hopper
    server.setVehicleHopper(self.ID, voxelX, voxelY, voxelZ, amount, resourceType)
end

--[[
    Set a keypad's value (by name).
]]
---@param keypadName string
---@param value number
function Noir.Classes.BodyClass:SetKeypad(keypadName, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetKeypad()", "keypadName", keypadName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetKeypad()", "value", value, "number")

    -- Set keypad
    server.setVehicleKeypad(self.ID, keypadName, value)
end

--[[
    Set a keypad's value (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param value number
function Noir.Classes.BodyClass:SetKeypadByVoxel(voxelX, voxelY, voxelZ, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetKeypadByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetKeypadByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetKeypadByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetKeypadByVoxel()", "value", value, "number")

    -- Set keypad
    server.setVehicleKeypad(self.ID, voxelX, voxelY, voxelZ, value)
end

--[[
    Set a seat's values (by name).
]]
---@param seatName string
---@param axisPitch number
---@param axisRoll number
---@param axisUpDown number
---@param axisYaw number
---@param button1 boolean
---@param button2 boolean
---@param button3 boolean
---@param button4 boolean
---@param button5 boolean
---@param button6 boolean
---@param trigger boolean
function Noir.Classes.BodyClass:SetSeat(seatName, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "seatName", seatName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisPitch", axisPitch, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisRoll", axisRoll, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisUpDown", axisUpDown, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisYaw", axisYaw, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button1", button1, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button2", button2, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button3", button3, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button4", button4, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button5", button5, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button6", button6, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "trigger", trigger, "boolean")

    -- Set seat
    server.setVehicleSeat(self.ID, seatName, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
end

--[[
    Set a seat's values (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param axisPitch number
---@param axisRoll number
---@param axisUpDown number
---@param axisYaw number
---@param button1 boolean
---@param button2 boolean
---@param button3 boolean
---@param button4 boolean
---@param button5 boolean
---@param button6 boolean
---@param trigger boolean
function Noir.Classes.BodyClass:SetSeatByVoxel(voxelX, voxelY, voxelZ, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeatByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeatByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeatByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisPitch", axisPitch, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisRoll", axisRoll, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisUpDown", axisUpDown, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "axisYaw", axisYaw, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button1", button1, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button2", button2, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button3", button3, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button4", button4, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button5", button5, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "button6", button6, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetSeat()", "trigger", trigger, "boolean")

    -- Set seat
    server.setVehicleSeat(self.ID, voxelX, voxelY, voxelZ, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
end

--[[
    Set a weapon's ammo count (by name).
]]
---@param weaponName string
---@param amount number
function Noir.Classes.BodyClass:SetWeapon(weaponName, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetWeapon()", "weaponName", weaponName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetWeapon()", "amount", amount, "number")

    -- Set weapon
    server.setVehicleWeapon(self.ID, weaponName, amount)
end

--[[
    Set a weapon's ammo count (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param amount number
function Noir.Classes.BodyClass:SetWeaponByVoxel(voxelX, voxelY, voxelZ, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetWeaponByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetWeaponByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetWeaponByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetWeaponByVoxel()", "amount", amount, "number")

    -- Set weapon
    server.setVehicleWeapon(self.ID, voxelX, voxelY, voxelZ, amount)
end

--[[
    Set this body's transponder activity.
]]
---@param isActive boolean
function Noir.Classes.BodyClass:SetTransponder(isActive)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTransponder()", "isActive", isActive, "boolean")

    -- Set transponder
    server.setVehicleTransponder(self.ID, isActive)
end

--[[
    Set a tank's contents (by name).
]]
---@param tankName string
---@param amount number
---@param fluidType SWTankFluidTypeEnum
function Noir.Classes.BodyClass:SetTank(tankName, amount, fluidType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTank()", "tankName", tankName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTank()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTank()", "fluidType", fluidType, "number")

    -- Set tank
    server.setVehicleTank(self.ID, tankName, amount, fluidType)
end

--[[
    Set a tank's contents (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param amount number
---@param fluidType SWTankFluidTypeEnum
function Noir.Classes.BodyClass:SetTankByVoxel(voxelX, voxelY, voxelZ, amount, fluidType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTankByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTankByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTankByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTankByVoxel()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTankByVoxel()", "fluidType", fluidType, "number")

    -- Set tank
    server.setVehicleTank(self.ID, voxelX, voxelY, voxelZ, amount, fluidType)
end

--[[
    Set whether or not this body is shown on the map.
]]
---@param isShown boolean
function Noir.Classes.BodyClass:SetShowOnMap(isShown)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetShowOnMap()", "isShown", isShown, "boolean")

    -- Set show on map
    server.setVehicleShowOnMap(self.ID, isShown)
end

--[[
    Reset this body's state.
]]
function Noir.Classes.BodyClass:ResetState()
    server.resetVehicleState(self.ID)
end

--[[
    Set this body's tooltip.
]]
---@param tooltip string
function Noir.Classes.BodyClass:SetTooltip(tooltip)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:SetTooltip()", "tooltip", tooltip, "string")

    -- Set tooltip
    server.setVehicleTooltip(self.ID, tooltip)
end

--[[
    Get a battey's data (by name).
]]
---@param batteryName string
---@return SWVehicleBatteryData|nil
function Noir.Classes.BodyClass:GetBattery(batteryName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetBattery()", "batteryName", batteryName, "string")

    -- Get battery
    return (server.getVehicleBattery(self.ID, batteryName))
end

--[[
    Get a battey's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleBatteryData|nil
function Noir.Classes.BodyClass:GetBatteryByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetBatteryByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetBatteryByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetBatteryByVoxel()", "voxelZ", voxelZ, "number")

    -- Get battery
    return (server.getVehicleBattery(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a button's data (by name).
]]
---@param buttonName string
---@return SWVehicleButtonData|nil
function Noir.Classes.BodyClass:GetButton(buttonName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetButton()", "buttonName", buttonName, "string")

    -- Get button
    return (server.getVehicleButton(self.ID, buttonName))
end

--[[
    Get a button's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleButtonData|nil
function Noir.Classes.BodyClass:GetButtonByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetButtonByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetButtonByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetButtonByVoxel()", "voxelZ", voxelZ, "number")

    -- Get button
    return (server.getVehicleButton(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get this body's components.
]]
---@return SWLoadedVehicleData|nil
function Noir.Classes.BodyClass:GetComponents()
    -- Get components
    return (server.getVehicleComponents(self.ID))
end

--[[
    Get this body's data.
]]
---@return SWVehicleData|nil
function Noir.Classes.BodyClass:GetData()
    -- Get data
    return (server.getVehicleData(self.ID))
end

--[[
    Get a dial's data (by name).
]]
---@param dialName string
---@return SWVehicleDialData|nil
function Noir.Classes.BodyClass:GetDial(dialName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetDial()", "dialName", dialName, "string")

    -- Get dial
    return (server.getVehicleDial(self.ID, dialName))
end

--[[
    Get a dial's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleDialData|nil
function Noir.Classes.BodyClass:GetDialByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetDialByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetDialByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetDialByVoxel()", "voxelZ", voxelZ, "number")

    -- Get dial
    return (server.getVehicleDial(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Returns the number of surfaces that are on fire.
]]
---@return integer|nil
function Noir.Classes.BodyClass:GetFireCount()
    -- Get fire count
    return (server.getVehicleFireCount(self.ID))
end

--[[
    Get a hopper's data (by name).
]]
---@param hopperName string
---@return SWVehicleHopperData|nil
function Noir.Classes.BodyClass:GetHopper(hopperName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetHopper()", "hopperName", hopperName, "string")

    -- Get hopper
    return (server.getVehicleHopper(self.ID, hopperName))
end

--[[
    Get a hopper's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleHopperData|nil
function Noir.Classes.BodyClass:GetHopperByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetHopperByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetHopperByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetHopperByVoxel()", "voxelZ", voxelZ, "number")

    -- Get hopper
    return (server.getVehicleHopper(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a rope hook's data (by name).
]]
---@param hookName string
---@return SWVehicleRopeHookData|nil
function Noir.Classes.BodyClass:GetRopeHook(hookName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetRopeHook()", "hookName", hookName, "string")

    -- Get rope hook
    return (server.getVehicleRopeHook(self.ID, hookName))
end

--[[
    Get a rope hook's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleRopeHookData|nil
function Noir.Classes.BodyClass:GetRopeHookByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetRopeHookByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetRopeHookByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetRopeHookByVoxel()", "voxelZ", voxelZ, "number")

    -- Get rope hook
    return (server.getVehicleRopeHook(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a seat's data (by name).
]]
---@param seatName string
---@return SWVehicleSeatData|nil
function Noir.Classes.BodyClass:GetSeat(seatName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSeat()", "seatName", seatName, "string")

    -- Get seat
    return (server.getVehicleSeat(self.ID, seatName))
end

--[[
    Get a seat's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleSeatData|nil
function Noir.Classes.BodyClass:GetSeatByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSeatByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSeatByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSeatByVoxel()", "voxelZ", voxelZ, "number")

    -- Get seat
    return (server.getVehicleSeat(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a sign's data (by name).
]]
---@param signName string
---@return SWVehicleSignData|nil
function Noir.Classes.BodyClass:GetSign(signName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSign()", "signName", signName, "string")

    -- Get sign
    return (server.getVehicleSign(self.ID, signName))
end

--[[
    Get a sign's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleSignData|nil
function Noir.Classes.BodyClass:GetSignByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSignByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSignByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetSignByVoxel()", "voxelZ", voxelZ, "number")

    -- Get sign
    return (server.getVehicleSign(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a tank's data (by name).
]]
---@param tankName string
---@return SWVehicleTankData|nil
function Noir.Classes.BodyClass:GetTank(tankName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetTank()", "tankName", tankName, "string")

    -- Get tank
    return (server.getVehicleTank(self.ID, tankName))
end

--[[
    Get a tank's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleTankData|nil
function Noir.Classes.BodyClass:GetTankByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetTankByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetTankByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetTankByVoxel()", "voxelZ", voxelZ, "number")

    -- Get tank
    return (server.getVehicleTank(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a weapon's data (by name).
]]
---@param weaponName string
---@return SWVehicleWeaponData|nil
function Noir.Classes.BodyClass:GetWeapon(weaponName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetWeapon()", "weaponName", weaponName, "string")

    -- Get weapon
    return (server.getVehicleWeapon(self.ID, weaponName))
end

--[[
    Get a weapon's data (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@return SWVehicleWeaponData|nil
function Noir.Classes.BodyClass:GetWeaponByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetWeaponByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetWeaponByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:GetWeaponByVoxel()", "voxelZ", voxelZ, "number")

    -- Get weapon
    return (server.getVehicleWeapon(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Presses a button on this body (by name).
]]
---@param buttonName string
function Noir.Classes.BodyClass:PressButton(buttonName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:PressButton()", "buttonName", buttonName, "string")

    -- Press button
    server.pressVehicleButton(self.ID, buttonName)
end

--[[
    Presses a button on this body (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
function Noir.Classes.BodyClass:PressButtonByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:PressButtonByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:PressButtonByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.BodyClass:PressButtonByVoxel()", "voxelZ", voxelZ, "number")

    -- Press button
    server.pressVehicleButton(self.ID, voxelX, voxelY, voxelZ)
end

--[[
    Despawn the body.
]]
function Noir.Classes.BodyClass:Despawn()
    server.despawnVehicle(self.ID, true)
end

--[[
    Returns whether or not the body exists.
]]
---@return boolean
function Noir.Classes.BodyClass:Exists()
    local _, exists = server.getVehicleSimulating(self.ID)
    return exists
end

--[[
    Returns whether or not the body is simulating.
]]
---@return boolean
function Noir.Classes.BodyClass:IsSimulating()
    local simulating, success = server.getVehicleSimulating(self.ID)
    return simulating and success
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of the NoirBody class.
]]
---@class NoirSerializedBody
---@field ID integer
---@field Owner integer
---@field SpawnPosition SWMatrix
---@field Cost number
---@field ParentVehicle integer
---@field Loaded boolean