--------------------------------------------------------
-- [Noir] Tests - Dataclasses Library
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

---@class InventoryItem: NoirDataclass
---@field New fun(self: InventoryItem, name: string, ID: integer, weight: number|nil, stackable: boolean|nil): InventoryItem
---@field Name string
---@field ID integer
---@field Weight number|nil
---@field Stackable boolean|nil
local InventoryItem = Noir.Libraries.Dataclasses:New("InventoryItem", {
    Noir.Libraries.Dataclasses:Field("Name", "string"),
    Noir.Libraries.Dataclasses:Field("ID", "number"),
    Noir.Libraries.Dataclasses:Field("Weight", "number", "nil"),
    Noir.Libraries.Dataclasses:Field("Stackable", "boolean", "nil")
})

local item = InventoryItem:New("Sword", 1, 5, true)
assert(item.Name == "Sword", "Expected \"Sword\" for name")
assert(item.ID == 1, "Expected 1 for ID")
assert(item.Weight == 5, "Expected 5 for weight")
assert(item.Stackable == true, "Expected true for stackable")

local item2 = InventoryItem:New("Gun", 2)
assert(item2.Name == "Gun", "Expected \"Gun\" for name")
assert(item2.ID == 2, "Expected 2 for ID")
assert(item2.Weight == nil, "Expected nil for weight")
assert(item2.Stackable == nil, "Expected nil for stackable")

local item3 = InventoryItem:New("Crate", 3, nil, true)
assert(item3.Name == "Crate", "Expected \"Crate\" for name")
assert(item3.ID == 3, "Expected 3 for ID")
assert(item3.Weight == nil, "Expected nil for weight")
assert(item3.Stackable == true, "Expected true for stackable")

local item4 = InventoryItem:New("Statue", 4)
assert(item4.Name == "Statue", "Expected \"Statue\" for name")
assert(item4.ID == 4, "Expected 4 for ID")
assert(item4.Weight == nil, "Expected nil for weight")
assert(item4.Stackable == nil, "Expected nil for stackable")