---
description: >-
  This page will go over Noir's class system. Classes are used throughout Noir,
  like for services, etc.
cover: ../.gitbook/assets/25.png
coverY: 0
---

# 💥 Classes

## What Are Classes?

{% hint style="warning" %}
All of this might be confusing if you don't understand OOP. Consider reading up on [this](https://en.wikipedia.org/wiki/Object-oriented_programming) if you don't know or properly understand OOP.
{% endhint %}

In Noir, classes are simply advanced tables that can be cloned numerous times into class objects.

This is an example of a class. The `---@` bits are for intellisense.

{% code title="person.lua" lineNumbers="true" %}
```lua
---@class Person: NoirClass <-- For intellisense
---@field New fun(self: Person, name: string, occupation: string): Person <-- so the Lua extension thinks Person:New() returns a Person and not a NoirClass
---@field name string The name of this person
---@field occupation string The occupation of this person
local Person = Noir.Class("Person")

---@param name string
---@param occupation string
function Person:Init(name, occupation)
    self.name = name
    self.occupation = occupation
end

function Person:PrintInfo()
    print(("I am %s, my occupation is %s."):format(self.name, self.occupation))
end

-- Creating an object/instance from the class above
local JohnDoe = Person:New("John Doe", "Unoccupied")
JohnDoe:PrintInfo()
```
{% endcode %}

## Creating A Class

We can create a class by simply calling `Noir.Class` and providing a name as the first argument.

{% code title="MyClass.lua" lineNumbers="true" %}
```lua
local MyClass = Noir.Class("MyClass")
```
{% endcode %}

This class is missing an `:Init()` method, which is required! Let's fix that.

{% code title="MyClass.lua" lineNumbers="true" %}
```lua
function MyClass:Init(name) -- Arguments passed by MyClass:New() end up here
    self.name = name -- Create a class attribute
end
```
{% endcode %}

To break this down, every time `MyClass:New()` is called, a new table is created, and methods from `MyClass` are copied over (apart from `:Init()` and internal methods). Once this is done, `MyClass.Init()` is called, with the first argument being the new table.

This `:Init()` method is essentially responsible for setting up class objects descending from `MyClass`. This is similar to Python's `__init__` method for classes.

## Adding Custom Methods

Adding a custom method is very simple. It's essentially the same as the `:Init()` method, but we rename the method and change the functionality.

{% code title="MyClass.lua" lineNumbers="true" %}
```lua
function MyClass:MyName()
    return self.name
end
```
{% endcode %}

This method essentially returns the name that was stored in class objects descending from `MyClass` because of the `:Init()` method.

## Creating A Class Object From A Class

To create an object from a class, simply call the `:New()` method like so:

{% code title="main.lua" lineNumbers="true" %}
```lua
local MyObject = MyClass:New("Cuh4")
print(MyObject.name) -- "Cuh4"
print(MyObject:MyName()) -- "Cuh4"
```
{% endcode %}

Easy as that! Note that arguments passed to `:New()` will be passed to the class's `:Init()` method, as said earlier.

## Inheritance

Noir's classes system has support for inheritance. To inherit from another class, simply provide the class you want to inherit from as the second argument to `Noir.Class()`.

{% code title="Cuh4.lua" lineNumbers="true" %}
```lua
local Cuh4 = Noir.Class("Cuh4", MyClass, ...) -- you can inherit from multiple classes

function Cuh4:Init()
    self:InitFrom(
      MyClass, -- class to initialize from
      "Cuh4"
    )
end
```
{% endcode %}

`self:InitFrom()` essentially creates an object from `MyClass` (the parent class we passed to the method) and passes all created attributes and methods down to the new `Cuh4` object.

{% code title="main.lua" lineNumbers="true" %}
```lua
local cuh4 = Cuh4:New()
print(cuh4.name) -- "Cuh4"
print(cuh4:MyName()) -- "Cuh4"
```
{% endcode %}

## Intellisense

Intellisense is relatively easy to setup with classes. Check out the example at the start of this page.

Consider reading up on [this](https://luals.github.io/wiki/annotations/#class) for more information on using intellisense with classes.
