--------------------------------------------------------
-- [Noir] Classes - Map Line Widget
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
    Represents a map line UI widget to be shown to players via UIService.
]]
---@class NoirMapLineWidget: NoirWidget
---@field New fun(self: NoirMapLineWidget, ID: integer, visible: boolean, startPosition: SWMatrix, endPosition: SWMatrix, width: number, colorR: number, colorG: number, colorB: number, colorA: number, player: NoirPlayer|nil): NoirMapLineWidget
---@field StartPosition SWMatrix The starting position of the line
---@field EndPosition SWMatrix The ending position of the line
---@field Width number The width of the line
---@field ColorR number The red color value of this map object (0-255)
---@field ColorG number The green color value of this map object (0-255)
---@field ColorB number The blue color value of this map object (0-255)
---@field ColorA number The alpha color value of this map object (0-255)
Noir.Classes.MapLineWidget = Noir.Class("MapLineWidget", Noir.Classes.Widget)

--[[
    Initializes class objects from this class.
]]
---@param ID integer
---@param visible boolean
---@param startPosition SWMatrix
---@param endPosition SWMatrix
---@param width number
---@param colorR number
---@param colorG number
---@param colorB number
---@param colorA number
---@param player NoirPlayer|nil
function Noir.Classes.MapLineWidget:Init(ID, visible, startPosition, endPosition, width, colorR, colorG, colorB, colorA, player)
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "ID", ID, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "startPosition", startPosition, "table")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "endPosition", endPosition, "table")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "width", width, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "colorR", colorR, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "colorG", colorG, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "colorB", colorB, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "colorA", colorA, "number")
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Init()", "player", player, Noir.Classes.Player, "nil")

    self:InitFrom(
        Noir.Classes.Widget,
        ID,
        visible,
        "MapLine",
        player
    )

    self.StartPosition = startPosition
    self.EndPosition = endPosition
    self.Width = width
    self.ColorR = colorR
    self.ColorG = colorG
    self.ColorB = colorB
    self.ColorA = colorA
end

--[[
    Serializes this map line widget.
]]
---@return NoirSerializedMapLineWidget
function Noir.Classes.MapLineWidget:_Serialize()
    return {
        StartPosition = self.StartPosition,
        EndPosition = self.EndPosition,
        Width = self.Width,
        ColorR = self.ColorR,
        ColorG = self.ColorG,
        ColorB = self.ColorB,
        ColorA = self.ColorA
    }
end

--[[
    Deserializes a map line widget.
]]
---@param serializedWidget NoirSerializedMapLineWidget
---@return NoirMapLineWidget|nil
function Noir.Classes.MapLineWidget:Deserialize(serializedWidget)
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:Deserialize()", "serializedWidget", serializedWidget, "table")

    return self:New(
        serializedWidget.ID,
        serializedWidget.Visible,
        serializedWidget.StartPosition,
        serializedWidget.EndPosition,
        serializedWidget.Width,
        serializedWidget.ColorR,
        serializedWidget.ColorG,
        serializedWidget.ColorB,
        serializedWidget.ColorA,
        Noir.Services.UIService:_GetSerializedPlayer(serializedWidget.Player)
    )
end

--[[
    Handles updating this widget.
]]
---@param player NoirPlayer
function Noir.Classes.MapLineWidget:_Update(player)
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:_Update()", "player", player, Noir.Classes.Player)

    server.addMapLine(
        player.ID,
        self.ID,
        self.StartPosition,
        self.EndPosition,
        self.Width,
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
function Noir.Classes.MapLineWidget:_Destroy(player)
    Noir.TypeChecking:Assert("Noir.Classes.MapLineWidget:_Destroy()", "player", player, Noir.Classes.Player)
    server.removeMapLine(player.ID, self.ID)
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of a map line widget.
]]
---@class NoirSerializedMapLineWidget: NoirSerializedWidget
---@field StartPosition SWMatrix The starting position of the line
---@field EndPosition SWMatrix The ending position of the line
---@field Width number The width of the line
---@field ColorR number The red component of the color (0-255)
---@field ColorG number The green component of the color (0-255)
---@field ColorB number The blue component of the color (0-255)
---@field ColorA number The alpha component of the color (0-255)