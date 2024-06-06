# ObjectService

**Noir.Services.ObjectService**: `NoirService`

A service for wrapping SW objects in classes.

***

```lua
Noir.Services.ObjectService:_SaveObjects(objects)
```

Overwrite saved objects.

Used internally. Do not use in your code.

#### Parameters

* `objects`: table\<integer, NoirSerializedObject>

***

```lua
Noir.Services.ObjectService:_GetSavedObjects()
```

Get saved objects.

Used internally. Do not use in your code.

#### Returns

* `table<integer, NoirSerializedObject>`

***

```lua
Noir.Services.ObjectService:GetObjects()
```

Get all objects.

#### Returns

* `table<integer, NoirObject>`

***

```lua
Noir.Services.ObjectService:_SaveObjectSavedata(object)
```

Save an object to g\_savedata.

Used internally. Do not use in your code.

#### Parameters

* `object`: NoirObject

***

```lua
Noir.Services.ObjectService:_RemoveObjectSavedata(object_id)
```

Remove an object from g\_savedata.

Used internally. Do not use in your code.

#### Parameters

* `object_id`: integer

***

```lua
Noir.Services.ObjectService:RegisterObject(object_id)
```

Registers an object by ID.

#### Parameters

* `object_id`: integer

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:GetObject(object_id)
```

Returns the object with the given ID.

#### Parameters

* `object_id`: integer

#### Returns

* `NoirObject|nil`

***

```lua
Noir.Services.ObjectService:RemoveObject(object_id)
```

Removes the object with the given ID.

#### Parameters

* `object_id`: integer
