# DebugLogLoggerMiddleware

**Noir.Classes.DebugLogLoggerMiddleware**: `NoirClass`

Logger middleware to send logs via `debug.log`.

---

```lua
Noir.Classes.DebugLogLoggerMiddleware:Init()
```
Initializes DebugLogLoggerMiddleware class objects.

---

```lua
Noir.Classes.DebugLogLoggerMiddleware:OnLog(record)
```
Called when a log from the attached logger is received.

### Parameters
- `record`: NoirLogRecord