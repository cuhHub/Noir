--------------------------------------------------------
-- [Noir] Classes - Logger
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
    Represents a logger, used for logging messages to chat and other places.<br>
    Functionality of loggers can be extended with LoggerMiddleware instances, allowing for<br>
    sending logs to other places - like a Discord webhook via HTTP.
]]
---@class NoirLogger: NoirClass
---@field New fun(self: NoirLogger, name: string): NoirLogger
---@field Name string The name of the logger
---@field Middleware table<integer, NoirLoggerMiddleware> The middleware attached to this logger
---@field LevelFilter NoirLogLevel Logs below this level will not be sent
---@field Enabled boolean Whether or not this logger is enabled
---@field Formatter NoirLogFormatter The formatter for this logger
---@field OnLog NoirEvent Fired when this logger logs something | Arguments: record (NoirLogRecord)
Noir.Classes.Logger = Noir.Class("Logger")

--[[
    Initializes Logger class objects.
]]
---@param name string
function Noir.Classes.Logger:Init(name)
    Noir.TypeChecking:Assert("Noir.Classes.Logger:Init()", "name", name, "string")

    self.Name = name
    self.Middleware = {}
    self.LevelFilter = Noir.Enums.LogLevel.DEBUG
    self.Enabled = true

    self.Formatter = function(record)
        local start = ("[%s] [%s] [%sms] (%s): "):format(
            Noir.AddonName,
            Noir.Classes.Logger:GetLevelName(record.Level),
            record.Time,
            record.Logger.Name
        )

        return start..record.Message:gsub("\n", "\n"..start)
    end

    self.OnLog = Noir.Libraries.Events:Create()
end

--[[
    Sets whether the logger is enabled or not.
]]
---@param enabled boolean
function Noir.Classes.Logger:SetEnabled(enabled)
    Noir.TypeChecking:Assert("Noir.Classes.Logger:SetEnabled()", "enabled", enabled, "boolean")
    self.Enabled = enabled
end

--[[
    Returns if the logger is enabled.
]]
---@return boolean
function Noir.Classes.Logger:IsEnabled()
    return self.Enabled
end

--[[
    Sets the log filter.
]]
---@param level NoirLogLevel
function Noir.Classes.Logger:SetFilter(level)
    Noir.TypeChecking:Assert("Noir.Classes.Logger:SetFilter()", "level", level, "number")
    self.LevelFilter = level
end

--[[
    Attaches middleware to this logger.
]]
---@param middleware NoirLoggerMiddleware
function Noir.Classes.Logger:AttachMiddleware(middleware)
    Noir.TypeChecking:Assert("Noir.Classes.Logger:AttachMiddleware()", "middleware", middleware, Noir.Classes.LoggerMiddleware)
    table.insert(self.Middleware, middleware)
end

--[[
    Sets the formatter for this logger.
]]
---@param formatter NoirLogFormatter
function Noir.Classes.Logger:SetFormatter(formatter)
    Noir.TypeChecking:Assert("Noir.Classes.Logger:SetFormatter()", "formatter", formatter, "function")
    self.Formatter = formatter
end

--[[
    Returns the log level formatted a string.
]]
---@param level NoirLogLevel
---@return string
function Noir.Classes.Logger:GetLevelName(level)
    if level == Noir.Enums.LogLevel.DEBUG then
        return "DEBUG"
    elseif level == Noir.Enums.LogLevel.INFO then
        return "INFO"
    elseif level == Noir.Enums.LogLevel.SUCCESS then
        return "SUCCESS"
    elseif level == Noir.Enums.LogLevel.WARNING then
        return "WARNING"
    elseif level == Noir.Enums.LogLevel.ERROR then
        return "ERROR"
    else
        return "UNKNOWN"
    end
end

--[[
    Returns if this logger can handle a log level based on the logger's filter.
]]
---@param level NoirLogLevel
---@return boolean
function Noir.Classes.Logger:CanHandle(level)
    return level >= self.LevelFilter
end

--[[
    Returns all middleware attached to this logger.
]]
---@return table<integer, NoirLoggerMiddleware>
function Noir.Classes.Logger:GetMiddleware()
    return self.Middleware
end

--[[
    Propagates a log record to all attached middleware for processing.
]]
---@param record NoirLogRecord
function Noir.Classes.Logger:_PropagateLogRecord(record)
    for _, middleware in pairs(self:GetMiddleware()) do
        middleware:Process(record)
    end
end

--[[
    Sends a log.
]]
---@param level NoirLogLevel
---@param message string
---@param ... any
---@return NoirLogRecord
function Noir.Classes.Logger:Log(level, message, ...)
    local fullMessage = ... and message:format(...) or message
    local logRecord = Noir.Classes.LogRecord:New(level, fullMessage, self, server.getTimeMillisec())

    if not self:CanHandle(level) then
        return logRecord
    end

    if not self:IsEnabled() then
        return logRecord
    end

    self:_PropagateLogRecord(logRecord)
    self.OnLog:Fire(logRecord)

    return logRecord
end

--[[
    Sends a debug log.
]]
---@param message any
---@param ... any
---@return NoirLogRecord
function Noir.Classes.Logger:Debug(message, ...)
    return self:Log(Noir.Enums.LogLevel.DEBUG, message, ...)
end

--[[
    Sends an info log.
]]
---@param message any
---@param ... any
---@return NoirLogRecord
function Noir.Classes.Logger:Info(message, ...)
    return self:Log(Noir.Enums.LogLevel.INFO, message, ...)
end

--[[
    Sends a success log.
]]
---@param message any
---@param ... any
---@return NoirLogRecord
function Noir.Classes.Logger:Success(message, ...)
    return self:Log(Noir.Enums.LogLevel.SUCCESS, message, ...)
end

--[[
    Sends a warning log.
]]
---@param message any
---@param ... any
---@return NoirLogRecord
function Noir.Classes.Logger:Warning(message, ...)
    return self:Log(Noir.Enums.LogLevel.WARNING, message, ...)
end

--[[
    Sends an error log.
]]
---@param message any
---@param ... any
---@return NoirLogRecord
function Noir.Classes.Logger:Error(message, ...)
    return self:Log(Noir.Enums.LogLevel.ERROR, message, ...)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a function used for formatting log records.
]]
---@alias NoirLogFormatter fun(record: NoirLogRecord): string