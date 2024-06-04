--------------------------------------------------------
-- [Noir] Classes - Event
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
    A class for events.
]]
---@class NoirEvent: NoirClass
---@field CurrentID integer The ID that will be passed to new connections. Increments by 1 every connection
---@field Connections table<integer, NoirConnection> The connections that are connected to this event
---@field ConnectionsOrder integer[] Array of connection IDs into Connections table
---@field ConnectionsToRemove NoirConnection[]? Array of connections to remove after the firing of the event
---@field ConnectionsToAdd NoirConnection[]? Array of connections to add after the firing of the event
---@field IsFiring boolean Weather or not this event is currently calling connection callbacks
---@field HasFiredOnce boolean Whether or not this event has fired atleast once
Noir.Classes.EventClass = Noir.Class("NoirEvent")

--[[
    Initializes event  class objects.
]]
function Noir.Classes.EventClass:Init()
    self.CurrentID = 0
    self.Connections = {}
    self.ConnectionsOrder = {}
    self.ConnectionsToRemove = {}  -- Only used when IsFiring is true, should remain empty otherwise.
    self.ConnectionsToAdd = {}  -- Only used when IsFiring is true, should remain empty otherwise.
    self.ConnectionsToAddMap = {}  -- Only used when IsFiring is true, should remain empty otherwise.
    self.IsFiring = false
    self.HasFiredOnce = false
end

--[[
    Fires the event, passing any provided arguments to the connections.

    local event = Noir.Libraries.Events:Create()
    event:Fire()
]]
function Noir.Classes.EventClass:Fire(...)
    self.IsFiring = true

    for _, connection_id in ipairs(self.ConnectionsOrder) do
        self.Connections[connection_id]:Fire(...)
    end

    self.IsFiring = false

    -- Reverse iteration is more performant, as we have on book-keeping stuff we already plan to remove
    for index = #self.ConnectionsToRemove, 1, -1 do
        self:_DisconnectImmediate(self.ConnectionsToRemove[index])
        self.ConnectionsToRemove[index] = nil
    end

    -- Add connections which were connected during iteration, so they get called next time
    for index = 1, #self.ConnectionsToAdd do
        self:_ConnectFinalize(self.ConnectionsToAdd[index])
        self.ConnectionsToAdd[index] = nil
    end

    self.HasFiredOnce = true
end

--[[
    Connects a function to the event. A connection is automatically made for the function.  
    If connecting to an event that is currently being handled, it will be added afterwards and run the next time the event is fired.  

    local event = Noir.Libraries.Events:Create()

    local connection = event:Connect(function()
        print("Fired")
    end)

    connection:Disconnect() -- Disconnects the callback from the event
]]
---@param callback function
---@return NoirConnection
function Noir.Classes.EventClass:Connect(callback)
    self.CurrentID = self.CurrentID + 1

    local connection = Noir.Classes.ConnectionClass:New(callback, self) ---@type NoirConnection
    self.Connections[self.CurrentID] = connection

    connection.ParentEvent = self
    connection.ID = self.CurrentID
    connection.Index = -1
    connection.Connected = false

    -- If we are currently iterating over the events, finalize it later, otherwise do it now
    if self.IsFiring then
        table.insert(self.ConnectionsToAdd, connection)
    else
        self:_ConnectFinalize(connection)
    end

    -- Return the connection
    return connection
end

--[[
    **Should only be used internally.**  
    Finalizes the connection to the event, allowing it to be run.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:_ConnectFinalize(connection)
    table.insert(self.ConnectionsOrder, connection.ID)

    connection.Index = #self.ConnectionsOrder
    connection.Connected = true
end

--[[
    Connects a callback to the event that will automatically be disconnected upon the event being fired.  
    If connecting to an event that is currently being handled, it will be added afterwards and run the next time the event is fired.  
]]
---@param callback function
---@return NoirConnection
function Noir.Classes.EventClass:Once(callback)
    local connection

    connection = self:Connect(function(...)
        callback(...)
        connection:Disconnect()
    end)

    return connection
end

--[[
    Disconnects the provided connection from the event.  
    The disconnection may be delayed if done while handling the event.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:Disconnect(connection)
    -- If we are currently iterating over the events, disconnect it later, otherwise do it now
    if self.IsFiring then
        table.insert(self.ConnectionsToRemove, connection)
    else
        self:_DisconnectImmediate(connection)
    end
end

--[[
    **Should only be used internally.**  
    Disconnects the provided connection from the event immidiately.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:_DisconnectImmediate(connection)
    self.Connections[connection.ID] = nil
    table.remove(self.ConnectionsOrder, connection.Index)

    for index = connection.Index, #self.ConnectionsOrder do
        local _connection = self.Connections[self.ConnectionsOrder[index]]
        _connection.Index = _connection.Index - 1
    end

    connection.Connected = false
    connection.ParentEvent = nil
    connection.ID = nil
    connection.Index = nil
end
