
KBEngineLua.EntityCall = {}


function KBEngineLua.EntityCall:New()
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me.id = 0;
	me.className = "";
	me.type = 0;
	me.bundle = nil;

    return me;
end

function KBEngineLua.EntityCall:isBase( )
	return self.type == 1;
end

function KBEngineLua.EntityCall:isCell( )
	return self.type == 0;
end

function KBEngineLua.EntityCall:newCall()

	if(self.bundle == nil) then
		self.bundle = KBEngineLua.Bundle:New();
	end

	if(self.type == 0) then
		self.bundle:newMessage(KBEngineLua.messages["Baseapp_onRemoteCallCellMethodFromClient"]);
	else
		self.bundle:newMessage(KBEngineLua.messages["Entity_onRemoteMethodCall"]);
	end

	self.bundle:writeInt32(self.id);

	return self.bundle;
end

function KBEngineLua.EntityCall:sendCall(inbundle)

	if(inbundle == nil) then
		inbundle = self.bundle;
	end

	inbundle:send();

	if(inbundle == self.bundle) then
		self.bundle = nil;
	end
end
