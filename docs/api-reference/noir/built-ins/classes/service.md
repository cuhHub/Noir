# Service

**Noir.Classes.ServiceClass**: `NoirClass`

Represents a Noir service.

---

```lua
Noir.Classes.ServiceClass:Init(name, isBuiltIn, shortDescription, longDescription, authors)
```
Initializes service class objects.

### Parameters
- `name`: string
- `isBuiltIn`: boolean
- `shortDescription`: string
- `longDescription`: string
- `authors`: table<integer, string>

---

```lua
Noir.Classes.ServiceClass:_Initialize()
```
Initialize this service.

Used internally.

---

```lua
Noir.Classes.ServiceClass:_Start()
```
Start this service.

Used internally.

---

```lua
Noir.Classes.ServiceClass:_CheckSaveData()
```
Checks if g_savedata is intact.

Used internally.

### Returns
- `boolean`

---

```lua
Noir.Classes.ServiceClass:Save(index, data)
```
Save a value to g_savedata under this service.

### Parameters
- `index`: string
- `data`: any

---

```lua
Noir.Classes.ServiceClass:Load(index, default)
```
Load data from this service's g_savedata entry that was saved via the :Save() method.

### Parameters
- `index`: string
- `default`: any
### Returns
- `any`

---

```lua
Noir.Classes.ServiceClass:EnsuredLoad(index, default)
```
Similar to `:Load()`, this method loads a value from this service's g_savedata entry.

However, if the value doesn't exist, the default value provided to this method is saved then returned.

### Parameters
- `index`: string
- `default`: any
### Returns
- `any`

---

```lua
Noir.Classes.ServiceClass:Remove(index)
```
Remove data from this service's g_savedata entry that was saved.

### Parameters
- `index`: string

---

```lua
Noir.Classes.ServiceClass:GetSaveData()
```
Returns this service's g_savedata table for direct modification.



### Returns
- `table`