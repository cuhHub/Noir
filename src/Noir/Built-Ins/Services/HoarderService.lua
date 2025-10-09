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

---@alias NoirHoarderCheckpoint fun(instance: NoirHoardable): boolean, table|nil

--[[
    A service for easily saving/loading class instances within a service with minimal hassle.<br>
    Example (see `Hoardable` code sample for info on the class side of things):

    Fruits = Noir.Services:CreateService("Fruits")

    function Fruits:ServiceInit()
        self.Basket = {}
        self.Bin = {}

        -- Before a fruit is loaded, the below is called
        Noir.Services.HoarderService:AddCheckpoint(self, Fruit, function(fruit)
            -- Decrease the value of the fruit by 0.1. This is to show you can manipulate the fruit before it is loaded.
            fruit.Value = fruit.Value - 0.1

            -- We need to save the changes hence this line
            fruit:Hoard(self, "Basket")

            -- Return `true` to 100% load the fruit (`false` would skip loading it and remove it forever).
            -- We also return a second value which is where the fruit should be stored upon loading.
            -- Returning `nil` for the second value would just move the fruit to its original destination
            -- provided by `:LoadAll()`, which in this case, is `self.Basket`.
            return true, math.random(0, 1) == 1 and self.Bin or nil
        end)

        -- Load all saved fruits
        Noir.Services.HoarderService:LoadAll(
            self, -- the service holding the save data that the fruits are stored in
            "Basket", -- the name of the table in the save data the fruits are stored in
            self.Basket, -- where to store the loaded fruits (can be overwritten by a checkpoint, see `:AddCheckpoint()` above)
            Fruit, -- the class the saved fruits are instances of
            {ItemInfo, Noir.Classes.Event} -- any classes that may be in `Fruit`. they do not have to inherit from NoirHoardable
        )

        -- Show the loaded fruits
        print("Fruits have been loaded!")
        print("Basket:")
        for _, fruit in pairs(self.Basket) do
            print("   \\____ %s ($%s)", fruit.Name, fruit.Value)
        end

        print("Bin:")
        for _, fruit in pairs(self.Bin) do
            print("   \\____ %s ($%s)", fruit.Name, fruit.Value)
        end

        if Noir.AddonReason == "SaveCreate" then
            -- Create some fruits
            self:AddFruit("Apple")
            self:AddFruit("Banana")
            self:AddFruit("Cherry")
            self:AddFruit("Watermelon")
            self:AddFruit("Pineapple")
            self:AddFruit("Grapes")
            self:AddFruit("Strawberry")
            self:AddFruit("Orange")
        end
    end

    function Fruits:AddFruit(name)
        local fruit = Fruit:New(name, 1)
        fruit:Hoard(self, "Basket")
        self.Basket[name] = fruit

        print("Added new fruit: %s", name)
    end
]]
---@class NoirHoarderService: NoirService
---@field Checkpoints table<NoirService, table<NoirClass, NoirHoarderCheckpoint>> The checkpoint functions for each service and class that dictate whether or not to load a serialized class instance
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
    Serializes a table for saving by removing all functions.<br>
    Used internally.
]]
---@param tbl table
---@return table
function Noir.Services.HoarderService:_Serialize(tbl)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_Serialize()", "tbl", tbl, "table")

    -- Serialize
    local serialized = {}

    for key, value in pairs(tbl) do
        -- Disallow functions
        if type(value) == "function" then
            goto continue
        end

        if type(value) == "table" then
            -- Recursively serialize
            serialized[key] = self:_Serialize(value)
        else
            -- Add value (it's allowed)
            serialized[key] = value
        end

        ::continue::
    end

    -- Return
    return serialized
end

--[[
    Adds class names as indices to a table of classes.<br>
    Used internally.
]]
---@param classes table<integer, NoirClass>
---@return table<string, NoirClass>
function Noir.Services.HoarderService:_IndexClasses(classes)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_IndexClasses()", "classes", classes, "table")

    -- Index classes
    ---@type table<string, NoirClass>
    local indexed = {}

    for _, class in pairs(classes) do
        indexed[class.ClassName] = class
    end

    return indexed
end


--[[
    Deserializes a serialized class instance.<br>
    Used internally.
]]
---@param class NoirHoardable|NoirClass
---@param serialized table
---@param lookupClasses table<string, NoirClass>
---@return NoirClass
function Noir.Services.HoarderService:_Deserialize(class, serialized, lookupClasses)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_Deserialize()", "class", class, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_Deserialize()", "serialized", serialized, "table")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_Deserialize()", "lookupClasses", lookupClasses, "table")

    -- Setup instance
    ---@type NoirHoardable|NoirClass
    ---@diagnostic disable-next-line: missing-fields
    local instance = {}
    class:_SetupObject(instance)

    -- Set attributes
    for key, value in pairs(serialized) do
        if Noir.IsClass(value) then -- .IsClass(), at least for 3.0.0, checks for a `ClassName` attribute. so even if serialized, it'll work here 
            local className = value.ClassName
            local _class = lookupClasses[className]

            if not _class then
                error("Noir.Services.HoarderService:_Deserialize()", "Class '%s' is unrecognised and cannot be serialized. Please ensure it is in the `lookupClasses` table passed to `:LoadAll()` (or `:_Deserialize()`).", className)
            end

            instance[key] = self:_Deserialize(_class, value, lookupClasses)
        else
            instance[key] = value
        end
    end

    -- Re-add parents
    instance._Parents = class._Parents

    -- Call `OnDeserialize`
    if Noir.Classes.Hoardable:IsSameType(instance)  and instance.OnDeserialize then
        ---@diagnostic disable-next-line: param-type-mismatch
        instance:OnDeserialize(serialized, lookupClasses)
    end

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
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_InitSaveDataCategory()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_InitSaveDataCategory()", "tblName", tblName, "string")

    -- Create table
    service:EnsuredLoad(tblName, {})
end

--[[
    Invokes the checkpoint for the provided service and class if any.<br>
    It then returns the result which should be whether or not to load the instance and an optional overwritten location for the instance.<br>
    Used internally.
]]
---@param service NoirService
---@param class NoirClass
---@param instance NoirHoardable
---@return boolean
---@return table|nil
function Noir.Services.HoarderService:_HandleCheckpoint(service, class, instance)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_ShouldLoad()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_ShouldLoad()", "class", class, "class")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:_ShouldLoad()", "instance", instance, Noir.Classes.Hoardable)

    -- Run checkpoint if it exists
    if self.Checkpoints[service] and self.Checkpoints[service][class] then
        return self.Checkpoints[service][class](instance)
    end

    -- Default to true and default location
    return true
end

--[[
    Adds a checkpoint function for a service and class. It must return a boolean and an optional location for the instance.<br>
    if `true` is returned, the passed instance will be loaded.<br>
    if `false` is returned, the passed instance will not be loaded.<br><br>
    Example Checkpoint:

    function myCheckpoint(instance)
        if not instance:DoesObjectExist() then
            return false -- do not load
        end
    
        if instance.HasOwner then
            return true, myService.InstancesWithOwner -- loads, and goes to a different table
        else
            return true -- loads, and goes to the default table provided with `:LoadAll()`
        end
    end
]]
---@param service NoirService
---@param class NoirHoardable
---@param func NoirHoarderCheckpoint
function Noir.Services.HoarderService:AddCheckpoint(service, class, func)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:AddCheckpoint()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:AddCheckpoint()", "class", class, Noir.Classes.Hoardable)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:AddCheckpoint()", "func", func, "function")

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
---@param tblName string The name of the sub-table in the provided service's savedata to save the serialized instance to
---@param instance NoirHoardable
function Noir.Services.HoarderService:Hoard(service, tblName, instance)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Hoard()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Hoard()", "tblName", tblName, "string")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Hoard()", "instance", instance, Noir.Classes.Hoardable)

    -- Serialize
    local serialized = self:_Serialize(instance)

    if instance.OnSerialize then
        instance:OnSerialize(serialized)
    end

    -- Save serialized instance
    local saveData = service:GetSaveData()

    self:_InitSaveData(service, tblName)

    if instance:GetHoardableID() then
        saveData[tblName][instance:GetHoardableID()] = serialized
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
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Unhoard()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Unhoard()", "tblName", tblName, "string")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:Unhoard()", "instance", instance, Noir.Classes.Hoardable)

    -- Init savedata
    self:_InitSaveData(service, tblName)

    -- Unhoard
    local saveData = service:GetSaveData()

    if instance:GetHoardableID() then
        saveData[tblName][instance:GetHoardableID()] = nil
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
---@param service NoirService
---@param from string The name of the sub-table in the provided service's savedata to load the serialized instances from
---@param to table The table to load the class instances into
---@param class NoirHoardable The class the serialized instances are of
---@param lookupClasses table<integer, NoirClass> A table of classes that the provided class may contain instances of. This is used to deserialize instances of classes that are not the provided class but may be contained within it.
function Noir.Services.HoarderService:LoadAll(service, from, to, class, lookupClasses)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "service", service, Noir.Classes.Service)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "from", from, "string")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "to", to, "table")
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "class", class, Noir.Classes.Hoardable)
    Noir.TypeChecking:Assert("Noir.Services.HoarderService:LoadAll()", "lookupClasses", lookupClasses, "table")

    -- Convert classes to lookup table (classes indexed by their class name)
    local _lookupClasses = self:_IndexClasses(lookupClasses)

    -- Get save data
    local saveData = service:GetSaveData()
    self:_InitSaveData(service, from)

    -- Load
    for _, serialized in pairs(saveData[from]) do
        ---@type NoirHoardable
        local instance = self:_Deserialize(class, serialized, _lookupClasses)
        local shouldLoad, overwrittenLocation = self:_HandleCheckpoint(service, class, instance)

        if not shouldLoad then
            self:Unhoard(service, from, instance)
            goto continue
        end

        local ID = instance:GetHoardableID()
        local location = overwrittenLocation or to

        if ID then
            location[ID] = instance
        else
            table.insert(location, instance)
        end

        ::continue::
    end
end