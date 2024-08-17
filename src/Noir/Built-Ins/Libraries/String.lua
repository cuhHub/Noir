--------------------------------------------------------
-- [Noir] Libraries - String
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
    A library containing helper methods relating to strings.
]]
---@class NoirStringLib: NoirLibrary
Noir.Libraries.String = Noir.Libraries:Create(
    "NoirString",
    "A library containing helper methods relating to strings.",
    nil,
    {"Cuh4"}
)

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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.String:Split()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.String:Split()", "separator", separator, "string", "nil")

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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.String:SplitLines()", "str", str, "string")

    -- Split the string by newlines
    return self:Split(str, "\n")
end

--[[
    Returns whether or not the provided string starts with the provided prefix.

    local myString = "hello world"
    Noir.Libraries.String:StartsWith(myString, "hello") -- true
    Noir.Libraries.String:StartsWith(myString, "world") -- false
]]
---@param str string
---@param prefix string
---@return boolean
function Noir.Libraries.String:StartsWith(str, prefix)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.String:StartsWith()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.String:StartsWith()", "prefix", prefix, "string")

    -- Return
    if prefix == "" then
        return false
    end

    return str:sub(1, #prefix) == prefix
end

--[[
    Returns whether or not the provided string ends with the provided suffix.

    local myString = "hello world"
    Noir.Libraries.String:EndsWith(myString, "world") -- true
    Noir.Libraries.String:EndsWith(myString, "hello") -- false
]]
---@param str string
---@param suffix string
---@return boolean
function Noir.Libraries.String:EndsWith(str, suffix)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.String:EndsWith()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.String:EndsWith()", "suffix", suffix, "string")

    -- Return
    if suffix == "" then
        return false
    end

    return str:sub(-#suffix) == suffix
end