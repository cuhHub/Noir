--------------------------------------------------------
-- [Noir] Tests - MAtrix Library
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

local offsetPos = Noir.Libraries.Matrix:Offset(
    matrix.translation(3, 0, 2),
    15,
    -25,
    1
)

assert(offsetPos[13] == 18, ":Offset() didn't offset X correctly")
assert(offsetPos[14] == -25, ":Offset() didn't offset Y correctly")
assert(offsetPos[15] == 3, ":Offset() didn't offset Z correctly")

local empty = Noir.Libraries.Matrix:Empty()
assert(empty[13] == 0, ":Empty() didn't return a matrix with X as 0")
assert(empty[14] == 0, ":Empty() didn't return a matrix with Y as 0")
assert(empty[15] == 0, ":Empty() didn't return a matrix with Z as 0")

local scaled = Noir.Libraries.Matrix:Scale(1, 2, 3)
assert(scaled[1] == 1, ":Scale() didn't scale X correctly")
assert(scaled[6] == 2, ":Scale() didn't scale Y correctly")
assert(scaled[11] == 3, ":Scale() didn't scale Z correctly")

assert(Noir.Libraries.Matrix:ToString(matrix.translation(1, 2, 3)) == "1.0, 2.0, 3.0", ":ToString() didn't return the correct string")

assert(Noir.Libraries.Matrix:Magnitude(matrix.translation(1, 2, 3)) == 3.7416573867739413, ":Magnitude() didn't return the correct magnitude")