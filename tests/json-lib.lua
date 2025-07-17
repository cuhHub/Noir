--------------------------------------------------------
-- [Noir] Tests - JSON Library
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

local data = {
    {
        tbl = {},
        jsonEncoded = "{}"
    },
    {
        tbl = {foo = "bar"},
        jsonEncoded = "{\"foo\":\"bar\"}"
    },
    {
        tbl = {
            g = {1, 2}
        },
        jsonEncoded = "{\"g\":[1, 2]}"
    }
}

for index, value in pairs(data) do
    local encoded = Noir.Libraries.JSON:Encode(value.tbl)
    assert(encoded == value.jsonEncoded, ":Encode() returned incorrect JSON (tested on data #"..index.."). Got: "..encoded.." vs "..value.jsonEncoded)
end

local decodeTest = {
    bar = 1,
    g = {1, 2}
}

local encoded = Noir.Libraries.JSON:Encode(decodeTest)
local decoded = Noir.Libraries.JSON:Decode(encoded)
assert(decoded.bar == 1, ":Decode() returned incorrect JSON (`.bar` is not 1).")
assert(decoded.g ~= nil, ":Decode() returned incorrect JSON (`.g` is nil).")
assert(decoded.g[1] == 1, ":Decode() returned incorrect JSON (`.g` values missing).")
assert(decoded.g[2] == 2, ":Decode() returned incorrect JSON (`.g` values missing).")