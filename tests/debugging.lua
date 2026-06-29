--------------------------------------------------------
-- [Noir] Tests - Debugging
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

-- RaiseError: should error via the debug.error alias
local success, err = pcall(function()
    Noir.Debugging:RaiseError(":Something()", "Something went wrong!")
end)
assert(not success, "RaiseError should have errored")

-- RaiseError: OnError event fires
local firedSource = nil
local firedMessage = nil
local connection = Noir.Debugging.OnError:Connect(function(source, message)
    firedSource = source
    firedMessage = message
end)

local success, _ = pcall(function()
    Noir.Debugging:RaiseError(":MyFunc()", "My error message: %s", "details")
end)
assert(firedSource == ":MyFunc()", "Expected ':MyFunc()' for OnError source, got: " .. tostring(firedSource))
assert(firedMessage == "My error message: details", "Expected 'My error message: details' for OnError message, got: " .. tostring(firedMessage))
connection:Disconnect()

-- OnBeforeCall / OnAfterCall events exist
assert(Noir.Debugging.OnError ~= nil, "OnError event should exist")
assert(Noir.Debugging.OnBeforeCall ~= nil, "OnBeforeCall event should exist")
assert(Noir.Debugging.OnAfterCall ~= nil, "OnAfterCall event should exist")

-- TrackFunction: returns nil when debugging is not enabled
local tracker = Noir.Debugging:TrackFunction("myFunction", function() end)
assert(tracker == nil, "TrackFunction should return nil when debugging is disabled")

-- Enable debugging for tracker tests
Noir.Debugging.Enabled = true

-- TrackFunction: basic usage
local myFunc = function()
    return 42
end

local tracker = Noir.Debugging:TrackFunction("myFunction", myFunc)
assert(tracker ~= nil, "TrackFunction should return a tracker when debugging is enabled")
assert(tracker.FunctionName == "myFunction", "Expected 'myFunction' for FunctionName, got: " .. tostring(tracker.FunctionName))
assert(tracker.Function == myFunc, "Expected original function to match")
assert(tracker:GetName() == "myFunction", ":GetName() should return 'myFunction'")
assert(tracker:GetCallCount() == 0, "Expected call count to be 0 initially")

-- Mount and call the function
local mountedFunc = tracker:Mount()
assert(type(mountedFunc) == "function", "Mount should return a function")

local result = mountedFunc()
assert(result == 42, "Expected mounted function to return 42, got: " .. tostring(result))
assert(tracker:GetCallCount() == 1, "Expected call count to be 1 after one call")
assert(tracker:GetLastExecutionTime() >= 0, "Expected last execution time to be >= 0")

-- Mount and call multiple times
mountedFunc()
mountedFunc()
assert(tracker:GetCallCount() == 3, "Expected call count to be 3 after three calls")
assert(tracker:GetAverageExecutionTime() >= 0, "Expected average execution time to be >= 0")

-- TrackFunction: _TrackingExceptions should cause nil return
local exceptionFunc = function() end
Noir.Debugging._TrackingExceptions[exceptionFunc] = true
local exceptionTracker = Noir.Debugging:TrackFunction("exceptionFunc", exceptionFunc)
assert(exceptionTracker == nil, "TrackFunction should return nil for functions in _TrackingExceptions")
Noir.Debugging._TrackingExceptions[exceptionFunc] = nil

-- TrackFunction: type checking errors
local success, err = pcall(function()
    Noir.Debugging:TrackFunction(123, function() end)
end)
assert(not success, "TrackFunction should error for non-string name")

local success, err = pcall(function()
    Noir.Debugging:TrackFunction("test", "not_a_function")
end)
assert(not success, "TrackFunction should error for non-function")

-- OnBeforeCall and OnAfterCall events fire
local beforeCalled = false
local afterCalled = false

local beforeConnection = Noir.Debugging.OnBeforeCall:Connect(function(tracker, ...)
    beforeCalled = true
end)

local afterConnection = Noir.Debugging.OnAfterCall:Connect(function(tracker, ...)
    afterCalled = true
end)

local anotherFunc = function() return "hello" end
local anotherTracker = Noir.Debugging:TrackFunction("anotherFunction", anotherFunc)
local mountedAnother = anotherTracker:Mount()
mountedAnother()

assert(beforeCalled == true, "OnBeforeCall should have fired")
assert(afterCalled == true, "OnAfterCall should have fired")

beforeConnection:Disconnect()
afterConnection:Disconnect()

-- GetTrackedFunctions
local tracked = Noir.Debugging:GetTrackedFunctions()
assert(#tracked >= 2, "Expected at least 2 tracked functions, got: " .. #tracked)

local trackedCopy = Noir.Debugging:GetTrackedFunctions(true)
assert(trackedCopy ~= tracked, "GetTrackedFunctions(true) should return a copy")

-- GetLeastPerformantTracked / GetMostPerformantTracked / GetMostCalledTracked
-- These should work even with our simple trackers
local least = Noir.Debugging:GetLeastPerformantTracked()
assert(type(least) == "table", "GetLeastPerformantTracked should return a table")
assert(#least >= 2, "Expected at least 2 trackers")

local most = Noir.Debugging:GetMostPerformantTracked()
assert(type(most) == "table", "GetMostPerformantTracked should return a table")

local mostCalled = Noir.Debugging:GetMostCalledTracked()
assert(type(mostCalled) == "table", "GetMostCalledTracked should return a table")

-- GetLastCalledTracked
local lastCalled = Noir.Debugging:GetLastCalledTracked()
assert(type(lastCalled) == "table", "GetLastCalledTracked should return a table")

-- ToFormattedString
local formatted = tracker:ToFormattedString()
assert(type(formatted) == "string", "ToFormattedString should return a string")
assert(formatted:find("myFunction") ~= nil, "ToFormattedString should contain the function name")

-- Tracker: GetCallsPerTick / GetAverageCallsPerTick
assert(type(tracker:GetCallsPerTick()) == "number", "GetCallsPerTick should return a number")
assert(type(tracker:GetAverageCallsPerTick()) == "number", "GetAverageCallsPerTick should return a number")

-- Disable debugging after tests
Noir.Debugging.Enabled = false