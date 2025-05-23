--------------------------------------------------------
-- [Noir] Classes - Task
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
    Represents a task.

    task:SetRepeating(true)
    task:SetDuration(1)

    task.OnCompletion:Connect(function()
        -- Do something
    end)
]]
---@class NoirTask: NoirClass
---@field New fun(self: NoirTask, ID: integer, taskType: NoirTaskType, duration: number, isRepeating: boolean, arguments: table<integer, any>, startedAt: number): NoirTask
---@field ID integer The ID of this task
---@field TaskType NoirTaskType The type of this task
---@field StartedAt number The point that this task started at
---@field Duration number The duration of this task
---@field StopsAt number The point that this task will stop at if it is not repeating
---@field IsRepeating boolean Whether or not this task is repeating
---@field Arguments table<integer, any> The arguments that will be passed to this task upon completion
---@field OnCompletion NoirEvent The event that will be fired when this task is completed
Noir.Classes.Task = Noir.Class("Task")

--[[
    Initializes task class objects.
]]
---@param ID integer
---@param taskType NoirTaskType
---@param duration number
---@param isRepeating boolean
---@param arguments table<integer, any>
---@param startedAt number
function Noir.Classes.Task:Init(ID, taskType, duration, isRepeating, arguments, startedAt)
    Noir.TypeChecking:Assert("Noir.Classes.Task:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Task:Init()", "taskType", taskType, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Task:Init()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Task:Init()", "isRepeating", isRepeating, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Task:Init()", "arguments", arguments, "table")
    Noir.TypeChecking:Assert("Noir.Classes.Task:Init()", "startedAt", startedAt, "number", "nil")

    self.ID = ID
    self.TaskType = taskType
    self.StartedAt = startedAt

    self:SetDuration(duration)
    self:SetRepeating(isRepeating)
    self:SetArguments(arguments)

    self.OnCompletion = Noir.Libraries.Events:Create()
end

    --[[
]]

--[[
    Sets whether or not this task is repeating.<br>
    If repeating, the task will be triggered repeatedly as implied.<br>
    If not, the task will be triggered once, then removed from the TaskService.
]]
---@param isRepeating boolean
function Noir.Classes.Task:SetRepeating(isRepeating)
    Noir.TypeChecking:Assert("Noir.Classes.Task:SetRepeating()", "isRepeating", isRepeating, "boolean")
    self.IsRepeating = isRepeating
end

--[[
    Sets the duration of this task.
]]
---@param duration number
function Noir.Classes.Task:SetDuration(duration)
    Noir.TypeChecking:Assert("Noir.Classes.Task:SetDuration()", "duration", duration, "number")

    self.Duration = duration
    self.StopsAt = self.StartedAt + duration
end

--[[
    Sets the arguments that will be passed to this task upon finishing.
]]
---@param arguments table<integer, any>
function Noir.Classes.Task:SetArguments(arguments)
    Noir.TypeChecking:Assert("Noir.Classes.Task:SetArguments()", "arguments", arguments, "table")
    self.Arguments = arguments
end

--[[
    Remove this task from the task service.
]]
function Noir.Classes.Task:Remove()
    Noir.Services.TaskService:RemoveTask(self)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a task type.
]]
---@alias NoirTaskType
---| "Time" The task will use `server.getTimeMillisec()`
---| "Ticks" The task will count ticks in `onTick` while considering the amount of ticks passed in a single tick