# RelPos

**Noir.Classes.RelPos**: `NoirClass`

Represents a relative position.

See the built-in `RelPosService` for more info.

---

```lua
Noir.Classes.RelPos:Init(tileName, offset)
```
Initializes class objects from this class.

### Parameters
- `tileName`: string
- `offset`: SWMatrix

---

```lua
Noir.Classes.RelPos:GetGlobalPositions()
```
Returns all global positions this relative position can be found at.

### Returns
- `table<integer, SWMatrix>`