--------------------------------------------------------
-- [Noir] Libraries - Deprecation
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
    A library that allows you to mark functions as deprecated.

    ---@deprecated <-- intellisense. recommended to add
    function HelloWorld()
        Noir.Libraries.Deprecation:Deprecated("HelloWorld", "AnOptionalReplacementFunction", "An optional note appended to the deprecation message")
        print("Hello World")
    end
]]
---@class NoirDeprecationLib: NoirLibrary
Noir.Libraries.Deprecation = Noir.Libraries:Create(
    "DeprecationLibrary",
    "A library that allows you to mark functions as deprecated.",
    "A library that allows you to mark functions as deprecated. No function wrapping is used.",
    {"Cuh4"}
)

--[[
    Mark a function as deprecated.
    
    ---@deprecated <-- intellisense. recommended to add
    function HelloWorld()
        Noir.Libraries.Deprecation:Deprecated("HelloWorld", "AnOptionalReplacementFunction", "An optional note appended to the deprecation message")
        print("Hello World")
    end
]]
---@param name string
---@param replacement string|nil
---@param note string|nil
function Noir.Libraries.Deprecation:Deprecated(name, replacement, note)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Deprecation:Deprecated()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Deprecation:Deprecated()", "replacement", replacement, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Deprecation:Deprecated()", "note", note, "string", "nil")

    -- Setup message
    local _replacement = ""

    if replacement then
        use = (" Please use '%s' instead.")
    end

    local _note = ""

    if note then
        note = "\n"..note
    end

    -- Send message
    Noir.Libraries.Logging:Warning("Deprecated", "'%s' is deprecated.".._replacement.._note, name)
end