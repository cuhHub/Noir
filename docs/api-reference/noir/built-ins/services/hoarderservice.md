# HoarderService

**Noir.Services.HoarderService**: `NoirService`

A service for easily saving/loading class instances within a service with minimal hassle.

Example:

---

```lua
Noir.Services.HoarderService:_Deserialize(class, serialized)
```
Deserializes a serialized class instance.

Used internally.

### Parameters
- `class`: NoirHoardable
- `serialized`: table
### Returns
- `NoirHoardable`

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
Noir.Services.HoarderService:_ShouldLoad(service, class, instance)
```
Returns whether a class instance about to be loaded should be loaded.

Used internally.

### Parameters
- `service`: NoirService
- `class`: NoirHoardable
- `instance`: NoirHoardable
### Returns
- `boolean`

---

```lua
Noir.Services.HoarderService:AddCheckpoint(service, class, func)
```
Adds a checkpoint function for a service. It must return a boolean.

if `true` is returned, the passed instance will be loaded.

if `false` is returned, the passed instance will not be loaded.

### Parameters
- `service`: NoirService
- `class`: NoirHoardable
- `func`: fun(instance: - NoirHoardable): boolean

---

```lua
Noir.Services.HoarderService:Hoard(service, tblName, instance)
```
Saves the provided class instance within a service.

### Parameters
- `service`: NoirService
- `tblName`: string
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
Noir.Services.HoarderService:LoadAll(class, service, tblName)
```
Loads all serialized class instances into a table in the provided service.

### Parameters
- `class`: NoirHoardable
- `service`: NoirService
- `tblName`: string