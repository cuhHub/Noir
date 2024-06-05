---
description: A service for easily delaying or repeating tasks.
---

# TaskService

```lua
Noir.Services.TaskService:GetTimeSeconds()
```

Returns the current time in seconds. Equivalent to: server.getTimeMillisec() / 1000

#### Returns

* `number`

***

```lua
Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
```

Creates and adds a task to the TaskService.

#### Parameters

* `callback`: function
* `duration`: number
* `arguments`: table|nil
* `isRepeating`: boolean|nil

#### Returns

* `NoirTask`

***

```lua
Noir.Services.TaskService:RemoveTask(task)
```

Removes a task.

#### Parameters

* `task`: NoirTask

***
