--------------------------------------------------------
-- [Noir] Classes - AI Target
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
    Represents AI target data for a character.
]]
---@class NoirAITarget: NoirClass
---@field New fun(self: NoirAITarget, data: SWTargetData): NoirAITarget
---@field TargetBody NoirBody|nil The body that the character is targeting (if any).
---@field TargetCharacter NoirObject|nil The character that the character is targeting (if any).
---@field TargetPos SWMatrix The position that the character is targeting.
Noir.Classes.AITargetClass = Noir.Class("NoirAITarget")

--[[
    Initializes class objects from this class.
]]
---@param data SWTargetData
function Noir.Classes.AITargetDataClass:Init(data)
    Noir.TypeChecking:Assert("Noir.Classes.AITargetClass:Init()", "data", data, "table")

    self.TargetBody = data.vehicle and Noir.Services.VehicleService:GetBody(data.vehicle)
    self.TargetCharacter = data.character and Noir.Services.ObjectService:GetObject(data.character)
    self.TargetPos = matrix.translation(data.x or 0, data.y or 0, data.z or 0)
end