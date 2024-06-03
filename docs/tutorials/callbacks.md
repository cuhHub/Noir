---
description: This page will go over Noir's callbacks system.
cover: ../.gitbook/assets/26.png
coverY: 0
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# 💬 Callbacks

## What Are Callbacks?

Callbacks are simply functions defined in your addon like `onPlayerJoin` that get called by Stormworks.

In Addon Lua, we can listen for game events by creating a function representing the name of the event like so:

{% code title="script.lua" lineNumbers="true" %}
```lua
function onPlayerJoin(...)
    ...
end
```
{% endcode %}

In Addon Lua, this is the only way. It's quite problematic though since we can only define a function with a specific name once, meaning we can only create one function per game callback.

Noir solves this by creating an event that wraps around a game callback. This event will then hold a bunch of functions that get called whenever the game callback is called.

## Connecting To A Callback

It's super easy to connect to a game callback, simply use `Noir.Callbacks:Connect(callbackName, function)` or `Noir.Callbacks:Once(callbackName, function)`

{% code lineNumbers="true" %}
```lua
Noir.Callbacks:Connect("onVehicleSpawn", function(vehicle_id, peer_id)
    server.announce("Server", "A vehicle was spawned by "..(server.getPlayerName(peer_id)))
end)
```
{% endcode %}

Behind the scenes, this automatically creates an `onVehicleSpawn` function in `_ENV` if it doesn't exist for Stormworks to use when `onVehicleSpawn` is triggered. Noir also retrieves or creates an event for this callback stored in`Noir.Callbacks.Events`. The created function essentially fires the created event with all the arguments provided by Stormworks, and the function passed to `Noir.Callbacks:Connect()` is automatically connected to the new event.

## Removing A Callback Connection

`Noir.Callbacks:Connect()`and `Noir.Callbacks:Once()` both return a `NoirConnection` which comes with a method called `:Disconnect()`.

This method essentially disconnects the connection from the event, meaning the function in the connection won't get triggered again if the event is called.

See [#events](libraries.md#events "mention") for an example on event disconnection and events in general.
