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

	scene_:CreateComponent("Octree")
	scene_:CreateComponent("DebugRenderer");
	local physicsWorld = scene_:CreateComponent("PhysicsWorld2D");
	physicsWorld.gravity = Vector2.ZERO;

	cameraNode = Node();
	local camera = cameraNode:CreateComponent("Camera");
	camera.orthographic = true;
	camera.orthoSize = graphics.height * PIXEL_SIZE;
	zoom = 2 * Min(graphics.width / 1280, graphics.height / 800);
	camera.zoom = zoom;

	local tmxFile = cache:GetResource("TmxFile2D", "Urho2D/Tilesets/atrium.tmx");
	tileMapNode = scene_:CreateChild("TileMap");
	local tileMap = tileMapNode:CreateComponent("TileMap2D");
	tileMap.tmxFile = tmxFile;

	scene_:LoadXML(fileSystem:GetProgramDir().."Data/Scenes/" .. "Isometric2D.xml")
end

function scene.enter_scene()
	logDbg("scene:enter_scene set view port");
	local viewport = Viewport:new(scene_, cameraNode:GetComponent("Camera"));
	renderer:SetViewport(0, viewport);
	renderer.defaultZone.fogColor = Color(0.2, 0.2, 0.2);
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
end


return scene
