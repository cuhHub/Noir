# JSON

**Noir.Libraries.JSON**: `NoirLibrary`

A library containing helper methods to serialize Lua objects into JSON and back.

This code is from https://gist.github.com/tylerneylon/59f4bcf316be525b30ab

***

**Noir.Libraries.JSON.Null**: `table`

Represents a null value.

***

```lua
Noir.Libraries.JSON:KindOf(obj)
```

Returns the type of the provided object.

Used internally. Do not use in your code.

#### Parameters

* `obj`: any

#### Returns

* `"nil"|"boolean"|"number"|"string"|"table"|"function"|"array"`

***

```lua
Noir.Libraries.JSON:EscapeString(str)
```

Escapes a string for JSON.

Used internally. Do not use in your code.

#### Parameters

* `str`: string

#### Returns

* `string`

***

```lua
Noir.Libraries.JSON:SkipDelim(str, pos, delim, errIfMissing)
```

Finds the point where a delimiter is and simply returns the point after.

Used internally. Do not use in your code.

#### Parameters

* `str`: string
* `pos`: integer
* `delim`: string
* `errIfMissing`: boolean|nil

#### Returns

* `integer`
* `boolean`

***

```lua
Noir.Libraries.JSON:ParseStringValue(str, pos, val)
```

Parses a string.

Used internally. Do not use in your code.

#### Parameters

* `str`: string
* `pos`: integer
* `val`: string|nil

#### Returns

* `string`
* `integer`

***

```lua
Noir.Libraries.JSON:ParseNumberValue(str, pos)
```

Parses a number.

Used internally. Do not use in your code.

#### Parameters

* `str`: string
* `pos`: integer

#### Returns

* `integer`
* `integer`

***

```lua
Noir.Libraries.JSON:Encode(obj, asKey)
```

Encodes a Lua object as a JSON string.

#### Parameters

* `obj`: table|number|string|boolean|nil
* `asKey`: boolean|nil

#### Returns

* `string`

***

```lua
Noir.Libraries.JSON:Decode(str, pos, endDelim)
```

Decodes a JSON string into a Lua object.

#### Parameters

* `str`: string
* `pos`: integer|nil
* `endDelim`: string|nil

#### Returns

* `any`
* `integer`
