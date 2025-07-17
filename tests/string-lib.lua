--------------------------------------------------------
-- [Noir] Tests - String Library
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

local split = Noir.Libraries.String:Split("hello world", " ")
assert(split[1] == "hello", "expected `hello` at index 1 for :Split()")
assert(split[2] == "world", "expected `world` at index 2 for :Split()")

local splitLines = Noir.Libraries.String:SplitLines("hello\nworld")
assert(splitLines[1] == "hello", "expected `hello` at index 1 for :SplitLines()")
assert(splitLines[2] == "world", "expected `world` at index 2 for :SplitLines()")

assert(Noir.Libraries.String:StartsWith("hello world", "hello") == true, "expected `true` for :StartsWith()")
assert(Noir.Libraries.String:StartsWith("hello world", "world") == false, "expected `false` for :StartsWith()")

assert(Noir.Libraries.String:EndsWith("hello world", "world") == true, "expected `true` for :EndsWith()")
assert(Noir.Libraries.String:EndsWith("hello world", "hello") == false, "expected `false` for :EndsWith()")