--------------------------------------------------------
-- [Noir] Tests - Table Library
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

assert(Noir.Libraries.Table:Length({1, 2, 3}) == 3, ":Length() returned incorrect length")
assert(Noir.Libraries.Table:Length({}) == 0, ":Length() returned non-zero length for empty table")

assert(Noir.Libraries.Table:Random({1}) == 1, ":Random() returned incorrect value")
assert(Noir.Libraries.Table:Random({}) == nil, ":Random() returned non-nil for empty table")

assert(Noir.Libraries.Table:Keys({foo = 1})[1] == "foo", ":Keys() returned incorrect keys (expected [1] to be 'foo')")
assert(Noir.Libraries.Table:Values({bar = "foo"})[1] == "foo", ":Values() returned incorrect values (expected [1] to be 'foo')")

local sliced = Noir.Libraries.Table:Slice({1, 2, 3, 4, 5}, 1, 3)
assert(sliced, ":Slice() returned incorrect values (expected [1] to be '1')")
assert(sliced, ":Slice() returned incorrect values (expected [2] to be '2')")
assert(sliced, ":Slice() returned incorrect values (expected [3] to be '3')")
assert(sliced, ":Slice() returned incorrect values (expected [4] to be nil)")

assert(Noir.Libraries.Table:ToString({1, 2, 3}) == "[1]: 1\n[2]: 2\n[3]: 3", ":ToString() returned incorrect string")

local tblInDeep = {
    bar = true
}

local tbl = {
    foo = true,
    bar = tblInDeep
}

assert(Noir.Libraries.Table:Copy(tbl) ~= tbl, ":Copy() returned a table that is the same as the original")
assert(Noir.Libraries.Table:Copy(tbl).bar == tblInDeep, ":Copy() `bar` is different from original. Shallowcopy shouldn't do this")

assert(Noir.Libraries.Table:DeepCopy(tbl) ~= tbl, ":DeepCopy() returned a table that is the same as the original")
assert(Noir.Libraries.Table:DeepCopy(tbl).bar ~= tblInDeep, ":DeepCopy() `bar` is the same as original. Deepcopy should've made the two different")

local tbl1 = {1}
local tbl2 = {2, 3}

local merged = Noir.Libraries.Table:Merge(tbl1, tbl2)
assert(merged[1] == 1, ":Merge() returned incorrect values (expected [1] to be '1')")
assert(merged[2] == 2, ":Merge() returned incorrect values (expected [2] to be '2')")
assert(merged[3] == 3, ":Merge() returned incorrect values (expected [3] to be '3')")

local forceMerged = Noir.Libraries.Table:ForceMerge(tbl1, tbl2)
assert(forceMerged[1] == 2, ":ForceMerge() returned incorrect values (expected [1] to be '2')")
assert(forceMerged[2] == 3, ":ForceMerge() returned incorrect values (expected [2] to be '3')")

assert(Noir.Libraries.Table:Find({1, 2, 3}, 2) == 2, ":Find() returned incorrect value")
assert(Noir.Libraries.Table:Find({1, 2, 3}, 4) == nil, ":Find() returned incorrect value (expected nil)")

local hidingPlace = {
    foo = 1
}

local findDeepTbl = {
    hidingPlace = hidingPlace
}

local foundIndex, foundTbl = Noir.Libraries.Table:FindDeep(findDeepTbl, 1)
assert(foundIndex == "foo", ":FindDeep() returned incorrect index")
assert(foundTbl == hidingPlace, ":FindDeep() returned incorrect table")
assert(Noir.Libraries.Table:FindDeep(findDeepTbl, "bar") == nil, ":FindDeep() returned incorrect value (expected nil)")

local mapTbl1 = {1, 2, 3}

local mappedTbl1 = Noir.Libraries.Table:Map(mapTbl1, function(index, value)
    return index + value
end)

assert(mappedTbl1[1] == 2, ":Map() returned incorrect values (expected [1] to be '2')")
assert(mappedTbl1[2] == 4, ":Map() returned incorrect values (expected [2] to be '4')")
assert(mappedTbl1[3] == 6, ":Map() returned incorrect values (expected [3] to be '6')")

local mapTbl2 = {1, foo = 5, bar = 2}

local mappedTbl2 = Noir.Libraries.Table:Map(mapTbl2, function(index, value)
    return value * 2
end)

assert(mappedTbl2[1] == 2, ":Map() returned incorrect values (expected [1] to be '2')")
assert(mappedTbl2.foo == 10, ":Map() returned incorrect values (expected [foo] to be '10')")
assert(mappedTbl2.bar == 4, ":Map() returned incorrect values (expected [bar] to be '4')")

local filterTbl1 = {1, 2, 3, 4, 5, 6}

local filteredTbl1 = Noir.Libraries.Table:Filter(filterTbl1, function(index, value)
    return value % 2 == 0
end)

assert(filteredTbl1[2] == 2, ":Filter() returned incorrect values (expected [2] to be '2')")
assert(filteredTbl1[4] == 4, ":Filter() returned incorrect values (expected [4] to be '4')")
assert(filteredTbl1[6] == 6, ":Filter() returned incorrect values (expected [6] to be '6')")

local filteredTbl2 = Noir.Libraries.Table:FilterSequential(filterTbl1, function(index, value)
    return value % 2 == 0
end)

assert(filteredTbl2[1] == 2, ":FilterSequential() returned incorrect values (expected [1] to be '2')")
assert(filteredTbl2[2] == 4, ":FilterSequential() returned incorrect values (expected [2] to be '4')")
assert(filteredTbl2[3] == 6, ":FilterSequential() returned incorrect values (expected [3] to be '6')")