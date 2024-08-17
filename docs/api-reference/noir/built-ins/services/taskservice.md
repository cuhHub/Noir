# TaskService

**Noir.Services.TaskService**: `NoirService`

A service for easily delaying or repeating tasks.

---

```lua
Noir.Services.TaskService:GetTimeSeconds()
```
Returns the current time in seconds.

Equivalent to: server.getTimeMillisec() / 1000

### Returns
- `number`

---

```lua
Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
```
Creates and adds a task to the TaskService.

### Parameters
- `callback`: function
- `duration`: number
- `arguments`: table|nil
- `isRepeating`: boolean|nil
### Returns
- `NoirTask`

---

```lua
Noir.Services.TaskService:GetTasks(copy)
```
Returns all active tasks.

### Parameters
- `copy`: boolean|nil
### Returns
- `table<integer, NoirTask>`

---

```lua
Noir.Services.TaskService:RemoveTask(task)
```
Removes a task.

### Parameters
- `task`: NoirTask

---

```lua
Noir.Services.TaskService:IterateOverTicks(tbl, chunkSize, callback)
```
Iterate a table over how many necessary ticks in chunks of x.

Useful for iterating through large tables without freezes due to taking too long in a tick.

Only works for tables that are sequential. Please use `Noir.Libraries.Table:Values()` to convert a non-sequential table into a sequential table.

### Parameters
- `tbl`: table<integer, any>
- `chunkSize`: integer - How many values to iterate per tick
- `callback`: fun(value: - any, currentTick: integer|nil, completed: boolean|nil)
### Returns
- `NoirTickIterationProcess`

---

```lua
Noir.Services.TaskService:GetTickIterationProcesses(copy)
```
Get all active tick iteration processes.

### Parameters
- `copy`: boolean|nil
### Returns
- `table<integer, NoirTickIterationProcess>`

---

```lua
Noir.Services.TaskService:RemoveTickIterationProcess(tickIterationProcess)
```
Removes a tick iteration process.

### Parameters
- `tickIterationProcess`: NoirTickIterationProcess