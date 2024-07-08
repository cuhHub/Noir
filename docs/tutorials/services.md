---
description: Services are a fundamental part of Noir. This page will go over them.
cover: ../.gitbook/assets/21.png
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

# 🖥️ Services

## What Are Services?

Services, when simplified, are simply tables containing methods you can use throughout your code.

Unlike libraries, services tend to interact with the game and store data within itself or through `g_savedata`. Services can utilize one another as well as libraries.

Example:

{% code title="MyService.lua" lineNumbers="true" %}
```lua
local MyService = Noir.Services:CreateService("MyService") -- Create a service

-- Called when the service is initialized. This is to be used for setting up the service
function MyService:ServiceInit()
    self.AVariable = 5
end

-- Called when the service is started. This is to be used for setting up things that may require event connections, etc
function MyService:ServiceStart()
    Noir.Callbacks:Connect("onPlayerJoin", function()
        server.announce("Server", "A player joined!")
    end)
end

function MyService:ACustomMethod()
    server.announce("Server", "Hello World")
end
```
{% endcode %}

You probably noticed in the example that there are two strange methods - `ServiceInit`, and `ServiceStart`. These methods are strictly for service initialization and are actually quite useful.

Here's a quick rundown:

`ServiceInit` is called when the service is initialized by Noir after `Noir:Start()` is called.

`ServiceStart` is called when the service is started by Noir after `Noir:Start()` is called.

Both of these methods are optional, but be sure to use `ServiceInit` if you need to store data within your service or setup things like events.

Services can be stored as a variable and retrieved at anytime throughout your code, but you can also use `Noir.Services:GetService("MyService")` to retrieve a service. Note that this method only works if the service has been initialized (always the case after Noir has started).

## Built-In Services

Noir comes with built-in services to prevent you from writing a lot of code. They can be found under `Noir.Services` along with everything else relating to services.

A very notable built-in service is `Noir.Services.PlayerService` that wraps players in classes to make interacting with players more OOP than not.

## Creating A Service

Creating a service is simple. First, you need to give it a name. For this example, we'll assume the name of "MyService". Now, add the following code to your addon:

{% code title="MyService.lua" lineNumbers="true" %}
```lua
local MyService = Noir.Services:CreateService("MyService")
```
{% endcode %}

{% hint style="info" %}
It is recommended to create a separate .lua file for each service you create. These files can be bundled together into one using the tools provided by Noir or by using the Stormworks Lua VSCode extension.
{% endhint %}

### :ServiceInit()

Now, we're not all done. We can optionally add a [method](https://www.lua.org/pil/16.html) to our service called `ServiceInit`. This isn't required but is often used to setup events and generally store attributes. See the code sample below.

{% code title="MyService.lua" lineNumbers="true" %}
```lua
function MyService:ServiceInit()
    self.Something = true
end
```
{% endcode %}

As mentioned under [#what-are-services](services.md#what-are-services "mention"), `ServiceInit` is called when the service is initialized by Noir after `Noir:Start()` is called. This method is often used to store values in the service for later use.

You may be wondering what `self` is. Well, `:ServiceInit()` is a method, and `self` is automatically added as an argument because of the colon before `ServiceInit()`. Behind the scenes, Noir calls `ServiceInit` like so:

```lua
Service:ServiceInit()
```

Due to the `:`, `Service` is passed as the first argument to `ServiceInit`. This means that `self` in the example above is equivalent to `MyService`.

{% hint style="info" %}
This is known as OOP (Object-Oriented Programming). Check [this](https://www.lua.org/pil/16.html) out for more information.
{% endhint %}

### :ServiceStart()

Optionally, we can add another method to our service called `ServiceStart` which is called when the service is started by Noir.

<pre class="language-lua" data-title="MyService.lua" data-line-numbers data-full-width="false"><code class="lang-lua"><strong>function MyService:ServiceStart()
</strong>    Noir.Callbacks:Connect("onPlayerJoin", function()
        server.announce("Server", "A player joined!")
    end)
end
</code></pre>

{% hint style="info" %}
`Noir.Callbacks` will be talked about in a future page.
{% endhint %}

## Adding Credit

This is not necessary, but if you would like to add credit to your service for whatever reason. You can add a few extra parameters to `:CreateService()`.

<pre class="language-lua"><code class="lang-lua">Noir.Services:CreateService(
<strong>    "Name", -- The name of your service
</strong>    false, -- Whether or not this service is built into Noir. Always have this set to false
    "Short Description", -- A short description of your service
    "Loooongg description", -- A long description of your service
    {"Cuh4"} -- The authors of your service
)
</code></pre>

{% hint style="info" %}
Note that everything beyond the `"Name"` is optional. See [services.md](../api-reference/noir/services.md "mention").
{% endhint %}

## What's The Point?

Services help you structure your addon neatly. Instead of having 6 functions all in your script environment that interact with the same things but differently, you can bundle all of these functions into a service.

<pre class="language-lua" data-title="script.lua" data-line-numbers><code class="lang-lua"><strong>-- Unclean. Globals are cluttered.
</strong><strong>kickedPlayers = {}
</strong>bannedPlayers = {}

function Kick(peer_id)
    server.kickPlayer(peer_id)
    table.insert(kickedPlayers, peer_id)
end

function Ban(peer_id)
    server.banPlayer(peer_id)
    table.insert(bannedPlayers, peer_id)
end
</code></pre>

{% code title="ModerationService.lua" lineNumbers="true" %}
```lua
-- Clean. Globals aren't cluttered. Functions are all bundled together in a service.
local ModerationService = Noir.Services:CreateService("ModerationService")

function ModerationService:ServiceInit() 
    self.kickedPlayers = {}
    self.bannedPlayers = {}
end

function ModerationService:Kick(peer_id)
    server.kickPlayer(peer_id)
    table.insert(self.kickedPlayers, peer_id)
end

function ModerationService:Ban(peer_id)
    server.banPlayer(peer_id)
    table.insert(self.bannedPlayers, peer_id)
end
```
{% endcode %}

You can see this sort of format in games like Roblox.

## Intellisense Support

{% hint style="info" %}
Intellisense represents code auto-completion, linting, etc.
{% endhint %}

Services do have support for intellisense, but you do need to put some work into making your service intellisense-compatible.

{% hint style="warning" %}
For intellisense, you'll need this [VSCode extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua).
{% endhint %}

Assuming your service looks like:

```lua
local MyService = Noir.Services:CreateService("MyService")

function MyService:ServiceInit()
    self.something = true
end

function MyService:ServiceStart()
    
end

function MyService:ACustomMethod()
    server.announce("Server", "Hello World")
    return true
end
```

You would add this directly above `:CreateService()`:

```lua
---@class MyService: NoirService
---@field something boolean A service attribute
```

The final result should look like:

```lua
---@class MyService: NoirService
---@field something boolean A service attribute
local MyService = Noir.Services:CreateService("MyService")

function MyService:ServiceInit()
    self.something = true
end

function MyService:ServiceStart()
    
end

function MyService:ACustomMethod()
    server.announce("Server", "Hello World")
    return true
end
```
