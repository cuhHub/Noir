--------------------------------------------------------
-- [Noir] Classes - Map Object Widget
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
    Represents a map object UI widget to be shown to players via UIService.
]]
---@class NoirMapObjectWidget: NoirWidget
---@field New fun(self: NoirMapObjectWidget, ID: integer, visible: boolean, title: string, text: string, objectType: SWMarkerTypeEnum, position: SWMatrix, radius: number, colorR: number, colorG: number, colorB: number, colorA: number, player: NoirPlayer|nil): NoirMapObjectWidget
---@field Title string The title of this map object
---@field Text string The text of this map object
---@field ObjectType SWMarkerTypeEnum The map object type to use (changes the icon)
---@field Position SWMatrix The position the map object should be shown on the map at
---@field Radius number The radius of this map object
---@field AttachmentBody NoirBody|nil The body to optionally attach the map object to
---@field AttachmentObject NoirObject|nil The object to optionally attach the map object to
---@field AttachmentOffset SWMatrix The offset to apply to the body/object attachment
---@field _AttachmentMode SWPositionTypeEnum The map object attachment mode
---@field ColorR number The red color value of this map object
---@field ColorG number The green color value of this map object
---@field ColorB number The blue color value of this map object
---@field ColorA number The alpha color value of this map object
Noir.Classes.MapObjectWidget = Noir.Class("MapObjectWidget", Noir.Classes.Widget)

--[[
    Initializes class objects from this class.
]]
---@param ID integer
---@param visible boolean
---@param title string
---@param text string
---@param objectType SWMarkerTypeEnum
---@param position SWMatrix
---@param radius number
---@param colorR number
---@param colorG number
---@param colorB number
---@param colorA number
---@param player NoirPlayer|nil
function Noir.Classes.MapObjectWidget:Init(ID, visible, title, text, objectType, position, radius, colorR, colorG, colorB, colorA, player)
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "text", text, "string")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "objectType", objectType, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "radius", radius, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "colorR", colorR, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "colorG", colorG, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "colorB", colorB, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "colorA", colorA, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Init()", "player", player, Noir.Classes.Player, "nil")

    self:InitFrom(
        Noir.Classes.Widget,
        ID,
        visible,
        "MapObject",
        player
    )

    self.Title = title
    self.Text = text
    self.ObjectType = objectType
    self.Position = position
    self.Radius = radius
    self.AttachmentOffset = matrix.translation(0, 0, 0)
    self._AttachmentMode = 0
    self.ColorR = colorR
    self.ColorG = colorG
    self.ColorB = colorB
    self.ColorA = colorA
end

--[[
    Attaches this map object to a body.
]]
---@param body NoirBody
function Noir.Classes.MapObjectWidget:AttachToBody(body)
    self.AttachmentBody = body
    self.Mode = 1

    self:Update()
end

--[[
    Attaches this map object to an object.
]]
---@param object NoirObject
function Noir.Classes.MapObjectWidget:AttachToObject(object)
    self.AttachmentObject = object
    self.Mode = 2

    self:Update()
end

--[[
    Detaches this map object from any body or object.
]]
function Noir.Classes.MapObjectWidget:Detach()
    self.AttachmentBody = nil
    self.AttachmentObject = nil
    self.Mode = 0

    self:Update()
end

--[[
    Serializes this map object widget.
]]
---@return NoirSerializedMapObjectWidget
function Noir.Classes.MapObjectWidget:_Serialize() ---@diagnostic disable-next-line missing-return
    return {
        Title = self.Title,
        Text = self.Text,
        ObjectType = self.ObjectType,
        Position = self.Position,
        Radius = self.Radius,
        ColorR = self.ColorR,
        ColorG = self.ColorG,
        ColorB = self.ColorB,
        ColorA = self.ColorA,
        AttachmentBodyID = self.AttachmentBody and self.AttachmentBody.ID or nil,
        AttachmentObjectID = self.AttachmentObject and self.AttachmentObject.ID or nil,
        AttachmentOffset = self.AttachmentOffset,
        AttachmentMode = self._AttachmentMode
    }
end

--[[
    Deserializes a map object widget.
]]
---@param serializedWidget NoirSerializedMapObjectWidget
---@return NoirMapObjectWidget|nil
function Noir.Classes.MapObjectWidget:Deserialize(serializedWidget)
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:Deserialize()", "serializedWidget", serializedWidget, "table")

    local widget = self:New(
        serializedWidget.ID,
        serializedWidget.Visible,
        serializedWidget.Title,
        serializedWidget.Text,
        serializedWidget.ObjectType,
        serializedWidget.Position,
        serializedWidget.Radius,
        serializedWidget.ColorR,
        serializedWidget.ColorG,
        serializedWidget.ColorB,
        serializedWidget.ColorA,
        Noir.Services.UIService:_GetSerializedPlayer(serializedWidget.Player)
    )

    widget._AttachmentMode = serializedWidget.AttachmentMode
    widget.AttachmentOffset = serializedWidget.AttachmentOffset

    if serializedWidget.AttachmentMode == 1 then
        local body = Noir.Services.VehicleService:GetBody(serializedWidget.AttachmentBodyID)

        if not body then
            self:Detach()
            return widget
        end

        self.AttachmentBody = body
    elseif serializedWidget.AttachmentMode == 2 then
        local object = Noir.Services.ObjectService:GetObject(serializedWidget.AttachmentObjectID)

        if not widget.AttachmentObject:Exists() then
            self:Detach()
            return widget
        end

        self.AttachmentObject = object
    end

    return widget
end

--[[
    Handles updating this widget.
]]
---@param player NoirPlayer
function Noir.Classes.MapObjectWidget:_Update(player)
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:_Update()", "player", player, Noir.Classes.Player)

    server.addMapObject(
        player.ID,
        self.ID,
        0,
        self.ObjectType,
        self.Position[13],
        self.Position[15],
        self.AttachmentOffset[13],
        self.AttachmentOffset[15],
        self._AttachmentMode == 1 and self.AttachmentBody.ID or 0,
        self._AttachmentMode == 2 and self.AttachmentObject.ID or 0,
        self.Title,
        self.Radius,
        self.Text,
        self.ColorR,
        self.ColorG,
        self.ColorB,
        self.ColorA
    )
end

--[[
    Handles destroying this widget.
]]
---@param player NoirPlayer
function Noir.Classes.MapObjectWidget:_Destroy(player)
    Noir.TypeChecking:Assert("Noir.Classes.MapObjectWidget:_Destroy()", "player", player, Noir.Classes.Player)
    server.removeMapObject(player.ID, self.ID)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of a map object widget.
]]
---@class NoirSerializedMapObjectWidget: NoirSerializedWidget
---@field Title string The title of this map object
---@field Text string The text of this map object
---@field ObjectType SWMarkerTypeEnum The map object type to use (changes the icon)
---@field Position SWMatrix The position the map object should be shown on the map at
---@field Radius number The radius of this map object
---@field ColorR number The red color value of this map object
---@field ColorG number The green color value of this map object
---@field ColorB number The blue color value of this map object
---@field ColorA number The alpha color value of this map object
---@field AttachmentBodyID integer|nil The ID of the body to attach this map object to
---@field AttachmentObjectID integer|nil The ID of the object to attach this map object to
---@field AttachmentOffset SWMatrix The offset to apply to the body/object attachment
---@field AttachmentMode SWPositionTypeEnum The attachment mode to use