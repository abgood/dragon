
require "scripts/libs/Base"


local event = require 'scripts/event/event'
local libnetwork = require 'scripts/network/KBEngine'
local login = require 'scripts/login/login'
local scene = require 'scripts/scene/scene'
local map = require 'scripts/map/map'


function Start()
	BaseStart()

	event.init()
	libnetwork.init()
	login.init()
	scene.init()
	map.init()

	SampleInitMouseMode(MM_FREE)
	
	SubscribeToEvents()

	libnetwork.encode();

	-- scene.addSpaceGeometryMapping()
end

function Stop()
	event.uninstallEvents()
	libnetwork.Destroy();
end

function SubscribeToEvents()
    SubscribeToEvent("Update", "HandleUpdate")
    SubscribeToEvent("PostUpdate", "HandlePostUpdate")

    SubscribeToEvent("NetworkMessage", "HandleNetworkMessage")
    SubscribeToEvent("ServerConnected", "HandleConnectionStatus")
end

function HandleUpdate(eventType, eventData)
	libnetwork.update(eventType, eventData);
	scene.update(eventType, eventData);
end

function HandlePostUpdate(eventType, eventData)
	scene.post_update(eventType, eventData);
end
