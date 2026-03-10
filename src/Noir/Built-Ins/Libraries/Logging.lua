--------------------------------------------------------
-- [Noir] Libraries - Logging
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
    A library providing standard logging functionality.
]]
---@class NoirLoggingLib: NoirLibrary
Noir.Libraries.Logging = Noir.Libraries:Create(
    "Logging",
    "A library providing standard logging functionality.",
    nil,
    {"Cuh4"}
)

--[[
    Creates a logger.
]]
---@param name string
---@return NoirLogger
function Noir.Libraries.Logging:CreateLogger(name)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:CreateLogger()", "name", name, "string")
    return Noir.Classes.Logger:New(name)
end