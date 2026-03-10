# Player

**Noir.Classes.Player**: `NoirClass`

Represents a player.

---

```lua
Noir.Classes.Player:Init(name, ID, steam, admin, auth)
```
Initializes player class objects.

### Parameters
- `name`: string
- `ID`: integer
- `steam`: string
- `admin`: boolean
- `auth`: boolean

---

```lua
Noir.Classes.Player:_CharacterLoad(character)
```
Triggers `OnCharacterLoad`.

Used internally.

### Parameters
- `character`: NoirObject

---

```lua
Noir.Classes.Player:SetAuth(auth)
```
Sets whether or not this player is authed.

### Parameters
- `auth`: boolean

---

```lua
Noir.Classes.Player:SetAdmin(admin)
```
Sets whether or not this player is an admin.

### Parameters
- `admin`: boolean

---

```lua
Noir.Classes.Player:Kick()
```
Kicks this player.

---

```lua
Noir.Classes.Player:Ban()
```
Bans this player.

---

```lua
Noir.Classes.Player:Teleport(pos)
```
Teleports this player.

### Parameters
- `pos`: SWMatrix

---

```lua
Noir.Classes.Player:GetPosition()
```
Returns this player's position.

### Returns
- `SWMatrix`

---

```lua
Noir.Classes.Player:SetAudioMood(mood)
```
Set the player's audio mood.

### Parameters
- `mood`: SWAudioMoodEnum

---

```lua
Noir.Classes.Player:GetCharacter()
```
Returns this player's character as a NoirObject.

### Returns
- `NoirObject|nil`

---

```lua
Noir.Classes.Player:GetLook()
```
Returns this player's look direction.

### Returns
- `number`: LookX
- `number`: LookY
- `number`: LookZ

---

```lua
Noir.Classes.Player:Notify(title, message, notificationType)
```
Send this player a notification.

### Parameters
- `title`: string
- `message`: string
- `notificationType`: SWNotificationTypeEnum