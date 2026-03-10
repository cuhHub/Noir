# Logger

**Noir.Classes.Logger**: `NoirClass`

Represents a logger, used for logging messages to chat and other places.

Functionality of loggers can be extended with LoggerMiddleware instances, allowing for

sending logs to other places - like a Discord webhook via HTTP.

---

```lua
Noir.Classes.Logger:Init(name)
```
Initializes Logger class objects.

### Parameters
- `name`: string

---

```lua
Noir.Classes.Logger:SetEnabled(enabled)
```
Sets whether the logger is enabled or not.

### Parameters
- `enabled`: boolean

---

```lua
Noir.Classes.Logger:IsEnabled()
```
Returns if the logger is enabled.

### Returns
- `boolean`

---

```lua
Noir.Classes.Logger:SetFilter(level)
```
Sets the log filter.

### Parameters
- `level`: NoirLogLevel

---

```lua
Noir.Classes.Logger:AttachMiddleware(middleware)
```
Attaches middleware to this logger.

### Parameters
- `middleware`: NoirLoggerMiddleware

---

```lua
Noir.Classes.Logger:SetFormatter(formatter)
```
Sets the formatter for this logger.

### Parameters
- `formatter`: NoirLogFormatter

---

```lua
Noir.Classes.Logger:GetLevelName(level)
```
Returns the log level formatted a string.

### Parameters
- `level`: NoirLogLevel
### Returns
- `string`

---

```lua
Noir.Classes.Logger:CanHandle(level)
```
Returns if this logger can handle a log level based on the logger's filter.

### Parameters
- `level`: NoirLogLevel
### Returns
- `boolean`

---

```lua
Noir.Classes.Logger:GetMiddleware()
```
Returns all middleware attached to this logger.

### Returns
- `table<integer, NoirLoggerMiddleware>`

---

```lua
Noir.Classes.Logger:_PropagateLogRecord(record)
```
Propagates a log record to all attached middleware for processing.

### Parameters
- `record`: NoirLogRecord

---

```lua
Noir.Classes.Logger:Log(level, message, ...)
```
Sends a log.

### Parameters
- `level`: NoirLogLevel
- `message`: string
- `...`: any
### Returns
- `NoirLogRecord`

---

```lua
Noir.Classes.Logger:Debug(message, ...)
```
Sends a debug log.

### Parameters
- `message`: any
- `...`: any
### Returns
- `NoirLogRecord`

---

```lua
Noir.Classes.Logger:Info(message, ...)
```
Sends an info log.

### Parameters
- `message`: any
- `...`: any
### Returns
- `NoirLogRecord`

---

```lua
Noir.Classes.Logger:Success(message, ...)
```
Sends a success log.

### Parameters
- `message`: any
- `...`: any
### Returns
- `NoirLogRecord`

---

```lua
Noir.Classes.Logger:Warning(message, ...)
```
Sends a warning log.

### Parameters
- `message`: any
- `...`: any
### Returns
- `NoirLogRecord`

---

```lua
Noir.Classes.Logger:Error(message, ...)
```
Sends an error log.

### Parameters
- `message`: any
- `...`: any
### Returns
- `NoirLogRecord`