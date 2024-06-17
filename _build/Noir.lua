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
        return type(other) == "table" and other.ClassName ~= nil and self.ClassName == other.ClassName
    end

    return class
end

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
        Noir.Libraries.Logging:Error("Event Connection", "Attempted to fire an event connection when it is not connected.", true)
        return
    end

    self.Callback(...)
end

--[[
    Disconnects the callback from the event.
]]
function Noir.Classes.ConnectionClass:Disconnect()
    if not self.Connected then
        Noir.Libraries.Logging:Error("Event Connection", "Attempted to disconnect an event connection when it is not connected.", true)
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
    self.IsFiring = true

    for _, connection_id in ipairs(self.ConnectionsOrder) do
        self.Connections[connection_id]:Fire(...)
    end

    self.IsFiring = false

    -- Reverse iteration is more performant, as we have on book-keeping stuff we already plan to remove
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
    self.CurrentID = self.CurrentID + 1

    local connection = Noir.Classes.ConnectionClass:New(callback)
    self.Connections[self.CurrentID] = connection

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
    **Should only be used internally.**<br>
    Finalizes the connection to the event, allowing it to be run.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:_ConnectFinalize(connection)
    table.insert(self.ConnectionsOrder, connection.ID)

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
    local connection

    connection = self:Connect(function(...)
        callback(...)
        connection:Disconnect()
    end)

    return connection
end

--[[
    Disconnects the provided connection from the event.<br>
    The disconnection may be delayed if done while handling the event.  
]]
---@param connection NoirConnection
function Noir.Classes.EventClass:Disconnect(connection)
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
    self.Connections[connection.ID] = nil
    table.remove(self.ConnectionsOrder, connection.Index)

    for index = connection.Index, #self.ConnectionsOrder do
        local _connection = self.Connections[self.ConnectionsOrder[index]]
        _connection.Index = _connection.Index - 1
    end

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
---@field New fun(self: NoirService, name: string, isBuiltIn: boolean): NoirService
---@field Name string The name of this service
---@field IsBuiltIn boolean Whether or not this service comes with Noir
---@field Initialized boolean Whether or not this service has been initialized
---@field Started boolean Whether or not this service has been started
---@field InitPriority integer The priority of this service when it is initialized
---@field StartPriority integer The priority of this service when it is started
---
---@field ServiceInit fun(self: NoirService) A method that is called when the service is initialized
---@field ServiceStart fun(self: NoirService) A method that is called when the service is started
Noir.Classes.ServiceClass = Noir.Class("NoirService")

--[[
    Initializes service class objects.
]]
---@param name string
function Noir.Classes.ServiceClass:Init(name, isBuiltIn)
    -- Create attributes
    self.Name = name
    self.IsBuiltIn = isBuiltIn
    self.Initialized = false
    self.Started = false

    self.InitPriority = nil
    self.StartPriority = nil
end

--[[
    Start this service.<br>
    Used internally.
]]
function Noir.Classes.ServiceClass:_Initialize()
    -- Checks
    if self.Initialized then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to initialize this service when it has already initialized.", true, self.Name)
        return
    end

    if self.Started then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to start this service when it has already started.", true, self.Name)
        return
    end

    -- Set initialized
    self.Initialized = true

    -- Call ServiceInit
    if not self.ServiceInit then
        Noir.Libraries.Logging:Error("Service", "%s: This service is missing a ServiceInit method.", true, self.Name)
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
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to start this service when it has already started.", true, self.Name)
        return
    end

    if not self.Initialized then
        Noir.Libraries.Logging:Error("Service", "%s: Attempted to start this service when it has not initialized yet.", true, self.Name)
        return
    end

    -- Set started
    self.Started = true

    -- Call ServiceStart
    if not self.ServiceStart then
        Noir.Libraries.Logging:Warning("Service", "%s: This service is missing a ServiceStart method. You can ignore this if this service doesn't require it.", self.Name)
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
        Noir.Libraries.Logging:Error("Service", "_CheckSaveData(): g_savedata is nil.", true)
        return false
    end

    if not g_savedata.Noir then
        Noir.Libraries.Logging:Error("Service", "._CheckSaveData(): g_savedata.Noir is nil.", true)
        return false
    end

    if not g_savedata.Noir.Services then
        Noir.Libraries.Logging:Error("Service", "._CheckSaveData(): g_savedata.Noir.Services is nil.", true)
        return false
    end

    if not g_savedata.Noir.Services[self.Name] then
        Noir.Libraries.Logging:Info("Service", "_CheckSaveData(): %s is missing a table in g_savedata.Noir.Services. Creating one.", self.Name)
        g_savedata.Noir.Services[self.Name] = {}
    end

    -- All good!
    return true
end

--[[
    Save a value to g_savedata under this service.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        MyService:Save("MyKey", "MyValue")
    end
]]
---@param index string
---@param data any
function Noir.Classes.ServiceClass:Save(index, data)
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return
    end

    -- Save
    g_savedata.Noir.Services[self.Name][index] = data
end

--[[
    Load data from g_savedata that was saved via the :Save() method.

    local MyService = Noir.Services:CreateService("MyService")

    function MyService:ServiceInit()
        local MyValue = MyService:Load("MyKey")
    end
]]
---@param index string
---@param default any
---@return any
function Noir.Classes.ServiceClass:Load(index, default)
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return
    end

    -- Load
    local value = g_savedata.Noir.Services[self.Name][index]

    if value == nil then
        return default
    end

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
    -- Check g_savedata
    if not self:_CheckSaveData() then
        return
    end

    -- Remove
    g_savedata.Noir.Services[self.Name][index] = nil
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
    self.Permissions[permission] = true
    Noir.Services.PlayerService:_SaveProperty(self, "Permissions")
end

--[[
    Returns whether or not this player has a permission.
]]
---@param permission string
---@return boolean
function Noir.Classes.PlayerClass:HasPermission(permission)
    return self.Permissions[permission] ~= nil
end

--[[
    Remove a permission from this player.
]]
---@param permission string
function Noir.Classes.PlayerClass:RemovePermission(permission)
    self.Permissions[permission] = nil
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
function Noir.Classes.PlayerClass:Teleport(pos)
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
        Noir.Libraries.Logging:Error("Player", ":GetCharacter() failed for player %s (%d, %s)", false, self.Name, self.ID, self.Steam)
        return
    end

    -- Get or create object for character
    local object = Noir.Services.ObjectService:GetObject(character)

    if not object then
        Noir.Libraries.Logging:Error("Player", ":GetCharacter() failed for player %s (%d, %s) due to object being nil", false, self.Name, self.ID, self.Steam)
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
    self.IsRepeating = isRepeating
end

--[[
    Sets the duration of this task.
]]
---@param duration number
function Noir.Classes.TaskClass:SetDuration(duration)
    self.Duration = duration
    self.StopsAt = self.StartedAt + duration
end

--[[
    Sets the arguments that will be passed to this task upon finishing.
]]
---@param arguments table<integer, any>
function Noir.Classes.TaskClass:SetArguments(arguments)
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
    local object = Noir.Classes.ObjectClass:New(serializedObject.ID)
    return object
end

--[[
    Returns the data of this object.
]]
---@return SWObjectData|nil
function Noir.Classes.ObjectClass:GetData()
    local data = server.getObjectData(self.ID)

    if not data then
        Noir.Libraries.Logging:Error("ObjectService", ":GetData() failed for object %d. Data is nil", false, self.ID)
        return
    end

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
        Noir.Libraries.Logging:Error("Object", ":GetHealth() failed as data is nil. Returning 100 as default.", false)
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
    server.setCharacterTooltip(self.ID, tooltip)
end

--[[
    Set this character's AI state (if character).
]]
---@param state integer 0 = none, 1 = path to destination
function Noir.Classes.ObjectClass:SetAIState(state)
    server.setAIState(self.ID, state)
end

--[[
    Set this character's AI character target (if character).
]]
---@param target NoirObject
function Noir.Classes.ObjectClass:SetAICharacterTarget(target)
    server.setAITargetCharacter(self.ID, target.ID)
end

--[[
    Set this character's AI vehicle target (if character).
]]
---@param vehicle_id integer
function Noir.Classes.ObjectClass:SetAIVehicleTarget(vehicle_id)
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
        Noir.Libraries.Logging:Error("Object", "server.getCharacterVehicle(...) was unsuccessful.", false)
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
    local item, success = server.getCharacterItem(self.ID, slot)

    if not success then
        Noir.Libraries.Logging:Error("Object", "server.getCharacterItem(...) was unsuccessful.", false)
        return
    end

    return item
end

--[[
    Returns whether or not this character is downed (dead, incapaciated, or hp <= 0) (if character).
]]
---@return boolean
function Noir.Classes.ObjectClass:IsDowned()
    -- Get data
    local data = self:GetData()

    if not data then
        Noir.Libraries.Logging:Error("Object", ":IsDowned() failed due to data being nil.", false)
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
    if name then
        server.setSeated(self.ID, vehicle_id, name)
    elseif voxelX and voxelY and voxelZ then
        server.setSeated(self.ID, vehicle_id, voxelX, voxelY, voxelZ)
    else
        Noir.Libraries.Logging:Error("Object", "Name, or voxelX and voxelY and voxelZ must be provided to NoirObject:Seat().", true)
    end
end

--[[
    Set the move target of this character (if creature).
]]
---@param position SWMatrix
function Noir.Classes.ObjectClass:SetMoveTarget(position)
    server.setCreatureMoveTarget(self.ID, position)
end

--[[
    Damage this character by a certain amount (if character).
]]
---@param amount number
function Noir.Classes.ObjectClass:Damage(amount)
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
    local isLit, success = server.getFireData(self.ID)

    if not success then
        Noir.Libraries.Logging:Error("Object", "server.getFireData(...) was unsuccessful. Returning false.", false)
        return false
    end

    return isLit
end

--[[
    Set this fire's data (if fire).
]]
---@param isLit boolean
---@param isExplosive boolean
function Noir.Classes.ObjectClass:SetFireData(isLit, isExplosive)
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
    self.OnUse:Fire(player, message, args, self:CanUse(player))
end

--[[
    Returns whether or not the string matches this command.<br>
    Used internally. Do not use in your code.
]]
---@param query string
---@return boolean
function Noir.Classes.CommandClass:_Matches(query)
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
    if self.RequiresAuth and not player.Auth then
        return false
    end

    if self.RequiresAdmin and not player.Admin then
        return false
    end

    for _, permission in ipairs(self.RequiredPermissions) do
        if not player:HasPermission(permission) then
            return false
        end
    end

    return true
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
function Noir.Libraries:Create(name)
    return {
        name = name
    }
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
Noir.Libraries.Events = Noir.Libraries:Create("NoirEvents")

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
Noir.Libraries.Logging = Noir.Libraries:Create("NoirLogging")

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
    self.LoggingMode = mode
end

--[[
    Sends a log.

    Noir.Libraries.Logging:Log("Warning", "Title", "Something went wrong relating to %s", "something.")
]]
---@param logType string
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Log(logType, title, message, ...)
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
---@param message string
---@param ... any
function Noir.Libraries.Logging:_FormatLog(logType, title, message, ...)
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
---@param message string
---@param triggerError boolean
---@param ... any
function Noir.Libraries.Logging:Error(title, message, triggerError, ...)
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
---@param message string
---@param ... any
function Noir.Libraries.Logging:Warning(title, message, ...)
    self:Log("Warning", title, message, ...)
end

--[[
    Sends an info log.

    Noir.Libraries.Logging:Info("Title", "Something went okay relating to %s", "something.")
]]
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Info(title, message, ...)
    self:Log("Info", title, message, ...)
end

--[[
    Sends a success log.

    Noir.Libraries.Logging:Success("Title", "Something went right relating to %s", "something.")
]]
---@param title string
---@param message string
---@param ... any
function Noir.Libraries.Logging:Success(title, message, ...)
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
Noir.Libraries.Table = Noir.Libraries:Create("NoirTable")

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
    if #tbl == 0 then
        Noir.Libraries.Logging:Warning("TableLibrary", ":Random() - The provided table is empty, nil has been returned instead.")
        return
    end

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
---@param start number
---@param finish number
---@return tbl
function Noir.Libraries.Table:Slice(tbl, start, finish)
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
Noir.Libraries.Number = Noir.Libraries:Create("NoirNumber")

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
    local mult = 10 ^ (decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
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
Noir.Libraries.String = Noir.Libraries:Create("NoirString")

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
    return self:Split(str, "\n")
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
    Do not modify this table directly. Please use `Noir.Services:GetService(name)` instead.
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
---@return NoirService
function Noir.Services:CreateService(name, isBuiltIn)
    -- Check if service already exists
    if self.CreatedServices[name] then
        Noir.Libraries.Logging:Error("Service Creation", "Attempted to create a service that already exists. The already existing service has been returned instead.", false)
        return self.CreatedServices[name]
    end

    -- Create service
    local service = Noir.Classes.ServiceClass:New(name, isBuiltIn or false)

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
    -- Get service
    local service = self.CreatedServices[name]

    -- Check if service exists
    if not service then
        Noir.Libraries.Logging:Error(name, "Attempted to retrieve a service that doesn't exist ('%s').", true)
        return
    end

    -- Check if service has been initialized
    if not service.Initialized then
        Noir.Libraries.Logging:Error("Service Retrieval", "Attempted to retrieve a service that hasn't initialized yet ('%s').", false)
        return
    end

    return service
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
    for index, service in pairs(self:GetBuiltInServices()) do
        if Noir.Libraries.Table:Find(exceptions, service.Name) then
            goto continue
        end

        self.CreatedServices[index] = nil

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
Noir.Services.TaskService = Noir.Services:CreateService("TaskService", true)
Noir.Services.TaskService.InitPriority = 1
Noir.Services.TaskService.StartPriority = 1

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
---@field DestroyCallback NoirConnection A connection to the onDestroy event
Noir.Services.PlayerService = Noir.Services:CreateService("PlayerService", true)
Noir.Services.PlayerService.InitPriority = 2
Noir.Services.PlayerService.StartPriority = 2

function Noir.Services.PlayerService:ServiceInit()
    self.OnJoin = Noir.Libraries.Events:Create()
    self.OnLeave = Noir.Libraries.Events:Create()
    self.OnDie = Noir.Libraries.Events:Create()
    self.OnRespawn = Noir.Libraries.Events:Create()

    self.Players = {}
end

function Noir.Services.PlayerService:ServiceStart()
    -- Create callbacks
    self.JoinCallback = Noir.Callbacks:Connect("onPlayerJoin", function(steam_id, name, peer_id, admin, auth)
        -- Check if player was loaded via save data. This happens because onPlayerJoin runs for the host after Noir fully starts
        if self:GetPlayer(peer_id) then
            return
        end

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

    -- Remove all players when the world exists
    self.DestroyCallback = Noir.Callbacks:Connect("onDestroy", function()
        for _, player in pairs(self:GetPlayers()) do
            self.LeaveCallback:Fire(nil, nil, player.ID) -- TODO: probably add service methods that handles onPlayerJoin and onPlayerLeave, that way we can trigger the onPlayerLeave handler code cleanly here
        end
    end)

    -- Load players in game
    if Noir.AddonReason == "AddonReload" then -- Only load players in-game if the addon was reloaded, otherwise onPlayerJoin will be called for the players that join when the save is loaded/created and we can just listen for that
        for _, player in pairs(server.getPlayers()) do
            -- Check if unnamed client
            if player.steam_id == 0 then
                goto continue
            end

            -- Log
            Noir.Libraries.Logging:Info("PlayerService", "server.getPlayers(): Loading player in game: %s (%d, %s)", player.name, player.id, player.steam_id)

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

            -- Load saved properties
            local savedProperties = self:_GetSavedPropertiesForPlayer(createdPlayer)

            if savedProperties then
                for property, value in pairs(savedProperties) do
                    createdPlayer[property] = value
                end
            end

            ::continue::
        end
    end
end

--[[
    Gives data to a player.<br>
    Used internally.
]]
---@param steam_id integer
---@param name string
---@param peer_id integer
---@param admin boolean
---@param auth boolean
---@return NoirPlayer|nil
function Noir.Services.PlayerService:_GivePlayerData(steam_id, name, peer_id, admin, auth)
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

    -- Return
    return player
end

--[[
    Overwrite saved properties.<br>
    Used internally. Do not use in your code.
]]
---@param properties NoirSavedPlayerProperties
function Noir.Services.PlayerService:_OverwriteSavedProperties(properties)
    self:Save("PlayerProperties", properties)
end

--[[
    Returns all saved player properties saved in g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@return NoirSavedPlayerProperties
function Noir.Services.PlayerService:_GetSavedProperties()
    return self:Load("PlayerProperties", {})
end

--[[
    Removes data for a player.<br>
    Used internally.
]]
---@param player NoirPlayer
---@return boolean success Whether or not the operation was successful
function Noir.Services.PlayerService:_RemovePlayerData(player)
    -- Check if player exists in this service
    if not self:GetPlayer(player.ID) then
        Noir.Libraries.Logging:Error("PlayerService", "Attempted to remove player data from a non-existent player.", false)
        return false
    end

    -- Remove player
    self.Players[player.ID] = nil

    -- Remove saved properties
    self:_RemoveSavedProperties(player)

    return true
end

--[[
    Save a player's property to g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@param property string
function Noir.Services.PlayerService:_SaveProperty(player, property)
    local properties = self:_GetSavedProperties()

    if not properties[player.ID] then
        properties[player.ID] = {}
    end

    properties[player.ID][property] = player[property]
    self:_OverwriteSavedProperties(properties)
end

--[[
    Get a player's saved properties.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
---@return table<string, boolean>|nil
function Noir.Services.PlayerService:_GetSavedPropertiesForPlayer(player)
    return self:_GetSavedProperties()[player.ID]
end

--[[
    Removes a player's saved properties from g_savedata.<br>
    Used internally. Do not use in your code.
]]
---@param player NoirPlayer
function Noir.Services.PlayerService:_RemoveSavedProperties(player)
    local properties = self:_GetSavedProperties()
    properties[player.ID] = nil
    self:_OverwriteSavedProperties(properties)
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
    return self:GetPlayers()[ID]
end

--[[
    Returns a player by their Steam ID.<br>
    Note that two players or more can have the same Steam ID if they spoof their Steam ID or join the server on two Stormworks instances.
]]
---@param steam string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerBySteam(steam)
    for _, player in pairs(self:GetPlayers()) do
        if player.Steam == steam then
            return player
        end
    end
end

--[[
    Returns a player by their exact name.<br>
    Consider using `:SearchPlayerByName()` if you want to search and not directly fetch.
]]
---@param name string
---@return NoirPlayer|nil
function Noir.Services.PlayerService:GetPlayerByName(name)
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
    return playerA.ID == playerB.ID
end

-------------------------------
-- // Intellisense
-------------------------------

---@alias NoirSavedPlayerProperties table<integer, table<string, boolean>>

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
    local object = Service:GetObject(object_id)

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
Noir.Services.ObjectService = Noir.Services:CreateService("ObjectService", true)

function Noir.Services.ObjectService:ServiceInit()
    self.Objects = {}

    self.OnRegister = Noir.Libraries.Events:Create()
    self.OnUnregister = Noir.Libraries.Events:Create()
    self.OnLoad = Noir.Libraries.Events:Create()
    self.OnUnload = Noir.Libraries.Events:Create()
end

function Noir.Services.ObjectService:ServiceStart()
    -- Load saved objects
    for _, object in pairs(self:_GetSavedObjects()) do -- important to copy, because :RegisterObject() modifies the saved objects table
        -- Register object
        local registeredObject = self:RegisterObject(object.ID)

        if not registeredObject then
            goto continue
        end

        -- Log
        Noir.Libraries.Logging:Info("ObjectService", "Loading object: %s", object.ID)

        ::continue::
    end

    -- Listen for object loading/unloading
    ---@param object_id integer
    self.OnLoadConnection = Noir.Callbacks:Connect("onObjectLoad", function(object_id)
        -- Get object
        local object = self:GetObject(object_id)

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

    ---@param object_id integer
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

        -- Save
        self:_SaveObjectSavedata(object)
    end)
end

--[[
    Overwrite saved objects.<br>
    Used internally. Do not use in your code.
]]
---@param objects table<integer, NoirSerializedObject>
function Noir.Services.ObjectService:_SaveObjects(objects)
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
---@return NoirObject|nil
function Noir.Services.ObjectService:RegisterObject(object_id)
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
    self.OnRegister:Fire(object)

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
    return self.Objects[object_id] or self:RegisterObject(object_id)
end

--[[
    Removes the object with the given ID.
]]
---@param object_id integer
function Noir.Services.ObjectService:RemoveObject(object_id)
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
Noir.Services.GameSettingsService = Noir.Services:CreateService("GameSettingsService", true)

function Noir.Services.GameSettingsService:ServiceInit() end
function Noir.Services.GameSettingsService:ServiceStart() end

--[[
    Returns the value of the provided game setting.

    Noir.Services.GameSettingsService:GetSetting("infinite_batteries") -- false
]]
---@param name SWGameSettingEnum
---@return any
function Noir.Services.GameSettingsService:GetSetting(name)
    local settings = server.getGameSettings()
    local setting = settings[name]

    if not setting then
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
    if not self:GetSetting(name) then
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
Noir.Services.CommandService = Noir.Services:CreateService("CommandService", true)

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
    for _, command in pairs(self:GetCommands()) do
        if command:_Matches(query) then
            return command
        end
    end
end

--[[
    Create a new command.
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
    local command = Noir.Classes.CommandClass:New(name, aliases, requiredPermissions or {}, requiresAuth or false, requiresAdmin or false, capsSensitive or false, description or "")
    command.OnUse:Connect(callback)

    self.Commands[name] = command
    return command
end

--[[
    Get a command by the name.
]]
---@param name string
---@return NoirCommand|nil
function Noir.Services.CommandService:GetCommand(name)
    return self.Commands[name]
end

--[[
    Remove a command.
]]
---@param name string
function Noir.Services.CommandService:RemoveCommand(name)
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
    -- Get or create event
    local event = self:_InstantiateCallback(name, hideStartWarning or false)

    -- Connect callback to event
    return event:Once(callback)
end

--[[
    Get a game callback event.<br>
    It's best to use `Noir.Callbacks:Connect()` or `Noir.Callbacks:Once()` instead of getting a callback event directly and connecting to it.

    local event = Noir.Callbacks:Get("onPlayerJoin")

    event:Connect(function()
        server.announce("Server", "A player joined!")
    end)
]]
---@param name string
---@return NoirEvent
function Noir.Callbacks:Get(name)
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
    -- Check if Noir has started
    if not Noir.HasStarted and not hideStartWarning then
        Noir.Libraries.Logging:Warning("Callbacks", "Noir has not started yet. It is not recommended to connect to callbacks before `Noir:Start()` is called and finalized. Please connect to the `Noir.Started` event and attach to game callbacks in that.")
    end

    -- For later
    local event = Noir.Callbacks.Events[name]
    local wasCreatedAlready = event ~= nil

    -- Create event if it doesn't exist
    if not event then
        event = Noir.Libraries.Events:Create()
        self.Events[name] = event
    end

    -- Create function for game callback if it doesn't exist. If the user created the callback themselves, overwrite it
    local existing = _ENV[name]

    if existing and not wasCreatedAlready then
        -- Inform developer that a function for a game callback already exists
        Noir.Libraries.Logging:Warning("Callbacks", "Your addon has a function for the game callback '%s'. Noir will wrap around it to prevent overwriting. Please use Noir.Callbacks:Connect(\"%s\", function(...) end) to avoid this warning.", name, name)

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

    table.sort(servicesToInit, function(serviceA, serviceB)
        return serviceA.InitPriority < serviceB.InitPriority
    end)

    -- Initialize services
    for _, service in pairs(servicesToInit) do
        Noir.Libraries.Logging:Info("Bootstrapper", "Initializing '%s'. Priority: %d", service.Name, service.InitPriority)
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

    table.sort(servicesToStart, function(serviceA, serviceB)
        return serviceA.StartPriority < serviceB.StartPriority
    end)

    -- Start services
    for _, service in pairs(servicesToStart) do
        Noir.Libraries.Logging:Info("Bootstrapper", "Starting '%s'. Priority: %d", service.Name, service.StartPriority)
        service:_Start()
    end
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
Noir.Version = "1.8.0"

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
            local took = server.getTimeMillisec() - startTime
            Noir.AddonReason = isSaveCreate and "SaveCreate" or (took < 1000 and "AddonReload" or "SaveLoad")

            self.IsStarting = false
            self.HasStarted = true

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
    ---@param isSaveCreate boolean
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