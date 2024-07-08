----------------------------------------------
-- // [File] ..\src\Noir\Definition.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Definition
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
    Noir Framework @ https://github.com/cuhHub/Noir<br>
    A framework for making Stormworks addons with ease.
]]
Noir = {}

g_savedata = { ---@diagnostic disable-line: lowercase-global
    Noir = {
        Services = {}
    }
}

----------------------------------------------
-- // [File] ..\src\Noir\Class.lua
----------------------------------------------
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
---@return NoirClass
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
    ---@field _IsObject boolean Represents whether or not this is a class (objects are created from a class via class:New()) or a class object (an object created from a class due to class:New() call)
    ---@field Init fun(self: NoirClass, ...) A function that initializes objects created from this class
    local class = {} ---@diagnostic disable-line
    class.ClassName = name
    class._Parent = parent
    class._IsObject = false

    function class:New(...)
        -- Create class object
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
    ---@param object NoirClass|table
    ---@param exceptions table<integer, string>
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
        Returns if a class/object is the same type as another.<br>
        If 'other' is not a class, it will return false.
    ]]
    ---@param other NoirClass|any
    ---@return boolean
    function class:IsSameType(other)
        return self:IsClass(other) and self.ClassName == other.ClassName
    end

    --[[
        Returns if a table is a class or not.
    ]]
    ---@param other NoirClass|any
    ---@return boolean
    function class:IsClass(other)
        return type(other) == "table" and other.ClassName ~= nil
    end

    return class
end

----------------------------------------------
-- // [File] ..\src\Noir\TypeChecking.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Type Checking
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
    A module of Noir for checking if a value is of the correct type.<br>
    This normally would be a library, but libraries need to use this and libraries are meant to be independent of each other.
]]
Noir.TypeChecking = {}

--[[
    Raises an error if the value is not any of the provided types.<br>
    This has basic support for classes. It will check if the provided value is a Noir class if needed, but it will not check if it's the right class.
]]
---@param origin string The location of the thing (method, function, etc) that called this so the user can find out where something went wrong
---@param parameterName string The name of the parameter that is being type checked
---@param value any
---@param ... NoirTypeCheckingType
function Noir.TypeChecking:Assert(origin, parameterName, value, ...)
    -- Type checking can't be performed here otherwise we get a stack overflow :-( TODO: very small priority but might want to get this sorted in the future

    -- Pack types into a table
    local types = {...}

    -- Get value type
    local valueType = type(value)

    -- Check if the value is of the correct type
    local isClassWhileCheckTable = false -- sorry for the horrendous variable name. this is here so the error doesn't say "expected 'table' but got 'table'"

    for _, typeToCheck in pairs(types) do
        if not isClassWhileCheckTable then
            isClassWhileCheckTable = typeToCheck == "table" and self._DummyClass:IsClass(value)
        end

        -- Value == ExactType
        if (valueType == typeToCheck) and not isClassWhileCheckTable then
            return
        end

        -- Value == AnyClass
        if typeToCheck == "class" and self._DummyClass:IsClass(value) then
            return
        end

        -- Value == ExactClass
        if self._DummyClass:IsClass(typeToCheck) and typeToCheck:IsSameType(value) then ---@diagnostic disable-line
            return
        end
    end

    -- Otherwise, raise an error
    Noir.Libraries.Logging:Error(
        "Invalid Type",
        "%s: Expected %s for parameter '%s', but got '%s'.",
        true,
        origin,
        self:FormatTypes(types),
        parameterName,
        self._DummyClass:IsClass(value) and value.ClassName or (isClassWhileCheckTable and "class" or valueType)
    )
end

--[[
    Raises an error if any of the provided values are not any of the provided types.
]]
---@param origin string The location of the thing (method, function, etc) that called this so the user can find out where something went wrong
---@param parameterName string The name of the parameter that is being type checked
---@param values table<integer, any>
---@param ... NoirTypeCheckingType
function Noir.TypeChecking:AssertMany(origin, parameterName, values, ...)
    -- Perform type checking on the provided parameters
    self:Assert("Noir.TypeChecking:AssertMany()", "origin", origin, "string")
    self:Assert("Noir.TypeChecking:AssertMany()", "parameterName", parameterName, "string")
    self:Assert("Noir.TypeChecking:AssertMany()", "values", values, "table")
    self:AssertMany("Noir.TypeChecking:AssertMany()", "...", {...}, "string", "class")

    -- Perform type checking for provided values
    for _, value in pairs(values) do
        self:Assert(origin, parameterName, value, ...)
    end
end

--[[
    Format required types for an error message.<br>
    Used internally.
]]
---@param types table<integer, NoirTypeCheckingType>
---@return string
function Noir.TypeChecking:FormatTypes(types)
    -- Perform type checking
    self:Assert("Noir.TypeChecking:FormatTypes()", "types", types, "table")

    -- Format types
    local formatted = ""

    for index, typeToFormat in pairs(types) do
        if self._DummyClass:IsClass(typeToFormat) then
            typeToFormat = typeToFormat.ClassName
        end

        local formattedType = ("'%s'%s"):format(typeToFormat, index ~= #types and (index == #types - 1 and " or " or ", ") or "")
        formatted = formatted..formattedType
    end

    return formatted
end

--[[
    A dummy class for checking if a value is a class or not.<br>
    Used internally.
]]
Noir.TypeChecking._DummyClass = Noir.Class("NoirTypeCheckingDummyClass")

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirTypeCheckingType
---| "string"
---| "number"
---| "boolean"
---| "nil"
---| "table"
---| "function"
---| "class"
---| NoirClass

----------------------------------------------
-- // [File] ..\src\Noir\Classes.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes
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
    A table containing classes used throughout Noir.<br>
    This is a good place to store your classes.
]]
Noir.Classes = {}

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Connection.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Connection
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
    Represents a connection to an event.
]]
---@class NoirConnection: NoirClass
---@field New fun(self: NoirConnection, callback: function): NoirConnection
---@field ID integer The ID of this connection
---@field Callback function The callback that is assigned to this connection
---@field ParentEvent NoirEvent The event that this connection is connected to
---@field Connected boolean Whether or not this connection is connected
---@field Index integer The index of this connection in ParentEvent.ConnectionsOrder
Noir.Classes.ConnectionClass = Noir.Class("NoirConnection")

--[[
    Initializes new connection class objects.
]]
---@param callback function
function Noir.Classes.ConnectionClass:Init(callback)
    Noir.TypeChecking:Assert("Noir.Classes.ConnectionClass:Init()", "callback", callback, "function")

    self.Callback = callback
    self.ParentEvent = nil
    self.ID = nil
    self.Connected = false
    self.Index = -1
end

--[[
    Triggers the callback's stored function.
]]
---@param ... any
function Noir.Classes.ConnectionClass:Fire(...)
    if not self.Connected then
        Noir.Libraries.Logging:Error("NoirConnection", "Attempted to fire an event connection when it is not connected.", true)
        return
    end

    self.Callback(...)
end

--[[
    Disconnects the callback from the event.
]]
function Noir.Classes.ConnectionClass:Disconnect()
    if not self.Connected then
        Noir.Libraries.Logging:Error("NoirConnection", "Attempted to disconnect an event connection when it is not connected.", true)
        return
    end

    self.ParentEvent:Disconnect(self)
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Event.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Event
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
    Represents an event.
]]
---@class NoirEvent: NoirClass
---@field New fun(self: NoirEvent): NoirEvent
---@field CurrentID integer The ID that will be passed to new connections. Increments by 1 every connection
---@field Connections table<integer, NoirConnection> The connections that are connected to this event
---@field ConnectionsOrder integer[] Array of connection IDs into Connections table
---@field ConnectionsToRemove NoirConnection[]? Array of connections to remove after the firing of the event
---@field ConnectionsToAdd NoirConnection[]? Array of connections to add after the firing of the event
---@field IsFiring boolean Weather or not this event is currently calling connection callbacks
---@field HasFiredOnce boolean Whether or not this event has fired atleast once
Noir.Classes.EventClass = Noir.Class("NoirEvent")

--[[
    Initializes event class objects.
]]
function Noir.Classes.EventClass:Init()
    self.CurrentID = 0
    self.Connections = {}
    self.ConnectionsOrder = {}
    self.ConnectionsToRemove = {}  -- Only used when IsFiring is true, should remain empty otherwise.
    self.ConnectionsToAdd = {}  -- Only used when IsFiring is true, should remain empty otherwise.
    self.IsFiring = false
    self.HasFiredOnce = false
end

--[[
    Fires the event, passing any provided arguments to the connections.

    local event = Noir.Libraries.Events:Create()
    event:Fire()
]]
function Noir.Classes.EventClass:Fire(...)
    -- Fire the event connections
    self.IsFiring = true

    for _, connection_id in ipairs(self.ConnectionsOrder) do
        self.Connections[connection_id]:Fire(...)
    end

    self.IsFiring = false

    -- Reverse iteration is more performant, as we are book-keeping stuff we already plan to remove
    for index = #self.ConnectionsToRemove, 1, -1 do
        self:_DisconnectImmediate(self.ConnectionsToRemove[index])
        self.ConnectionsToRemove[index] = nil
    end

    -- Add connections which were connected during iteration, so they get called next time
    for index = 1, #self.ConnectionsToAdd do
        self:_ConnectFinalize(self.ConnectionsToAdd[index])
        self.ConnectionsToAdd[index] = nil
    end

    self.HasFiredOnce = true
end

--[[
    Connects a function to the event. A connection is automatically made for the function.<br>
    If connecting to an event that is currently being handled, it will be added afterwards and run the next time the event is fired.

    local event = Noir.Libraries.Events:Create()

    local connection = event:Connect(function()
        print("Fired")
    end)

    connection:Disconnect() -- Disconnects the callback from the event
]]
---@param callback function
---@return NoirConnection
function Noir.Classes.EventClass:Connect(callback)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.EventClass:Connect()", "callback", callback, "function")

    -- Increment ID
    self.CurrentID = self.CurrentID + 1

    -- Create connection object
    local connection = Noir.Classes.ConnectionClass:New(callback)
    self.Connections[self.CurrentID] = connection

    -- Set up the connection for later
    connection.ParentEvent = self
    connection.ID = self.CurrentID
    connection.Index = -1
    connection.Connected = false

    -- If we are currently iterating over the events, finalize it later, otherwise do it now
    if self.IsFiring then
        table.insert(self.ConnectionsToAdd, connection)
    else
        self:_ConnectFinalize(connection)
    end

    -- Return the connection
    return connection
end

--[[
    Finalizes the connection to the event, allowing it to be run.<br>
    Used internally.
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:_ConnectFinalize(connection)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.EventClass:_ConnectFinalize()", "connection", connection, Noir.Classes.ConnectionClass)

    -- Insert into ConnectionsOrder
    table.insert(self.ConnectionsOrder, connection.ID)

    -- Set up connection
    connection.Index = #self.ConnectionsOrder
    connection.Connected = true
end

--[[
    Connects a callback to the event that will automatically be disconnected upon the event being fired.<br>
    If connecting to an event that is currently being handled, it will be added afterwards and run the next time the event is fired.  
]]
---@param callback function
---@return NoirConnection
function Noir.Classes.EventClass:Once(callback)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.EventClass:Once()", "callback", callback, "function")

    -- Connect to event
    local connection

    connection = self:Connect(function(...)
        callback(...)
        connection:Disconnect()
    end)

    -- Return the connection
    return connection
end

--[[
    Disconnects the provided connection from the event.<br>
    The disconnection may be delayed if done while handling the event.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:Disconnect(connection)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.EventClass:Disconnect()", "connection", connection, Noir.Classes.ConnectionClass)

    -- If we are currently iterating over the events, disconnect it later, otherwise do it now
    if self.IsFiring then
        table.insert(self.ConnectionsToRemove, connection)
    else
        self:_DisconnectImmediate(connection)
    end
end

--[[
    **Should only be used internally.**<br>
    Disconnects the provided connection from the event immediately.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:_DisconnectImmediate(connection)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.EventClass:_DisconnectImmediate()", "connection", connection, Noir.Classes.ConnectionClass)

    -- Remove the connection
    self.Connections[connection.ID] = nil
    table.remove(self.ConnectionsOrder, connection.Index)

    -- Re-index the connections by shifting down one
    for index = connection.Index, #self.ConnectionsOrder do
        local _connection = self.Connections[self.ConnectionsOrder[index]]
        _connection.Index = _connection.Index - 1
    end

    -- Update connection attributes
    connection.Connected = false
    connection.ParentEvent = nil
    connection.ID = nil
    connection.Index = nil
end


----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Service.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Service
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
    Represents a Noir service.
]]
---@class NoirService: NoirClass
---@field New fun(self: NoirService, name: string, isBuiltIn: boolean, shortDescription: string, longDescription: string, authors: table<integer, string>): NoirService
---@field Name string The name of this service
---@field IsBuiltIn boolean Whether or not this service comes with Noir
---@field Initialized boolean Whether or not this service has been initialized
---@field Started boolean Whether or not this service has been started
---@field InitPriority integer The priority of this service when it is initialized
---@field StartPriority integer The priority of this service when it is started
---@field ShortDescription string A short description of this service
---@field LongDescription string A long description of this service
---@field Authors table<integer, string> The authors of this service
---
---@field ServiceInit fun(self: NoirService) A method that is called when the service is initialized
---@field ServiceStart fun(self: NoirService) A method that is called when the service is started
Noir.Classes.ServiceClass = Noir.Class("NoirService")

--[[
    Initializes service class objects.
]]
---@param name string
---@param isBuiltIn boolean
---@param shortDescription string
---@param longDescription string
---@param authors table<integer, string>
function Noir.Classes.ServiceClass:Init(name, isBuiltIn, shortDescription, longDescription, authors)
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Init()", "isBuiltIn", isBuiltIn, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Init()", "shortDescription", shortDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Init()", "longDescription", longDescription, "string")
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Init()", "authors", authors, "table")

    self.Name = name
    self.IsBuiltIn = isBuiltIn
    self.Initialized = false
    self.Started = false

    self.InitPriority = nil
    self.StartPriority = nil

    self.ShortDescription = shortDescription
    self.LongDescription = longDescription
    self.Authors = authors
end

--[[
    Initialize this service.<br>
    Used internally.
]]
function Noir.Classes.ServiceClass:_Initialize()
    -- Checks
    if self.Initialized then
        Noir.Libraries.Logging:Error("NoirService", "%s: Attempted to initialize this service when it has already initialized.", true, self.Name)
        return
    end

    if self.Started then
        Noir.Libraries.Logging:Error("NoirService", "%s: Attempted to start this service when it has already started.", true, self.Name)
        return
    end

    -- Set initialized
    self.Initialized = true

    -- Call ServiceInit
    if not self.ServiceInit then
        return
    end

    self:ServiceInit()
end

--[[
    Start this service.<br>
    Used internally.
]]
function Noir.Classes.ServiceClass:_Start()
    -- Checks
    if self.Started then
        Noir.Libraries.Logging:Error("NoirService", "%s: Attempted to start this service when it has already started.", true, self.Name)
        return
    end

    if not self.Initialized then
        Noir.Libraries.Logging:Error("NoirService", "%s: Attempted to start this service when it has not initialized yet.", true, self.Name)
        return
    end

    -- Set started
    self.Started = true

    -- Call ServiceStart
    if not self.ServiceStart then
        return
    end

    self:ServiceStart()
end

--[[
    Checks if g_savedata is intact.<br>
    Used internally.
]]
---@return boolean
function Noir.Classes.ServiceClass:_CheckSaveData()
    -- Checks
    if not g_savedata then
        Noir.Libraries.Logging:Error("NoirService", "_CheckSaveData(): g_savedata is nil.", false)
        return false
    end

    if not g_savedata.Noir then
        Noir.Libraries.Logging:Error("NoirService", "._CheckSaveData(): g_savedata.Noir is nil.", false)
        return false
    end

    if not g_savedata.Noir.Services then
        Noir.Libraries.Logging:Error("NoirService", "._CheckSaveData(): g_savedata.Noir.Services is nil.", false)
        return false
    end

    if not g_savedata.Noir.Services[self.Name] then
        Noir.Libraries.Logging:Info("NoirService", "_CheckSaveData(): %s is missing a table in g_savedata.Noir.Services. Creating one.", self.Name)
        g_savedata.Noir.Services[self.Name] = {}
    end

    -- All good!
    return true
end

--[[
    Save a value to g_savedata under this service.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        self:Save("MyKey", "MyValue")
    end
]]
---@param index string
---@param data any
function Noir.Classes.ServiceClass:Save(index, data)
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Save()", "index", index, "string")
    self:GetSaveData()[index] = data
end

--[[
    Load data from g_savedata that was saved via the :Save() method.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        local MyValue = self:Load("MyKey")
    end
]]
---@param index string
---@param default any
---@return any
function Noir.Classes.ServiceClass:Load(index, default)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Load()", "index", index, "string")

    -- Get the value
    local value = self:GetSaveData()[index]

    -- Return the default if it's nil
    if value == nil then
        return default
    end

    -- Return the value
    return value
end

--[[
    Remove data from g_savedata that was saved via the :Save() method.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        MyService:Remove("MyKey")
    end
]]
---@param index string
function Noir.Classes.ServiceClass:Remove(index)
    Noir.TypeChecking:Assert("Noir.Classes.ServiceClass:Remove()", "index", index, "string")
    self:GetSaveData()[index] = nil
end

--[[
    Returns this service's g_savedata table for direct modification.<br>

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        self:GetSaveData().MyKey = "MyValue"
        -- Equivalent to: self:Save("MyKey", "MyValue")
    end
]]
---@return table
function Noir.Classes.ServiceClass:GetSaveData()
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return {}
    end

    -- Return
    return g_savedata.Noir.Services[self.Name]
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Player.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Player
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
    Represents a player.

    player:GetCharacter() -- NoirCharacter
    player:SetPermission("Awesome")
    player:HasPermission("Awesome") -- true
]]
---@class NoirPlayer: NoirClass
---@field New fun(self: NoirPlayer, name: string, ID: integer, steam: string, admin: boolean, auth: boolean, permissions: table<string, boolean>): NoirPlayer
---@field Name string The name of this player
---@field ID integer The ID of this player
---@field Steam string The Steam ID of this player
---@field Admin boolean Whether or not this player is an admin
---@field Auth boolean Whether or not this player is authed
---@field Permissions table<string, boolean> The permissions this player has
Noir.Classes.PlayerClass = Noir.Class("NoirPlayer")

--[[
    Initializes player class objects.
]]
---@param name string
---@param ID integer
---@param steam string
---@param admin boolean
---@param auth boolean
---@param permissions table<string, boolean>
function Noir.Classes.PlayerClass:Init(name, ID, steam, admin, auth, permissions)
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Init()", "steam", steam, "string")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Init()", "admin", admin, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Init()", "auth", auth, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Init()", "permissions", permissions, "table")

    self.Name = name
    self.ID = ID
    self.Steam = steam
    self.Admin = admin
    self.Auth = auth
    self.Permissions = permissions
end

--[[
    Give this player a permission.
]]
---@param permission string
function Noir.Classes.PlayerClass:SetPermission(permission)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:SetPermission()", "permission", permission, "string")

    -- Set permission
    self.Permissions[permission] = true

    -- Save changes
    Noir.Services.PlayerService:_SaveProperty(self, "Permissions")
end

--[[
    Returns whether or not this player has a permission.
]]
---@param permission string
---@return boolean
function Noir.Classes.PlayerClass:HasPermission(permission)
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:HasPermission()", "permission", permission, "string")
    return self.Permissions[permission] ~= nil
end

--[[
    Remove a permission from this player.
]]
---@param permission string
function Noir.Classes.PlayerClass:RemovePermission(permission)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:RemovePermission()", "permission", permission, "string")

    -- Remove permission
    self.Permissions[permission] = nil

    -- Save changes
    Noir.Services.PlayerService:_SaveProperty(self, "Permissions")
end

--[[
    Returns a table containing the player's permissions.
]]
---@return table<integer, string>
function Noir.Classes.PlayerClass:GetPermissions()
    return Noir.Libraries.Table:Keys(self.Permissions)
end

--[[
    Sets whether or not this player is authed.
]]
---@param auth boolean
function Noir.Classes.PlayerClass:SetAuth(auth)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:SetAuth()", "auth", auth, "boolean")

    -- Add/remove auth
    if auth then
        server.addAuth(self.ID)
    else
        server.removeAuth(self.ID)
    end

    self.Auth = auth
end

--[[
    Sets whether or not this player is an admin.
]]
---@param admin boolean
function Noir.Classes.PlayerClass:SetAdmin(admin)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:SetAdmin()", "admin", admin, "boolean")

    -- Add/remove admin
    if admin then
        server.addAdmin(self.ID)
    else
        server.removeAdmin(self.ID)
    end

    self.Admin = admin
end

--[[
    Kicks this player.
]]
function Noir.Classes.PlayerClass:Kick()
    server.kickPlayer(self.ID)
end

--[[
    Bans this player.
]]
function Noir.Classes.PlayerClass:Ban()
    server.banPlayer(self.ID)
end

--[[
    Teleports this player.
]]
---@param pos SWMatrix
function Noir.Classes.PlayerClass:Teleport(pos)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Teleport()", "pos", pos, "table")

    -- Teleport the player
    server.setPlayerPos(self.ID, pos)
end

--[[
    Returns this player's position.
]]
---@return SWMatrix
function Noir.Classes.PlayerClass:GetPosition()
    local pos, success = server.getPlayerPos(self.ID)

    if not success then
        return matrix.translation(0, 0 ,0)
    end

    return pos
end

--[[
    Returns this player's character as a NoirObject.
]]
---@return NoirObject|nil
function Noir.Classes.PlayerClass:GetCharacter()
    -- Get the character
    local character = server.getPlayerCharacterID(self.ID)

    if not character then
        Noir.Libraries.Logging:Error("NoirPlayer", ":GetCharacter() failed for player %s (%d, %s)", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Get or create object for character
    local object = Noir.Services.ObjectService:GetObject(character)

    if not object then
        Noir.Libraries.Logging:Error("NoirPlayer", ":GetCharacter() failed for player %s (%d, %s) due to object being nil", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Return
    return object
end

--[[
    Returns this player's look direction.
]]
---@return number LookX
---@return number LookY
---@return number LookZ
function Noir.Classes.PlayerClass:GetLook()
    local x, y, z, success = server.getPlayerLookDirection(self.ID)

    if not success then
        return 0, 0, 0
    end

    return x, y, z
end

--[[
    Send this player a notification.
]]
---@param title string
---@param message string
---@param notificationType SWNotifiationTypeEnum
function Noir.Classes.PlayerClass:Notify(title, message, notificationType)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Notify()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Notify()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Classes.PlayerClass:Notify()", "notificationType", notificationType, "number")

    -- Send notification
    server.notify(self.ID, title, message, notificationType)
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Task.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Task
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
    Represents a task.

    task:SetRepeating(true)
    task:SetDuration(1)

    task.OnCompletion:Connect(function()
        -- Do something
    end)
]]
---@class NoirTask: NoirClass
---@field New fun(self: NoirTask, ID: integer, duration: number, isRepeating: boolean, arguments: table<integer, any>): NoirTask
---@field ID integer The ID of this task
---@field StartedAt integer The time that this task started at
---@field Duration integer The duration of this task
---@field StopsAt integer The time that this task will stop at if it is not repeating
---@field IsRepeating boolean Whether or not this task is repeating
---@field Arguments table<integer, any> The arguments that will be passed to this task upon completion
---@field OnCompletion NoirEvent The event that will be fired when this task is completed
Noir.Classes.TaskClass = Noir.Class("NoirTask")

--[[
    Initializes task class objects.
]]
---@param ID integer
---@param duration number
---@param isRepeating boolean
---@param arguments table<integer, any>
function Noir.Classes.TaskClass:Init(ID, duration, isRepeating, arguments)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "isRepeating", isRepeating, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:Init()", "arguments", arguments, "table")

    self.ID = ID
    self.StartedAt = Noir.Services.TaskService:GetTimeSeconds()

    self:SetDuration(duration)
    self:SetRepeating(isRepeating)
    self:SetArguments(arguments)

    self.OnCompletion = Noir.Libraries.Events:Create()
end

--[[
    Sets whether or not this task is repeating.<br>
    If repeating, the task will be triggered every Task.Duration seconds.<br>
    If not, the task will be triggered once, then removed from the TaskService.
]]
---@param isRepeating boolean
function Noir.Classes.TaskClass:SetRepeating(isRepeating)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:SetRepeating()", "isRepeating", isRepeating, "boolean")
    self.IsRepeating = isRepeating
end

--[[
    Sets the duration of this task.
]]
---@param duration number
function Noir.Classes.TaskClass:SetDuration(duration)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:SetDuration()", "duration", duration, "number")

    self.Duration = duration
    self.StopsAt = self.StartedAt + duration
end

--[[
    Sets the arguments that will be passed to this task upon finishing.
]]
---@param arguments table<integer, any>
function Noir.Classes.TaskClass:SetArguments(arguments)
    Noir.TypeChecking:Assert("Noir.Classes.TaskClass:SetArguments()", "arguments", arguments, "table")
    self.Arguments = arguments
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Object.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Object
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
    Represents a Stormworks object.

    object:IsSimulating() -- true
    object:Teleport(matrix.translation(0, 0, 0))
]]
---@class NoirObject: NoirClass
---@field New fun(self: NoirObject, ID: integer): NoirObject
---@field ID integer The ID of this object
---@field Loaded boolean Whether or not this object is loaded
---@field OnLoad NoirEvent Fired when this object is loaded
---@field OnUnload NoirEvent Fired when this object is unloaded
---@field OnDespawn NoirEvent Fired when this object is despawned
Noir.Classes.ObjectClass = Noir.Class("NoirObject")

--[[
    Initializes object class objects.
]]
---@param ID integer
function Noir.Classes.ObjectClass:Init(ID)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Init()", "ID", ID, "number")

    self.ID = ID
    self.Loaded = false

    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
    self.OnDespawn = Noir.Libraries.Events:Create()
end

--[[
    Serializes this object into g_savedata format.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSerializedObject
function Noir.Classes.ObjectClass:_Serialize()
    return {
        ID = self.ID
    }
end

--[[
    Deserializes this object from g_savedata format.<br>
    Used internally. Do not use in your code.
]]
---@param serializedObject NoirSerializedObject
---@return NoirObject
function Noir.Classes.ObjectClass._Deserialize(serializedObject)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass._Deserialize()", "serializedObject", serializedObject, "table")

    -- Create object from serialized object
    local object = Noir.Classes.ObjectClass:New(serializedObject.ID)

    -- Return it
    return object
end

--[[
    Returns the data of this object.
]]
---@return SWObjectData|nil
function Noir.Classes.ObjectClass:GetData()
    -- Get the data
    local data = server.getObjectData(self.ID)

    if not data then
        Noir.Libraries.Logging:Error("NoirObject", ":GetData() failed for object %d. Data is nil", false, self.ID)
        return
    end

    -- Return the data
    return data
end

--[[
    Returns whether or not this object is simulating.
]]
---@return boolean
function Noir.Classes.ObjectClass:IsSimulating()
    local simulating, success = server.getObjectSimulating(self.ID)
    return simulating and success
end

--[[
    Returns whether or not this object exists.
]]
---@return boolean
function Noir.Classes.ObjectClass:Exists()
    local _, exists = server.getObjectSimulating(self.ID)
    return exists
end

--[[
    Despawn this object.
]]
function Noir.Classes.ObjectClass:Despawn()
    server.despawnObject(self.ID, true)
    self.OnDespawn:Fire()
end

--[[
    Get this object's position.
]]
---@return SWMatrix
function Noir.Classes.ObjectClass:GetPosition()
    return (server.getObjectPos(self.ID))
end

--[[
    Teleport this object.
]]
---@param position SWMatrix
function Noir.Classes.ObjectClass:Teleport(position)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Teleport()", "position", position, "table")
    server.setObjectPos(self.ID, position)
end

--[[
    Revive this character (if character).
]]
function Noir.Classes.ObjectClass:Revive()
    server.reviveCharacter(self.ID)
end

--[[
    Set this object's data (if character).
]]
---@param hp number
---@param interactable boolean
---@param AI boolean
function Noir.Classes.ObjectClass:SetData(hp, interactable, AI)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetData()", "hp", hp, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetData()", "interactable", interactable, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetData()", "AI", AI, "boolean")

    -- Set data
    server.setCharacterData(self.ID, hp, interactable, AI)
end

--[[
    Returns this character's health (if character).
]]
---@return number
function Noir.Classes.ObjectClass:GetHealth()
    -- Get character data
    local data = self:GetData()

    if not data then
        Noir.Libraries.Logging:Error("NoirObject", ":GetHealth() failed as data is nil. Returning 100 as default.", false)
        return 100
    end

    -- Return
    return data.hp
end

--[[
    Set this character's tooltip (if character).
]]
---@param tooltip string
function Noir.Classes.ObjectClass:SetTooltip(tooltip)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetTooltip()", "tooltip", tooltip, "string")
    server.setCharacterTooltip(self.ID, tooltip)
end

--[[
    Set this character's AI state (if character).
]]
---@param state integer 0 = none, 1 = path to destination
function Noir.Classes.ObjectClass:SetAIState(state)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetAIState()", "state", state, "number")
    server.setAIState(self.ID, state)
end

--[[
    Set this character's AI character target (if character).
]]
---@param target NoirObject
function Noir.Classes.ObjectClass:SetAICharacterTarget(target)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetAICharacterTarget()", "target", target, Noir.Classes.ObjectClass)
    server.setAITargetCharacter(self.ID, target.ID)
end

--[[
    Set this character's AI vehicle target (if character).
]]
---@param vehicle_id integer
function Noir.Classes.ObjectClass:SetAIVehicleTarget(vehicle_id)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetAIVehicleTarget()", "vehicle_id", vehicle_id, "number")
    server.setAITargetVehicle(self.ID, vehicle_id)
end

--[[
    Kills this character (if character).
]]
function Noir.Classes.ObjectClass:Kill()
    server.killCharacter(self.ID)
end

--[[
    Returns the vehicle this character is sat in (if character).
]]
---@return integer|nil
function Noir.Classes.ObjectClass:GetVehicle()
    local vehicle_id, success = server.getCharacterVehicle(self.ID)

    if not success then
        Noir.Libraries.Logging:Error("NoirObject", "server.getCharacterVehicle(...) was unsuccessful.", false)
        return
    end

    return vehicle_id
end

--[[
    Returns the item this character is holding in the specified slot (if character).
]]
---@param slot SWSlotNumberEnum
---@return integer|nil
function Noir.Classes.ObjectClass:GetItem(slot)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:GetItem()", "slot", slot, "number")

    -- Get the item
    local item, success = server.getCharacterItem(self.ID, slot)

    if not success then
        Noir.Libraries.Logging:Error("NoirObject", "server.getCharacterItem(...) was unsuccessful.", false)
        return
    end

    -- Return it
    return item
end

--[[
    Give this character an item (if character).
]]
---@param slot SWSlotNumberEnum
---@param equipmentID SWEquipmentTypeEnum
---@param isActive boolean|nil
---@param int integer|nil
---@param float number|nil
function Noir.Classes.ObjectClass:GiveItem(slot, equipmentID, isActive, int, float)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:GiveItem()", "slot", slot, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:GiveItem()", "equipmentID", equipmentID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:GiveItem()", "isActive", isActive, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:GiveItem()", "int", int, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:GiveItem()", "float", float, "number", "nil")

    -- Give the item
    server.setCharacterItem(self.ID, slot, equipmentID, isActive or false, int or 0, float or 0)
end

--[[
    Returns whether or not this character is downed (dead, incapaciated, or hp <= 0) (if character).
]]
---@return boolean
function Noir.Classes.ObjectClass:IsDowned()
    -- Get data
    local data = self:GetData()

    if not data then
        Noir.Libraries.Logging:Error("NoirObject", ":IsDowned() failed due to data being nil.", false)
        return false
    end

    -- Return
    return data.dead or data.incapacitated or data.hp <= 0
end

--[[
    Seat this character in a seat (if character).
]]
---@param vehicle_id integer
---@param name string|nil
---@param voxelX integer|nil
---@param voxelY integer|nil
---@param voxelZ integer|nil
function Noir.Classes.ObjectClass:Seat(vehicle_id, name, voxelX, voxelY, voxelZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Seat()", "vehicle_id", vehicle_id, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Seat()", "name", name, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Seat()", "voxelX", voxelX, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Seat()", "voxelY", voxelY, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Seat()", "voxelZ", voxelZ, "number", "nil")

    -- Set seated
    if name then
        server.setSeated(self.ID, vehicle_id, name)
    elseif voxelX and voxelY and voxelZ then
        server.setSeated(self.ID, vehicle_id, voxelX, voxelY, voxelZ)
    else
        Noir.Libraries.Logging:Error("NoirObject", "Name, or voxelX and voxelY and voxelZ must be provided to NoirObject:Seat().", true)
    end
end

--[[
    Set the move target of this character (if creature).
]]
---@param position SWMatrix
function Noir.Classes.ObjectClass:SetMoveTarget(position)
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetMoveTarget()", "position", position, "table")
    server.setCreatureMoveTarget(self.ID, position)
end

--[[
    Damage this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.ObjectClass:Damage(amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Damage()", "amount", amount, "number")

    -- Get health
    local health = self:GetHealth()

    -- Damage
    self:SetData(health - amount, false, false)
end

--[[
    Heal this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.ObjectClass:Heal(amount)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:Heal()", "amount", amount, "number")

    -- Get health
    local health = self:GetHealth()

    -- Prevent soft-lock
    if health <= 0 and amount > 0 then
        self:Revive()
    end

    -- Heal
    self:SetData(health + amount, false, false)
end

--[[
    Get this fire's data (if fire).
]]
---@return boolean isLit
function Noir.Classes.ObjectClass:GetFireData()
    -- Get fire data
    local isLit, success = server.getFireData(self.ID)

    if not success then
        Noir.Libraries.Logging:Error("NoirObject", "server.getFireData(...) was unsuccessful. Returning false.", false)
        return false
    end

    -- Return
    return isLit
end

--[[
    Set this fire's data (if fire).
]]
---@param isLit boolean
---@param isExplosive boolean
function Noir.Classes.ObjectClass:SetFireData(isLit, isExplosive)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetFireData()", "isLit", isLit, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.ObjectClass:SetFireData()", "isExplosive", isExplosive, "boolean")

    -- Set fire data
    server.setFireData(self.ID, isLit, isExplosive)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents an object class object that has been serialized.
]]
---@class NoirSerializedObject
---@field ID integer The object ID

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Command.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Classes - Command
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
    Represents a command.
]]
---@class NoirCommand: NoirClass
---@field New fun(self: NoirCommand, name: string, aliases: table<integer, string>, requiredPermissions: table<integer, string>, requiresAuth: boolean, requiresAdmin: boolean, capsSensitive: boolean, description: string): NoirCommand
---@field Name string The name of this command
---@field Aliases table<integer, string> The aliases of this command
---@field RequiredPermissions table<integer, string> The required permissions for this command. If this is empty, anyone can use this command
---@field RequiresAuth boolean Whether or not this command requires auth
---@field RequiresAdmin boolean Whether or not this command requires admin
---@field CapsSensitive boolean Whether or not this command is case-sensitive
---@field Description string The description of this command
---@field OnUse NoirEvent Arguments: player, message, args, hasPermission | Fired when this command is used
Noir.Classes.CommandClass = Noir.Class("NoirCommand")

--[[
    Initializes command class objects.
]]
---@param name string
---@param aliases table<integer, string>
---@param requiredPermissions table<integer, string>
---@param requiresAuth boolean
---@param requiresAdmin boolean
---@param capsSensitive boolean
---@param description string
function Noir.Classes.CommandClass:Init(name, aliases, requiredPermissions, requiresAuth, requiresAdmin, capsSensitive, description)
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "aliases", aliases, "table")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "requiredPermissions", requiredPermissions, "table")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "requiresAuth", requiresAuth, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "requiresAdmin", requiresAdmin, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "capsSensitive", capsSensitive, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:Init()", "description", description, "string")

    self.Name = name
    self.Aliases = aliases
    self.RequiredPermissions = requiredPermissions
    self.RequiresAuth = requiresAuth
    self.RequiresAdmin = requiresAdmin
    self.CapsSensitive = capsSensitive
    self.Description = description

    self.OnUse = Noir.Libraries.Events:Create()
end

--[[
    Trigger this command.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@param message string
---@param args table
function Noir.Classes.CommandClass:_Use(player, message, args)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:_Use()", "player", player, Noir.Classes.PlayerClass)
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:_Use()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:_Use()", "args", args, "table")

    -- Fire event
    self.OnUse:Fire(player, message, args, self:CanUse(player))
end

--[[
    Returns whether or not the string matches this command.<br>
    Used internally. Do not use in your code.
]]
---@param query string
---@return boolean
function Noir.Classes.CommandClass:_Matches(query)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:_Matches()", "query", query, "string")

    -- Check if the string matches this command's name/aliases
    if not self.CapsSensitive then
        if self.Name:lower() == query:lower() then
            return true
        end

        for _, alias in ipairs(self.Aliases) do
            if alias:lower() == query:lower() then
                return true
            end
        end

        return false
    else
        if self.Name == query then
            return true
        end

        for _, alias in ipairs(self.Aliases) do
            if alias == query then
                return true
            end
        end

        return false
    end
end

--[[
    Returns whether or not the player can use this command.
]]
---@param player NoirPlayer
---@return boolean
function Noir.Classes.CommandClass:CanUse(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.CommandClass:CanUse()", "player", player, Noir.Classes.PlayerClass)

    -- Check if the player can use this command via auth
    if self.RequiresAuth and not player.Auth then
        return false
    end

    -- Check if the player can use this command via admin
    if self.RequiresAdmin and not player.Admin then
        return false
    end

    -- Check if the player has the required permissions
    for _, permission in ipairs(self.RequiredPermissions) do
        if not player:HasPermission(permission) then
            return false
        end
    end

    -- Woohoo!
    return true
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Classes\Library.lua
----------------------------------------------
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

----------------------------------------------
-- // [File] ..\src\Noir\Libraries.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries
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

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\Events.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - Events
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
    A library that allows you to create events.

    local MyEvent = Events:Create()

    MyEvent:Connect(function()
        print("Fired")
    end)

    MyEvent:Once(function() -- Automatically disconnected upon event being fired
        print("Fired (once)")
    end)

    MyEvent:Fire()
]]
---@class NoirEventsLib: NoirLibrary
Noir.Libraries.Events = Noir.Libraries:Create(
    "NoirEvents",
    "A library that allows you to create events.",
    "A library that allows you to create events. Functions can then be connected or disconnected from these events. Events can be fired which calls all connected functions with the provided arguments.",
    {"Cuh4", "Avril112113"}
)

--[[
    Create an event. This event can then be fired with the :Fire() method.

    local MyEvent = Events:Create()

    local connection = MyEvent:Connect(function()
        print("Fired")
    end)

    connection:Disconnect() -- Disconnects the callback from the event

    local connection2 = MyEvent:Once(function() -- Automatically disconnected upon fire
        print("Fired. This won't be printed ever again even if the event is fired again")
    end)

    MyEvent:Fire() -- "Fired. This won't be printed ever again even if the event is fired again"
]]
---@return NoirEvent
function Noir.Libraries.Events:Create()
    local event = Noir.Classes.EventClass:New()
    return event
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\Logging.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - Logging
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
    A library containing methods related to logging.
]]
---@class NoirLoggingLib: NoirLibrary
Noir.Libraries.Logging = Noir.Libraries:Create(
    "NoirLogging",
    "A library containing methods related to logging.",
    nil,
    {"Cuh4"}
)

--[[
    The mode to use when logging.<br>
    - "DebugLog": Sends logs to DebugView<br>
    - "Chat": Sends logs to chat
]]
Noir.Libraries.Logging.LoggingMode = "DebugLog" ---@type NoirLoggingMode

--[[
    An event called when a log is sent.<br>
    Arguments: (log: string)
]]
Noir.Libraries.Logging.OnLog = Noir.Libraries.Events:Create()

--[[
    Represents the logging layout.<br>
    Requires two '%s' in the layout. First %s is the log type, the second %s is the log title. The message is then added after the layout.
]]
Noir.Libraries.Logging.Layout = "[Noir] [%s] [%s]: "

--[[
    Set the logging mode.

    Noir.Libraries.Logging:SetMode("DebugLog")
]]
---@param mode NoirLoggingMode
function Noir.Libraries.Logging:SetMode(mode)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:SetMode()", "mode", mode, "string")
    self.LoggingMode = mode
end

--[[
    Sends a log.

    Noir.Libraries.Logging:Log("Warning", "Title", "Something went wrong relating to %s", "something.")
]]
---@param logType string
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Log(logType, title, message, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Log()", "logType", logType, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Log()", "title", title, "string")

    -- Format
    local formattedText = self:_FormatLog(logType, title, message, ...)

    -- Send log
    if self.LoggingMode == "DebugLog" then
        debug.log(formattedText)
    elseif self.LoggingMode == "Chat" then
        debug.log(formattedText)
        server.announce("Noir", formattedText)
    else
        self:Error("Invalid logging mode: %s", "'%s' is not a valid logging mode.", true, tostring(Noir.Libraries.LoggingMode))
    end

    -- Send event
    self.OnLog:Fire(formattedText)
end

--[[
    Format a log.<br>
    Used internally.
]]
---@param logType string
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:_FormatLog(logType, title, message, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:_FormatLog()", "logType", logType, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:_FormatLog()", "title", title, "string")

    -- Validate args
    local validatedLogType = tostring(logType)
    local validatedTitle = tostring(title)
    local validatedMessage = type(message) == "table" and Noir.Libraries.Table:ToString(message) or (... and tostring(message):format(...) or tostring(message))

    -- Format text
    local formattedMessage = (self.Layout:format(validatedLogType, validatedTitle)..validatedMessage):gsub("\n", "\n"..self.Layout:format(validatedLogType, validatedTitle))

    -- Return
    return formattedMessage
end

--[[
    Sends an error log.<br>
    Passing true to the third argument will intentionally cause an addon error to be thrown.

    Noir.Libraries.Logging:Error("Title", "Something went wrong relating to %s", true, "something.")
]]
---@param title string
---@param message any
---@param triggerError boolean
---@param ... any
function Noir.Libraries.Logging:Error(title, message, triggerError, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Error()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Error()", "triggerError", triggerError, "boolean")

    self:Log("Error", title, message, ...)

    if triggerError then
        _ENV["Noir: An error was triggered. See logs for details."]()
    end
end

--[[
    Sends a warning log.

    Noir.Libraries.Logging:Warning("Title", "Something went unexpected relating to %s", "something.")
]]
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Warning(title, message, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Warning()", "title", title, "string")
    self:Log("Warning", title, message, ...)
end

--[[
    Sends an info log.

    Noir.Libraries.Logging:Info("Title", "Something went okay relating to %s", "something.")
]]
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Info(title, message, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Info()", "title", title, "string")
    self:Log("Info", title, message, ...)
end

--[[
    Sends a success log.

    Noir.Libraries.Logging:Success("Title", "Something went right relating to %s", "something.")
]]
---@param title string
---@param message any
---@param ... any
function Noir.Libraries.Logging:Success(title, message, ...)
    Noir.TypeChecking:Assert("Noir.Libraries.Logging:Success()", "title", title, "string")
    self:Log("Success", title, message, ...)
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirLoggingMode
---| "Chat" Sends via server.announce and via debug.log
---| "DebugLog" Sends only via debug.log

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\Table.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - Table
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
    A library containing helper methods relating to tables.
]]
---@class NoirTableLib: NoirLibrary
Noir.Libraries.Table = Noir.Libraries:Create(
    "NoirTable",
    "A library containing helper methods relating to tables.",
    nil,
    {"Cuh4"}
)

--[[
    Returns the length of the provided table.

    local myTbl = {1, 2, 3}
    local length = Noir.Libraries.Table:Length(myTbl)
    print(length) -- 3

    local complexTable = {
        [5] = true,
        [true] = 25
    }
    local complexLength = Noir.Libraries.Table:Length(complexTable)
    print(length) -- 2
]]
---@param tbl table
---@return integer
function Noir.Libraries.Table:Length(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Length()", "tbl", tbl, "table")

    -- Calculate the length of the table
    local length = 0

    for _ in pairs(tbl) do
        length = length + 1
    end

    return length
end

--[[
    Returns a random value in the provided table.

    local myTbl = {1, 2, 3}
    local random = Noir.Libraries.Table:Random(myTbl)
    print(random) -- 1|2|3
]]
---@param tbl table
---@return any
function Noir.Libraries.Table:Random(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Random()", "tbl", tbl, "table")

    -- Prevent an error if the table is empty
    if #tbl == 0 then
        return
    end

    -- Return a random value
    return tbl[math.random(1, #tbl)]
end

--[[
    Return the keys of the provided table.

    local myTbl = {
        [true] = 1
    }

    local keys = Noir.Libraries.Table:Keys(myTbl)
    print(keys) -- {true}
]]
---@generic tbl: table
---@param tbl table
---@return tbl
function Noir.Libraries.Table:Keys(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Keys()", "tbl", tbl, "table")

    -- Create a new table with the keys of the provided table
    local keys = {}

    for index, _ in pairs(tbl) do
        table.insert(keys, index)
    end

    return keys
end

--[[
    Return the values of the provided table.

    local myTbl = {
        [true] = 1
    }

    local values = Noir.Libraries.Table:Values(myTbl)
    print(values) -- {1}
]]
---@generic tbl: table
---@param tbl tbl
---@return tbl
function Noir.Libraries.Table:Values(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Values()", "tbl", tbl, "table")

    -- Create a new table with the values of the provided table
    local values = {}

    for _, value in pairs(tbl) do
        table.insert(values, value)
    end

    return values
end

--[[
    Get a portion of a table between two points.

    local myTbl = {1, 2, 3, 4, 5, 6}
    local trimmed = Noir.Libraries.Table:Slice(myTbl, 2, 4)
    print(trimmed) -- {2, 3, 4}
]]
---@generic tbl: table
---@param tbl tbl
---@param start number|nil
---@param finish number|nil
---@return tbl
function Noir.Libraries.Table:Slice(tbl, start, finish)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Slice()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Slice()", "start", start, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Slice()", "finish", finish, "number", "nil")

    -- Slice the table
    return {table.unpack(tbl, start, finish)}
end

--[[
    Converts a table to a string by iterating deep through the table.

    local myTbl = {1, 2, {}, "foo"}
    local string = Noir.Libraries.Table:ToString(myTbl)
    print(string) -- 1: 1\n2: 2\n3: {}\n4: "foo"
    
]]
---@param tbl table
---@param indent integer|nil
---@return string
function Noir.Libraries.Table:ToString(tbl, indent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ToString()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ToString()", "indent", indent, "number", "nil")

    -- Set default indent
    if not indent then
        indent = 0
    end

    -- Create a table for later
    local toConcatenate = {}

    -- Convert the table to a string
    for index, value in pairs(tbl) do
        -- Get value type
        local valueType = type(value)

        -- Format the index for later
        local formattedIndex = ("[%s]:"):format(type(index) == "string" and "\""..index.."\"" or tostring(index):gsub("\n", "\\n"))

        -- Format the value
        local toAdd = formattedIndex

        if valueType == "table" then
            -- Format table
            local nextIndent = indent + 2
            local formattedValue = Noir.Libraries.Table:ToString(value, nextIndent)

            -- Check if empty table
            if formattedValue == "" then
                formattedValue = "{}"
            else
                formattedValue = "\n"..formattedValue
            end

            -- Add to string
            toAdd = toAdd..(" %s"):format(formattedValue)
        elseif valueType == "number" or valueType == "boolean" then
            toAdd = toAdd..(" %s"):format(tostring(value))
        else
            toAdd = toAdd..(" \"%s\""):format(tostring(value):gsub("\n", "\\n"))
        end

        -- Add to table
        table.insert(toConcatenate, ("  "):rep(indent)..toAdd)
    end

    -- Return the table as a formatted string
    return table.concat(toConcatenate, "\n")
end

--[[
    Copy a table (shallow).

    local myTbl = {1, 2, 3}
    local copy = Noir.Libraries.Table:Copy(myTbl)
    print(copy) -- {1, 2, 3}
]]
---@generic tbl: table
---@param tbl tbl
---@return tbl
function Noir.Libraries.Table:Copy(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Copy()", "tbl", tbl, "table")

    -- Perform a shallow copy
    local new = {}

    for index, value in pairs(tbl) do
        new[index] = value
    end

    return new
end
--[[
    Copy a table (deep).

    local myTbl = {1, 2, 3}
    local copy = Noir.Libraries.Table:DeepCopy(myTbl)
    print(copy) -- {1, 2, 3}
]]
---@generic tbl: table
---@param tbl tbl
---@return tbl
function Noir.Libraries.Table:DeepCopy(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:DeepCopy()", "tbl", tbl, "table")

    -- Perform a deep copy
    local new = {}

    for index, value in pairs(tbl) do
        if type(value) == "table" then
            new[index] = self:DeepCopy(value)
        else
            new[index] = value
        end
    end

    return new
end

--[[
    Merge two tables together (unforced).

    local myTbl = {1, 2, 3}
    local otherTbl = {4, 5, 6}
    local merged = Noir.Libraries.Table:Merge(myTbl, otherTbl)
    print(merged) -- {1, 2, 3, 4, 5, 6}
]]
---@param tbl table
---@param other table
---@return table
function Noir.Libraries.Table:Merge(tbl, other)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Merge()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Merge()", "other", other, "table")

    -- Merge the tables
    local new = self:Copy(tbl)

    for _, value in pairs(other) do
        table.insert(new, value)
    end

    return new
end

--[[
    Merge two tables together (forced).

    local myTbl = {1, 2, 3}
    local otherTbl = {4, 5, 6}
    local merged = Noir.Libraries.Table:ForceMerge(myTbl, otherTbl)
    print(merged) -- {4, 5, 6} <-- This is because the indexes are the same, so the values of myTbl were overwritten
]]
---@param tbl table
---@param other table
---@return table
function Noir.Libraries.Table:ForceMerge(tbl, other)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ForceMerge()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Table:ForceMerge()", "other", other, "table")

    -- Merge the tables forcefully
    local new = self:Copy(tbl)

    for index, value in pairs(other) do
        new[index] = value
    end

    return new
end

--[[
    Find a value in a table. Returns the index, or nil if not found.

    local myTbl = {["hello"] = true}

    local index = Noir.Libraries.Table:Find(myTbl, true)
    print(index) -- "hello"
]]
---@param tbl table
---@param value any
---@return any|nil
function Noir.Libraries.Table:Find(tbl, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Table:Find()", "tbl", tbl, "table")

    -- Find the value
    for index, iterValue in pairs(tbl) do
        if iterValue == value then
            return index
        end
    end
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\Number.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - Number
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
    A library containing helper methods relating to numbers.
]]
---@class NoirNumberLib: NoirLibrary
Noir.Libraries.Number = Noir.Libraries:Create(
    "NoirNumber",
    "Provides helper methods relating to numbers.",
    nil,
    {"Cuh4"}
)

--[[
    Returns whether or not the provided number is between the two provided values.

    local number = 5
    local isWithin = Noir.Libraries.Number:IsWithin(number, 1, 10) -- true

    local number = 5
    local isWithin = Noir.Libraries.Number:IsWithin(number, 10, 20) -- false
]]
---@param number number
---@param start number
---@param stop number
---@return boolean
function Noir.Libraries.Number:IsWithin(number, start, stop)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsWithin()", "number", number, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsWithin()", "start", start, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsWithin()", "stop", stop, "number")

    -- Clamp the number
    return number >= start and number <= stop
end

--[[
    Clamps a number between two values.

    local number = 5
    local clamped = Noir.Libraries.Number:Clamp(number, 1, 10) -- 5

    local number = 15
    local clamped = Noir.Libraries.Number:Clamp(number, 1, 10) -- 10
]]
---@param number number
---@param min number
---@param max number
---@return number
function Noir.Libraries.Number:Clamp(number, min, max)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Clamp()", "number", number, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Clamp()", "min", min, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Clamp()", "max", max, "number")

    -- Clamp the number
    return math.min(math.max(number, min), max)
end

--[[
    Rounds the number to the provided number of decimal places (defaults to 0).

    local number = 5.5
    local rounded = Noir.Libraries.Number:Round(number) -- 6

    local number = 5.5
    local rounded = Noir.Libraries.Number:Round(number, 1) -- 5.5

    local number = 5.537
    local rounded = Noir.Libraries.Number:Round(number, 2) -- 5.54
]]
---@param number number
---@param decimalPlaces number|nil
---@return number
function Noir.Libraries.Number:Round(number, decimalPlaces)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Number:Round()", "number", number, "number")

    -- Round the number
    local mult = 10 ^ (decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
end

--[[
    Returns whether or not the provided number is an integer.

    Noir.Libraries.Number:IsInteger(5) -- true
    Noir.Libraries.Number:IsInteger(5.5) -- false
]]
---@param number number
---@return boolean
function Noir.Libraries.Number:IsInteger(number)
    Noir.TypeChecking:Assert("Noir.Libraries.Number:IsInteger()", "number", number, "number")
    return math.floor(number) == number
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\String.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - String
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
    A library containing helper methods relating to strings.
]]
---@class NoirStringLib: NoirLibrary
Noir.Libraries.String = Noir.Libraries:Create(
    "NoirString",
    "A library containing helper methods relating to strings.",
    nil,
    {"Cuh4"}
)

--[[
    Splits a string by the provided separator (defaults to " ").

    local myString = "hello world"
    Noir.Libraries.String:Split(myString, " ") -- {"hello", "world"}
    Noir.Libraries.String:Split(myString) -- {"hello", "world"}
]]
---@param str string
---@param separator string|nil
---@return table<integer, string>
function Noir.Libraries.String:Split(str, separator)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.String:Split()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.String:Split()", "separator", separator, "string", "nil")

    -- Default separator
    separator = separator or " "

    -- Split the string
    local split = {}

    for part in str:gmatch("([^"..separator.."]+)") do
        table.insert(split, part)
    end

    -- Return the split string
    return split
end

--[[
    Splits a string by their lines.

    local myString = "hello\nworld"
    Noir.Libraries.String:SplitLines(myString) -- {"hello", "world"}
]]
---@param str string
---@return table<integer, string>
function Noir.Libraries.String:SplitLines(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.String:SplitLines()", "str", str, "string")

    -- Split the string by newlines
    return self:Split(str, "\n")
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\JSON.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - JSON
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
    A library containing helper methods to serialize Lua objects into JSON and back.<br>
    This code is from https://gist.github.com/tylerneylon/59f4bcf316be525b30ab
]]
---@class NoirJSONLib: NoirLibrary
Noir.Libraries.JSON = Noir.Libraries:Create(
    "NoirJSON",
    "A library containing helper methods to serialize Lua objects into JSON and back.",
    nil,
    {"Cuh4"}
)

--[[
    Represents a null value.
]]
Noir.Libraries.JSON.Null = {}

--[[
    Returns the type of the provided object.<br>
    Used internally. Do not use in your code.
]]
---@param obj any
---@return "nil"|"boolean"|"number"|"string"|"table"|"function"|"array"
function Noir.Libraries.JSON:KindOf(obj)
    if type(obj) ~= "table" then
        return type(obj) ---@diagnostic disable-line
    end

    local i = 1

    for _ in pairs(obj) do
        if obj[i] ~= nil then
            i = i + 1
        else
            return "table"
        end
    end

    if i == 1 then
        return "table"
    else
        return "array"
    end
end

--[[
    Escapes a string for JSON.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@return string
function Noir.Libraries.JSON:EscapeString(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:EscapeString()", "str", str, "string")

    -- Escape the string
    local inChar  = { "\\", "\"", "/", "\b", "\f", "\n", "\r", "\t" }
    local outChar = { "\\", "\"", "/", "b", "f", "n", "r", "t" }

    for i, c in ipairs(inChar) do
        str = str:gsub(c, "\\" .. outChar[i])
    end

    return str
end

--[[
    Finds the point where a delimiter is and simply returns the point after.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@param pos integer
---@param delim string
---@param errIfMissing boolean|nil
---@return integer
---@return boolean
function Noir.Libraries.JSON:SkipDelim(str, pos, delim, errIfMissing)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:SkipDelim()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:SkipDelim()", "pos", pos, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:SkipDelim()", "delim", delim, "string")

    -- Main logic
    pos = pos + #str:match("^%s*", pos)

    if str:sub(pos, pos) ~= delim then
        if errIfMissing then
            Noir.Libraries.Logging:Error("JSON", "Expected %s at position %d", true, delim, pos)
            return 0, false
        end

        return pos, false
    end

    return pos + 1, true
end

--[[
    Parses a string.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@param pos integer
---@param val string|nil
---@return string
---@return integer
function Noir.Libraries.JSON:ParseStringValue(str, pos, val)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseStringValue()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseStringValue()", "pos", pos, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseStringValue()", "val", val, "string", "nil")

    -- Parsing
    val = val or ""

    local earlyEndError = "End of input found while parsing string."

    if pos > #str then
        Noir.Libraries.Logging:Error("JSON", earlyEndError, true)
        return "", 0
    end

    local c = str:sub(pos, pos)

    if c == "\"" then
        return val, pos + 1
    end

    if c ~= "\\" then return
        self:ParseStringValue(str, pos + 1, val .. c)
    end

    local escMap = {b = "\b", f = "\f", n = "\n", r = "\r", t = "\t"}
    local nextc = str:sub(pos + 1, pos + 1)

    if not nextc then
        Noir.Libraries.Logging:Error("JSON", earlyEndError, true)
        return "", 0
    end

    return self:ParseStringValue(str, pos + 2, val..(escMap[nextc] or nextc))
end

--[[
    Parses a number.<br>
    Used internally. Do not use in your code.
]]
---@param str string
---@param pos integer
---@return integer
---@return integer
function Noir.Libraries.JSON:ParseNumberValue(str, pos)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseNumberValue()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:ParseNumberValue()", "pos", pos, "number")

    -- Parse number
    local numStr = str:match("^-?%d+%.?%d*[eE]?[+-]?%d*", pos)
    local val = tonumber(numStr)

    if not val then
        Noir.Libraries.Logging:Error("JSON", "Error parsing number at position %s.", true, pos)
        return 0, 0
    end

    return val, pos + #numStr
end

--[[
    Encodes a Lua object as a JSON string.

    local str = {1, 2, 3}
    Noir.Libraries.JSON:Encode(str) -- "{1, 2, 3}"
]]
---@param obj table|number|string|boolean|nil
---@param asKey boolean|nil
---@return string
function Noir.Libraries.JSON:Encode(obj, asKey)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Encode()", "obj", obj, "table", "number", "string", "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Encode()", "asKey", asKey, "boolean", "nil")

    -- Encode the object into a JSON string
    local s = {}
    local kind = self:KindOf(obj)

    if kind == "array" then
        if asKey then
            Noir.Libraries.Logging:Error("JSON", "Can't encode array as key.", true)
            return ""
        end

        s[#s + 1] = "["

        for i, val in ipairs(obj --[[@as table]]) do
            if i > 1 then
                s[#s + 1] = ", "
            end

            s[#s + 1] = self:Encode(val)
        end

        s[#s + 1] = "]"
    elseif kind == "table" then
        if asKey then
            Noir.Libraries.Logging:Error("JSON", "Can't encode table as key.", true)
            return ""
        end

        s[#s + 1] = "{"

        for k, v in pairs(obj --[[@as table]]) do
            if #s > 1 then
                s[#s + 1] = ", "
            end

            s[#s + 1] = self:Encode(k, true)
            s[#s + 1] = ":"
            s[#s + 1] = self:Encode(v)
        end

        s[#s + 1] = "}"
    elseif kind == "string" then
        return "\""..self:EscapeString(obj --[[@as string]]).."\""
    elseif kind == "number" then
        if asKey then
            return "\"" .. tostring(obj) .. "\""
        end

        return tostring(obj)
    elseif kind == "boolean" then
        return tostring(obj)
    elseif kind == "nil" then
        return "null"
    else
        Noir.Libraries.Logging:Error("JSON", "Type of %s cannot be JSON encoded.", true, kind)
        return ""
    end

    return table.concat(s)
end

--[[
    Decodes a JSON string into a Lua object.

    local obj = "{1, 2, 3}"
    Noir.Libraries.JSON:Decode(obj) -- {1, 2, 3}
]]
---@param str string
---@param pos integer|nil
---@param endDelim string|nil
---@return any
---@return integer
function Noir.Libraries.JSON:Decode(str, pos, endDelim)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Decode()", "str", str, "string")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Decode()", "pos", pos, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.JSON:Decode()", "endDelim", endDelim, "string", "nil")

    -- Decode a JSON string into a Lua object
    pos = pos or 1

    if pos > #str then
        Noir.Libraries.Logging:Error("JSON", "Reached unexpected end of input.", true)
    end

    pos = pos + #str:match("^%s*", pos)
    local first = str:sub(pos, pos)

    if first == "{" then
        local obj, key, delimFound = {}, true, true
        pos = pos + 1

        while true do
            key, pos = self:Decode(str, pos, "}")

            if key == nil then
                return obj, pos
            end

            if not delimFound then
                Noir.Libraries.Logging:Error("JSON", "Comma missing between object items.", true)
                return nil, 0
            end

            pos = self:SkipDelim(str, pos, ":", true)
            obj[key], pos = self:Decode(str, pos)
            pos, delimFound = self:SkipDelim(str, pos, ",")
        end
    elseif first == "[" then
        local arr, val, delimFound = {}, true, true
        pos = pos + 1

        while true do
            val, pos = self:Decode(str, pos, "]")

            if val == nil then
                return arr, pos
            end

            if not delimFound then
                Noir.Libraries.Logging:Error("JSON", "Comma missing between array items.", true)
                return nil, 0
            end

            arr[#arr + 1] = val
            pos, delimFound = self:SkipDelim(str, pos, ",")
        end
    elseif first == "\"" then
        return self:ParseStringValue(str, pos + 1)
    elseif first == "-" or first:match("%d") then
        return self:ParseNumberValue(str, pos)
    elseif first == endDelim then
        return nil, pos + 1
    else
        local literals = {["true"] = true, ["false"] = false, ["null"] = self.Null}

        for litStr, litVal in pairs(literals) do
            local litEnd = pos + #litStr - 1

            if str:sub(pos, litEnd) == litStr then
                return litVal, litEnd + 1
            end
        end

        local posInfoStr = "position "..pos..": "..str:sub(pos, pos + 10)
        Noir.Libraries.Logging:Error("JSON", "Invalid json syntax starting at %s", true, posInfoStr)

        return nil, 0
    end
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\Base64.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - Base64
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
    A library containing helper methods to serialize strings into Base64 and back.<br>
    This code is from https://gist.github.com/To0fan/ca3ebb9c029bb5df381e4afc4d27b4a6
]]
---@class NoirBase64Lib: NoirLibrary
Noir.Libraries.Base64 = Noir.Libraries:Create(
    "NoirBase64",
    "A library containing helper methods to serialize strings into Base64 and back.",
    "",
    {"Cuh4"}
)

--[[
    Character table as a string.<br>
    Used internally, do not use in your code.
]]
Noir.Libraries.Base64.Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

--[[
    Encode a string into Base64.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:Encode(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:Encode()", "data", data, "string")

    -- Encode the string into Base64
    ---@param str string
    local encoded = (data:gsub(".", function(str)
        return self:_EncodeInitial(str)
    end).."0000")

    ---@param str string
    return encoded:gsub("%d%d%d?%d?%d?%d?", function(str)
        return self:_EncodeFinal(str)
    end)..({"", "==", "="})[#data % 3 + 1]
end

--[[
    Used internally, do not use in your code.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:_EncodeInitial(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_EncodeInitial()", "data", data, "string")

    -- Main logic
    local r, b = "", data:byte()

    for i = 8, 1, -1 do
        r = r..(b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0")
    end

    return r
end

--[[
    Used internally, do not use in your code.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:_EncodeFinal(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_EncodeFinal()", "data", data, "string")

    -- Main logic
    if (#data < 6) then
        return ""
    end

    local c = 0

    for i = 1, 6 do
        c = c + (data:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
    end

    return self.Characters:sub(c + 1, c + 1)
end

--[[
    Decode a string from Base64.
]]
---@param data string
---@return string
function Noir.Libraries.Base64:Decode(data)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:Decode()", "data", data, "string")

    -- Decode the Base64 string into a normal string
    local decoded = data:gsub("[^"..self.Characters.."=]", "")

    ---@param str string
    decoded = decoded:gsub(".", function(str)
        return self:_DecodeInitial(str)
    end)

    ---@param str string
    return (decoded:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(str)
        return self:_DecodeFinal(str)
    end))
end

--[[
    Used internally, do not use in your code.
]]
---@param str string
---@return string
function Noir.Libraries.Base64:_DecodeInitial(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_DecodeInitial()", "str", str, "string")

    -- Main logic
    if str == "=" then
        return ""
    end

    local r, f = "", (self.Characters:find(str)) - 1

    for i = 6, 1, -1 do
        r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
    end

    return r
end

--[[
    Used internally, do not use in your code.
]]
---@param str string
---@return string
function Noir.Libraries.Base64:_DecodeFinal(str)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Base64:_DecodeFinal()", "str", str, "string")

    -- Main logic
    if #str ~= 8 then
        return ""
    end

    local c = 0

    for i = 1, 8 do
        c = c + (str:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
    end

    if not Noir.Libraries.Number:IsInteger(c) then
        Noir.Libraries.Logging:Error("Base64 - :_DecodeFinal()", "'c' is not an integer.", true)
        return ""
    end

    return string.char(c)
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Libraries\Matrix.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Libraries - Table
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
    A library containing helper methods relating to Stormworks matrices.
]]
---@class NoirMatrixLib: NoirLibrary
Noir.Libraries.Matrix = Noir.Libraries:Create(
    "NoirMatrix",
    "A library containing helper methods relating to Stormworks matrices.",
    nil,
    {"Cuh4"}
)

--[[
    Offsets the position of a matrix.
]]
---@param pos SWMatrix
---@param xOffset integer|nil
---@param yOffset integer|nil
---@param zOffset integer|nil
---@return SWMatrix
function Noir.Libraries.Matrix:Offset(pos, xOffset, yOffset, zOffset)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "pos", pos, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "xOffset", xOffset, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "yOffset", yOffset, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "zOffset", zOffset, "number", "nil")

    -- Offset the matrix
    return matrix.multiply(pos, matrix.translation(xOffset or 0, yOffset or 0, zOffset or 0))
end

--[[
    Returns an empty matrix. Equivalent to matrix.translation(0, 0, 0)
]]
---@return SWMatrix
function Noir.Libraries.Matrix:Empty()
    return matrix.translation(0, 0, 0)
end

--[[
    Returns a scaled matrix. Multiply this with another matrix to scale up said matrix.<br>
    This can be used to enlarge vehicles spawned via server.spawnAddonComponent, server.spawnAddonVehicle, etc.
]]
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@return SWMatrix
function Noir.Libraries.Matrix:Scale(scaleX, scaleY, scaleZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Scale()", "scaleX", scaleX, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Scale()", "scaleY", scaleY, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Scale()", "scaleZ", scaleZ, "number")

    -- Scale the matrix
    local pos = self:Empty()
    pos[1] = scaleX
    pos[6] = scaleY
    pos[11] = scaleZ

    -- Return
    return pos
end

--[[
    Offset a matrix by a random amount.
]]
---@param pos SWMatrix
---@param xRange number
---@param yRange number
---@param zRange number
---@return SWMatrix
function Noir.Libraries.Matrix:RandomOffset(pos, xRange, yRange, zRange)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "pos", pos, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "xRange", xRange, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "yRange", yRange, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "zRange", zRange, "number")

    -- Offset the matrix randomly
    return self:Offset(pos, math.random(-xRange, xRange), math.random(-yRange, yRange), math.random(-zRange, zRange))
end

--[[
    Converts a matrix to a readable format.
]]
---@param pos SWMatrix
---@return string
function Noir.Libraries.Matrix:ToString(pos)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:ToString()", "pos", pos, "table")

    -- Convert the matrix to a string
    local x, y, z = matrix.position(pos)
    return ("%.1f, %.1f, %.1f"):format(x, y, z)
end

----------------------------------------------
-- // [File] ..\src\Noir\Services.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Services
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
    A module of Noir that allows you to create organized services.<br>
    These services can be used to hold methods that are all designed for a specific purpose.

    local service = Noir.Services:GetService("MyService")
    service.initPriority = 1 -- Initialize before any other services

    function service:ServiceInit()
        -- Do something
    end

    function service:ServiceStart()
        -- Do something
    end
]]
Noir.Services = {}

--[[
    A table containing created services.<br>
    You probably do not need to modify or access this table directly. Please use `Noir.Services:GetService(name)` instead.
]]
Noir.Services.CreatedServices = {} ---@type table<string, NoirService>

--[[
    Create a service.<br>
    This service will be initialized and started after `Noir:Start()` is called.

    local service = Noir.Services:CreateService("MyService")
    service.initPriority = 1 -- Initialize before any other services

    function service:ServiceInit()
        Noir.Services:GetService("MyOtherService") -- This will likely error if the other service hasn't initialized yet. Use :GetService() in :ServiceStart() always!
        self.saveSomething = "something"
    end

    function service:ServiceStart()
        print(self.saveSomething)
    end
]]
---@param name string
---@param isBuiltIn boolean|nil
---@param shortDescription string|nil
---@param longDescription string|nil
---@param authors table<integer, string>|nil
---@return NoirService
function Noir.Services:CreateService(name, isBuiltIn, shortDescription, longDescription, authors)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "isBuiltIn", isBuiltIn, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "shortDescription", shortDescription, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "longDescription", longDescription, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Services:CreateService()", "authors", authors, "table", "nil")

    -- Check if service already exists
    if self.CreatedServices[name] then
        Noir.Libraries.Logging:Error("Service Creation", "Attempted to create a service that already exists. The already existing service has been returned instead.", false)
        return self.CreatedServices[name]
    end

    -- Create service
    local service = Noir.Classes.ServiceClass:New(name, isBuiltIn or false, shortDescription or "N/A", longDescription or "N/A", authors or {})

    -- Register service internally
    self.CreatedServices[name] = service

    -- Return service
    return service
end

--[[
    Retrieve a service by its name.<br>
    This will error if the service hasn't initialized yet.

    local service = Noir.Services:GetService("MyService")
    print(service.name) -- "MyService"
]]
---@param name string
---@return NoirService|nil
function Noir.Services:GetService(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:GetService()", "name", name, "string")

    -- Get service
    local service = self.CreatedServices[name]

    -- Check if service exists
    if not service then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that doesn't exist ('%s').", true, name)
        return
    end

    -- Check if service has been initialized
    if not service.Initialized then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that hasn't initialized yet ('%s').", false, service.Name)
        return
    end

    return service
end

--[[
    Remove a service.
]]
---@param name string
function Noir.Services:RemoveService(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:RemoveService()", "name", name, "string")

    -- Check if service exists
    if not self.CreatedServices[name] then
        Noir.Libraries.Logging:Error("Service Removal", "Attempted to remove a service that doesn't exist ('%s').", true, name)
        return
    end

    -- Remove service
    self.CreatedServices[name] = nil
end

--[[
    Format a service into a string.<br>
    Returns the service name as well as the author(s) if any.
]]
---@param service NoirService
---@return string
function Noir.Services:FormatService(service)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:FormatService()", "service", service, Noir.Classes.ServiceClass)

    -- Format service
    return ("'%s'%s%s"):format(service.Name, #service.Authors >= 1 and " by "..table.concat(service.Authors, ", ") or "", service.IsBuiltIn and " (Built-In)" or "")
end

--[[
    Returns all built-in Noir services.
]]
---@return table<string, NoirService>
function Noir.Services:GetBuiltInServices()
    local services = {}

    for index, service in pairs(self.CreatedServices) do
        if service.IsBuiltIn then
            services[index] = service
        end
    end

    return services
end

--[[
    Removes built-in services from Noir. This may give a very slight performance increase.<br>
    **Use before calling Noir:Start().**
]]
---@param exceptions table<integer, string> A table containing exact names of services to not remove
function Noir.Services:RemoveBuiltInServices(exceptions)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services:RemoveBuiltInServices()", "exceptions", exceptions, "table")

    -- Remove built-in services
    for _, service in pairs(self:GetBuiltInServices()) do
        if Noir.Libraries.Table:Find(exceptions, service.Name) then
            goto continue
        end

        self:RemoveService(service.Name)

        ::continue::
    end
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Services\TaskService.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Services - Task Service
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
    A service for easily delaying or repeating tasks.

    local task = Noir.Services.TaskService:AddTask(function(toSay)
        server.announce("Server", toSay)
    end, 5, {"Hello World!"}, true) -- This task is repeating due to isRepeating being true (final argument)

    task:SetDuration(10) -- Duration changes from 5 to 10
]]
---@class NoirTaskService: NoirService
---@field IncrementalID integer The ID of the next task
---@field Tasks table<integer, NoirTask> A table containing active tasks
---@field OnTickConnection NoirConnection Represents the connection to the onTick game callback
Noir.Services.TaskService = Noir.Services:CreateService(
    "TaskService",
    true,
    "A service for calling functions after x amount of seconds.",
    "A service that allows you to call functions after x amount of seconds, either repeatedly or once.",
    {"Cuh4"}
)

function Noir.Services.TaskService:ServiceInit()
    -- Create attributes
    self.IncrementalID = 0
    self.Tasks = {}
end

function Noir.Services.TaskService:ServiceStart()
    -- Connect to onTick, and constantly check tasks
    self.OnTickConnection = Noir.Callbacks:Connect("onTick", function()
        for _, task in pairs(self.Tasks) do
            -- Get time so far in seconds
            local time = self:GetTimeSeconds()

            -- Check if the task should be stopped
            if time >= task.StopsAt then
                if task.IsRepeating then
                    -- Repeat the task
                    task.StartedAt = time
                    task.StopsAt = time + task.Duration

                    -- Fire OnCompletion
                    task.OnCompletion:Fire(table.unpack(task.Arguments))
                else
                    -- Stop the task
                    self:RemoveTask(task)

                    -- Fire OnCompletion
                    task.OnCompletion:Fire(table.unpack(task.Arguments))
                end
            end
        end
    end)
end

--[[
    Returns the current time in seconds.<br>
    Equivalent to: server.getTimeMillisec() / 1000
]]
---@return number
function Noir.Services.TaskService:GetTimeSeconds()
    return server.getTimeMillisec() / 1000
end

--[[
    Creates and adds a task to the TaskService.

    local task = Noir.Services.TaskService:AddTask(function(toSay)
        server.announce("Server", toSay)
    end, 5, {"Hello World!"}, true) -- This task is repeating due to isRepeating being true (final argument)

    local anotherTask = Noir.Services.TaskService:AddTask(server.announce, 5, {"Server", "Hello World!"}, true) -- This does the same as above
    Noir.Services.TaskService:RemoveTask(anotherTask) -- Removes the task
]]
---@param callback function
---@param duration number
---@param arguments table|nil
---@param isRepeating boolean|nil
---@return NoirTask
function Noir.Services.TaskService:AddTask(callback, duration, arguments, isRepeating)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "duration", duration, "number")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "arguments", arguments, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.TaskService:AddTask()", "isRepeating", isRepeating, "boolean", "nil")

    -- Defaults
    arguments = arguments or {}
    isRepeating = isRepeating or false

    -- Increment ID
    self.IncrementalID = self.IncrementalID + 1

    -- Create task
    local task = Noir.Classes.TaskClass:New(self.IncrementalID, duration, isRepeating, arguments)
    task.OnCompletion:Connect(callback)

    self.Tasks[task.ID] = task

    -- Return the task
    return task
end

--[[
    Removes a task.
]]
---@param task NoirTask
function Noir.Services.TaskService:RemoveTask(task)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TaskService:RemoveTask()", "task", task, Noir.Classes.TaskClass)

    -- Remove task
    self.Tasks[task.ID] = nil
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Services\PlayerService.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Services - Player Service
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
    A service that wraps SW players in a class. Essentially makes players OOP.

    local player = Noir.Services.PlayerService:GetPlayer(0)
    player:IsAdmin() -- true
    player:Teleport(matrix.translation(10, 0, 10))

    ---@param player NoirPlayer
    Noir.Services.PlayerService.OnJoin:Once(function(player) -- Ban the first player who joins
        player:Ban()
    end)
]]
---@class NoirPlayerService: NoirService
---@field OnJoin NoirEvent Arguments: player | Fired when a player joins the server
---@field OnLeave NoirEvent Arguments: player | Fired when a player leaves the server
---@field OnDie NoirEvent Arguments: player | Fired when a player dies
---@field OnRespawn NoirEvent Arguments: player | Fired when a player respawns
---@field Players table<integer, NoirPlayer>
---@field JoinCallback NoirConnection A connection to the onPlayerDie event
---@field LeaveCallback NoirConnection A connection to the onPlayerLeave event
---@field DieCallback NoirConnection A connection to the onPlayerDie event
---@field RespawnCallback NoirConnection A connection to the onPlayerRespawn event
Noir.Services.PlayerService = Noir.Services:CreateService(
    "PlayerService",
    true,
    "A service that wraps SW players in a class.",
    "A service that wraps SW players in a class following an OOP format. Player data persistence across addon reloads is also handled, and player-related events are provided.",
    {"Cuh4"}
)

Noir.Services.PlayerService.InitPriority = 1

function Noir.Services.PlayerService:ServiceInit()
    self.OnJoin = Noir.Libraries.Events:Create()
    self.OnLeave = Noir.Libraries.Events:Create()
    self.OnDie = Noir.Libraries.Events:Create()
    self.OnRespawn = Noir.Libraries.Events:Create()

    self.Players = {}

    self:GetSaveData().PlayerProperties = self:_GetSavedProperties() or {}
    self:GetSaveData().RecognizedIDs = self:GetSaveData().RecognizedIDs or {}
end

function Noir.Services.PlayerService:ServiceStart()
    -- Create callbacks
    self.JoinCallback = Noir.Callbacks:Connect("onPlayerJoin", function(steam_id, name, peer_id, admin, auth)
        -- Give data
        local player = self:_GivePlayerData(steam_id, name, peer_id, admin, auth)

        if not player then
            return
        end

        -- Call join event
        self.OnJoin:Fire(player)
    end)

    self.LeaveCallback = Noir.Callbacks:Connect("onPlayerLeave", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just left, but their data couldn't be found.", false)
            return
        end

        -- Remove player
        local success = self:_RemovePlayerData(player)

        if not success then
            Noir.Libraries.Logging:Error("PlayerService", "onPlayerLeave player data removal failed.", false)
            return
        end

        -- Call leave event
        self.OnLeave:Fire(player)
    end)

    self.DieCallback = Noir.Callbacks:Connect("onPlayerDie", function(steam_id, name, peer_id, admin, auth)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just died, but they don't have data.", false)
            return
        end

        -- Call die event
        self.OnDie:Fire(player)
    end)

    self.RespawnCallback = Noir.Callbacks:Connect("onPlayerRespawn", function(peer_id)
        -- Get player
        local player = self:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("PlayerService", "A player just respawned, but they don't have data.", false)
            return
        end

        -- Call respawn event
        self.OnRespawn:Fire(player)
    end)

    -- Load players in game
    if Noir.AddonReason == "AddonReload" then -- Only load players in-game if the addon was reloaded, otherwise onPlayerJoin will be called for the players that join when the save is loaded/created and we can just listen for that
        for _, player in pairs(server.getPlayers()) do
            -- Check if unnamed client
            if player.steam_id == 0 then
                goto continue
            end

            -- Check if already loaded
            if self:GetPlayer(player.id) then
                Noir.Libraries.Logging:Info("PlayerService", "server.getPlayers(): %s already has data. Ignoring.", player.name)
                goto continue
            end

            -- Give data
            local createdPlayer = self:_GivePlayerData(player.steam_id, player.name, player.id, player.admin, player.auth)

            if not createdPlayer then
                Noir.Libraries.Logging:Error("PlayerService", "server.getPlayers(): Player data creation failed.", false)
                goto continue
            end

            -- Load saved properties (eg: permissions)
            local savedProperties = self:_GetSavedPropertiesForPlayer(createdPlayer)

            if savedProperties then
                for property, value in pairs(savedProperties) do
                    createdPlayer[property] = value
                end
            end

            -- Call onJoin if unrecognized
            if not self:_IsRecognized(createdPlayer) then
                self.OnJoin:Fire(createdPlayer)
            end

            ::continue::
        end
    end
end

--[[
    Gives data to a player.<br>
    Used internally.
]]
---@param steam_id integer|string
---@param name string
---@param peer_id integer
---@param admin boolean
---@param auth boolean
---@return NoirPlayer|nil
function Noir.Services.PlayerService:_GivePlayerData(steam_id, name, peer_id, admin, auth)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "steam_id", steam_id, "number", "string")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "peer_id", peer_id, "number")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "admin", admin, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GivePlayerData()", "auth", auth, "boolean")

    -- Check if the player is the server itself (applies to dedicated servers)
    if self:_IsHost(peer_id) then
        return
    end

    -- Check if player already exists
    if self:GetPlayer(peer_id) then
        Noir.Libraries.Logging:Error("PlayerService", "Attempted to give player data to an existing player. This player has been ignored.", false)
        return
    end

    -- Create player
    local player = Noir.Classes.PlayerClass:New(
        name,
        peer_id,
        tostring(steam_id),
        admin,
        auth,
        {}
    )

    -- Save player
    self.Players[peer_id] = player

    -- Save peer ID so we know if we can call onJoin for this player or not if the addon reloads
    self:_MarkRecognized(player)

    -- Return
    return player
end

--[[
    Removes data for a player.<br>
    Used internally.
]]
---@param player NoirPlayer
---@return boolean success Whether or not the operation was successful
function Noir.Services.PlayerService:_RemovePlayerData(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_RemovePlayerData()", "player", player, Noir.Classes.PlayerClass)

    -- Check if player exists in this service
    if not self:GetPlayer(player.ID) then
        Noir.Libraries.Logging:Error("PlayerService", "Attempted to remove player data from a non-existent player.", false)
        return false
    end

    -- Remove player
    self.Players[player.ID] = nil

    -- Remove saved properties
    self:_RemoveSavedProperties(player)

    -- Unmark as recognized
    self:_UnmarkRecognized(player)

    return true
end

--[[
    Returns whether or not a player is the server's host. Only applies in dedicated servers.<br>
    Used internally.
]]
---@param peer_id integer
---@return boolean
function Noir.Services.PlayerService:_IsHost(peer_id)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_IsHost()", "peer_id", peer_id, "number")

    -- Return true if the provided peer_id is that of the server host player
    return peer_id == 0 and Noir.IsDedicatedServer
end

--[[
    Mark a player as recognized to prevent onJoin being called for them after an addon reload.<br>
    Used internally.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_MarkRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_MarkRecognized()", "player", player, Noir.Classes.PlayerClass)

    -- Mark as recognized
    self:GetSaveData().RecognizedIDs[player.ID] = true
end

--[[
    Returns whether or not a player is recognized.<br>
    Used internally.
]]
---@param player NoirPlayer
---@return boolean
function Noir.Services.PlayerService:_IsRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_IsRecognized()", "player", player, Noir.Classes.PlayerClass)

    -- Return true if recognized
    return self:GetSaveData().RecognizedIDs[player.ID] ~= nil
end

--[[
    Mark a player as not recognized.<br>
    Used internally.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_UnmarkRecognized(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_UnmarkRecognized()", "player", player, Noir.Classes.PlayerClass)

    -- Remove from recognized
    self:GetSaveData().RecognizedIDs[player.ID] = nil
end

--[[
    Returns all saved player properties saved in g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSavedPlayerProperties
function Noir.Services.PlayerService:_GetSavedProperties()
    return self:GetSaveData().PlayerProperties
end

--[[
    Save a player's property to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@param property string
function Noir.Services.PlayerService:_SaveProperty(player, property)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_SaveProperty()", "player", player, Noir.Classes.PlayerClass)
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_SaveProperty()", "property", property, "string")

    -- Property saving
    local properties = self:_GetSavedProperties()

    if not properties[player.ID] then
        properties[player.ID] = {}
    end

    properties[player.ID][property] = player[property]
end

--[[
    Get a player's saved properties.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@return table<string, boolean>|nil
function Noir.Services.PlayerService:_GetSavedPropertiesForPlayer(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_GetSavedPropertiesForPlayer()", "player", player, Noir.Classes.PlayerClass)

    -- Return saved properties for player
    return self:_GetSavedProperties()[player.ID]
end

--[[
    Removes a player's saved properties from g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_RemoveSavedProperties(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:_RemoveSavedProperties()", "player", player, Noir.Classes.PlayerClass)

    -- Remove saved properties
    local properties = self:_GetSavedProperties()
    properties[player.ID] = nil
end

--[[
    Returns all players.<br>
    This is the preferred way to get all players instead of using `Noir.Services.PlayerService.Players`.
]]
---@return table<integer, NoirPlayer>
function Noir.Services.PlayerService:GetPlayers()
    return self.Players
end

--[[
    Returns a player by their peer ID.<br>
    This is the preferred way to get a player.
]]
---@param ID integer
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayer(ID)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayer()", "ID", ID, "number")

    -- Get player
    return self:GetPlayers()[ID]
end

--[[
    Returns a player by their Steam ID.<br>
    Note that two players or more can have the same Steam ID if they spoof their Steam ID or join the server on two Stormworks instances.
]]
---@param steam string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerBySteam(steam)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayerBySteam()", "steam", steam, "string")

    -- Get player
    for _, player in pairs(self:GetPlayers()) do
        if player.Steam == steam then
            return player
        end
    end
end

--[[
    Returns a player by their exact name.<br>
    Consider using `:SearchPlayerByName()` if the player name only needs to match partially.
]]
---@param name string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerByName(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:GetPlayerByName()", "name", name, "string")

    -- Get player
    for _, player in pairs(self:GetPlayers()) do
        if player.Name == name then
            return player
        end
    end
end

--[[
    Searches for a player by their name, similar to a Google search but way simpler under the hood.
]]
---@param name string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:SearchPlayerByName(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:SearchPlayerByName()", "name", name, "string")

    -- Get player
    for _, player in pairs(self:GetPlayers()) do
        if player.Name:lower():gsub(" ", ""):find(name:lower():gsub(" ", "")) then
            return player
        end
    end
end

--[[
    Returns whether or not two players are the same.
]]
---@param playerA NoirPlayer
---@param playerB NoirPlayer
---@return boolean
function Noir.Services.PlayerService:IsSamePlayer(playerA, playerB)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:IsSamePlayer()", "playerA", playerA, Noir.Classes.PlayerClass)
    Noir.TypeChecking:Assert("Noir.Services.PlayerService:IsSamePlayer()", "playerB", playerB, Noir.Classes.PlayerClass)

    -- Return if both players are the same
    return playerA.ID == playerB.ID
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirSavedPlayerProperties table<integer, table<string, any>>

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Services\ObjectService.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Services - Object Service
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
    A service for wrapping SW objects in classes.

    local object_id = 5
    local object = Noir.Services.ObjectService:GetObject(object_id)

    object:GetData()
    object:Despawn()
    object:GetPosition()
    object:Teleport()

    object.OnLoad:Connect(function()
        -- Code
    end)

    object.OnUnload:Connect(function()
        -- Code
    end)
]]
---@class NoirObjectService: NoirService
---@field Objects table<integer, NoirObject> A table containing all objects
---@field OnRegister NoirEvent Fired when an object is registered (first arg: NoirObject)
---@field OnUnregister NoirEvent Fired when an object is unregistered (first arg: NoirObject)
---@field OnLoad NoirEvent Fired when an object is loaded (first arg: NoirObject)
---@field OnUnload NoirEvent Fired when an object is unloaded (first arg: NoirObject)
---
---@field OnLoadConnection NoirConnection A connection to the onObjectLoad game callback
---@field OnUnloadConnection NoirConnection A connection to the onObjectUnload game callback
Noir.Services.ObjectService = Noir.Services:CreateService(
    "ObjectService",
    true,
    "A service for wrapping SW objects in classes.",
    "A service for wrapping SW objects in classes as well as providing useful object-related utilities.",
    {"Cuh4"}
)

function Noir.Services.ObjectService:ServiceInit()
    self.Objects = {}

    self.OnRegister = Noir.Libraries.Events:Create()
    self.OnUnregister = Noir.Libraries.Events:Create()
    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
end

function Noir.Services.ObjectService:ServiceStart()
    -- Load saved objects
    for _, object in pairs(self:_GetSavedObjects()) do
        self:RegisterObject(object.ID, true)
    end

    -- Listen for object loading/unloading
    self.OnLoadConnection = Noir.Callbacks:Connect("onObjectLoad", function(object_id)
        -- Get object
        local object = self:GetObject(object_id) -- creates an object if it doesn't already exist

        if not object then
            Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in OnLoadConnection callback.", false)
            return
        end

        -- Fire event, set loaded
        object.Loaded = true
        object.OnLoad:Fire()
        self.OnLoad:Fire(object)

        -- Save
        self:_SaveObjectSavedata(object)
    end)

    self.OnUnloadConnection = Noir.Callbacks:Connect("onObjectUnload", function(object_id)
        -- Get object
        local object = self:GetObject(object_id)

        if not object then
            Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in OnUnloadConnection callback.", false)
            return
        end

        -- Fire events, set loaded
        object.Loaded = false
        object.OnUnload:Fire()
        self.OnUnload:Fire(object)

        -- Remove from g_savedata if the object was removed and unloaded, otherwise save
        Noir.Services.TaskService:AddTask(function()
            if not object:Exists() then
                self:_RemoveObjectSavedata(object.ID)
            else
                self:_SaveObjectSavedata(object)
            end
        end, 0.01) -- untested, but this delay might be needed in case the object is unloaded first, then removed
    end)
end

--[[
    Overwrite saved objects.<br>
    Used internally. Do not use in your code.
]]
---@param objects table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_SaveObjects(objects)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_SaveObjects()", "objects", objects, "table")

    -- Save to g_savedata
    self:Save("objects", objects)
end

--[[
    Get saved objects.<br>
    Used internally. Do not use in your code.
]]
---@return table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_GetSavedObjects()
    return Noir.Libraries.Table:Copy(self:Load("objects", {}))
end

--[[
    Save an object to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param object NoirObject
function Noir.Services.ObjectService:_SaveObjectSavedata(object)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_SaveObjectSavedata()", "object", object, Noir.Classes.ObjectClass)

    -- Save to g_savedata
    local saved = self:_GetSavedObjects()
    saved[object.ID] = object:_Serialize()

    self:_SaveObjects(saved)
end

--[[
    Remove an object from g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param object_id integer
function Noir.Services.ObjectService:_RemoveObjectSavedata(object_id)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:_RemoveObjectSavedata()", "object_id", object_id, "number")

    -- Remove from g_savedata
    local saved = self:_GetSavedObjects()
    saved[object_id] = nil

    self:_SaveObjects(saved)
end

--[[
    Get all objects.
]]
---@return table<integer, NoirObject>
function Noir.Services.ObjectService:GetObjects()
    return Noir.Libraries.Table:Copy(self.Objects)
end

--[[
    Registers an object by ID.
]]
---@param object_id integer
---@param _preventEventTrigger boolean|nil
---@return NoirObject|nil
function Noir.Services.ObjectService:RegisterObject(object_id, _preventEventTrigger)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:RegisterObject()", "object_id", object_id, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:RegisterObject()", "_preventEventTrigger", _preventEventTrigger, "boolean", "nil")

    -- Check if the object exists and is loaded
    local loaded, exists = server.getObjectSimulating(object_id)

    if not exists then
        self:_RemoveObjectSavedata(object_id) -- prevent memory leak
        return
    end

    -- Create object
    local object = Noir.Classes.ObjectClass:New(object_id)
    object.Loaded = loaded

    self.Objects[object_id] = object

    -- Fire event
    if not _preventEventTrigger then -- this is here for objects that are being registered from g_savedata
        self.OnRegister:Fire(object)
    end

    -- Save to g_savedata
    self:_SaveObjectSavedata(object)

    -- Remove on object despawn
    object.OnDespawn:Once(function()
        self:RemoveObject(object_id)
    end)

    -- Return
    return object
end

--[[
    Returns the object with the given ID.
]]
---@param object_id integer
---@return NoirObject|nil
function Noir.Services.ObjectService:GetObject(object_id)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:GetObject()", "object_id", object_id, "number")

    -- Get object
    return self.Objects[object_id] or self:RegisterObject(object_id)
end

--[[
    Removes the object with the given ID.
]]
---@param object_id integer
function Noir.Services.ObjectService:RemoveObject(object_id)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:RemoveObject()", "object_id", object_id, "number")

    -- Get object
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", "Failed to get object in :RemoveObject().", false)
        return
    end

    -- Fire event
    self.OnUnregister:Fire(object)

    -- Remove object
    self.Objects[object_id] = nil

    -- Remove from g_savedata
    self:_RemoveObjectSavedata(object_id)
end

--[[
    Spawn an object.
]]
---@param objectType SWObjectTypeEnum
---@param position SWMatrix
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnObject(objectType, position)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnObject()", "objectType", objectType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnObject()", "position", position, "table")

    -- Spawn the object
    local object_id, success = server.spawnObject(position, objectType)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnObject() failed due to server.spawnObject() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnObject().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn a character.
]]
---@param outfitType SWOutfitTypeEnum
---@param position SWMatrix
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnCharacter(outfitType, position)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCharacter()", "outfitType", outfitType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCharacter()", "position", position, "table")

    -- Spawn the character
    local object_id, success = server.spawnCharacter(position, outfitType)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnCharacter() failed due to server.spawnCharacter() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnCharacter().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn a creature.
]]
---@param creatureType SWCreatureTypeEnum
---@param position SWMatrix
---@param sizeMultiplier number|nil Default: 1
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnCreature(creatureType, position, sizeMultiplier)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCreature()", "creatureType", creatureType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCreature()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnCreature()", "sizeMultiplier", sizeMultiplier, "number", "nil")

    -- Spawn the creature
    local object_id, success = server.spawnCreature(position, creatureType, sizeMultiplier or 1)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnCreature() failed due to server.spawnCreature() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnCreature().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn an animal.
]]
---@param animalType SWAnimalTypeEnum
---@param position SWMatrix
---@param sizeMultiplier number|nil Default: 1
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnAnimal(animalType, position, sizeMultiplier)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnAnimal()", "animalType", animalType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnAnimal()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnAnimal()", "sizeMultiplier", sizeMultiplier, "number", "nil")

    -- Spawn the animal
    local object_id, success = server.spawnAnimal(position, animalType, sizeMultiplier or 1)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnAnimal() failed due to server.spawnAnimal() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnAnimal().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn an equipment item.
]]
---@param equipmentType SWEquipmentTypeEnum
---@param position SWMatrix
---@param int integer
---@param float integer
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnEquipment(equipmentType, position, int, float)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "equipmentType", equipmentType, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "int", int, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnEquipment()", "float", float, "number")

    -- Spawn the equipment
    local object_id, success = server.spawnEquipment(position, equipmentType, int, float)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnEquipment() failed due to server.spawnEquipment() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnEquipment().", false)
        return
    end

    -- Return
    return object
end

--[[
    Spawn a fire.
]]
---@param position SWMatrix
---@param size number 0 - 10
---@param magnitude number -1 explodes instantly. Nearer to 0 means the explosion takes longer to happen. Must be below 0 for explosions to work.
---@param isLit boolean Lights the fire. If the magnitude is >1, this will need to be true for the fire to first warm up before exploding.
---@param isExplosive boolean
---@param parentVehicleID integer|nil
---@param explosionMagnitude number The size of the explosion (0-5)
---@return NoirObject|nil
function Noir.Services.ObjectService:SpawnFire(position, size, magnitude, isLit, isExplosive, parentVehicleID, explosionMagnitude)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "size", size, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "magnitude", magnitude, "number")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "isLit", isLit, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "isExplosive", isExplosive, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "parentVehicleID", parentVehicleID, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.ObjectService:SpawnFire()", "explosionMagnitude", explosionMagnitude, "number")

    -- Spawn the fire
    local object_id, success = server.spawnFire(position, size, magnitude, isLit, isExplosive, parentVehicleID or 0, explosionMagnitude)

    if not success then
        Noir.Libraries.Logging:Error("ObjectService", ":SpawnFire() failed due to server.spawnFire() being unsuccessful.", false)
        return
    end

    -- Wrap object in a class
    local object = self:GetObject(object_id)

    if not object then
        Noir.Libraries.Logging:Error("ObjectService", ":GetObject() returned nil in :SpawnFire().", false)
        return
    end

    -- Return
    return object
end


----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Services\GameSettingsService.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Services - Game Settings Service
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
    A service for changing and accessing the game's settings.

    Noir.Services.GameSettingsService:GetSetting("infinite_batteries") -- false
    Noir.Services.GameSettingsService:SetSetting("infinite_batteries", true)
]]
---@class NoirGameSettingsService: NoirService
Noir.Services.GameSettingsService = Noir.Services:CreateService(
    "GameSettingsService",
    true,
    "A basic service for changing and accessing the game's settings.",
    nil,
    {"Cuh4"}
)

--[[
    Returns a list of all game settings.
]]
---@return SWGameSettings
function Noir.Services.GameSettingsService:GetSettings()
    return server.getGameSettings()
end

--[[
    Returns the value of the provided game setting.

    Noir.Services.GameSettingsService:GetSetting("infinite_batteries") -- false
]]
---@param name SWGameSettingEnum
---@return any
function Noir.Services.GameSettingsService:GetSetting(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.GameSettingsService:GetSetting()", "name", name, "string")

    -- Get a setting
    local settings = self:GetSettings()
    local setting = settings[name]

    if setting == nil then
        Noir.Libraries.Logging:Error("GameSettingsService", "GetSetting(): %s is not a valid game setting.", false, name)
        return
    end

    return setting
end

--[[
    Sets the value of the provided game setting.

    Noir.Services.GameSettingsService:SetSetting("infinite_batteries", true)
]]
---@param name SWGameSettingEnum
---@param value any
function Noir.Services.GameSettingsService:SetSetting(name, value)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.GameSettingsService:SetSetting()", "name", name, "string")

    -- Set the setting
    if self:GetSettings()[name] == nil then
        Noir.Libraries.Logging:Error("GameSettingsService", "SetSetting(): %s is not a valid game setting.", false, name)
        return
    end

    server.setGameSetting(name, value)
end

----------------------------------------------
-- // [File] ..\src\Noir\Built-Ins/Services\CommandService.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Services - Command Service
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
    A service for easily creating commands with support for command aliases, permissions, etc.

    Noir.Services.CommandService:CreateCommand("info", {"i"}, {"Nerd"}, false, false, false, "Shows random information.", function(player, message, args, hasPermission)
        if not hasPermission then
            server.announce("Server", "Sorry, you don't have permission to use this command. Try again though.", player.ID)
            player:SetPermission("Nerd")
            return
        end

        server.announce("Info", "This addon uses Noir!")
    end)
]]
---@class NoirCommandService: NoirService
---@field Commands table<string, NoirCommand>
---@field OnCustomCommand NoirConnection Represents the connection to the OnCustomCommand game callback
Noir.Services.CommandService = Noir.Services:CreateService(
    "CommandService",
    true,
    "A service that allows you to create commands.",
    "A service that allows you to create commands with support for aliases, permissions, etc.",
    {"Cuh4"}
)

function Noir.Services.CommandService:ServiceInit()
    self.Commands = {}
end

function Noir.Services.CommandService:ServiceStart()
    self.OnCustomCommand = Noir.Callbacks:Connect("onCustomCommand", function(message, peer_id, _, _, commandName, ...)
        -- Get the player
        local player = Noir.Services.PlayerService:GetPlayer(peer_id)

        if not player then
            Noir.Libraries.Logging:Error("CommandService", "A player ran a command, but they aren't recognized as a player in the PlayerService", false)
            return
        end

        -- Remove ? prefix
        commandName = commandName:sub(2)

        -- Get the command
        local command = self:FindCommand(commandName)

        if not command then
            return
        end

        -- Trigger the command
        command:_Use(player, message, {...})
    end)
end

--[[
    Get a command by the name or alias.
]]
---@param query string
---@return NoirCommand|nil
function Noir.Services.CommandService:FindCommand(query)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:FindCommand()", "query", query, "string")

    -- Find the command
    for _, command in pairs(self:GetCommands()) do
        if command:_Matches(query) then
            return command
        end
    end
end

--[[
    Create a new command.

    Noir.Services.CommandService:CreateCommand("help", {"h"}, {"Nerd"}, false, false, false, "Example Command", function(player, message, args, hasPermission)
        if not hasPermission then
            player:Notify("Lacking Permissions", "Sorry, you don't have permission to run this command. Try again.", 3)
            player:SetPermission("Nerd")
            return
        end

        player:Notify("Help", "TODO: Add a help message", 4)
    end)
]]
---@param name string The name of the command (eg: if you provided "help", the player would need to type "?help" in chat)
---@param aliases table<integer, string> The aliases of the command
---@param requiredPermissions table<integer, string>|nil The required permissions for this command
---@param requiresAuth boolean|nil Whether or not this command requires auth
---@param requiresAdmin boolean|nil Whether or not this command requires admin
---@param capsSensitive boolean|nil Whether or not this command is case-sensitive
---@param description string|nil The description of this command
---@param callback fun(player: NoirPlayer, message: string, args: table<integer, string>, hasPermission: boolean)
---@return NoirCommand
function Noir.Services.CommandService:CreateCommand(name, aliases, requiredPermissions, requiresAuth, requiresAdmin, capsSensitive, description, callback)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "aliases", aliases, "table")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "requiredPermissions", requiredPermissions, "table", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "requiresAuth", requiresAuth, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "requiresAdmin", requiresAdmin, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "capsSensitive", capsSensitive, "boolean", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "description", description, "string", "nil")
    Noir.TypeChecking:Assert("Noir.Services.CommandService:CreateCommand()", "callback", callback, "function")

    -- Create command
    local command = Noir.Classes.CommandClass:New(name, aliases, requiredPermissions or {}, requiresAuth or false, requiresAdmin or false, capsSensitive or false, description or "")

    -- Connect to event
    command.OnUse:Connect(callback)

    -- Save and return
    self.Commands[name] = command
    return command
end

--[[
    Get a command by the name.
]]
---@param name string
---@return NoirCommand|nil
function Noir.Services.CommandService:GetCommand(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:GetCommand()", "name", name, "string")

    -- Return the command
    return self.Commands[name]
end

--[[
    Remove a command.
]]
---@param name string
function Noir.Services.CommandService:RemoveCommand(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.CommandService:RemoveCommand()", "name", name, "string")

    -- Remove the command
    self.Commands[name] = nil
end

--[[
    Returns all commands.
]]
---@return table<string, NoirCommand>
function Noir.Services.CommandService:GetCommands()
    return self.Commands
end

----------------------------------------------
-- // [File] ..\src\Noir\Callbacks.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Callbacks
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
    A module of Noir that allows you to attach multiple functions to game callbacks.<br>
    These functions can be disconnected from the game callbacks at any time.

    Noir.Callbacks:Connect("onPlayerJoin", function()
        server.announce("Server", "A player joined!")
    end)

    Noir.Callbacks:Once("onPlayerJoin", function()
        server.announce("Server", "A player joined! (once) This will never be shown again.")
    end)
]]
Noir.Callbacks = {}

--[[
    A table of events assigned to game callbacks.<br>
    Do not directly modify this table.
]]
Noir.Callbacks.Events = {} ---@type table<string, NoirEvent>

--[[
    Connect to a game callback.

    Noir.Callbacks:Connect("onPlayerJoin", function()
        -- Code here
    end)
]]
---@param name string
---@param callback function
---@param hideStartWarning boolean|nil
---@return NoirConnection
---@overload fun(self, name: "onClearOilSpill", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTick", callback: fun(game_ticks: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreate", callback: fun(is_world_create: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onDestroy", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCustomCommand", callback: fun(full_message: string, peer_id: number, is_admin: boolean, is_auth: boolean, command: string, ...: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onChatMessage", callback: fun(peer_id: number, sender_name: string, message: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerJoin", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerSit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerUnsit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterPickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreaturePickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentPickup", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentDrop", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerRespawn", callback: fun(peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerLeave", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onToggleMap", callback: fun(peer_id: number, is_open: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerDie", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleSpawn", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number, group_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onGroupSpawn", callback: fun(group_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDespawn", callback: fun(vehicle_id: integer, peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleLoad", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleUnload", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleTeleport", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectLoad", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectUnload", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onButtonPress", callback: fun(vehicle_id: integer, peer_id: number, button_name: string, is_pressed: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onSpawnAddonComponent", callback: fun(vehicle_or_object_id: integer, component_name: string, type_string: string, addon_index: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDamaged", callback: fun(vehicle_id: integer, damage_amount: number, voxel_x: number, voxel_y: number, voxel_z: number, body_index: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "httpReply", callback: fun(port: number, request: string, reply: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onFireExtinguished", callback: fun(fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireSpawned", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireExtinguished", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTornado", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onMeteor", callback: fun(transform: SWMatrix, magnitude), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTsunami", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onWhirlpool", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVolcano", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onOilSpill", callback: fun(tile_x: number, tile_z: number, delta: number, total: number, vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
function Noir.Callbacks:Connect(name, callback, hideStartWarning)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:Connect()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Callbacks:Connect()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Callbacks:Connect()", "hideStartWarning", hideStartWarning, "boolean", "nil")

    -- Get or create event
    local event = self:_InstantiateCallback(name, hideStartWarning or false)

    -- Connect callback to event
    return event:Connect(callback)
end

--[[
    Connect to a game callback, but disconnect after the game callback has been called.

    Noir.Callbacks:Once("onPlayerJoin", function()
        -- Code here
    end)
]]
---@param name string
---@param callback function
---@param hideStartWarning boolean|nil
---@return NoirConnection
---@overload fun(self, name: "onClearOilSpill", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTick", callback: fun(game_ticks: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreate", callback: fun(is_world_create: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onDestroy", callback: fun(), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCustomCommand", callback: fun(full_message: string, peer_id: number, is_admin: boolean, is_auth: boolean, command: string, ...: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onChatMessage", callback: fun(peer_id: number, sender_name: string, message: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerJoin", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerSit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerUnsit", callback: fun(peer_id: number, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCharacterPickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureSit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreatureUnsit", callback: fun(object_id: integer, vehicle_id: integer, seat_name: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onCreaturePickup", callback: fun(object_id_actor: integer, object_id_target: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentPickup", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onEquipmentDrop", callback: fun(character_object_id: integer, equipment_object_id: integer, equipment_id: SWEquipmentTypeEnum), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerRespawn", callback: fun(peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerLeave", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onToggleMap", callback: fun(peer_id: number, is_open: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onPlayerDie", callback: fun(steam_id: number, name: string, peer_id: number, is_admin: boolean, is_auth: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleSpawn", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number, group_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onGroupSpawn", callback: fun(group_id: integer, peer_id: number, x: number, y: number, z: number, group_cost: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDespawn", callback: fun(vehicle_id: integer, peer_id: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleLoad", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleUnload", callback: fun(vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleTeleport", callback: fun(vehicle_id: integer, peer_id: number, x: number, y: number, z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectLoad", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onObjectUnload", callback: fun(object_id: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onButtonPress", callback: fun(vehicle_id: integer, peer_id: number, button_name: string, is_pressed: boolean), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onSpawnAddonComponent", callback: fun(vehicle_or_object_id: integer, component_name: string, type_string: string, addon_index: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVehicleDamaged", callback: fun(vehicle_id: integer, damage_amount: number, voxel_x: number, voxel_y: number, voxel_z: number, body_index: integer), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "httpReply", callback: fun(port: number, request: string, reply: string), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onFireExtinguished", callback: fun(fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireSpawned", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onForestFireExtinguished", callback: fun(fire_objective_id: number, fire_x: number, fire_y: number, fire_z: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTornado", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onMeteor", callback: fun(transform: SWMatrix, magnitude), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onTsunami", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onWhirlpool", callback: fun(transform: SWMatrix, magnitude: number), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onVolcano", callback: fun(transform: SWMatrix), hideStartWarning: boolean?): NoirConnection
---@overload fun(self, name: "onOilSpill", callback: fun(tile_x: number, tile_z: number, delta: number, total: number, vehicle_id: integer), hideStartWarning: boolean?): NoirConnection
function Noir.Callbacks:Once(name, callback, hideStartWarning)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:Once()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Callbacks:Once()", "callback", callback, "function")
    Noir.TypeChecking:Assert("Noir.Callbacks:Once()", "hideStartWarning", hideStartWarning, "boolean", "nil")

    -- Get or create event
    local event = self:_InstantiateCallback(name, hideStartWarning or false)

    -- Connect callback to event
    return event:Once(callback)
end

--[[
    Get a game callback event. These events may not exist if `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` was not called for them.<br>
    It's best to use `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` instead of getting a callback event directly and connecting to it.

    local event = Noir.Callbacks:Get("onPlayerJoin") -- can be nil! use Noir.Callbacks:Connect() or Noir.Callbacks:Once() instead to guarantee an event

    event:Connect(function()
        server.announce("Server", "A player joined!")
    end)
]]
---@param name string
---@return NoirEvent
function Noir.Callbacks:Get(name)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:Get()", "name", name, "string")

    -- Return
    return self.Events[name]
end

--[[
    Creates an event and an _ENV function for a game callback.<br>
    Used internally, do not use this in your addon.
]]
---@param name string
---@param hideStartWarning boolean
---@return NoirEvent
function Noir.Callbacks:_InstantiateCallback(name, hideStartWarning)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Callbacks:_InstantiateCallback()", "name", name, "string")
    Noir.TypeChecking:Assert("Noir.Callbacks:_InstantiateCallback()", "hideStartWarning", hideStartWarning, "boolean")

    -- Check if Noir has started
    if not Noir.HasStarted and not hideStartWarning then
        Noir.Libraries.Logging:Warning("Callbacks", "Noir has not started yet. It is not recommended to connect to callbacks before `Noir:Start()` is called and finalized. Please connect to the `Noir.Started` event and attach to game callbacks in that.")
    end

    -- For later
    local event = Noir.Callbacks.Events[name]

    -- Stop here if the event already exists
    if event then
        return event
    end

    -- Create event if it doesn't exist
    if not event then
        event = Noir.Libraries.Events:Create()
        self.Events[name] = event
    end

    -- Create function for game callback if it doesn't exist. If the user created the callback themselves, overwrite it
    local existing = _ENV[name]

    if existing then
        -- Inform developer that a function for a game callback already exists
        Noir.Libraries.Logging:Warning("Callbacks", "Your addon has a function for the game callback '%s'. Noir will wrap around it to prevent overwriting. Please use `Noir.Callbacks:Connect(\"%s\", function(...) end)` instead of `function %s(...) end` function to avoid this warning.", name, name, name)

        -- Wrap around existing function
        _ENV[name] = function(...)
            existing(...)
            event:Fire(...)
        end
    else
        -- Create function for game callback
        _ENV[name] = function(...)
            event:Fire(...)
        end
    end

    -- Return event
    return event
end

----------------------------------------------
-- // [File] ..\src\Noir\Bootstrapper.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Bootstrapper
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
    An internal module of Noir that is used to initialize and start services.<br>
    Do not use this in your code.
]]
Noir.Bootstrapper = {}

--[[
    Set up g_savedata.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:InitializeSavedata()
    -- Setup g_savedata
    g_savedata.Noir = g_savedata.Noir or {}
    Noir.Libraries.Logging:Info("Bootstrapper", "'Noir' has been defined in g_savedata.")

    g_savedata.Noir.Services = g_savedata.Noir.Services or {}
    Noir.Libraries.Logging:Info("Bootstrapper", "'Services' has been defined in Noir savedata.")
end

--[[
    Initialize all services.<br>
    This will order services by their `InitPriority` and then initialize them.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:InitializeServices()
    -- Calculate order of service initialization
    local servicesToInit = Noir.Libraries.Table:Values(Noir.Services.CreatedServices)
    local lowestInitPriority = 0

    for _, service in pairs(servicesToInit) do
        local priority = service.InitPriority ~= nil and service.InitPriority or 0

        if priority >= lowestInitPriority then
            lowestInitPriority = priority
        end
    end

    for _, service in pairs(servicesToInit) do
        if not service.InitPriority then
            service.InitPriority = lowestInitPriority + 1
            lowestInitPriority = lowestInitPriority + 1
        end
    end

    ---@param serviceA NoirService
    ---@param serviceB NoirService
    table.sort(servicesToInit, function(serviceA, serviceB)
        return serviceA.InitPriority < serviceB.InitPriority
    end)

    -- Initialize services
    for _, service in pairs(servicesToInit) do
        Noir.Libraries.Logging:Info("Bootstrapper", "Initializing %s of priority %d.", Noir.Services:FormatService(service), service.InitPriority)
        service:_Initialize()
    end
end

--[[
    Start all services.<br>
    This will order services by their `StartPriority` and then start them.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:StartServices()
    -- Calculate order of service start
    local servicesToStart = Noir.Libraries.Table:Values(Noir.Services.CreatedServices)
    local lowestStartPriority = 0

    for _, service in pairs(servicesToStart) do
        local priority = service.StartPriority ~= nil and service.StartPriority or 0

        if priority >= lowestStartPriority then
            lowestStartPriority = priority
        end
    end

    for _, service in pairs(servicesToStart) do
        if not service.StartPriority then
            service.StartPriority = lowestStartPriority + 1
            lowestStartPriority = lowestStartPriority + 1
        end
    end

    ---@param serviceA NoirService
    ---@param serviceB NoirService
    table.sort(servicesToStart, function(serviceA, serviceB)
        return serviceA.StartPriority < serviceB.StartPriority
    end)

    -- Start services
    for _, service in pairs(servicesToStart) do
        Noir.Libraries.Logging:Info("Bootstrapper", "Starting %s of priority %d.", Noir.Services:FormatService(service), service.StartPriority)
        service:_Start()
    end
end

--[[
    Determines whether or not the server this addon is being ran in is a dedicated server.<br>
    This evaluation is then used to set `Noir.IsDedicatedServer`.<br>
    Do not use this in your code. This is used internally.
]]
function Noir.Bootstrapper:SetIsDedicatedServer()
    local host = server.getPlayers()[1]
    Noir.IsDedicatedServer = host and (host.steam_id == 0 and host.object_id == nil)
end

----------------------------------------------
-- // [File] ..\src\Noir\Noir.lua
----------------------------------------------
--------------------------------------------------------
-- [Noir] Noir
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
    The current version of Noir.<br>
    Follows [Semantic Versioning.](https://semver.org)
]]
Noir.Version = "1.10.0"

--[[
    Returns the MAJOR, MINOR, and PATCH of the current Noir version.

    major, minor, patch = Noir:GetVersion()
]]
---@return string major The MAJOR part of the version
---@return string minor The MINOR part of the version
---@return string patch The PATCH part of the version
function Noir:GetVersion()
    return table.unpack(Noir.Libraries.String:Split(self.Version, "."))
end

--[[
    This event is called when the framework is started.<br>
    Use this event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)
]]
Noir.Started = Noir.Libraries.Events:Create()

--[[
    This represents whether or not the framework has started.
]]
Noir.HasStarted = false

--[[
    This represents whether or not the framework is starting.
]]
Noir.IsStarting = false

--[[
    This represents whether or not the addon is being ran in a dedicated server.
]]
Noir.IsDedicatedServer = false

--[[
    This represents whether or not the addon was:<br>
    - Reloaded<br>
    - Started via a save being loaded<br>
    - Started via a save creation
]]
Noir.AddonReason = "AddonReload" ---@type NoirAddonReason

--[[
    Starts the framework.<br>
    This will initialize all services, then upon completion, all services will be started.<br>
    Use the `Noir.Started` event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)

    Noir:Start()
]]
function Noir:Start()
    -- Checks
    if self.IsStarting then
        self.Libraries.Logging:Error("Start", "The addon attempted to start Noir when it is in the process of starting.", true)
        return
    end

    if self.HasStarted then
        self.Libraries.Logging:Error("Start", "The addon attempted to start Noir more than once.", true)
        return
    end

    -- Function to setup everything
    ---@param startTime number
    ---@param isSaveCreate boolean
    local function setup(startTime, isSaveCreate)
        -- Wait until onTick is first called to determine if the addon was reloaded, or if a save with the addon was loaded/created
        self.Callbacks:Once("onTick", function()
            -- Determine the addon reason
            local took = server.getTimeMillisec() - startTime
            self.AddonReason = isSaveCreate and "SaveCreate" or (took < 1000 and "AddonReload" or "SaveLoad")

            self.IsStarting = false
            self.HasStarted = true

            -- Set Noir.IsDedicatedServer
            self.Bootstrapper:SetIsDedicatedServer()

            -- Initialize g_savedata
            self.Bootstrapper:InitializeSavedata()

            -- Initialize services, then start them
            self.Bootstrapper:InitializeServices()
            self.Bootstrapper:StartServices()

            -- Fire event
            self.Started:Fire()

            -- Send log
            self.Libraries.Logging:Success("Start", "Noir v%s has started. Bootstrapper has initialized and started all services.\nTook: %sms | Addon Reason: %s", self.Version, took, Noir.AddonReason)

            -- Send log on addon stop
            self.Callbacks:Once("onDestroy", function()
                local addonData = server.getAddonData((server.getAddonIndex()))
                self.Libraries.Logging:Info("Stop", "%s, using Noir v%s, has stopped.", addonData.name, self.Version)
            end)
        end, true)
    end

    self.IsStarting = true

    -- Wait for onCreate, then setup
    self.Callbacks:Once("onCreate", function(isSaveCreate)
        setup(server.getTimeMillisec(), isSaveCreate)
    end, true)

    -- Send log
    self.Libraries.Logging:Info("Start", "Waiting for onCreate game event to fire before setting up Noir.")
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirAddonReason
---| "AddonReload"
---| "SaveCreate"
---| "SaveLoad"