# ScreenPopupWidget

**Noir.Classes.ScreenPopupWidget**: `NoirClass`

Represents a screen popup widget to be shown to players via UIService.

Not to be confused with a popup which is shown in 3D space.

---

```lua
Noir.Classes.ScreenPopupWidget:Init(ID, visible, text, X, Y, player)
```
Initializes class objects from this class.

### Parameters
- `ID`: integer
- `visible`: boolean
- `text`: string
- `X`: number
- `Y`: number
- `player`: NoirPlayer|nil

---

```lua
Noir.Classes.ScreenPopupWidget:_Serialize() ---@diagnostic disable-next-line missing-return
```
Serializes this screen popup widget.

### Returns
- `NoirSerializedScreenPopupWidget`

---

```lua
Noir.Classes.ScreenPopupWidget:Deserialize(serializedWidget)
```
Deserializes a screen popup widget.

### Parameters
- `serializedWidget`: NoirSerializedScreenPopupWidget
### Returns
- `NoirScreenPopupWidget|nil`

---

```lua
Noir.Classes.ScreenPopupWidget:_Update(player)
```
Handles updating this widget.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Classes.ScreenPopupWidget:_Destroy(player)
```
Handles destroying this widget.

### Parameters
- `player`: NoirPlayer