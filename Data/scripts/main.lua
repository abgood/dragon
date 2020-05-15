
require "scripts/libs/Base"


local game = require 'game.game'
local libnetwork = require 'network.KBEngine'
local login = require 'login.login'
local scene = require 'scene.scene'
local map = require 'map.map'


function Start()
	BaseStart()

	CreateScene()

	installEvents()

	game.init()
	libnetwork.init()
	login.init()
	scene.init()
	map.init()

	SetupViewport()

    SampleInitMouseMode(MM_FREE)
	
	SubscribeToEvents()
end

function Stop()
	uninstallEvents()
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

    SubscribeToEvent("NetworkMessage", "HandleNetworkMessage")
    SubscribeToEvent("ServerConnected", "HandleConnectionStatus")
end

function HandleUpdate(eventType, eventData)
    local timeStep = eventData["TimeStep"]:GetFloat()

	libnetwork.update();
end

function installEvents()
	libnetwork.Event.AddListener("onLoginSuccessfully", login.onLoginSuccessfully);
	libnetwork.Event.AddListener("onReqAvatarList", login.onReqAvatarList);
	libnetwork.Event.AddListener("onCreateAvatarResult", login.onCreateAvatarResult);

	libnetwork.Event.AddListener("set_direction", scene.set_direction);
	libnetwork.Event.AddListener("set_position", scene.set_position);
	libnetwork.Event.AddListener("onEnterWorld", scene.onEnterWorld);
end

function uninstallEvents()
	libnetwork.Event.RemoveListener("onLoginSuccessfully", login.onLoginSuccessfully);
	libnetwork.Event.RemoveListener("onReqAvatarList", login.onReqAvatarList);

	libnetwork.Event.RemoveListener("set_direction", scene.set_direction);
	libnetwork.Event.RemoveListener("set_position", scene.set_position);
	libnetwork.Event.RemoveListener("onEnterWorld", scene.onEnterWorld);
end
