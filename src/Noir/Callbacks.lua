--------------------------------------------------------
-- [Noir] Callbacks
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
    A module of Noir that allows you to attach multiple functions to game callbacks.<br>
    These functions can be disconnected from the game callbacks at any time.

    Noir.Callbacks:Connect("onPlayerJoin", function()
        server.announce("Server", "A player joined!")
    end)

    Noir.Callbacks:Once("onPlayerJoin", function()
        server.announce("Server", "A player joined! (once) This will never be shown again.")
    end)
]]
Noir.Callbacks = {}

--[[
    A table of events assigned to game callbacks.<br>
    Do not directly modify this table.
]]
Noir.Callbacks.Events = {} ---@type table<string, NoirEvent>

--[[
    Connect to a game callback.

    Noir.Callbacks:Connect("onPlayerJoin", function()
        -- Code here
    end)
]]
---@param name string
---@param callback fun(...)
function Noir.Callbacks:Connect(name, callback)
    -- get or create event
    local event = self:InstantiateCallback(name)

    -- connect callback to event
    event:Connect(callback)
end

--[[
    Connect to a game callback, but disconnect after the game callback has been called.

    Noir.Callbacks:Once("onPlayerJoin", function()
        -- Code here
    end)
]]
---@param name string
---@param callback fun(...)
function Noir.Callbacks:Once(name, callback)
    -- get or create event
    local event = self:InstantiateCallback(name)

    -- connect callback to event
    event:Once(callback)
end

--[[
    Get a game callback event.<br>
    It's best to use `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` instead of getting a callback event directly and connecting to it.

    local event = Noir.Callbacks:Get("onPlayerJoin")

    event:Connect(function()
        server.announce("Server", "A player joined!")
    end)
]]
---@param name string
---@return NoirEvent
function Noir.Callbacks:Get(name)
    return self.Events[name]
end

--[[
    Creates an event and an _ENV function for a game callback.<br>
    Used internally, do not use this in your addon.
]]
---@param name string
---@return NoirEvent
function Noir.Callbacks:InstantiateCallback(name)
    -- for later
    local event = Noir.Callbacks.Events[name]
    local doesEventExist = event ~= nil

    -- create event if it doesn't exist
    if not event then
        event = Noir.Libraries.Events:Create()
        self.Events[name] = event
    end

    -- create function for game callback if it doesn't exist. if the user created the callback themselves, overwrite it
    if not _ENV[name] or (_ENV[name] and not doesEventExist) then
        _ENV[name] = function(...)
            event:Fire(...)
        end
    end

    -- return event
    return event
end