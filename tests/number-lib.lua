--------------------------------------------------------
-- [Noir] Tests - Number Library
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

assert(Noir.Libraries.Number:IsWithin(3, 1, 10) == true, "expected `true` for :IsWithin()")
assert(Noir.Libraries.Number:IsWithin(3, 10, 20) == false, "expected `false` for :IsWithin()")

assert(Noir.Libraries.Number:Clamp(3, 1, 10) == 3, "expected `3` for :Clamp()")
assert(Noir.Libraries.Number:Clamp(3, 10, 20) == 10, "expected `10` for :Clamp()")
assert(Noir.Libraries.Number:Clamp(35, 20, 30) == 30, "expected `30` for :Clamp()")

assert(Noir.Libraries.Number:Round(3.5525) == 4, "expected `4` for :Round()")
assert(Noir.Libraries.Number:Round(3.5525, 1) == 3.6, "expected `3.6` for :Round()")
assert(Noir.Libraries.Number:Round(3.5525, 2) == 3.55, "expected `3.55` for :Round()")

assert(Noir.Libraries.Number:IsInteger(2.5525) == false, "expected `true` for :IsInteger()")
assert(Noir.Libraries.Number:IsInteger(2) == true, "expected `true` for :IsInteger()")

local values = { 1, 2, 3, 4, 5 }
assert(Noir.Libraries.Number:Average(values) == 3, "expected `3` for :Average()")

values = {5, 5, 2}
assert(Noir.Libraries.Number:Average(values) == 4, "expected `4` for :Average()")