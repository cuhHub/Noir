---
description: Noir's Libraries system allows you to format code neatly.
cover: ../.gitbook/assets/25.png
coverY: 0
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# 📖 Libraries

## What Are Libraries?

Libraries are simply tables containing helper methods. These methods can then be used throughout your addon.

## Libraries VS Services

The main distinction between libraries and services is that libraries do not need to listen for game callbacks. They simply return values and **do not manage anything**.&#x20;

Services on the other hand can return values, but they also **manage things** and listen for callbacks, etc.

## Built-In Libraries

Just like with services, Noir comes with built-in libraries. They can be found under `Noir.Libraries`.

Notable libraries are `Noir.Libraries.Class` and `Noir.Libraries.Events`.



### Class

{% code lineNumbers="true" %}
```lua
local Person = Noir.Libraries.Class:Create("Person")

function Person:Init(name)
    self.name = name
end

local bob = Person:New("Bob")
print(bob.name) -- "Bob"

-- supports inheritance too!
local Worker = Noir.Libraries.Class:Create("Worker", Person)

function Worker:Init(name)
    self:InitializeParent("[Worker] "..name)
end

local rob = Worker:New("Rob")
print(rob.name) -- "[Worker] Rob"
```
{% endcode %}

### Events

{% code lineNumbers="true" %}
```lua
local sayHello = Noir.Libraries.Events:Create()

sayHello:Connect(function(name)
    print("Hello, "..name)
end)

sayHello:Once(function(name) -- once this event is fired when this callback is listening, the callback gets disconnected
    print("Hello and bye forever, "..name) -- this means this will only run once
end)

for _ = 1, 5 do
    sayHello:Fire("Cuh4")
end

--[[
    terminal:
    "Hello, Cuh4"
    "Hello and bye forever, Cuh4"
    "Hello, Cuh4"
    "Hello, Cuh4"
    "Hello, Cuh4"
    "Hello, Cuh4"
]]

-- You can also disconnect a connection (function binded to an event) from an event
local connection = sayHello:Connect(function()
    -- bla bla
end)

connection:Disconnect()

-- Or even manually trigger the connection
connection:Fire()
```
{% endcode %}

## Creating A Library

Unlike services-ish, libraries are very simple to setup.

First, give your library a name. For this example, we'll call your library `Matrix`, and we'll have the library provide helper methods relating to SW matrices.

Define the library like so:

<pre class="language-lua" data-title="Matrix.lua" data-line-numbers><code class="lang-lua"><strong>MatrixLibrary = Noir.Libraries:Create("Matrix")
</strong></code></pre>

And simply add methods to it like so:

{% code title="Matrix.lua" lineNumbers="true" %}
```lua
function MatrixLibrary:Offset(pos, x, y, z)
    pos[13] = pos[13] + x
    pos[14] = pos[14] + y
    pos[15] = pos[15] + z
    return pos
end

...
```
{% endcode %}

You can then use the libary methods like so:

{% code title="main.lua" lineNumbers="true" %}
```lua
local myMatrix = matrix.translation(0, 1, 0)
print(myMatrix) -- 0, 1, 0

local new = MatrixLibrary:Offset(myMatrix, 0, 2, 0)
print(new) -- 0, 3, 0
print(myMatrix) -- 0, 3, 0
```
{% endcode %}

Uh oh! `myMatrix` also got changed from the `:Offset` method. We only want it to provide a new matrix to prevent issues. We could just use `matrix.translation`, but that would get rid of the rotational values. Instead, we can use a built-in library to copy the contents of `pos` (parameter of `:Offset()`)  into a new table, and modify that new table instead. We can use a built-in library for this!

{% hint style="info" %}
Matrices in Stormworks are actually tables.
{% endhint %}

{% code title="Matrix.lua" lineNumbers="true" %}
```lua
function MatrixLibrary:Offset(pos, x, y, z)
    local new = Noir.Libraries.Table:Copy(pos)
    new[13] = new[13] + x
    new[14] = new[14] + y
    new[15] = new[15] + z

    return new
end
```
{% endcode %}

Problem solved!

## Retrieving A Library

Libraries you create aren't stored in Noir. You have to store them yourselves by either placing them under `Noir.Libraries`, or just by placing it into `_ENV` like so:

```lua
MatrixLibrary = ... -- placed into _ENV
Noir.Libraries.MatrixLibrary = ... -- placed into Noir.Libraries
```

{% hint style="info" %}
\_ENV is a table containing globals.

{% code lineNumbers="true" %}
```lua
function hello()
    return "hello world"
end

_ENV["hello"]() -- "hello world"
_ENV.hello() -- "hello world"
hello() -- "hello world"

x = 0
_ENV["x"] -- 0
_ENV.x -- 0
```
{% endcode %}
{% endhint %}
