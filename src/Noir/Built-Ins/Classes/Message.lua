--------------------------------------------------------
-- [Noir] Classes - Message
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

--[[
    Represents a message.
]]
---@class NoirMessage: NoirClass
---@field New fun(self: NoirMessage, author: NoirPlayer|nil, isAddon: boolean, content: string, title: string, sentAt: number|nil, recipient: NoirPlayer|nil): NoirMessage
---@field Author NoirPlayer|nil The author of the message, or nil if sent by an addon
---@field IsAddon boolean Whether or not the message was sent by an addon
---@field Content string The actual message
---@field Title string If this message wasn't sent by an addon, this will be the author's name
---@field SentAt number Represents when the message was sent
---@field Recipient NoirPlayer|nil Who received the message, nil = everyone
Noir.Classes.MessageClass = Noir.Class("NoirMessage")

--[[
    Initializes message class objects.
]]
---@param author NoirPlayer|nil
---@param isAddon boolean
---@param content string
---@param title string
---@param sentAt number|nil
---@param recipient NoirPlayer|nil
function Noir.Classes.MessageClass:Init(author, isAddon, content, title, sentAt, recipient)
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:Init()", "author", author, Noir.Classes.PlayerClass, "nil")
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:Init()", "isAddon", isAddon, "boolean")
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:Init()", "content", content, "string")
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:Init()", "title", title, "string")
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:Init()", "sentAt", sentAt, "number", "nil")
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:Init()", "recipient", recipient, Noir.Classes.PlayerClass, "nil")

    self.Author = author
    self.IsAddon = isAddon
    self.Content = content
    self.Title = title
    self.SentAt = sentAt or server.getTimeMillisec()
    self.Recipient = recipient
end

--[[
    Serializes the message into a g_savedata-safe format.<br>
    Used internally.
]]
---@return NoirSerializedMessage
function Noir.Classes.MessageClass:_Serialize()
    return {
        Author = self.Author and self.Author.ID,
        IsAddon = self.IsAddon,
        Content = self.Content,
        Title = self.Title,
        SentAt = self.SentAt,
        Recipient = self.Recipient and self.Recipient.ID
    }
end

--[[
    Deserializes the message from a g_savedata-safe format.<br>
    Used internally.
]]
---@param serializedMessage NoirSerializedMessage
function Noir.Classes.MessageClass:_Deserialize(serializedMessage)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Classes.MessageClass:_Deserialize()", "serializedMessage", serializedMessage, "table")

    -- Create the message
    local message = self:New(
        serializedMessage.Author and Noir.Services.PlayerService:GetPlayer(serializedMessage.Author),
        serializedMessage.IsAddon,
        serializedMessage.Content,
        serializedMessage.Title,
        serializedMessage.SentAt,
        serializedMessage.Recipient and Noir.Services.PlayerService:GetPlayer(serializedMessage.Recipient)
    )

    -- Return the message
    return message
end

-------------------------------
-- // Intellisense
-------------------------------

--[[
    Represents a serialized version of the NoirMessage class.
]]
---@class NoirSerializedMessage
---@field Author integer|nil
---@field IsAddon boolean
---@field Content string
---@field Title string
---@field SentAt number
---@field Recipient integer|nil