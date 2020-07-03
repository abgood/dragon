
Vehicle = ScriptObject();

function Vehicle:Start()
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
end
