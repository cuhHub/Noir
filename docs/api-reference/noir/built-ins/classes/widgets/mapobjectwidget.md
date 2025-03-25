# MapObjectWidget

**Noir.Classes.MapObjectWidget**: `NoirClass`

Represents a map object UI widget to be shown to players via UIService.

---

```lua
Noir.Classes.MapObjectWidget:Init(ID, visible, title, text, objectType, position, radius, colorR, colorG, colorB, colorA, player)
```
Initializes class objects from this class.

### Parameters
- `ID`: integer
- `visible`: boolean
- `title`: string
- `text`: string
- `objectType`: SWMarkerTypeEnum
- `position`: SWMatrix
- `radius`: number
- `colorR`: number
- `colorG`: number
- `colorB`: number
- `colorA`: number
- `player`: NoirPlayer|nil

---

```lua
Noir.Classes.MapObjectWidget:AttachToBody(body)
```
Attaches this map object to a body.

Upon doing so, the map object will follow the body's position until detached with the `:Detach()` method.

You can offset the map object with the `AttachmentOffset` property.

Note that `:Update()` is called automatically.

### Parameters
- `body`: NoirBody

---

```lua
Noir.Classes.MapObjectWidget:AttachToObject(object)
```
Attaches this map object to an object.

Upon doing so, the map object will follow the object's position until detached with the `:Detach()` method.

You can offset the map object with the `AttachmentOffset` property.

Note that `:Update()` is called automatically.

### Parameters
- `object`: NoirObject

---

```lua
Noir.Classes.MapObjectWidget:Detach()
```
Detaches this map object from any body or object.

---

```lua
Noir.Classes.MapObjectWidget:_Serialize() ---@diagnostic disable-next-line missing-return
```
Serializes this map object widget.

### Returns
- `NoirSerializedMapObjectWidget`

---

```lua
Noir.Classes.MapObjectWidget:Deserialize(serializedWidget)
```
Deserializes a map object widget.

### Parameters
- `serializedWidget`: NoirSerializedMapObjectWidget
### Returns
- `NoirMapObjectWidget|nil`

---

```lua
Noir.Classes.MapObjectWidget:_Update(player)
```
Handles updating this widget.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Classes.MapObjectWidget:_Destroy(player)
```
Handles destroying this widget.

### Parameters
- `player`: NoirPlayer