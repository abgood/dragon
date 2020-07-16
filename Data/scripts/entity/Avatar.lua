
require "scripts/libs/Base"
require "scripts/network/Entity"
require "scripts/network/Dbg"


KBEngineLua.Avatar = {}

function KBEngineLua.Avatar:New()
	setmetatable(self, KBEngineLua.Entity)

	me = me or {};
	me = KBEngineLua.Entity:New(me);
	setmetatable(me, self);

	self.__index = self;

    return me;
end

function KBEngineLua.Avatar:__init__()
	logDbg("KBEAvatar::__init__");
end

function KBEngineLua.Avatar:relive(type_id)
	print ("lj relive", type_id);
end

function KBEngineLua.Avatar:useTargetSkill(skillID, targetID)
	print ("lj useTargetSkill", skillID, targetID);
end

function KBEngineLua.Avatar:jump()
	print ("lj jump");
end

function KBEngineLua.Avatar:onJump()
	print ("lj onJump");
end

function KBEngineLua.Avatar:onAddSkill(skillID)
	print ("lj onAddSkill", skillID);
end

function KBEngineLua.Avatar:onRemoveSkill(skillID)
	print ("lj onRemoveSkill", skillID);
end

function KBEngineLua.Avatar:onEnterWorld()
	logInfo("KBEAvatar::onEnterWorld className: " .. self.className .. ", entity id: " .. self.id);
	if (self:isPlayer()) then
		KBEngineLua.Event.Brocast("onAvatarEnterWorld", KBEngineLua.entity_uuid, self.id, self);
		self:cellCall("requestPull");
	end
end

function KBEngineLua.Avatar:dialog_addOption(dialogType, dialogKey, title, extra)
	print ("lj dialog_addOption", dialogType, dialogKey, title, extra);
end

function KBEngineLua.Avatar:dialog_setText(body, isPlayer, headID, sayname)
	print ("lj dialog_setText", body, isPlayer, headID, sayname);
end

function KBEngineLua.Avatar:dialog_close()
	print ("lj dialog_close");
end

function KBEngineLua.Avatar:recvDamage(attackerID, skillID, damageType, damage)
	print ("lj recvDamage", attackerID, skillID, damageType, damage);
end

function KBEngineLua.Avatar:create_avatar()
	logDbg("KBEAvatar::create_avatar");

	self.renderObj = scene_:CreateChild("vehicle");
	self.renderObj.position = Vector3(0.0, 5.0, 0.0);

	local vehicle = self.renderObj:CreateScriptObject("scripts/object/Vehicle.lua", "Vehicle");
	vehicle:Init();

	return self;
end
