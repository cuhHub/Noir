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
    A class for events.<br>
    Do not use this, but instead use `Noir.Libraries.Events:Create()`.
]]
---@class NoirEvent: NoirClass
---@field CurrentID integer The ID that will be passed to new connections. Increments by 1 every connection
---@field Connections table<integer, NoirConnection> The connections that are connected to this event
---@field HasFiredOnce boolean Whether or not this event has fired atleast once
Noir.Classes.EventClass = Noir.Libraries.Class:Create("NoirEvent")

--[[
    Initializes event  class objects.
]]
function Noir.Classes.EventClass:Init()
    self.CurrentID = 0
    self.Connections = {}
    self.HasFiredOnce = false
end

--[[
    Fires the event, passing any provided arguments to the connections.

    local event = Noir.Libraries.Events:Create()
    event:Fire()
]]
function Noir.Classes.EventClass:Fire(...)
    -- Iterate through all connections and fire them
    for _, connection in pairs(self.Connections) do
        connection:Fire(...)
    end

    -- Set hasFiredOnce
    self.HasFiredOnce = true
end

--[[
    Connects a function to the event. A connection is automatically made for the function.

    local event = Noir.Libraries.Events:Create()

    local connection = event:Connect(function()
        print("Fired")
    end)

    connection:Disconnect() -- Disconnects the callback from the event
]]
---@param callback function
---@return NoirConnection
function Noir.Classes.EventClass:Connect(callback)
    -- Increment ID
    self.CurrentID = self.CurrentID + 1

    -- Create connection
    local connection = Noir.Classes.ConnectionClass:New(callback, self) ---@type NoirConnection
    self.Connections[self.CurrentID] = connection

    connection.ParentEvent = self
    connection.ID = self.CurrentID
    connection.Connected = true

    -- Return the connection
    return connection
end

--[[
    Connects a callback to the event that will automatically be disconnected upon the event being fired.
]]
---@param callback function
---@return NoirConnection
function Noir.Classes.EventClass:Once(callback)
    -- Create connection
    local connection

    connection = self:Connect(function(...)
        callback(...)
        connection:Disconnect()
    end)

    -- Return the connection
    return connection
end

--[[
    Disconnects the provided connection from the event.
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:Disconnect(connection)
    self.Connections[connection.ID] = nil

    connection.Connected = false
    connection.ParentEvent = nil
    connection.ID = nil
end