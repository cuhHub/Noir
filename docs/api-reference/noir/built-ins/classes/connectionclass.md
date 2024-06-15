# ConnectionClass

**Noir.Classes.ConnectionClass**: `NoirClass`

A class for event connections.

***

```lua
Noir.Classes.ConnectionClass:Init(callback)
```

Initializes new connection class objects.

#### Parameters

* `callback`: function

***

```lua
Noir.Classes.ConnectionClass:Fire(...)
```

Triggers the callback's stored function.

#### Parameters

* `...`: any

***

```lua
Noir.Classes.ConnectionClass:Disconnect()
```

Disconnects the callback from the event.
