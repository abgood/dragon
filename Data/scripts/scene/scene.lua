
scene = {};

local this = scene;


require "scripts/libs/Base"
require "scripts/network/Dbg"
require "scripts/app"


scene.entities = {}
scene.player = nil


local CAMERA_DISTANCE = 10.0;
local CTRL_FORWARD = 1;
local CTRL_BACK = 2;
local CTRL_LEFT = 4;
local CTRL_RIGHT = 8;
local CTRL_BRAKE = 16;


local jillNodes = {};


scene.init = function()
	logInfo("scene init");
	this.CreateScene()
end

scene.CreateScene = function()
	scene_ = Scene()
end

scene.enter_scene = function()
	logDbg("scene:enter_scene set view port");
end

scene.set_direction = function(entity)
	logDbg("KBEscene.set_direction entity id: " .. entity.id);
	local ae = this.entities[entity.id];
	if (not ae) then
		return;
	end
	ae:setDirection(entity.direction.z);
end

scene.set_position = function(entity)
	logDbg("KBEscene.set_position entity id: " .. entity.id);
	local ae = this.entities[entity.id];
	if (not ae) then
		return;
	end
	if (not ae) then
		return;
	end
	ae:SetPosition(entity.position.x, entity.position.y, entity.position.z);
end

scene.onEnterWorld = function(entity)
	logDbg("KBEscene.onEnterWorld entity id: " .. entity.id);
	if (not entity:isPlayer()) then
		local obj = entity:create_avatar();
		this.entities[entity.id] = obj;
	end
end

scene.addSpaceGeometryMapping = function(resPath)
	logDbg("scene:addSpaceGeometryMapping set map: " .. resPath);
	local file = cache:GetFile("Scenes/Raycast.xml");
	scene_:LoadXML(file);
	cameraNode = scene_:GetChild("Camera");

	local lightNode = scene_:GetChild("DirectionalLight")
	lightNode.direction = Vector3(0.3, -0.5, 0.425)

	this.SetupViewport();

	this.add_mushrooms();

	this.add_jills();

	this.create_avatar_enter_world();
end

scene.onAvatarEnterWorld = function(rndUUID, eid, avatar)
	logDbg("scene:onAvatarEnterWorld uuid: " .. rndUUID .. ", eid: " .. eid);

	this.player = avatar;
end

scene.update = function(eventType, eventData)
	if (not scene) then
		return;
	end

	local ae = this.entities[app.libnetwork.entity_id];
	if (not ae) then
		return;
	end

	local vehicleNode = ae.renderObj;
	if (not vehicleNode) then
		return;
	end

	local vehicle = vehicleNode:GetScriptObject();
	if (not vehicle) then
		return;
	end

	if ui.focusElement == nil then
		vehicle.controls:Set(CTRL_FORWARD, input:GetKeyDown(KEY_W));
		vehicle.controls:Set(CTRL_BACK, input:GetKeyDown(KEY_S));
		vehicle.controls:Set(CTRL_LEFT, input:GetKeyDown(KEY_A));
		vehicle.controls:Set(CTRL_RIGHT, input:GetKeyDown(KEY_D));
		vehicle.controls:Set(CTRL_BRAKE, input:GetKeyDown(KEY_F));
	else
		vehicle.controls:Set(CTRL_FORWARD + CTRL_BACK + CTRL_LEFT + CTRL_RIGHT, false);
	end
end

scene.post_update = function(eventType, eventData)
	if (not scene) then
		return;
	end

	local ae = this.entities[app.libnetwork.entity_id];
	if (not ae) then
		return;
	end

	local vehicleNode = ae.renderObj;
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

scene.create_avatar_enter_world = function()
	local obj = this.player:create_avatar();
	this.entities[this.player.id] = obj;
end

scene.SetupViewport = function()
	local camera = cameraNode:GetComponent("Camera")
	renderer:SetViewport(0, Viewport:new(scene_, camera))
end

scene.add_mushrooms = function()
	local terrainNode = scene_:GetChild("Terrain");
	local terrain = terrainNode:GetComponent("Terrain");

	local NUM_MUSHROOMS = 1000;
	for i = 1, NUM_MUSHROOMS do
		local objectNode = scene_:CreateChild("Mushroom_" .. i);
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

scene.add_jills = function()
	local terrainNode = scene_:GetChild("Terrain");
	local terrain = terrainNode:GetComponent("Terrain");

	local NUM_MODELS = 300;
	local MODEL_MOVE_SPEED = 2.0;
	local MODEL_ROTATE_SPEED = 100.0;
	local bounds = BoundingBox(Vector3(-1000.0, 0.0, -1000,0), Vector3(1000.0, 0.0, 1000.0));

	for i = 1, NUM_MODELS do
		local modelNode = scene_:CreateChild("Jill_" .. i);
		local position = Vector3(Random(2000.0) - 1000.0, 0.0, Random(2000.0) - 1000.0);
		position.y = terrain:GetHeight(position);
		modelNode.position = position;
		modelNode.rotation = Quaternion(Vector3(0.0, 1.0, 0.0), terrain:GetNormal(position));

		local modelObject = modelNode:CreateComponent("AnimatedModel");
		modelObject.model = cache:GetResource("Model", "Models/Kachujin/Kachujin.mdl");
		modelObject.material = cache:GetResource("Material", "Models/Kachujin/Materials/Kachujin.xml");
		modelObject.castShadows = true;

		local walkAnimation = cache:GetResource("Animation", "Models/Kachujin/Kachujin_Walk.ani");
		local state = modelObject:AddAnimationState(walkAnimation);
		state.weight = 1.0;
		state.looped = true;
		state.time = Random(walkAnimation.length);

		local object = modelNode:CreateScriptObject("scripts/object/Mover.lua", "Mover");
		object:SetParameters(MODEL_MOVE_SPEED, MODEL_ROTATE_SPEED, bounds);

		table.insert(jillNodes, modelNode);
	end

end


return scene;
