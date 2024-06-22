--------------------------------------------------------
-- [Noir] Services - Game Settings Service
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
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
    A service for changing and accessing the game's settings.

    Noir.Services.GameSettingsService:GetSetting("infinite_batteries") -- false
    Noir.Services.GameSettingsService:SetSetting("infinite_batteries", true)
]]
---@class NoirGameSettingsService: NoirService
Noir.Services.GameSettingsService = Noir.Services:CreateService("GameSettingsService", true)

function Noir.Services.GameSettingsService:ServiceInit() end
function Noir.Services.GameSettingsService:ServiceStart() end

--[[
    Returns a list of all game settings.
]]
---@return table<integer, SWGameSettingEnum>
function Noir.Services.GameSettingsService:GetSettings()
    return server.getGameSettings()
end

--[[
    Returns the value of the provided game setting.

    Noir.Services.GameSettingsService:GetSetting("infinite_batteries") -- false
]]
---@param name SWGameSettingEnum
---@return any
function Noir.Services.GameSettingsService:GetSetting(name)
    local settings = self:GetSettings()
    local setting = settings[name]

    if not setting then
        return
    end

    return setting
end

--[[
    Sets the value of the provided game setting.

    Noir.Services.GameSettingsService:SetSetting("infinite_batteries", true)
]]
---@param name SWGameSettingEnum
---@param value any
function Noir.Services.GameSettingsService:SetSetting(name, value)
    if not self:GetSetting(name) then
        Noir.Libraries.Logging:Error("GameSettingsService", "SetSetting(): %s is not a valid game setting.", false, name)
        return
    end

    server.setGameSetting(name, value)
end