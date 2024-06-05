# Noir

**Noir.Version**: `string`

The current version of Noir. Follows [Semantic Versioning.](https://semver.org)

***

**Noir.Started**: `NoirEvent`

This event is called when the framework is started. Use this event to safely run your code.

***

**Noir.HasStarted**: `boolean`

This represents whether or not the framework has started.

***

**Noir.IsStarting**: `boolean`

This represents whether or not the framework is starting.

***

**Noir.AddonReason**: `NoirAddonReason`

This represents whether or not the addon was:

* Reloaded
* Started via a save being loaded into
* Started via a save creation

***

```lua
Noir:Start()
```

Starts the framework. This will initalize all services, then upon completion, all services will be started. Use the `Noir.Started` event to safely run your code.
