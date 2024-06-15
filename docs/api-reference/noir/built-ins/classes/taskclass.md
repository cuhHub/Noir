# TaskClass

**Noir.Classes.TaskClass**: `NoirClass`

Represents a task for the TaskService.

***

```lua
Noir.Classes.TaskClass:Init(ID, duration, isRepeating, arguments)
```

Initializes task class objects.

#### Parameters

* `ID`: integer
* `duration`: number
* `isRepeating`: boolean
* `arguments`: table\<integer, any>

***

```lua
Noir.Classes.TaskClass:SetRepeating(isRepeating)
```

Sets whether or not this task is repeating. If repeating, the task will be triggered every Task.Duration seconds. If not, the task will be triggered once, then removed from the TaskService.

#### Parameters

* `isRepeating`: boolean

***

```lua
Noir.Classes.TaskClass:SetDuration(duration)
```

Sets the duration of this task.

#### Parameters

* `duration`: number

***

```lua
Noir.Classes.TaskClass:SetArguments(arguments)
```

Sets the arguments that will be passed to this task upon finishing.

#### Parameters

* `arguments`: table\<integer, any>
