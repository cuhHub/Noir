--[[
    Simple test for the new v2.0.0 feature that allows classes to inherit from multiple other classes
]]

---@class Entity: NoirClass
---@field New fun(self: Entity, name: string): Entity
---@field Name string
Entity = Noir.Class("Entity")

---@param name string
function Entity:Init(name)
    self.Name = name
end

---@class AnimatedEntity: Entity
---@field New fun(self: AnimatedEntity, name: string): AnimatedEntity
---@field HasAnims boolean
AnimatedEntity = Noir.Class("AnimatedEntity", Entity)

---@param name string
function AnimatedEntity:Init(name)
    self:InitFrom(Entity, name)
    self.HasAnims = true
end

---@class Networked: NoirClass
---@field IsSyncing boolean
---@field New fun(self: Networked, isSyncing: boolean): Networked
Networked = Noir.Class("Networked")

---@param isSyncing boolean
function Networked:Init(isSyncing)
    self.IsSyncing = isSyncing
end

---@class Person: AnimatedEntity, Networked
---@field New fun(self: Person, name: string): Person
Person = Noir.Class("Person", Entity, Networked)

---@param name string
function Person:Init(name)
    self:InitFrom(AnimatedEntity, name)
    self:InitFrom(Networked, true)
end

local bob = Person:New("Bob")
print(bob.Name, bob.IsSyncing, bob.HasAnims)