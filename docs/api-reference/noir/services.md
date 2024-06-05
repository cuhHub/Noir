---
description: >-
  A module of Noir that allows you to create organized services. These services
  can be used to hold methods that are all designed for a specific purpose.
---

# Services

**Noir.Services.CreatedServices**: `table<string, NoirService>`

A table containing created services. Do not modify this table directly. Please use `Noir.Services:GetService(name)` instead.

***

```lua
Noir.Services:CreateService(name)
```

Create a service. This service will be initialized and started after `Noir:Start()` is called.

#### Parameters

* `name`: string

#### Returns

* `NoirService`

***

```lua
Noir.Services:GetService(name)
```

Retrieve a service by its name. This will error if the service hasn't initialized yet.

#### Parameters

* `name`: string

#### Returns

* `NoirService|nil`
