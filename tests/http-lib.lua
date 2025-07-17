--------------------------------------------------------
-- [Noir] Tests - HTTP Library
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

local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
local encoded = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~"

assert(Noir.Libraries.HTTP:URLEncode(characters) == encoded, "URL encoded characters doesn't match expected")
assert(Noir.Libraries.HTTP:URLDecode(encoded) == characters, "URL decode of URL encoded characters doesn't match expected")

local urlParams = Noir.Libraries.HTTP:URLParameters({
    foo = 1,
    bar = " "
})

assert(urlParams == "?foo=1&bar=%20" or urlParams == "?bar=%20&foo=1", "URL parameters don't match expected")

assert(Noir.Libraries.HTTP:IsResponseOk("Connection closed unexpectedly") == false, ":IsResponseOk() returned ok when it should be not ok")
assert(Noir.Libraries.HTTP:IsResponseOk("connect(): Connection refused") == false, ":IsResponseOk() returned ok when it should be not ok")
assert(Noir.Libraries.HTTP:IsResponseOk("recv(): Connection reset by peer") == false, ":IsResponseOk() returned ok when it should be not ok")
assert(Noir.Libraries.HTTP:IsResponseOk("timeout") == false, ":IsResponseOk() doesn't match expected")
assert(Noir.Libraries.HTTP:IsResponseOk("connect(): Can't assign requested address") == false, ":IsResponseOk() returned ok when it should be not ok")
assert(Noir.Libraries.HTTP:IsResponseOk("foo bar") == true, ":IsResponseOk() returned not ok when it should be ok")