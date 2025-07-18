--------------------------------------------------------
-- [Noir] Class
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
    Create a class that objects can be created from.<br>
    Note that classes can inherit from other classes.

    local MyClass = Noir.Class("MyClass")

    function MyClass:Init(name) -- This is called when MyClass:New() is called
        self.name = name
    end

    function MyClass:MyName()
        print(self.name)
    end

    local object = MyClass:New("Cuh4")
    object:MyName() -- "Cuh4"
]]
---@param name string
---@param ... NoirClass
---@return NoirClass
function Noir.Class(name, ...)
    --[[
        A class that objects can be created from.

        local MyClass = Noir.Class("MyClass")

        function MyClass:Init(name) -- This is called when MyClass:New() is called
            self.something = true
        end

        local object = MyClass:New("Cuh4")
        print(object.something) -- true
    ]]
    ---@class NoirClass
    ---@field ClassName string The name of this class/object
    ---@field _Parents table<integer, NoirClass> The parent classes that this class inherits from
    ---@field _IsObject boolean Represents whether or not this is a class or a class object (an object created from a class due to class:New() call)
    ---@field _ClassMethods table<string, boolean> A list of methods that are only available on classes and not objects created from classes. Used for :_Descend() exceptions internally
    ---@field Init fun(self: NoirClass, ...) A function that initializes objects created from this class
    local class = {} ---@diagnostic disable-line
    class.ClassName = name
    class._Parents = {...}
    class._IsObject = false
    class._ClassMethods = {
        ["New"] = true,
        ["Init"] = true
    }

    function class:New(...)
        -- Create class object
        ---@type NoirClass
        local object = {} ---@diagnostic disable-line
        self:_SetupObject(object)

        -- Call init of object. This init function will provide the needed attributes to the object
        if self.Init then
            self.Init(object, ...)
        else
            error("Class", "'%s' is missing an :Init() method. This method is required for classes. See the documentation for info.", self.ClassName)
        end

        -- Return the object
        return object
    end

    --[[
        Brings down all methods from the provided parent class into the provided object
        and recursively calls this method on the parents of the provided parent until there are
        no parents left.<br>
        Used internally. Do not use in your code.
    ]]
    ---@param object NoirClass
    ---@param parent NoirClass
    function class:_DescendFromParent(object, parent)
        parent:_Descend(object, self._ClassMethods)

        for _, _parent in pairs(parent._Parents) do
            self:_DescendFromParent(object, _parent)
        end
    end

    --[[
        Sets up a new class object. Used in `:New(...)`.<br>
        Used internally. Do not use in your code.
    ]]
    ---@param object NoirClass
    function class:_SetupObject(object)
        -- can't do typechecking here because of circular dependency :-(

        -- Check if this was called from an object
        if self._IsObject then
            error("Class", "Attempted to call :_SetupObject() when 'self' is a class object, not a class")
        end

        -- Setup object
        object._IsObject = true
        self:_Descend(object, self._ClassMethods)

        -- Bring down methods from parent
        self:_DescendFromParent(object, self)
    end

    --[[
        Copies attributes and methods from one object to another.<br>
        Used internally. Do not use in your code.
    ]]
    ---@param from NoirClass
    ---@param object NoirClass|table
    ---@param exceptions table<string, boolean>
    function class._Descend(from, object, exceptions)
        -- Type checking
        Noir.TypeChecking:Assert("Noir.Class()._Descend()", "from", from, "class")
        Noir.TypeChecking:Assert("Noir.Class()._Descend()", "object", object, "class", "table")
        Noir.TypeChecking:Assert("Noir.Class()._Descend()", "exceptions", exceptions, "table")

        -- Perform value descending
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

    --[[
        Creates an object from the parent class and copies it to this object.<br>
        Use this in the :Init() method of a class that inherits from a parent class.<br>
        Any args provided will be passed to the :Init()
    ]]
    ---@param parent NoirClass 
    function class:InitFrom(parent, ...)
        -- Type checking
        Noir.TypeChecking:Assert("Noir.Class().InitFrom()", "parent", parent, "class")

        -- Check if this was called from an object
        if not self._IsObject then
            error("Class", "Attempted to call :InitFrom() when 'self' is a class and not an object.")
        end

        -- Create an object from the parent class
        local object = parent:New(...)

        -- Copy and bring new attributes and methods down from the new parent object to this object
        self._Descend(object, self, self._ClassMethods)
    end

    --[[
        Returns if a class/object is the same type as another.<br>
        If `other` is not a class, it will return false.
    ]]
    ---@param other NoirClass
    ---@return boolean
    function class:IsSameType(other)
        -- Check if even class
        if not Noir.IsClass(other) then
            return false
        end

        -- Compare class names
        if self.ClassName == other.ClassName then
            return true
        end

        -- Check parents
        -- `self` as subject
        for _, parent in pairs(other._Parents) do
            if self.ClassName == parent.ClassName then
                return true
            end

            if parent:IsSameType(self) then
                return true
            end
        end

        -- `other` as subject
        for _, parent in pairs(self._Parents) do
            if other.ClassName == parent.ClassName then
                return true
            end

            if parent:IsSameType(other) then
                return true
            end
        end

        return false
    end

    --[[
        Returns if a table is a class or not.
    ]]
    ---@param other any
    ---@return boolean
    function class:IsClass(other)
        return Noir.IsClass(other)
    end

    return class
end

--[[
    Returns if the provided argument is a class or not.
]]
---@param object any
---@return boolean
function Noir.IsClass(object)
    return type(object) == "table" and object.ClassName ~= nil
end