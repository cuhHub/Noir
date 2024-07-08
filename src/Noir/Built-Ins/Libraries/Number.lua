--------------------------------------------------------
-- [Noir] Libraries - Number
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
    A library containing helper methods relating to numbers.
]]
---@class NoirNumberLib: NoirLibrary
Noir.Libraries.Number = Noir.Libraries:Create(
    "NoirNumber",
    "Provides helper methods relating to numbers.",
    nil,
    {"Cuh4"}
)

--[[
    Returns whether or not the provided number is between the two provided values.

    local number = 5
    local isWithin = Noir.Libraries.Number:IsWithin(number, 1, 10) -- true

    local number = 5
    local isWithin = Noir.Libraries.Number:IsWithin(number, 10, 20) -- false
]]
---@param number number
---@param start number
---@param stop number
---@return boolean
function Noir.Libraries.Number:IsWithin(number, start, stop)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsWithin()", "number", number, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsWithin()", "start", start, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsWithin()", "stop", stop, "number")

    -- Clamp the number
    return number >= start and number <= stop
end

--[[
    Clamps a number between two values.

    local number = 5
    local clamped = Noir.Libraries.Number:Clamp(number, 1, 10) -- 5

    local number = 15
    local clamped = Noir.Libraries.Number:Clamp(number, 1, 10) -- 10
]]
---@param number number
---@param min number
---@param max number
---@return number
function Noir.Libraries.Number:Clamp(number, min, max)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Clamp()", "number", number, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Clamp()", "min", min, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Clamp()", "max", max, "number")

    -- Clamp the number
    return math.min(math.max(number, min), max)
end

--[[
    Rounds the number to the provided number of decimal places (defaults to 0).

    local number = 5.5
    local rounded = Noir.Libraries.Number:Round(number) -- 6

    local number = 5.5
    local rounded = Noir.Libraries.Number:Round(number, 1) -- 5.5

    local number = 5.537
    local rounded = Noir.Libraries.Number:Round(number, 2) -- 5.54
]]
---@param number number
---@param decimalPlaces number|nil
---@return number
function Noir.Libraries.Number:Round(number, decimalPlaces)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Round()", "number", number, "number")

    -- Round the number
    local mult = 10 ^ (decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
end

--[[
    Returns whether or not the provided number is an integer.

    Noir.Libraries.Number:IsInteger(5) -- true
    Noir.Libraries.Number:IsInteger(5.5) -- false
]]
---@param number number
---@return boolean
function Noir.Libraries.Number:IsInteger(number)
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsInteger()", "number", number, "number")
    return math.floor(number) == number
end