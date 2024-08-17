# VehicleService

**Noir.Services.VehicleService**: `NoirService`

A service for interacting with vehicles.

Note that vehicles are referred to as bodies, while vehicle groups are referred to as vehicles.

---

```lua
Noir.Services.VehicleService:_LoadSavedVehicles()
```
Load all saved vehicles. It is important bodies are loaded beforehand. If this is not the case, they will be created automatically but possibly with incorrect data.

Used internally.

---

```lua
Noir.Services.VehicleService:_LoadSavedBodies()
```
Load all saved bodies.

Used internally.

---

```lua
Noir.Services.VehicleService:_RegisterVehicle(ID, player, spawnPosition, cost, fireEvent)
```
Register a vehicle to the vehicle service.

Used internally.

### Parameters
- `ID`: integer
- `player`: NoirPlayer|nil
- `spawnPosition`: SWMatrix
- `cost`: number
- `fireEvent`: boolean
### Returns
- `NoirVehicle|nil`

---

```lua
Noir.Services.VehicleService:_SaveVehicle(vehicle)
```
Save a vehicle.

Used internally.

### Parameters
- `vehicle`: NoirVehicle

---

```lua
Noir.Services.VehicleService:_UnsaveVehicle(vehicle)
```
Unsave a vehicle.

Used internally.

### Parameters
- `vehicle`: NoirVehicle

---

```lua
Noir.Services.VehicleService:_UnregisterVehicle(vehicle, fireEvent)
```
Unregister a vehicle from the vehicle service.

Used internally.

### Parameters
- `vehicle`: NoirVehicle
- `fireEvent`: boolean

---

```lua
Noir.Services.VehicleService:_RegisterBody(ID, player, spawnPosition, cost, fireEvent)
```
Register a body to the vehicle service.

Used internally.

### Parameters
- `ID`: integer
- `player`: NoirPlayer|nil
- `spawnPosition`: SWMatrix
- `cost`: number
- `fireEvent`: boolean
### Returns
- `NoirBody|nil`

---

```lua
Noir.Services.VehicleService:_SaveBody(body)
```
Save a body.

Used internally.

### Parameters
- `body`: NoirBody

---

```lua
Noir.Services.VehicleService:_UnsaveBody(body)
```
Unsave a body.

Used internally.

### Parameters
- `body`: NoirBody

---

```lua
Noir.Services.VehicleService:_LoadBody(body, fireEvent)
```
Load a body internally.

Used internally.

### Parameters
- `body`: NoirBody
- `fireEvent`: boolean

---

```lua
Noir.Services.VehicleService:_UnloadBody(body, fireEvent)
```
Unload a body internally.

Used internally.

### Parameters
- `body`: NoirBody
- `fireEvent`: boolean

---

```lua
Noir.Services.VehicleService:_UnregisterBody(body, autoDespawnParentVehicle, fireEvent)
```
Unregister a body from the vehicle service.

Used internally.

### Parameters
- `body`: NoirBody
- `autoDespawnParentVehicle`: boolean
- `fireEvent`: boolean

---

```lua
Noir.Services.VehicleService:SpawnVehicle(componentID, position, addonIndex)
```
Spawn a vehicle.

Uses `server.spawnAddonVehicle` under the hood.

### Parameters
- `componentID`: integer
- `position`: SWMatrix
- `addonIndex`: integer|nil - Defaults to this addon's index
### Returns
- `NoirVehicle|nil`

---

```lua
Noir.Services.VehicleService:GetVehicle(ID)
```
Get a vehicle from the vehicle service.

### Parameters
- `ID`: integer
### Returns
- `NoirVehicle|nil`

---

```lua
Noir.Services.VehicleService:GetBody(ID)
```
Get a body from the vehicle service.

### Parameters
- `ID`: integer
### Returns
- `NoirBody|nil`

---

```lua
Noir.Services.VehicleService:GetVehicles()
```
Get all spawned vehicles.

### Returns
- `table<integer, NoirVehicle>`

---

```lua
Noir.Services.VehicleService:GetBodies()
```
Get all spawned bodies.



### Returns
- `table<integer, NoirBody>`

---

```lua
Noir.Services.VehicleService:GetBodiesFromPlayer(player)
```
Get all bodies spawned by a player.

### Parameters
- `player`: NoirPlayer
### Returns
- `table<integer, NoirBody>`

---

```lua
Noir.Services.VehicleService:GetVehiclesFromPlayer(player)
```
Get all vehicles spawned by a player.

### Parameters
- `player`: NoirPlayer
### Returns
- `table<integer, NoirVehicle>`