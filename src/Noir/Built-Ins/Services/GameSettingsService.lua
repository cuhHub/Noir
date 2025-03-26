--------------------------------------------------------
-- [Noir] Services - Game Settings Service
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

-------------------------------
-- // Main
-------------------------------

--[[
    A service for changing and accessing the game's settings.

    Noir.Services.GameSettingsService:GetSetting("infinite_batteries") -- false
    Noir.Services.GameSettingsService:SetSetting("infinite_batteries", true)
]]
---@class NoirGameSettingsService: NoirService
Noir.Services.GameSettingsService = Noir.Services:CreateService(
    "GameSettingsService",
    true,
    "A basic service for changing and accessing the game's settings.",
    nil,
    {"Cuh4"}
)

--[[
    Returns a list of all game settings.
]]
---@return SWGameSettings
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.GameSettingsService:GetSetting()", "name", name, "string")

    -- Get a setting
    local settings = self:GetSettings()
    local setting = settings[name]

    if setting == nil then
        error("GameSettingsService:GetSetting()", "'%s' is not a valid game setting.", name)
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
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.GameSettingsService:SetSetting()", "name", name, "string")

    -- Set the setting
    if self:GetSettings()[name] == nil then
        error("GameSettingsService:SetSetting()", "'%s' is not a valid game setting.", name)
    end

    server.setGameSetting(name, value)
end