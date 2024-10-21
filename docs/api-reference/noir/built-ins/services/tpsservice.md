# TPSService

**Noir.Services.TPSService**: `NoirService`

A service for retrieving the TPS (Ticks Per Second) of the server.    TPS calculations are from Trapdoor: https://discord.com/channels/357480372084408322/905791966904729611/1270333300635992064 - https://discord.gg/stormworks

---

```lua
Noir.Services.TPSService:_CalculateTPS(past, now, gameTicks)
```
Calculates TPS from two points in time.

### Parameters
- `past`: number
- `now`: number
- `gameTicks`: number
### Returns
- `number`

---

```lua
Noir.Services.TPSService:SetTPS(desiredTPS)
```
Set the desired TPS. The service will then slow the game down until the desired TPS is achieved. Set to 0 to disable this.

### Parameters
- `desiredTPS`: number - 0 = disabled

---

```lua
Noir.Services.TPSService:GetTPS()
```
Get the TPS of the server.

### Returns
- `number`

---

```lua
Noir.Services.TPSService:GetAverageTPS()
```
Get the average TPS of the server.

### Returns
- `number`

---

```lua
Noir.Services.TPSService:SetPrecision(precision)
```
Set the amount of ticks to use when calculating the average TPS.

Eg: if this is set to 10, the average TPS will be calculated over a period of 10 ticks.

### Parameters
- `precision`: integer