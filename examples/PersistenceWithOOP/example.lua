---@diagnostic disable

ItemInfo = Noir.Class(
    "ItemInfo",
    Noir.Classes.Hoardable -- only required for `:OnSerialize()` etc
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

function ItemInfo:OnSerialize(serialized)
    serialized.Bar = nil -- unneeded but this is just an example to show you can mess with serialization logic
end

function ItemInfo:OnDeserialize(serialized, lookupClasses)
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
        name -- the Hoardable ID. this ID will be used as an index for this class instance in save data. omitting this will just append the class instance to the end of the save data
    )

    self.Name = name
    self.Value = value
    self.ItemInfo = ItemInfo:New()
    self.Functions = {
        iShouldGetDiscarded = function() end -- functions not of a class cannot be serialized, so this will automatically be removed during serialization
    }
end

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