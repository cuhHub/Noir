# Bootstrapper

**Noir.Bootstrapper**: `table`

An internal module of Noir that is used to initialize and start services.

Do not use this in your code.

---

```lua
Noir.Bootstrapper:WrapServiceMethodsForService(service)
```
Wraps user-created methods in a service with code to prevent them from being called if the service hasn't initialized yet.

Do not use this in your code. This is used internally.

### Parameters
- `service`: NoirService

---

```lua
Noir.Bootstrapper:WrapServiceMethodsForAllServices()
```
Calls :WrapServiceMethodsForService() for all services.

Do not use this in your code. This is used internally.

---

```lua
Noir.Bootstrapper:_SortServicesByPriority(priorityName)
```
Sort services by `xPriority`.

Do not use this in your code. This is used internally.

### Parameters
- `priorityName`: string - e.g: "Init"
### Returns
- `table<integer, NoirService>`

---

```lua
Noir.Bootstrapper:InitializeServices()
```
Initialize all services.

This will order services by their `InitPriority` and then initialize them.

Do not use this in your code. This is used internally.

---

```lua
Noir.Bootstrapper:StartServices()
```
Start all services.

This will order services by their `StartPriority` and then start them.

Do not use this in your code. This is used internally.

---

```lua
Noir.Bootstrapper:SetIsDedicatedServer()
```
Determines whether or not the server this addon is being ran in is a dedicated server.

This evaluation is then used to set `Noir.IsDedicatedServer`.

Do not use this in your code. This is used internally.

---

```lua
Noir.Bootstrapper:SetAddonName()
```
Sets the `Noir.AddonName` to the name of your addon.

Do not use this in your code. This is used internally.