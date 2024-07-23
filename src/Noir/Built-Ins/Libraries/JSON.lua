--------------------------------------------------------
-- [Noir] Libraries - JSON
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
    A library containing helper methods to serialize Lua objects into JSON and back.<br>
    This code is from https://gist.github.com/tylerneylon/59f4bcf316be525b30ab
]]
---@class NoirJSONLib: NoirLibrary
Noir.Libraries.JSON = Noir.Libraries:Create(
    "NoirJSON",
    "A library containing helper methods to serialize Lua objects into JSON and back.",
    nil,
    {"Cuh4"}
)

--[[
    Represents a null value.
]]
Noir.Libraries.JSON.Null = {}

--[[
    Returns the type of the provided object.<br>
    Used internally. Do not use in your code.
]]
---@param obj any
---@return "nil"|"boolean"|"number"|"string"|"table"|"function"|"array"
function Noir.Libraries.JSON:KindOf(obj)
    if type(obj) ~= "table" then
        return type(obj) ---@diagnostic disable-line
    end

    local i = 1

    for _ in pairs(obj) do
        if obj[i] ~= nil then
            i = i + 1
        else
            return "table"
        end
    end

    if i == 1 then
        return "table"
    else
        return "array"
    end
end

--[[
    Escapes a string for JSON.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@return string
function Noir.Libraries.JSON:EscapeString(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:EscapeString()", "str", str, "string")

    -- Escape the string
    local inChar  = { "\\", "\"", "/", "\b", "\f", "\n", "\r", "\t" }
    local outChar = { "\\", "\"", "/", "b", "f", "n", "r", "t" }

    for i, c in ipairs(inChar) do
        str = str:gsub(c, "\\" .. outChar[i])
    end

    return str
end

--[[
    Finds the point where a delimiter is and simply returns the point after.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@param pos integer
---@param delim string
---@param errIfMissing boolean|nil
---@return integer
---@return boolean
function Noir.Libraries.JSON:SkipDelim(str, pos, delim, errIfMissing)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:SkipDelim()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:SkipDelim()", "pos", pos, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:SkipDelim()", "delim", delim, "string")

    -- Main logic
    pos = pos + #str:match("^%s*", pos)

    if str:sub(pos, pos) ~= delim then
        if errIfMissing then
            Noir.Libraries.Logging:Error("JSON", "Expected %s at position %d", true, delim, pos)
            return 0, false
        end

        return pos, false
    end

    return pos + 1, true
end

--[[
    Parses a string.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@param pos integer
---@param val string|nil
---@return string
---@return integer
function Noir.Libraries.JSON:ParseStringValue(str, pos, val)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseStringValue()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseStringValue()", "pos", pos, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseStringValue()", "val", val, "string", "nil")

    -- Parsing
    val = val or ""

    local earlyEndError = "End of input found while parsing string."

    if pos > #str then
        Noir.Libraries.Logging:Error("JSON", earlyEndError, true)
        return "", 0
    end

    local c = str:sub(pos, pos)

    if c == "\"" then
        return val, pos + 1
    end

    if c ~= "\\" then return
        self:ParseStringValue(str, pos + 1, val .. c)
    end

    local escMap = {b = "\b", f = "\f", n = "\n", r = "\r", t = "\t"}
    local nextc = str:sub(pos + 1, pos + 1)

    if not nextc then
        Noir.Libraries.Logging:Error("JSON", earlyEndError, true)
        return "", 0
    end

    return self:ParseStringValue(str, pos + 2, val..(escMap[nextc] or nextc))
end

--[[
    Parses a number.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@param pos integer
---@return integer
---@return integer
function Noir.Libraries.JSON:ParseNumberValue(str, pos)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseNumberValue()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseNumberValue()", "pos", pos, "number")

    -- Parse number
    local numStr = str:match("^-?%d+%.?%d*[eE]?[+-]?%d*", pos)
    local val = tonumber(numStr)

    if not val then
        Noir.Libraries.Logging:Error("JSON", "Error parsing number at position %s.", true, pos)
        return 0, 0
    end

    return val, pos + #numStr
end

--[[
    Encodes a Lua object as a JSON string.

    local str = {1, 2, 3}
    Noir.Libraries.JSON:Encode(str) -- "{1, 2, 3}"
]]
---@param obj table|number|string|boolean|nil
---@param asKey boolean|nil
---@return string
function Noir.Libraries.JSON:Encode(obj, asKey)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Encode()", "obj", obj, "table", "number", "string", "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Encode()", "asKey", asKey, "boolean", "nil")

    -- Encode the object into a JSON string
    local s = {}
    local kind = self:KindOf(obj)

    if kind == "array" then
        if asKey then
            Noir.Libraries.Logging:Error("JSON", "Can't encode array as key.", true)
            return ""
        end

        s[#s + 1] = "["

        for i, val in ipairs(obj --[[@as table]]) do
            if i > 1 then
                s[#s + 1] = ", "
            end

            s[#s + 1] = self:Encode(val)
        end

        s[#s + 1] = "]"
    elseif kind == "table" then
        if asKey then
            Noir.Libraries.Logging:Error("JSON", "Can't encode table as key.", true)
            return ""
        end

        s[#s + 1] = "{"

        for k, v in pairs(obj --[[@as table]]) do
            if #s > 1 then
                s[#s + 1] = ", "
            end

            s[#s + 1] = self:Encode(k, true)
            s[#s + 1] = ":"
            s[#s + 1] = self:Encode(v)
        end

        s[#s + 1] = "}"
    elseif kind == "string" then
        return "\""..self:EscapeString(obj --[[@as string]]).."\""
    elseif kind == "number" then
        if asKey then
            return "\"" .. tostring(obj) .. "\""
        end

        return tostring(obj)
    elseif kind == "boolean" then
        return tostring(obj)
    elseif kind == "nil" then
        return "null"
    else
        Noir.Libraries.Logging:Error("JSON", "Type of %s cannot be JSON encoded.", true, kind)
        return ""
    end

    return table.concat(s)
end

--[[
    Decodes a JSON string into a Lua object.

    local obj = "{1, 2, 3}"
    Noir.Libraries.JSON:Decode(obj) -- {1, 2, 3}
]]
---@param str string
---@param pos integer|nil
---@param endDelim string|nil
---@return any
---@return integer
function Noir.Libraries.JSON:Decode(str, pos, endDelim)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Decode()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Decode()", "pos", pos, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Decode()", "endDelim", endDelim, "string", "nil")

    -- Decode a JSON string into a Lua object
    pos = pos or 1

    if pos > #str then
        Noir.Libraries.Logging:Error("JSON", "Reached unexpected end of input.", true)
    end

    pos = pos + #str:match("^%s*", pos)
    local first = str:sub(pos, pos)

    if first == "{" then
        local obj, key, delimFound = {}, true, true
        pos = pos + 1

        while true do
            key, pos = self:Decode(str, pos, "}")

            if key == nil then
                return obj, pos
            end

            if not delimFound then
                Noir.Libraries.Logging:Error("JSON", "Comma missing between object items.", true)
                return nil, 0
            end

            pos = self:SkipDelim(str, pos, ":", true)
            obj[key], pos = self:Decode(str, pos)
            pos, delimFound = self:SkipDelim(str, pos, ",")
        end
    elseif first == "[" then
        local arr, val, delimFound = {}, true, true
        pos = pos + 1

        while true do
            val, pos = self:Decode(str, pos, "]")

            if val == nil then
                return arr, pos
            end

            if not delimFound then
                Noir.Libraries.Logging:Error("JSON", "Comma missing between array items.", true)
                return nil, 0
            end

            arr[#arr + 1] = val
            pos, delimFound = self:SkipDelim(str, pos, ",")
        end
    elseif first == "\"" then
        return self:ParseStringValue(str, pos + 1)
    elseif first == "-" or first:match("%d") then
        return self:ParseNumberValue(str, pos)
    elseif first == endDelim then
        return nil, pos + 1
    else
        local literals = {["true"] = true, ["false"] = false, ["null"] = self.Null}

        for litStr, litVal in pairs(literals) do
            local litEnd = pos + #litStr - 1

            if str:sub(pos, litEnd) == litStr then
                return litVal, litEnd + 1
            end
        end

        local posInfoStr = "position "..pos..": "..str:sub(pos, pos + 10)
        Noir.Libraries.Logging:Error("JSON", "Invalid json syntax starting at %s", true, posInfoStr)

        return nil, 0
    end
end