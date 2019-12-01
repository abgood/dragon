
require "scripts/libs/Base"

function Start()
	BaseStart()

	CreateScene()

	local game = require 'game.game'
	local libnetwork = require 'network.KBEngine'
	local login = require 'login.login'

	game.init()
	libnetwork.init()
	login.init()

	SetupViewport()

    SampleInitMouseMode(MM_FREE)
	
	SubscribeToEvents()
end

function Stop()
end

function CreateScene()
    scene_ = Scene()

    scene_:CreateComponent("Octree")

    cameraNode = scene_:CreateChild("Camera")
    cameraNode:CreateComponent("Camera")

    cameraNode.position = Vector3(0.0, 5.0, 0.0)
end

function SetupViewport()
    local viewport = Viewport:new(scene_, cameraNode:GetComponent("Camera"))
    renderer:SetViewport(0, viewport)
end

function SubscribeToEvents()
    SubscribeToEvent("Update", "HandleUpdate")
    SubscribeToEvent("ServerConnected", "HandleConnectionStatus")
end

function HandleUpdate(eventType, eventData)
    local timeStep = eventData["TimeStep"]:GetFloat()
end
