--------------------------------------------------------
-- [Noir] Libraries - Base64
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
    A library containing helper methods to serialize strings into Base64 and back.<br>
    This code is from https://gist.github.com/To0fan/ca3ebb9c029bb5df381e4afc4d27b4a6
]]
---@class NoirBase64Lib: NoirLibrary
Noir.Libraries.Base64 = Noir.Libraries:Create(
    "Base64",
    "A library containing helper methods to serialize strings into Base64 and back.",
    "",
    {"Cuh4"}
)

--[[
    Character table as a string.<br>
    Used internally, do not use in your code.
]]
Noir.Libraries.Base64.Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

--[[
    Encode a string into Base64.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:Encode(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:Encode()", "data", data, "string")

    -- Encode the string into Base64
    ---@param str string
    local encoded = (data:gsub(".", function(str)
        return self:_EncodeInitial(str)
    end).."0000")

    ---@param str string
    return encoded:gsub("%d%d%d?%d?%d?%d?", function(str)
        return self:_EncodeFinal(str)
    end)..({"", "==", "="})[#data % 3 + 1]
end

--[[
    Used internally, do not use in your code.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:_EncodeInitial(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_EncodeInitial()", "data", data, "string")

    -- Main logic
    local r, b = "", data:byte()

    for i = 8, 1, -1 do
        r = r..(b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0")
    end

    return r
end

--[[
    Used internally, do not use in your code.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:_EncodeFinal(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_EncodeFinal()", "data", data, "string")

    -- Main logic
    if (#data < 6) then
        return ""
    end

    local c = 0

    for i = 1, 6 do
        c = c + (data:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
    end

    return self.Characters:sub(c + 1, c + 1)
end

--[[
    Decode a string from Base64.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:Decode(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:Decode()", "data", data, "string")

    -- Decode the Base64 string into a normal string
    local decoded = data:gsub("[^"..self.Characters.."=]", "")

    ---@param str string
    decoded = decoded:gsub(".", function(str)
        return self:_DecodeInitial(str)
    end)

    ---@param str string
    return (decoded:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(str)
        return self:_DecodeFinal(str)
    end))
end

--[[
    Used internally, do not use in your code.
]]
---@param str string
---@return string
function Noir.Libraries.Base64:_DecodeInitial(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_DecodeInitial()", "str", str, "string")

    -- Main logic
    if str == "=" then
        return ""
    end

    local r, f = "", (self.Characters:find(str)) - 1

    for i = 6, 1, -1 do
        r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
    end

    return r
end

--[[
    Used internally, do not use in your code.
]]
---@param str string
---@return string
function Noir.Libraries.Base64:_DecodeFinal(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_DecodeFinal()", "str", str, "string")

    -- Main logic
    if #str ~= 8 then
        return ""
    end

    local c = 0

    for i = 1, 8 do
        c = c + (str:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
    end

    if not Noir.Libraries.Number:IsInteger(c) then
        Noir.Debugging:RaiseError("Noir.Libraries.Base64:_DecodeFinal()", "'c' is not an integer.")
        return ""
    end

    return string.char(c)
end