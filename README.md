<div align="center">
    <img src = "imgs/banner.png">
</div>

<div align="center">
    <img src="https://img.shields.io/badge/Stormworks-Build%20and%20Rescue-blue?style=for-the-badge">
    <img src="https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white">
    <img src="https://img.shields.io/badge/Addon%20Framework-9e6244?style=for-the-badge">
</div>

## 📚 Overview
Noir is a framework for Stormworks: Build and Rescue designed to (metaphorically!) hold your hand in some areas with addon development, while also giving you a neat way of organizing your addon.

Noir contains libraries that provide helpful functions to use throughout your code. They can be found in `Noir.Libraries`.

Noir also contains default services which can be found in `Noir.Services`. (TODO)

## ❔ Example
Let's say your addon needs to spawn objects, then despawn them after some time. You can create something called a `Service` that handles this.

```lua
JanitorService = Noir.Services:CreateService("JanitorService")
JanitorService.initPriority = 1 -- dictates the order of which services are initialized first
JanitorService.startPriority = 1 -- same here, but with starting services
```

Boom, we created our first service! 

---

However, if we started Noir with `Noir:Start()`, we would encounter an error with the service relating to missing a `:ServiceInit()` method. We can fix that like so:

```lua
function JanitorService:ServiceInit()
    self.pendingCleanups = {}
end
```

The `:ServiceInit()` method is used to setup things relating to the service.

---

We can then use the optional `:ServiceStart()` method to setup the actual functionality of our service.

```lua
function JanitorService:ServiceStart()
    self.onTick = Noir.Callbacks:Connect("onTick", function()
        for objectID, timer in pairs(self.pendingCleanups) do
            if (server.getTimeMillisec() / 1000) - timer.startedAt >= timer.duration then
                server.despawnObject(objectID, true)
                self.pendingCleanups[objectID] = nil
            end
        end
    end)
end
```

This essentially despawns objects in the `pendingCleanups` table if too much time passes.

---

Now, let's add in a custom method to add objects to `pendingCleanups`.

```lua
---@param object_id integer <-- This is a parameter annotation. This is used for intellisense from the Lua LSP VSCode extension.
---@param duration number
function JanitorService:Clean(object_id, duration)
    self.pendingCleanups[object_id] = {
        duration = duration,
        startedAt = server.getTimeMillisec() / 1000
    }
end
```

Now, we have a fully working service! 🥳 Do note that `Noir.Services:GetService()` will error if the service you are trying to retrieve hasn't initialized yet or doesn't exist.

---

If you would like intellisense, you will need to add some extra bits:

```lua
---@class JanitorService: NoirService
---@field pendingCleanups table<integer, JanitorServiceTimer>
---@field onTick NoirConnection
---
---@field Clean fun(self: JanitorService, object_id: integer, duration: number)

---@class JanitorServiceTimer
---@field duration integer
---@field startedAt integer
```

As well as add `---@type JanitorService` there and then. Be sure to disable the `assign-type-mismatch` diagnostic too.

## 🔨 Installation
Sorry, installation is complicated, but here's how:
- Run `git clone https://github.com/cuhHub/Noir`
- Move `src/Noir` into your addon directory.
- Extract all files in `tools` and place them into your addon directory.
- Create a file called `__order.json` and place the following into it:
```json
{
    "order" : [
        "Noir",
        "script.lua"
    ]
}
```
- Run `build.bat` every time you change your addon. This will combine the contents of `Noir` and your addon's `script.lua` file into one file called `build.lua`. You can copy and paste the contents of `build.lua` into your `script.lua` file, or even create a script that automates that.

If you are somewhat patient, you can manually add `require()` into each Noir .lua file and use the [Stormworks VSCode extension's](https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi) build feature.

## ✨ Credit
- [Cuh4](https://github.com/Cuh4)