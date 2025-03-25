# Task

**Noir.Classes.Task**: `NoirClass`

Represents a task.

---

```lua
Noir.Classes.Task:Init(ID, taskType, duration, isRepeating, arguments, startedAt)
```
Initializes task class objects.

### Parameters
- `ID`: integer
- `taskType`: NoirTaskType
- `duration`: number
- `isRepeating`: boolean
- `arguments`: table<integer, any>
- `startedAt`: number

---

```lua
Noir.Classes.Task:SetRepeating(isRepeating)
```
Sets whether or not this task is repeating.

If repeating, the task will be triggered repeatedly as implied.

If not, the task will be triggered once, then removed from the TaskService.

### Parameters
- `isRepeating`: boolean

---

```lua
Noir.Classes.Task:SetDuration(duration)
```
Sets the duration of this task.

### Parameters
- `duration`: number

---

```lua
Noir.Classes.Task:SetArguments(arguments)
```
Sets the arguments that will be passed to this task upon finishing.

### Parameters
- `arguments`: table<integer, any>

---

```lua
Noir.Classes.Task:Remove()
```
Remove this task from the task service.