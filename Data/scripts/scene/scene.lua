require "scripts/libs/Base"
require "scripts/network/Dbg"

local game = require 'game.game'
local libnetwork = require 'network.KBEngine'

scene = {}

setmetatable(scene, scene)

local mt = {}

scene.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'scene'
mt.name = 'scene'
mt.entities = {}
mt.player = nil




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
	logDbg("KBEscene.set_direction entity id: " .. entity.id);
	local ae = scene.entities[entity.id];
	if (not ae) then
		return;
	end
	print ("lj set_direction", entity.id);
end

function scene.set_position(entity)
	logDbg("KBEscene.set_position entity id: " .. entity.id);
	local ae = scene.entities[entity.id];
	if (not ae) then
		return;
	end
	print ("lj set_position", entity.id);
end

function scene.onEnterWorld(entity)
	logDbg("KBEscene.onEnterWorld entity id: " .. entity.id);
	if (not entity:isPlayer()) then
		print ("lj onEnterWorld", entity.id, entity.className);
	end
end

function scene.addSpaceGeometryMapping(resPath)
	logDbg("scene:addSpaceGeometryMapping set map: " .. resPath);
	scene_:LoadXML(fileSystem:GetProgramDir() .. "Data/Scenes/Raycast.xml");
	cameraNode = scene_:GetChild("Camera");

    local lightNode = scene_:GetChild("DirectionalLight")
    lightNode.direction = Vector3(0.3, -0.5, 0.425)

	SetupViewport();

	add_mushrooms();

	create_avatar_enter_world();
end

function scene.onAvatarEnterWorld(rndUUID, eid, avatar)
	logDbg("scene:onAvatarEnterWorld uuid: " .. rndUUID .. ", eid: " .. eid);

	scene.player = avatar;
end

function scene.post_update(eventType, eventData)
	if (not scene) then
		return;
	end

	local vehicleNode = scene.entities[libnetwork.entity_id];
	if (not vehicleNode) then
		return;
	end

    local vehicle = vehicleNode:GetScriptObject();
	if (not vehicle) then
		return;
	end

	local dir = Quaternion(vehicleNode.rotation:YawAngle(), Vector3(0.0, 1.0, 0.0));
	dir = dir * Quaternion(vehicle.controls.yaw, Vector3(0.0, 1.0, 0.0));
	dir = dir * Quaternion(vehicle.controls.pitch, Vector3(1.0, 0.0, 0.0));

	local cameraTargetPos = vehicleNode.position - dir * Vector3(0.0, 0.0, CAMERA_DISTANCE);
	local cameraStartPos = vehicleNode.position;

	local cameraRay = Ray(cameraStartPos, (cameraTargetPos - cameraStartPos):Normalized());
	local cameraRayLength = (cameraTargetPos - cameraStartPos):Length();
	local physicsWorld = scene_:GetComponent("PhysicsWorld");
	local result = physicsWorld:RaycastSingle(cameraRay, cameraRayLength, 2);
	if result.body ~= nil then
		cameraTargetPos = cameraStartPos + cameraRay.direction * (result.distance - 0.5);
	end

	cameraNode.position = cameraTargetPos;
	cameraNode.rotation = dir;
end

function create_avatar_enter_world()
	local obj = scene.player:create_avatar();
	scene.entities[scene.player.id] = obj;
end

function SetupViewport()
    local camera = cameraNode:GetComponent("Camera")
    renderer:SetViewport(0, Viewport:new(scene_, camera))
end

function add_mushrooms()
	local terrainNode = scene_:GetChild("Terrain");
	local terrain = terrainNode:GetComponent("Terrain");

	local NUM_MUSHROOMS = 1000;
	for i = 1, NUM_MUSHROOMS do
		local objectNode = scene_:CreateChild("Mushroom");
		local position = Vector3(Random(2000.0) - 1000.0, 0.0, Random(2000.0) - 1000.0);
		position.y = terrain:GetHeight(position) - 0.1;
		objectNode.position = position;
		objectNode.rotation = Quaternion(Vector3(0.0, 1.0, 0.0), terrain:GetNormal(position));
		objectNode:SetScale(3.0);

		local object = objectNode:CreateComponent("StaticModel");
		object.model = cache:GetResource("Model", "Models/Mushroom.mdl");
		object.material = cache:GetResource("Material", "Materials/Mushroom.xml");
		object.castShadows = true;

		local body = objectNode:CreateComponent("RigidBody");
		body.collisionLayer = 2;
		local shape = objectNode:CreateComponent("CollisionShape");
		shape:SetTriangleMesh(object.model, 0);
	end
end


return scene
