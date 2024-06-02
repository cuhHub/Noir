--------------------------------------------------------
-- [Noir] Libraries - Class
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
    A library that allows you to define classes which you can create objects from.<br>
    Note that classes can inherit from other classes.<br>
    Adapted from [this repo.](https://github.com/Cuh4/LuaClasses)

    local MyClass = Class:Create("MyClass")

    function MyClass:init(name) -- This is called when MyClass.new() is called
        self.name = name
    end

    function MyClass:myName()
        print(self.name)
    end

    local object = MyClass.new("Cuh4")
    object:myName() -- "Cuh4"
]]
Noir.Libraries.Class = Noir.Libraries:Create("NoirClass")

--[[
    Create a class that objects can be created from.<br>
    Note that classes can inherit from other classes.

    local MyClass = Class:Create("MyClass")

    function MyClass:init(name) -- This is called when MyClass.new() is called
        self.name = name
    end

    function MyClass:myName()
        print(self.name)
    end

    local object = MyClass.new("Cuh4")
    object:myName() -- "Cuh4"
]]
---@param name string
---@param parent NoirClass|nil
function Noir.Libraries.Class:Create(name, parent)
    -- Create a class
    ---@type NoirClass
    local class = {} ---@diagnostic disable-line
    class.__Name = name
    class.__Parent = parent
    class.__IsObject = false

    function class:New(...)
        -- create Object
        ---@type NoirClass
        local object = {} ---@diagnostic disable-line
        self:__Descend(object, {New = true, Init = true, __Descend = true})

        object.__IsObject = true

        -- Call init of object. This init function will provide the needed attributes to the object
        if self.Init then
            self.Init(object, ...)
        end

        -- Return the object
        return object
    end

    function class.__Descend(from, object, exceptions)
        for index, value in pairs(from) do
            if exceptions[index] then
                goto continue
            end

            if object[index] then
                goto continue
            end

            object[index] = value

            ::continue::
        end
    end

    function class:InitializeParent(...)
        -- Check if this was called from an object
        if not self.IsSameType then
            Noir.Libraries.Logging:Error(self.__Name, "Attempted to call :InitializeParent() when 'self' is a class and not an object.")
            return
        end

        -- Check if there is a parent
        if not self.__IsObject then
            Noir.Libraries.Logging:Error(self.__Name, "Attempted to call :InitializeParent() when 'self' has no parent.")
            return
        end

        -- Create an object from the parent class
        local object = self.__Parent:New(...)

        -- Copy and bring new attributes and methods down from the new parent object to this object
        self.__Descend(object, self, {New = true, Init = true, __Descend = true})
    end

    function class:IsSameType(other)
        return other.__Name ~= nil and self.__Name == other.__Name
    end

    return class
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirClass
---@field __Name string The name of this class/object
---@field __Parent NoirClass|nil The parent class that this class inherits from
---@field __IsObject boolean
---@field Init fun(self: NoirClass, ...) A function that initializes objects created from this class
---
---@field New fun(self: NoirClass, ...: any): NoirClass A method to create an object from this class
---@field __Descend fun(from: NoirClass, object: NoirClass, exceptions: table<any, boolean>) A helper function that copies important values from the class to an object
---@field IsSameType fun(self: NoirClass, other: NoirClass): boolean A method that returns whether an object is identical to this one
---@field InitializeParent fun(self: NoirClass, ...: any) A method that initializes the parent class for this object