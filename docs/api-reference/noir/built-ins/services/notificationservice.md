# NotificationService

**Noir.Services.NotificationService**: `NoirService`

A service for sending notifications to players.

---

```lua
Noir.Services.NotificationService:Notify(title, message, notificationType, player, ...)
```
Notify a player or multiple players.

### Parameters
- `title`: string
- `message`: string
- `notificationType`: SWNotificationTypeEnum
- `player`: NoirPlayer|table<integer, NoirPlayer>
- `...`: any

---

```lua
Noir.Services.NotificationService:Success(title, message, player, ...)
```
Send a success notification to a player.

### Parameters
- `title`: string
- `message`: string
- `player`: NoirPlayer|table<integer, NoirPlayer>
- `...`: any

---

```lua
Noir.Services.NotificationService:Warning(title, message, player, ...)
```
Send a warning notification to a player.

### Parameters
- `title`: string
- `message`: string
- `player`: NoirPlayer|table<integer, NoirPlayer>
- `...`: any

---

```lua
Noir.Services.NotificationService:Error(title, message, player, ...)
```
Send an error notification to a player.

### Parameters
- `title`: string
- `message`: string
- `player`: NoirPlayer|table<integer, NoirPlayer>
- `...`: any

---

```lua
Noir.Services.NotificationService:Info(title, message, player, ...)
```
Send an info notification to a player.

### Parameters
- `title`: string
- `message`: string
- `player`: NoirPlayer|table<integer, NoirPlayer>
- `...`: any