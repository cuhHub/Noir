--------------------------------------------------------
-- [Noir] Services - Task Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2024 Cuh4

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
Noir.Services.TaskService = Noir.Services:CreateService("TaskService") ---@type NoirTaskService
Noir.Services.TaskService.initPriority = 1
Noir.Services.TaskService.startPriority = 1

function Noir.Services.TaskService:ServiceInit()
    -- Create attributes
    self.incrementalID = 0
    self.tasks = {}

    -- Create task class
    self.TaskClass = Noir.Libraries.Class:Create("NoirTaskServiceTask") ---@type NoirTaskServiceTask

    ---@param task NoirTaskServiceTask
    ---@param ID integer
    ---@param duration number
    ---@param isRepeating boolean
    ---@param arguments table
    function self.TaskClass.Init(task, ID, duration, isRepeating, arguments)
        task.ID = ID
        task.startedAt = self:GetTimeSeconds()

        task:SetDuration(duration)
        task:SetRepeating(isRepeating)
        task:SetArguments(arguments)

        task.onCompletion = Noir.Libraries.Events:Create()
    end

    function self.TaskClass.SetRepeating(task, isRepeating)
        task.isRepeating = isRepeating
    end

    function self.TaskClass.SetDuration(task, duration)
        task.duration = duration
        task.stopsAt = task.startedAt + duration
    end

    function self.TaskClass.SetArguments(task, arguments)
        task.arguments = arguments
    end
end

function Noir.Services.TaskService:ServiceStart()
    -- Connect to onTick, and constantly check tasks
    self.onTickConnection = Noir.Callbacks:Connect("onTick", function()
        for _, task in pairs(self.tasks) do
            -- Get time so far in seconds
            local time = self:GetTimeSeconds()

            -- Check if the task should be stopped
            if time >= task.stopsAt then
                if not task.isRepeating then
                    -- Repeat the task
                    task.startedAt = time
                    task.stopsAt = time + task.duration
                else
                    -- Stop the task
                    self:RemoveTask(task)

                    -- Fire onCompletion
                    task.onCompletion:Fire(table.unpack(task.arguments))
                end
            end
        end
    end)
end

function Noir.Services.TaskService:GetTimeSeconds()
    return server.getTimeMillisec() / 1000
end

function Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
    -- Defaults
    arguments = arguments or {}
    isRepeating = isRepeating or false

    -- Increment ID
    self.incrementalID = self.incrementalID + 1

    -- Create task
    local task = self.TaskClass:New(self.incrementalID, duration, isRepeating, arguments) ---@type NoirTaskServiceTask
    task.onCompletion:Connect(callback)

    self.tasks[task.ID] = task

    -- Return the task
    return task
end

function Noir.Services.TaskService:RemoveTask(task)
    self.tasks[task.ID] = nil
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirTaskService: NoirService
---@field TaskClass NoirTaskServiceTask The class that represents a task. Used internally
---@field incrementalID integer The ID of the next task
---@field tasks table<integer, NoirTaskServiceTask> A table containing active tasks
---@field onTickConnection NoirConnection Represents the connection to the onTick game callback
---
---@field GetTimeSeconds fun(self: NoirTaskService): number Returns the current time in seconds
---@field RemoveTask fun(self: NoirTaskService, task: NoirTaskServiceTask) Removes a task
---@field AddTask fun(self: NoirTaskService, callback: function, duration: number, arguments: table<any, any>|nil, isRepeating: boolean|nil): NoirTaskServiceTask Adds a task

---@class NoirTaskServiceTask: NoirClass
---@field ID integer The ID of this task
---@field startedAt integer The time that this task started at
---@field duration integer The duration of this task
---@field stopsAt integer The time that this task will stop at if it is not repeating
---@field isRepeating boolean Whether or not this task is repeating
---@field arguments table<integer, any> The arguments that will be passed to this task upon completion
---@field onCompletion NoirEvent The event that will be fired when this task is completed
---
---@field SetRepeating fun(self: NoirTaskServiceTask, isRepeating: boolean) Sets whether this task is repeating or not
---@field SetDuration fun(self: NoirTaskServiceTask, duration: number) Sets the duration of this task
---@field SetArguments fun(self: NoirTaskServiceTask, arguments: table<any, any>) Sets the arguments that will be passed to this task upon completion