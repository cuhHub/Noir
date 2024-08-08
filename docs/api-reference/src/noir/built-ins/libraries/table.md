# Table

**Noir.Libraries.Table**: `NoirLibrary`

A library containing helper methods relating to tables.

---

```lua
Noir.Libraries.Table:Length(tbl)
```
Returns the length of the provided table.

### Parameters
- `tbl`: table
### Returns
- `integer`

---

```lua
Noir.Libraries.Table:Random(tbl)
```
Returns a random value in the provided table.

### Parameters
- `tbl`: table
### Returns
- `any`

---

```lua
Noir.Libraries.Table:Keys(tbl)
```
Return the keys of the provided table.

### Parameters
- `tbl`: table
### Returns
- `tbl`

---

```lua
Noir.Libraries.Table:Values(tbl)
```
Return the values of the provided table.

### Parameters
- `tbl`: tbl
### Returns
- `tbl`

---

```lua
Noir.Libraries.Table:Slice(tbl, start, finish)
```
Get a portion of a table between two points.

### Parameters
- `tbl`: tbl
- `start`: number|nil
- `finish`: number|nil
### Returns
- `tbl`

---

```lua
Noir.Libraries.Table:ToString(tbl, indent)
```
Converts a table to a string by iterating deep through the table.

### Parameters
- `tbl`: table
- `indent`: integer|nil
### Returns
- `string`

---

```lua
Noir.Libraries.Table:Copy(tbl)
```
Copy a table (shallow).

### Parameters
- `tbl`: tbl
### Returns
- `tbl`

---

```lua
Noir.Libraries.Table:DeepCopy(tbl)
```
Copy a table (deep).

### Parameters
- `tbl`: tbl
### Returns
- `tbl`

---

```lua
Noir.Libraries.Table:Merge(tbl, other)
```
Merge two tables together (unforced).

### Parameters
- `tbl`: table
- `other`: table
### Returns
- `table`

---

```lua
Noir.Libraries.Table:ForceMerge(tbl, other)
```
Merge two tables together (forced).

### Parameters
- `tbl`: table
- `other`: table
### Returns
- `table`

---

```lua
Noir.Libraries.Table:Find(tbl, value)
```
Find a value in a table. Returns the index, or nil if not found.

### Parameters
- `tbl`: table
- `value`: any
### Returns
- `any|nil`