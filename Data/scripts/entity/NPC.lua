
require "scripts/network/Entity"


KBEngineLua.NPC = {}

function KBEngineLua.NPC:New()
	setmetatable(self, KBEngineLua.Entity)

	me = me or {};
	me = KBEngineLua.Entity:New(me);
	setmetatable(me, self);

	self.__index = self;

    return me;
end

function KBEngineLua.NPC:__init__()
	print ("lj NPC __init__");
end
