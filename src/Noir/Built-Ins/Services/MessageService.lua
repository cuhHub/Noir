--------------------------------------------------------
-- [Noir] Services - Message Service
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
    A service for storing, accessing and sending messages.

    ---@param message NoirMessage
    Noir.Services.MessageService.OnMessage:Connect(function(message)
        Noir.Libraries.Logging:Info("Message", "(%s) > %s (%s)", message.Title, message.Content, message.IsAddon and "Sent by addon" or "Sent by player")
    end)

    Noir.Services.MessageService:SendMessage(nil, "[Server]", "Hello world!")
]]
---@class NoirMessageService: NoirService
---@field Messages table<integer, NoirMessage> A table of all messages that have been sent.
---@field _SavedMessages table<integer, NoirSerializedMessage> A table of all messages that have been sent (g_savedata version).
---@field _MessageLimit integer The maximum amount of messages that can be stored.
---
---@field OnMessage NoirEvent Arguments: message (NoirMessage) | Fired when a message is sent.
---
---@field _OnChatMessageConnection NoirConnection The connection to the `onChatMessage` event.
Noir.Services.MessageService = Noir.Services:CreateService(
    "MessageService",
    true,
    "A service for storing, accessing and sending messages.",
    nil,
    {"Cuh4"}
)

Noir.Services.MessageService.InitPriority = 2
-- ^ just after playerservice. loading saved messages cannot be done if this is not initialized after playerservice

function Noir.Services.MessageService:ServiceInit()
    self.Messages = {}
    self._SavedMessages = self:Load("Messages", {})
    self._MessageLimit = 220

    self.OnMessage = Noir.Libraries.Events:Create()
    self:_LoadSavedMessages()
end

function Noir.Services.MessageService:ServiceStart()
    self._OnChatMessageConnection = Noir.Callbacks:Connect("onChatMessage", function(peerID, title, message)
        -- Get author of message (player)
        local author = Noir.Services.PlayerService:GetPlayer(peerID)

        if not author then
            error("MessageService", "Failed to get author of message via 'onChatMessage' callback.")
        end

        -- Register message
        self:_RegisterMessage(
            title,
            message,
            author,
            false,
            nil,
            nil,
            true
        )
    end)
end

--[[
    Load all saved messages.<br>
    Used internally.
]]
function Noir.Services.MessageService:_LoadSavedMessages()
    -- Get messages
    local messages = Noir.Libraries.Table:Copy(self._SavedMessages)

    -- Ensure correct order
    table.sort(messages, function(a, b)
        return a.SentAt < b.SentAt
    end)

    -- Clear saved messages
    self._SavedMessages = {}
    self:Save("Messages", self._SavedMessages)

    -- Register saved messages
    for _, message in pairs(messages) do
        self:_RegisterMessage(
            message.Title,
            message.Content,
            message.Author and Noir.Services.PlayerService:GetPlayer(message.Author),
            message.IsAddon,
            message.SentAt,
            message.Recipient and Noir.Services.PlayerService:GetPlayer(message.Recipient),
            false
        )
    end
end

--[[
    Insert a value into a table, removing the first value if the table is full.<br>
    Used internally.
]]
---@param tbl table
---@param value any
---@param limit integer
function Noir.Services.MessageService:_InsertIntoTable(tbl, value, limit)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_InsertIntoTable()", "tbl", tbl, "table")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_InsertIntoTable()", "limit", limit, "number")

    -- Insert
    table.insert(tbl, value)

    -- Remove
    if #tbl > limit then
        table.remove(tbl, 1)
    end
end

--[[
    Register a message.<br>
    Used internally.
]]
---@param title string
---@param content string
---@param author NoirPlayer|nil
---@param isAddon boolean
---@param sentAt number|nil
---@param recipient NoirPlayer|nil
---@param fireEvent boolean|nil
---@return NoirMessage
function Noir.Services.MessageService:_RegisterMessage(title, content, author, isAddon, sentAt, recipient, fireEvent)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "content", content, "string")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "author", author, Noir.Classes.Player, "nil")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "isAddon", isAddon, "boolean")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "sentAt", sentAt, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "recipient", recipient, Noir.Classes.Player, "nil")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_RegisterMessage()", "fireEvent", fireEvent, "boolean", "nil")

    -- Create message
    local message = Noir.Classes.Message:New(
        author,
        isAddon,
        content,
        title,
        sentAt or server.getTimeMillisec(),
        recipient
    )

    -- Register
    self:_InsertIntoTable(self.Messages, message, self._MessageLimit)

    -- Save
    self:_SaveMessage(message)

    -- Fire event
    if fireEvent then
        self.OnMessage:Fire(message)
    end

    -- Return
    return message
end

--[[
    Save a message.<br>
    Used internally.
]]
---@param message NoirMessage
function Noir.Services.MessageService:_SaveMessage(message)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.MessageService:_SaveMessage()", "message", message, Noir.Classes.Message)

    -- Save
    self:_InsertIntoTable(self._SavedMessages, message:_Serialize(), self._MessageLimit)
    self:Save("Messages", self._SavedMessages)
end

--[[
    Send a message to a player or all players.

    Noir.Services.MessageService:SendMessage(nil, "[Server]", "Hello, %s!", "world") -- "[Server] Hello, world!"
]]
---@param player NoirPlayer|nil nil = everyone
---@param title string
---@param content string
---@param ... any
---@return NoirMessage
function Noir.Services.MessageService:SendMessage(player, title, content, ...)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.MessageService:SendMessage()", "player", player, Noir.Classes.Player, "nil")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:SendMessage()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Services.MessageService:SendMessage()", "content", content, "string")

    -- Send message
    local formattedContent = ... and content:format(...) or content
    server.announce(title, formattedContent, player and player.ID or -1)

    -- Register message
    local message = self:_RegisterMessage(
        title,
        formattedContent,
        nil,
        true,
        nil,
        player,
        true
    )

    -- Return message
    return message
end

--[[
    Returns all messages sent by a player.
]]
---@param player NoirPlayer
---@return table<integer, NoirMessage>
function Noir.Services.MessageService:GetMessagesByPlayer(player)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.MessageService:GetMessagesByPlayer()", "player", player, Noir.Classes.Player)

    -- Get messages
    local messages = {}

    for _, message in pairs(self:GetAllMessages()) do
        if message.Author and Noir.Services.PlayerService:IsSamePlayer(player, message.Author) then
            table.insert(messages, message)
        end
    end

    -- Return
    return messages
end

--[[
    Returns all messages.<br>
    Earliest entries in table = Oldest messages
]]
---@param copy boolean|nil Whether or not to copy the table (recommended), but may be slow
---@return table<integer, NoirMessage>
function Noir.Services.MessageService:GetAllMessages(copy)
    Noir.TypeChecking:Assert("Noir.Services.MessageService:GetAllMessages()", "copy", copy, "boolean", "nil")
    return copy and Noir.Libraries.Table:Copy(self.Messages) or self.Messages
end