--[[
    Simple test for new v2.0.0 feature that allows dataclass fields to allow multiple types instead of just one
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
print(item.Name, item.Weight, item.Stackable)

local item2 = InventoryItem:New("Gun", 2)
print(item2.Name, item2.Weight, item2.Stackable)

local item3 = InventoryItem:New("Crate", 3, nil, true)
print(item3.Name, item3.Weight, item3.Stackable)

local item4 = InventoryItem:New("Statue", 4)
print(item4.Name, item4.Weight, item4.Stackable)