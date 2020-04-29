
require "scripts/network/Entity"


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
	print ("lj Avatar __init__");
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
	print ("lj onEnterWorld");
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
