--------------------------------------------------------
-- [Noir] Init
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

--[[
    This is deprecated but still maintained.
    If you would like to make a PR and test it, require() this file and use the Stormworks VSCode extension's build feature.

    Alternatively, and this is recommended, you could use the combine tool in the `/tools` directory and combine `src/Noir` with your addon files, completely removing the need for this init.lua file.
    You will need to create an `__order.json` file though, you can see the docs for an example.
]]

-------------------------------
-- // Main
-------------------------------

require("Noir.Definition")
require("Noir.Class")
require("Noir.TypeChecking")

require("Noir.Classes")

require("Noir.Built-Ins.Classes.Connection")
require("Noir.Built-Ins.Classes.Event")
require("Noir.Built-Ins.Classes.Service")
require("Noir.Built-Ins.Classes.Player")
require("Noir.Built-Ins.Classes.Task")
require("Noir.Built-Ins.Classes.Object")
require("Noir.Built-Ins.Classes.Command")
require("Noir.Built-Ins.Classes.Library")
require("Noir.Built-Ins.Classes.HTTPRequest")
require("Noir.Built-Ins.Classes.HTTPResponse")
require("Noir.Built-Ins.Classes.Body")
require("Noir.Built-Ins.Classes.Vehicle")
require("Noir.Built-Ins.Classes.Message")
require("Noir.Built-Ins.Classes.TickIterationProcess")
require("Noir.Built-Ins.Classes.AITargetData")
require("Noir.Built-Ins.Classes.Tracker")

require("Noir.Libraries")

require("Noir.Built-Ins.Libraries.Events")
require("Noir.Built-Ins.Libraries.Logging")
require("Noir.Built-Ins.Libraries.Table")
require("Noir.Built-Ins.Libraries.String")
require("Noir.Built-Ins.Libraries.Number")
require("Noir.Built-Ins.Libraries.JSON")
require("Noir.Built-Ins.Libraries.Base64")
require("Noir.Built-Ins.Libraries.Matrix")
require("Noir.Built-Ins.Libraries.Dataclasses")
require("Noir.Built-Ins.Libraries.HTTP")
require("Noir.Built-Ins.Libraries.Deprecation")

require("Noir.Services")

require("Noir.Built-Ins.Services.TaskService")
require("Noir.Built-Ins.Services.PlayerService")
require("Noir.Built-Ins.Services.ObjectService")
require("Noir.Built-Ins.Services.GameSettingsService")
require("Noir.Built-Ins.Services.CommandService")
require("Noir.Built-Ins.Services.TPSService")
require("Noir.Built-Ins.Services.NotificationService")
require("Noir.Built-Ins.Services.HTTPService")
require("Noir.Built-Ins.Services.VehicleService")
require("Noir.Built-Ins.Services.MessageService")
require("Noir.Built-Ins.Services.DebuggerService")

require("Noir.Callbacks")
require("Noir.Bootstrapper")
require("Noir.Noir")