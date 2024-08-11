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

Noir is a framework that helps Stormworks addon developers create addons with a neat, modular structure.

Noir also comes with built-in [services](tutorials/services.md) and [libraries](tutorials/libraries.md) to reduce the amount of code you have to write.

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

1. Head to the [latest Noir release.](https://github.com/cuhHub/Noir/releases/latest)
2. Download the `Noir.lua` file.
3. Move the file into your addon directory.
4. (OPTIONAL) Move `docs/intellisense.lua` from [this repo](https://github.com/Cuh4/StormworksAddonLuaDocumentation) into your addon directory for full intellisense with addon lua.

Your addon directory should now look like:

```
📁 | Your Addon
        🔵 | Noir.lua
        🔵 | script.lua
        🔵 | intellisense.lua <-- optional
        🟠 | playlist.xml
```

Now, you need to use Noir in your `script.lua` file, but `Noir` is in a whole separate location. This is a problem because addons cannot use `require()`, but no worries! We need to simply integrate Noir into our `script.lua` file.

## Integrating Noir Using Noir's Tools

{% hint style="warning" %}
[Python](https://www.python.org/downloads/) is required for these tools, preferably `>3.12`.
{% endhint %}

1. Extract `requirements.txt`, `combine.py` and `build.bat` from [here](https://github.com/cuhHub/Noir/tree/main/tools/combine) from and place it in your addon directory.
2. Install the requirements by running `pip install -r requirements.txt`. You can delete the `requirements.txt` file after doing so.
3. Create an `__order.json` file in your addon directory containing the following:

{% code title="__order.json" lineNumbers="true" %}
```json
{
    "order" : [
        "Noir.lua",
        "script.lua" // replace with your addon's main file. normally "script.lua"
    ]
}
```
{% endcode %}

4. Run `build.bat`. This will combine the contents of Noir and your addon and dump it all into a file called `build.lua` by running `py combine.py` with specific arguments.

Your addon directory should now look like:

```
📁 | Your Addon
        🔵 | Noir.lua
        🔵 | script.lua
        🔵 | intellisense.lua <-- optional
        🟠 | playlist.xml
        🟠 | __order.json
        🔵 | combine.py
        🟡 | build.bat
```

## Integrating Noir Using SW Lua VSCode Extension

This assumes you have the [Stormworks Lua VSCode Extension.](https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi)

1. Add `require("Noir")` into your `script.lua` file.
2. Use the build keybind, or search "Build" in the VSCode command palette.

## Congratulations!

You've set up your addon with Noir. Head to the Tutorials section to figure out:

* How to start Noir
* Services
* Libraries
* ...etc
