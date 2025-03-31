--------------------------------------------------------
-- [Noir] Services - UI Service
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
    A service for showing UI to players in an OOP manner.
    Map UI, screen popups, physical popups, etc, are all supported.

    local widget = Noir.Services.UIService:CreateMapLabel(
        "My Custom Map Label", -- the text to show on the map label
        2, -- the map label type
        matrix.translation(0, 0, 0), -- the position the widget (map label) should be at
        false, -- if the widget (map label) starts visible. in this case, it starts invisible
        nil -- nil = all players can see. set this to a player to only show it for them
    )

    widget.Position = matrix.translation(15, 0, 0)
    widget.Visible = true
    widget:Update() -- we changed the widget's properties, so to reflect changes, we update

    widget:Remove() -- remove's the widget from the game and this service
]]
---@class NoirUIService: NoirService
---@field Widgets table<integer, NoirWidget> A table of all widgets currently being shown to players
---@field _OnJoinConnection NoirConnection The connection to PlayerService's `OnJoin` event
---@field _OnLeaveConnection NoirConnection The connection to PlayerService's `OnLeave` event
Noir.Services.UIService = Noir.Services:CreateService(
    "UIService",
    true,
    "A service for showing UI to players.",
    "A service for showing UI to players in an OOP manner. Map UI, screen popups, physical popups, etc, are all supported.",
    {"Cuh4"}
)

function Noir.Services.UIService:ServiceInit()
    self.Widgets = {}
    self:_LoadWidgets()
end

function Noir.Services.UIService:ServiceStart()
    ---@param player NoirPlayer
    self._OnJoinConnection = Noir.Services.PlayerService.OnJoin:Connect(function(player)
        for _, widget in pairs(self:GetWidgetsShownToPlayer(player)) do
            widget:_Update(player)
        end
    end)

    ---@param player NoirPlayer
    self._OnLeaveConnection = Noir.Services.PlayerService.OnJoin:Connect(function(player)
        for _, widget in pairs(self:GetWidgetsBelongingToPlayer(player)) do
            self:RemoveWidget(widget.ID)
        end
    end)
end

--[[
    Returns all saved widgets (serialized versions).<br>
    Used internally. Do not use in your code.
]]
---@return table<integer, NoirSerializedWidget>
function Noir.Services.UIService:_GetSavedWidgets()
    return self:EnsuredLoad("Widgets", {})
end

--[[
    Loads all widgets saved in g_savedata.<br>
    Used internally. Do not use in your code.
]]
function Noir.Services.UIService:_LoadWidgets()
    local savedWidgets = self:_GetSavedWidgets()

    for _, savedWidget in pairs(savedWidgets) do
        if savedWidget.Player ~= -1 and not Noir.Services.PlayerService:GetPlayer(savedWidget.Player) then -- player must've left. no need to load this widget
            goto continue
        end

        ---@type table<NoirWidgetType, function>
        local deserializers = {
            ["MapObject"] = function(serializedWidget)
                return Noir.Classes.MapObjectWidget:Deserialize(serializedWidget)
            end,

            ["MapLabel"] = function(serializedWidget)
                return Noir.Classes.MapLabelWidget:Deserialize(serializedWidget)
            end,

            ["Popup"] = function(serializedWidget)
                return Noir.Classes.PopupWidget:Deserialize(serializedWidget)
            end,

            ["ScreenPopup"] = function(serializedWidget)
                return Noir.Classes.ScreenPopupWidget:Deserialize(serializedWidget)
            end,

            ["MapLine"] = function(serializedWidget)
                return Noir.Classes.MapLineWidget:Deserialize(serializedWidget)
            end
        }

        if not deserializers[savedWidget.WidgetType] then
            Noir.Libraries.Logging:Warning("UIService", "Got unknown saved widget of type: %s", savedWidget.WidgetType)
            goto continue
        end

        local widget = deserializers[savedWidget.WidgetType](savedWidget)

        if not widget then
            goto continue
        end

        self:_AddWidget(widget)

        ::continue::
    end
end

--[[
    Saves a widget.<br>
    Used internally. Do not use in your code.
]]
---@param widget NoirWidget
function Noir.Services.UIService:_SaveWidget(widget)
    Noir.TypeChecking:Assert("Noir.Services.UIService:_SaveWidget()", "widget", widget, Noir.Classes.Widget)

    local savedWidgets = self:_GetSavedWidgets()
    savedWidgets[widget.ID] = widget:Serialize()

    self:Save("Widgets", savedWidgets)
end

--[[
    Unsaves a widget.<br>
    Used internally. Do not use in your code.
]]
---@param widget NoirWidget
function Noir.Services.UIService:_UnsaveWidget(widget)
    Noir.TypeChecking:Assert("Noir.Services.UIService:_UnsaveWidget()", "widget", widget, Noir.Classes.Widget)

    local savedWidgets = self:_GetSavedWidgets()
    savedWidgets[widget.ID] = nil

    self:Save("Widgets", savedWidgets)
end

--[[
    Adds a widget to the UIService.<br>
    Used internally. Do not use in your code.
]]
---@param widget NoirWidget The widget to add
function Noir.Services.UIService:_AddWidget(widget)
    Noir.TypeChecking:Assert("Noir.Services.UIService:_AddWidget()", "widget", widget, Noir.Classes.Widget)

    self.Widgets[widget.ID] = widget
    self:_SaveWidget(widget)
end

--[[
    Removes a widget from the UIService.<br>
    Used internally. Do not use in your code.
]]
---@param widget NoirWidget The widget to remove
function Noir.Services.UIService:_RemoveWidget(widget)
    Noir.TypeChecking:Assert("Noir.Services.UIService:_RemoveWidget()", "widget", widget, Noir.Classes.Widget)

    self.Widgets[widget.ID] = nil
    self:_UnsaveWidget(widget)
end

--[[
    Creates a map label widget.<br>
    This is a label that is shown on the map (duh), similar to what you see at shipwrecks, key locations (e.g: "Harrison Airbase").
]]
---@param text string
---@param labelType SWLabelTypeEnum
---@param position SWMatrix
---@param visible boolean
---@param player NoirPlayer|nil
---@return NoirMapLabelWidget
function Noir.Services.UIService:CreateMapLabel(text, labelType, position, visible, player)
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLabel()", "text", text, "string")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLabel()", "labelType", labelType, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLabel()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLabel()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLabel()", "player", player, Noir.Classes.Player, "nil")

    local widget = Noir.Classes.MapLabelWidget:New(
        server.getMapID(),
        visible,
        text,
        labelType,
        position,
        player
    )

    widget:Update()
    self:_AddWidget(widget)

    return widget
end

--[[
    Creates a screen popup widget.<br>
    This is a rounded-rectangle with text shown on your screen, exactly the same as the tutorial popups
    you get when you start a singleplayer game.
]]
---@param text string
---@param X number -1 (left) to 1 (right)
---@param Y number -1 (top) to 1 (bottom)
---@param visible boolean
---@param player NoirPlayer|nil
---@return NoirScreenPopupWidget
function Noir.Services.UIService:CreateScreenPopup(text, X, Y, visible, player)
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateScreenPopup()", "text", text, "string")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateScreenPopup()", "X", X, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateScreenPopup()", "X", Y, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateScreenPopup()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateScreenPopup()", "player", player, Noir.Classes.Player, "nil")

    local widget = Noir.Classes.ScreenPopupWidget:New(
        server.getMapID(),
        visible,
        text,
        X,
        Y,
        player
    )

    widget:Update()
    self:_AddWidget(widget)

    return widget
end

--[[
    Creates a popup widget.<br>
    This is a 2D popup that is shown in 3D space. It can be attached to a body or an object too.<br>
    This is used in the Stormworks career tutorial.
]]
---@param text string
---@param position SWMatrix
---@param renderDistance number in meters
---@param visible boolean
---@param player NoirPlayer|nil
---@return NoirPopupWidget
function Noir.Services.UIService:CreatePopup(text, position, renderDistance, visible, player)
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreatePopup()", "text", text, "string")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreatePopup()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreatePopup()", "renderDistance", renderDistance, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreatePopup()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreatePopup()", "player", player, Noir.Classes.Player, "nil")

    local widget = Noir.Classes.PopupWidget:New(
        server.getMapID(),
        visible,
        text,
        position,
        renderDistance,
        player
    )

    widget:Update()
    self:_AddWidget(widget)

    return widget
end

--[[
    Creates a map line widget.<br>
    Simply renders a line connecting two points on the map.
]]
---@param startPosition SWMatrix
---@param endPosition SWMatrix
---@param width number
---@param visible boolean
---@param colorR number|nil
---@param colorG number|nil
---@param colorB number|nil
---@param colorA number|nil
---@param player NoirPlayer|nil
---@return NoirMapLineWidget
function Noir.Services.UIService:CreateMapLine(startPosition, endPosition, width, visible, colorR, colorG, colorB, colorA, player)
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "startPosition", startPosition, "table")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "endPosition", endPosition, "table")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "width", width, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "colorR", colorR, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "colorG", colorG, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "colorB", colorB, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "colorA", colorA, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapLine()", "player", player, Noir.Classes.Player, "nil")

    local widget = Noir.Classes.MapLineWidget:New(
        server.getMapID(),
        visible,
        startPosition,
        endPosition,
        width,
        colorR or 255,
        colorG or 255,
        colorB or 255,
        colorA or 255,
        player
    )

    widget:Update()
    self:_AddWidget(widget)

    return widget
end

--[[
    Creates a map object widget.<br>
    Similar to a map label, this is shown on the map. However, this comes with an interactive circular icon
    that when hovered over, shows a title and a subtitle.<br>
    This is what Stormworks missions use to show mission locations.
]]
---@param title string
---@param text string
---@param objectType SWMarkerTypeEnum
---@param position SWMatrix
---@param radius number
---@param visible boolean
---@param colorR number|nil
---@param colorG number|nil
---@param colorB number|nil
---@param colorA number|nil
---@param player NoirPlayer|nil
---@return NoirMapObjectWidget
function Noir.Services.UIService:CreateMapObject(title, text, objectType, position, radius, visible, colorR, colorG, colorB, colorA, player)
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "text", text, "string")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "objectType", objectType, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "position", position, "table")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "radius", radius, "number")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "visible", visible, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "colorR", colorR, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "colorG", colorG, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "colorB", colorB, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "colorA", colorA, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.UIService:CreateMapObject()", "player", player, Noir.Classes.Player, "nil")

    local widget = Noir.Classes.MapObjectWidget:New(
        server.getMapID(),
        visible,
        title,
        text,
        objectType,
        position,
        radius,
        colorR or 255,
        colorG or 255,
        colorB or 255,
        colorA or 255,
        player
    )

    widget:Update()
    self:_AddWidget(widget)

    return widget
end

--[[
    Returns a widget by ID.
]]
---@param ID integer
---@return NoirWidget|nil
function Noir.Services.UIService:GetWidget(ID)
    return self.Widgets[ID]
end

--[[
    Returns all widgets shown to a player.<br>
    Unlike `:GetWidgetsBelongingToPlayer()`, this will include widgets that are shown to all players including this player.
]]
---@param player NoirPlayer
---@return table<integer, NoirWidget>
function Noir.Services.UIService:GetWidgetsShownToPlayer(player)
    local widgets = {}

    for _, widget in pairs(self.Widgets) do
        if not widget.Player or Noir.Services.PlayerService:IsSamePlayer(player, widget.Player) then
            table.insert(widgets, widget)
        end
    end

    return widgets
end

--[[
    Returns all widgets belonging to a player (ignoring widgets belonging to all players).
]]
---@param player NoirPlayer
---@return table<integer, NoirWidget>
function Noir.Services.UIService:GetWidgetsBelongingToPlayer(player)
    local widgets = {}

    for _, widget in pairs(self.Widgets) do
        if not widget.Player then
            goto continue
        end

        if Noir.Services.PlayerService:IsSamePlayer(player, widget.Player) then
            table.insert(widgets, widget)
        end

        ::continue::
    end

    return widgets
end

--[[
    Remove a widget by ID. This will also hide the widget from players.
]]
---@param ID integer
function Noir.Services.UIService:RemoveWidget(ID)
    local widget = self:GetWidget(ID)

    if not widget then
        error("Noir.Services.UIService:RemoveWidget()", "No widget with ID %d exists.", ID)
    end

    widget:Destroy()
    self:_RemoveWidget(widget)
end

--[[
    Returns the player a serialized widget belongs to.<br>
    Raises an error if the player does not exist and peer id is not -1.
]]
---@param ID integer The peer ID of the player, or -1 if everyone
---@return NoirPlayer|nil
function Noir.Services.UIService:_GetSerializedPlayer(ID)
    Noir.TypeChecking:Assert("Noir.Services.UIService:_GetSerializedPlayer()", "ID", ID, "number")

    if ID == -1 then
        return
    end

    local player = Noir.Services.PlayerService:GetPlayer(ID)

    if not player then
        error("Noir.Services.UIService:_GetSerializedPlayer()", "Player with ID %d does not exist.", ID)
    end

    return player
end