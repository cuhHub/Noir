--------------------------------------------------------
-- [Noir] Libraries - HTTP
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2025 Cuh4

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
    A library containing helper methods relating to HTTP.
]]
---@class NoirHTTPLib: NoirLibrary
Noir.Libraries.HTTP = Noir.Libraries:Create(
    "HTTP",
    "A library containing helper methods relating to HTTP.",
    "A library containing helper methods relating to HTTP. Comes with methods for encoding/decoding URLs, etc.",
    {"Cuh4"}
)

--[[
    Encode a string into a URL-safe string.
]]
---@param str string
---@return string
function Noir.Libraries.HTTP:URLEncode(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.HTTP:URLEncode()", "str", str, "string")

    -- Encode and return
    return (str:gsub(
        "([^%w%-%_%.%~])",

        ---@param c string
        function(c)
            return ("%%%02X"):format(c:byte())
        end
    ))
end

--[[
    Decode a URL-safe string into a string.
]]
---@param str string
---@return string
function Noir.Libraries.HTTP:URLDecode(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.HTTP:URLDecode()", "str", str, "string")

    -- Decode and return
    return (str:gsub(
        "%%(%x%x)",

        ---@param c string
        function(c)
            return string.char(tonumber(c, 16))
        end
    ))
end

--[[
    Convert a table of URL parameters into a string.
]]
---@param parameters table<string, any>
---@return string
function Noir.Libraries.HTTP:URLParameters(parameters)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.HTTP:URLParameters()", "parameters", parameters, "table")

    -- Convert
    local str = ""
    local count = 0

    for key, value in pairs(parameters) do
        count = count + 1

        if count == 1 then
            str = ("?%s=%s"):format(self:URLEncode(tostring(key)), self:URLEncode(tostring(value)))
        else
            str = ("%s&%s=%s"):format(str, self:URLEncode(tostring(key)), self:URLEncode(tostring(value)))
        end
    end

    -- Return
    return str
end

--[[
    Returns whether or not a response to a HTTP request is ok.
]]
---@param response string
---@return boolean
function Noir.Libraries.HTTP:IsResponseOk(response)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.HTTP:IsResponseOk()", "response", response, "string")

    -- Return
    return ({
        ["Connection closed unexpectedly"] = true,
        ["connect(): Connection refused"] = true,
        ["recv(): Connection reset by peer"] = true,
        ["timeout"] = true,
		["connect(): Can't assign requested address"] = true
    })[response] == nil
end