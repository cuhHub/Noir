--------------------------------------------------------
-- [Noir] Libraries - Dataclasses
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
    A library that allows you to create dataclasses, similar to Python.

    local InventoryItem = Noir.Libraries.Dataclasses:New("InventoryItem", {
        Noir.Libraries.Dataclasses:Field("Name", "string"),
        Noir.Libraries.Dataclasses:Field("Weight", "number"),
        Noir.Libraries.Dataclasses:Field("Stackable", "boolean")
    })

    local item = InventoryItem:New("Sword", 5, true)
    print(item.Name, item.Weight, item.Stackable)
]]
---@class NoirDataclassesLib: NoirLibrary
Noir.Libraries.Dataclasses = Noir.Libraries:Create(
    "Dataclasses",
    "A library that allows you to create dataclasses, similar to Python.",
    nil,
    {"Cuh4"}
)

--[[
    Create a new dataclass.

    local InventoryItem = Noir.Libraries.Dataclasses:New("InventoryItem", {
        Noir.Libraries.Dataclasses:Field("Name", "string"),
        Noir.Libraries.Dataclasses:Field("Weight", "number"),
        Noir.Libraries.Dataclasses:Field("Stackable", "boolean")
    })

    local item = InventoryItem:New("Sword", 5, true)
    print(item.Name, item.Weight, item.Stackable)
]]
---@param name string
---@param fields table<integer, NoirDataclassField>
---@return NoirDataclass
function Noir.Libraries.Dataclasses:New(name, fields)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Dataclasses:New()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Dataclasses:New()", "fields", fields, "table")

    -- Create dataclass
    ---@class NoirDataclass: NoirClass
    ---@field New fun(self: NoirDataclass, ...: any): NoirDataclass
    local dataclass = Noir.Class(name)

    function dataclass:Init(...)
        local args = {...} ---@type table<integer, any>

        for index, field in pairs(fields) do
            local argument = args[index]

            -- If nil and nil isn't allowed, raise error
            if argument == nil and not Noir.Libraries.Table:Find(field.Types, "nil") then
                Noir.Debugging:RaiseError(("%s (Dataclass)"):format(name), "Missing argument #%d. Expected %s, got nil.", index, table.concat(field.Types, " | "))
                return
            end

            -- Perform type check
            Noir.TypeChecking:Assert(("%s:Init()"):format(name), field.Name, argument, table.unpack(field.Types))

            -- Ensure we're not overwriting
            if self[field.Name] then
                Noir.Debugging:RaiseError(("%s (Dataclass)"):format(name), "'%s' overwrites an existing field (possibly a built-in field to a class like 'ClassName'). To fix this, rename the field to something else.", field.Name)
                return
            end

            -- Insert field
            self[field.Name] = argument
        end
    end

    -- Return
    return dataclass
end

--[[
    Returns a dataclass field to be used with Noir.Libraries.Dataclasses:New().
]]
---@param name string
---@param ... NoirTypeCheckingType
---@return NoirDataclassField
function Noir.Libraries.Dataclasses:Field(name, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Dataclasses:Field()", "name", name, "string")
    Noir.TypeChecking:AssertMany("Noir.Libraries.Dataclasses:Field()", "...", {...}, "string")

    -- Construct and return field
    return {Name = name, Types = {...}}
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a field for a dataclass.
]]
---@class NoirDataclassField
---@field Name string
---@field Types table<integer, NoirTypeCheckingType>