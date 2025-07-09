--------------------------------------------------------
-- [Noir] Services - RelPos Service
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
    Represents a tile range.<br>
    Used in the built-in `RelPosService`.
]]
---@class NoirTileRange
---@field X table<integer, number> The X range of the tile: {min, max}
---@field Z table<integer, number> The Z range of the tile: {min, max}

--[[
    This is a service that allows you to convert a global position into an offset from the tile the global position rests on (if any).<br>
    This allows you to create positions that work in all seeds without having to create a zone in the addon editor and such.<br>

    In order to initially get a relative position for a global position and save it, you'll need to make a command.
]]
---@class NoirRelPosService: NoirService
---@field _TILE_SIZE number The size of a tile in meters
---@field _TILE_RANGES table<integer, NoirTileRange> The tile ranges of all "planets"
---@field _TileCache table<string, table<integer, SWMatrix>> A cache of all the global positions of tiles (center of tile)
Noir.Services.RelPosService = Noir.Services:CreateService(
    "RelPosService",
    true,
    "",
    "",
    {"Cuh4"}
)

function Noir.Services.RelPosService:ServiceInit()
    self._TILE_SIZE = 1000

    self._TILE_RANGES = {
        { -- Earth
            X = {-65500, 64500},
            Z = {-63500, 126500}
        },

        { -- Moon
            X = {183500, 215500},
            Z = {-16500, 15500}
        }
    }

    self._TileCache = {}
    self:_FillTileCache()
end

--[[
    Fills the tile cache.
]]
function Noir.Services.RelPosService:_FillTileCache()
    local start = server.getTimeMillisec()
    local count = 0

    for _, tileRange in pairs(self._TILE_RANGES) do
        for x = tileRange.X[1], tileRange.X[2], self._TILE_SIZE do
            for z = tileRange.Z[1], tileRange.Z[2], self._TILE_SIZE do
                local center = matrix.translation(x + self._TILE_SIZE / 2, 0, z + self._TILE_SIZE / 2)
                local tile, success = server.getTile(center)

                if not success then
                    goto continue
                end

                local name = tile.name

                if not self._TileCache[name] then
                    self._TileCache[name] = {}
                    count = count + 1
                end

                table.insert(self._TileCache[name], center)

                ::continue::
            end
        end
    end

    local took = (server.getTimeMillisec() - start) / 1000 -- seconds
    Noir.Libraries.Logging:Info("RelPosService", "Took %.5f seconds to fill tile cache. Got positions for %d tiles.", took, count)
end

--[[
    Returns all global positions from a relative position.
]]
---@param relPos NoirRelPos
---@return table<integer, SWMatrix>
function Noir.Services.RelPosService:GetGlobalPositions(relPos)
    local positions = self._TileCache[relPos.TileName]

    if not positions then
        return {}
    end

    local offsetsApplied = {}

    for _, position in pairs(positions) do
        table.insert(offsetsApplied, matrix.multiply(position, relPos.Offset))
    end

    return offsetsApplied
end

--[[
    Returns a relative position from the provided global position.<br>
    A relative position is a simply a position relative to the closest tile to the provided global position.<br>
    This is useful as you can create positions that work in all seeds.
]]
---@param position SWMatrix
---@return NoirRelPos
function Noir.Services.RelPosService:GetRelPos(position)
    local tile, success = server.getTile(position)

    if not success then
        error("Noir.Services.RelPosService:GetRelPos()", "Failed to get tile from provided position.")
    end

    local origin = server.getTileTransform(position, tile.name, self._TILE_SIZE * 2)
    local relPos = self:CreateRelPos(tile.name, matrix.translation(position[13] - origin[13], position[14] - origin[14], position[15] - origin[15]))

    return relPos
end

--[[
    Creates a relative position with the provided tile name and offset.
]]
---@param tileName string
---@param offset SWMatrix
---@return NoirRelPos
function Noir.Services.RelPosService:CreateRelPos(tileName, offset)
    return Noir.Classes.RelPos:New(tileName, offset)
end