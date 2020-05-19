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

	SetupViewport()
end

function SetupViewport()
    local viewport = Viewport:new(scene_, cameraNode:GetComponent("Camera"))
    renderer:SetViewport(0, viewport)
end

function CreateScene()
    scene_ = Scene()

    scene_:CreateComponent("Octree")

    cameraNode = scene_:CreateChild("Camera")
    cameraNode:CreateComponent("Camera")

    cameraNode.position = Vector3(0.0, 5.0, 0.0)
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
	print ("lj scene addSpaceGeometryMapping", resPath);
end


return scene
