--------------------------------------------------------
-- [Noir] Services - Notification Service
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
    A service for sending notifications to players.

    -- Notify multiple
    local player1, player2 = Noir.Services.PlayerService:GetPlayer(0), Noir.Services.PlayerService:GetPlayer(1)
    Noir.Services.NotificationService:Info("Money", "Your money is $%d.", {player1, player2}, 1000)

    -- Notify one
    local player = Noir.Services.PlayerService:GetPlayer(0)
    Noir.Services.NotificationService:Info("Money", "Your money is $1000.", player) -- FYI: This is the same message as above

    -- Notify everyone
    Noir.Services.NotificationService:Info("Money", "Your money is $1000.", Noir.Services.PlayerService:GetPlayers())
]]
---@class NoirNotificationService: NoirService
---@field SuccessTitlePrefix string The title prefix for success notifications
---@field WarningTitlePrefix string The title prefix for warning notifications
---@field ErrorTitlePrefix string The title prefix for error notifications
---@field InfoTitlePrefix string The title prefix for info notifications
Noir.Services.NotificationService = Noir.Services:CreateService(
    "NotificationService",
    true,
    "A service for notifying players.",
    "A minimal service for notifying players.",
    {"Cuh4"}
)

function Noir.Services.NotificationService:ServiceInit()
    self.SuccessTitlePrefix = "[Success] "
    self.WarningTitlePrefix = "[Warning] "
    self.ErrorTitlePrefix = "[Error] "
    self.InfoTitlePrefix = "[Info] "
end

--[[
    Notify a player or multiple players.
]]
---@param title string
---@param message string
---@param notificationType SWNotificationTypeEnum
---@param player NoirPlayer|table<integer, NoirPlayer>|nil
---@param ... any
function Noir.Services.NotificationService:Notify(title, message, notificationType, player, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.NotificationService:Notify()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Services.NotificationService:Notify()", "message", message, "string")
    Noir.TypeChecking:Assert("Noir.Services.NotificationService:Notify()", "notificationType", notificationType, "number")
    Noir.TypeChecking:Assert("Noir.Services.NotificationService:Notify()", "player", player, Noir.Classes.Player, "table", "nil")

    -- Convert to table if needed
    local players

    if player == nil then
        players = Noir.Services.PlayerService:GetPlayers(true)
    else
        players = (type(player) == "table" and not Noir.Classes.Player:IsClass(player)) and player or {player}
    end

    -- Format message
    local formattedMessage = ... and message:format(...) or message

    -- Notify
    for _, playerToNotify in pairs(players) do
        playerToNotify:Notify(title, formattedMessage, notificationType)
    end
end

--[[
    Send a success notification to a player.
]]
---@param title string
---@param message string
---@param player NoirPlayer|table<integer, NoirPlayer>|nil
---@param ... any
function Noir.Services.NotificationService:Success(title, message, player, ...)
    self:Notify(self.SuccessTitlePrefix..title, message, 4, player, ...)
end

--[[
    Send a warning notification to a player.
]]
---@param title string
---@param message string
---@param player NoirPlayer|table<integer, NoirPlayer>|nil
---@param ... any
function Noir.Services.NotificationService:Warning(title, message, player, ...)
    self:Notify(self.WarningTitlePrefix..title, message, 1, player, ...)
end

--[[
    Send an error notification to a player.
]]
---@param title string
---@param message string
---@param player NoirPlayer|table<integer, NoirPlayer>|nil
---@param ... any
function Noir.Services.NotificationService:Error(title, message, player, ...)
    self:Notify(self.ErrorTitlePrefix..title, message, 3, player, ...)
end

--[[
    Send an info notification to a player.
]]
---@param title string
---@param message string
---@param player NoirPlayer|table<integer, NoirPlayer>|nil
---@param ... any
function Noir.Services.NotificationService:Info(title, message, player, ...)
    self:Notify(self.InfoTitlePrefix..title, message, 7, player, ...)
end