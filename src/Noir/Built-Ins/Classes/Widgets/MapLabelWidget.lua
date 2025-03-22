--------------------------------------------------------
-- [Noir] Classes - Map Label Widget
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
    Represents a map label UI widget to be shown to players via UIService.
]]
---@class NoirMapLabelWidget: NoirWidget
---@field New fun(self: NoirMapLabelWidget, ID: integer, visible: boolean, text: string, labelType: SWLabelTypeEnum, position: SWMatrix, player: NoirPlayer|nil): NoirMapLabelWidget
---@field Text string The text of this label
---@field LabelType SWLabelTypeEnum The label type to use (changes the icon)
---@field Position SWMatrix The position the map label should be shown on the map at
Noir.Classes.MapLabelWidget = Noir.Class("MapLabelWidget", Noir.Classes.Widget)

--[[
    Initializes class objects from this class.
]]
---@param ID integer
---@param visible boolean
---@param text string
---@param labelType SWLabelTypeEnum
---@param position SWMatrix
---@param player NoirPlayer|nil
function Noir.Classes.MapLabelWidget:Init(ID, visible, text, labelType, position, player)
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:Init()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:Init()", "labelType", labelType, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:Init()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:Init()", "player", player, Noir.Classes.Player, "nil")

    self:InitFrom(
        Noir.Classes.Widget,
        ID,
        visible,
        "MapLabel",
        player
    )

    self.Text = text
    self.LabelType = labelType
    self.Position = position
end

--[[
    Serializes this map label widget.
]]
---@return NoirSerializedMapLabelWidget
function Noir.Classes.MapLabelWidget:_Serialize() ---@diagnostic disable-next-line missing-return
    return {
        Text = self.Text,
        LabelType = self.LabelType,
        Position = self.Position
    }
end

--[[
    Deserializes a map label widget.
]]
---@param serializedWidget NoirSerializedMapLabelWidget
---@return NoirMapLabelWidget|nil
function Noir.Classes.MapLabelWidget:Deserialize(serializedWidget)
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:Deserialize()", "serializedWidget", serializedWidget, "table")

    return self:New(
        serializedWidget.ID,
        serializedWidget.Visible,
        serializedWidget.Text,
        serializedWidget.LabelType,
        serializedWidget.Position,
        Noir.Services.UIService:_GetSerializedPlayer(serializedWidget.Player)
    )
end

--[[
    Handles updating this widget.
]]
---@param player NoirPlayer
function Noir.Classes.MapLabelWidget:_Update(player)
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:_Update()", "player", player, Noir.Classes.Player)

    server.addMapLabel(
        player.ID,
        self.ID,
        self.LabelType,
        self.Text,
        self.Position[13],
        self.Position[15]
    )
end

--[[
    Handles destroying this widget.
]]
---@param player NoirPlayer
function Noir.Classes.MapLabelWidget:_Destroy(player)
    Noir.TypeChecking:Assert("Noir.Classes.MapLabelWidget:_Destroy()", "player", player, Noir.Classes.Player)
    server.removeMapLabel(player.ID, self.ID)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of a widget.
]]
---@class NoirSerializedMapLabelWidget: NoirSerializedWidget
---@field Text string The text of this label
---@field LabelType SWLabelTypeEnum The label type to use (changes the icon)
---@field Position SWMatrix The position the map label should be shown on the map at