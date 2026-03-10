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
- `ID`: any|nil

---

```lua
Noir.Classes.Hoardable:GetHoardableID()
```
Returns the ID of this class instance.

### Returns
- `any|nil`

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

---

```lua
Noir.Classes.Hoardable:OnSerialize(serialized) end
```
Called during serialization.

`self` is the class instance being serialized.

`serialized` is the serialized data of the class instance.

This is an `abstractmethod` and should be overridden in subclasses (optional).

### Parameters
- `serialized`: table

---

```lua
Noir.Classes.Hoardable:OnDeserialize(serialized, lookupClasses) end
```
Called during deserialization.

`self` is the deserialized class instance.

`serialized` is the serialized data of the class instance.

`lookupClasses` is a table of classes that can be used to deserialize the class instance.

This is a useful place to apply corrections if the `HoarderService` didn't deserialize the class instance to your expectation.

This is an `abstractmethod` and should be overridden in subclasses (optional).

### Parameters
- `serialized`: table
- `lookupClasses`: table<string, NoirClass>