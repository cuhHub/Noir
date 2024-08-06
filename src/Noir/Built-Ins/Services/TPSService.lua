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
    Main code is from Trapdoor: https://discord.com/channels/357480372084408322/905791966904729611/1270333300635992064 - https://discord.gg/stormworks

    Noir.Services.TPSService:GetTPS() -- 62.0
    Noir.Services.TPSService:GetAverageTPS() -- 61.527...
    Noir.Services.TPSService:SetPrecision(10) -- The average TPS will now be calculated every 10 ticks, meaning higher accuracy but slower
]]
---@class NoirTPSService: NoirService
---@field TPS integer The TPS of the server
---@field AverageTPS integer The average TPS of the server
---@field _AverageTPSPrecision integer Tick rate for calculating the average TPS. Higher = more accurate, but slower. Use :SetPrecision() to modify
---@field _AverageTPSAccumulation table<integer, integer> Average TPS over time. Gets cleared after it is filled enough
---@field _LastTimeSec number The last time the TPS was calculated
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

    self._AverageTPSPrecision = 10
    self._LastTimeSec = nil
    self._AverageTPSAccumulation = {}
end

function Noir.Services.TPSService:ServiceStart()
    self._OnTickConnection = Noir.Callbacks:Connect("onTick", function()
        -- Calculate TPS
        if not self._LastTimeSec then
            self._LastTimeSec = Noir.Services.TaskService:GetTimeSeconds()
        end

        self.TPS = Noir.Services.TaskService:GetTimeSeconds() - self._LastTimeSec
        self._LastTimeSec = Noir.Services.TaskService:GetTimeSeconds()

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
    Get the TPS of the server.
]]
---@return integer
function Noir.Services.TPSService:GetTPS()
    return self.TPS
end

--[[
    Get the average TPS of the server.
]]
---@return integer
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