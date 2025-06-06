# ObjectService

**Noir.Services.ObjectService**: `NoirService`

A service for wrapping SW objects in classes.

---

```lua
Noir.Services.ObjectService:_LoadObjects()
```
Load saved objects.

Used internally. Do not use in your code.

---

```lua
Noir.Services.ObjectService:_OnObjectLoad(object)
```
Run code that would normally be ran when an object is loaded.

Used internally. Do not use in your code.

### Parameters
- `object`: NoirObject

---

```lua
Noir.Services.ObjectService:_OnObjectUnload(object)
```
Run code that would normally be ran when an object is unloaded.

Used internally. Do not use in your code.

### Parameters
- `object`: NoirObject

---

```lua
Noir.Services.ObjectService:_RegisterObject(object_id, _preventEventTrigger)
```
Registers an object by ID.

Used internally. Use :GetObject() to retrieve an object instead.

### Parameters
- `object_id`: integer
- `_preventEventTrigger`: boolean|nil
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:_RemoveObject(object)
```
Removes the object with the given ID.

Used internally. Do not use in your code.

### Parameters
- `object`: NoirObject

---

```lua
Noir.Services.ObjectService:_SaveObjects(objects)
```
Overwrite saved objects.

Used internally. Do not use in your code.

### Parameters
- `objects`: table<integer, NoirSerializedObject>

---

```lua
Noir.Services.ObjectService:_GetSavedObjects()
```
Get saved objects.

Used internally. Do not use in your code.

### Returns
- `table<integer, NoirSerializedObject>`

---

```lua
Noir.Services.ObjectService:_SaveObjectSavedata(object)
```
Save an object to g_savedata.

Used internally. Do not use in your code.

### Parameters
- `object`: NoirObject

---

```lua
Noir.Services.ObjectService:_RemoveObjectSavedata(object_id)
```
Remove an object from g_savedata.

Used internally. Do not use in your code.

### Parameters
- `object_id`: integer

---

```lua
Noir.Services.ObjectService:GetObjects()
```
Get all objects.

### Returns
- `table<integer, NoirObject>`

---

```lua
Noir.Services.ObjectService:GetObject(object_id)
```
Returns the object with the given ID.

### Parameters
- `object_id`: integer
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnObject(objectType, position)
```
Spawn an object.

### Parameters
- `objectType`: SWObjectTypeEnum
- `position`: SWMatrix
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnCharacter(outfitType, position)
```
Spawn a character.

### Parameters
- `outfitType`: SWOutfitTypeEnum
- `position`: SWMatrix
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnCreature(creatureType, position, sizeMultiplier)
```
Spawn a creature.

### Parameters
- `creatureType`: SWCreatureTypeEnum
- `position`: SWMatrix
- `sizeMultiplier`: number|nil - Default: 1
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnAnimal(animalType, position, sizeMultiplier)
```
Spawn an animal.

### Parameters
- `animalType`: SWAnimalTypeEnum
- `position`: SWMatrix
- `sizeMultiplier`: number|nil - Default: 1
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnEquipment(equipmentType, position, int, float)
```
Spawn an equipment item.

### Parameters
- `equipmentType`: SWEquipmentTypeEnum
- `position`: SWMatrix
- `int`: integer
- `float`: integer
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnFire(position, size, magnitude, isLit, isExplosive, parentBody, explosionMagnitude)
```
Spawn a fire.

### Parameters
- `position`: SWMatrix
- `size`: number - 0 - 10
- `magnitude`: number - -1 explodes instantly. Nearer to 0 means the explosion takes longer to happen. Must be below 0 for explosions to work.
- `isLit`: boolean - Lights the fire. If the magnitude is >1, this will need to be true for the fire to first warm up before exploding.
- `isExplosive`: boolean
- `parentBody`: NoirBody|nil
- `explosionMagnitude`: number - The size of the explosion (0-5)
### Returns
- `NoirObject`

---

```lua
Noir.Services.ObjectService:SpawnExplosion(position, magnitude)
```
Spawn an explosion.

### Parameters
- `position`: SWMatrix
- `magnitude`: number - 0-1