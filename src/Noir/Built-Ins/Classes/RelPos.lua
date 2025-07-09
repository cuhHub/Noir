--------------------------------------------------------
-- [Noir] Classes - Rel Pos
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2025 Cuh4

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
    Represents a relative position.<br>
    See the built-in `RelPosService` for more info.
]]
---@class NoirRelPos: NoirClass
---@field New fun(self: NoirRelPos, tileName: string, offset: SWMatrix): NoirRelPos
---@field TileName string The tile name
---@field Offset SWMatrix The offset from the tile's origin
Noir.Classes.RelPos = Noir.Class("RelPos")

--[[
    Initializes class objects from this class.
]]
---@param tileName string
---@param offset SWMatrix
function Noir.Classes.RelPos:Init(tileName, offset)
    Noir.TypeChecking:Assert("Noir.Classes.RelPos:Init()", "tileName", tileName, "string")
    Noir.TypeChecking:Assert("Noir.Classes.RelPos:Init()", "offset", offset, "table")

    self.TileName = tileName
    self.Offset = offset
end

--[[
    Returns all global positions this relative position can be found at.
]]
---@return table<integer, SWMatrix>
function Noir.Classes.RelPos:GetGlobalPositions()
    return Noir.Services.RelPosService:GetGlobalPositions(self)
end