# Widget

**Noir.Classes.Widget**: `NoirClass`

Represents a UI widget for the UI service.

---

```lua
Noir.Classes.Widget:Init(ID, visible, widgetType, player)
```
Initializes class objects from this class.

### Parameters
- `ID`: integer
- `visible`: boolean
- `widgetType`: NoirWidgetType
- `player`: NoirPlayer|nil

---

```lua
Noir.Classes.Widget:Serialize()
```
Serializes this widget.

### Returns
- `NoirSerializedWidget`

---

```lua
Noir.Classes.Widget:_Serialize() ---@diagnostic disable-next-line missing-return
```
Serializes this widget.

*abstract method*

### Returns
- `NoirSerializedWidget`

---

```lua
Noir.Classes.Widget:Deserialize(serializedWidget)
```
Deserializes a serialized widget.

*abstract method*

*static method*

### Parameters
- `serializedWidget`: NoirSerializedWidget
### Returns
- `NoirWidget|nil`

---

```lua
Noir.Classes.Widget:IsVisible()
```
Returns if this widget is visible.

### Returns
- `boolean`

---

```lua
Noir.Classes.Widget:Update()
```
Updates this widget.

---

```lua
Noir.Classes.Widget:_Update()
```
Updates this widget.

*abstract method*

---

```lua
Noir.Classes.Widget:Destroy()
```
Destroys this widget.

---

```lua
Noir.Classes.Widget:_Destroy()
```
Destroys this widget.

*abstract method*

---

```lua
Noir.Classes.Widget:_GetPeerID()
```
Returns the peer ID for the player this widget is attached to, or -1 if for everyone.

### Returns
- `integer`

---

```lua
Noir.Classes.Widget:Exists()
```
Returns if this widget still exists within the UIService.

### Returns
- `boolean`

---

```lua
Noir.Classes.Widget:Remove()
```
Removes this widget from the UIService and from the game.