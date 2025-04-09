--------------------------------------------------------
-- [Noir] Classes - Body
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
    Represents a body which is apart of a vehicle.<br>
    In Stormworks, this is actually a vehicle apart of a vehicle group.
]]
---@class NoirBody: NoirClass
---@field New fun(self: NoirBody, ID: integer, owner: NoirPlayer|nil, loaded: boolean): NoirBody
---@field ID integer The ID of this body
---@field Owner NoirPlayer|nil The owner of this body, or nil if spawned by an addon OR if the player who owns the body left before Noir starts again (eg: after save load or addon reload)
---@field ParentVehicle NoirVehicle|nil The vehicle this body belongs to. This can be nil if the body or vehicle is despawned
---@field Loaded boolean Whether or not this body is loaded
---@field Spawned boolean Whether or not this body is spawned. This is set to false when the body is despawned
---@field OnDespawn NoirEvent Fired when this body is despawned
---@field OnLoad NoirEvent Fired when this body is loaded
---@field OnUnload NoirEvent Fired when this body is unloaded
---@field OnDamage NoirEvent Arguments: damage (number), voxelX (number), voxelY (number), voxelZ (number) | Fired when this body is damaged
Noir.Classes.Body = Noir.Class("Body")

--[[
    Initializes body class objects.
]]
---@param ID any
---@param owner NoirPlayer|nil
---@param loaded boolean
function Noir.Classes.Body:Init(ID, owner, loaded)
    Noir.TypeChecking:Assert("Noir.Classes.Body:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:Init()", "owner", owner, Noir.Classes.Player, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Body:Init()", "loaded", loaded, "boolean")

    self.ID = math.floor(ID)
    self.Owner = owner
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
function Noir.Classes.Body:_Serialize()
    return {
        ID = self.ID,
        Owner = self.Owner and self.Owner.ID,
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
---@return NoirBody
function Noir.Classes.Body:_Deserialize(serializedBody, setParentVehicle)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:_Deserialize()", "serializedBody", serializedBody, "table")
    Noir.TypeChecking:Assert("Noir.Classes.Body:_Deserialize()", "setParentVehicle", setParentVehicle, "boolean", "nil")

    -- Deserialize
    local body = self:New(
        serializedBody.ID,
        serializedBody.Owner and Noir.Services.PlayerService:GetPlayer(serializedBody.Owner),
        serializedBody.Loaded
    )

    -- Set parent vehicle
    if setParentVehicle and serializedBody.ParentVehicle then
        local parentVehicle = Noir.Services.VehicleService:GetVehicle(serializedBody.ParentVehicle)

        if not parentVehicle then
            error("Noir.Classes.Body:_Deserialize()", "Could not find parent vehicle for a deserialized body.")
        end

        body.ParentVehicle = parentVehicle
    end

    -- Return body
    return body
end

--[[
    Returns the name of the body, or nil if there is none (relies on map icon component)
]]
---@return string|nil
function Noir.Classes.Body:GetName()
    local data = self:GetData()

    if not data then
        return
    end

    if data.name == "" then
        return
    end

    return data.name
end

--[[
    Returns the position of this body.
]]
---@param voxelX integer|nil
---@param voxelY integer|nil
---@param voxelZ integer|nil
function Noir.Classes.Body:GetPosition(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetPosition()", "voxelX", voxelX, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetPosition()", "voxelY", voxelY, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetPosition()", "voxelZ", voxelZ, "number", "nil")

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
function Noir.Classes.Body:Damage(damageAmount, voxelX, voxelY, voxelZ, radius)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:Damage()", "damageAmount", damageAmount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:Damage()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:Damage()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:Damage()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:Damage()", "radius", radius, "number")

    -- Add damage
    server.addDamage(self.ID, damageAmount, voxelX, voxelY, voxelZ, radius)
end

--[[
    Makes the body invulnerable/vulnerable to damage.
]]
---@param invulnerable boolean
function Noir.Classes.Body:SetInvulnerable(invulnerable)
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetInvulnerable()", "invulnerable", invulnerable, "boolean")
    server.setVehicleInvulnerable(self.ID, invulnerable)
end

--[[
    Makes the body editable/non-editable (dictates whether or not the body can be brought back to the workbench).
]]
---@param editable boolean
function Noir.Classes.Body:SetEditable(editable)
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetEditable()", "editable", editable, "boolean")
    server.setVehicleEditable(self.ID, editable)
end

--[[
    Teleport the body to the specified position.
]]
---@param position SWMatrix
function Noir.Classes.Body:Teleport(position)
    Noir.TypeChecking:Assert("Noir.Classes.Body:Teleport()", "position", position, "table")
    server.setVehiclePos(self.ID, position)
end

--[[
    Move the body to the specified position. Essentially teleports the body without reloading it.<br>
    Rotation is ignored.
]]
---@param position SWMatrix
function Noir.Classes.Body:Move(position)
    Noir.TypeChecking:Assert("Noir.Classes.Body:Move()", "position", position, "table")
    server.moveVehicle(self.ID, position)
end

--[[
    Set a battery's charge (by name).
]]
---@param batteryName string
---@param amount number
function Noir.Classes.Body:SetBattery(batteryName, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetBattery()", "batteryName", batteryName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetBattery()", "amount", amount, "number")

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
function Noir.Classes.Body:SetBatteryByVoxel(voxelX, voxelY, voxelZ, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetBatteryByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetBatteryByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetBatteryByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetBatteryByVoxel()", "amount", amount, "number")

    -- Set battery
    server.setVehicleBattery(self.ID, voxelX, voxelY, voxelZ, amount)
end

--[[
    Set a hopper's amount (by name).
]]
---@param hopperName string
---@param amount number
---@param resourceType SWResourceTypeEnum
function Noir.Classes.Body:SetHopper(hopperName, amount, resourceType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopper()", "hopperName", hopperName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopper()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopper()", "resourceType", resourceType, "number")

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
function Noir.Classes.Body:SetHopperByVoxel(voxelX, voxelY, voxelZ, amount, resourceType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopperByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopperByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopperByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopperByVoxel()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetHopperByVoxel()", "resourceType", resourceType, "number")

    -- Set hopper
    server.setVehicleHopper(self.ID, voxelX, voxelY, voxelZ, amount, resourceType)
end

--[[
    Set a keypad's value (by name).
]]
---@param keypadName string
---@param value number
function Noir.Classes.Body:SetKeypad(keypadName, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetKeypad()", "keypadName", keypadName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetKeypad()", "value", value, "number")

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
function Noir.Classes.Body:SetKeypadByVoxel(voxelX, voxelY, voxelZ, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetKeypadByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetKeypadByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetKeypadByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetKeypadByVoxel()", "value", value, "number")

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
function Noir.Classes.Body:SetSeat(seatName, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "seatName", seatName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisPitch", axisPitch, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisRoll", axisRoll, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisUpDown", axisUpDown, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisYaw", axisYaw, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button1", button1, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button2", button2, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button3", button3, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button4", button4, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button5", button5, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button6", button6, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "trigger", trigger, "boolean")

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
function Noir.Classes.Body:SetSeatByVoxel(voxelX, voxelY, voxelZ, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeatByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeatByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeatByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisPitch", axisPitch, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisRoll", axisRoll, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisUpDown", axisUpDown, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "axisYaw", axisYaw, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button1", button1, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button2", button2, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button3", button3, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button4", button4, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button5", button5, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "button6", button6, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetSeat()", "trigger", trigger, "boolean")

    -- Set seat
    server.setVehicleSeat(self.ID, voxelX, voxelY, voxelZ, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
end

--[[
    Set a weapon's ammo count (by name).
]]
---@param weaponName string
---@param amount number
function Noir.Classes.Body:SetWeapon(weaponName, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetWeapon()", "weaponName", weaponName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetWeapon()", "amount", amount, "number")

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
function Noir.Classes.Body:SetWeaponByVoxel(voxelX, voxelY, voxelZ, amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetWeaponByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetWeaponByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetWeaponByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetWeaponByVoxel()", "amount", amount, "number")

    -- Set weapon
    server.setVehicleWeapon(self.ID, voxelX, voxelY, voxelZ, amount)
end

--[[
    Set this body's transponder activity.
]]
---@param isActive boolean
function Noir.Classes.Body:SetTransponder(isActive)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTransponder()", "isActive", isActive, "boolean")

    -- Set transponder
    server.setVehicleTransponder(self.ID, isActive)
end

--[[
    Set a tank's contents (by name).
]]
---@param tankName string
---@param amount number
---@param fluidType SWTankFluidTypeEnum
function Noir.Classes.Body:SetTank(tankName, amount, fluidType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTank()", "tankName", tankName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTank()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTank()", "fluidType", fluidType, "number")

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
function Noir.Classes.Body:SetTankByVoxel(voxelX, voxelY, voxelZ, amount, fluidType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTankByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTankByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTankByVoxel()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTankByVoxel()", "amount", amount, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTankByVoxel()", "fluidType", fluidType, "number")

    -- Set tank
    server.setVehicleTank(self.ID, voxelX, voxelY, voxelZ, amount, fluidType)
end

--[[
    Set whether or not this body is shown on the map.
]]
---@param isShown boolean
function Noir.Classes.Body:SetShowOnMap(isShown)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetShowOnMap()", "isShown", isShown, "boolean")

    -- Set show on map
    server.setVehicleShowOnMap(self.ID, isShown)
end

--[[
    Reset this body's state.
]]
function Noir.Classes.Body:ResetState()
    server.resetVehicleState(self.ID)
end

--[[
    Set this body's tooltip.
]]
---@param tooltip string
function Noir.Classes.Body:SetTooltip(tooltip)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SetTooltip()", "tooltip", tooltip, "string")

    -- Set tooltip
    server.setVehicleTooltip(self.ID, tooltip)
end

--[[
    Get a battey's data (by name).
]]
---@param batteryName string
---@return SWVehicleBatteryData|nil
function Noir.Classes.Body:GetBattery(batteryName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetBattery()", "batteryName", batteryName, "string")

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
function Noir.Classes.Body:GetBatteryByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetBatteryByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetBatteryByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetBatteryByVoxel()", "voxelZ", voxelZ, "number")

    -- Get battery
    return (server.getVehicleBattery(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a button's data (by name).
]]
---@param buttonName string
---@return SWVehicleButtonData|nil
function Noir.Classes.Body:GetButton(buttonName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetButton()", "buttonName", buttonName, "string")

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
function Noir.Classes.Body:GetButtonByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetButtonByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetButtonByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetButtonByVoxel()", "voxelZ", voxelZ, "number")

    -- Get button
    return (server.getVehicleButton(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get this body's components.
]]
---@return SWLoadedVehicleData|nil
function Noir.Classes.Body:GetComponents()
    -- Get components
    return (server.getVehicleComponents(self.ID))
end

--[[
    Get this body's data.
]]
---@return SWVehicleData|nil
function Noir.Classes.Body:GetData()
    -- Get data
    return (server.getVehicleData(self.ID))
end

--[[
    Get a dial's data (by name).
]]
---@param dialName string
---@return SWVehicleDialData|nil
function Noir.Classes.Body:GetDial(dialName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetDial()", "dialName", dialName, "string")

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
function Noir.Classes.Body:GetDialByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetDialByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetDialByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetDialByVoxel()", "voxelZ", voxelZ, "number")

    -- Get dial
    return (server.getVehicleDial(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Returns the number of surfaces that are on fire.
]]
---@return integer|nil
function Noir.Classes.Body:GetFireCount()
    -- Get fire count
    return (server.getVehicleFireCount(self.ID))
end

--[[
    Get a hopper's data (by name).
]]
---@param hopperName string
---@return SWVehicleHopperData|nil
function Noir.Classes.Body:GetHopper(hopperName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetHopper()", "hopperName", hopperName, "string")

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
function Noir.Classes.Body:GetHopperByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetHopperByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetHopperByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetHopperByVoxel()", "voxelZ", voxelZ, "number")

    -- Get hopper
    return (server.getVehicleHopper(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a rope hook's data (by name).
]]
---@param hookName string
---@return SWVehicleRopeHookData|nil
function Noir.Classes.Body:GetRopeHook(hookName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetRopeHook()", "hookName", hookName, "string")

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
function Noir.Classes.Body:GetRopeHookByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetRopeHookByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetRopeHookByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetRopeHookByVoxel()", "voxelZ", voxelZ, "number")

    -- Get rope hook
    return (server.getVehicleRopeHook(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a seat's data (by name).
]]
---@param seatName string
---@return SWVehicleSeatData|nil
function Noir.Classes.Body:GetSeat(seatName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSeat()", "seatName", seatName, "string")

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
function Noir.Classes.Body:GetSeatByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSeatByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSeatByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSeatByVoxel()", "voxelZ", voxelZ, "number")

    -- Get seat
    return (server.getVehicleSeat(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a sign's data (by name).
]]
---@param signName string
---@return SWVehicleSignData|nil
function Noir.Classes.Body:GetSign(signName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSign()", "signName", signName, "string")

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
function Noir.Classes.Body:GetSignByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSignByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSignByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetSignByVoxel()", "voxelZ", voxelZ, "number")

    -- Get sign
    return (server.getVehicleSign(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a tank's data (by name).
]]
---@param tankName string
---@return SWVehicleTankData|nil
function Noir.Classes.Body:GetTank(tankName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetTank()", "tankName", tankName, "string")

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
function Noir.Classes.Body:GetTankByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetTankByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetTankByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetTankByVoxel()", "voxelZ", voxelZ, "number")

    -- Get tank
    return (server.getVehicleTank(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Get a weapon's data (by name).
]]
---@param weaponName string
---@return SWVehicleWeaponData|nil
function Noir.Classes.Body:GetWeapon(weaponName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetWeapon()", "weaponName", weaponName, "string")

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
function Noir.Classes.Body:GetWeaponByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetWeaponByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetWeaponByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:GetWeaponByVoxel()", "voxelZ", voxelZ, "number")

    -- Get weapon
    return (server.getVehicleWeapon(self.ID, voxelX, voxelY, voxelZ))
end

--[[
    Presses a button on this body (by name).
]]
---@param buttonName string
function Noir.Classes.Body:PressButton(buttonName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:PressButton()", "buttonName", buttonName, "string")

    -- Press button
    server.pressVehicleButton(self.ID, buttonName)
end

--[[
    Presses a button on this body (by voxel).
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
function Noir.Classes.Body:PressButtonByVoxel(voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:PressButtonByVoxel()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:PressButtonByVoxel()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:PressButtonByVoxel()", "voxelZ", voxelZ, "number")

    -- Press button
    server.pressVehicleButton(self.ID, voxelX, voxelY, voxelZ)
end

--[[
    Spawns a rope connected by a hook on this body to a hook on another (or this) body.
]]
---@param voxelX integer
---@param voxelY integer
---@param voxelZ integer
---@param targetBody NoirBody|nil nil = this body
---@param targetVoxelX integer
---@param targetVoxelY integer
---@param targetVoxelZ integer
---@param length number
---@param ropeType SWRopeTypeEnum
function Noir.Classes.Body:SpawnRopeHook(voxelX, voxelY, voxelZ, targetBody, targetVoxelX, targetVoxelY, targetVoxelZ, length, ropeType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "voxelX", voxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "voxelY", voxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "voxelZ", voxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "targetBody", targetBody, Noir.Classes.Body, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "targetVoxelX", targetVoxelX, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "targetVoxelY", targetVoxelY, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "targetVoxelZ", targetVoxelZ, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "length", length, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Body:SpawnRopeHook()", "ropeType", ropeType, "number")

    -- Spawn rope hook
    server.spawnVehicleRope(
        self.ID,
        voxelX,
        voxelY,
        voxelZ,
        targetBody and targetBody.ID or self.ID,
        targetVoxelX,
        targetVoxelY,
        targetVoxelZ,
        length,
        ropeType
    )
end

--[[
    Despawn the body.
]]
function Noir.Classes.Body:Despawn()
    server.despawnVehicle(self.ID, true)
end

--[[
    Sets the AI team of this body. Useful for AI targeting different bodies depending on team.
]]
---@param team SWAITeamEnum
function Noir.Classes.Body:SetAITeam(team)
    Noir.TypeChecking:Assert("Noir.Classes.Object:SetAITeam()", "team", team, "number")
    server.setAIVehicleTeam(self.ID, team)
end

--[[
    Returns whether or not the body exists.
]]
---@return boolean
function Noir.Classes.Body:Exists()
    local _, exists = server.getVehicleSimulating(self.ID)
    return exists
end

--[[
    Returns whether or not the body is simulating.
]]
---@return boolean
function Noir.Classes.Body:IsSimulating()
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
---@field ParentVehicle integer
---@field Loaded boolean