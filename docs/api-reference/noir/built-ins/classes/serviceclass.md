# ServiceClass

**Noir.Classes.ServiceClass**: `NoirClass`

Represents a Noir service.

***

```lua
Noir.Classes.ServiceClass:Init(name, isBuiltIn)
```

Initializes service class objects.

#### Parameters

* `name`: string
* `isBuiltIn`: boolean

***

```lua
Noir.Classes.ServiceClass:_Initialize()
```

Initialize this service.

Used internally.

***

```lua
Noir.Classes.ServiceClass:_Start()
```

Start this service.

Used internally.

***

```lua
Noir.Classes.ServiceClass:_CheckSaveData()
```

Checks if g\_savedata is intact.

Used internally.

#### Returns

* `boolean`

***

```lua
Noir.Classes.ServiceClass:Save(index, data)
```

Save a value to g\_savedata under this service.

#### Parameters

* `index`: string
* `data`: any

***

```lua
Noir.Classes.ServiceClass:Load(index, default)
```

Load data from g\_savedata that was saved via the :Save() method.

#### Parameters

* `index`: string
* `default`: any

#### Returns

* `any`

***

```lua
Noir.Classes.ServiceClass:Remove(index)
```

Remove data from g\_savedata that was saved via the :Save() method.

#### Parameters

* `index`: string
