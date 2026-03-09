--------------------------------------------------------
-- [Noir] Classes - Chat Logger Middleware
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
    Logger middleware to send logs to chat.
]]
---@class NoirChatLoggerMiddleware: NoirLoggerMiddleware
---@field New fun(self: NoirChatLoggerMiddleware): NoirChatLoggerMiddleware
Noir.Classes.ChatLoggerMiddleware = Noir.Class("ChatLoggerMiddleware", Noir.Classes.LoggerMiddleware)

--[[
    Initializes ChatLoggerMiddleware class objects.
]]
function Noir.Classes.ChatLoggerMiddleware:Init()
    self:InitFrom(
        Noir.Classes.LoggerMiddleware,
        "ChatLoggerMiddleware"
    )
end

--[[
    Called when a log from the attached logger is received.
]]
---@param record NoirLogRecord
function Noir.Classes.ChatLoggerMiddleware:OnLog(record)
    server.announce(record.Logger.Name, record:Format())
end