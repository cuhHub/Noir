# Callbacks

**Noir.Callbacks**: `table`

A module of Noir that allows you to attach multiple functions to game callbacks.

These functions can be disconnected from the game callbacks at any time.

---

**Noir.Callbacks.Events**: `table<string, NoirEvent>`

A table of events assigned to game callbacks.

Do not directly modify this table.

---

```lua
Noir.Callbacks:Connect(name, callback, hideStartWarning)
```
Connect to a game callback.

### Parameters
- `name`: string
- `callback`: function
- `hideStartWarning`: boolean|nil

---

```lua
Noir.Callbacks:Once(name, callback, hideStartWarning)
```
Connect to a game callback, but disconnect after the game callback has been called.

### Parameters
- `name`: string
- `callback`: function
- `hideStartWarning`: boolean|nil

---

```lua
Noir.Callbacks:Get(name)
```
Get a game callback event. These events may not exist if `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` was not called for them.

It's best to use `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` instead of getting a callback event directly and connecting to it.

### Parameters
- `name`: string
### Returns
- `NoirEvent`

---

```lua
Noir.Callbacks:_InstantiateCallback(name, hideStartWarning)
```
Creates an event and an _ENV function for a game callback.

Used internally, do not use this in your addon.

### Parameters
- `name`: string
- `hideStartWarning`: boolean
### Returns
- `NoirEvent`