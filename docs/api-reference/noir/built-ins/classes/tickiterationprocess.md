# TickIterationProcess

**Noir.Classes.TickIterationClass**: `NoirClass`

Represents a process in which code iterates through a table in chunks of x over how ever many necessary ticks.

---

```lua
Noir.Classes.TickIterationClass:Init(ID, tbl, chunkSize)
```
Initializes tick iteration process class objects.

### Parameters
- `ID`: integer
- `tbl`: table<integer, table<integer, - any>>
- `chunkSize`: integer

---

```lua
Noir.Classes.TickIterationClass:Iterate()
```
Iterate through the table in chunks of x over how ever many necessary ticks.

### Returns
- `boolean`: completed

---

```lua
Noir.Classes.TickIterationClass:CalculateChunks()
```
Calculate the chunks of the table.

### Returns
- `table<integer, table<integer,`: any>>