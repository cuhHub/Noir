# Message

**Noir.Classes.MessageClass**: `NoirClass`

Represents a message.

---

```lua
Noir.Classes.MessageClass:Init(author, isAddon, content, title, sentAt, recipient)
```
Initializes message class objects.

### Parameters
- `author`: NoirPlayer|nil
- `isAddon`: boolean
- `content`: string
- `title`: string
- `sentAt`: number|nil
- `recipient`: NoirPlayer|nil

---

```lua
Noir.Classes.MessageClass:_Serialize()
```
Serializes the message into a g_savedata-safe format.

Used internally.

### Returns
- `NoirSerializedMessage`

---

```lua
Noir.Classes.MessageClass:_Deserialize(serializedMessage)
```
Deserializes the message from a g_savedata-safe format.

Used internally.

### Parameters
- `serializedMessage`: NoirSerializedMessage