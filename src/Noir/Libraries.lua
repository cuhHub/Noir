--------------------------------------------------------
-- [Noir] Libraries
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
    A module of Noir that allows you to create your own libraries to use throughout your code.

    MyLibrary = Noir.Libraries:Create("MyLibrary")

    function MyLibrary:add(num1, num2)
        return num1 + num2
    end
]]
Noir.Libraries = {}

--[[
    Returns a library starter pack for you to use when creating libraries for your addon.

    MyLibrary = Noir.Libraries:Create("MyLibrary")

    function MyLibrary:add(num1, num2)
        return num1 + num2
    end
]]
---@param name string
---@param shortDescription string|nil
---@param longDescription string|nil
---@param authors table<integer, string>|nil
---@return NoirLibrary
function Noir.Libraries:Create(name, shortDescription, longDescription, authors)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries:Create()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Libraries:Create()", "shortDescription", shortDescription, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries:Create()", "longDescription", longDescription, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries:Create()", "authors", authors, "table", "nil")

    -- Create library
    local library = Noir.Classes.LibraryClass:New(name, shortDescription or "N/A", longDescription or "N/A", authors or {})

    -- Return library
    return library
end