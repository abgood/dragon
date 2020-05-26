require "scripts/libs/Base"
require "scripts/network/Dbg"

local game = require 'game.game'
local libnetwork = require 'network.KBEngine'

local scene = {}
setmetatable(scene, scene)

local mt = {}

scene.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'scene'
mt.name = 'scene'
mt.entities = {}



function scene.init()
	logInfo(scene:get_type() .. " init");
	CreateScene()
end

function CreateScene()
	scene_ = Scene()
end

function scene.enter_scene()
	logDbg("scene:enter_scene set view port");
end

function scene.set_direction(entity)
	print ("lj set_direction");
end

function scene.set_position(entity)
	print ("lj set_position");
end

function scene.onEnterWorld(entity)
	print ("lj scene onEnterWorld");
end

function scene.addSpaceGeometryMapping(resPath)
	logDbg("scene:addSpaceGeometryMapping set map", resPath);
	scene_:LoadXML(fileSystem:GetProgramDir() .. "Data/Scenes/Isometric2D.xml");
	cameraNode = scene_:GetChild("Camera");

	SetupViewport();
end

function SetupViewport()
	local viewport = Viewport:new(scene_, cameraNode:GetComponent("Camera"));
	renderer:SetViewport(0, viewport);
	renderer.defaultZone.fogColor = Color(0.2, 0.2, 0.2);
end


return scene
