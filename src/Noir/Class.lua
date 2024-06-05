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
    Create a class that objects can be created from.<br>
    Note that classes can inherit from other classes.

    local MyClass = Noir.Class:Create("MyClass")

    function MyClass:Init(name) -- This is called when MyClass:New() is called
        self.name = name
    end

    function MyClass:myName()
        print(self.name)
    end

    local object = MyClass:New("Cuh4")
    object:myName() -- "Cuh4"
]]
---@param name string
---@param parent NoirClass|nil
function Noir.Class(name, parent)
    --[[
        A class that objects can be created from.

        local MyClass = Class:Create("MyClass")

        function MyClass:Init(name) -- This is called when MyClass.new() is called
            self.something = true
        end

        local object = MyClass:new("Cuh4")
        print(object.something) -- true
    ]]
    ---@class NoirClass
    ---@field ClassName string The name of this class/object
    ---@field _Parent NoirClass|nil The parent class that this class inherits from
    ---@field _IsObject boolean
    ---@field Init fun(self: NoirClass, ...) A function that initializes objects created from this class
    local class = {} ---@diagnostic disable-line
    class.ClassName = name
    class._Parent = parent
    class._IsObject = false

    function class:New(...)
        -- Create Object
        ---@type NoirClass
        local object = {} ---@diagnostic disable-line
        self:_Descend(object, {New = true, Init = true, _Descend = true})

        object._IsObject = true

        -- Call init of object. This init function will provide the needed attributes to the object
        if self.Init then
            self.Init(object, ...)
        else
            Noir.Libraries.Logging:Error("Class", "'%s' is missing an :Init() method. This method is required for classes. See the documentation for info.", true, self.ClassName)
        end

        -- Return the object
        return object
    end

    --[[
        Copies attributes and methods from one object to another.<br>
        Used internally. Do not use in your code.
    ]]
    ---@param from NoirClass
    ---@param object NoirClass
    ---@param exceptions table<integer, string>
    function class._Descend(from, object, exceptions)
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
    function class:InitializeParent(...)
        -- Check if this was called from an object
        if not self.IsSameType then
            Noir.Libraries.Logging:Error(self.ClassName, "Attempted to call :InitializeParent() when 'self' is a class and not an object.", true)
            return
        end

        -- Check if there is a parent
        if not self._IsObject then
            Noir.Libraries.Logging:Error(self.ClassName, "Attempted to call :InitializeParent() when 'self' has no parent.", true)
            return
        end

        -- Create an object from the parent class
        local object = self._Parent:New(...)

        -- Copy and bring new attributes and methods down from the new parent object to this object
        self._Descend(object, self, {New = true, Init = true, _Descend = true})
    end

    --[[
        Returns if a class/object is the same type as another.
    ]]
    ---@param other NoirClass
    ---@return boolean
    function class:IsSameType(other)
        return other.ClassName ~= nil and self.ClassName == other.ClassName
    end

    return class
end