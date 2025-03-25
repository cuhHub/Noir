# PopupWidget

**Noir.Classes.PopupWidget**: `NoirClass`

Represents a 3D space popup UI widget to be shown to players via UIService.

---

```lua
Noir.Classes.PopupWidget:Init(ID, visible, text, position, renderDistance, player)
```
Initializes a new popup widget.

### Parameters
- `ID`: number
- `visible`: boolean
- `text`: string
- `position`: SWMatrix
- `renderDistance`: number
- `player`: NoirPlayer|nil

---

```lua
Noir.Classes.PopupWidget:AttachToBody(body)
```
Attaches this popup to a body.

Upon doing so, the popup will follow the body's position until detached with the `:Detach()` method.

You can offset the popup from the body by setting the `AttachmentOffset` property.

Note that `:Update()` is called automatically.

### Parameters
- `body`: NoirBody

---

```lua
Noir.Classes.PopupWidget:AttachToObject(object)
```
Attaches this popup to an object.

Upon doing so, the popup will follow the object's position until detached with the `:Detach()` method.

You can offset the popup from the object by setting the `AttachmentOffset` property.

Note that `:Update()` is called automatically.

### Parameters
- `object`: NoirObject

---

```lua
Noir.Classes.PopupWidget:Detach()
```
Detaches this popup from any body or object.

---

```lua
Noir.Classes.PopupWidget:_Serialize() ---@diagnostic disable-next-line missing-return
```
Serializes this popup widget.

### Returns
- `NoirSerializedPopupWidget`

---

```lua
Noir.Classes.PopupWidget:Deserialize(serializedWidget)
```
Deserializes a popup widget.

### Parameters
- `serializedWidget`: NoirSerializedPopupWidget
### Returns
- `NoirPopupWidget|nil`

---

```lua
Noir.Classes.PopupWidget:_Update(player)
```
Handles updating this widget.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Classes.PopupWidget:_Destroy(player)
```
Handles destroying this widget.

### Parameters
- `player`: NoirPlayer