--------------------------------------------------------
-- [Noir] Classes - Connection
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
    A class for event connections.
]]
---@class NoirConnection: NoirClass
---@field New fun(self: NoirConnection, callback: function): NoirConnection
---@field ID integer The ID of this connection
---@field Callback function The callback that is assigned to this connection
---@field ParentEvent NoirEvent The event that this connection is connected to
---@field Connected boolean Whether or not this connection is connected
---@field Index integer The index of this connection in ParentEvent.ConnectionsOrder
Noir.Classes.ConnectionClass = Noir.Class("NoirConnection")

--[[
    Initializes new connection class objects.
]]
---@param callback function
function Noir.Classes.ConnectionClass:Init(callback)
    self.Callback = callback
    self.ParentEvent = nil
    self.ID = nil
    self.Connected = false
    self.Index = -1
end

--[[
    Triggers the callback's stored function.
]]
---@param ... any
function Noir.Classes.ConnectionClass:Fire(...)
    if not self.Connected then
        Noir.Libraries.Logging:Error("Event Connection", "Attempted to fire an event connection when it is not connected.", true)
        return
    end

    self.Callback(...)
end

--[[
    Disconnects the callback from the event.
]]
function Noir.Classes.ConnectionClass:Disconnect()
    if not self.Connected then
        Noir.Libraries.Logging:Error("Event Connection", "Attempted to disconnect an event connection when it is not connected.", true)
        return
    end

    self.ParentEvent:Disconnect(self)
end