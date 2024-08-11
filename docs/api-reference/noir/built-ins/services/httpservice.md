# HTTPService

**Noir.Services.HTTPService**: `NoirService`

A service for sending HTTP requests.

Requests are localhost only due to Stormworks limitations.

---

```lua
Noir.Services.HTTPService:_FindRequest(URL, port)
```
Get earliest request for a URL and port.

Used internally.

### Parameters
- `URL`: string
- `port`: integer
### Returns
- `NoirHTTPRequest|nil,`: integer|nil

---

```lua
Noir.Services.HTTPService:IsPortValid(port)
```
Returns if a port is within the valid port range.

### Parameters
- `port`: integer
### Returns
- `boolean`

---

```lua
Noir.Services.HTTPService:GET(URL, port, callback)
```
Send a GET request.

All requests are localhost only. This is a Stormworks limitation.

### Parameters
- `URL`: string
- `port`: integer
- `callback`: fun(response: - NoirHTTPResponse)
### Returns
- `NoirHTTPRequest|nil`

---

```lua
Noir.Services.HTTPService:GetActiveRequests()
```
Returns all active requests.

### Returns
- `table<integer, NoirHTTPRequest>`