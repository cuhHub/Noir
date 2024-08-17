# MessageService

**Noir.Services.MessageService**: `NoirService`

A service for storing, accessing and sending messages.

---

```lua
Noir.Services.MessageService:_LoadSavedMessages()
```
Load all saved messages.

Used internally.

---

```lua
Noir.Services.MessageService:_InsertIntoTable(tbl, value, limit)
```
Insert a value into a table, removing the first value if the table is full.

Used internally.

### Parameters
- `tbl`: table
- `value`: any
- `limit`: integer

---

```lua
Noir.Services.MessageService:_RegisterMessage(title, content, author, isAddon, sentAt, recipient, fireEvent)
```
Register a message.

Used internally.

### Parameters
- `title`: string
- `content`: string
- `author`: NoirPlayer|nil
- `isAddon`: boolean
- `sentAt`: number|nil
- `recipient`: NoirPlayer|nil
- `fireEvent`: boolean|nil
### Returns
- `NoirMessage`

---

```lua
Noir.Services.MessageService:_SaveMessage(message)
```
Save a message.

Used internally.

### Parameters
- `message`: NoirMessage

---

```lua
Noir.Services.MessageService:SendMessage(player, title, content, ...)
```
Send a message to a player or all players.

### Parameters
- `player`: NoirPlayer|nil - nil = everyone
- `title`: string
- `content`: string
- `...`: any
### Returns
- `NoirMessage`

---

```lua
Noir.Services.MessageService:GetMessagesByPlayer(player)
```
Returns all messages sent by a player.

### Parameters
- `player`: NoirPlayer
### Returns
- `table<integer, NoirMessage>`

---

```lua
Noir.Services.MessageService:GetAllMessages(copy)
```
Returns all messages.

Earliest entries in table = Oldest messages

### Parameters
- `copy`: boolean|nil - Whether or not to copy the table (recommended), but may be slow
### Returns
- `table<integer, NoirMessage>`