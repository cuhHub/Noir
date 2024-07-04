# Base64

**Noir.Libraries.Base64**: `NoirLibrary`

A library containing helper methods to serialize strings into Base64 and back.

This code is from https://gist.github.com/To0fan/ca3ebb9c029bb5df381e4afc4d27b4a6

***

**Noir.Libraries.Base64.Characters**: `string`

Character table as a string.

Used internally, do not use in your code.

***

```lua
Noir.Libraries.Base64:Encode(data)
```

Encode a string into Base64.

#### Parameters

* `data`: string

#### Returns

* `string`

***

```lua
Noir.Libraries.Base64:_EncodeInitial(data)
```

Used internally, do not use in your code.

#### Parameters

* `data`: string

#### Returns

* `string`

***

```lua
Noir.Libraries.Base64:_EncodeFinal(data)
```

Used internally, do not use in your code.

#### Parameters

* `data`: string

#### Returns

* `string`

***

```lua
Noir.Libraries.Base64:Decode(data)
```

Decode a string from Base64.

#### Parameters

* `data`: string

#### Returns

* `string`

***

```lua
Noir.Libraries.Base64:_DecodeInitial(str)
```

Used internally, do not use in your code.

#### Parameters

* `str`: string

#### Returns

* `string`

***

```lua
Noir.Libraries.Base64:_DecodeFinal(str)
```

Used internally, do not use in your code.

#### Parameters

* `str`: string

#### Returns

* `string`
