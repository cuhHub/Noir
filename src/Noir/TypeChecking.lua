--------------------------------------------------------
-- [Noir] Type Checking
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
    A module of Noir for checking if a value is of the correct type.<br>
    This normally would be a library, but libraries need to use this and libraries are meant to be independent of each other.
]]
Noir.TypeChecking = {}

--[[
    Raises an error if the value is not any of the provided types.<br>
    This supports checking if a value is a specific class or not too.
]]
---@param origin string The location of the thing (method, function, etc) that called this so the user can find out where something went wrong
---@param parameterName string The name of the parameter that is being type checked
---@param value any
---@param ... NoirTypeCheckingType
function Noir.TypeChecking:Assert(origin, parameterName, value, ...)
    -- TODO: Type checking can't be performed here otherwise we get a stack overflow :-( very small priority but might want to get this sorted in the future

    -- Pack types into a table
    local types = {...}

    -- Get value type
    local valueType = type(value)

    -- Check if the value is of the correct type
    for _, typeToCheck in pairs(types) do
        -- Value == ExactType
        if valueType == typeToCheck then
            return
        end

        -- Value == Any Class
        if typeToCheck == "class" and Noir.IsClass(value) then
            return
        end

        -- Value == Exact Class
        if Noir.IsClass(typeToCheck) and typeToCheck:IsSameType(value) then ---@diagnostic disable-line param-type-mismatch
            return
        end
    end

    -- Otherwise, raise an error
    error(
        origin,
        "Expected %s for parameter '%s', but got '%s'.",
        self:_FormatTypes(types),
        parameterName,
        Noir.IsClass(value) and value.ClassName.." (Class)" or valueType
    )
end

--[[
    Raises an error if any of the provided values are not any of the provided types.
]]
---@param origin string The location of the thing (method, function, etc) that called this so the user can find out where something went wrong
---@param parameterName string The name of the parameter that is being type checked
---@param values table<integer, any>
---@param ... NoirTypeCheckingType
function Noir.TypeChecking:AssertMany(origin, parameterName, values, ...)
    -- Perform type checking on the provided parameters
    self:Assert("Noir.TypeChecking:AssertMany()", "origin", origin, "string")
    self:Assert("Noir.TypeChecking:AssertMany()", "parameterName", parameterName, "string")
    self:Assert("Noir.TypeChecking:AssertMany()", "values", values, "table")

    -- Perform type checking for provided values
    for _, value in pairs(values) do
        self:Assert(origin, parameterName, value, ...)
    end
end

--[[
    Format required types for an error message.<br>
    Used internally.
]]
---@param types table<integer, NoirTypeCheckingType>
---@return string
function Noir.TypeChecking:_FormatTypes(types)
    -- Perform type checking
    self:Assert("Noir.TypeChecking:_FormatTypes()", "types", types, "table")

    -- Format types
    local formatted = ""

    for index, typeToFormat in pairs(types) do
        if Noir.IsClass(typeToFormat) then
            typeToFormat = typeToFormat.ClassName
        end

        local formattedType = ("'%s'%s"):format(typeToFormat, index ~= #types and (index == #types - 1 and " or " or ", ") or "")
        formatted = formatted..formattedType
    end

    return formatted
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirTypeCheckingType
---| "string"
---| "number"
---| "boolean"
---| "nil"
---| "table"
---| "function"
---| "class"
---| NoirClass