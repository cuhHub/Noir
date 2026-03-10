--------------------------------------------------------
-- [Noir] Classes - Logger Middleware
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2026 Cuh4

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
    Represents a logger middleware.<br>
    Logger middleware are used to handle any logs sent via a logger.<br>
    An example of a logger middleware is one that receives logs and sends them in chat.
]]
---@class NoirLoggerMiddleware: NoirClass
---@field New fun(self: NoirLoggerMiddleware, name: string): NoirLoggerMiddleware
---@field Name string The name of the logger middleware
---@field LevelFilter NoirLogLevel The log level below which this logger middleware will ignore logs
---@field Enabled boolean Whether or not this logger middleware is enabled
Noir.Classes.LoggerMiddleware = Noir.Class("LoggerMiddleware")

--[[
    Initializes LoggerMiddleware class objects.
]]
---@param name string
function Noir.Classes.LoggerMiddleware:Init(name)
    Noir.TypeChecking:Assert("Noir.Classes.LoggerMiddleware:Init()", "name", name, "string")

    self.Name = name
    self.LevelFilter = Noir.Enums.LogLevel.DEBUG
    self.Enabled = true
end

--[[
    Sets the level filter for this middleware.
]]
---@param level NoirLogLevel
function Noir.Classes.LoggerMiddleware:SetFilter(level)
    Noir.TypeChecking:Assert("Noir.Classes.LoggerMiddleware:SetFilter()", "level", level, "number")
    self.LevelFilter = level
end

--[[
    Enables or disables this middleware.
]]
---@param enabled boolean
function Noir.Classes.LoggerMiddleware:SetEnabled(enabled)
    Noir.TypeChecking:Assert("Noir.Classes.LoggerMiddleware:Enable()", "enabled", enabled, "boolean")
    self.Enabled = enabled
end

--[[
    Returns if this middleware can handle a log record.
]]
---@param record NoirLogRecord
---@return boolean
function Noir.Classes.LoggerMiddleware:CanHandle(record)
    return record.Level >= self.LevelFilter and self.Enabled
end

--[[
    Processes a log record.
]]
---@param record NoirLogRecord
function Noir.Classes.LoggerMiddleware:Process(record)
    if not self:CanHandle(record) then
        return
    end

    self:OnLog(record)
end

--[[
    Called when a log from the attached logger is received.<br>
    *abstractmethod - replace with own implementation in subclass*
]]
---@param record NoirLogRecord
function Noir.Classes.LoggerMiddleware:OnLog(record) end