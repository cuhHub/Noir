# Player

**Noir.Classes.PlayerClass**: `NoirClass`

Represents a player.

---

```lua
Noir.Classes.PlayerClass:Init(name, ID, steam, admin, auth, permissions)
```
Initializes player class objects.

### Parameters
- `name`: string
- `ID`: integer
- `steam`: string
- `admin`: boolean
- `auth`: boolean
- `permissions`: table<string, boolean>

---

```lua
Noir.Classes.PlayerClass:SetPermission(permission)
```
Give this player a permission.

### Parameters
- `permission`: string

---

```lua
Noir.Classes.PlayerClass:HasPermission(permission)
```
Returns whether or not this player has a permission.

### Parameters
- `permission`: string
### Returns
- `boolean`

---

```lua
Noir.Classes.PlayerClass:RemovePermission(permission)
```
Remove a permission from this player.

### Parameters
- `permission`: string

---

```lua
Noir.Classes.PlayerClass:GetPermissions()
```
Returns a table containing the player's permissions.

### Returns
- `table<integer, string>`

---

```lua
Noir.Classes.PlayerClass:SetAuth(auth)
```
Sets whether or not this player is authed.

### Parameters
- `auth`: boolean

---

```lua
Noir.Classes.PlayerClass:SetAdmin(admin)
```
Sets whether or not this player is an admin.

### Parameters
- `admin`: boolean

---

```lua
Noir.Classes.PlayerClass:Kick()
```
Kicks this player.

---

```lua
Noir.Classes.PlayerClass:Ban()
```
Bans this player.

---

```lua
Noir.Classes.PlayerClass:Teleport(pos)
```
Teleports this player.

### Parameters
- `pos`: SWMatrix

---

```lua
Noir.Classes.PlayerClass:GetPosition()
```
Returns this player's position.

### Returns
- `SWMatrix`

---

```lua
Noir.Classes.PlayerClass:SetAudioMood(mood)
```
Set the player's audio mood.

### Parameters
- `mood`: SWAudioMoodEnum

---

```lua
Noir.Classes.PlayerClass:GetCharacter()
```
Returns this player's character as a NoirObject.

### Returns
- `NoirObject|nil`

---

```lua
Noir.Classes.PlayerClass:GetLook()
```
Returns this player's look direction.

### Returns
- `number`: LookX
- `number`: LookY
- `number`: LookZ

---

```lua
Noir.Classes.PlayerClass:Notify(title, message, notificationType)
```
Send this player a notification.

### Parameters
- `title`: string
- `message`: string
- `notificationType`: SWNotificationTypeEnum