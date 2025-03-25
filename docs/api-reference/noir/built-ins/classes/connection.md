# Connection

**Noir.Classes.Connection**: `NoirClass`

Represents a connection to an event.

---

```lua
Noir.Classes.Connection:Init(callback)
```
Initializes new connection class objects.

### Parameters
- `callback`: function

---

```lua
Noir.Classes.Connection:Fire(...)
```
Triggers the callback's stored function.

### Parameters
- `...`: any
### Returns
- `any`

---

```lua
Noir.Classes.Connection:Disconnect()
```
Disconnects the callback from the event.