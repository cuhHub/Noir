# Vehicle

**Noir.Classes.VehicleClass**: `NoirClass`

Represents a vehicle.

In Stormworks, this is actually a vehicle group.

---

```lua
Noir.Classes.VehicleClass:Init(ID, owner, spawnPosition, cost)
```
Initializes vehicle class objects.

### Parameters
- `ID`: any
- `owner`: NoirPlayer|nil
- `spawnPosition`: SWMatrix
- `cost`: number

---

```lua
Noir.Classes.VehicleClass:_Serialize()
```
Serialize the vehicle.

Used internally.

### Returns
- `NoirSerializedVehicle`

---

```lua
Noir.Classes.VehicleClass:_Deserialize(serializedVehicle, addBodies)
```
Deserialize a serialized vehicle.



### Parameters
- `serializedVehicle`: NoirSerializedVehicle
- `addBodies`: boolean|nil
### Returns
- `NoirVehicle`

---

```lua
Noir.Classes.VehicleClass:_CalculatePrimaryBody()
```
Calculate the primary body.

Used internally.

---

```lua
Noir.Classes.VehicleClass:_AddBody(body)
```
Add a body to the vehicle.

Used internally.

### Parameters
- `body`: NoirBody

---

```lua
Noir.Classes.VehicleClass:_RemoveBody(body)
```
Remove a body from the vehicle.

Used internally.

### Parameters
- `body`: NoirBody

---

```lua
Noir.Classes.VehicleClass:GetPosition(voxelX, voxelY, voxelZ)
```
Return this vehicle's position.

Uses the vehicle's primary body internally.

### Parameters
- `voxelX`: integer|nil
- `voxelY`: integer|nil
- `voxelZ`: integer|nil
### Returns
- `SWMatrix`

---

```lua
Noir.Classes.VehicleClass:GetBody(ID)
```
Get a child body by its ID.

### Parameters
- `ID`: integer
### Returns
- `NoirBody|nil`

---

```lua
Noir.Classes.VehicleClass:Teleport(position)
```
Teleport the vehicle to a new position.

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.VehicleClass:Move(position)
```
Move the vehicle to a new position, essentially teleports without reloading the vehicle.

Note that rotation is ignored.

### Parameters
- `position`: SWMatrix

---

```lua
Noir.Classes.VehicleClass:Despawn()
```
Despawn the vehicle.