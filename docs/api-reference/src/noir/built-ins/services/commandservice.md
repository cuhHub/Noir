# CommandService

**Noir.Services.CommandService**: `NoirService`

A service for easily creating commands with support for command aliases, permissions, etc.

---

```lua
Noir.Services.CommandService:FindCommand(query)
```
Get a command by the name or alias.

### Parameters
- `query`: string
### Returns
- `NoirCommand|nil`

---

```lua
Noir.Services.CommandService:CreateCommand(name, aliases, requiredPermissions, requiresAuth, requiresAdmin, capsSensitive, description, callback)
```
Create a new command.

### Parameters
- `name`: string - The name of the command (eg: if you provided "help", the player would need to type "?help" in chat)
- `aliases`: table<integer, string> - The aliases of the command
- `requiredPermissions`: table<integer, string>|nil - The required permissions for this command
- `requiresAuth`: boolean|nil - Whether or not this command requires auth
- `requiresAdmin`: boolean|nil - Whether or not this command requires admin
- `capsSensitive`: boolean|nil - Whether or not this command is case-sensitive
- `description`: string|nil - The description of this command
- `callback`: fun(player: - NoirPlayer, message: string, args: table<integer, string>, hasPermission: boolean)
### Returns
- `NoirCommand`

---

```lua
Noir.Services.CommandService:GetCommand(name)
```
Get a command by the name.

### Parameters
- `name`: string
### Returns
- `NoirCommand|nil`

---

```lua
Noir.Services.CommandService:RemoveCommand(name)
```
Remove a command.

### Parameters
- `name`: string

---

```lua
Noir.Services.CommandService:GetCommands()
```
Returns all commands.

### Returns
- `table<string, NoirCommand>`