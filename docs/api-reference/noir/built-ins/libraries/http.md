# HTTP

**Noir.Libraries.HTTP**: `NoirLibrary`

A library containing helper methods relating to HTTP.

---

```lua
Noir.Libraries.HTTP:URLEncode(str)
```
Encode a string into a URL-safe string.

### Parameters
- `str`: string
### Returns
- `string`

---

```lua
Noir.Libraries.HTTP:URLDecode(str)
```
Decode a URL-safe string into a string.

### Parameters
- `str`: string
### Returns
- `string`

---

```lua
Noir.Libraries.HTTP:URLParameters(parameters)
```
Convert a table of URL parameters into a string.

### Parameters
- `parameters`: table<string, any>
### Returns
- `string`

---

```lua
Noir.Libraries.HTTP:IsResponseOk(response)
```
Returns whether or not a response to a HTTP request is ok.

### Parameters
- `response`: string
### Returns
- `boolean`