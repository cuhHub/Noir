--------------------------------------------------------
-- [Noir] Libraries - Events
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
Noir.Libraries.Events = Noir.Libraries:Create("NoirEvents")

--[[
    A class for events.<br>
    Do not use this, but instead use `Noir.Libraries.Events:Create()`.
]]
Noir.Libraries.Events.EventClass = Noir.Libraries.Class:Create("NoirEvent") ---@type NoirEvent

function Noir.Libraries.Events.EventClass:Init()
    self.CurrentID = 0
    self.Connections = {}
    self.HasFiredOnce = false
end

function Noir.Libraries.Events.EventClass:Fire(...)
    -- Iterate through all connections and fire them
    for _, connection in pairs(self.Connections) do
        connection:Fire(...)
    end

    -- Set hasFiredOnce
    self.HasFiredOnce = true
end

function Noir.Libraries.Events.EventClass:Connect(callback)
    -- Increment ID
    self.CurrentID = self.CurrentID + 1

    -- Create connection
    local connection = Noir.Libraries.Events.ConnectionClass:New(callback, self) ---@type NoirConnection
    self.Connections[self.CurrentID] = connection

    connection.ParentEvent = self
    connection.ID = self.CurrentID
    connection.Connected = true

    -- Return the connection
    return connection
end

function Noir.Libraries.Events.EventClass:Once(callback)
    -- Create connection
    local connection

    connection = self:Connect(function(...)
        callback(...)
        connection:Disconnect()
    end)

    -- Return the connection
    return connection
end

function Noir.Libraries.Events.EventClass:Disconnect(connection)
    self.Connections[connection.ID] = nil

    connection.Connected = false
    connection.ParentEvent = nil
    connection.ID = nil
end

--[[
    A class for event connections.<br>
    Do not use this, but instead use `Event:Connect()`.
]]
Noir.Libraries.Events.ConnectionClass = Noir.Libraries.Class:Create("NoirConnection") ---@type NoirConnection

function Noir.Libraries.Events.ConnectionClass:Init(callback)
    self.Callback = callback
    self.ParentEvent = nil
    self.ID = nil
    self.Connected = false
end

function Noir.Libraries.Events.ConnectionClass:Fire(...)
    if not self.Connected then
        Noir.Libraries.Logging:Error("Event Connection", "Attempted to fire an event connection when it is not connected.")
        return
    end

    self.Callback(...)
end

function Noir.Libraries.Events.ConnectionClass:Disconnect()
    if not self.Connected then
        Noir.Libraries.Logging:Error("Event Connection", "Attempted to disconnect an event connection when it is not connected.")
        return
    end

    self.ParentEvent:Disconnect(self)
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
---@return NoirEvent
function Noir.Libraries.Events:Create()
    local event = self.EventClass:New() ---@type NoirEvent
    return event
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirEvent: NoirClass
---@field CurrentID integer The ID that will be passed to new connections. Increments by 1 every connection
---@field Connections table<integer, NoirConnection> The connections that are connected to this event
---@field HasFiredOnce boolean Whether or not this event has fired atleast once
---
---@field Fire fun(self: NoirEvent, ...) A method that fires the event
---@field Connect fun(self: NoirEvent, callback: function): NoirConnection A method that connects a callback to the event
---@field Once fun(self: NoirEvent, callback: function): NoirConnection A method that connects a callback to the event that will automatically be disconnected upon the event being fired
---@field Disconnect fun(self: NoirEvent, connection: NoirConnection) A method that disconnects a callback from the event

---@class NoirConnection: NoirClass
---@field ID integer The ID of this connection
---@field Callback function The callback that is assigned to this connection
---@field ParentEvent NoirEvent The event that this connection is connected to
---@field Connected boolean Whether or not this connection is connected
---
---@field Fire fun(self: NoirConnection, ...) A method that fires the callback
---@field Disconnect fun(self: NoirConnection) A method that disconnects the callback