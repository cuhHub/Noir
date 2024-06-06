# Bootstrapper

**Noir.Bootstrapper**: `table`

An internal module of Noir that is used to initialize and start services. Do not use this in your code.

***

```lua
Noir.Bootstrapper:InitializeSavedata()
```

Set up g\_savedata. Do not use this in your code. This is used internally.

***

```lua
Noir.Bootstrapper:InitializeServices()
```

Initialize all services. This will order services by their `InitPriority` and then initialize them. Do not use this in your code. This is used internally.

***

```lua
Noir.Bootstrapper:StartServices()
```

Start all services. This will order services by their `StartPriority` and then start them. Do not use this in your code. This is used internally.
