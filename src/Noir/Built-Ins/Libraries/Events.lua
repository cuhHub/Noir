--------------------------------------------------------
-- [Noir] Libraries - Events
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub), @Avril112113 (GitHub)
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
    A library that allows you to create events.

    local MyEvent = Events:Create()

    MyEvent:Connect(function()
        print("Fired")
    end)

    MyEvent:Once(function() -- Automatically disconnected upon event being fired
        print("Fired (once)")
    end)

    MyEvent:Fire()
]]
---@class NoirEventsLib: NoirLibrary
Noir.Libraries.Events = Noir.Libraries:Create(
    "Events",
    "A library that allows you to create events.",
    "A library that allows you to create events. Functions can then be connected or disconnected from these events. Events can be fired which calls all connected functions with the provided arguments.",
    {"Cuh4", "Avril112113"}
)

--[[
    Create an event. This event can then be fired with the :Fire() method.

    local MyEvent = Noir.Libraries.Events:Create()

    local connection = MyEvent:Connect(function()
        print("Fired")
    end)

    connection:Disconnect() -- Disconnects the callback from the event

    local connection2 = MyEvent:Once(function() -- Automatically disconnected upon fire
        print("Fired. This won't be printed ever again even if the event is fired again")
    end)

    MyEvent:Fire() -- "Fired. This won't be printed ever again even if the event is fired again"
]]
---@return NoirEvent
function Noir.Libraries.Events:Create()
    local event = Noir.Classes.Event:New()
    return event
end

--[[
    Return this in the function provided to `:Connect()` to disconnect the function from the connected event after it is called.<br>
    This is similar to calling `:Disconnect()` after a connection to an event was fired.
    
    local MyEvent = Noir.Libraries.Events:Create()

    MyEvent:Connect(function()
        print("Fired")
        return Noir.Libraries.Events.DismissAction
    end)

    MyEvent:Fire()
    -- "Fired"
    MyEvent:Fire()
    -- N/A
]]
Noir.Libraries.Events.DismissAction = {}