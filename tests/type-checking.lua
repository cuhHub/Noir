--------------------------------------------------------
-- [Noir] Tests - Type Checking
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2026 Cuh4

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

-- Assert: valid single type
Noir.TypeChecking:Assert("test", "value", "hello", "string")

-- Assert: valid multiple types
Noir.TypeChecking:Assert("test", "value", 42, "string", "number")

-- Assert: invalid type should error
local success, err = pcall(function()
    Noir.TypeChecking:Assert("test", "value", 42, "string")
end)
assert(not success, "Assert should have errored for invalid type")
assert(err ~= nil, "Error message should be present")

-- Assert: nil allowed
Noir.TypeChecking:Assert("test", "value", nil, "string", "nil")

-- Assert: nil not allowed should error
local success, err = pcall(function()
    Noir.TypeChecking:Assert("test", "value", nil, "string", "number")
end)
assert(not success, "Assert should have errored for nil without 'nil' type")

-- Assert: class type checking
---@class TestClass: NoirClass
local TestClass = Noir.Class("TestClass")
function TestClass:Init() end

local instance = TestClass:New()
Noir.TypeChecking:Assert("test", "value", instance, TestClass)
Noir.TypeChecking:Assert("test", "value", instance, "class")

-- Assert: class type mismatch should error
---@class OtherClass: NoirClass
local OtherClass = Noir.Class("OtherClass")
function OtherClass:Init() end

local success, err = pcall(function()
    Noir.TypeChecking:Assert("test", "value", instance, OtherClass)
end)
assert(not success, "Assert should have errored for class type mismatch")

-- AssertMany: valid
Noir.TypeChecking:AssertMany("test", "values", {"hello", "world"}, "string")

-- AssertMany: invalid should error
local success, err = pcall(function()
    Noir.TypeChecking:AssertMany("test", "values", {"hello", 42}, "string")
end)
assert(not success, "AssertMany should have errored for invalid type in values")

-- AssertMany: empty table
Noir.TypeChecking:AssertMany("test", "values", {}, "string")

-- AssertMany: nil values allowed
Noir.TypeChecking:AssertMany("test", "values", {nil, "hello"}, "string", "nil")

-- _FormatTypes: basic formatting
local formatted = Noir.TypeChecking:_FormatTypes({"string", "number"})
assert(formatted == "'string' or 'number'", "Expected ''string' or 'number'', got: " .. formatted)

-- _FormatTypes: single type
local formatted = Noir.TypeChecking:_FormatTypes({"string"})
assert(formatted == "'string'", "Expected ''string'', got: " .. formatted)

-- _FormatTypes: three types
local formatted = Noir.TypeChecking:_FormatTypes({"string", "number", "boolean"})
assert(formatted == "'string', 'number' or 'boolean'", "Expected ''string', 'number' or 'boolean'', got: " .. formatted)