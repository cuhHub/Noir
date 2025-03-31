--------------------------------------------------------
-- [Noir] Services - Task Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2025 Cuh4

        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------

--[[
    A service for easily delaying or repeating tasks.

    local task = Noir.Services.TaskService:AddTask(function(toSay)
        server.announce("Server", toSay)
    end, 5, {"Hello World!"}, true) -- This task is repeating due to isRepeating being true (final argument)

    task:SetDuration(10) -- Duration changes from 5 to 10
]]
---@class NoirTaskService: NoirService
---@field Ticks integer The amount of `onTick` calls
---@field DeltaTicks number The amount of ticks that have technically passed since the last tick
---@field Tasks table<integer, NoirTask> A table containing active tasks
---@field _TaskID integer The ID of the most recent task
---@field TickIterationProcesses table<integer, NoirTickIterationProcess> A table of tick iteration processes
---@field _TickIterationProcessID integer The ID of the most recent tick iteration process
---@field _TaskTypeHandlers table<NoirTaskType, fun(task: NoirTask)>
---@field _OnTickConnection NoirConnection Represents the connection to the onTick game callback
Noir.Services.TaskService = Noir.Services:CreateService(
    "TaskService",
    true,
    "A service for calling functions after x amount of seconds.",
    "A service that allows you to call functions after x amount of seconds, either repeatedly or once.",
    {"Cuh4"}
)

function Noir.Services.TaskService:ServiceInit()
    -- Create attributes
    self.Ticks = 0
    self.DeltaTicks = 0

    self.Tasks = {}
    self._TaskID = 0

    self.TickIterationProcesses = {}
    self._TickIterationProcessID = 0

    self._TaskTypeHandlers = {}

    -- Create task handlers
    self._TaskTypeHandlers["Time"] = function(task)
        local time = self:GetTimeSeconds()

        if time < task.StopsAt then
            return
        end

        if task.IsRepeating then
            task.StartedAt = time
            task.StopsAt = time + task.Duration

            task.OnCompletion:Fire(table.unpack(task.Arguments))
        else
            self:RemoveTask(task)
            task.OnCompletion:Fire(table.unpack(task.Arguments))
        end
    end

    self._TaskTypeHandlers["Ticks"] = function(task)
        if self.Ticks < task.StopsAt then
            return
        end

        if task.IsRepeating then
            task.StartedAt = self.Ticks
            task.StopsAt = self.Ticks + task.Duration

            task.OnCompletion:Fire(table.unpack(task.Arguments))
        else
            self:RemoveTask(task)
            task.OnCompletion:Fire(table.unpack(task.Arguments))
        end
    end
end

function Noir.Services.TaskService:ServiceStart()
    -- Connect to onTick
    self._OnTickConnection = Noir.Callbacks:Connect("onTick", function(ticks)
        -- Increment ticks
        self.Ticks = self.Ticks + ticks
        self.DeltaTicks = ticks

        -- Handle tick iteration processes
        self:_HandleTickIterationProcesses()

        -- Check tasks
        self:_HandleTasks()
    end)
end

--[[
    Handles tick iteration processes.<br>
    Used internally.
]]
function Noir.Services.TaskService:_HandleTickIterationProcesses()
    for _, tickIterationProcess in pairs(self:GetTickIterationProcesses(true)) do
        if tickIterationProcess.Completed then
            self:RemoveTickIterationProcess(tickIterationProcess)
        else
            tickIterationProcess:Iterate()
        end
    end
end

--[[
    Handles tasks.<br>
    Used internally.
]]
function Noir.Services.TaskService:_HandleTasks()
    for _, task in pairs(self:GetTasks(true)) do
        if not self:_IsValidTaskType(task.TaskType) then
            error("TaskService:_HandleTasks()", "Task #%d has an invalid task type of '%s'. Please ensure when creating a task, you use the correct type (assuming you're using `:_AddTask()`)", task.ID, task.TaskType)
        end

        local handler = self._TaskTypeHandlers[task.TaskType]
        handler(task)

        ::continue::
    end
end

--[[
    Add a task to the TaskService.<br>
    Used internally.
]]
---@param callback function
---@param duration number
---@param arguments table
---@param isRepeating boolean
---@param taskType NoirTaskType
---@param startedAt number
---@return NoirTask
function Noir.Services.TaskService:_AddTask(callback, duration, arguments, isRepeating, taskType, startedAt)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:_AddTask()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:_AddTask()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:_AddTask()", "arguments", arguments, "table")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:_AddTask()", "isRepeating", isRepeating, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:_AddTask()", "taskType", taskType, "string")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:_AddTask()", "startedAt", startedAt, "number")

    -- Check task type
    if not self:_IsValidTaskType(taskType) then
        error("TaskService:_AddTask()", "Invalid task type of '%s'. Please ensure when creating a task, you use the correct type.", taskType)
    end

    -- Increment ID
    self._TaskID = self._TaskID + 1

    -- Create task
    local task = Noir.Classes.Task:New(self._TaskID, taskType, duration, isRepeating, arguments, startedAt)
    task.OnCompletion:Connect(callback)

    self.Tasks[task.ID] = task

    -- Return the task
    return task
end

--[[
    Returns whether or not a task type is valid.<br>
    Used internally.
]]
---@param taskType string
---@return boolean
function Noir.Services.TaskService:_IsValidTaskType(taskType)
    return self._TaskTypeHandlers[taskType] ~= nil
end

--[[
    Returns the current time in seconds.<br>
    Equivalent to: server.getTimeMillisec() / 1000
]]
---@return number
function Noir.Services.TaskService:GetTimeSeconds()
    return server.getTimeMillisec() / 1000
end

--[[
    Creates and adds a task to the TaskService using the task type `"Time"`.<br>
    This is less accurate than the other task types as it uses time to determine when to run the task. This is more convenient though.

    local task = Noir.Services.TaskService:AddTimeTask(function(toSay)
        server.announce("Server", toSay)
    end, 5, {"Hello World!"}, true) -- This task is repeating due to isRepeating being true (final argument)

    local anotherTask = Noir.Services.TaskService:AddTimeTask(server.announce, 5, {"Server", "Hello World!"}, true) -- This does the same as above
    Noir.Services.TaskService:RemoveTask(anotherTask) -- Removes the task
]]
---@param callback function
---@param duration number In seconds
---@param arguments table|nil
---@param isRepeating boolean|nil
---@return NoirTask
function Noir.Services.TaskService:AddTimeTask(callback, duration, arguments, isRepeating)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTimeTask()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTimeTask()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTimeTask()", "arguments", arguments, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTimeTask()", "isRepeating", isRepeating, "boolean", "nil")

    -- Create task
    local task = self:_AddTask(callback, duration, arguments or {}, isRepeating or false, "Time", self:GetTimeSeconds())
    return task
end

--[[
    This is deprecated. Please use `:AddTimeTask()`.
]]
---@deprecated
---@param callback function
---@param duration number In seconds
---@param arguments table|nil
---@param isRepeating boolean|nil
---@return NoirTask
function Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
    -- Deprecation
    Noir.Libraries.Deprecation:Deprecated("Noir.Services.TaskService:AddTask()", ":AddTimeTask()", "Due to the addition of task types, this method has been deprecated.")

    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "arguments", arguments, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "isRepeating", isRepeating, "boolean", "nil")

    -- Create task
    return self:AddTimeTask(callback, duration, arguments, isRepeating)
end

--[[
    Creates and adds a task to the TaskService using the task type `"Ticks"`.<br>
    This is more accurate as it uses ticks to determine when to run the task.<br>
    It is highly recommended to multiply any calculations by `Noir.Services.TaskService.DeltaTicks` to account for when all players sleep.

    local last = Noir.Services.TaskService:GetTimeSeconds()
    local time = 0

    Noir.Services.TaskService:AddTickTask(function()
        local now = Noir.Services.TaskService:GetTimeSeconds()
        time = time + ((now - last) * Noir.Services.TaskService.DeltaTicks)
        last = now

        print(("%.1f seconds passed"):format(time))
    end, 1, nil, true) -- This task reoeats every tick
]]
---@param callback function
---@param duration integer In ticks
---@param arguments table|nil
---@param isRepeating boolean|nil
---@return NoirTask
function Noir.Services.TaskService:AddTickTask(callback, duration, arguments, isRepeating)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTickTask()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTickTask()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTickTask()", "arguments", arguments, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTickTask()", "isRepeating", isRepeating, "boolean", "nil")

    -- Create task
    local task = self:_AddTask(callback, duration, arguments or {}, isRepeating or false, "Ticks", self.Ticks)
    return task
end

--[[
    Converts seconds to ticks, accounting for TPS.

    local ticks = Noir.Services.TaskService:SecondsToTicks(2)
    print(ticks) -- 120 (assuming TPS is 60)
]]
---@param seconds integer
---@return integer
function Noir.Services.TaskService:SecondsToTicks(seconds)
    Noir.TypeChecking:Assert("Noir.Services.TaskService:SecondsToTicks()", "seconds", seconds, "number")
    return math.floor(seconds * Noir.Services.TPSService:GetTPS())
end

--[[
    Converts ticks to seconds, accounting for TPS.

    local seconds = Noir.Services.TaskService:TicksToSeconds(120)
    print(seconds) -- 2 (assuming TPS is 60)
]]
---@param ticks integer
---@return number
function Noir.Services.TaskService:TicksToSeconds(ticks)
    Noir.TypeChecking:Assert("Noir.Services.TaskService:TicksToSeconds()", "ticks", ticks, "number")
    return ticks / Noir.Services.TPSService:GetTPS()
end

--[[
    Returns all active tasks.
]]
---@param copy boolean|nil
---@return table<integer, NoirTask>
function Noir.Services.TaskService:GetTasks(copy)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:GetTasks()", "copy", copy, "boolean", "nil")

    -- Return tasks
    return copy and Noir.Libraries.Table:Copy(self.Tasks) or self.Tasks
end

--[[
    Removes a task.
]]
---@param task NoirTask
function Noir.Services.TaskService:RemoveTask(task)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:RemoveTask()", "task", task, Noir.Classes.Task)

    -- Remove task
    self.Tasks[task.ID] = nil
end

--[[
    Iterate a table over how many necessary ticks in chunks of x.<br>
    Useful for iterating through large tables without freezes due to taking too long in a tick.<br>
    Works for sequential and non-sequential tables, although **order is NOT guaranteed**.

    local tbl = {}

    for value = 1, 100000 do
        table.insert(tbl, value)
    end

    Noir.Services.TaskService:IterateOverTicks(tbl, 1000, function(value, currentTick, completed)
        print(value)
    end)
]]
---@param tbl table<integer, any>
---@param chunkSize integer How many values to iterate per tick
---@param callback fun(index: any, value: any, currentTick: integer|nil, completed: boolean|nil) `currentTick` and `completed` are never nil. this is just to mark the paramters as optional
---@return NoirTickIterationProcess
function Noir.Services.TaskService:IterateOverTicks(tbl, chunkSize, callback)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:IterateOverTicks()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:IterateOverTicks()", "chunkSize", chunkSize, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:IterateOverTicks()", "callback", callback, "function")

    -- Increment ID
    self._TickIterationProcessID = self._TickIterationProcessID + 1

    -- Create iteration process
    local iterationProcess = Noir.Classes.TickIterationProcess:New(self._TickIterationProcessID, tbl, chunkSize)
    iterationProcess.IterationEvent:Connect(callback)

    -- Store iteration process
    self.TickIterationProcesses[self._TickIterationProcessID] = iterationProcess

    -- Return iteration
    return iterationProcess
end

--[[
    Get all active tick iteration processes.
]]
---@param copy boolean|nil
---@return table<integer, NoirTickIterationProcess>
function Noir.Services.TaskService:GetTickIterationProcesses(copy)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:GetTickIterationProcesses()", "copy", copy, "boolean", "nil")

    -- Return tick iteration processes
    return copy and Noir.Libraries.Table:Copy(self.TickIterationProcesses) or self.TickIterationProcesses
end

--[[
    Removes a tick iteration process.
]]
---@param tickIterationProcess NoirTickIterationProcess
function Noir.Services.TaskService:RemoveTickIterationProcess(tickIterationProcess)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:RemoveTickIterationProcess()", "tickIterationProcess", tickIterationProcess, Noir.Classes.TickIterationProcess)

    -- Remove iteration process
    self.TickIterationProcesses[tickIterationProcess.ID] = nil
end