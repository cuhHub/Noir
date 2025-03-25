# HTTPResponse

**Noir.Classes.HTTPResponse**: `NoirClass`

Represents a response to a HTTP request.

---

```lua
Noir.Classes.HTTPResponse:Init(response)
```
Initializes HTTP response class objects.

### Parameters
- `response`: string

---

```lua
Noir.Classes.HTTPResponse:JSON()
```
Attempts to JSON decode the response. This will error if the response cannot be JSON decoded.

### Returns
- `any`

---

```lua
Noir.Classes.HTTPResponse:IsOk()
```
Returns whether or not the response is ok.

### Returns
- `boolean`