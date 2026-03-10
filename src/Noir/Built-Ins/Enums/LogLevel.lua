--------------------------------------------------------
-- [Noir] Enums - Log Level
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
    Represents a log level, with higher levels being more severe.
]]
Noir.Enums.LogLevel = {
    --[[
        The log level for debug messages.
    ]]
    DEBUG = 0,

    --[[
        The log level for info messages.
    ]]
    INFO = 5,

    --[[
        The log level for success messages.
    ]]
    SUCCESS = 10,

    --[[
        The log level for warning messages.
    ]]
    WARNING = 15,

    --[[
        The log level for error messages.
    ]]
    ERROR = 20
}

--[[
    Represents a log level, with higher levels being more severe.
]]
---@alias NoirLogLevel
---| 0 # The log level for debug messages.
---| 5 # The log level for info messages.
---| 10 # The log level for success messages.
---| 15 # The log level for warning messages.
---| 20 # The log level for error messages.