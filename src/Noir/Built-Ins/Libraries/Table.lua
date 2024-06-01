--------------------------------------------------------
-- [Noir] Table
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/NoirFramework

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
    A library containing helper methods relating to tables.
]]
Noir.Libraries.Table = Noir.Libraries:Create("NoirTable")

--[[
    Returns the length of the provided table.

    local myTbl = {1, 2, 3}
    local length = Noir.Libraries.Table:Length(myTbl)
    print(length) -- 3

    local complexTable = {
        [5] = true,
        [true] = 25
    }
    local complexLength = Noir.Libraries.Table:Length(complexTable)
    print(length) -- 2
]]
---@param tbl table
---@return number
function Noir.Libraries.Table:Length(tbl)
    local length = 0

    for _ in pairs(tbl) do
        length = length + 1
    end

    return length
end

--[[
    Returns a random value in the provided table.

    local myTbl = {1, 2, 3}
    local random = Noir.Libraries.Table:Random(myTbl)
    print(random) -- 1|2|3
]]
---@param tbl table
---@return any
function Noir.Libraries.Table:Random(tbl)
    if #tbl == 0 then
        -- TODO: log
        return
    end

    return tbl[math.random(1, #tbl)]
end

--[[
    Return the keys of the provided table.

    local myTbl = {
        [true] = 1
    }

    local keys = Noir.Libraries.Table:Keys(myTbl)
    print(keys) -- {true}
]]
---@param tbl table
---@return table<integer, any>
function Noir.Libraries.Table:Keys(tbl)
    local keys = {}

    for index, _ in pairs(tbl) do
        table.insert(keys, index)
    end

    return keys
end

--[[
    Return the values of the provided table.

    local myTbl = {
        [true] = 1
    }

    local values = Noir.Libraries.Table:Values(myTbl)
    print(values) -- {1}
]]
---@param tbl table
---@return table<integer, any>
function Noir.Libraries.Table:Values(tbl)
    local values = {}

    for _, value in pairs(tbl) do
        table.insert(values, value)
    end

    return values
end

--[[
    Get a portion of a table between two points.

    local myTbl = {1, 2, 3, 4, 5, 6}
    local trimmed = Noir.Libraries.Table:Slice(myTbl, 2, 4)
    print(trimmed) -- {2, 3, 4}
]]
---@param tbl table
---@param start number
---@param finish number
---@return table
function Noir.Libraries.Table:Slice(tbl, start, finish)
    return table.pack(table.unpack(tbl, start, finish))
end

--[[
    Copy a table (shallow).

    local myTbl = {1, 2, 3}
    local copy = Noir.Libraries.Table:Copy(myTbl)
    print(copy) -- {1, 2, 3}
]]
---@generic tbl: table
---@param tbl tbl
---@return tbl
function Noir.Libraries.Table:Copy(tbl)
    local new = {}

    for index, value in pairs(tbl) do
        new[index] = value
    end

    return new
end

--[[
    Copy a table (deep).

    local myTbl = {1, 2, 3}
    local copy = Noir.Libraries.Table:DeepCopy(myTbl)
    print(copy) -- {1, 2, 3}
]]
---@generic tbl: table
---@param tbl tbl
---@return tbl
function Noir.Libraries.Table:DeepCopy(tbl)
    local new = {}

    for index, value in pairs(tbl) do
        if type(value) == "table" then
            new[index] = self:DeepCopy(value)
        else
            new[index] = value
        end
    end

    return new
end

--[[
    Merge two tables together (unforced).

    local myTbl = {1, 2, 3}
    local otherTbl = {4, 5, 6}
    local merged = Noir.Libraries.Table:Merge(myTbl, otherTbl)
    print(merged) -- {1, 2, 3, 4, 5, 6}
]]
---@generic tbl: table
---@param tbl tbl
---@param other tbl
---@return tbl
function Noir.Libraries.Table:Merge(tbl, other)
    local new = self:Copy(tbl)

    for _, value in pairs(other) do
        table.insert(new, value)
    end
end

--[[
    Merge two tables together (forced).

    local myTbl = {1, 2, 3}
    local otherTbl = {4, 5, 6}
    local merged = Noir.Libraries.Table:ForceMerge(myTbl, otherTbl)
    print(merged) -- {4, 5, 6} <-- This is because the indexes are the same, so the values of myTbl were overwritten
]]
---@generic tbl: table
---@param tbl tbl
---@param other tbl
---@return tbl
function Noir.Libraries.Table:ForceMerge(tbl, other)
    local new = self:Copy(tbl)

    for index, value in pairs(other) do
        new[index] = value
    end
end