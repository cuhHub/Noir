--------------------------------------------------------
-- [Noir] Classes - Widget
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
    Represents a UI widget for the UI service.
]]
---@class NoirWidget: NoirClass
---@field New fun(self: NoirWidget, ID: integer, visible: boolean, widgetType: NoirWidgetType, player: NoirPlayer|nil): NoirWidget
---@field ID integer The Stormworks UI ID of this widget
---@field Visible boolean Whether or not this widget is visible
---@field WidgetType NoirWidgetType The type of this widget (eg: "MapObject")
---@field Player NoirPlayer|nil The player that this widget is attached to. If nil, all players can see this UI
Noir.Classes.Widget = Noir.Class("Widget")

--[[
    Initializes class objects from this class.
]]
---@param ID integer
---@param visible boolean
---@param widgetType NoirWidgetType
---@param player NoirPlayer|nil
function Noir.Classes.Widget:Init(ID, visible, widgetType, player)
    Noir.TypeChecking:Assert("Noir.Classes.Widget:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.Widget:Init()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.Widget:Init()", "widgetType", widgetType, "string")
    Noir.TypeChecking:Assert("Noir.Classes.Widget:Init()", "player", player, Noir.Classes.Player, "nil")

    self.ID = ID
    self.Visible = visible
    self.WidgetType = widgetType
    self.Player = player
end

--[[
    Serializes this widget.
]]
---@return NoirSerializedWidget
function Noir.Classes.Widget:Serialize()
    return Noir.Libraries.Table:ForceMerge({
        ID = self.ID,
        Visible = self.Visible,
        WidgetType = self.WidgetType,
        Player = self.Player and self.Player.ID or -1
    }, self:_Serialize())
end

--[[
    Serializes this widget.<br>
    *abstract method*
]]
---@return NoirSerializedWidget
function Noir.Classes.Widget:_Serialize() ---@diagnostic disable-next-line missing-return
    Noir.Debugging:RaiseError("Noir.Classes.Widget:_Serialize()", "This method is abstract and must be overridden.")
end

--[[
    Deserializes a serialized widget.<br>
    *abstract method*<br>
    *static method*
]]
---@param serializedWidget NoirSerializedWidget
---@return NoirWidget|nil
function Noir.Classes.Widget:Deserialize(serializedWidget)
    Noir.Debugging:RaiseError("Noir.Classes.Widget:Deserialize()", "This method is abstract and must be overridden.")
end

--[[
    Updates this widget.
]]
function Noir.Classes.Widget:Update()
    if self.Player then
        self:_Destroy(self.Player) -- destroy old version. prevents duplication
        self:_Update(self.Player)
    else
        for _, player in pairs(Noir.Services.PlayerService:GetPlayers(true)) do
            self:_Destroy(player)
            self:_Update(player)
        end
    end
end

--[[
    Updates this widget.<br>
    *abstract method*
]]
---@param player NoirPlayer
function Noir.Classes.Widget:_Update(player)
    Noir.Debugging:RaiseError("Noir.Classes.Widget:Update()", "This method is abstract and must be overridden.")
end

--[[
    Destroys this widget.
]]
function Noir.Classes.Widget:Destroy()
    if self.Player then
        self:_Destroy(self.Player)
    else
        for _, player in pairs(Noir.Services.PlayerService:GetPlayers(true)) do
            self:_Destroy(player)
        end
    end
end

--[[
    Destroys this widget.<br>
    *abstract method*
]]
---@param player NoirPlayer
function Noir.Classes.Widget:_Destroy(player)
    Noir.Debugging:RaiseError("Noir.Classes.Widget:_Destroy()", "This method is abstract and must be overridden.")
end

--[[
    Returns if this widget still exists within the UIService.
]]
---@return boolean
function Noir.Classes.Widget:Exists()
    return Noir.Services.UIService:GetWidget(self.ID) ~= nil
end

--[[
    Removes this widget from the UIService and from the game.
]]
function Noir.Classes.Widget:Remove()
    Noir.Services.UIService:RemoveWidget(self.ID)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of a widget.
]]
---@class NoirSerializedWidget
---@field ID integer The Stormworks UI ID of this widget
---@field Visible boolean Whether or not this widget is visible
---@field WidgetType NoirWidgetType The type of this widget (eg: "MapObject")
---@field Player integer The peer ID of the player that this widget is attached to, or -1 if for everyone

--[[
    Represents a widget type.
]]
---@alias NoirWidgetType
---| "MapObject" # A map object widget
---| "MapLabel" # A map label widget
---| "MapLine" # A map line widget
---| "ScreenPopup" # A screen popup widget
---| "Popup" # A popup widget in 3D space]