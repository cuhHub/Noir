# ChatLoggerMiddleware

**Noir.Classes.ChatLoggerMiddleware**: `NoirClass`

Logger middleware to send logs to chat.

---

```lua
Noir.Classes.ChatLoggerMiddleware:Init()
```
Initializes ChatLoggerMiddleware class objects.

---

```lua
Noir.Classes.ChatLoggerMiddleware:OnLog(record)
```
Called when a log from the attached logger is received.

### Parameters
- `record`: NoirLogRecord