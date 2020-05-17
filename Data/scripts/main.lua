
require "scripts/libs/Base"


local event = require 'event.event'
local libnetwork = require 'network.KBEngine'
local login = require 'login.login'
local scene = require 'scene.scene'
local map = require 'map.map'


function Start()
	BaseStart()

	event.init()
	libnetwork.init()
	login.init()
	scene.init()
	map.init()

	SampleInitMouseMode(MM_FREE)
	
	SubscribeToEvents()
end

function Stop()
	event.uninstallEvents()
end

function SubscribeToEvents()
    SubscribeToEvent("Update", "HandleUpdate")

    SubscribeToEvent("NetworkMessage", "HandleNetworkMessage")
    SubscribeToEvent("ServerConnected", "HandleConnectionStatus")
end

function HandleUpdate(eventType, eventData)
    local timeStep = eventData["TimeStep"]:GetFloat()

	libnetwork.update();
end
