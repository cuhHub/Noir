--------------------------------------------------------
-- [Noir] Example - Dataclasses
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

-- Represents an item
---@class Item: NoirDataclass -- The below is purely for intellisense in your IDE. It is not required for functionality
---@field New fun(self: Item, name: string, weight: number, stackable: boolean): Item
---@field Name string
---@field Weight number
---@field Stackable boolean
local Item = Noir.Libraries.Dataclasses:New("Item", {
    Noir.Libraries.Dataclasses:Field("Name", "string"),
    Noir.Libraries.Dataclasses:Field("Weight", "number"),
    Noir.Libraries.Dataclasses:Field("Stackable", "boolean")
})

-- Create a sword (item)
local sword = Item:New("Sword", 5, true)
Noir.Libraries.Logging:Info("Sword", "Name: %s | Weight: %s | Stackable: %s", sword.Name, sword.Weight, sword.Stackable)

-- Create a shield (item)
local shield = Item:New("Shield", 10, false)
Noir.Libraries.Logging:Info("Shield", "Name: %s | Weight: %s | Stackable: %s", shield.Name, shield.Weight, shield.Stackable)