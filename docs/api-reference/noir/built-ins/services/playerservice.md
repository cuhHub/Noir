# PlayerService

**Noir.Services.PlayerService**: `NoirService`

A service that wraps SW players in a class. Essentially makes players OOP.

***

```lua
Noir.Services.PlayerService:_GivePlayerData(steam_id, name, peer_id, admin, auth)
```

Gives data to a player.

Used internally.

#### Parameters

* `steam_id`: integer
* `name`: string
* `peer_id`: integer
* `admin`: boolean
* `auth`: boolean

#### Returns

* `NoirPlayer|nil`

***

```lua
Noir.Services.PlayerService:_OverwriteSavedProperties(properties)
```

Overwrite saved properties.

Used internally. Do not use in your code.

#### Parameters

* `properties`: NoirSavedPlayerProperties

***

```lua
Noir.Services.PlayerService:_GetSavedProperties()
```

Returns all saved player properties saved in g\_savedata.

Used internally. Do not use in your code.

#### Returns

* `NoirSavedPlayerProperties`

***

```lua
Noir.Services.PlayerService:_RemovePlayerData(player)
```

Removes data for a player.

Used internally.

#### Parameters

* `player`: NoirPlayer

#### Returns

* `boolean`: success - Whether or not the operation was successful

***

```lua
Noir.Services.PlayerService:_SaveProperty(player, property)
```

Save a player's property to g\_savedata.

Used internally. Do not use in your code.

#### Parameters

* `player`: NoirPlayer
* `property`: string

***

```lua
Noir.Services.PlayerService:_GetSavedPropertiesForPlayer(player)
```

Get a player's saved properties.

Used internally. Do not use in your code.

#### Parameters

* `player`: NoirPlayer

#### Returns

* `table<string, boolean>|nil`

***

```lua
Noir.Services.PlayerService:_RemoveSavedProperties(player)
```

Removes a player's saved properties from g\_savedata.

Used internally. Do not use in your code.

#### Parameters

* `player`: NoirPlayer

***

```lua
Noir.Services.PlayerService:GetPlayers()
```

Returns all players.

This is the preferred way to get all players instead of using `Noir.Services.PlayerService.Players`.

#### Returns

* `table<integer, NoirPlayer>`

***

```lua
Noir.Services.PlayerService:GetPlayer(ID)
```

Returns a player by their peer ID.

This is the preferred way to get a player.

#### Parameters

* `ID`: integer

#### Returns

* `NoirPlayer|nil`

***

```lua
Noir.Services.PlayerService:GetPlayerBySteam(steam)
```

Returns a player by their Steam ID.

Note that two players or more can have the same Steam ID if they spoof their Steam ID or join the server on two Stormworks instances.

#### Parameters

* `steam`: string

#### Returns

* `NoirPlayer|nil`

***

```lua
Noir.Services.PlayerService:GetPlayerByName(name)
```

Returns a player by their exact name.

Consider using `:SearchPlayerByName()` if you want to search and not directly fetch.

#### Parameters

* `name`: string

#### Returns

* `NoirPlayer|nil`

***

```lua
Noir.Services.PlayerService:SearchPlayerByName(name)
```

Searches for a player by their name, similar to a Google search but way simpler under the hood.

#### Parameters

* `name`: string

#### Returns

* `NoirPlayer|nil`

***

```lua
Noir.Services.PlayerService:IsSamePlayer(playerA, playerB)
```

Returns whether or not two players are the same.

#### Parameters

* `playerA`: NoirPlayer
* `playerB`: NoirPlayer

#### Returns

* `boolean`
