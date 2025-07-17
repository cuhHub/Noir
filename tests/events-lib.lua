--------------------------------------------------------
-- [Noir] Tests - Events Library
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

local fired = false
local event = Noir.Libraries.Events:Create()

local function func()
    fired = true
end

local connection = event:Connect(func)

assert(event.Connections[connection.ID] == connection, "Connection not added to event")
assert(event.CurrentID == 1, "ID not incremented")
assert(connection.Callback == func, "Connection callback was not set properly")

event:Fire()
assert(fired, "Event was not fired")
assert(event.HasFiredOnce, "HasFiredOnce was not set")

event:Disconnect(connection)
assert(event.Connections[connection.ID] == nil, "Connection not removed from event (event:Disconnect())")

connection = event:Connect(func)
connection:Disconnect()
assert(event.Connections[connection.ID] == nil, "Connection not removed from event (connection:Disconnect())")