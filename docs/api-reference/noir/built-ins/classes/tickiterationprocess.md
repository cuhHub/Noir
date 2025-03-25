# TickIterationProcess

**Noir.Classes.TickIterationProcess**: `NoirClass`

Represents a process in which code iterates through a table in chunks of x over how ever many necessary ticks.

---

```lua
Noir.Classes.TickIterationProcess:Init(ID, tbl, chunkSize)
```
Initializes tick iteration process class objects.

### Parameters
- `ID`: integer
- `tbl`: table
- `chunkSize`: integer

---

```lua
Noir.Classes.TickIterationProcess:Iterate()
```
Iterate through the table in chunks of x over how ever many necessary ticks.

### Returns
- `boolean`: completed