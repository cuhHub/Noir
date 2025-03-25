# MapLabelWidget

**Noir.Classes.MapLabelWidget**: `NoirClass`

Represents a map label UI widget to be shown to players via UIService.

---

```lua
Noir.Classes.MapLabelWidget:Init(ID, visible, text, labelType, position, player)
```
Initializes class objects from this class.

### Parameters
- `ID`: integer
- `visible`: boolean
- `text`: string
- `labelType`: SWLabelTypeEnum
- `position`: SWMatrix
- `player`: NoirPlayer|nil

---

```lua
Noir.Classes.MapLabelWidget:_Serialize() ---@diagnostic disable-next-line missing-return
```
Serializes this map label widget.

### Returns
- `NoirSerializedMapLabelWidget`

---

```lua
Noir.Classes.MapLabelWidget:Deserialize(serializedWidget)
```
Deserializes a map label widget.

### Parameters
- `serializedWidget`: NoirSerializedMapLabelWidget
### Returns
- `NoirMapLabelWidget|nil`

---

```lua
Noir.Classes.MapLabelWidget:_Update(player)
```
Handles updating this widget.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Classes.MapLabelWidget:_Destroy(player)
```
Handles destroying this widget.

### Parameters
- `player`: NoirPlayer