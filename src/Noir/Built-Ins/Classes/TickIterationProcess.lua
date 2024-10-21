--------------------------------------------------------
-- [Noir] Classes - Tick Iteration Process
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2024 Cuh4

        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------

--[[
    Represents a process in which code iterates through a table in chunks of x over how ever many necessary ticks.
]]
---@class NoirTickIterationProcess: NoirClass
---@field New fun(self: NoirTickIterationProcess, ID: number, tbl: table, chunkSize: integer): NoirTickIterationProcess
---@field ID integer The ID of this process
---@field IterationEvent NoirEvent Arguments: value (any), tick (integer), completed (boolean) | Fired when an iteration during a tick is occuring
---@field ChunkSize integer The number of values to iterate through per tick
---@field TableToIterate table The table to iterate through across ticks
---@field CurrentTick integer Represents the current tick the iteration is at
---@field Completed boolean Whether or not the iteration is completed
---@field _PreviousIndex any The last index used in iteration
Noir.Classes.TickIterationProcessClass = Noir.Class("NoirTickIterationProcess")

--[[
    Initializes tick iteration process class objects.
]]
---@param ID integer
---@param tbl table
---@param chunkSize integer
function Noir.Classes.TickIterationProcessClass:Init(ID, tbl, chunkSize)
    Noir.TypeChecking:Assert("Noir.Classes.TickIterationProcessClass:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.TickIterationProcessClass:Init()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Classes.TickIterationProcessClass:Init()", "chunkSize", chunkSize, "number")

    self.ID = ID
    self.IterationEvent = Noir.Libraries.Events:Create()
    self.ChunkSize = chunkSize
    self.TableToIterate = tbl
    self.CurrentTick = 0
    self.Completed = false
    self._PreviousIndex = nil
end

--[[
    Iterate through the table in chunks of x over how ever many necessary ticks.
]]
---@return boolean completed
function Noir.Classes.TickIterationProcessClass:Iterate()
    -- Increment the current tick
    self.CurrentTick = self.CurrentTick + 1

    -- Iterate 
    for _ = 1, self.ChunkSize do
        -- Get next index and value
        local index, value = next(self.TableToIterate, self._PreviousIndex)

        -- Nil check. This should never evaluate to true
        if index == nil then
            break
        end

        -- Set completed
        local completed = (next(self.TableToIterate, index) == nil)
        self.Completed = completed

        -- Set index
        self._PreviousIndex = index

        -- Fire event
        self.IterationEvent:Fire(index, value, self.CurrentTick, completed)

        -- Break if completed
        if completed then
            break
        end
    end

    -- Return
    return self.Completed
end