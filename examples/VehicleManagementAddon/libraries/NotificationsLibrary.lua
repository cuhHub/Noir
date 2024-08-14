--------------------------------------------------------
-- [Noir] Example - Vehicle Management Addon
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author(s): @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/Noir

    License:
        Copyright (C) 2024 Cuh4

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

---@class NotificationsLib: NoirLibrary
Notifications = Noir.Libraries:Create("Notifications")

---@param title string
---@param text string
---@param notificationType SWNotificationTypeEnum
---@param player NoirPlayer|nil
function Notifications:SendNotification(title, text, notificationType, player)
    server.notify(player and player.ID or -1, title, text, notificationType)
end

---@param title string
---@param text string
---@param player NoirPlayer|nil
function Notifications:SendErrorNotification(title, text, player)
    server.notify(player and player.ID or -1, title, text, 2)
end

---@param title string
---@param text string
---@param player NoirPlayer|nil
function Notifications:SendSuccessNotification(title, text, player)
    server.notify(player and player.ID or -1, title, text, 4)
end

---@param title string
---@param text string
---@param player NoirPlayer|nil
function Notifications:SendWarningNotification(title, text, player)
    server.notify(player and player.ID or -1, title, text, 8)
end

---@param title string
---@param text string
---@param player NoirPlayer|nil
function Notifications:SendInfoNotification(title, text, player)
    server.notify(player and player.ID or -1, title, text, 11)
end