--------------------------------------------------------
-- [Noir] Libraries - Table
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
    A library containing helper methods relating to tables.
]]
---@class NoirTableLib: NoirLibrary
Noir.Libraries.Table = Noir.Libraries:Create(
    "Table",
    "A library containing helper methods relating to tables.",
    nil,
    {"Cuh4"}
)

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
---@return integer
function Noir.Libraries.Table:Length(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Length()", "tbl", tbl, "table")

    -- Calculate the length of the table
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Random()", "tbl", tbl, "table")

    -- Prevent an error if the table is empty
    if #tbl == 0 then
        return
    end

    -- Return a random value
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
---@generic tbl: table
---@param tbl table
---@return tbl
function Noir.Libraries.Table:Keys(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Keys()", "tbl", tbl, "table")

    -- Create a new table with the keys of the provided table
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
---@generic tbl: table
---@param tbl tbl
---@return tbl
function Noir.Libraries.Table:Values(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Values()", "tbl", tbl, "table")

    -- Create a new table with the values of the provided table
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
---@generic tbl: table
---@param tbl tbl
---@param start number|nil
---@param finish number|nil
---@return tbl
function Noir.Libraries.Table:Slice(tbl, start, finish)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Slice()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Slice()", "start", start, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Slice()", "finish", finish, "number", "nil")

    -- Slice the table
    return {table.unpack(tbl, start, finish)}
end

--[[
    Converts a table to a string by iterating deep through the table.

    local myTbl = {1, 2, {}, "foo"}
    local string = Noir.Libraries.Table:ToString(myTbl)
    print(string) -- 1: 1\n2: 2\n3: {}\n4: "foo"
    
]]
---@param tbl table
---@param indent integer|nil
---@return string
function Noir.Libraries.Table:ToString(tbl, indent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ToString()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ToString()", "indent", indent, "number", "nil")

    -- Set default indent
    if not indent then
        indent = 0
    end

    -- Create a table for later
    local toConcatenate = {}

    -- Convert the table to a string
    for index, value in pairs(tbl) do
        -- Get value type
        local valueType = type(value)

        -- Format the index for later
        local formattedIndex = ("[%s]:"):format(type(index) == "string" and "\""..index.."\"" or tostring(index):gsub("\n", "\\n"))

        -- Format the value
        local toAdd = formattedIndex

        if valueType == "table" then
            -- Format table
            local nextIndent = indent + 2
            local formattedValue = Noir.Libraries.Table:ToString(value, nextIndent)

            -- Check if empty table
            if formattedValue == "" then
                formattedValue = "{}"
            else
                formattedValue = "\n"..formattedValue
            end

            -- Add to string
            toAdd = toAdd..(" %s"):format(formattedValue)
        elseif valueType == "number" or valueType == "boolean" then
            toAdd = toAdd..(" %s"):format(tostring(value))
        else
            toAdd = toAdd..(" \"%s\""):format(tostring(value):gsub("\n", "\\n"))
        end

        -- Add to table
        table.insert(toConcatenate, ("  "):rep(indent)..toAdd)
    end

    -- Return the table as a formatted string
    return table.concat(toConcatenate, "\n")
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Copy()", "tbl", tbl, "table")

    -- Perform a shallow copy
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:DeepCopy()", "tbl", tbl, "table")

    -- Perform a deep copy
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
---@param tbl table
---@param other table
---@return table
function Noir.Libraries.Table:Merge(tbl, other)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Merge()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Merge()", "other", other, "table")

    -- Merge the tables
    local new = self:Copy(tbl)

    for _, value in pairs(other) do
        table.insert(new, value)
    end

    return new
end

--[[
    Merge two tables together (forced).

    local myTbl = {1, 2, 3}
    local otherTbl = {4, 5, 6}
    local merged = Noir.Libraries.Table:ForceMerge(myTbl, otherTbl)
    print(merged) -- {4, 5, 6} <-- This is because the indexes are the same, so the values of myTbl were overwritten
]]
---@param tbl table
---@param other table
---@return table
function Noir.Libraries.Table:ForceMerge(tbl, other)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ForceMerge()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ForceMerge()", "other", other, "table")

    -- Merge the tables forcefully
    local new = self:Copy(tbl)

    for index, value in pairs(other) do
        new[index] = value
    end

    return new
end

--[[
    Find a value in a table. Returns the index, or nil if not found.

    local myTbl = {["hello"] = true}

    local index = Noir.Libraries.Table:Find(myTbl, true)
    print(index) -- "hello"
]]
---@param tbl table
---@param value any
---@return any|nil
function Noir.Libraries.Table:Find(tbl, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Find()", "tbl", tbl, "table")

    -- Find the value
    for index, iterValue in pairs(tbl) do
        if iterValue == value then
            return index
        end
    end
end

--[[
    Find a value in a table. Unlike `:Find()`, this method will recursively search through nested tables to find the value.

    local myTbl = {
        mySecondTbl = {
            hello = true
        }
    }
    
    local index, table = Noir.Libraries.Table:FindDeep(myTbl, true)
    print(index) -- "hello"
    print(table) -- {["hello"] = true}
]]
---@param tbl table
---@param value any
---@return any|nil, table|nil
function Noir.Libraries.Table:FindDeep(tbl, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:FindDeep()", "tbl", tbl, "table")

    -- Find the value
    for index, iterValue in pairs(tbl) do
        if iterValue == value then
            return index, tbl
        elseif type(iterValue) == "table" then
            local _index, _tbl = self:FindDeep(iterValue, value)

            if _index and _tbl then
                return _index, _tbl
            end
        end
    end
end