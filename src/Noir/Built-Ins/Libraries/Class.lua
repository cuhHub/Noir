--------------------------------------------------------
-- [Noir] Class
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
    class.__name = name
    class.__parent = parent
    class.isObject = false

    function class:New(...)
        -- create Object
        ---@type NoirClassObject
        local object = {} ---@diagnostic disable-line
        self:__descend(object, {New = true, Init = true, __descend = true})

        object.isObject = true

        -- Call init of object. This init function will provide the needed attributes to the object
        if self.Init then
            self.Init(object, ...)
        end

        -- Return the object
        return object
    end

    function class.__descend(from, object, exceptions)
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
        if not self.isObject then
            Noir.Libraries.Logging:Error(self.__name, "Attempted to call :InitializeParent() when 'self' is a class and not an object.")
            return
        end

        -- Check if there is a parent
        if not self.__parent then
            Noir.Libraries.Logging:Error(self.__name, "Attempted to call :InitializeParent() when 'self' has no parent.")
            return
        end

        -- Create an object from the parent class
        local object = self.__parent:New(...)

        -- Copy and bring new attributes and methods down from the new parent object to this object
        self.__descend(object, self, {New = true, Init = true, __descend = true})
    end

    function class:IsSameType(other)
        return other.__name ~= nil and self.__name == other.__name
    end

    return class
end

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirClass
---@field __name string The name of this class
---@field __parent NoirClass|nil The parent class that this class inherits from
---@field isObject false
---@field Init fun(self: NoirClassObject, ...) A function that initializes objects created from this class
---
---@field New fun(self: NoirClass, ...: any): NoirClassObject A method to create an object from this class
---@field __descend fun(from: NoirClass|NoirClassObject, object: NoirClassObject, exceptions: table<any, boolean>) A helper function that copies important values from the class to an object
---@field IsSameType fun(self: NoirClass, other: NoirClass|NoirClassObject): boolean A method that returns whether an object is identical to this one

---@class NoirClassObject An object created from a class
---@field isObject true
---@field __name string The name of the class that created this object
---@field __parent NoirClass|nil The parent class that this object inherits from
---@field InitializeParent fun(self: NoirClassObject, ...: any) A method that initializes the parent class for this object
---@field IsSameType fun(self: NoirClassObject, object: NoirClassObject): boolean A method that returns whether an object is identical to this one