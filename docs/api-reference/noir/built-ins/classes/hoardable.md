# Hoardable

**Noir.Classes.Hoardable**: `NoirClass`

A class that hoardable classes should inherit from to be able to be used with the `Noir.Services.HoarderService`.

Check out the aforementioned service for more info.

Example:

---

```lua
Noir.Classes.Hoardable:Init(ID)
```
Initializes `Hoardable` class instances.

### Parameters
- `ID`: any

---

```lua
Noir.Classes.Hoardable:GetHoardableID()
```
Returns the ID of this class instance.

### Returns
- `any|nil`

---

```lua
Noir.Classes.Hoardable:_Strip(tbl)
```
Returns the provided table but stripped of non-serializable values.

### Parameters
- `tbl`: table
### Returns
- `table`

---

```lua
Noir.Classes.Hoardable:Serialize()
```
Serializes this class instance.

### Returns
- `table`

---

```lua
Noir.Classes.Hoardable:Hoard(service, tblName)
```
Hoards this instance.

### Parameters
- `service`: NoirService
- `tblName`: string

---

```lua
Noir.Classes.Hoardable:Unhoard(service, tblName)
```
Unhoards this instance.

### Parameters
- `service`: NoirService
- `tblName`: string