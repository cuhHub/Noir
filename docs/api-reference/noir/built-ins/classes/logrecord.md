# LogRecord

**Noir.Classes.LogRecord**: `NoirClass`

Represents a log record (a logged message, essentially).

---

```lua
Noir.Classes.LogRecord:Init(level, message, logger, time)
```
Initializes LogRecord class objects.

### Parameters
- `level`: NoirLogLevel
- `message`: string
- `logger`: NoirLogger
- `time`: number

---

```lua
Noir.Classes.LogRecord:Format()
```
Formats the record using the parent logger's formatter.

### Returns
- `string`