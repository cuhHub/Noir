--------------------------------------------------------
-- [Noir] Debugging
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
    A module of Noir for debugging your code. This allows you to raise errors in the event something goes wrong
    as well as track functions to see how well they are performing and sort these functions in order of performance.<br>
    This can be useful for figuring out what functions are performing the worst which can help you optimize your addon.<br>
    This is not recommended to use in production it service may slow your addon. Please use it for debugging purposes only.

    -- Enabling debug
    Noir.Debugging.Enabled = true

    -- Raising an error
    Noir.Debugging:RaiseError(":Something()", "Something went wrong!")

    -- Tracking the performance of a function
    function myFunction()
        local value = 0

        for i = 1, 100000 do 
            value = value + i
        end
        
        return value
    end

    local tracker = Noir.Debugging:TrackFunction("myFunction", myFunction)
    myFunction = tracker:Mount()

    tracker:GetAverageExecutionTime() -- 0.01 ms
    tracker:GetLastExecutionTime() -- 0.02 ms
    print(tracker.FunctionName) -- "myFunction"

    -- Tracking the performance of all methods in a service
    local trackers = Noir.Debugging:TrackService(Noir.Services.VehicleService) -- Does the above but for all methods in VehicleService

    -- Tracking the performance of all functions in a table
    local myTbl = {
        foo = function()
            print("foo")
        end,

        bar = function()
            print("bar")
        end
    }

    local trackers = Noir.Debugging:TrackAll("myTbl", myTbl)
    -- To track all functions in your addon that are non-local, you can use the above method on `_ENV`. Existing local references keep calling the original function.

    -- Getting least performant functions
    Noir.Debugging:GetLeastPerformantTracked() -- A table of trackers. Index 1 being the least performant

    -- Showing least performant functions
    Noir.Debugging:ShowLeastPerformantTracked() -- Will send logs via logging library. You could call this every tick or in a command, etc
]]
Noir.Debugging = {}

--[[
    Enables/disables debugging. False by default, and it is recommended to keep it this way in production.
]]
Noir.Debugging.Enabled = false

--[[
    Number of completed calls used to calculate recent timing averages.
]]
Noir.Debugging.ExecutionTimeWindow = 20

--[[
    Number of completed ticks used to average calls per tick, including idle ticks.
]]
Noir.Debugging.CallsPerTickWindow = 64

--[[
    Maximum number of trackers shown per report. Set to zero to show all matching trackers.
]]
Noir.Debugging.ReportLimit = 120

--[[
    Whether reports include functions that have never been called.
]]
Noir.Debugging.IncludeUncalled = false

--[[
    Active tracker frames, with the current call at the top.
]]
Noir.Debugging._Stack = {}

--[[
    Maps each original function and its mounted wrapper to their shared tracker.
]]
Noir.Debugging._ByFunction = {}

--[[
    Increments when a tracked call starts to record call order.
]]
Noir.Debugging._Sequence = 0

--[[
    Pauses tracking while the profiler updates statistics, fires its events, or prints reports.
]]
Noir.Debugging._Busy = false

--[[
    A table containing all created trackers for functions.
]]
---@type table<integer, NoirTracker>
Noir.Debugging.Trackers = {}

--[[
    A table containing all functions and tables that should not be tracked.
]]
---@type table<function|table, boolean>
Noir.Debugging._TrackingExceptions = {
    [Noir] = true
}

--[[
    Fired whenever an error is raised.
]]
Noir.Debugging.OnError = Noir.Libraries.Events:Create()

--[[
    Fired before any tracked function is called.<br>
    Arguments: tracker (NoirTracker), ... (any)
]]
Noir.Debugging.OnBeforeCall = Noir.Libraries.Events:Create()

--[[
    Fired after any tracked function is called.<br>
    Arguments: tracker (NoirTracker), ... (any)
]]
Noir.Debugging.OnAfterCall = Noir.Libraries.Events:Create()

--[[
    Raises an error.<br>
    This method can still be called regardless of if debugging is enabled or not.<br>
    `error()` is aliased to this method.
]]
---@param source string
---@param message string
---@param ... any
function Noir.Debugging:RaiseError(source, message, ...)
    Noir.Logger:Error(source..": "..message, ...)
    self.OnError:Fire(source, ... and message:format(...) or message)

    _ENV["Noir: An error was raised. See logs for details."]()
end

--[[
    Raises an error.<br>
    This method can still be called regardless of if debugging is enabled or not.<br>
    This is an alias for `Noir.Debugging:RaiseError()`.
]]
---@param source string
---@param message string
---@param ... any
function error(source, message, ...)
    Noir.Debugging:RaiseError(source, message, ...)
end

--[[
    Pauses the caller while a tracked function runs.
]]
---@param tracker NoirTracker
---@param ... any
---@return NoirTrackerFrame
function Noir.Debugging:_BeginCall(tracker, ...)
    local now = server.getTimeMillisec()
    local stack = self._Stack
    local parent = stack[#stack]

    if parent then
        parent.SelfTime = parent.SelfTime + now - parent.Start
    end

    self._Busy = true

    local frame = Noir.Classes.TrackerFrame:New(tracker)
    stack[#stack + 1] = frame

    self._Sequence = self._Sequence + 1
    tracker.LastCallSequence = self._Sequence
    tracker.LastCalledAt = now
    tracker:_CountCall()

    tracker.OnBeforeCall:Fire(...)

    self._Busy = false

    return frame
end

--[[
    Records the call and resumes its caller.
]]
---@param frame NoirTrackerFrame
---@param ... any
function Noir.Debugging:_EndCall(frame, ...)
    local selfTime = frame.SelfTime + server.getTimeMillisec() - frame.Start
    local inclusive = selfTime + frame.ChildTime
    local stack = self._Stack
    local tracker = frame.Tracker

    self._Busy = true
    stack[#stack] = nil

    if tracker.ExecutionTimes == frame.Samples then
        tracker:_Record(selfTime, inclusive)
    end

    tracker.OnAfterCall:Fire(...)

    local parent = stack[#stack]

    if parent then
        parent.ChildTime = parent.ChildTime + inclusive
        parent.Start = server.getTimeMillisec()
    end

    self._Busy = false
end

--[[
    Discards unfinished calls at the next game callback.
]]
function Noir.Debugging:_RecoverCallback()
    for index = #self._Stack, 1, -1 do
        local frame = self._Stack[index]

        if frame.Samples == frame.Tracker.ExecutionTimes then
            frame.Tracker.InterruptedCalls = frame.Tracker.InterruptedCalls + 1
        end

        self._Stack[index] = nil
    end

    self._Busy = false
end

--[[
    Presents trackers in a category.<br>
    Used internally.
]]
---@param category string
---@param trackers table<integer, NoirTracker>
---@param limit integer|nil
---@param includeUncalled boolean|nil
function Noir.Debugging:_PresentTrackers(category, trackers, limit, includeUncalled)
    if includeUncalled == nil then
        includeUncalled = self.IncludeUncalled
    end

    limit = limit or self.ReportLimit

    local rows = {}

    for _, tracker in ipairs(trackers) do
        if includeUncalled or tracker.CallCount > 0 then
            table.insert(rows, tracker:ToFormattedString())

            if limit > 0 and #rows >= limit then
                break
            end
        end
    end

    Noir.Logger:Success("--- %s functions (last %d calls, %d completed ticks):", category, self.ExecutionTimeWindow, self.CallsPerTickWindow)

    for index, row in ipairs(rows) do
        Noir.Logger:Info("Tracker #%d: %s", index, row)
    end
end

--[[
    Excludes sorting and logging from the active call's timing.
]]
---@param category string
---@param getTrackers fun(self: table, inclusive: boolean|nil): table<integer, NoirTracker>
---@param limit integer|nil
---@param includeUncalled boolean|nil
---@param inclusive boolean|nil
function Noir.Debugging:_Show(category, getTrackers, limit, includeUncalled, inclusive)
    local busy = self._Busy
    local frame = self._Stack[#self._Stack]

    if frame and not busy then
        frame.SelfTime = frame.SelfTime + server.getTimeMillisec() - frame.Start
    end

    self._Busy = true
    self:_PresentTrackers(category, getTrackers(self, inclusive), limit, includeUncalled)
    self._Busy = busy

    if frame and not busy then
        frame.Start = server.getTimeMillisec()
    end
end

--[[
    Returns all tracked functions with the option to copy.
]]
---@param copy boolean|nil
---@return table<integer, NoirTracker>
function Noir.Debugging:GetTrackedFunctions(copy)
    Noir.TypeChecking:Assert("Noir.Debugging:GetTrackedFunctions()", "copy", copy, "boolean", "nil")
    return copy and Noir.Libraries.Table:Copy(self.Trackers) or self.Trackers
end

--[[
    Returns the most recently called tracked functions.
]]
---@return table<integer, NoirTracker>
function Noir.Debugging:GetLastCalledTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a.LastCallSequence > b.LastCallSequence
    end)

    return trackers
end

--[[
    Shows the most recently called tracked functions.
]]
---@param limit integer|nil
---@param includeUncalled boolean|nil
function Noir.Debugging:ShowLastCalledTracked(limit, includeUncalled)
    self:_Show("*Last* called", self.GetLastCalledTracked, limit, includeUncalled)
end

--[[
    Returns the tracked functions with the worst performance.
]]
---@param inclusive boolean|nil
---@return table<integer, NoirTracker>
function Noir.Debugging:GetLeastPerformantTracked(inclusive)
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        if inclusive then
            return a:GetAverageExecutionTime() > b:GetAverageExecutionTime()
        end

        return a:GetAverageSelfExecutionTime() > b:GetAverageSelfExecutionTime()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the worst performance.
]]
---@param limit integer|nil
---@param includeUncalled boolean|nil
---@param inclusive boolean|nil
function Noir.Debugging:ShowLeastPerformantTracked(limit, includeUncalled, inclusive)
    self:_Show("*Least* performant"..(inclusive and " (inclusive)" or " (self)"), self.GetLeastPerformantTracked, limit, includeUncalled, inclusive)
end

--[[
    Returns the tracked functions with the best performance.
]]
---@param inclusive boolean|nil
---@return table<integer, NoirTracker>
function Noir.Debugging:GetMostPerformantTracked(inclusive)
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        if inclusive then
            return a:GetAverageExecutionTime() < b:GetAverageExecutionTime()
        end

        return a:GetAverageSelfExecutionTime() < b:GetAverageSelfExecutionTime()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the best performance.
]]
---@param limit integer|nil
---@param includeUncalled boolean|nil
---@param inclusive boolean|nil
function Noir.Debugging:ShowMostPerformantTracked(limit, includeUncalled, inclusive)
    self:_Show("*Most* performant"..(inclusive and " (inclusive)" or " (self)"), self.GetMostPerformantTracked, limit, includeUncalled, inclusive)
end

--[[
    Returns the tracked functions with the most calls.
]]
---@return table<integer, NoirTracker>
function Noir.Debugging:GetMostCalledTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a:GetCallCount() > b:GetCallCount()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the most calls.
]]
---@param limit integer|nil
---@param includeUncalled boolean|nil
function Noir.Debugging:ShowMostCalledTracked(limit, includeUncalled)
    self:_Show("*Most* called", self.GetMostCalledTracked, limit, includeUncalled)
end

--[[
    Returns the tracked functions with the most calls per tick.
]]
---@return table<integer, NoirTracker>
function Noir.Debugging:GetMostCalledPerTickTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a:GetAverageCallsPerTick() > b:GetAverageCallsPerTick()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the most calls per tick.
]]
---@param limit integer|nil
---@param includeUncalled boolean|nil
function Noir.Debugging:ShowMostCalledPerTickTracked(limit, includeUncalled)
    self:_Show("*Most* calls/tick", self.GetMostCalledPerTickTracked, limit, includeUncalled)
end

--[[
    Track a function. This returns a tracker which will track the performance of the function among other things.<br>
    Returns `nil` if the provided function isn't allowed to be tracked or if debugging isn't enabled.
    
    local tracker = Noir.Debugging:TrackFunction("myFunction", myFunction)
    myFunction = tracker:Mount()

    tracker:GetAverageExecutionTime() -- 0.01 ms
    tracker:GetLastExecutionTime() -- 0.02 ms
    -- etc
]]
---@param name string
---@param func function
---@return NoirTracker|nil
function Noir.Debugging:TrackFunction(name, func)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Debugging:TrackFunction()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Debugging:TrackFunction()", "func", func, "function")

    -- Checks
    if not self.Enabled then
        return
    end

    if self._TrackingExceptions[func] then
        return
    end

    local existing = self._ByFunction[func]

    if existing then
        existing.Aliases[name] = true
        return existing
    end

    -- Track
    local tracker = Noir.Classes.Tracker:New(name, func)
    self._ByFunction[func] = tracker
    self._ByFunction[tracker:Mount()] = tracker

    table.insert(self.Trackers, tracker)

    -- Handle events
    tracker.OnBeforeCall:Connect(function(...)
        self.OnBeforeCall:Fire(tracker, ...)
    end)

    tracker.OnAfterCall:Connect(function(...)
        self.OnAfterCall:Fire(tracker, ...)
    end)

    -- Return
    return tracker
end

--[[
    Track all functions in a table. This will track all methods in the provided table, returning a table of all the trackers created.<br>
    Returns an empty table if debugging isn't enabled or the provided table is an exception.
]]
---@param name string
---@param tbl table
---@param _journey table<table, boolean>|nil Used internally to prevent infinite recursion
---@return table<integer, NoirTracker>
function Noir.Debugging:TrackAll(name, tbl, _journey)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Debugging:TrackAll()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Debugging:TrackAll()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Debugging:TrackAll()", "_journey", _journey, "table", "nil")

    local visited = _journey or {}
    local trackers = {}
    local seen = {}

    ---@param path string
    ---@param source table
    local function visit(path, source)
        if visited[source] or self._TrackingExceptions[source] then
            return
        end

        visited[source] = true

        for key, value in pairs(source) do
            if type(value) == "table" then
                visit(("%s.%s"):format(path, key), value)
            elseif type(value) == "function" then
                local tracker = self:TrackFunction(("%s.%s"):format(path, key), value)

                if tracker then
                    local wrapper = tracker:Mount()

                    if source == _ENV and Noir.Libraries.Table:Find(Noir.Callbacks.GameCallbacks, key) then
                        local tracked = wrapper

                        wrapper = function(...)
                            self:_RecoverCallback()

                            return tracked(...)
                        end

                        self._TrackingExceptions[wrapper] = true
                    end

                    if value ~= wrapper then
                        source[key] = wrapper
                        table.insert(tracker._Bindings, Noir.Classes.TrackerBinding:New(source, key, value, wrapper))
                    end

                    if not seen[tracker] then
                        seen[tracker] = true
                        table.insert(trackers, tracker)
                    end
                end
            end
        end
    end

    if self.Enabled then
        visit(name, tbl)
    end

    return trackers
end

--[[
    Track a service. This will track all methods in the provided service, returning a table of all the trackers created.
]]
---@param service NoirService
---@return table<integer, NoirTracker>
function Noir.Debugging:TrackService(service)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Debugging:TrackService()", "service", service, Noir.Classes.Service)

    -- Track
    return self:TrackAll(service.Name, service)
end

--[[
    Returns trackers sorted by total self time.
]]
---@return table<integer, NoirTracker>
function Noir.Debugging:GetMostTotalSelfTimeTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a.TotalSelfTime > b.TotalSelfTime
    end)

    return trackers
end

--[[
    Shows the functions with the highest total self time.
]]
---@param limit integer|nil
---@param includeUncalled boolean|nil
function Noir.Debugging:ShowMostTotalSelfTimeTracked(limit, includeUncalled)
    self:_Show("Highest total self time", self.GetMostTotalSelfTimeTracked, limit, includeUncalled)
end

--[[
    Removes a tracker and restores its mounted functions.
]]
---@param tracker NoirTracker
function Noir.Debugging:RemoveTracker(tracker)
    if not tracker._Active then
        return
    end

    tracker._Active = false

    for _, binding in ipairs(tracker._Bindings) do
        if binding.Table[binding.Key] == binding.Wrapper then
            binding.Table[binding.Key] = binding.Original
        end

        self._TrackingExceptions[binding.Wrapper] = nil
    end

    tracker._Bindings = {}
    self._ByFunction[tracker.Function] = nil
    self._ByFunction[tracker:Mount()] = nil

    for index, item in ipairs(self.Trackers) do
        if item == tracker then
            table.remove(self.Trackers, index)
            break
        end
    end
end

--[[
    Clears statistics for all trackers.
]]
function Noir.Debugging:ResetTrackers()
    for _, tracker in ipairs(self.Trackers) do
        tracker:Reset()
    end
end

--[[
    Removes all trackers.
]]
function Noir.Debugging:ClearTrackers()
    for index = #self.Trackers, 1, -1 do
        self:RemoveTracker(self.Trackers[index])
    end
end

-- Protect dependencies before addons can mount their own functions.
---@param tbl table
function Noir.Debugging:_Protect(tbl)
    if Noir.Debugging._TrackingExceptions[tbl] then
        return
    end

    Noir.Debugging._TrackingExceptions[tbl] = true

    for _, value in pairs(tbl) do
        if type(value) == "function" then
            Noir.Debugging._TrackingExceptions[value] = true
        elseif type(value) == "table" then
            self:_Protect(value)
        end
    end
end

for _, lib in pairs({server, matrix, math, table, string, Noir.Classes, Noir.Libraries, Noir.TypeChecking, Noir.Debugging}) do
    Noir.Debugging:_Protect(lib)
end

for _, func in pairs({pairs, ipairs, next, type, tostring, tonumber, error}) do
    Noir.Debugging._TrackingExceptions[func] = true
end