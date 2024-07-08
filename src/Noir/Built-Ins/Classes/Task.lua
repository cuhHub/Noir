--------------------------------------------------------
-- [Noir] Classes - Task
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
    Represents a task.

    task:SetRepeating(true)
    task:SetDuration(1)

    task.OnCompletion:Connect(function()
        -- Do something
    end)
]]
---@class NoirTask: NoirClass
---@field New fun(self: NoirTask, ID: integer, duration: number, isRepeating: boolean, arguments: table<integer, any>): NoirTask
---@field ID integer The ID of this task
---@field StartedAt integer The time that this task started at
---@field Duration integer The duration of this task
---@field StopsAt integer The time that this task will stop at if it is not repeating
---@field IsRepeating boolean Whether or not this task is repeating
---@field Arguments table<integer, any> The arguments that will be passed to this task upon completion
---@field OnCompletion NoirEvent The event that will be fired when this task is completed
Noir.Classes.TaskClass = Noir.Class("NoirTask")

--[[
    Initializes task class objects.
]]
---@param ID integer
---@param duration number
---@param isRepeating boolean
---@param arguments table<integer, any>
function Noir.Classes.TaskClass:Init(ID, duration, isRepeating, arguments)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "isRepeating", isRepeating, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "arguments", arguments, "table")

    self.ID = ID
    self.StartedAt = Noir.Services.TaskService:GetTimeSeconds()

    self:SetDuration(duration)
    self:SetRepeating(isRepeating)
    self:SetArguments(arguments)

    self.OnCompletion = Noir.Libraries.Events:Create()
end

--[[
    Sets whether or not this task is repeating.<br>
    If repeating, the task will be triggered every Task.Duration seconds.<br>
    If not, the task will be triggered once, then removed from the TaskService.
]]
---@param isRepeating boolean
function Noir.Classes.TaskClass:SetRepeating(isRepeating)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:SetRepeating()", "isRepeating", isRepeating, "boolean")
    self.IsRepeating = isRepeating
end

--[[
    Sets the duration of this task.
]]
---@param duration number
function Noir.Classes.TaskClass:SetDuration(duration)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:SetDuration()", "duration", duration, "number")

    self.Duration = duration
    self.StopsAt = self.StartedAt + duration
end

--[[
    Sets the arguments that will be passed to this task upon finishing.
]]
---@param arguments table<integer, any>
function Noir.Classes.TaskClass:SetArguments(arguments)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:SetArguments()", "arguments", arguments, "table")
    self.Arguments = arguments
end