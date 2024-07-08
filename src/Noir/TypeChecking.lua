--------------------------------------------------------
-- [Noir] Type Checking
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
    A module of Noir for checking if a value is of the correct type.<br>
    This normally would be a library, but libraries need to use this and libraries are meant to be independent of each other.
]]
Noir.TypeChecking = {}

--[[
    A dummy class.<br>
    Used internally.
]]
Noir.TypeChecking.DummyClass = Noir.Class("NoirTypeCheckingDummyClass")

--[[
    Raises an error if the value is not any of the provided types.<br>
    This has basic support for classes. It will check if the provided value is a Noir class if needed, but it will not check if it's the right class.
]]
---@param origin string The name of the method that called this so the user can find out where something went wrong
---@param value any
---@param ... NoirTypeCheckingType
function Noir.TypeChecking:Assert(origin, value, ...)
    -- Pack types into a table
    local types = {...}

    -- Get value type
    local valueType = type(value)

    -- Check if the value is of the correct type
    local isClassWhileCheckTable = false -- sorry for the horrendous variable name. this is here so the error doesn't say "expected 'table' but got 'table'"

    for _, typeToCheck in pairs(types) do
        if not isClassWhileCheckTable then
            isClassWhileCheckTable = typeToCheck == "table" and self.DummyClass:IsClass(value)
        end

        if (valueType == typeToCheck) and not isClassWhileCheckTable then -- classes should not count as tables, hence the weird check at the end
            return
        end

        if typeToCheck == "class" and self.DummyClass:IsClass(value) then
            return
        end
    end

    -- Otherwise, raise an error
    Noir.Libraries.Logging:Error("Invalid Type", "%s: Expected %s, but got '%s'.", true, origin, self:FormatTypes(types), isClassWhileCheckTable and "class" or valueType)
end

--[[
    Format required types for an error message.<br>
    Used internally.
]]
---@param types table<integer, NoirTypeCheckingType>
---@return string
function Noir.TypeChecking:FormatTypes(types)
    local formatted = ""

    for index, typeToFormat in pairs(types) do
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