# PlayerService

**Noir.Services.PlayerService**: `NoirService`

A service that wraps SW players in a class. Essentially makes players OOP.

---

```lua
Noir.Services.PlayerService:_LoadPlayers()
```
Load players current in-game.

---

```lua
Noir.Services.PlayerService:_GivePlayerData(steam_id, name, peer_id, admin, auth)
```
Gives data to a player.

Used internally.

### Parameters
- `steam_id`: integer|string
- `name`: string
- `peer_id`: integer
- `admin`: boolean
- `auth`: boolean
### Returns
- `NoirPlayer|nil`

---

```lua
Noir.Services.PlayerService:_RemovePlayerData(player)
```
Removes data for a player.

Used internally.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Services.PlayerService:_IsHost(peer_id)
```
Returns whether or not a player is the server's host. Only applies in dedicated servers.

Used internally.

### Parameters
- `peer_id`: integer
### Returns
- `boolean`

---

```lua
Noir.Services.PlayerService:_MarkRecognized(player)
```
Mark a player as recognized to prevent onJoin being called for them after an addon reload.

Used internally.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Services.PlayerService:_IsRecognized(player)
```
Returns whether or not a player is recognized.

Used internally.

### Parameters
- `player`: NoirPlayer
### Returns
- `boolean`

---

```lua
Noir.Services.PlayerService:_ClearRecognized()
```
Clear the list of recognized players.

Used internally.

---

```lua
Noir.Services.PlayerService:_UnmarkRecognized(player)
```
Mark a player as not recognized.

Used internally.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Services.PlayerService:_GetSavedProperties()
```
Returns all saved player properties saved in g_savedata.

Used internally. Do not use in your code.

### Returns
- `NoirSavedPlayerProperties`

---

```lua
Noir.Services.PlayerService:_SaveProperty(player, property)
```
Save a player's property to g_savedata.

Used internally. Do not use in your code.

### Parameters
- `player`: NoirPlayer
- `property`: string

---

```lua
Noir.Services.PlayerService:_GetSavedPropertiesForPlayer(player)
```
Get a player's saved properties.

Used internally. Do not use in your code.

### Parameters
- `player`: NoirPlayer
### Returns
- `table<string, boolean>|nil`

---

```lua
Noir.Services.PlayerService:_RemoveSavedProperties(player)
```
Removes a player's saved properties from g_savedata.

Used internally. Do not use in your code.

### Parameters
- `player`: NoirPlayer

---

```lua
Noir.Services.PlayerService:GetPlayers(usePeerIDsAsIndex)
```
Returns all players.

This is the preferred way to get all players instead of using `Noir.Services.PlayerService.Players`.

### Parameters
- `usePeerIDsAsIndex`: boolean|nil - If true, the indices of the returned table will match the peer ID of the value (player) matched to the index. Having this as true is slightly faster
### Returns
- `table<integer, NoirPlayer>`

---

```lua
Noir.Services.PlayerService:GetPlayer(ID)
```
Returns a player by their peer ID.

This is the preferred way to get a player.

### Parameters
- `ID`: integer
### Returns
- `NoirPlayer|nil`

---

```lua
Noir.Services.PlayerService:GetPlayerBySteam(steam)
```
Returns a player by their Steam ID.

Note that two players or more can have the same Steam ID if they spoof their Steam ID or join the server on two Stormworks instances.

### Parameters
- `steam`: string
### Returns
- `NoirPlayer|nil`

---

```lua
Noir.Services.PlayerService:GetPlayerByName(name)
```
Returns a player by their exact name.

Consider using `:SearchPlayerByName()` if the player name only needs to match partially.

### Parameters
- `name`: string
### Returns
- `NoirPlayer|nil`

---

```lua
Noir.Services.PlayerService:GetPlayerByCharacter(character)
```
Get a player by their character.

### Parameters
- `character`: NoirObject
### Returns
- `NoirPlayer|nil`

---

```lua
Noir.Services.PlayerService:SearchPlayerByName(name)
```
Searches for a player by their name, similar to a Google search but way simpler under the hood.

### Parameters
- `name`: string
### Returns
- `NoirPlayer|nil`

---

```lua
Noir.Services.PlayerService:IsSamePlayer(playerA, playerB)
```
Returns whether or not two players are the same.

### Parameters
- `playerA`: NoirPlayer
- `playerB`: NoirPlayer
### Returns
- `boolean`