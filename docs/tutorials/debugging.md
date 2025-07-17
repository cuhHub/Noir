---
description: >-
  This page will go over Noir's debugging system which can be used to figure out
  where you can optimize  your code. You can track the statistics and
  performance of individual functions, services, etc.
cover: ../.gitbook/assets/6.png
coverY: 0
---

# 🔎 Debugging

## Enabling Debug

Debug is disabled by default, so to enable debug, set `Noir.Debugging.Enabled`to `true`.

{% code title="main.lua" lineNumbers="true" %}
```lua
Noir.Started:Once(function()
    -- ...
end)

Noir.Debugging.Enabled = true
```
{% endcode %}

## Trackers

A tracker represents a function that is being tracked by Noir's debugging suite. You can track a function easily like so:

{% code title="debugging.lua" %}
```lua
function doTheFoo()
    print("Hello world!")
end

local tracker = Noir.Debugging:TrackFunction("doTheFoo", doTheFoo)
```
{% endcode %}

You can then overwrite the function with the version that comes with debugging like so:

{% code title="debugging.lua" %}
```lua
doTheFoo = tracker:Mount()
```
{% endcode %}

{% hint style="info" %}
This is done automatically when using `:TrackAll()`and `:TrackService()`.
{% endhint %}

Now, when you call a tracked function that has been overwritten with `:Mount()`, statistics like how long it took to execute the function, the amount of times the function has been called and the average execution time are gathered and saved within the tracker. You can then access the statistics at any point via the tracker's attributes.

{% code title="debugging.lua" %}
```lua
doTheFoo()

tracker:GetCallCount() -- 1
tracker:GetAverageExecutionTime() -- 0.0 (in ms)
tracker:GetLastExecutionTime() -- latest execution time, 0.0 (also in ms)
```
{% endcode %}

## Viewing All Stats

The best part about the debugging is being able to sort all tracked functions based on how well they perform or how recently they've been called, and then show you the stats to determine where you should optimize. You can do this with a single method call too.

{% code title="debugging.lua" %}
```lua
Noir.Debugging:ShowLeastPerformantTracked()
```
{% endcode %}

This will print out all tracked functions and their statistics in order of performance (least performant being shown first).

If you need the tracked functions sorted and returned, you can use the `Get`variant instead.

{% code title="debugging.lua" %}
```lua
local trackers = Noir.Debugging:GetLeastPerformantTracked()
```
{% endcode %}

## Tracking In Bulk

Tracking every function one-by-one is tedious however, so instead if your functions are in a table, or better yet, a service, you can track them like so:

#### Tables

{% code title="debugging.lua" %}
```lua
functions = {
    foo = function()
        print("foo")
    end,
    
    bar = function()
        print("bar")
    end
}

Noir.Debugging:TrackAll("functions", functions)
```
{% endcode %}

#### Services

{% code title="debugging.lua" overflow="wrap" %}
```lua
MyService = Noir.Services:CreateService("MyService")

function MyService:Foo()
    print("foo")
end

Noir.Debugging:TrackService(MyService) -- no need for a name argument, the service comes with a name
```
{% endcode %}

## Error Detection

Unfortunately, Noir's debugging tools does not allow you to detect errors that well. It is recommended to use [SSSWTool ](https://github.com/Avril112113/SSSWTool)instead as it detects errors and provides extremely accurate traceback so you can see exactly where your code errored.

## And More...

See the [api-reference](../api-reference/ "mention") for all available methods to mess with.
