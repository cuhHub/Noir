---
description: This page will go over Noir, and teach you how to setup an addon with Noir.
cover: .gitbook/assets/github.png
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

# 🚶‍♂️ Intro

## Links

[Noir GitHub Repo](https://github.com/cuhHub/Noir)

[Discord Community](https://dsc.gg/cuhhubsw)

## What is Noir?

Noir is a framework that helps Stormworks addon developers create addons in a neat, modular structure.

Noir also comes with built-in [services](tutorials/services.md) and [libraries](tutorials/libraries.md) to reduce the amount of code you have to write.&#x20;

## Prerequisites

This page will assume you already have an addon placed in `%appdata%/Stormworks/data/missions` (or somewhere else if you're experienced) that looks like:

```
📁 | Your Addon
        🔵 | script.lua
        🟠 | playlist.xml
    ...
```

## Installing Noir In Your Addon

Before we even set up an addon, let's install Noir first.

1. Run `git clone https://github.com/cuhHub/Noir.git`
2. Move `/Noir/src/Noir` into your addon directory
3. (OPTIONAL) Move `docs/intellisense.lua` from [this repo](https://github.com/Cuh4/StormworksAddonLuaDocumentation) into your addon directory for full intellisense with addon lua.

Your addon directory should now look like:

```
📁 | Your Addon
        📁 | Noir
                🔵 | Noir.lua
                ...
        🔵 | script.lua
        🔵 | intellisense.lua <-- optional
        🟠 | playlist.xml
```

Now, you need to use Noir in your `script.lua` file, but `Noir` is in a whole separate location. This is a problem because addons cannot use `require()`, but no worries! We need to simply integrate Noir into our `script.lua` file.

## Integrating Noir Using Noir's Tools

1. Extract all files in `/Noir/tools` from and place it in your addon dircetory.
2. Create an `__order.json` file in your addon directory containing the following:

{% code title="__order.json" lineNumbers="true" %}
```json
{
    "order" : [
        "Noir",
        "script.lua" // replace with your addon's main file. normally "script.lua"
    ]
}
```
{% endcode %}

3. Run `build.bat`. This will combine the contents of Noir and your addon and dump it all into a file called `build.lua`.

Your addon directory should now look like:

```
📁 | Your Addon
        📁 | Noir
                🔵 | Noir.lua
                ...
        🔵 | script.lua
        🔵 | intellisense.lua <-- optional
        🟠 | playlist.xml
        🟠 | __order.json
        🔵 | combine.py
        🟡 | build.bat
```

## Integrating Noir Using SW Lua VSCode Extension

This assumes you have the [Stormworks Lua VSCode Extension.](https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi)

1. Add `require("Noir.init")` into your `script.lua` file.
2. Use the build keybind, or search "Build" in the VSCode command palette.

You can now remove the `/Noir` directory you created earlier from `git clone`.

## Congratulations!

You've set up your addon with Noir. Head to the Tutorials section to figure out:

* How to start Noir
* Services
* Libraries
* ...etc
