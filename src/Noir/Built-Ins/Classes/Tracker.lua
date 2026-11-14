--------------------------------------------------------
-- [Noir] Classes - Tracker
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2026 Cuh4

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
    Represents a tracker assigned to a function via `Noir.Debugging`.
]]
---@class NoirTracker: NoirClass
---@field New fun(self: NoirTracker, name: string, func: function): NoirTracker
---@field OnBeforeCall NoirEvent Fired before the function is called | Arguments: ... (any)
---@field OnAfterCall NoirEvent Fired after the function is called | Arguments: ... (any)
---@field FunctionName string The name of the function provided
---@field Function function The original unmodified function
---@field CallCount integer The number of times the function has been called
---@field ExecutionTimes table<integer, integer> A table containing the execution time of each function call in milliseconds
---@field AverageExecutionTime number The average execution time of the function
---@field AverageCallsPerTick integer The average number of times the function gets called per tick
---@field CallsPerTick integer The number of times the function has been called this tick
---@field CallsPerTickHistory table<integer, integer> A table containing the number of times the function has been called per tick
---@field SelfExecutionTimes table<integer, number> Recent self times in milliseconds
---@field TotalSelfTime number Total self time in milliseconds
---@field TotalTime number Total inclusive time in milliseconds
---@field MaxSelfTime number Longest self time in milliseconds
---@field MaxTime number Longest inclusive time in milliseconds
---@field CompletedCalls integer Number of calls that returned
---@field InterruptedCalls integer Number of unfinished calls discarded
---@field Aliases table<string, boolean> Names used for this function
---@field _Bindings table<integer, NoirTrackerBinding> Table entries mounted by this tracker
Noir.Classes.Tracker = Noir.Class("Tracker")

--[[
    Initializes class objects from this class.
]]
---@param name string
---@param func function
function Noir.Classes.Tracker:Init(name, func)
    Noir.TypeChecking:Assert("Noir.Classes.Tracker:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Tracker:Init()", "func", func, "function")

    self.OnBeforeCall = Noir.Libraries.Events:Create()
    self.OnAfterCall = Noir.Libraries.Events:Create()

    self.FunctionName = name
    self.Function = func
    self.Aliases = {[name] = true}

    self._Bindings = {}
    self._Active = true

    self:Reset()

    self._ModifiedFunction = function(...)
        if not self._Active or not Noir.Debugging.Enabled or Noir.Debugging._Busy then
            return func(...)
        end

        local frame = Noir.Debugging:_BeginCall(self, ...)
        frame.Start = server.getTimeMillisec()

        local results = table.pack(func(...))
        Noir.Debugging:_EndCall(frame, ...)

        return table.unpack(results, 1, results.n)
    end
end

--[[
    Clears this tracker's statistics.
]]
function Noir.Classes.Tracker:Reset()
    self.ExecutionTimes = {}
    self.SelfExecutionTimes = {}

    self.CallsPerTickHistory = {}
    self._FirstTick = Noir.Services.TaskService.Ticks or 0

    self.CallCount = 0
    self.CompletedCalls = 0
    self.InterruptedCalls = 0

    self.TotalTime = 0
    self.TotalSelfTime = 0
    self.MaxTime = 0
    self.MaxSelfTime = 0
    self.AverageExecutionTime = 0
    self.AverageSelfTime = 0

    self.LastCallSequence = 0
    self.LastCalledAt = 0

    self.CallsPerTick = 0
    self.AverageCallsPerTick = 0
    self._LastTick = nil
end

--[[
    Counts a call in the current tick.
]]
function Noir.Classes.Tracker:_CountCall()
    local tick = Noir.Services.TaskService.Ticks or 0

    if self._LastTick ~= tick then
        self:GetAverageCallsPerTick()
        self._LastTick = tick
    end

    self.CallCount = self.CallCount + 1
    self.CallsPerTick = (self.CallsPerTickHistory[tick] or 0) + 1
    self.CallsPerTickHistory[tick] = self.CallsPerTick
end

--[[
    Records the duration of a completed call.
]]
---@param selfTime number
---@param inclusive number
function Noir.Classes.Tracker:_Record(selfTime, inclusive)
    local window = math.max(1, Noir.Debugging.ExecutionTimeWindow)

    while #self.ExecutionTimes >= window do
        table.remove(self.ExecutionTimes, 1)
        table.remove(self.SelfExecutionTimes, 1)
    end

    table.insert(self.ExecutionTimes, inclusive)
    table.insert(self.SelfExecutionTimes, selfTime)

    self.AverageExecutionTime = Noir.Libraries.Number:Average(self.ExecutionTimes)
    self.AverageSelfTime = Noir.Libraries.Number:Average(self.SelfExecutionTimes)

    self.TotalTime = self.TotalTime + inclusive
    self.TotalSelfTime = self.TotalSelfTime + selfTime
    self.MaxTime = math.max(self.MaxTime, inclusive)
    self.MaxSelfTime = math.max(self.MaxSelfTime, selfTime)

    self.CompletedCalls = self.CompletedCalls + 1
end

--[[
    Formats this tracker into a string.
]]
---@return string
function Noir.Classes.Tracker:ToFormattedString()
    return ("%s() | Self/inclusive (ms): avg %.2f/%.2f, last %.0f/%.0f, total %.0f/%.0f, max %.0f/%.0f | %d calls, %d completed, %d interrupted, %.3f calls/tick"):format(
        self.FunctionName, self.AverageSelfTime, self.AverageExecutionTime,
        self:GetLastSelfExecutionTime(), self:GetLastExecutionTime(),
        self.TotalSelfTime, self.TotalTime, self.MaxSelfTime, self.MaxTime,
        self.CallCount, self.CompletedCalls, self.InterruptedCalls, self:GetAverageCallsPerTick()
    )
end

--[[
    Returns the modified function.
    
    local tracker = Noir.Debugging:TrackFunction("myFunction", myFunction)
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
    Returns the calls per tick.
]]
---@return number
function Noir.Classes.Tracker:GetCallsPerTick()
    return self.CallsPerTickHistory[Noir.Services.TaskService.Ticks or 0] or 0
end

--[[
    Returns the average calls per tick.
]]
---@return number
function Noir.Classes.Tracker:GetAverageCallsPerTick()
    local tick = Noir.Services.TaskService.Ticks or 0
    local first = math.max(self._FirstTick, tick - Noir.Debugging.CallsPerTickWindow)
    local count = 0

    for calledTick, calls in pairs(self.CallsPerTickHistory) do
        if calledTick < first then
            self.CallsPerTickHistory[calledTick] = nil
        elseif calledTick < tick then
            count = count + calls
        end
    end

    self.AverageCallsPerTick = tick > first and count / (tick - first) or 0

    return self.AverageCallsPerTick
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

--[[
    Returns the last call's self time in milliseconds.
]]
---@return number
function Noir.Classes.Tracker:GetLastSelfExecutionTime()
    return self.SelfExecutionTimes[#self.SelfExecutionTimes] or 0
end

--[[
    Returns the recent average self time in milliseconds.
]]
---@return number
function Noir.Classes.Tracker:GetAverageSelfExecutionTime()
    return self.AverageSelfTime
end