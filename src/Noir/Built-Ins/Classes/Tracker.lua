--------------------------------------------------------
-- [Noir] Classes - Tracker
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
    Represents a tracker assigned to a function via the DebuggerService.
]]
---@class NoirTracker: NoirClass
---@field New fun(self: NoirTracker, name: string, func: function): NoirTracker
---@field FunctionName string The name of the function provided
---@field Function function The original unmodified function
---@field CallCount integer The number of times the function has been called
---@field ExecutionTimes table<integer, integer> A table containing the execution time of each function call in milliseconds
---@field AverageExecutionTime number The average execution time of the function
---@field _TimeBeforeCall number The time before the function was called via server.getTimeMillisec()
---@field _ModifiedFunction function The unmodified function but wrapped with debug code
Noir.Classes.Tracker = Noir.Class("Tracker")

--[[
    Initializes class objects from this class.
]]
---@param name string
---@param func function
function Noir.Classes.Tracker:Init(name, func)
    Noir.TypeChecking:Assert("Noir.Classes.Tracker:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Tracker:Init()", "func", func, "function")

    self.FunctionName = name
    self.Function = func
    self.CallCount = 0
    self.ExecutionTimes = {}
    self.AverageExecutionTime = 0

    self._TimeBeforeCall = 0

    self._ModifiedFunction = function(...)
        self:_BeforeCall(...)
        local returns = {self.Function(...)}
        self:_AfterCall(...)

        return table.unpack(returns)
    end
end

--[[
    Method called when the unmodified function is about to be called.<br>
    Used internally.
]]
function Noir.Classes.Tracker:_BeforeCall(...)
    self._TimeBeforeCall = server.getTimeMillisec()
end

--[[
    Method called after the unmodified function has been called.<br>
    Used internally.
]]
function Noir.Classes.Tracker:_AfterCall(...)
    -- Increment call count
    self.CallCount = self.CallCount + 1

    -- Add execution time
    if #self.ExecutionTimes >= 10 then
        table.remove(self.ExecutionTimes, 1)
    end

    table.insert(self.ExecutionTimes, server.getTimeMillisec() - self._TimeBeforeCall)

    -- Calculate average execution time
    self.AverageExecutionTime = Noir.Libraries.Number:Average(self.ExecutionTimes)
end

--[[
    Formats this tracker into a string.
]]
---@return string
function Noir.Classes.Tracker:ToFormattedString()
    return ("%s() | Avg. Exc. Time: %.4f ms, Last Exc. Time: %.4fms, Call Count: %d"):format(
        self:GetName(),
        self:GetAverageExecutionTime(),
        self:GetLastExecutionTime(),
        self:GetCallCount()
    )
end

--[[
    Returns the modified function.
    
    local tracker = Noir.Services.DebuggerService:TrackFunction("myFunction", myFunction)
    myFunction = tracker:Mount()
]]
---@return function
function Noir.Classes.Tracker:Mount()
    return self._ModifiedFunction
end

--[[
    Returns the name of the function.
]]
---@return string
function Noir.Classes.Tracker:GetName()
    return self.FunctionName
end

--[[
    Returns the average execution time of the function.
]]
---@return number
function Noir.Classes.Tracker:GetAverageExecutionTime()
    return self.AverageExecutionTime
end

--[[
    Returns the last execution time of the function.
]]
---@return number
function Noir.Classes.Tracker:GetLastExecutionTime()
    return self.ExecutionTimes[#self.ExecutionTimes] or 0
end

--[[
    Returns the amount of times this function has been called.
]]
---@return number
function Noir.Classes.Tracker:GetCallCount()
    return self.CallCount
end