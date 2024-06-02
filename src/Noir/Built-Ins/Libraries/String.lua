--------------------------------------------------------
-- [Noir] Libraries - String
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
    A library containing helper methods relating to strings.
]]
Noir.Libraries.String = Noir.Libraries:Create("NoirString")

--[[
    Splits a string by the provided separator (defaults to " ").

    local myString = "hello world"
    Noir.Libraries.String:Split(myString, " ") -- {"hello", "world"}
    Noir.Libraries.String:Split(myString) -- {"hello", "world"}
]]
---@param str string
---@param separator string|nil
---@return table<integer, string>
function Noir.Libraries.String:Split(str, separator)
    -- Default separator
    separator = separator or " "

    -- Split the string
    local split = {}

    for part in str:gmatch("([^"..separator.."]+)") do
        table.insert(split, part)
    end

    -- Return the split string
    return split
end

--[[
    Splits a string by their lines.

    local myString = "hello\nworld"
    Noir.Libraries.String:SplitLines(myString) -- {"hello", "world"}
]]
---@param str string
---@return table<integer, string>
function Noir.Libraries.String:SplitLines(str)
    return self:Split(str, "\n")
end