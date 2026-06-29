--------------------------------------------------------
-- [Noir] Tests - Deprecation Library
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

-- Deprecated: basic usage (no replacement, no note)
Noir.Libraries.Deprecation:Deprecated("OldFunction")

-- Deprecated: with replacement
Noir.Libraries.Deprecation:Deprecated("OldFunction", "NewFunction")

-- Deprecated: with replacement and note
Noir.Libraries.Deprecation:Deprecated("OldFunction", "NewFunction", "This function will be removed in v2.0")

-- Deprecated: with note only (no replacement)
Noir.Libraries.Deprecation:Deprecated("OldFunction", nil, "This function will be removed in v2.0")

-- Deprecated: type checking should error for invalid name
local success, err = pcall(function()
    Noir.Libraries.Deprecation:Deprecated(123) ---@diagnostic disable-line
end)
assert(not success, "Deprecated should have errored for non-string name")

-- Deprecated: type checking should error for invalid replacement
local success, err = pcall(function()
    Noir.Libraries.Deprecation:Deprecated("OldFunction", 123) ---@diagnostic disable-line
end)
assert(not success, "Deprecated should have errored for non-string replacement")

-- Deprecated: type checking should error for invalid note
local success, err = pcall(function()
    Noir.Libraries.Deprecation:Deprecated("OldFunction", nil, 123) ---@diagnostic disable-line
end)
assert(not success, "Deprecated should have errored for non-string note")