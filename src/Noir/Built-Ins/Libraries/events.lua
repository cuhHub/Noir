--------------------------------------------------------
-- [Noir] Events
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/NoirFramework

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
local Events = Noir.Libraries:Create("Events")

-- Event Class
Events.EventClass = Noir.Libraries.Class:Create("Event") ---@type NoirLib_Event

function Events.EventClass:Init()
    self.currentID = 0
    self.connections = {}
end

function Events.EventClass:Fire(...)
    -- Iterate through all connections and fire them
    for _, connection in pairs(self.connections) do
        connection:Fire(...)
    end
end

function Events.EventClass:Connect(callback)
    -- Increment ID
    self.currentID = self.currentID + 1

    -- Create connection
    local connection = Events.ConnectionClass:New(callback, self) ---@type NoirLib_Connection
    self.connections[self.currentID] = connection

    connection.parentEvent = self
    connection.ID = self.currentID
    connection.connected = true

    -- Return the connection
    return connection
end

function Events.EventClass:Once(callback)
    -- Create connection
    local connection

    connection = self:Connect(function(...)
        callback(...)
        connection:Disconnect()
    end)

    -- Return the connection
    return connection
end

function Events.EventClass:Disconnect(connection)
    self.connections[connection.ID] = nil

    connection.connected = false
    connection.parentEvent = nil
    connection.ID = nil
end

-- Connection Class
Events.ConnectionClass = Noir.Libraries.Class:Create("Connection") ---@type NoirLib_Connection

function Events.ConnectionClass:Init(callback)
    self.callback = callback
    self.parentEvent = nil
    self.ID = nil
    self.connected = false
end

function Events.ConnectionClass:Connect(event)
    event:Connect(self)
end

function Events.ConnectionClass:Fire(...)
    if not self.connected then
        -- TODO: log
        return
    end

    self.callback(...)
end

function Events.ConnectionClass:Disconnect()
    if not self.connected then
        -- TODO: log
        return
    end

    self.parentEvent:Disconnect(self)
end

--[[
    Create an event. This event can then be fired with the :Fire() method.

    local MyEvent = Events:Create()

    local connection = MyEvent:Connect(function()
        print("Fired")
    end)

    connection:Disconnect() -- Disconnects the callback from the event

    local connection2 = MyEvent:Once(function() -- Automatically disconnected upon fire
        print("Fired. This won't be printed ever again even if the event is fired again")
    end)

    MyEvent:Fire() -- "Fired. This won't be printed ever again even if the event is fired again"
]]
---@return NoirLib_Event
function Events:Create()
    local event = Events.EventClass:New() ---@type NoirLib_Event
    return event
end

Noir.Libraries.Events = Events

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirLib_Event: NoirLib_Class
---@field currentID integer
---@field connections table<integer, NoirLib_Connection>
---
---@field Fire fun(self: NoirLib_Event, ...) A method that fires the event
---@field Connect fun(self: NoirLib_Event, callback: fun(...)): NoirLib_Connection A method that connects a callback to the event
---@field Once fun(self: NoirLib_Event, callback: fun(...)): NoirLib_Connection A method that connects a callback to the event that will automatically be disconnected upon the event being fired
---@field Disconnect fun(self: NoirLib_Event, connection: NoirLib_Connection) A method that disconnects a callback from the event

---@class NoirLib_Connection: NoirLib_Class
---@field ID integer
---@field callback fun(...)
---@field parentEvent NoirLib_Event
---@field connected boolean
---
---@field Connect fun(self: NoirLib_Connection, event: NoirLib_Event) A method that connects this connection to an event
---@field Fire fun(self: NoirLib_Connection, ...) A method that fires the callback
---@field Disconnect fun(self: NoirLib_Connection) A method that disconnects the callback