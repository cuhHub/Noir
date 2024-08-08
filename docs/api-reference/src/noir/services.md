# Services

**Noir.Services**: `table`

A module of Noir that allows you to create organized services.

These services can be used to hold methods that are all designed for a specific purpose.

---

**Noir.Services.CreatedServices**: `table<string, NoirService>`

A table containing created services.

You probably do not need to modify or access this table directly. Please use `Noir.Services:GetService(name)` instead.

---

```lua
Noir.Services:CreateService(name, isBuiltIn, shortDescription, longDescription, authors)
```
Create a service.

This service will be initialized and started after `Noir:Start()` is called.

### Parameters
- `name`: string
- `isBuiltIn`: boolean|nil
- `shortDescription`: string|nil
- `longDescription`: string|nil
- `authors`: table<integer, string>|nil
### Returns
- `NoirService`

---

```lua
Noir.Services:GetService(name)
```
Retrieve a service by its name.

This will error if the service hasn't initialized yet.

### Parameters
- `name`: string
### Returns
- `NoirService|nil`

---

```lua
Noir.Services:RemoveService(name)
```
Remove a service.

### Parameters
- `name`: string

---

```lua
Noir.Services:FormatService(service)
```
Format a service into a string.

Returns the service name as well as the author(s) if any.

### Parameters
- `service`: NoirService
### Returns
- `string`

---

```lua
Noir.Services:GetBuiltInServices()
```
Returns all built-in Noir services.

### Returns
- `table<string, NoirService>`

---

```lua
Noir.Services:RemoveBuiltInServices(exceptions)
```
Removes built-in services from Noir. This may give a very slight performance increase.

**Use before calling Noir:Start().**

### Parameters
- `exceptions`: table<integer, string> - A table containing exact names of services to not remove