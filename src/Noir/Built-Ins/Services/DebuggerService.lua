--------------------------------------------------------
-- [Noir] Services - Debugger Service
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
    A useful service for debugging your code. This allows you to raise errors in the event something goes wrong,<br>
    as well as track functions to see how well they are performing and sort these functions in order of performance.<br>
    This can be useful for figuring out what functions are performing the worst which can help you optimize your addon.<br>
    This is not recommended to use in production as this service may slow your addon. Please use it for debugging purposes only.

    -- Enabling debug
    Noir.Services.DebuggerService.Enabled = true

    -- Raising an error
    Noir.Services.DebuggerService:RaiseError(":Something()", "Something went wrong!")

    -- Tracking the performance of a function
    function myFunction()
        local value = 0

        for i = 1, 100000 do 
            value = value + i
        end
        
        return value
    end

    local tracker = Noir.Services.DebuggerService:TrackFunction("myFunction", myFunction)
    myFunction = tracker:Mount()

    tracker:GetAverageExecutionTime() -- 0.01 ms
    tracker:GetLastExecutionTime() -- 0.02 ms
    print(tracker.FunctionName) -- "myFunction"

    -- Tracking the performance of all methods in a service
    local trackers = Noir.Services.DebuggerService:TrackService(Noir.Services.VehicleService) -- Does the above but for all methods in VehicleService

    -- Tracking the performance of all functions in a table
    local myTbl = {
        foo = function()
            print("foo")
        end,

        bar = function()
            print("bar")
        end
    }

    local trackers = Noir.Services.DebuggerService:TrackAll("myTbl", myTbl)
    -- To track all funcctions in your addon that are non-local, you can use the above method on `_ENV`. :TrackAll() will ignore 

    -- Getting least performant functions
    Noir..Services.DebuggerService:GetLeastPerformantTracked() -- A table of trackers. Index 1 being the least performant

    -- Showing least performant functions
    Noir.Services.DebuggerService:ShowLeastPerformantTracked() -- Will send logs via logging library. You could call this every tick or in a command, etc
]]
---@class NoirDebuggerService: NoirService
---@field Enabled boolean Whether or not the DebuggerService is enabled. Recommended to have this off if your addon is in production (eg: in a server, published to workshop, etc)
---@field Trackers table<integer, NoirTracker> The trackers created via this service
---@field _TrackingExceptions table<table|function, boolean> A table containing tables/functions that should not be tracked
Noir.Services.DebuggerService = Noir.Services:CreateService(
    "DebuggerService",
    true,
    "A service for debugging your addon.",
    "A service for debugging your addon by tracking functions, services, etc, to give you insight into what is performing the best and what is performing the worst.",
    {"Cuh4"}
)

function Noir.Services.DebuggerService:ServiceInit()
    self.Enabled = false
    self.Trackers = {}

    self._TrackingExceptions = {
        [self] = true,
        -- [Noir.Libraries.Logging] = true,
        -- [Noir.TypeChecking] = true
    }
end

--[[
    Raises an error.<br>
    This method can still be called regardless of if debugging is enabled or not.
]]
---@param source string
---@param message string
---@param ... any
function Noir.Services.DebuggerService:RaiseError(source, message, ...)
    _ENV["Noir: An error was raised. See logs for details."]()
    Noir.Libraries.Logging:Error("Error", "%s: %s", source, message, ...)
end

--[[
    Returns all tracked functions with the option to copy.
]]
---@param copy boolean|nil
function Noir.Services.DebuggerService:GetTrackedFunctions(copy)
    Noir.TypeChecking:Assert("Noir.Services.DebuggerService:GetTrackedFunctions()", "copy", copy, "boolean", "nil")
    return copy and Noir.Libraries.Table:Copy(self.Trackers) or self.Trackers
end

--[[
    Returns the tracked functions with the worst performance.
]]
function Noir.Services.DebuggerService:GetLeastPerformantTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a:GetAverageExecutionTime() < b:GetAverageExecutionTime()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the worst performance.
]]
function Noir.Services.DebuggerService:ShowLeastPerformantTracked()
    local trackers = self:GetLeastPerformantTracked()

    Noir.Libraries.Logging:Success("DebuggerService", "--- *Least* performant functions:")

    for index, tracker in ipairs(trackers) do
        Noir.Libraries.Logging:Info("DebuggerService", "#%d: %s", index, tracker:ToFormattedString())
    end
end

--[[
    Returns the tracked functions with the best performance.
]]
function Noir.Services.DebuggerService:GetMostPerformantTracked()
    local trackers = self:GetTrackedFunctions(true)

    table.sort(trackers, function(a, b)
        return a:GetAverageExecutionTime() > b:GetAverageExecutionTime()
    end)

    return trackers
end

--[[
    Shows the tracked functions with the best performance.
]]
function Noir.Services.DebuggerService:ShowMostPerformantTracked()
    local trackers = self:GetMostPerformantTracked()

    Noir.Libraries.Logging:Success("DebuggerService", "--- *Most* performant functions:")

    for index, tracker in ipairs(trackers) do
        Noir.Libraries.Logging:Info("DebuggerService", "#%d: %s", index, tracker:ToFormattedString())
    end
end

--[[
    Track a function. This returns a tracker which will track the performance of the function among other things.<br>
    Returns `nil` if the provided function isn't allowed to be tracked or if debugging isn't enabled.
    
    local tracker = Noir.Services.DebuggerService:TrackFunction("myFunction", myFunction)
    myFunction = tracker:Mount()

    tracker:GetAverageExecutionTime() -- 0.01 ms
    tracker:GetLastExecutionTime() -- 0.02 ms
    -- etc
]]
---@param name string
---@param func function
---@return NoirTracker|nil
function Noir.Services.DebuggerService:TrackFunction(name, func)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.DebuggerService:TrackFunction()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services.DebuggerService:TrackFunction()", "func", func, "function")

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
function Noir.Services.DebuggerService:TrackAll(name, tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.DebuggerService:TrackAll()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services.DebuggerService:TrackAll()", "tbl", tbl, "table")

    -- Checks
    if not self.Enabled then
        return {}
    end

    if self._TrackingExceptions[tbl] then
        return {}
    end

    -- Track
    local trackers = {}

    for index, method in pairs(tbl) do
        if type(method) ~= "function" then
            goto continue
        end

        local tracker = self:TrackFunction(("%s:%s"):format(name, index), method)

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
function Noir.Services.DebuggerService:TrackService(service)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.DebuggerService:TrackService()", "service", service, Noir.Classes.Service)

    -- Track
    return self:TrackAll(service.Name, service)
end