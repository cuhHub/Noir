# Deprecation

**Noir.Libraries.Deprecation**: `NoirLibrary`

A library that allows you to mark functions as deprecated.

---

```lua
Noir.Libraries.Deprecation:Deprecated(name, replacement, note)
```
Mark a function as deprecated.        function HelloWorld()        Noir.Libraries.Deprecation:Deprecated("HelloWorld", "AnOptionalReplacementFunction", "An optional note appended to the deprecation message")        print("Hello World")    end

### Parameters
- `name`: string
- `replacement`: string|nil
- `note`: string|nil