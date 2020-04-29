
require "scripts/network/Entity"


KBEngineLua.Gate = {}

function KBEngineLua.Gate:New()
	setmetatable(self, KBEngineLua.Entity)

	me = me or {};
	me = KBEngineLua.Entity:New(me);
	setmetatable(me, self);

	self.__index = self;

    return me;
end

function KBEngineLua.Gate:__init__()
	print ("lj Gate __init__");
end
