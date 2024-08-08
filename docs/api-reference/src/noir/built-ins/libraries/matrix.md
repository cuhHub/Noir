# Matrix

**Noir.Libraries.Matrix**: `NoirLibrary`

A library containing helper methods relating to Stormworks matrices.

---

```lua
Noir.Libraries.Matrix:Offset(pos, xOffset, yOffset, zOffset)
```
Offsets the position of a matrix.

### Parameters
- `pos`: SWMatrix
- `xOffset`: integer|nil
- `yOffset`: integer|nil
- `zOffset`: integer|nil
### Returns
- `SWMatrix`

---

```lua
Noir.Libraries.Matrix:Empty()
```
Returns an empty matrix. Equivalent to matrix.translation(0, 0, 0)

### Returns
- `SWMatrix`

---

```lua
Noir.Libraries.Matrix:Scale(scaleX, scaleY, scaleZ)
```
Returns a scaled matrix. Multiply this with another matrix to scale up said matrix.

This can be used to enlarge vehicles spawned via server.spawnAddonComponent, server.spawnAddonVehicle, etc.

### Parameters
- `scaleX`: number
- `scaleY`: number
- `scaleZ`: number
### Returns
- `SWMatrix`

---

```lua
Noir.Libraries.Matrix:RandomOffset(pos, xRange, yRange, zRange)
```
Offset a matrix by a random amount.

### Parameters
- `pos`: SWMatrix
- `xRange`: number
- `yRange`: number
- `zRange`: number
### Returns
- `SWMatrix`

---

```lua
Noir.Libraries.Matrix:ToString(pos)
```
Converts a matrix to a readable format.

### Parameters
- `pos`: SWMatrix
### Returns
- `string`