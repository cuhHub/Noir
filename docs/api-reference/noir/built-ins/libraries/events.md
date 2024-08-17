# Events

**Noir.Libraries.Events**: `NoirLibrary`

A library that allows you to create events.

---

**Noir.Libraries.Events.DismissAction**: `table`

Return this in the function provided to `:Connect()` to disconnect the function from the connected event after it is called.

This is similar to calling `:Disconnect()` after a connection to an event was fired.        local MyEvent = Noir.Libraries.Events:Create()

---

```lua
Noir.Libraries.Events:Create()
```
Create an event. This event can then be fired with the :Fire() method.

### Returns
- `NoirEvent`