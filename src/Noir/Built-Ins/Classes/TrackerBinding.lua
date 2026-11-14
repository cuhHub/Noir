--------------------------------------------------------
-- [Noir] Classes - TrackerBinding
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2026 Cuh4

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
    Records where a tracked function was mounted.
]]
---@class NoirTrackerBinding: NoirClass
---@field New fun(self: NoirTrackerBinding, tbl: table, key: any, original: function, wrapper: function): NoirTrackerBinding
---@field Table table The table containing the function
---@field Key any The key where the wrapper was mounted
---@field Original function The function previously stored at this key
---@field Wrapper function The mounted wrapper
Noir.Classes.TrackerBinding = Noir.Class("TrackerBinding")

--[[
    Initializes a tracker binding.
]]
---@param tbl table
---@param key any
---@param original function
---@param wrapper function
function Noir.Classes.TrackerBinding:Init(tbl, key, original, wrapper)
    Noir.TypeChecking:Assert("Noir.Classes.TrackerBinding:Init()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Classes.TrackerBinding:Init()", "original", original, "function")
    Noir.TypeChecking:Assert("Noir.Classes.TrackerBinding:Init()", "wrapper", wrapper, "function")

    self.Table = tbl
    self.Key = key
    self.Original = original
    self.Wrapper = wrapper
end