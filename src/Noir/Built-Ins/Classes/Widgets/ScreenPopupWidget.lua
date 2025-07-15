--------------------------------------------------------
-- [Noir] Classes - Screen Popup Widget
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
    Represents a screen popup widget to be shown to players via UIService.<br>
    Not to be confused with a popup which is shown in 3D space.
]]
---@class NoirScreenPopupWidget: NoirWidget
---@field New fun(self: NoirScreenPopupWidget, ID: integer, visible: boolean, text: string, X: number, Y: number, player: NoirPlayer|nil): NoirScreenPopupWidget
---@field Text string The text shown in the popup
---@field X number The X position of the popup on the screen (-1 (left) to 1 (right))
---@field Y number The Y position of the popup on the screen (-1 (bottom) to 1 (top))
Noir.Classes.ScreenPopupWidget = Noir.Class("ScreenPopupWidget", Noir.Classes.Widget)

--[[
    Initializes class objects from this class.
]]
---@param ID integer
---@param visible boolean
---@param text string
---@param X number
---@param Y number
---@param player NoirPlayer|nil
function Noir.Classes.ScreenPopupWidget:Init(ID, visible, text, X, Y, player)
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:Init()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:Init()", "X", X, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:Init()", "Y", Y, "number")
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:Init()", "player", player, Noir.Classes.Player, "nil")

    self:InitFrom(
        Noir.Classes.Widget,
        ID,
        visible,
        "ScreenPopup",
        player
    )

    self.Text = text
    self.X = X
    self.Y = Y
end

--[[
    Serializes this screen popup widget.
]]
---@return NoirSerializedScreenPopupWidget
function Noir.Classes.ScreenPopupWidget:_Serialize() ---@diagnostic disable-next-line missing-return
    return {
        Text = self.Text,
        X = self.X,
        Y = self.Y
    }
end

--[[
    Deserializes a screen popup widget.
]]
---@param serializedWidget NoirSerializedScreenPopupWidget
---@return NoirScreenPopupWidget|nil
function Noir.Classes.ScreenPopupWidget:Deserialize(serializedWidget)
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:Deserialize()", "serializedWidget", serializedWidget, "table")

    return self:New(
        serializedWidget.ID,
        serializedWidget.Visible,
        serializedWidget.Text,
        serializedWidget.X,
        serializedWidget.Y,
        Noir.Services.UIService:_GetSerializedPlayer(serializedWidget.Player)
    )
end

--[[
    Handles updating this widget.
]]
---@param player NoirPlayer
function Noir.Classes.ScreenPopupWidget:_Update(player)
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:_Update()", "player", player, Noir.Classes.Player)

    server.setPopupScreen(
        player.ID,
        self.ID,
        "",
        self.Visible,
        self.Text,
        self.X,
        self.Y
    )
end

--[[
    Handles destroying this widget.
]]
---@param player NoirPlayer
function Noir.Classes.ScreenPopupWidget:_Destroy(player)
    Noir.TypeChecking:Assert("Noir.Classes.ScreenPopupWidget:_Destroy()", "player", player, Noir.Classes.Player)

    server.setPopupScreen( -- `server.removePopup` shows a tutorial popup for a brief moment, so we aren't using it
        player.ID,
        self.ID,
        "",
        false,
        "",
        0,
        0
    )
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of a screen popup widget.
]]
---@class NoirSerializedScreenPopupWidget: NoirSerializedWidget
---@field Text string The text shown in the screen popup
---@field X number The X position of the popup on the screen (-1 (left) to 1 (right))
---@field Y number The Y position of the popup on the screen (-1 (bottom) to 1 (top))