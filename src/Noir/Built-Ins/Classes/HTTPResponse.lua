--------------------------------------------------------
-- [Noir] Classes - HTTP Response
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
    Represents a response to a HTTP request.
]]
---@class NoirHTTPResponse: NoirClass
---@field New fun(self: NoirHTTPResponse, response: string): NoirHTTPResponse
---@field Text string The raw response.
Noir.Classes.HTTPResponseClass = Noir.Class("NoirHTTPResponse")

--[[
    Initializes HTTP response class objects.
]]
---@param response string
function Noir.Classes.HTTPResponseClass:Init(response)
    Noir.TypeChecking:Assert("Noir.Classes.HTTPResponseClass:Init()", "response", response, "string")

    self.Text = response
end

--[[
    Attempts to JSON decode the response. This will error if the response cannot be JSON decoded.
]]
---@return any
function Noir.Classes.HTTPResponseClass:JSON()
    return (Noir.Libraries.JSON:Decode(self.Text))
end

--[[
    Returns whether or not the response is ok.
]]
---@return boolean
function Noir.Classes.HTTPResponseClass:IsOk()
    return Noir.Libraries.HTTP:IsResponseOk(self.Text)
end