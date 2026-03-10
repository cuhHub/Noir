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
- `ID`: NoirHoardableID

---

```lua
Noir.Classes.Hoardable:GetHoardableID()
```
Returns the ID of this class instance.

### Returns
- `NoirHoardableID`

---

```lua
Noir.Classes.Hoardable:HasHoardableID()
```
Returns if this class instance has a hoardable ID.

### Returns
- `boolean`

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
Noir.Classes.Hoardable:OnPreSerialize() end
```
Called before serialization.

You can use this to replace unserializable values like cyclic tables with something else.

These can then be converted back via `OnDeserialize`.

`self` is the class instance being serialized.

This is an `abstractmethod` and should be overridden in subclasses (optional).

---

```lua
Noir.Classes.Hoardable:OnPostSerialize(serialized) end
```
Called after serialization.

`self` is the class instance being serialized.

`serialized` is the now serialized data of the class instance.

This is an `abstractmethod` and should be overridden in subclasses (optional).

### Parameters
- `serialized`: table

---

```lua
Noir.Classes.Hoardable:OnPreDeserialize(serialized, lookupClasses) end
```
Called before deserialization.

Can be used to replace serialized values with something else, e.g. converting older data to newer data.

`self` is the class instance being deserialized.

`serialized` is the serialized data of the class instance.

`lookupClasses` is a table of classes that can be used to deserialize the class instance.

This is an `abstractmethod` and should be overridden in subclasses (optional).

### Parameters
- `serialized`: table
- `lookupClasses`: table<string, NoirClass>

---

```lua
Noir.Classes.Hoardable:OnPostDeserialize(serialized, lookupClasses) end
```
Called after deserialization.

`self` is the deserialized class instance.

`serialized` is the serialized data of the class instance.

`lookupClasses` is a table of classes that can be used to deserialize the class instance.

This is a useful place to apply corrections if the `HoarderService` didn't deserialize the class instance to your expectation.

This is an `abstractmethod` and should be overridden in subclasses (optional).

### Parameters
- `serialized`: table
- `lookupClasses`: table<string, NoirClass>