# PlayerClass

**Noir.Classes.PlayerClass**: `NoirClass`

A class that represents a player for the built-in PlayerService.

***

```lua
Noir.Classes.PlayerClass:Init(name, ID, steam, admin, auth)
```

Initializes player class objects.

#### Parameters

* `name`: string
* `ID`: integer
* `steam`: string
* `admin`: boolean
* `auth`: boolean

***

```lua
Noir.Classes.PlayerClass:_Serialize()
```

**⚠️ | Deprecated. Do not use.**

Serializes this player for g\_savedata.

***

```lua
Noir.Classes.PlayerClass._Deserialize(serializedPlayer)
```

**⚠️ | Deprecated. Do not use.**

Deserializes a player from g\_savedata into a player class object.

#### Parameters

* `serializedPlayer`: NoirSerializedPlayer

#### Returns

* `NoirPlayer`

***

```lua
Noir.Classes.PlayerClass:SetAuth(auth)
```

Sets whether or not this player is authed.

#### Parameters

* `auth`: boolean

***

```lua
Noir.Classes.PlayerClass:SetAdmin(admin)
```

Sets whether or not this player is an admin.

#### Parameters

* `admin`: boolean

***

```lua
Noir.Classes.PlayerClass:Kick()
```

Kicks this player.

***

```lua
Noir.Classes.PlayerClass:Ban()
```

Bans this player.

***

```lua
Noir.Classes.PlayerClass:Teleport(pos)
```

Teleports this player.

***

```lua
Noir.Classes.PlayerClass:GetPosition()
```

Returns this player's position.

#### Returns

* `SWMatrix`

***

```lua
Noir.Classes.PlayerClass:GetCharacter()
```

Returns this player's character as a NoirObject.

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Classes.PlayerClass:GetLook()
```

Returns this player's look direction.

#### Returns

* `number`: LookX
* `number`: LookY
* `number`: LookZ
