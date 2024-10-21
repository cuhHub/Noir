# TickIterationProcess

**Noir.Classes.TickIterationProcessClass**: `NoirClass`

Represents a process in which code iterates through a table in chunks of x over how ever many necessary ticks.

---

```lua
Noir.Classes.TickIterationProcessClass:Init(ID, tbl, chunkSize)
```
Initializes tick iteration process class objects.

### Parameters
- `ID`: integer
- `tbl`: table<integer, table<integer, - any>>
- `chunkSize`: integer

---

```lua
Noir.Classes.TickIterationProcessClass:Iterate()
```
Iterate through the table in chunks of x over how ever many necessary ticks.

### Returns
- `boolean`: completed

---

```lua
Noir.Classes.TickIterationProcessClass:CalculateChunks()
```
Calculate the chunks of the table.

### Returns
- `table<integer, table<integer,`: any>>