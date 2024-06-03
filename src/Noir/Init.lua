--------------------------------------------------------
-- [Noir] Init
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
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

--[[
    This is here for those who want to use this framework without using the tools provided with the framework
    but instead using the Stormworks Lua extension's build feature.
]]

-------------------------------
-- // Main
-------------------------------
require("Definition")

require("Libraries")

require("Built-Ins.Libraries.Class")

require("Classes.Init")
require("Classes.Connection")
require("Classes.Event")
require("Classes.Service")
require("Classes.Player")
require("Classes.Task")

require("Built-Ins.Libraries.Events")
require("Built-Ins.Libraries.Logging")
require("Built-Ins.Libraries.Table")

require("Services")

require("Built-Ins.Services.TaskService")
require("Built-Ins.Services.PlayerService")

require("Callbacks")

require("Bootstrapper")

require("Noir")