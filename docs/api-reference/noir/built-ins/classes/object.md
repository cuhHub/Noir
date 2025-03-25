# Object

**Noir.Classes.Object**: `NoirClass`

Represents a Stormworks object.

---

```lua
Noir.Classes.Object:Init(ID)
```
Initializes object class objects.

### Parameters
- `ID`: integer

---

```lua
Noir.Classes.Object:_Serialize()
```
Serializes this object into g_savedata format.

Used internally. Do not use in your code.

### Returns
- `NoirSerializedObject`

---

```lua
Noir.Classes.Object:_Deserialize(serializedObject)
```
Deserializes this object from g_savedata format.

Used internally. Do not use in your code.

### Parameters
- `serializedObject`: NoirSerializedObject
### Returns
- `NoirObject`

---

```lua
Noir.Classes.Object:GetData()
```
Returns the data of this object.

### Returns
- `SWObjectData`

---

```lua
Noir.Classes.Object:IsSimulating()
```
Returns whether or not this object is simulating.

### Returns
- `boolean`

---

```lua
Noir.Classes.Object:Exists()
```
Returns whether or not this object exists.

### Returns
- `boolean`

---

```lua
Noir.Classes.Object:Despawn()
```
Despawn this object.

---

```lua
Noir.Classes.Object:GetPosition()
```
Get this object's position.

### Returns
- `SWMatrix`

---

```lua
Noir.Classes.Object:Teleport(position)
```
Teleport this object.

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.Object:Revive()
```
Revive this character (if character).

---

```lua
Noir.Classes.Object:SetData(hp, interactable, AI)
```
Set this object's data (if character).

### Parameters
- `hp`: number
- `interactable`: boolean
- `AI`: boolean

---

```lua
Noir.Classes.Object:GetHealth()
```
Returns this character's health (if character).

### Returns
- `number`

---

```lua
Noir.Classes.Object:SetTooltip(tooltip)
```
Set this character's/creature's tooltip (if character or creature).

### Parameters
- `tooltip`: string

---

```lua
Noir.Classes.Object:SetAIState(state)
```
Set this character's AI state (if character).

### Parameters
- `state`: integer - **Ship Pilot**: 0 = none, 1 = path to destination<br>**Heli Pilot**: 0 = None, 1 = path to destination, 2 = path to destination (accurate), 3 = gun run<br>**Plane Pilot**: 0 = none, 1 = path to destination, 2 = gun run<br>**Gunner**: 0 = none, 1 = fire at target<br>**Designator**: 0 = none, 1 = aim at target

---

```lua
Noir.Classes.Object:GetAITarget()
```
Returns this character's AI target (if character).

### Returns
- `NoirAITarget|nil`

---

```lua
Noir.Classes.Object:SetAICharacterTarget(target)
```
Set this character's AI character target (if character).

### Parameters
- `target`: NoirObject

---

```lua
Noir.Classes.Object:SetAIBodyTarget(body)
```
Set this character's AI body target (if character).

### Parameters
- `body`: NoirBody

---

```lua
Noir.Classes.Object:SetAIPositionTarget(position)
```
Set this character's AI position target (if character).

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.Object:Kill()
```
Kills this character (if character).

---

```lua
Noir.Classes.Object:GetVehicle()
```
Returns the vehicle this character is sat in (if character).

### Returns
- `NoirBody|nil`

---

```lua
Noir.Classes.Object:GetItem(slot)
```
Returns the item this character is holding in the specified slot (if character).

### Parameters
- `slot`: SWSlotNumberEnum
### Returns
- `integer|nil`

---

```lua
Noir.Classes.Object:GiveItem(slot, equipmentID, isActive, int, float)
```
Give this character an item (if character).

### Parameters
- `slot`: SWSlotNumberEnum
- `equipmentID`: SWEquipmentTypeEnum
- `isActive`: boolean|nil
- `int`: integer|nil
- `float`: number|nil

---

```lua
Noir.Classes.Object:IsDowned()
```
Returns whether or not this character is downed (dead, incapaciated, or hp <= 0) (if character).

### Returns
- `boolean`

---

```lua
Noir.Classes.Object:Seat(body, name, voxelX, voxelY, voxelZ)
```
Seat this character in a seat (if character).

### Parameters
- `body`: NoirBody
- `name`: string|nil
- `voxelX`: integer|nil
- `voxelY`: integer|nil
- `voxelZ`: integer|nil

---

```lua
Noir.Classes.Object:SetMoveTarget(position)
```
Set the move target of this character (if creature).

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.Object:Damage(amount)
```
Damage this character by a certain amount (if character).

### Parameters
- `amount`: number

---

```lua
Noir.Classes.Object:Heal(amount)
```
Heal this character by a certain amount (if character).

### Parameters
- `amount`: number

---

```lua
Noir.Classes.Object:GetFireData()
```
Get this fire's data (if fire).

### Returns
- `boolean`: isLit

---

```lua
Noir.Classes.Object:SetFireData(isLit, isExplosive)
```
Set this fire's data (if fire).

### Parameters
- `isLit`: boolean
- `isExplosive`: boolean