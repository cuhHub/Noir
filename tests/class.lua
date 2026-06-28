--------------------------------------------------------
-- [Noir] Tests - Class
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

---@class Entity: NoirClass
---@field New fun(self: Entity, name: string): Entity
---@field Name string
Entity = Noir.Class("Entity")

---@param name string
function Entity:Init(name)
    self.Name = name
end

function Entity:SayEntityName()
    print(self.Name)
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

function AnimatedEntity:SayAnimatedEntityName()
    Entity.SayEntityName(self)
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
Person = Noir.Class("Person", AnimatedEntity, Networked)

---@param name string
function Person:Init(name)
    self:InitFrom(AnimatedEntity, name)
    self:InitFrom(Networked, true)
end

local bob = Person:New("Bob")

-- attributes
assert(bob.Name == "Bob", "Expected 'Bob' for name, got "..bob.Name)
assert(bob.IsSyncing == true, "Expected 'true' for IsSyncing, got "..tostring(bob.IsSyncing))
assert(bob.HasAnims == true, "Expected 'true' for HasAnims, got "..tostring(bob.HasAnims))

-- methods
assert(bob.SayEntityName == Entity.SayEntityName, "Expected 'Entity.SayEntityName' for SayEntityName, got "..tostring(bob.SayEntityName))
assert(bob.SayAnimatedEntityName == AnimatedEntity.SayAnimatedEntityName, "Expected 'AnimatedEntity.SayAnimatedEntityName' for SayAnimatedEntityName, got "..tostring(bob.SayAnimatedEntityName))

-- comparison
assert(AnimatedEntity:IsA(Entity), "Expected true for AnimatedEntity:IsA(Entity)")
assert(not Entity:IsA(AnimatedEntity), "Expected false for Entity:IsA(AnimatedEntity)")
assert(Person:IsA(AnimatedEntity), "Expected true for Person:IsA(AnimatedEntity)")
assert(Person:IsA(Networked), "Expected true for Person:IsA(Networked)")
assert(Person:IsA(Person), "Expected true for Person:IsA(Person)")
assert(Person:IsA(Entity), "Expected true for Person:IsA(Entity)")
assert(Person:IsExactly(Person), "Expected true for Person:IsExactly(Person)")
assert(Person:IsExactly(Entity) == false, "Expected false for Person:IsExactly(Entity)")
assert(Entity:IsExactly(Entity), "Expected true for Entity:IsExactly(Entity)")
assert(not AnimatedEntity:IsA(Networked), "AnimatedEntity should NOT inherit Networked")
assert(not Networked:IsA(AnimatedEntity), "Networked should NOT inherit AnimatedEntity")
assert(Person:IsA(Entity), "Person should inherit Entity")
assert(Person:IsA(Networked), "Person should inherit Networked")
assert(AnimatedEntity:IsA(Entity), "AnimatedEntity should inherit Entity")
assert(not Entity:IsA(Networked), "Entity should not inherit Networked")