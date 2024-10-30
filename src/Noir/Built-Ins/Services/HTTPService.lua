--------------------------------------------------------
-- [Noir] Services - HTTP Service
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
    A service for sending HTTP requests.<br>
    Requests are localhost only due to Stormworks limitations.

    Noir.Services.HTTPService:GET("/items/5", 8000, function(response)
        if not response:IsOk() then
            return
        end

        local item = response:JSON()
        Noir.Libraries.Logging:Info("Item", item.Name)
    end)
]]
---@class NoirHTTPService: NoirService
---@field ActiveRequests table<integer, NoirHTTPRequest> A table of unanswered HTTP requests.
---@field _PortRangeMin integer The minimum acceptable port number.
---@field _PortRangeMax integer The maximum acceptable port number.
---@field _HTTPReplyConnection NoirConnection A connection to the httpReply event
Noir.Services.HTTPService = Noir.Services:CreateService(
    "HTTPService",
    true,
    "A service for sending HTTP requests.",
    "A service for sending HTTP requests. Comes with helper HTTP functions.",
    {"Cuh4"}
)

function Noir.Services.HTTPService:ServiceInit()
    self.ActiveRequests = {}

    self._PortRangeMin = 1
    self._PortRangeMax = 65535
end

function Noir.Services.HTTPService:ServiceStart()
    self._HTTPReplyConnection = Noir.Callbacks:Connect("httpReply", function(port, URL, response)
        -- Check if port is valid
        if not self:IsPortValid(port) then
            return
        end

        -- Find request
        local request, index = self:_FindRequest(URL, port)

        if not request then
            return
        end

        -- Trigger response
        request.OnResponse:Fire(Noir.Classes.HTTPResponse:New(response))

        -- Remove request
        table.remove(self.ActiveRequests, index)
    end)
end

--[[
    Get earliest request for a URL and port.<br>
    Used internally.
]]
---@param URL string
---@param port integer
---@return NoirHTTPRequest|nil, integer|nil
function Noir.Services.HTTPService:_FindRequest(URL, port)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HTTPService:_FindRequest()", "URL", URL, "string")
    Noir.TypeChecking:Assert("Noir.Services.HTTPService:_FindRequest()", "port", port, "number")

    -- Find request
    for index, request in ipairs(self:GetActiveRequests()) do
        if request.URL == URL and request.Port == port then
            return request, index
        end
    end
end

--[[
    Returns if a port is within the valid port range.
]]
---@param port integer
---@return boolean
function Noir.Services.HTTPService:IsPortValid(port)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HTTPService:IsPortValid()", "port", port, "number")

    -- Return
    return port >= self._PortRangeMin and port <= self._PortRangeMax
end

--[[
    Send a GET request.<br>
    All requests are localhost only. This is a Stormworks limitation.

    Noir.Services.HTTPService:GET("/items/5", 8000, function(response)
        if not response:IsOk() then
            return
        end

        local item = response:JSON()
        Noir.Libraries.Logging:Info("Item", item.Name)
    end)
]]
---@param URL string
---@param port integer
---@param callback fun(response: NoirHTTPResponse)|nil
---@return NoirHTTPRequest|nil
function Noir.Services.HTTPService:GET(URL, port, callback)
    -- Type checking
    Noir.TypeChecking:Assert("Noir.Services.HTTPService:GET()", "URL", URL, "string")
    Noir.TypeChecking:Assert("Noir.Services.HTTPService:GET()", "port", port, "number")
    Noir.TypeChecking:Assert("Noir.Services.HTTPService:GET()", "callback", callback, "function", "nil")

    -- Check if port is valid
    if not self:IsPortValid(port) then
        Noir.Libraries.Logging:Error("HTTPService", "Port is out of range, expected a port between %d and %d.", true, self._PortRangeMin, self._PortRangeMax)
        return
    end

    -- Create request object
    local request = Noir.Classes.HTTPRequest:New(URL, port)

    if callback then
        request.OnResponse:Once(callback)
    end

    -- Send request
    server.httpGet(port, URL)
    table.insert(self.ActiveRequests, request)

    -- Return it
    return request
end

--[[
    Returns all active requests.
]]
---@return table<integer, NoirHTTPRequest>
function Noir.Services.HTTPService:GetActiveRequests()
    return self.ActiveRequests
end