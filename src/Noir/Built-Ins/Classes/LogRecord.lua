--------------------------------------------------------
-- [Noir] Classes - Log Record
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
    Represents a log record (a logged message, essentially).
]]
---@class NoirLogRecord: NoirClass
---@field New fun(self: NoirLogRecord, level: NoirLogLevel, message: string, logger: NoirLogger, time: number): NoirLogRecord
---@field Level NoirLogLevel The log level
---@field Message string The log message
---@field Logger NoirLogger The logger the log was sent from
---@field Time number The time the log was sent (milliseconds)
Noir.Classes.LogRecord = Noir.Class("LogRecord")

--[[
    Initializes LogRecord class objects.
]]
---@param level NoirLogLevel
---@param message string
---@param logger NoirLogger
---@param time number
function Noir.Classes.LogRecord:Init(level, message, logger, time)
    Noir.TypeChecking:Assert("Noir.Classes.LogRecord:Init()", "level", level, "number")
    Noir.TypeChecking:Assert("Noir.Classes.LogRecord:Init()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Classes.LogRecord:Init()", "logger", logger, Noir.Classes.Logger)
    Noir.TypeChecking:Assert("Noir.Classes.LogRecord:Init()", "time", time, "number")

    self.Level = level
    self.Message = message
    self.Logger = logger
    self.Time = time
end

--[[
    Formats the record using the parent logger's formatter.
]]
---@return string
function Noir.Classes.LogRecord:Format()
    return self.Logger.Formatter(self)
end