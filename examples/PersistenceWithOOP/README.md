# Persistence With OOP
Saving data without OOP is easy as you can directly use `g_savedata`.
```lua
g_savedata = {
    objects = {}
}

function createObject(id)
    g_savedata.objects[id] = {
        X = 0,
        Y = 0
    }
end

function moveObject(id, x, y)
    g_savedata.objects[id].X = x
    g_savedata.objects[id].X = y
end
```
But with Noir, this isn't really doable nor recommended. Especially since classes created with Noir (and also used everywhere in Noir and hopefully your addon code) contain functions which can't be stored in `g_savedata`.
```lua
g_savedata = {
    objects = {} -- you wouldn't do this in Noir. use services instead with all the provided save data methods
}

Object = Noir.Class("Object")

function Object:Init(x, y)
    self.X = x
    self.Y = y
end

function Object:Move(x, y)
    self.X = x
    self.Y = y
end

local myObject = Object:New(0, 0)
table.insert(g_savedata.objects, myObject) -- wouldn't work. `myObject` contains functions (`:Move()`, and internal functions)
```
Luckily, the built-in `HoarderService` was built specifically for this issue to bridge the gap and make it much easier and less cumbersome to save classes without having to write so much code.

See `example.lua` in this folder to see an example.