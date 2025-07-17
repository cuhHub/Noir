--[[
    A class representing Fruit.
]]
---@class Fruit: NoirHoardable
---@field New fun(self: Fruit, name: string, value: number): Fruit
Fruit = Noir.Class(
    "Fruit",
    Noir.Classes.Hoardable
)

--[[
    Initializes Fruit instances.
]]
---@param name string
---@param value integer
function Fruit:Init(name, value)
    self:InitFrom(
        Noir.Classes.Hoardable,
        name -- <-- the Hoardable ID. good rule of thumb is to use the same indexing system as your service
    )        -- e.g: this fruit is saved in the `Basket` table in the `Fruits` service below, indexed by name.
             -- therefore, we use the name as the hoardable ID too so the `HoarderService` will load the fruit
             -- and save it in the `Basket` table using the name as the key too
             --
             -- omitting the id (passing it as nil or just avoiding the argument entirely) will just make the
             -- `HoarderService` assume the `Basket` table is sequential (1, 2, 3, etc) and append it to the end

    --[[
        The name of the fruit
    ]]
    self.Name = name

    --[[
        The value of the fruit
    ]]
    self.Value = value
end

--[[
    A service that stores Fruit instances.
]]
---@class Fruits: NoirService
Fruits = Noir.Services:CreateService("Fruits")

function Fruits:ServiceInit()
    ---@type table<string, Fruit>
    self.Basket = {}

    -- Before a fruit is loaded, the below is called.
    -- This is useful for modifying the fruit before it is loaded, or for deciding whether or not to load any fruit.
    ---@param fruit Fruit
    Noir.Services.HoarderService:AddCheckpoint(self, Fruit, function(fruit)
        fruit.Value = fruit.Value - 0.1

        -- We modified the fruit, so we need to save it again
        -- Line-by-line explanation:
        fruit:Hoard( -- "Hoard" (save) the fruit instance
            self, -- in this service
            "Basket" -- into a savedata table called "Basket" (this is *NOT* `self.Basket`)
        )                     -- ^ specifically, `self:GetSaveData()["Basket"]` which is NOT `self.Basket`
                              -- it is important that the savedata table name matches the table name in the service 
        Noir.Services.MessageService:SendMessage(nil, "[Fruits]", "Loaded fruit %s", fruit.Name)

        return true -- return true to let the fruit load. if false, it will be discarded and unhoarded (never seen again)
    end)

    Noir.Services.HoarderService:LoadAll( -- Load all
        Fruit, -- saved `Fruit` instances
        self, -- into this service
        "Basket" -- specifically from `Basket` table in savedata, then into the `Basket` table in the service itself
    )
end

function Fruits:ServiceStart()
    -- Create a command to create fruit at any time.
    -- The created fruit will stick around forever as it is easily saved thanks to
    -- the HoarderService
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

--[[
    Adds a new fruit.
]]
---@param name string
function Fruits:AddFruit(name)
    local fruit = Fruit:New(name, 1) -- Create a fruit with the provided name
    fruit:Hoard(self, "Basket") -- Save it on the savedata side
    self.Basket[name] = fruit -- Save it on the service side

    Noir.Services.MessageService:SendMessage(nil, "[Fruits]", "Added new fruit: %s", name)
end

-- Start Noir
Noir:Start()