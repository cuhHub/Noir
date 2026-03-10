--------------------------------------------------------
-- [Noir] Enums - Widget Type
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
    Represents the type of a widget.
]]
Noir.Enums.WidgetType = {
    --[[
        A map object.
    ]]
    MAP_OBJECT = "MapObject",

    --[[
        A map label.
    ]]
    MAP_LABEL = "MapLabel",

    --[[
        A map line.
    ]]
    MAP_LINE = "MapLine",

    --[[
        A screen popup.
    ]]
    SCREEN_POPUP = "ScreenPopup",

    --[[
        A physical, in-world popup.
    ]]
    POPUP = "Popup"
}

--[[
    Represents the type of a widget.
]]
---@alias NoirWidgetType
---| "MapObject" A map object
---| "MapLabel" A map label
---| "MapLine" A map line
---| "ScreenPopup" A screen popup
---| "Popup" A physical, in-world popup