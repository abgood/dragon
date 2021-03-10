require "scripts/libs/Base"
require "scripts/network/Dbg"
require "scripts/app"

local CTRL_FORWARD = 1;
local CTRL_BACK = 2;
local CTRL_LEFT = 4;
local CTRL_RIGHT = 8;
local CTRL_BRAKE = 16;
local CHASSIS_WIDTH = 2.6;
local MAX_WHEEL_ANGLE = 22.5;
local ENGINE_FORCE = 2500.0;

Vehicle = ScriptObject();

function Vehicle:Start()
	self.steering = 0.0;

	self.wheelWidth = 0.4;
	self.wheelRadius = 0.5;
	self.suspensionRestLength = 0.6;
	self.suspensionStiffness = 14.0;
	self.suspensionDamping = 2.0;
	self.suspensionCompression = 4.0;
	self.rollInfluence = 0.12;
	self.brakingForce = 50.0;
	self.maxEngineForce = ENGINE_FORCE;

	self.connectionPoints = {};
	self.particleEmitterNodeList = {};

	self.controls = Controls();
end

function Vehicle:Init()
	local node = self.node;
	local hullObject = node:CreateComponent("StaticModel");
	self.hullBody = node:CreateComponent("RigidBody");
	local hullShape = node:CreateComponent("CollisionShape");

	node.scale = Vector3(2.3, 1.0, 4.0);
	hullObject.model = cache:GetResource("Model", "Models/Box.mdl");
	hullObject.material = cache:GetResource("Material", "Materials/Stone.xml");
	hullObject.castShadows = true;
	hullShape:SetBox(Vector3(1.0, 1.0, 1.0));

	self.hullBody.mass = 800.0;
	self.hullBody.linearDamping = 0.2;
	self.hullBody.angularDamping = 0.5;
	self.hullBody.collisionLayer = 1;

	local raycastVehicle = node:CreateComponent("RaycastVehicle");
	raycastVehicle:Init();

	local connectionHeight = -0.4;
	local isFrontWheel = true;
	local wheelDirection = Vector3(0, -1, 0);
	local wheelAxle = Vector3(-1, 0, 0);
	local wheelX = CHASSIS_WIDTH / 2.0 - self.wheelWidth;

	table.insert(self.connectionPoints, Vector3(-wheelX, connectionHeight, 2.5 - self.wheelRadius * 2.0));
	table.insert(self.connectionPoints, Vector3(wheelX, connectionHeight, 2.5 - self.wheelRadius * 2.0));
	table.insert(self.connectionPoints, Vector3(-wheelX, connectionHeight, -2.5 + self.wheelRadius * 2.0));
	table.insert(self.connectionPoints, Vector3(wheelX, connectionHeight, -2.5 + self.wheelRadius * 2.0));

	for i = 1, #self.connectionPoints do
		local wheelNode = scene_:CreateChild();
		local connectionPoint = self.connectionPoints[i];
		local isFrontWheel = connectionPoint.z > 0.0;

		if connectionPoint.x >= 0.0 then
			wheelNode.rotation = Quaternion(0.0, 0.0, -90.0);
		else
			wheelNode.rotation = Quaternion(0.0, 0.0, 90.0);
		end

		wheelNode.worldPosition = node.worldPosition + node.worldRotation * connectionPoint;
		wheelNode.scale = Vector3(1.0, 0.65, 1.0);

		raycastVehicle:AddWheel(wheelNode, wheelDirection, wheelAxle, self.suspensionRestLength, self.wheelRadius, isFrontWheel);
		raycastVehicle:SetWheelSuspensionStiffness(i - 1, self.suspensionStiffness);
		raycastVehicle:SetWheelDampingRelaxation(i - 1, self.suspensionDamping);
		raycastVehicle:SetWheelDampingCompression(i - 1, self.suspensionCompression)
		raycastVehicle:SetWheelRollInfluence(i - 1, self.rollInfluence);

		local pWheel = wheelNode:CreateComponent("StaticModel");
		pWheel.model = cache:GetResource("Model", "Models/Cylinder.mdl");
		pWheel.material = cache:GetResource("Material", "Materials/Stone.xml");
		pWheel.castShadows = true;
	end

	self:PostInit();

	self:SetName();
end

function Vehicle:CreateEmitter(place)
	local emitter = scene_:CreateChild();
	local node = self.node;
	emitter.worldPosition = node.worldPosition + node.worldRotation * place + Vector3(0, -self.wheelRadius, 0);
	local particleEmitter = emitter:CreateComponent("ParticleEmitter");
	particleEmitter.effect = cache:GetResource("ParticleEffect", "Particle/Dust.xml");
	particleEmitter.emitting = false;
	particleEmitter.temporary = true;
	table.insert(self.particleEmitterNodeList, emitter);
end

function Vehicle:CreateEmitters()
	self.particleEmitterNodeList = {};
	local node = self.node;
	local raycastVehicle = node:GetComponent("RaycastVehicle");

	for id = 0, raycastVehicle:GetNumWheels() do
		local connectionPoint = raycastVehicle:GetWheelConnectionPoint(id);
		self:CreateEmitter(connectionPoint);
	end
end

function Vehicle:PostInit()
	local node = self.node;
	local raycastVehicle = node:GetComponent("RaycastVehicle");
	self.hullBody = node:GetComponent("RigidBody");
	self:CreateEmitters();
	raycastVehicle:ResetWheels();
end

function Vehicle:SetName()
	local node = self.node;
	local id = app.scene.player.id;
	local name = app.scene.player.name;

	logDbg("Vehicle:SetName id(" .. id .. "), name(" .. name .. ")");

	local nameNode = node:CreateChild("nameNode");
	nameNode.position = Vector3(0.0, 1.5, 0.0);

	nameText = nameNode:CreateComponent("Text3D");
	nameText.text = id .. "_" .. name;

	nameText:SetFont(cache:GetResource("Font", "Fonts/msyh.ttf"), 24);

	if (id % 3 == 1) then
		nameText.color = Color(1.0, 0.0, 0.0);
	elseif (id % 3 == 2) then
		nameText.color = Color(0.0, 1.0, 0.0);
	else
		nameText.color = Color(0.0, 0.0, 1.0);
	end

	nameText.textEffect = TE_SHADOW;
	nameText.effectColor = Color(0.5, 0.5, 0.5);
	nameText:SetAlignment(HA_CENTER, VA_CENTER);
end

function Vehicle:FixedUpdate(timeStep)
	local node = self.node;
	local newSteering = 0.0;
	local accelerator = 0.0;
	local brake = false;

	if self.controls:IsDown(CTRL_LEFT) then
		newSteering = -1.0;
	end

	if self.controls:IsDown(CTRL_RIGHT) then
		newSteering = 1.0;
	end

	if self.controls:IsDown(CTRL_FORWARD) then
		accelerator = 1.0;
	end

	if self.controls:IsDown(CTRL_BACK) then
		accelerator = -0.5;
	end

	if self.controls:IsDown(CTRL_BRAKE) then
		brake = true;
	end

	if newSteering ~= 0.0 then
		self.steering = self.steering * 0.95 + newSteering * 0.05;
	else
		self.steering = self.steering * 0.8 + newSteering * 0.2;
	end

	local steeringRot = Quaternion(0.0, self.steering * MAX_WHEEL_ANGLE, 0.0);

	local raycastVehicle = node:GetComponent("RaycastVehicle");
	raycastVehicle:SetSteeringValue(0, self.steering);
	raycastVehicle:SetSteeringValue(1, self.steering);
	raycastVehicle:SetEngineForce(2, self.maxEngineForce * accelerator);
	raycastVehicle:SetEngineForce(3, self.maxEngineForce * accelerator);

	for i = 0, raycastVehicle:GetNumWheels() - 1 do
		if brake then
			raycastVehicle:SetBrake(i, self.brakingForce);
		else
			raycastVehicle:SetBrake(i, 0.0);
		end
    end

	if ((newSteering ~= 0.0) or (accelerator ~= 0.0)) then
		local entity = app.libnetwork.player();
		if (entity and (entity.position ~= node.position)) then
			entity.position = node.position;
		end
	end
end

function Vehicle:PostUpdate(timeStep)
end

function Vehicle:SetDir(dir)
	self.steering = dir;
end
