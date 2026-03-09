--------------------------------------------------------
-- [Noir] Enums - Addon Reason
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

-------------------------------
-- // Main
-------------------------------

--[[
    Represents how the addon has started (was it through a save being loaded? addons being reloaded? etc.).
]]
Noir.Enums.AddonReason = {
    --[[
        The addon was reloaded.
    ]]
    ADDON_RELOAD = "AddonReload",

    --[[
        A save was created with the addon enabled.
    ]]
    SAVE_CREATE = "SaveCreate",

    --[[
        A save was loaded with the addon enabled.
    ]]
    SAVE_LOAD = "SaveLoad"
}

--[[
    Represents how the addon has started (was it through a save being loaded? addons being reloaded? etc.).
]]
---@alias NoirAddonReason
---| "AddonReload" The addon was reloaded
---| "SaveCreate" A save was created with the addon enabled
---| "SaveLoad" A save with loaded into with the addon enabled