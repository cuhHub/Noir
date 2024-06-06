# String

**Noir.Libraries.String**: `NoirLibrary`

A library containing helper methods relating to strings.

***

```lua
Noir.Libraries.String:Split(str, separator)
```

Splits a string by the provided separator (defaults to " ").

#### Parameters

* `str`: string
* `separator`: string|nil

#### Returns

* `table<integer, string>`

***

```lua
Noir.Libraries.String:SplitLines(str)
```

Splits a string by their lines.

#### Parameters

* `str`: string

#### Returns

* `table<integer, string>`
