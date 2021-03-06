
require "scripts/network/Entity"
require "scripts/network/Dbg"


KBEngineLua.Monster = {}

function KBEngineLua.Monster:New()
	setmetatable(self, KBEngineLua.Entity)

	me = me or {};
	me = KBEngineLua.Entity:New(me);
	setmetatable(me, self);

	self.__index = self;

    return me;
end

function KBEngineLua.Monster:__init__()
	logDbg("KBEMonster::__init__");
end

function KBEngineLua.Monster:recvDamage(attackerID, skillID, damageType, damage)
	print ("lj recvDamage", attackerID, skillID, damageType, damage);
end
