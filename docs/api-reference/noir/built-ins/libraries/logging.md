# Logging

**Noir.Libraries.Logging**: `NoirLibrary`

A library containing methods related to logging.

---

**Noir.Libraries.Logging.LoggingMode**: `NoirLoggingMode`

The mode to use when logging.

- "DebugLog": Sends logs to DebugView

- "Chat": Sends logs to chat

---

**Noir.Libraries.Logging.OnLog**: `NoirEvent`

An event called when a log is sent.

Arguments: (log: string)

---

**Noir.Libraries.Logging.Layout**: `string`

Represents the logging layout.

Requires two '%s' in the layout. First %s is the addon name, second %s is the log type, and the third %s is the log title. The message is then added after the layout.

---

```lua
Noir.Libraries.Logging:SetMode(mode)
```
Set the logging mode.

### Parameters
- `mode`: NoirLoggingMode

---

```lua
Noir.Libraries.Logging:Log(logType, title, message, ...)
```
Sends a log.

### Parameters
- `logType`: string
- `title`: string
- `message`: any
- `...`: any

---

```lua
Noir.Libraries.Logging:_FormatLog(logType, title, message, ...)
```
Format a log.

Used internally.

### Parameters
- `logType`: string
- `title`: string
- `message`: any
- `...`: any

---

```lua
Noir.Libraries.Logging:Error(title, message, ...)
```
Sends an error log.

### Parameters
- `title`: string
- `message`: any
- `...`: any

---

```lua
Noir.Libraries.Logging:Warning(title, message, ...)
```
Sends a warning log.

### Parameters
- `title`: string
- `message`: any
- `...`: any

---

```lua
Noir.Libraries.Logging:Info(title, message, ...)
```
Sends an info log.

### Parameters
- `title`: string
- `message`: any
- `...`: any

---

```lua
Noir.Libraries.Logging:Success(title, message, ...)
```
Sends a success log.

### Parameters
- `title`: string
- `message`: any
- `...`: any