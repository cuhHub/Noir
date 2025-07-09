# RelPosService

**Noir.Services.RelPosService**: `NoirService`

This is a service that allows you to convert a global position into an offset from the tile the global position rests on (if any).

This allows you to create positions that work in all seeds without having to create a zone in the addon editor and such.

In order to initially get a relative position for a global position and save it, you'll need to make a command to    call `:GetRelPos()` for whatever position, then show the offset and tile name to you in which then you can manually create and save    the relative position in your code (use `:CreateRelPos(tileName, offset)`).

---

```lua
Noir.Services.RelPosService:_FillTileCache()
```
Fills the tile cache.

---

```lua
Noir.Services.RelPosService:GetGlobalPositions(relPos)
```
Returns all global positions from a relative position.

### Parameters
- `relPos`: NoirRelPos
### Returns
- `table<integer, SWMatrix>`

---

```lua
Noir.Services.RelPosService:GetRelPos(position)
```
Returns a relative position from the provided global position.

A relative position is a simply a position relative to the closest tile to the provided global position.

This is useful as you can create positions that work in all seeds.

### Parameters
- `position`: SWMatrix
### Returns
- `NoirRelPos`

---

```lua
Noir.Services.RelPosService:CreateRelPos(tileName, offset)
```
Creates a relative position with the provided tile name and offset.

### Parameters
- `tileName`: string
- `offset`: SWMatrix
### Returns
- `NoirRelPos`