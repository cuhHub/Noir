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
Noir.Libraries.Table:ToString(tbl, indent, _journey)
```
Converts a table to a string by iterating deep through the table.

### Parameters
- `tbl`: table
- `indent`: integer|nil
- `_journey`: table<table, boolean>|nil
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
Noir.Libraries.Table:DeepCopy(tbl, _journey)
```
Copy a table (deep).

### Parameters
- `tbl`: tbl
- `_journey`: table|nil
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

---

```lua
Noir.Libraries.Table:FindDeep(tbl, value)
```
Find a value in a table. Unlike `:Find()`, this method will recursively search through nested tables to find the value.

### Parameters
- `tbl`: table
- `value`: any
### Returns
- `any|nil,`: table|nil

---

```lua
Noir.Libraries.Table:Map(tbl, callback)
```
Calls the function for every value in a table, and returns a new table with the results.        local myTbl = {1, 2, 3}

### Parameters
- `tbl`: table
- `callback`: fun(index: - any, value: any): any
### Returns
- `table`

---

```lua
Noir.Libraries.Table:Filter(tbl, callback)
```
Calls the function for every value in the provided table, keeping the value in a new table if the    function returns true.

### Parameters
- `tbl`: table
- `callback`: fun(index: - any, value: any): boolean
### Returns
- `table`

---

```lua
Noir.Libraries.Table:FilterSequential(tbl, callback)
```
Calls the function for every value in the provided table, keeping the value in a new table if the    function returns false. Unlike `:Filter()`, the indices are not maintained and `table.insert` is used instead.

### Parameters
- `tbl`: table
- `callback`: fun(index: - any, value: any): boolean
### Returns
- `table`