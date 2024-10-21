# TaskService

**Noir.Services.TaskService**: `NoirService`

A service for easily delaying or repeating tasks.

---

```lua
Noir.Services.TaskService:_HandleTickIterationProcesses()
```
Handles tick iteration processes.

Used internally.

---

```lua
Noir.Services.TaskService:_HandleTasks()
```
Handles tasks.

Used internally.

---

```lua
Noir.Services.TaskService:_AddTask(callback, duration, arguments, isRepeating, taskType, startedAt)
```
Add a task to the TaskService.

Used internally.

### Parameters
- `callback`: function
- `duration`: number
- `arguments`: table
- `isRepeating`: boolean
- `taskType`: NoirTaskType
- `startedAt`: number
### Returns
- `NoirTask`

---

```lua
Noir.Services.TaskService:_IsValidTaskType(taskType)
```
Returns whether or not a task type is valid.

Used internally.

### Parameters
- `taskType`: string
### Returns
- `boolean`

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
Noir.Services.TaskService:AddTimeTask(callback, duration, arguments, isRepeating)
```
Creates and adds a task to the TaskService using the task type `"Time"`.

This is less accurate than the other task types as it uses time to determine when to run the task. This is more convenient though.

### Parameters
- `callback`: function
- `duration`: number - In seconds
- `arguments`: table|nil
- `isRepeating`: boolean|nil
### Returns
- `NoirTask`

---

```lua
Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
```
**⚠️ | Deprecated. Do not use.**

This is deprecated. Please use `:AddTimeTask()`.

### Parameters
- `callback`: function
- `duration`: number - In seconds
- `arguments`: table|nil
- `isRepeating`: boolean|nil
### Returns
- `NoirTask`

---

```lua
Noir.Services.TaskService:AddTickTask(callback, duration, arguments, isRepeating)
```
Creates and adds a task to the TaskService using the task type `"Ticks"`.

This is more accurate as it uses ticks to determine when to run the task.

It is highly recommended to multiply any calculations by `Noir.Services.TaskService.DeltaTicks` to account for when all players sleep.

### Parameters
- `callback`: function
- `duration`: integer - In ticks
- `arguments`: table|nil
- `isRepeating`: boolean|nil
### Returns
- `NoirTask`

---

```lua
Noir.Services.TaskService:SecondsToTicks(seconds)
```
Converts seconds to ticks, accounting for TPS.

### Parameters
- `seconds`: integer
### Returns
- `integer`

---

```lua
Noir.Services.TaskService:TicksToSeconds(ticks)
```
Converts ticks to seconds, accounting for TPS.

### Parameters
- `ticks`: integer
### Returns
- `number`

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

Works for sequential and non-sequential tables, although **order is NOT guaranteed**.

### Parameters
- `tbl`: table<integer, any>
- `chunkSize`: integer - How many values to iterate per tick
- `callback`: fun(value: - any, currentTick: integer|nil, completed: boolean|nil) `currentTick` and `completed` are never nil. They are marked as so to mark the paramters as optional
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