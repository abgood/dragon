--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local EventLib = require "scripts/network/eventlib"

local Event = {}
local events = {}

function Event.AddListener(event,handler)
	if not event or type(event) ~= "string" then
		logError("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		logError("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		--create the Event with name
		events[event] = EventLib:new(event)
	end

	--conn this handler
	events[event]:connect(handler)
end

function Event.Brocast(event,...)
	if not events[event] then
		logError("brocast " .. event .. " has no event.")
	else
		events[event]:fire(...)
	end
end

function Event.RemoveListener(event,handler)
	if not events[event] then
		logError("remove " .. event .. " has no event.")
	else
		events[event]:disconnect(handler)
	end
end

return Event
