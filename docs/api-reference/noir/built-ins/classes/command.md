# Command

**Noir.Classes.Command**: `NoirClass`

Represents a command.

---

```lua
Noir.Classes.Command:Init(name, aliases, requiredPermissions, requiresAuth, requiresAdmin, capsSensitive, description)
```
Initializes command class objects.

### Parameters
- `name`: string
- `aliases`: table<integer, string>
- `requiredPermissions`: table<integer, string>
- `requiresAuth`: boolean
- `requiresAdmin`: boolean
- `capsSensitive`: boolean
- `description`: string

---

```lua
Noir.Classes.Command:_Use(player, message, args)
```
Trigger this command.

Used internally. Do not use in your code.

### Parameters
- `player`: NoirPlayer
- `message`: string
- `args`: table

---

```lua
Noir.Classes.Command:_Matches(query)
```
Returns whether or not the string matches this command.

Used internally. Do not use in your code.

### Parameters
- `query`: string
### Returns
- `boolean`

---

```lua
Noir.Classes.Command:CanUse(player)
```
Returns whether or not the player can use this command.

### Parameters
- `player`: NoirPlayer
### Returns
- `boolean`