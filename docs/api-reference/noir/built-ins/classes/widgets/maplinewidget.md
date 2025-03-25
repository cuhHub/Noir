# MapLineWidget

**Noir.Classes.MapLineWidget**: `NoirClass`

Represents a map line UI widget to be shown to players via UIService.

---

```lua
Noir.Classes.MapLineWidget:Init(ID, visible, startPosition, endPosition, width, colorR, colorG, colorB, colorA, player)
```
Initializes class objects from this class.

### Parameters
- `ID`: integer
- `visible`: boolean
- `startPosition`: SWMatrix
- `endPosition`: SWMatrix
- `width`: number
- `colorR`: number
- `colorG`: number
- `colorB`: number
- `colorA`: number
- `player`: NoirPlayer|nil

---

```lua
Noir.Classes.MapLineWidget:_Serialize()
```
Serializes this map line widget.

### Returns
- `NoirSerializedMapLineWidget`

---

```lua
Noir.Classes.MapLineWidget:Deserialize(serializedWidget)
```
Deserializes a map line widget.

### Parameters
- `serializedWidget`: NoirSerializedMapLineWidget
### Returns
- `NoirMapLineWidget|nil`

---

```lua
Noir.Classes.MapLineWidget:_Update(player)
```
Handles updating this widget.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Classes.MapLineWidget:_Destroy(player)
```
Handles destroying this widget.

### Parameters
- `player`: NoirPlayer