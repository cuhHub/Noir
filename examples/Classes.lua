--------------------------------------------------------
-- [Noir] Example - Classes
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2026 Cuh4

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
    Represents a food item.
]]
---@class Food: NoirClass
---@field New fun(self: Food, name: string): Food
Food = Noir.Class("Food")

--[[
    Initializes `Food` instances.
]]
---@param name string
function Food:Init(name)
    --[[
        The name of the fruit.
    ]]
    self.Name = name
end

--[[
    Returns the name of the food.
]]
---@return string
function Food:GetFoodName()
    return self.Name
end

--[[
    Represents a chicken.
]]
---@class Chicken: Food
---@field New fun(self: Chicken, type: string): Chicken
Chicken = Noir.Class("Chicken", Food) -- inherit from `Food`

--[[
    Initializes `Chicken` instances.
]]
---@param type string
function Chicken:Init(type)
    self:InitFrom(Food, "Chicken") -- required, otherwise attributes from `Food` won't get passed down
    self.ChickenType = type                 -- this applies the same behaviour as `Food:New("Chicken")` but affects
                                            -- this `Chicken` instance instead
end

--[[
    Showing off classes, no inheritance
]]
local banana = Food:New("Banana")
print(banana.Name) -- "Banana"
print(banana:GetFoodName()) -- "Banana"

local apple = Food:New("Apple")
print(apple.Name) -- "Apple"
print(apple:GetFoodName()) -- "Apple"

-- `apple` and `banana` are both instances of `Food`, but they are not the same object
-- and are independent from each other. that means changing `apple` will not change
-- `banana`, and vice versa.

--[[
    Showing off inheritance
]]
local chicken = Chicken:New("Battered")
print(chicken.ChickenType) -- "Battered"

-- Because `Chicken` inherits from `Food`, `Food` methods and attributes are also available
print(chicken:GetFoodName()) -- "Chicken"
print(chicken.Name) -- "Chicken"

-- For more info on OOP: https://www.lua.org/pil/16.html