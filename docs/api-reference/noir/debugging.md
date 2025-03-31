# Debugging

**Noir.Debugging**: `table`

A module of Noir for debugging your code. This allows you to raise errors in the event something goes wrong    as well as track functions to see how well they are performing and sort these functions in order of performance.

This can be useful for figuring out what functions are performing the worst which can help you optimize your addon.

This is not recommended to use in production it service may slow your addon. Please use it for debugging purposes only.

---

**Noir.Debugging.Enabled**: `boolean`

Enables/disables debugging. False by default, and it is recommended to keep it this way in production.

---

**Noir.Debugging.Trackers**: `table`

A table containing all created trackers for functions.

---

**Noir.Debugging._TrackingExceptions**: `table`

A table containing all functions and tables that should not be tracked.

---

```lua
Noir.Debugging:RaiseError(source, message, ...)
```
Raises an error.

This method can still be called regardless of if debugging is enabled or not.

`error()` is aliased to this method.

### Parameters
- `source`: string
- `message`: string
- `...`: any

---

```lua
Noir.Debugging:GetTrackedFunctions(copy)
```
Returns all tracked functions with the option to copy.

### Parameters
- `copy`: boolean|nil
### Returns
- `table<integer, NoirTracker>`

---

```lua
Noir.Debugging:GetLastCalledTracked()
```
Returns the most recently called tracked functions.

### Returns
- `table<integer, NoirTracker>`

---

```lua
Noir.Debugging:ShowLastCalledTracked()
```
Shows the most recently called tracked functions.

---

```lua
Noir.Debugging:GetLeastPerformantTracked()
```
Returns the tracked functions with the worst performance.

### Returns
- `table<integer, NoirTracker>`

---

```lua
Noir.Debugging:ShowLeastPerformantTracked()
```
Shows the tracked functions with the worst performance.

---

```lua
Noir.Debugging:GetMostPerformantTracked()
```
Returns the tracked functions with the best performance.

### Returns
- `table<integer, NoirTracker>`

---

```lua
Noir.Debugging:ShowMostPerformantTracked()
```
Shows the tracked functions with the best performance.

---

```lua
Noir.Debugging:TrackFunction(name, func)
```
Track a function. This returns a tracker which will track the performance of the function among other things.

Returns `nil` if the provided function isn't allowed to be tracked or if debugging isn't enabled.        local tracker = Noir.Debugging:TrackFunction("myFunction", myFunction)    myFunction = tracker:Mount()

### Parameters
- `name`: string
- `func`: function
### Returns
- `NoirTracker|nil`

---

```lua
Noir.Debugging:TrackAll(name, tbl, _journey)
```
Track all functions in a table. This will track all methods in the provided table, returning a table of all the trackers created.

Returns an empty table if debugging isn't enabled or the provided table is an exception.

### Parameters
- `name`: string
- `tbl`: table<integer, function>
- `_journey`: table<table, boolean>|nil - Used internally to prevent infinite recursion
### Returns
- `table<integer, NoirTracker>`

---

```lua
Noir.Debugging:TrackService(service)
```
Track a service. This will track all methods in the provided service, returning a table of all the trackers created.

### Parameters
- `service`: NoirService
### Returns
- `table<integer, NoirTracker>`