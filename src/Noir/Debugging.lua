--------------------------------------------------------
-- [Noir] Debugging
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
    A module of Noir for debugging your code. This allows you to raise errors in the event something goes wrong<br>
    as well as track functions to see how well they are performing and sort these functions in order of performance.<br>
    This can be useful for figuring out what functions are performing the worst which can help you optimize your addon.<br>
    This is not recommended to use in production as this service may slow your addon. Please use it for debugging purposes only.

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
    -- To track all functions in your addon that are non-local, you can use the above method on `_ENV`. :TrackAll() will ignore non-local functions as they aren't in `_ENV` anyway

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
    A table containing all created trackers for functions.
]]
Noir.Debugging.Trackers = {}

--[[
    A table containing all functions and tables that should not be tracked.
]]
Noir.Debugging._TrackingExceptions = {
    [Noir.Debugging] = true,
    -- [Noir.Libraries.Logging] = true,
    -- [Noir.TypeChecking] = true
}

--[[
    Raises an error.<br>
    This method can still be called regardless of if debugging is enabled or not.
]]
---@param source string
---@param message string
---@param ... any
function Noir.Debugging:RaiseError(source, message, ...)
    Noir.Libraries.Logging:Error("Error", source..": "..message, ...)
    _ENV["Noir: An error was raised. See logs for details."]()
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
        return a:GetLastExecutionTime() > b:GetLastExecutionTime()
    end)

    return trackers
end

--[[
    Shows the most recently called tracked functions.
]]
function Noir.Debugging:ShowLastCalledTracked()
    local trackers = self:GetLastCalledTracked()

    Noir.Libraries.Logging:Success("Debugging", "--- *Last* called functions:")

    for index, tracker in ipairs(trackers) do
        Noir.Libraries.Logging:Info("Debugging", "#%d: %s", index, tracker:ToFormattedString())
    end
end

--[[
    Returns the tracked functions with the worst performance.
]]
---@return table<integer, NoirTracker>
function Noir.Debugging:GetLeastPerformantTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a:GetAverageExecutionTime() > b:GetAverageExecutionTime()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the worst performance.
]]
function Noir.Debugging:ShowLeastPerformantTracked()
    local trackers = self:GetLeastPerformantTracked()

    Noir.Libraries.Logging:Success("Debugging", "--- *Least* performant functions:")

    for index, tracker in ipairs(trackers) do
        Noir.Libraries.Logging:Info("Debugging", "#%d: %s", index, tracker:ToFormattedString())
    end
end

--[[
    Returns the tracked functions with the best performance.
]]
---@return table<integer, NoirTracker>
function Noir.Debugging:GetMostPerformantTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a:GetAverageExecutionTime() < b:GetAverageExecutionTime()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the best performance.
]]
function Noir.Debugging:ShowMostPerformantTracked()
    local trackers = self:GetMostPerformantTracked()

    Noir.Libraries.Logging:Success("Debugging", "--- *Most* performant functions:")

    for index, tracker in ipairs(trackers) do
        Noir.Libraries.Logging:Info("Debugging", "#%d: %s", index, tracker:ToFormattedString())
    end
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

    -- Track
    local tracker = Noir.Classes.Tracker:New(name, func)
    table.insert(self.Trackers, tracker)

    -- Return
    return tracker
end

--[[
    Track all functions in a table. This will track all methods in the provided table, returning a table of all the trackers created.<br>
    Returns an empty table if debugging isn't enabled or the provided table is an exception.
]]
---@param name string
---@param tbl table<integer, function>
---@return table<integer, NoirTracker>
function Noir.Debugging:TrackAll(name, tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Debugging:TrackAll()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Debugging:TrackAll()", "tbl", tbl, "table")

    -- Checks
    if not self.Enabled then
        return {}
    end

    if self._TrackingExceptions[tbl] then
        return {}
    end

    -- Track
    local trackers = {}

    for index, value in pairs(tbl) do
        print(name.."[\"%s\"]", index)
        if type(value) == "table" then
            print("   table, going deeper")
            trackers = Noir.Libraries.Table:Merge(trackers, self:TrackAll(("%s.%s"):format(name, index), value))
            goto continue
        end

        if type(value) ~= "function" then
            goto continue
        end

        local tracker = self:TrackFunction(("%s:%s"):format(name, index), value)

        if not tracker then
            goto continue
        end

        tbl[index] = tracker:Mount()

        table.insert(trackers, tracker)

        ::continue::
    end

    -- Return
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