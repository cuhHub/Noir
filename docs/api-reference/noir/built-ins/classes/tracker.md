# Tracker

**Noir.Classes.Tracker**: `NoirClass`

Represents a tracker assigned to a function via `Noir.Debugging`.

---

```lua
Noir.Classes.Tracker:Init(name, func)
```
Initializes class objects from this class.

### Parameters
- `name`: string
- `func`: function

---

```lua
Noir.Classes.Tracker:_BeforeCall(...)
```
Method called when the unmodified function is about to be called.

Used internally.

---

```lua
Noir.Classes.Tracker:_AfterCall(...)
```
Method called after the unmodified function has been called.

Used internally.

---

```lua
Noir.Classes.Tracker:ToFormattedString()
```
Formats this tracker into a string.

### Returns
- `string`

---

```lua
Noir.Classes.Tracker:Mount()
```
Returns the modified function.        local tracker = Noir.Services.DebuggerService:TrackFunction("myFunction", myFunction)    myFunction = tracker:Mount()

### Returns
- `function`

---

```lua
Noir.Classes.Tracker:GetName()
```
Returns the name of the function.

### Returns
- `string`

---

```lua
Noir.Classes.Tracker:GetAverageExecutionTime()
```
Returns the average execution time of the function.

### Returns
- `number`

---

```lua
Noir.Classes.Tracker:GetLastExecutionTime()
```
Returns the last execution time of the function.

### Returns
- `number`

---

```lua
Noir.Classes.Tracker:GetCallCount()
```
Returns the amount of times this function has been called.

### Returns
- `number`