# Message

**Noir.Classes.Message**: `NoirClass`

Represents a message.

---

```lua
Noir.Classes.Message:Init(author, isAddon, content, title, sentAt, recipient)
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
Noir.Classes.Message:_Serialize()
```
Serializes the message into a g_savedata-safe format.

Used internally.

### Returns
- `NoirSerializedMessage`

---

```lua
Noir.Classes.Message:_Deserialize(serializedMessage)
```
Deserializes the message from a g_savedata-safe format.

Used internally.

### Parameters
- `serializedMessage`: NoirSerializedMessage