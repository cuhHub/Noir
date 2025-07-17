--------------------------------------------------------
-- [Noir] Tests - Callbacks
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

local func = function() end
local connection = Noir.Callbacks:Connect("onPlayerJoin", func)

assert(_ENV["onPlayerJoin"] ~= nil, "onPlayerJoin function was not automatically created")

local event = Noir.Callbacks:Get("onPlayerJoin")
assert(event ~= nil, "onPlayerJoin event was not automatically created")
assert(event.Connections[connection.ID] ~= nil, "onPlayerJoin connection was not automatically created")
assert(connection.Callback == func, "Connection callback was not set properly")