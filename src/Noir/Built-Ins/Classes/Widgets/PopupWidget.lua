--------------------------------------------------------
-- [Noir] Classes - Popup Widget
--------------------------------------------------------

--[[
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
]]


-------------------------------
-- // Main
-------------------------------

--[[
    Represents a 3D space popup UI widget to be shown to players via UIService.
]]
---@class NoirPopupWidget: NoirWidget
---@field New fun(self: NoirPopupWidget, ID: number, visible: boolean, text: string, position: SWMatrix, renderDistance: number, player: NoirPlayer|nil): NoirPopupWidget
---@field Text string The text of the popup
---@field Position SWMatrix The 3D position of the popup
---@field RenderDistance number The distance at which the popup is visible
---@field AttachmentBody NoirBody|nil The body to optionally attach the popup to
---@field AttachmentObject NoirObject|nil The object to optionally attach the popup to
---@field AttachmentOffset SWMatrix The offset to apply when attached
---@field _AttachmentMode number The attachment mode (0 = none, 1 = body, 2 = object)
Noir.Classes.PopupWidget = Noir.Class("PopupWidget", Noir.Classes.Widget)

--[[
    Initializes a new popup widget.
]]
---@param ID number
---@param visible boolean
---@param text string
---@param position SWMatrix
---@param renderDistance number
---@param player NoirPlayer|nil
function Noir.Classes.PopupWidget:Init(ID, visible, text, position, renderDistance, player)
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Init()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Init()", "text", text, "string")
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Init()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Init()", "renderDistance", renderDistance, "number")
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Init()", "player", player, Noir.Classes.Player, "nil")

    self:InitFrom(
        Noir.Classes.Widget,
        ID,
        visible,
        "Popup",
        player
    )

    self.Text = text
    self.Position = position
    self.RenderDistance = renderDistance

    self.AttachmentOffset = matrix.translation(0, 0, 0)
    self._AttachmentMode = 0
end

--[[
    Attaches this popup to a body.<br>
    Upon doing so, the popup will follow the body's position until detached with the `:Detach()` method.<br>
    You can offset the popup from the body by setting the `AttachmentOffset` property.<br>
    Note that `:Update()` is called automatically.
]]
---@param body NoirBody
function Noir.Classes.PopupWidget:AttachToBody(body)
    self.AttachmentBody = body
    self._AttachmentMode = 1

    self:Update()
end

--[[
    Attaches this popup to an object.<br>
    Upon doing so, the popup will follow the object's position until detached with the `:Detach()` method.<br>
    You can offset the popup from the object by setting the `AttachmentOffset` property.<br>
    Note that `:Update()` is called automatically.
]]
---@param object NoirObject
function Noir.Classes.PopupWidget:AttachToObject(object)
    self.AttachmentObject = object
    self._AttachmentMode = 2

    self:Update()
end

--[[
    Detaches this popup from any body or object.
]]
function Noir.Classes.PopupWidget:Detach()
    self.AttachmentBody = nil
    self.AttachmentObject = nil
    self._AttachmentMode = 0

    self:Update()
end

--[[
    Serializes this popup widget.
]]
---@return NoirSerializedPopupWidget
function Noir.Classes.PopupWidget:_Serialize() ---@diagnostic disable-next-line missing-return
    return {
        Text = self.Text,
        Position = self.Position,
        RenderDistance = self.RenderDistance,
        AttachmentBodyID = self.AttachmentBody and self.AttachmentBody.ID or nil,
        AttachmentObjectID = self.AttachmentObject and self.AttachmentObject.ID or nil,
        AttachmentOffset = self.AttachmentOffset,
        AttachmentMode = self._AttachmentMode
    }
end

--[[
    Deserializes a popup widget.
]]
---@param serializedWidget NoirSerializedPopupWidget
---@return NoirPopupWidget|nil
function Noir.Classes.PopupWidget:Deserialize(serializedWidget)
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:Deserialize()", "serializedWidget", serializedWidget, "table")

    local widget = self:New(
        serializedWidget.ID,
        serializedWidget.Visible,
        serializedWidget.Text,
        serializedWidget.Position,
        serializedWidget.RenderDistance,
        Noir.Services.UIService:_GetSerializedPlayer(serializedWidget.Player)
    )

    widget._AttachmentMode = serializedWidget.AttachmentMode
    widget.AttachmentOffset = serializedWidget.AttachmentOffset

    if serializedWidget.AttachmentMode == 1 then
        local body = Noir.Services.VehicleService:GetBody(serializedWidget.AttachmentBodyID or -1)

        if not body then
            self:Detach()
            return widget
        end

        widget.AttachmentBody = body
    elseif serializedWidget.AttachmentMode == 2 then
        local object = Noir.Services.ObjectService:GetObject(serializedWidget.AttachmentObjectID or -1)

        if not object or not object:Exists() then
            self:Detach()
            return widget
        end

        widget.AttachmentObject = object
    end

    return widget
end

--[[
    Handles updating this widget.
]]
---@param player NoirPlayer
function Noir.Classes.PopupWidget:_Update(player)
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:_Update()", "player", player, Noir.Classes.Player)

    server.setPopup(
        player.ID,
        self.ID,
        "",
        self.Visible,
        self.Text,
        self._AttachmentMode == 0 and self.Position[13] or self.AttachmentOffset[13],
        self._AttachmentMode == 0 and self.Position[14] or self.AttachmentOffset[14],
        self._AttachmentMode == 0 and self.Position[15] or self.AttachmentOffset[15],
        self.RenderDistance,
        self._AttachmentMode == 1 and self.AttachmentBody.ID or 0,
        self._AttachmentMode == 2 and self.AttachmentObject.ID or 0
    )
end

--[[
    Handles destroying this widget.
]]
---@param player NoirPlayer
function Noir.Classes.PopupWidget:_Destroy(player)
    Noir.TypeChecking:Assert("Noir.Classes.PopupWidget:_Destroy()", "player", player, Noir.Classes.Player)

    server.setPopup(
        player.ID,
        self.ID,
        "",
        false,
        "",
        0,
        0,
        0,
        0,
        0,
        0
    )
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of a popup widget.
]]
---@class NoirSerializedPopupWidget: NoirSerializedWidget
---@field Text string The text of the popup
---@field Position SWMatrix The 3D position of the popup
---@field RenderDistance number The distance at which the popup is visible
---@field AttachmentBodyID number|nil The ID of the body to attach this popup to
---@field AttachmentObjectID number|nil The ID of the object to attach this popup to
---@field AttachmentOffset SWMatrix The offset to apply to the attachment
---@field AttachmentMode number The attachment mode (0 = none, 1 = body, or 2 = object)