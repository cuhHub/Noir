# Libraries

**Noir.Libraries**: `table`

A module of Noir that allows you to create your own libraries to use throughout your code.

***

```lua
Noir.Libraries:Create(name, shortDescription, longDescription, authors)
```

Returns a library starter pack for you to use when creating libraries for your addon.

#### Parameters

* `name`: string
* `shortDescription`: string|nil
* `longDescription`: string|nil
* `authors`: table\<integer, string>|nil

#### Returns

* `NoirLibrary`
