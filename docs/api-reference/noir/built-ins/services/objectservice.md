# ObjectService

**Noir.Services.ObjectService**: `NoirService`

A service for wrapping SW objects in classes.

***

```lua
Noir.Services.ObjectService:_SaveObjects(objects)
```

Overwrite saved objects.

Used internally. Do not use in your code.

#### Parameters

* `objects`: table\<integer, NoirSerializedObject>

***

```lua
Noir.Services.ObjectService:_GetSavedObjects()
```

Get saved objects.

Used internally. Do not use in your code.

#### Returns

* `table<integer, NoirSerializedObject>`

***

```lua
Noir.Services.ObjectService:GetObjects()
```

Get all objects.

#### Returns

* `table<integer, NoirObject>`

***

```lua
Noir.Services.ObjectService:_SaveObjectSavedata(object)
```

Save an object to g\_savedata.

Used internally. Do not use in your code.

#### Parameters

* `object`: NoirObject

***

```lua
Noir.Services.ObjectService:_RemoveObjectSavedata(object_id)
```

Remove an object from g\_savedata.

Used internally. Do not use in your code.

#### Parameters

* `object_id`: integer

***

```lua
Noir.Services.ObjectService:RegisterObject(object_id)
```

Registers an object by ID.

#### Parameters

* `object_id`: integer

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:GetObject(object_id)
```

Returns the object with the given ID.

#### Parameters

* `object_id`: integer

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:RemoveObject(object_id)
```

Removes the object with the given ID.

#### Parameters

* `object_id`: integer

***

```lua
Noir.Services.ObjectService:SpawnObject(objectType, position)
```

Spawn an object.

#### Parameters

* `objectType`: SWObjectTypeEnum
* `position`: SWMatrix

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:SpawnCharacter(outfitType, position)
```

Spawn a character.

#### Parameters

* `outfitType`: SWOutfitTypeEnum
* `position`: SWMatrix

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:SpawnCreature(creatureType, position, sizeMultiplier)
```

Spawn a creature.

#### Parameters

* `creatureType`: SWCreatureTypeEnum
* `position`: SWMatrix
* `sizeMultiplier`: number|nil - Default: 1

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:SpawnAnimal(animalType, position, sizeMultiplier)
```

Spawn an animal.

#### Parameters

* `animalType`: SWAnimalTypeEnum
* `position`: SWMatrix
* `sizeMultiplier`: number|nil - Default: 1

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:SpawnEquipment(equipmentType, position, int, float)
```

Spawn an equipment item.

#### Parameters

* `equipmentType`: SWEquipmentTypeEnum
* `position`: SWMatrix
* `int`: integer
* `float`: integer

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:SpawnFire(position, size, magnitude, isLit, isExplosive, parentVehicleID, explosionMagnitude)
```

Spawn a fire.

#### Parameters

* `position`: SWMatrix
* `size`: number - 0 - 10
* `magnitude`: number - -1 explodes instantly. Nearer to 0 means the explosion takes longer to happen. Must be below 0 for explosions to work.
* `isLit`: boolean - Lights the fire. If the magnitude is >1, this will need to be true for the fire to first warm up before exploding.
* `isExplosive`: boolean
* `parentVehicleID`: integer|nil
* `explosionMagnitude`: number - The size of the explosion (0-5)

#### Returns

* `NoirObject|nil`
