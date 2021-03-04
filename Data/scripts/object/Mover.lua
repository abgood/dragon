require "scripts/libs/Base"
require "scripts/network/Dbg"
require "scripts/app"

Mover = ScriptObject();

function Mover:Start()
	self.moveSpeed = 0.0;
	self.rotationSpeed = 0.0;
	self.bounds = BoundingBox();
end

function Mover:SetParameters(moveSpeed, rotationSpeed, bounds)
	self.moveSpeed = moveSpeed;
	self.rotationSpeed = rotationSpeed;
	self.bounds = bounds;
end

function Mover:Update(timeStep)
	local node = self.node;
	node:Translate(Vector3(0.0, 0.0, 1.0) * self.moveSpeed * timeStep);

	local pos = node.position;
	local bounds = self.bounds;
	if pos.x < bounds.min.x or pos.x > bounds.max.x or pos.z < bounds.min.z or pos.z > bounds.max.z then
		node:Yaw(self.rotationSpeed * timeStep);
	end

	local model = node:GetComponent("AnimatedModel", true);
	local state = model:GetAnimationState(0);
	if (state ~= nil) then
		state:AddTime(timeStep);
	end

	local terrainNode = scene_:GetChild("Terrain");
	local terrain = terrainNode:GetComponent("Terrain");

	local position = Vector3(pos.x, 0.0, pos.z);
	position.y = terrain:GetHeight(position);
	node.position = position;
end
