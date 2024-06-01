--------------------------------------------------------
-- [Noir] Logging
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
    A library containing methods related to logging.
]]
Noir.Libraries.Logging = Noir.Libraries:Create("NoirLogging")

--[[
    The mode to use when logging.<br>
    "DebugLog": Sends logs to DebugView
    "Chat": Sends logs to chat
]]
---@type NoirLoggingMode
Noir.Libraries.Logging.LoggingMode = "DebugLog"

--[[
    Set the logging mode.

    Noir.Libraries.Logging:SetMode("DebugLog")
]]
---@param mode NoirLoggingMode
function Noir.Libraries.Logging:SetMode(mode)
    self.LoggingMode = mode
end

--[[
    Sends a log.

    Noir.Libraries.Logging:Log("Warning", "Title", "Something went wrong relating to %s", "something.")
]]
---@param logType string
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Log(logType, title, message, ...)
    -- validate args
    local validatedLogType = tostring(logType):upper()
    local validatedTitle = tostring(title)
    local validatedMessage = type(message) == "table" and Noir.Libraries.Table:TableToString(message) or (... and tostring(message):format(...) or tostring(message))

    local formattedText = ("[%s] %s: %s"):format(validatedLogType, validatedTitle, validatedMessage)

    -- send log
    if self.LoggingMode == "DebugLog" then
        debug.log(formattedText)
    elseif self.LoggingMode == "Chat" then
        server.announce("Noir", formattedText)
    else
        self:Error("Invalid logging mode: %s", "'%s' is not a valid logging mode.", tostring(Noir.Libraries.LoggingMode))
    end
end

--[[
    Sends an error log.

    Noir.Libraries.Logging:Error("Something went wrong relating to %s", "something.")
]]
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Error(title, message, ...)
    Noir.Libraries.Logging:Log("Error", title, message, ...)
end

--[[
    Sends a warning log.

    Noir.Libraries.Logging:Warning("Something went unexpected relating to %s", "something.")
]]
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Warning(title, message, ...)
    Noir.Libraries.Logging:Log("Warning", title, message, ...)
end

--[[
    Sends an info log.

    Noir.Libraries.Logging:Info("Something went okay relating to %s", "something.")
]]
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Info(title, message, ...)
    Noir.Libraries.Logging:Log("Info", title, message, ...)
end

--[[
    Sends a success log.

    Noir.Libraries.Logging:Success("Something went right relating to %s", "something.")
]]
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Success(title, message, ...)
    Noir.Libraries.Logging:Log("Success", title, message, ...)
end

--[[
    Converts a table to a string.
]]
---@param tbl table
---@return string
function Noir.Libraries.Logging:TableToString(tbl)
    
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirLoggingMode
---| "Chat"
---| "DebugLog"