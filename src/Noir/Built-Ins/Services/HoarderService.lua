--------------------------------------------------------
-- [Noir] Services - Hoarder Service
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
    A service for easily saving/loading class instances within a service with minimal hassle.<br>
    Example:

    -- For the code for the `Fruit` class used below, see the code sample in `Noir.Classes.Hoardable`

    -- A service that stores Fruit instances.
    ---@class Fruits: NoirService
    Fruits = Noir.Services:CreateService("Fruits")

    function Fruits:ServiceInit()
        ---@type table<string, Fruit>
        self.Basket = {}

        -- Before a fruit is loaded, the below is called
        ---@param fruit Fruit
        Noir.Services.HoarderService:AddCheckpoint(self, Fruit, function(fruit)
            fruit.Value = fruit.Value - 0.1
            fruit:Hoard(self, "Basket") -- update changes on the saving side of things

            return true -- return true to let the fruit load. if false, it will be discarded and unhoarded (never seen again)
        end)

        Noir.Services.HoarderService:LoadAll(Fruit, self, "Basket")

        print("Fruits have been loaded!")
        for _, fruit in pairs(self.Basket) do
            print("   \\____ %s ($%s)", fruit.Name, fruit.Value)
        end
    end

    function Fruits:ServiceStart()
        Noir.Services.CommandService:CreateCommand(
            "fruit",
            {},
            {},
            false,
            false,
            false,
            "",
            function(player, message, args, hasPermission)
                if not hasPermission then
                    return
                end

                self:AddFruit(args[1] or "Banana")
            end
        )
    end

    -- Adds a new fruit.
    ---@param name string
    function Fruits:AddFruit(name)
        local fruit = Fruit:New(name, 1)
        fruit:Hoard(self, "Basket")
        self.Basket[name] = fruit

        print("Added new fruit: %s", name)
    end
]]
---@class NoirHoarderService: NoirService
---@field Checkpoints table<NoirService, table<NoirHoardable, table<integer, fun(instance: NoirHoardable)>>> The checkpoint functions for each service and class that dictate whether or not to load a serialized class instance
Noir.Services.HoarderService = Noir.Services:CreateService(
    "HoarderService",
    true,
    "A service for easily saving/loading class instances within a service.",
    "A service for easily saving/loading class instances within a service with minimal hassle. Significantly reduces the amount of code required for persisting class instances.",
    {"Cuh4"}
)

function Noir.Services.HoarderService:ServiceInit()
    self.Checkpoints = {}
end

--[[
    Deserializes a serialized class instance.<br>
    Used internally.
]]
---@param class NoirHoardable
---@param serialized table
---@return NoirHoardable
function Noir.Services.HoarderService:_Deserialize(class, serialized)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_Deserialize()", "class", class, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_Deserialize()", "serialized", serialized, "table")

    if not Noir.Classes.Hoardable:IsSameType(class) then
        error("Noir.Services.HoarderService:_Deserialize()", "`class` argument must inherit from `Hoardable` to work with `HoarderService`.")
    end

    -- Setup instance
    local instance = {}
    class:_SetupObject(instance)

    -- Set attributes
    for key, value in pairs(serialized) do
        instance[key] = value
    end

    -- Re-add parents
    instance._Parents = class._Parents

    -- Return
    return instance
end

--[[
    Sets up a save data category for a service if it doesn't exist.<br>
    Used internally.
]]
---@param service NoirService
---@param tblName string
function Noir.Services.HoarderService:_InitSaveData(service, tblName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_InitSaveDataCategory()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_InitSaveDataCategory()", "tblName", tblName, "string")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Services.HoarderService:_InitSaveDataCategory()", "`service` argument must be a `NoirService` class instance.")
    end

    -- Create table
    service:EnsuredLoad(tblName, {})
end

--[[
    Returns whether a class instance about to be loaded should be loaded.<br>
    Used internally.
]]
---@param service NoirService
---@param class NoirHoardable
---@param instance NoirHoardable
---@return boolean
function Noir.Services.HoarderService:_ShouldLoad(service, class, instance)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_ShouldLoad()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_ShouldLoad()", "class", class, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_ShouldLoad()", "instance", instance, "class")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Services.HoarderService:_ShouldLoad()", "`service` argument must be a `NoirService` class instance.")
    end

    if not Noir.Classes.Hoardable:IsSameType(class) then
        error("Noir.Services.HoarderService:_ShouldLoad()", "`class` argument must inherit from `Hoardable` to work with `HoarderService`.")
    end

    -- Run checkpoint if it exists
    if self.Checkpoints[service] and self.Checkpoints[service][class] then
        return self.Checkpoints[service][class](instance)
    end

    -- Default to true
    return true
end

--[[
    Adds a checkpoint function for a service. It must return a boolean.<br>
    if `true` is returned, the passed instance will be loaded.<br>
    if `false` is returned, the passed instance will not be loaded.
]]
---@param service NoirService
---@param class NoirHoardable
---@param func fun(instance: NoirHoardable): boolean
function Noir.Services.HoarderService:AddCheckpoint(service, class, func)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:AddCheckpoint()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:AddCheckpoint()", "class", class, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:AddCheckpoint()", "func", func, "function")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Services.HoarderService:AddCheckpoint()", "`service` argument must be a `NoirService` class instance.")
    end

    if not Noir.Classes.Hoardable:IsSameType(class) then
        error("Noir.Services.HoarderService:AddCheckpoint()", "`class` argument must inherit from `Hoardable` to work with `HoarderService`.")
    end

    -- Add function
    if not self.Checkpoints[service] then
        self.Checkpoints[service] = {}
    end

    if self.Checkpoints[service][class] then
        error("Noir.Services.HoarderService:AddCheckpoint()", "There is already a checkpoint for `%s` in `%s` service.", class.ClassName, service.Name)
    end

    self.Checkpoints[service][class] = func
end

--[[
    Saves the provided class instance within a service.
]]
---@param service NoirService
---@param tblName string
---@param instance NoirHoardable
function Noir.Services.HoarderService:Hoard(service, tblName, instance)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Hoard()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Hoard()", "tblName", tblName, "string")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Hoard()", "instance", instance, "class")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Services.HoarderService:Hoard()", "`service` argument must be a `NoirService` class instance.")
    end

    if not Noir.Classes.Hoardable:IsSameType(instance) then
        error("Noir.Services.HoarderService:Hoard()", "`instance` argument must inherit from `Hoardable` to work with `HoarderService`.")
    end

    -- Serialize and save
    local serialized = instance:Serialize()
    local id = instance:GetHoardableID()
    local saveData = service:GetSaveData()

    self:_InitSaveData(service, tblName)

    if id then
        saveData[tblName][id] = serialized
    else
        table.insert(saveData[tblName], serialized)
    end
end

--[[
    Unhoards the provided class instance within a service.
]]
---@param service NoirService
---@param tblName string
---@param instance NoirHoardable
function Noir.Services.HoarderService:Unhoard(service, tblName, instance)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Unhoard()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Unhoard()", "tblName", tblName, "string")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Unhoard()", "instance", instance, "class")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Services.HoarderService:Unhoard()", "`service` argument must be a `NoirService` class instance.")
    end

    if not Noir.Classes.Hoardable:IsSameType(instance) then
        error("Noir.Services.HoarderService:Unhoard()", "`instance` argument must inherit from `Hoardable` to work with `HoarderService`.")
    end

    -- Init savedata
    self:_InitSaveData(service, tblName)

    -- Unhoard
    local saveData = service:GetSaveData()
    local ID = instance:GetHoardableID()

    if ID then
        saveData[tblName][ID] = nil
    else
        local index = Noir.Libraries.Table:Find(saveData[tblName], instance)

        if not index then
            return
        end

        table.remove(saveData[tblName], index)
    end
end

--[[
    Loads all serialized class instances into a table in the provided service.
]]
---@param class NoirHoardable
---@param service NoirService
---@param tblName string
function Noir.Services.HoarderService:LoadAll(class, service, tblName)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "class", class, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "service", service, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "tblName", tblName, "string")

    if not Noir.Classes.Service:IsSameType(service) then
        error("Noir.Services.HoarderService:LoadAll()", "`service` argument must be a `NoirService` class instance.")
    end

    if not Noir.Classes.Hoardable:IsSameType(class) then
        error("Noir.Services.HoarderService:LoadAll()", "`class` argument must inherit from `Hoardable` to work with `HoarderService`.")
    end

    if not service[tblName] then
        error("Noir.Services.HoarderService:LoadAll()", "`service` does not have a table with the name `%s`. Check the `tblName` argument.", tblName)
    end

    -- Get save data
    local saveData = service:GetSaveData()
    self:_InitSaveData(service, tblName)

    -- Load
    for _, serialized in pairs(saveData[tblName]) do
        local instance = self:_Deserialize(class, serialized)

        if not self:_ShouldLoad(service, class, instance) then
            self:Unhoard(service, tblName, instance)
            goto continue
        end

        local ID = instance:GetHoardableID()

        if ID then
            service[tblName][ID] = instance
        else
            table.insert(service[tblName], instance)
        end

        ::continue::
    end
end