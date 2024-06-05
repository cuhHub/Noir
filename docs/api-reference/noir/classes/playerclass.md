# PlayerClass

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

***

```lua
Noir.Classes.PlayerClass:SetCharacterData(health, interactable, AI)
```

Sets the character data for this player.

#### Parameters

* `health`: number
* `interactable`: boolean
* `AI`: boolean

***

```lua
Noir.Classes.PlayerClass:Heal(amount)
```

Heals this player by a certain amount.

#### Parameters

* `amount`: number

***

```lua
Noir.Classes.PlayerClass:Damage(amount)
```

Damages this player by a certain amount.

#### Parameters

* `amount`: number

***

```lua
Noir.Classes.PlayerClass:GetCharacter()
```

Returns this player's character object ID.

#### Returns

* `integer|nil`

***

```lua
Noir.Classes.PlayerClass:Revive()
```

Revives this player.

***

```lua
Noir.Classes.PlayerClass:GetCharacterData()
```

Returns this player's character data.

#### Returns

* `SWObjectData|nil`

***

```lua
Noir.Classes.PlayerClass:GetHealth()
```

Returns this player's health.

#### Returns

* `number`

***

```lua
Noir.Classes.PlayerClass:IsDowned()
```

Returns whether or not this player is downed.

#### Returns

* `boolean`
