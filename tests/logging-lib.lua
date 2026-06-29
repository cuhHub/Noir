--------------------------------------------------------
-- [Noir] Tests - Logging Library
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

-- CreateLogger: basic usage
local logger = Noir.Libraries.Logging:CreateLogger("MyLogger")
assert(logger ~= nil, "CreateLogger returned nil")
assert(logger.Name == "MyLogger", "Expected 'MyLogger' for logger name, got: " .. tostring(logger.Name))
assert(logger.Enabled == true, "Expected logger to be enabled by default")
assert(logger.LevelFilter == Noir.Enums.LogLevel.DEBUG, "Expected default level filter to be DEBUG")
assert(logger.Middleware ~= nil, "Expected middleware table to exist")
assert(#logger.Middleware == 0, "Expected no middleware by default")

-- CreateLogger: type checking should error for invalid name
local success, err = pcall(function()
    Noir.Libraries.Logging:CreateLogger(123) ---@diagnostic disable-line
end)
assert(not success, "CreateLogger should have errored for non-string name")

-- Logger: SetEnabled / IsEnabled
logger:SetEnabled(false)
assert(logger:IsEnabled() == false, "Expected logger to be disabled")
logger:SetEnabled(true)
assert(logger:IsEnabled() == true, "Expected logger to be enabled")

-- Logger: SetFilter
logger:SetFilter(Noir.Enums.LogLevel.ERROR)
assert(logger.LevelFilter == Noir.Enums.LogLevel.ERROR, "Expected level filter to be ERROR")

-- reset filter
logger:SetFilter(Noir.Enums.LogLevel.DEBUG)

-- Logger: GetLevelName
assert(Noir.Classes.Logger:GetLevelName(Noir.Enums.LogLevel.DEBUG) == "DEBUG", "Expected 'DEBUG' for DEBUG level")
assert(Noir.Classes.Logger:GetLevelName(Noir.Enums.LogLevel.INFO) == "INFO", "Expected 'INFO' for INFO level")
assert(Noir.Classes.Logger:GetLevelName(Noir.Enums.LogLevel.SUCCESS) == "SUCCESS", "Expected 'SUCCESS' for SUCCESS level")
assert(Noir.Classes.Logger:GetLevelName(Noir.Enums.LogLevel.WARNING) == "WARNING", "Expected 'WARNING' for WARNING level")
assert(Noir.Classes.Logger:GetLevelName(Noir.Enums.LogLevel.ERROR) == "ERROR", "Expected 'ERROR' for ERROR level")
assert(Noir.Classes.Logger:GetLevelName(999) == "UNKNOWN", "Expected 'UNKNOWN' for unknown level") ---@diagnostic disable-line

-- Logger: CanHandle
logger:SetFilter(Noir.Enums.LogLevel.WARNING)
assert(logger:CanHandle(Noir.Enums.LogLevel.ERROR) == true, "Should be able to handle ERROR when filter is WARNING")
assert(logger:CanHandle(Noir.Enums.LogLevel.DEBUG) == false, "Should NOT be able to handle DEBUG when filter is WARNING")
assert(logger:CanHandle(Noir.Enums.LogLevel.WARNING) == true, "Should be able to handle WARNING when filter is WARNING")

-- reset filter
logger:SetFilter(Noir.Enums.LogLevel.DEBUG)

-- Logger: Log returns a LogRecord
local record = logger:Log(Noir.Enums.LogLevel.INFO, "Test message")
assert(record ~= nil, "Log should return a LogRecord")
assert(record.Level == Noir.Enums.LogLevel.INFO, "Expected INFO level for log record")
assert(record.Message == "Test message", "Expected 'Test message' for log record message")
assert(record.Logger == logger, "Expected logger to match")
assert(record.Time ~= nil, "Expected time to be set")

-- Logger: Log with format arguments
local record = logger:Log(Noir.Enums.LogLevel.INFO, "Hello %s, you are #%d", "User", 1)
assert(record.Message == "Hello User, you are #1", "Expected formatted message, got: " .. record.Message)

-- Logger: Debug, Info, Success, Warning, Error methods
local record = logger:Debug("Debug message")
assert(record.Level == Noir.Enums.LogLevel.DEBUG, "Expected DEBUG level")

local record = logger:Info("Info message")
assert(record.Level == Noir.Enums.LogLevel.INFO, "Expected INFO level")

local record = logger:Success("Success message")
assert(record.Level == Noir.Enums.LogLevel.SUCCESS, "Expected SUCCESS level")

local record = logger:Warning("Warning message")
assert(record.Level == Noir.Enums.LogLevel.WARNING, "Expected WARNING level")

local record = logger:Error("Error message")
assert(record.Level == Noir.Enums.LogLevel.ERROR, "Expected ERROR level")

-- Logger: OnLog event fires
local loggedRecord = nil
local connection = logger.OnLog:Connect(function(record)
    loggedRecord = record
end)

logger:Info("Test OnLog")
assert(loggedRecord ~= nil, "OnLog should have fired")
assert(loggedRecord.Message == "Test OnLog", "Expected 'Test OnLog' for OnLog record message")
connection:Disconnect()