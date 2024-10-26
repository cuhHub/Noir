--------------------------------------------------------
-- [Noir] Libraries - Logging
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
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
    A library containing methods related to logging.
]]
---@class NoirLoggingLib: NoirLibrary
Noir.Libraries.Logging = Noir.Libraries:Create(
    "Logging",
    "A library containing methods related to logging.",
    nil,
    {"Cuh4"}
)

--[[
    The mode to use when logging.<br>
    - "DebugLog": Sends logs to DebugView<br>
    - "Chat": Sends logs to chat
]]
Noir.Libraries.Logging.LoggingMode = "DebugLog" ---@type NoirLoggingMode

--[[
    An event called when a log is sent.<br>
    Arguments: (log: string)
]]
Noir.Libraries.Logging.OnLog = Noir.Libraries.Events:Create()

--[[
    Represents the logging layout.<br>
    Requires two '%s' in the layout. First %s is the addon name, second %s is the log type, and the third %s is the log title. The message is then added after the layout.
]]
Noir.Libraries.Logging.Layout = "[Noir] [%s] [%s] [%s]: "

--[[
    Set the logging mode.

    Noir.Libraries.Logging:SetMode("DebugLog")
]]
---@param mode NoirLoggingMode
function Noir.Libraries.Logging:SetMode(mode)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:SetMode()", "mode", mode, "string")
    self.LoggingMode = mode
end

--[[
    Sends a log.

    Noir.Libraries.Logging:Log("Warning", "Title", "Something went wrong relating to %s", "something.")
]]
---@param logType string
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Log(logType, title, message, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Log()", "logType", logType, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Log()", "title", title, "string")

    -- Format
    local formattedText = self:_FormatLog(logType, title, message, ...)

    -- Send log
    if self.LoggingMode == "DebugLog" then
        debug.log(formattedText)
    elseif self.LoggingMode == "Chat" then
        debug.log(formattedText)
        server.announce("Noir", formattedText)
    else
        self:Error("Logging", "'%s' is not a valid logging mode.", true, tostring(Noir.Libraries.LoggingMode))
    end

    -- Send event
    self.OnLog:Fire(formattedText)
end

--[[
    Format a log.<br>
    Used internally.
]]
---@param logType string
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:_FormatLog(logType, title, message, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:_FormatLog()", "logType", logType, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:_FormatLog()", "title", title, "string")

    -- Validate args
    local validatedLogType = tostring(logType)
    local validatedTitle = tostring(title)
    local validatedMessage = type(message) == "table" and Noir.Libraries.Table:ToString(message) or (... and tostring(message):format(...) or tostring(message))

    -- Format text
    local formattedMessage = (self.Layout:format(Noir.AddonName, validatedLogType, validatedTitle)..validatedMessage):gsub("\n", "\n"..self.Layout:format(Noir.AddonName, validatedLogType, validatedTitle))

    -- Return
    return formattedMessage
end

--[[
    Sends an error log.<br>
    Passing true to the third argument will intentionally cause an addon error to be thrown.

    Noir.Libraries.Logging:Error("Title", "Something went wrong relating to %s", true, "something.")
]]
---@param title string
---@param message any
---@param triggerError boolean
---@param ... any
function Noir.Libraries.Logging:Error(title, message, triggerError, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Error()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Error()", "triggerError", triggerError, "boolean")

    self:Log("Error", title, message, ...)

    if triggerError then
        _ENV["Noir: An error was triggered. See logs for details."]()
    end
end

--[[
    Sends a warning log.

    Noir.Libraries.Logging:Warning("Title", "Something went unexpected relating to %s", "something.")
]]
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Warning(title, message, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Warning()", "title", title, "string")
    self:Log("Warning", title, message, ...)
end

--[[
    Sends an info log.

    Noir.Libraries.Logging:Info("Title", "Something went okay relating to %s", "something.")
]]
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Info(title, message, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Info()", "title", title, "string")
    self:Log("Info", title, message, ...)
end

--[[
    Sends a success log.

    Noir.Libraries.Logging:Success("Title", "Something went right relating to %s", "something.")
]]
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Success(title, message, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Success()", "title", title, "string")
    self:Log("Success", title, message, ...)
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirLoggingMode
---| "Chat" Sends via server.announce and via debug.log
---| "DebugLog" Sends only via debug.log