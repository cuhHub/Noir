--------------------------------------------------------
-- [Noir] Services - TPS Service
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
    A service for retrieving the TPS (Ticks Per Second) of the server.
    TPS calculations are from Trapdoor: https://discord.com/channels/357480372084408322/905791966904729611/1270333300635992064 - https://discord.gg/stormworks

    Noir.Services.TPSService:GetTPS() -- 62.0
    Noir.Services.TPSService:GetAverageTPS() -- 61.527...
    Noir.Services.TPSService:SetPrecision(10) -- The average TPS will now be calculated every 10 ticks, meaning higher accuracy but slower
]]
---@class NoirTPSService: NoirService
---@field TPS number The TPS of the server
---@field AverageTPS number The average TPS of the server
---@field DesiredTPS number The desired TPS. This service will slow the game enough to achieve this. 0 = disabled
---@field _AverageTPSPrecision integer Tick rate for calculating the average TPS. Higher = more accurate, but slower. Use :SetPrecision() to modify
---@field _AverageTPSAccumulation table<integer, integer> TPS over time. Gets cleared after it is filled enough
---@field _Last number The last time the TPS was calculated
---@field _OnTickConnection NoirConnection Represents the connection to the onTick game callback
Noir.Services.TPSService = Noir.Services:CreateService(
    "TPSService",
    true,
    "A service for gathering the TPS of the server.",
    "A minimal service for gathering the TPS of the server. The average TPS can also be retrieved.",
    {"Cuh4"}
)

function Noir.Services.TPSService:ServiceInit()
    self.TPS = 0
    self.AverageTPS = 0
    self.DesiredTPS = 0

    self._AverageTPSPrecision = 10
    self._Last = server.getTimeMillisec()
    self._AverageTPSAccumulation = {}
end

function Noir.Services.TPSService:ServiceStart()
    self._OnTickConnection = Noir.Callbacks:Connect("onTick", function(ticks)
        -- Calculate TPS
        local now = server.getTimeMillisec()

        if self.DesiredTPS ~= 0 then -- below is from Woe (https://discord.com/channels/357480372084408322/905791966904729611/1261911499723509820) @ https://discord.gg/stormworks
            while self:_CalculateTPS(self._Last, now, ticks) > self.DesiredTPS do
                now = server.getTimeMillisec()
            end
        end

        self.TPS = self:_CalculateTPS(self._Last, now, ticks)
        self._Last = server.getTimeMillisec()

        -- Calculate Average TPS
        if #self._AverageTPSAccumulation >= self._AverageTPSPrecision then
            self.AverageTPS = Noir.Libraries.Number:Average(self._AverageTPSAccumulation)
            self._AverageTPSAccumulation = {}
        else
            table.insert(self._AverageTPSAccumulation, self.TPS)
        end
    end)
end

--[[
    Calculates TPS from two points in time.
]]
---@param past number
---@param now number
---@param gameTicks number
---@return number
function Noir.Services.TPSService:_CalculateTPS(past, now, gameTicks)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TPSService:CalculateTPS()", "past", past, "number")
    Noir.TypeChecking:Assert("Noir.Services.TPSService:CalculateTPS()", "now", now, "number")
    Noir.TypeChecking:Assert("Noir.Services.TPSService:CalculateTPS()", "gameTicks", gameTicks, "number")

    -- Calculate TPS
    return 1000 / (now - past) * gameTicks
end

--[[
    Set the desired TPS. The service will then slow the game down until the desired TPS is achieved. Set to 0 to disable this.
]]
---@param desiredTPS number 0 = disabled
function Noir.Services.TPSService:SetTPS(desiredTPS)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.TPSService:SetTPS()", "desiredTPS", desiredTPS, "number")

    -- Set desired TPS, and validate
    if desiredTPS < 0 then
        desiredTPS = 0
    end

    self.DesiredTPS = desiredTPS
end

--[[
    Get the TPS of the server.
]]
---@return number
function Noir.Services.TPSService:GetTPS()
    return self.TPS
end

--[[
    Get the average TPS of the server.
]]
---@return number
function Noir.Services.TPSService:GetAverageTPS()
    return self.AverageTPS
end

--[[
    Set the tick rate for calculating the average TPS.
]]
---@param precision integer
function Noir.Services.TPSService:SetPrecision(precision)
    Noir.TypeChecking:Assert("Noir.Services.TPSService:SetPrecision()", "precision", precision, "number")
    self._AverageTPSPrecision = precision
end