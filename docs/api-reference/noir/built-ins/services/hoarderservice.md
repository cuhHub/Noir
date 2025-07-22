# HoarderService

**Noir.Services.HoarderService**: `NoirService`

A service for easily saving/loading class instances within a service with minimal hassle.

Example (see `Hoardable` code sample for info on the class side of things):

---

```lua
Noir.Services.HoarderService:_Serialize(tbl)
```
Serializes a table for saving by removing all functions.

Used internally.

### Parameters
- `tbl`: table
### Returns
- `table`

---

```lua
Noir.Services.HoarderService:_IndexClasses(classes)
```
Adds class names as indices to a table of classes.

Used internally.

### Parameters
- `classes`: table<integer, NoirClass>
### Returns
- `table<string, NoirClass>`

---

```lua
Noir.Services.HoarderService:_Deserialize(class, serialized, lookupClasses)
```
Deserializes a serialized class instance.

Used internally.

### Parameters
- `class`: NoirHoardable|NoirClass
- `serialized`: table
- `lookupClasses`: table<string, NoirClass>
### Returns
- `NoirClass`

---

```lua
Noir.Services.HoarderService:_InitSaveData(service, tblName)
```
Sets up a save data category for a service if it doesn't exist.

Used internally.

### Parameters
- `service`: NoirService
- `tblName`: string

---

```lua
Noir.Services.HoarderService:_HandleCheckpoint(service, class, instance)
```
Invokes the checkpoint for the provided service and class if any.

It then returns the result which should be whether or not to load the instance and an optional overwritten location for the instance.

Used internally.

### Parameters
- `service`: NoirService
- `class`: NoirClass
- `instance`: NoirClass
### Returns
- `boolean,`: nil

---

```lua
Noir.Services.HoarderService:AddCheckpoint(service, class, func)
```
Adds a checkpoint function for a service and class. It must return a boolean and an optional location for the instance.

if `true` is returned, the passed instance will be loaded.

if `false` is returned, the passed instance will not be loaded.



Example Checkpoint:

### Parameters
- `service`: NoirService
- `class`: NoirHoardable
- `func`: fun(instance: - NoirHoardable): boolean, table|nil

---

```lua
Noir.Services.HoarderService:Hoard(service, tblName, instance)
```
Saves the provided class instance within a service.

### Parameters
- `service`: NoirService
- `tblName`: string - The name of the sub-table in the provided service's savedata to save the serialized instance to
- `instance`: NoirHoardable

---

```lua
Noir.Services.HoarderService:Unhoard(service, tblName, instance)
```
Unhoards the provided class instance within a service.

### Parameters
- `service`: NoirService
- `tblName`: string
- `instance`: NoirHoardable

---

```lua
Noir.Services.HoarderService:LoadAll(service, from, to, class, lookupClasses)
```
Loads all serialized class instances into a table in the provided service.

### Parameters
- `service`: NoirService
- `from`: string - The name of the sub-table in the provided service's savedata to load the serialized instances from
- `to`: table - The table to load the class instances into
- `class`: NoirHoardable - The class the serialized instances are of
- `lookupClasses`: table<integer, NoirClass> - A table of classes that the provided class may contain instances of. This is used to deserialize instances of classes that are not the provided class but may be contained within it.