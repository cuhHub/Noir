# LoggerMiddleware

**Noir.Classes.LoggerMiddleware**: `NoirClass`

Represents a logger middleware.

Logger middleware are used to handle any logs sent via a logger.

An example of a logger middleware is one that receives logs and sends them in chat.

---

```lua
Noir.Classes.LoggerMiddleware:Init(name)
```
Initializes LoggerMiddleware class objects.

### Parameters
- `name`: string

---

```lua
Noir.Classes.LoggerMiddleware:SetFilter(level)
```
Sets the level filter for this middleware.

### Parameters
- `level`: NoirLogLevel

---

```lua
Noir.Classes.LoggerMiddleware:SetEnabled(enabled)
```
Enables or disables this middleware.

### Parameters
- `enabled`: boolean

---

```lua
Noir.Classes.LoggerMiddleware:CanHandle(record)
```
Returns if this middleware can handle a log record.

### Parameters
- `record`: NoirLogRecord
### Returns
- `boolean`

---

```lua
Noir.Classes.LoggerMiddleware:Process(record)
```
Processes a log record.

### Parameters
- `record`: NoirLogRecord

---

```lua
Noir.Classes.LoggerMiddleware:OnLog(record) end
```
Called when a log from the attached logger is received.

*abstractmethod - replace with own implementation in subclass*

### Parameters
- `record`: NoirLogRecord