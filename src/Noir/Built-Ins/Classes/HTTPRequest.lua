--------------------------------------------------------
-- [Noir] Classes - HTTP Request
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
    Represents a HTTP request.
]]
---@class NoirHTTPRequest: NoirClass
---@field New fun(self: NoirHTTPRequest, URL: string, port: integer): NoirHTTPRequest
---@field URL string
---@field Port integer
---@field OnResponse NoirEvent
Noir.Classes.HTTPRequestClass = Noir.Class("NoirHTTPRequest")

--[[
    Initializes HTTP request class objects.
]]
---@param URL string
---@param port integer
function Noir.Classes.HTTPRequestClass:Init(URL, port)
    Noir.TypeChecking:Assert("Noir.Classes.HTTPRequestClass:Init()", "URL", URL, "string")
    Noir.TypeChecking:Assert("Noir.Classes.HTTPRequestClass:Init()", "port", port, "number")

    self.URL = URL
    self.Port = port
    self.OnResponse = Noir.Libraries.Events:Create()
end