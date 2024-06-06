# ObjectClass

**Noir.Classes.ObjectClass**: `NoirClass`

Represents a object for the ObjectService.

***

```lua
Noir.Classes.ObjectClass:Init(ID)
```

Initializes object class objects.

#### Parameters

* `ID`: integer

***

```lua
Noir.Classes.ObjectClass:_Serialize()
```

Serializes this object into g\_savedata format. Used internally. Do not use in your code.

#### Returns

* `NoirSerializedObject`

***

```lua
Noir.Classes.ObjectClass._Deserialize(serializedObject)
```

Deserializes this object from g\_savedata format. Used internally. Do not use in your code.

#### Parameters

* `serializedObject`: NoirSerializedObject

#### Returns

* `NoirObject`

***

```lua
Noir.Classes.ObjectClass:GetData()
```

Returns the data of this object.

#### Returns

* `SWObjectData|nil`

***

```lua
Noir.Classes.ObjectClass:IsSimulating()
```

Returns whether or not this object is simulating.

#### Returns

* `boolean`

***

```lua
Noir.Classes.ObjectClass:Despawn()
```

Despawn this object.

***

```lua
Noir.Classes.ObjectClass:GetPosition()
```

Get this object's position.

#### Returns

* `SWMatrix`

***

```lua
Noir.Classes.ObjectClass:Teleport(position)
```

Teleport this object.

#### Parameters

* `position`: SWMatrix

***

```lua
Noir.Classes.ObjectClass:Revive()
```

Revive this character (if character).

***

```lua
Noir.Classes.ObjectClass:SetData(hp, interactable, AI)
```

Set this object's data (if character).

#### Parameters

* `hp`: number
* `interactable`: boolean
* `AI`: boolean

***

```lua
Noir.Classes.ObjectClass:GetHealth()
```

Returns this character's health (if character).

#### Returns

* `number`

***

```lua
Noir.Classes.ObjectClass:SetTooltip(tooltip)
```

Set this character's tooltip (if character).

#### Parameters

* `tooltip`: string

***

```lua
Noir.Classes.ObjectClass:SetAIState(state)
```

Set this character's AI state (if character).

#### Parameters

* `state`: integer - 0 = none, 1 = path to destination

***

```lua
Noir.Classes.ObjectClass:SetAICharacterTarget(target)
```

Set this character's AI character target (if character).

#### Parameters

* `target`: NoirObject

***

```lua
Noir.Classes.ObjectClass:SetAIVehicleTarget(vehicle_id)
```

Set this character's AI vehicle target (if character).

#### Parameters

* `vehicle_id`: integer

***

```lua
Noir.Classes.ObjectClass:Kill()
```

Kills this character (if character).

***

```lua
Noir.Classes.ObjectClass:GetVehicle()
```

Returns the vehicle this character is sat in (if character).

#### Returns

* `integer|nil`

***

```lua
Noir.Classes.ObjectClass:GetItem(slot)
```

Returns the item this character is holding in the specified slot (if character).

#### Parameters

* `slot`: SWSlotNumberEnum

#### Returns

* `integer|nil`

***

```lua
Noir.Classes.ObjectClass:IsDowned()
```

Returns whether or not this character is downed (dead, incapaciated, or hp <= 0) (if character).

#### Returns

* `boolean`

***

```lua
Noir.Classes.ObjectClass:Seat(vehicle_id, name, voxelX, voxelY, voxelZ)
```

Seat this character in a seat (if character).

#### Parameters

* `vehicle_id`: integer
* `name`: string|nil
* `voxelX`: integer|nil
* `voxelY`: integer|nil
* `voxelZ`: integer|nil

***

```lua
Noir.Classes.ObjectClass:SetMoveTarget(position)
```

Set the move target of this character (if creature).

#### Parameters

* `position`: SWMatrix

***

```lua
Noir.Classes.ObjectClass:Damage(amount)
```

Damage this character by a certain amount (if character).

#### Parameters

* `amount`: number

***

```lua
Noir.Classes.ObjectClass:Heal(amount)
```

Heal this character by a certain amount (if character).

#### Parameters

* `amount`: number
