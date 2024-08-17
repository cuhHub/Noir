--------------------------------------------------------
-- [Noir] Libraries - Table
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
    A library containing helper methods relating to Stormworks matrices.
]]
---@class NoirMatrixLib: NoirLibrary
Noir.Libraries.Matrix = Noir.Libraries:Create(
    "MatrixLibrary",
    "A library containing helper methods relating to Stormworks matrices.",
    nil,
    {"Cuh4"}
)

--[[
    Offsets the position of a matrix.
]]
---@param pos SWMatrix
---@param xOffset integer|nil
---@param yOffset integer|nil
---@param zOffset integer|nil
---@return SWMatrix
function Noir.Libraries.Matrix:Offset(pos, xOffset, yOffset, zOffset)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "pos", pos, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "xOffset", xOffset, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "yOffset", yOffset, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Offset()", "zOffset", zOffset, "number", "nil")

    -- Offset the matrix
    return matrix.multiply(pos, matrix.translation(xOffset or 0, yOffset or 0, zOffset or 0))
end

--[[
    Returns an empty matrix. Equivalent to matrix.translation(0, 0, 0)
]]
---@return SWMatrix
function Noir.Libraries.Matrix:Empty()
    return matrix.translation(0, 0, 0)
end

--[[
    Returns a scaled matrix. Multiply this with another matrix to scale up said matrix.<br>
    This can be used to enlarge vehicles spawned via server.spawnAddonComponent, server.spawnAddonVehicle, etc.
]]
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@return SWMatrix
function Noir.Libraries.Matrix:Scale(scaleX, scaleY, scaleZ)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Scale()", "scaleX", scaleX, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Scale()", "scaleY", scaleY, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:Scale()", "scaleZ", scaleZ, "number")

    -- Scale the matrix
    local pos = self:Empty()
    pos[1] = scaleX
    pos[6] = scaleY
    pos[11] = scaleZ

    -- Return
    return pos
end

--[[
    Offset a matrix by a random amount.
]]
---@param pos SWMatrix
---@param xRange number
---@param yRange number
---@param zRange number
---@return SWMatrix
function Noir.Libraries.Matrix:RandomOffset(pos, xRange, yRange, zRange)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "pos", pos, "table")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "xRange", xRange, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "yRange", yRange, "number")
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:RandomOffset()", "zRange", zRange, "number")

    -- Offset the matrix randomly
    return self:Offset(pos, math.random(-xRange, xRange), math.random(-yRange, yRange), math.random(-zRange, zRange))
end

--[[
    Converts a matrix to a readable format.
]]
---@param pos SWMatrix
---@return string
function Noir.Libraries.Matrix:ToString(pos)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Libraries.Matrix:ToString()", "pos", pos, "table")

    -- Convert the matrix to a string
    local x, y, z = matrix.position(pos)
    return ("%.1f, %.1f, %.1f"):format(x, y, z)
end