--------------------------------------------------------
-- [Noir] Classes - Library
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
    Represents a library.
]]
---@class NoirLibrary: NoirClass
---@field New fun(self: NoirLibrary, name: string, shortDescription: string, longDescription: string, authors: table<integer, string>): NoirLibrary
---@field Name string
---@field ShortDescription string
---@field LongDescription string
---@field Authors table<integer, string>
Noir.Classes.LibraryClass = Noir.Class("NoirLibrary")

--[[
    Initializes library class objects.
]]
---@param name string
---@param shortDescription string
---@param longDescription string
---@param authors table<integer, string>
function Noir.Classes.LibraryClass:Init(name, shortDescription, longDescription, authors)
    Noir.TypeChecking:Assert("Noir.Classes.LibraryClass:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.LibraryClass:Init()", "shortDescription", shortDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.LibraryClass:Init()", "longDescription", longDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.LibraryClass:Init()", "authors", authors, "table")

    self.Name = name
    self.ShortDescription = shortDescription
    self.LongDescription = longDescription
    self.Authors = authors
end