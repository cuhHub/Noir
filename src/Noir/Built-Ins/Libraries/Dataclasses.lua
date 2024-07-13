--------------------------------------------------------
-- [Noir] Libraries - Dataclasses
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
    A library that allows you to create dataclasses, similar to Python.

    local InventoryItem = Noir.Libraries.Dataclasses:New("InventoryItem", {
        Noir.Libraries.Dataclasses:Field("Name", "String"),
        Noir.Libraries.Dataclasses:Field("Weight", "Number"),
        Noir.Libraries.Dataclasses:Field("Stackable", "Boolean")
    })

    local item = InventoryItem:New("Sword", 5, true)
    print(item.Name, item.Weight, item.Stackable)
]]
---@class NoirDataclassesLib: NoirLibrary
Noir.Libraries.Dataclasses = Noir.Libraries:Create(
    "NoirDataclasses",
    "A library that allows you to create dataclasses, similar to Python.",
    nil,
    {"Cuh4"}
)

--[[
    Create a new dataclass.

    local InventoryItem = Noir.Libraries.Dataclasses:New("InventoryItem", {
        Noir.Libraries.Dataclasses:Field("Name", "String"),
        Noir.Libraries.Dataclasses:Field("Weight", "Number"),
        Noir.Libraries.Dataclasses:Field("Stackable", "Boolean")
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
        -- Pack into table
        local args = {...} ---@type table<integer, any>

        -- Check number of arguments
        if #args ~= #fields then
            Noir.Libraries.Logging:Error(("%s (Dataclass)"):format(name), "Invalid number of arguments. Expected %s, got %s.", true, #fields, #args)
            return
        end

        -- Iterate through arguments and create fields in this dataclass
        for index, arg in pairs(args) do
            -- Get field
            local field = fields[index]

            if not field then
                Noir.Libraries.Logging:Error(("%s (Dataclass)"):format(name), "An argument provided doesn't have a corresponding field.", true)
                return
            end

            -- Type check
            Noir.TypeChecking:Assert("Dataclass:Init()", field.Name, arg, field.Type)

            -- Ensure we're not overwriting anyway
            if self[field.Name] then
                Noir.Libraries.Logging:Error(("%s (Dataclass)"):format(name), "'%s' overwrites an existing field (possibly a built-in field to a class like 'ClassName'). To fix this, rename the field to something else.", true, field.Name)
                return
            end

            -- Insert field
            self[field.Name] = arg
        end
    end

    -- Return
    return dataclass
end

--[[
    Returns a dataclass field to be used with Noir.Libraries.Dataclasses:New().
]]
---@param name string
---@param type NoirTypeCheckingType
---@return NoirDataclassField
function Noir.Libraries.Dataclasses:Field(name, type)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Dataclasses:Field()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Dataclasses:Field()", "type", type, "string")

    -- Construct and return field
    return {Name = name, Type = type}
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a field for a dataclass.
]]
---@class NoirDataclassField
---@field Name string
---@field Type NoirTypeCheckingType