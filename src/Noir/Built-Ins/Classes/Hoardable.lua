--------------------------------------------------------
-- [Noir] Classes - Hoardable
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
    A class that hoardable classes should inherit from to be able to be used with the `Noir.Services.HoarderService`.<br>
    Check out the aforementioned service for more info.<br>
    Example:

    -- A class representing Fruit.
    ---@class Fruit: NoirHoardable
    ---@field New fun(self: Fruit, name: string, value: number): Fruit
    Fruit = Noir.Class(
        "Fruit",
        Noir.Classes.Hoardable
    )

    -- Initializes Fruit instances.
    ---@param name string
    ---@param value integer
    function Fruit:Init(name, value)
        self:InitFrom(
            Noir.Classes.Hoardable,
            name -- the Hoardable ID
        )

        -- The name of the fruit
        self.Name = name

        -- The value of the fruit
        self.Value = value
    end
]]
---@class NoirHoardable: NoirClass
---@field New fun(self: NoirHoardable, ID: any): NoirHoardable
---@field _HoardableID any The ID of this class instance (optional. used as key in tables. omitting will just append to the end of the table)
Noir.Classes.Hoardable = Noir.Class("Hoardable")

--[[
    Initializes `Hoardable` class instances.
]]
---@param ID any
function Noir.Classes.Hoardable:Init(ID)
    self._HoardableID = ID
end

--[[
    Returns the ID of this class instance.
]]
---@return any|nil
function Noir.Classes.Hoardable:GetHoardableID()
    return self._HoardableID
end

--[[
    Returns the provided table but stripped of non-serializable values.
]]
---@param tbl table
---@return table
function Noir.Classes.Hoardable:_Strip(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:_Strip()", "tbl", tbl, "table")

    -- Strip the table
    local stripped = {}

    for key, value in pairs(tbl) do
        if type(value) == "function" then
            goto continue
        end

        if type(value) == "table" then
            stripped[key] = self:_Strip(value)
        else
            stripped[key] = value
        end

        ::continue::
    end

    -- Return the stripped table
    return stripped
end

--[[
    Serializes this class instance.
]]
---@return table
function Noir.Classes.Hoardable:Serialize()
    local serialized = {}

    ---@param key string
    ---@param value NoirHoardable|any
    for key, value in pairs(self) do
        if type(value) == "function" then
            goto continue
        end

        if Noir.IsClass(value) then
            error("Noir.Classes.Hoardable:Serialize()", "A class instance (%s) is stored within this class and cannot be serialized. Consider inheritance over composition when using `HoardService`.", value.ClassName)
        elseif type(value) == "table" then
            serialized[key] = self:_Strip(value)
        else
            serialized[key] = value
        end

        ::continue::
    end

    return serialized
end

--[[
    Hoards this instance.
]]
---@param service NoirService
---@param tblName string
function Noir.Classes.Hoardable:Hoard(service, tblName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Hoard()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Hoard()", "tblName", tblName, "string")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Classes.Hoardable:Hoard()", "`service` argument must be a `NoirService` class instance.")
    end

    -- Hoard
    Noir.Services.HoarderService:Hoard(service, tblName, self)
end

--[[
    Unhoards this instance.
]]
---@param service NoirService
---@param tblName string
function Noir.Classes.Hoardable:Unhoard(service, tblName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Unhoard()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Unhoard()", "tblName", tblName, "string")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Classes.Hoardable:Unhoard()", "`service` argument must be a `NoirService` class instance.")
    end

    -- Unhoard
    Noir.Services.HoarderService:Unhoard(service, tblName, self)
end