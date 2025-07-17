--------------------------------------------------------
-- [Noir] Tests - Polyfill
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

---@diagnostic disable duplicate-set-field

debug = {}
debug.log = print

server = {}
server.announce = print

matrix = {}
matrix.translation = function(x, y, z)
    return {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        x, y, z, 1
    }
end

matrix.multiply = function(a, b)
    -- chatgpt unfortunately. not at all familiar with matrix math

    local result = {}

    for row = 0, 3 do
        for col = 0, 3 do
            local sum = 0

            for i = 0, 3 do
                sum = sum + a[row * 4 + i + 1] * b[i * 4 + col + 1]
            end

            result[row * 4 + col + 1] = sum
        end
    end

    return result
end

matrix.position = function(matrix)
    return matrix[13], matrix[14], matrix[15]
end