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
    The ID of a hoardable class.
]]
---@alias NoirHoardableID string|number|boolean|nil

--[[
    A class that hoardable classes should inherit from to be able to be used with the `Noir.Services.HoarderService`.<br>
    Check out the aforementioned service for more info.<br>
    Example:

    ItemInfo = Noir.Class(
        "ItemInfo",
        Noir.Classes.Hoardable
    )

    function ItemInfo:Init()
        self:InitFrom(Noir.Classes.Hoardable)

        self.MadeBy = "Cuh4"
        self.Foo = 1

        self.Bar = Noir.Libraries.Events:Create()
    end

    function ItemInfo:ToString()
        return string.format("ItemInfo: %s", self.MadeBy)
    end

    function ItemInfo:OnPreSerialize(serialized)
        serialized.Bar = nil -- unneeded but this is just an example to show you can mess with serialization logic
    end

    function ItemInfo:OnPostDeserialize(serialized, lookupClasses)
        self.Bar = Noir.Libraries.Events:Create() -- event functions would be removed during serialization, 
                                                  -- but attributes that "track" the functions (eg: function count) 
                                                  -- would not be reset which could cause problems so we just
                                                  -- completely overwrite the event with a fresh one
    end

    Fruit = Noir.Class(
        "Fruit",
        Noir.Classes.Hoardable
    )

    function Fruit:Init(name, value)
        self:InitFrom(
            Noir.Classes.Hoardable,
            name -- the Hoardable ID
        )

        self.Name = name
        self.Value = value
        self.ItemInfo = ItemInfo:New()
        self.Functions = {
            iShouldGetDiscarded = function() end -- functions not of a class cannot be serialized, so this will automatically be removed during serialization
        }
    end
]]
---@class NoirHoardable: NoirClass
---@field New fun(self: NoirHoardable, ID: NoirHoardableID): NoirHoardable
---@field _HoardableID NoirHoardableID The ID of this class instance (optional. used as key in tables. omitting will just append to the end of the table)
Noir.Classes.Hoardable = Noir.Class("Hoardable")

--[[
    Initializes `Hoardable` class instances.
]]
---@param ID NoirHoardableID
function Noir.Classes.Hoardable:Init(ID)
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Init()", "ID", ID, "string", "number", "boolean", "nil")
    self._HoardableID = ID
end

--[[
    Returns the ID of this class instance.
]]
---@return NoirHoardableID
function Noir.Classes.Hoardable:GetHoardableID()
    return self._HoardableID
end

--[[
    Returns if this class instance has a hoardable ID.
]]
---@return boolean
function Noir.Classes.Hoardable:HasHoardableID()
    return self:GetHoardableID() ~= nil
end

--[[
    Hoards this instance.
]]
---@param service NoirService
---@param tblName string
function Noir.Classes.Hoardable:Hoard(service, tblName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Hoard()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Hoard()", "tblName", tblName, "string")

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
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Unhoard()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Classes.Hoardable:Unhoard()", "tblName", tblName, "string")

    -- Unhoard
    Noir.Services.HoarderService:Unhoard(service, tblName, self)
end

--[[
    Called before serialization.<br>
    You can use this to replace unserializable values like cyclic tables with something else.<br>
    These can then be converted back via `OnDeserialize`.<br>
    `self` is the class instance being serialized.<br>
    This is an `abstractmethod` and should be overridden in subclasses (optional).
]]
function Noir.Classes.Hoardable:OnPreSerialize() end

--[[
    Called after serialization.<br>
    `self` is the class instance being serialized.<br>
    `serialized` is the now serialized data of the class instance.<br>
    This is an `abstractmethod` and should be overridden in subclasses (optional).
]]
---@param serialized table
function Noir.Classes.Hoardable:OnPostSerialize(serialized) end

--[[
    Called before deserialization.<br>
    Can be used to replace serialized values with something else, e.g. converting older data to newer data.<br>
    `self` is the class instance being deserialized.<br>
    `serialized` is the serialized data of the class instance.<br>
    `lookupClasses` is a table of classes that can be used to deserialize the class instance.<br>
    This is an `abstractmethod` and should be overridden in subclasses (optional).
]]
---@param serialized table
---@param lookupClasses table<string, NoirClass>
function Noir.Classes.Hoardable:OnPreDeserialize(serialized, lookupClasses) end

--[[
    Called after deserialization.<br>
    `self` is the deserialized class instance.<br>
    `serialized` is the serialized data of the class instance.<br>
    `lookupClasses` is a table of classes that can be used to deserialize the class instance.<br>
    This is a useful place to apply corrections if the `HoarderService` didn't deserialize the class instance to your expectation.<br>
    This is an `abstractmethod` and should be overridden in subclasses (optional).
]]
---@param serialized table
---@param lookupClasses table<string, NoirClass>
function Noir.Classes.Hoardable:OnPostDeserialize(serialized, lookupClasses) end