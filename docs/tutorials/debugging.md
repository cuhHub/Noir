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

Debug is disabled by default, so to enable debug, set `Noir.Debugging.Enabled` to `true`.

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

By default this shows the called functions with the highest average self time. Self time excludes time spent in tracked children. If a function does 2 ms of work and calls a tracked function for 10 ms, its self time is 2 ms and its inclusive time is 12 ms. Untracked calls count towards the caller's self time.

`GetAverageExecutionTime()` and `GetLastExecutionTime()` return inclusive time. Use `GetAverageSelfExecutionTime()` and `GetLastSelfExecutionTime()` for self time. All timings are approximate milliseconds.

```lua
Noir.Debugging:ShowLeastPerformantTracked(20, false, true) -- rank by inclusive time
Noir.Debugging:ShowMostTotalSelfTimeTracked() -- rank by cumulative self time
Noir.Debugging:ShowMostCalledTracked(0, true) -- include all trackers

Noir.Debugging.ExecutionTimeWindow = 10 -- completed calls
Noir.Debugging.CallsPerTickWindow = 60 -- completed ticks, including idle ticks
Noir.Debugging.ReportLimit = 20
Noir.Debugging.IncludeUncalled = false
```

Disabling debugging pauses collection. `:ResetTrackers()` clears statistics and `:ClearTrackers()` removes the trackers. `:RemoveTracker(tracker)` restores table entries mounted by Noir if they still contain its wrapper. Existing local references to the original function bypass tracking.

If a callback aborts, the next managed game callback discards incomplete timings and counts the affected calls as interrupted. This also works for direct game callbacks mounted by `:TrackAll()` on `_ENV`.

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