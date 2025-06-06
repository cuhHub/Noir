--------------------------------------------------------
-- [Noir] Classes - Library
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
    Represents a library.
]]
---@class NoirLibrary: NoirClass
---@field New fun(self: NoirLibrary, name: string, shortDescription: string, longDescription: string, authors: table<integer, string>): NoirLibrary
---@field Name string The name of the library
---@field ShortDescription string The short description of the library
---@field LongDescription string The long description of the library
---@field Authors table<integer, string> The authors of the library
Noir.Classes.Library = Noir.Class("Library")

--[[
    Initializes library class objects.
]]
---@param name string
---@param shortDescription string
---@param longDescription string
---@param authors table<integer, string>
function Noir.Classes.Library:Init(name, shortDescription, longDescription, authors)
    Noir.TypeChecking:Assert("Noir.Classes.Library:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Library:Init()", "shortDescription", shortDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Library:Init()", "longDescription", longDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Library:Init()", "authors", authors, "table")

    self.Name = name
    self.ShortDescription = shortDescription
    self.LongDescription = longDescription
    self.Authors = authors
end