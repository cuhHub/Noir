# UIService

**Noir.Services.UIService**: `NoirService`

A service for showing UI to players in an OOP manner.    Map UI, screen popups, physical popups, etc, are all supported.

---

```lua
Noir.Services.UIService:_GetSavedWidgets()
```
Returns all saved widgets (serialized versions).

Used internally. Do not use in your code.

### Returns
- `table<integer, NoirSerializedWidget>`

---

```lua
Noir.Services.UIService:_LoadWidgets()
```
Loads all widgets saved in g_savedata.

Used internally. Do not use in your code.

---

```lua
Noir.Services.UIService:_SaveWidget(widget)
```
Saves a widget.

Used internally. Do not use in your code.

### Parameters
- `widget`: NoirWidget

---

```lua
Noir.Services.UIService:_UnsaveWidget(widget)
```
Unsaves a widget.

Used internally. Do not use in your code.

### Parameters
- `widget`: NoirWidget

---

```lua
Noir.Services.UIService:_AddWidget(widget)
```
Adds a widget to the UIService.

Used internally. Do not use in your code.

### Parameters
- `widget`: NoirWidget - The widget to add

---

```lua
Noir.Services.UIService:_RemoveWidget(widget)
```
Removes a widget from the UIService.

Used internally. Do not use in your code.

### Parameters
- `widget`: NoirWidget - The widget to remove

---

```lua
Noir.Services.UIService:CreateMapLabel(text, labelType, position, visible, player)
```
Creates a map label widget.

This is a label that is shown on the map (duh), similar to what you see at shipwrecks, key locations (e.g: "Harrison Airbase").

### Parameters
- `text`: string
- `labelType`: SWLabelTypeEnum
- `position`: SWMatrix
- `visible`: boolean
- `player`: NoirPlayer|nil
### Returns
- `NoirMapLabelWidget`

---

```lua
Noir.Services.UIService:CreateScreenPopup(text, X, Y, visible, player)
```
Creates a screen popup widget.

This is a rounded-rectangle with text shown on your screen, exactly the same as the tutorial popups    you get when you start a singleplayer game.

### Parameters
- `text`: string
- `X`: number - -1 (left) to 1 (right)
- `Y`: number - -1 (top) to 1 (bottom)
- `visible`: boolean
- `player`: NoirPlayer|nil
### Returns
- `NoirScreenPopupWidget`

---

```lua
Noir.Services.UIService:CreatePopup(text, position, renderDistance, visible, player)
```
Creates a popup widget.

This is a 2D popup that is shown in 3D space. It can be attached to a body or an object too.

This is used in the Stormworks career tutorial.

### Parameters
- `text`: string
- `position`: SWMatrix
- `renderDistance`: number - in meters
- `visible`: boolean
- `player`: NoirPlayer|nil
### Returns
- `NoirPopupWidget`

---

```lua
Noir.Services.UIService:CreateMapLine(startPosition, endPosition, width, visible, colorR, colorG, colorB, colorA, player)
```
Creates a map line widget.

Simply renders a line connecting two points on the map.

### Parameters
- `startPosition`: SWMatrix
- `endPosition`: SWMatrix
- `width`: number
- `visible`: boolean
- `colorR`: number|nil
- `colorG`: number|nil
- `colorB`: number|nil
- `colorA`: number|nil
- `player`: NoirPlayer|nil
### Returns
- `NoirMapLineWidget`

---

```lua
Noir.Services.UIService:CreateMapObject(title, text, objectType, position, radius, visible, colorR, colorG, colorB, colorA, player)
```
Creates a map object widget.

Similar to a map label, this is shown on the map. However, this comes with an interactive circular icon    that when hovered over, shows a title and a subtitle.

This is what Stormworks missions use to show mission locations.

### Parameters
- `title`: string
- `text`: string
- `objectType`: SWMarkerTypeEnum
- `position`: SWMatrix
- `radius`: number
- `visible`: boolean
- `colorR`: number|nil
- `colorG`: number|nil
- `colorB`: number|nil
- `colorA`: number|nil
- `player`: NoirPlayer|nil
### Returns
- `NoirMapObjectWidget`

---

```lua
Noir.Services.UIService:GetWidget(ID)
```
Returns a widget by ID.

### Parameters
- `ID`: integer
### Returns
- `NoirWidget|nil`

---

```lua
Noir.Services.UIService:GetWidgetsShownToPlayer(player)
```
Returns all widgets shown to a player.

Unlike `:GetWidgetsBelongingToPlayer()`, this will include widgets that are shown to all players including this player.

### Parameters
- `player`: NoirPlayer
### Returns
- `table<integer, NoirWidget>`

---

```lua
Noir.Services.UIService:GetWidgetsBelongingToPlayer(player)
```
Returns all widgets belonging to a player (ignoring widgets belonging to all players).

### Parameters
- `player`: NoirPlayer
### Returns
- `table<integer, NoirWidget>`

---

```lua
Noir.Services.UIService:RemoveWidget(ID)
```
Remove a widget by ID. This will also hide the widget from players.

### Parameters
- `ID`: integer

---

```lua
Noir.Services.UIService:_GetSerializedPlayer(ID)
```
Returns the player a serialized widget belongs to.

Raises an error if the player does not exist and peer id is not -1.

### Parameters
- `ID`: integer - The peer ID of the player, or -1 if everyone
### Returns
- `NoirPlayer|nil`