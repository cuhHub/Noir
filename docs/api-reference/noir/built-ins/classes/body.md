# Body

**Noir.Classes.Body**: `NoirClass`

Represents a body which is apart of a vehicle.

In Stormworks, this is actually a vehicle apart of a vehicle group.

---

```lua
Noir.Classes.Body:Init(ID, owner, loaded)
```
Initializes body class objects.

### Parameters
- `ID`: any
- `owner`: NoirPlayer|nil
- `loaded`: boolean

---

```lua
Noir.Classes.Body:_Serialize()
```
Serialize the body.

Used internally.

### Returns
- `NoirSerializedBody`

---

```lua
Noir.Classes.Body:_Deserialize(serializedBody, setParentVehicle)
```
Deserialize the body.

Used internally.

### Parameters
- `serializedBody`: NoirSerializedBody
- `setParentVehicle`: boolean|nil
### Returns
- `NoirBody`

---

```lua
Noir.Classes.Body:GetName()
```
Returns the name of the body, or nil if there is none (relies on map icon component)

### Returns
- `string|nil`

---

```lua
Noir.Classes.Body:GetPosition(voxelX, voxelY, voxelZ)
```
Returns the position of this body.

### Parameters
- `voxelX`: integer|nil
- `voxelY`: integer|nil
- `voxelZ`: integer|nil

---

```lua
Noir.Classes.Body:Damage(damageAmount, voxelX, voxelY, voxelZ, radius)
```
Damage this body at the provided voxel.

### Parameters
- `damageAmount`: number
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `radius`: number

---

```lua
Noir.Classes.Body:SetInvulnerable(invulnerable)
```
Makes the body invulnerable/vulnerable to damage.

### Parameters
- `invulnerable`: boolean

---

```lua
Noir.Classes.Body:SetEditable(editable)
```
Makes the body editable/non-editable (dictates whether or not the body can be brought back to the workbench).

### Parameters
- `editable`: boolean

---

```lua
Noir.Classes.Body:Teleport(position)
```
Teleport the body to the specified position.

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.Body:Move(position)
```
Move the body to the specified position. Essentially teleports the body without reloading it.

Rotation is ignored.

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.Body:SetBattery(batteryName, amount)
```
Set a battery's charge (by name).

### Parameters
- `batteryName`: string
- `amount`: number

---

```lua
Noir.Classes.Body:SetBatteryByVoxel(voxelX, voxelY, voxelZ, amount)
```
Set a battery's charge (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `amount`: number

---

```lua
Noir.Classes.Body:SetHopper(hopperName, amount, resourceType)
```
Set a hopper's amount (by name).

### Parameters
- `hopperName`: string
- `amount`: number
- `resourceType`: SWResourceTypeEnum

---

```lua
Noir.Classes.Body:SetHopperByVoxel(voxelX, voxelY, voxelZ, amount, resourceType)
```
Set a hopper's amount (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `amount`: number
- `resourceType`: SWResourceTypeEnum

---

```lua
Noir.Classes.Body:SetKeypad(keypadName, value)
```
Set a keypad's value (by name).

### Parameters
- `keypadName`: string
- `value`: number

---

```lua
Noir.Classes.Body:SetKeypadByVoxel(voxelX, voxelY, voxelZ, value)
```
Set a keypad's value (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `value`: number

---

```lua
Noir.Classes.Body:SetSeat(seatName, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
```
Set a seat's values (by name).

### Parameters
- `seatName`: string
- `axisPitch`: number
- `axisRoll`: number
- `axisUpDown`: number
- `axisYaw`: number
- `button1`: boolean
- `button2`: boolean
- `button3`: boolean
- `button4`: boolean
- `button5`: boolean
- `button6`: boolean
- `trigger`: boolean

---

```lua
Noir.Classes.Body:SetSeatByVoxel(voxelX, voxelY, voxelZ, axisPitch, axisRoll, axisUpDown, axisYaw, button1, button2, button3, button4, button5, button6, trigger)
```
Set a seat's values (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `axisPitch`: number
- `axisRoll`: number
- `axisUpDown`: number
- `axisYaw`: number
- `button1`: boolean
- `button2`: boolean
- `button3`: boolean
- `button4`: boolean
- `button5`: boolean
- `button6`: boolean
- `trigger`: boolean

---

```lua
Noir.Classes.Body:SetWeapon(weaponName, amount)
```
Set a weapon's ammo count (by name).

### Parameters
- `weaponName`: string
- `amount`: number

---

```lua
Noir.Classes.Body:SetWeaponByVoxel(voxelX, voxelY, voxelZ, amount)
```
Set a weapon's ammo count (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `amount`: number

---

```lua
Noir.Classes.Body:SetTransponder(isActive)
```
Set this body's transponder activity.

### Parameters
- `isActive`: boolean

---

```lua
Noir.Classes.Body:SetTank(tankName, amount, fluidType)
```
Set a tank's contents (by name).

### Parameters
- `tankName`: string
- `amount`: number
- `fluidType`: SWTankFluidTypeEnum

---

```lua
Noir.Classes.Body:SetTankByVoxel(voxelX, voxelY, voxelZ, amount, fluidType)
```
Set a tank's contents (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `amount`: number
- `fluidType`: SWTankFluidTypeEnum

---

```lua
Noir.Classes.Body:SetShowOnMap(isShown)
```
Set whether or not this body is shown on the map.

### Parameters
- `isShown`: boolean

---

```lua
Noir.Classes.Body:ResetState()
```
Reset this body's state.

---

```lua
Noir.Classes.Body:SetTooltip(tooltip)
```
Set this body's tooltip.

### Parameters
- `tooltip`: string

---

```lua
Noir.Classes.Body:GetBattery(batteryName)
```
Get a battey's data (by name).

### Parameters
- `batteryName`: string
### Returns
- `SWVehicleBatteryData|nil`

---

```lua
Noir.Classes.Body:GetBatteryByVoxel(voxelX, voxelY, voxelZ)
```
Get a battey's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleBatteryData|nil`

---

```lua
Noir.Classes.Body:GetButton(buttonName)
```
Get a button's data (by name).

### Parameters
- `buttonName`: string
### Returns
- `SWVehicleButtonData|nil`

---

```lua
Noir.Classes.Body:GetButtonByVoxel(voxelX, voxelY, voxelZ)
```
Get a button's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleButtonData|nil`

---

```lua
Noir.Classes.Body:GetComponents()
```
Get this body's components.

### Returns
- `SWLoadedVehicleData|nil`

---

```lua
Noir.Classes.Body:GetData()
```
Get this body's data.

### Returns
- `SWVehicleData|nil`

---

```lua
Noir.Classes.Body:GetDial(dialName)
```
Get a dial's data (by name).

### Parameters
- `dialName`: string
### Returns
- `SWVehicleDialData|nil`

---

```lua
Noir.Classes.Body:GetDialByVoxel(voxelX, voxelY, voxelZ)
```
Get a dial's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleDialData|nil`

---

```lua
Noir.Classes.Body:GetFireCount()
```
Returns the number of surfaces that are on fire.

### Returns
- `integer|nil`

---

```lua
Noir.Classes.Body:GetHopper(hopperName)
```
Get a hopper's data (by name).

### Parameters
- `hopperName`: string
### Returns
- `SWVehicleHopperData|nil`

---

```lua
Noir.Classes.Body:GetHopperByVoxel(voxelX, voxelY, voxelZ)
```
Get a hopper's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleHopperData|nil`

---

```lua
Noir.Classes.Body:GetRopeHook(hookName)
```
Get a rope hook's data (by name).

### Parameters
- `hookName`: string
### Returns
- `SWVehicleRopeHookData|nil`

---

```lua
Noir.Classes.Body:GetRopeHookByVoxel(voxelX, voxelY, voxelZ)
```
Get a rope hook's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleRopeHookData|nil`

---

```lua
Noir.Classes.Body:GetSeat(seatName)
```
Get a seat's data (by name).

### Parameters
- `seatName`: string
### Returns
- `SWVehicleSeatData|nil`

---

```lua
Noir.Classes.Body:GetSeatByVoxel(voxelX, voxelY, voxelZ)
```
Get a seat's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleSeatData|nil`

---

```lua
Noir.Classes.Body:GetSign(signName)
```
Get a sign's data (by name).

### Parameters
- `signName`: string
### Returns
- `SWVehicleSignData|nil`

---

```lua
Noir.Classes.Body:GetSignByVoxel(voxelX, voxelY, voxelZ)
```
Get a sign's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleSignData|nil`

---

```lua
Noir.Classes.Body:GetTank(tankName)
```
Get a tank's data (by name).

### Parameters
- `tankName`: string
### Returns
- `SWVehicleTankData|nil`

---

```lua
Noir.Classes.Body:GetTankByVoxel(voxelX, voxelY, voxelZ)
```
Get a tank's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleTankData|nil`

---

```lua
Noir.Classes.Body:GetWeapon(weaponName)
```
Get a weapon's data (by name).

### Parameters
- `weaponName`: string
### Returns
- `SWVehicleWeaponData|nil`

---

```lua
Noir.Classes.Body:GetWeaponByVoxel(voxelX, voxelY, voxelZ)
```
Get a weapon's data (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
### Returns
- `SWVehicleWeaponData|nil`

---

```lua
Noir.Classes.Body:PressButton(buttonName)
```
Presses a button on this body (by name).

### Parameters
- `buttonName`: string

---

```lua
Noir.Classes.Body:PressButtonByVoxel(voxelX, voxelY, voxelZ)
```
Presses a button on this body (by voxel).

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer

---

```lua
Noir.Classes.Body:SpawnRopeHook(voxelX, voxelY, voxelZ, targetBody, targetVoxelX, targetVoxelY, targetVoxelZ, length, ropeType)
```
Spawns a rope connected by a hook on this body to a hook on another (or this) body.

### Parameters
- `voxelX`: integer
- `voxelY`: integer
- `voxelZ`: integer
- `targetBody`: NoirBody|nil - nil = this body
- `targetVoxelX`: integer
- `targetVoxelY`: integer
- `targetVoxelZ`: integer
- `length`: number
- `ropeType`: SWRopeTypeEnum

---

```lua
Noir.Classes.Body:Despawn()
```
Despawn the body.

---

```lua
Noir.Classes.Body:Exists()
```
Returns whether or not the body exists.

### Returns
- `boolean`

---

```lua
Noir.Classes.Body:IsSimulating()
```
Returns whether or not the body is simulating.

### Returns
- `boolean`