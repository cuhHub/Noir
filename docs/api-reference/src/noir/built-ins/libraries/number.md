# Number

**Noir.Libraries.Number**: `NoirLibrary`

A library containing helper methods relating to numbers.

---

```lua
Noir.Libraries.Number:IsWithin(number, start, stop)
```
Returns whether or not the provided number is between the two provided values.

### Parameters
- `number`: number
- `start`: number
- `stop`: number
### Returns
- `boolean`

---

```lua
Noir.Libraries.Number:Clamp(number, min, max)
```
Clamps a number between two values.

### Parameters
- `number`: number
- `min`: number
- `max`: number
### Returns
- `number`

---

```lua
Noir.Libraries.Number:Round(number, decimalPlaces)
```
Rounds the number to the provided number of decimal places (defaults to 0).

### Parameters
- `number`: number
- `decimalPlaces`: number|nil
### Returns
- `number`

---

```lua
Noir.Libraries.Number:IsInteger(number)
```
Returns whether or not the provided number is an integer.

### Parameters
- `number`: number
### Returns
- `boolean`

---

```lua
Noir.Libraries.Number:Average(numbers)
```
Returns the average of the provided numbers.

### Parameters
- `numbers`: table<integer, number>
### Returns
- `number`