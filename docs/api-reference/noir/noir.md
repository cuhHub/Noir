# Noir

**Noir.Version**: `string`

The current version of Noir.

Follows [Semantic Versioning.](https://semver.org)

---

**Noir.Started**: `NoirEvent`

This event is called when the framework is started.

Use this event to safely run your code.

---

**Noir.AddonName**: `string`

The name of this addon.

---

**Noir.HasStarted**: `boolean`

This represents whether or not the framework has started.

---

**Noir.IsStarting**: `boolean`

This represents whether or not the framework is starting.

---

**Noir.IsDedicatedServer**: `boolean`

This represents whether or not the addon is being ran in a dedicated server.

---

**Noir.AddonReason**: `NoirAddonReason`

This represents whether or not the addon was:

- Reloaded

- Started via a save load

- Started via a save creation

---

```lua
Noir:GetVersion()
```
Returns the MAJOR, MINOR, and PATCH of the current Noir version.

### Returns
- `string`: major - The MAJOR part of the version
- `string`: minor - The MINOR part of the version
- `string`: patch - The PATCH part of the version

---

```lua
Noir:Start()
```
Starts the framework.

This will initialize all services, then upon completion, all services will be started.

Use the `Noir.Started` event to safely run your code.