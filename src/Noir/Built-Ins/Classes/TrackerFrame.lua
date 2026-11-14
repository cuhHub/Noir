--------------------------------------------------------
-- [Noir] Classes - TrackerFrame
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
    Tracks timing for one function call.
]]
---@class NoirTrackerFrame: NoirClass
---@field New fun(self: NoirTrackerFrame, tracker: NoirTracker): NoirTrackerFrame
---@field Tracker NoirTracker The tracker for this call
---@field Samples table<integer, integer> The tracker's execution history when the call began
---@field SelfTime number Time spent in the function itself (milliseconds)
---@field ChildTime number Time spent in tracked child calls (milliseconds)
---@field Start number|nil When self timing last resumed (milliseconds)
Noir.Classes.TrackerFrame = Noir.Class("TrackerFrame")

--[[
    Initializes a tracker frame.
]]
---@param tracker NoirTracker
function Noir.Classes.TrackerFrame:Init(tracker)
    Noir.TypeChecking:Assert("Noir.Classes.TrackerFrame:Init()", "tracker", tracker, Noir.Classes.Tracker)

    self.Tracker = tracker
    self.Samples = tracker.ExecutionTimes

    self.SelfTime = 0
    self.ChildTime = 0
end