# HTTPResponse

**Noir.Classes.HTTPResponseClass**: `NoirClass`

Represents a response to a HTTP request.

---

```lua
Noir.Classes.HTTPResponseClass:Init(response)
```
Initializes HTTP response class objects.

### Parameters
- `response`: string

---

```lua
Noir.Classes.HTTPResponseClass:JSON()
```
Attempts to JSON decode the response. This will error if the response cannot be JSON decoded.

### Returns
- `any`

---

```lua
Noir.Classes.HTTPResponseClass:IsOk()
```
Returns whether or not the response is ok.

### Returns
- `boolean`