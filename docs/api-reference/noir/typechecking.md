# TypeChecking

**Noir.TypeChecking**: `table`

A module of Noir for checking if a value is of the correct type.

This normally would be a library, but libraries need to use this and libraries are meant to be independent of each other.

---

```lua
Noir.TypeChecking:Assert(origin, parameterName, value, ...)
```
Raises an error if the value is not any of the provided types.

This supports checking if a value is a specific class or not too.

### Parameters
- `origin`: string - The location of the thing (method, function, etc) that called this so the user can find out where something went wrong
- `parameterName`: string - The name of the parameter that is being type checked
- `value`: any
- `...`: NoirTypeCheckingType

---

```lua
Noir.TypeChecking:AssertMany(origin, parameterName, values, ...)
```
Raises an error if any of the provided values are not any of the provided types.

### Parameters
- `origin`: string - The location of the thing (method, function, etc) that called this so the user can find out where something went wrong
- `parameterName`: string - The name of the parameter that is being type checked
- `values`: table<integer, any>
- `...`: NoirTypeCheckingType

---

```lua
Noir.TypeChecking:_FormatTypes(types)
```
Format required types for an error message.

Used internally.

### Parameters
- `types`: table<integer, NoirTypeCheckingType>
### Returns
- `string`