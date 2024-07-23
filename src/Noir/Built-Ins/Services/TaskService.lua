--------------------------------------------------------
-- [Noir] Services - Task Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
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
---@class NoirTaskService: NoirService
---@field IncrementalID integer The ID of the next task
---@field Tasks table<integer, NoirTask> A table containing active tasks
---@field OnTickConnection NoirConnection Represents the connection to the onTick game callback
Noir.Services.TaskService = Noir.Services:CreateService(
    "TaskService",
    true,
    "A service for calling functions after x amount of seconds.",
    "A service that allows you to call functions after x amount of seconds, either repeatedly or once.",
    {"Cuh4"}
)

function Noir.Services.TaskService:ServiceInit()
    -- Create attributes
    self.IncrementalID = 0
    self.Tasks = {}
end

function Noir.Services.TaskService:ServiceStart()
    -- Connect to onTick, and constantly check tasks
    self.OnTickConnection = Noir.Callbacks:Connect("onTick", function()
        for _, task in pairs(self.Tasks) do
            -- Get time so far in seconds
            local time = self:GetTimeSeconds()

            -- Check if the task should be stopped
            if time >= task.StopsAt then
                if task.IsRepeating then
                    -- Repeat the task
                    task.StartedAt = time
                    task.StopsAt = time + task.Duration

                    -- Fire OnCompletion
                    task.OnCompletion:Fire(table.unpack(task.Arguments))
                else
                    -- Stop the task
                    self:RemoveTask(task)

                    -- Fire OnCompletion
                    task.OnCompletion:Fire(table.unpack(task.Arguments))
                end
            end
        end
    end)
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
    Creates and adds a task to the TaskService.

    local task = Noir.Services.TaskService:AddTask(function(toSay)
        server.announce("Server", toSay)
    end, 5, {"Hello World!"}, true) -- This task is repeating due to isRepeating being true (final argument)

    local anotherTask = Noir.Services.TaskService:AddTask(server.announce, 5, {"Server", "Hello World!"}, true) -- This does the same as above
    Noir.Services.TaskService:RemoveTask(anotherTask) -- Removes the task
]]
---@param callback function
---@param duration number
---@param arguments table|nil
---@param isRepeating boolean|nil
---@return NoirTask
function Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "arguments", arguments, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "isRepeating", isRepeating, "boolean", "nil")

    -- Defaults
    arguments = arguments or {}
    isRepeating = isRepeating or false

    -- Increment ID
    self.IncrementalID = self.IncrementalID + 1

    -- Create task
    local task = Noir.Classes.TaskClass:New(self.IncrementalID, duration, isRepeating, arguments)
    task.OnCompletion:Connect(callback)

    self.Tasks[task.ID] = task

    -- Return the task
    return task
end

--[[
    Removes a task.
]]
---@param task NoirTask
function Noir.Services.TaskService:RemoveTask(task)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:RemoveTask()", "task", task, Noir.Classes.TaskClass)

    -- Remove task
    self.Tasks[task.ID] = nil
end