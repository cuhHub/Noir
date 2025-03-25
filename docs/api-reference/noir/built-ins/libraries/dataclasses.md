# Dataclasses

**Noir.Libraries.Dataclasses**: `NoirLibrary`

A library that allows you to create dataclasses, similar to Python.

---

```lua
Noir.Libraries.Dataclasses:New(name, fields)
```
Create a new dataclass.

### Parameters
- `name`: string
- `fields`: table<integer, NoirDataclassField>
### Returns
- `NoirDataclass`

---

```lua
Noir.Libraries.Dataclasses:Field(name, ...)
```
Returns a dataclass field to be used with Noir.Libraries.Dataclasses:New().

### Parameters
- `name`: string
- `...`: NoirTypeCheckingType
### Returns
- `NoirDataclassField`