---
description: A class for events.
---

# EventClass

```lua
Noir.Classes.EventClass:Init()
```

Initializes event class objects.

***

```lua
Noir.Classes.EventClass:Fire(...)
```

Fires the event, passing any provided arguments to the connections.

***

```lua
Noir.Classes.EventClass:Connect(callback)
```

Connects a function to the event. A connection is automatically made for the function.\
If connecting to an event that is currently being handled, it will be added afterwards and run the next time the event is fired.

#### Parameters

* `callback`: function

#### Returns

* `NoirConnection`

***

```lua
Noir.Classes.EventClass:_ConnectFinalize(connection)
```

**Should only be used internally.**\
Finalizes the connection to the event, allowing it to be run.

#### Parameters

* `connection`: NoirConnection

***

```lua
Noir.Classes.EventClass:Once(callback)
```

Connects a callback to the event that will automatically be disconnected upon the event being fired.\
If connecting to an event that is currently being handled, it will be added afterwards and run the next time the event is fired.

#### Parameters

* `callback`: function

#### Returns

* `NoirConnection`

***

```lua
Noir.Classes.EventClass:Disconnect(connection)
```

Disconnects the provided connection from the event.\
The disconnection may be delayed if done while handling the event.

#### Parameters

* `connection`: NoirConnection

***

```lua
Noir.Classes.EventClass:_DisconnectImmediate(connection)
```

**Should only be used internally.**\
Disconnects the provided connection from the event immediately.

#### Parameters

* `connection`: NoirConnection
