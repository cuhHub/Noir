---
description: A simple tutorial going over how to start Noir.
cover: ../.gitbook/assets/19.png
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

# 🎓 Starting Noir

## Behind The Scenes

Starting Noir will tell Noir's bootstrapper to initialize and start all services, as well as setup other things.

This is important for Noir to function, so the below will teach you how to start Noir. It's very simple!



## Starting Noir

At the very bottom of your code, simply add:

```lua
Noir:Start()
```

This will start Noir, but Noir will actually wait for `onCreate` to fire, meaning if you were to run code in the root scope before or after starting Noir, Noir wouldn't have actually started yet. This raises a problem.

## Noir.Started Event

Noir has an event called `Started` which is fired when Noir has finished setting up. You can use this event to run code.

```lua
Noir.Started:Once(function()
    server.announce("Server", "Noir has started!")
    -- Your code
end)

Noir:Start()
server.announce("Server", "Noir hasn't started yet!")
```

That solves the problem we went over earlier.&#x20;

## Noir.AddonReason Attribute

Noir has an attribute called `AddonReason` which is determined and updated after Noir has finished setting up. This attribute tells your addon how it was created, whether it is from a save being created, a save being loaded into, or the addon simply being reloaded with `?reload_scripts`.

This attribute can be:

* `"AddonReload"` -> The addon was reloaded.
* `"SaveCreate"` -> A save was created with the addon enabled.
* `"SaveLoad"` -> A save with the addon enabled was loaded into.

{% code lineNumbers="true" %}
```lua
Noir.Started:Once(function()
    if Noir.AddonReason == "AddonReload" then
        server.announce("Server", "My addon was reloaded")
    elseif Noir.AddonReason == "SaveCreate" then
        server.announce("Server", "A save was created with my addon")
    elseif Noir.AddonReason == "SaveLoad" then
        server.announce("Server", "A save was loaded into with my addon")
    else -- don't worry! AddonReason will never be anything but AddonReload, SaveCreate, or SaveLoad
        server.announce("Server", "This is weird...")
    end
end)

Noir:Start()
```
{% endcode %}

## Noir.Version Attribute

Finally, Noir has an attribute called `Version` which represents the current version of Noir.

This version is logged to DebugView (default) or chat depending on `Noir.Libraries.Logging.LoggingMode` when Noir starts, along with other information.