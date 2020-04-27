-----------------------------------------------------------------------------------------
--												bundle
-----------------------------------------------------------------------------------------*/
KBEngineLua.Bundle = {}

function KBEngineLua.Bundle:New()
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me.streamList = {};
	me.stream = VectorBuffer();
	me.numMessage = 0;
	me.messageLength = 0;	
	me.msgtype = nil;

    return me;
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:newMessage(mt)
	self:fini(false);
	
	self.msgtype = mt;
	self.numMessage = self.numMessage + 1;

	self:writeUint16(self.msgtype.id);

	if (self.msgtype.msglen == -1) then
		table.insert(self.streamList, self.stream);
		self.stream = VectorBuffer();
		self.numMessage = self.numMessage + 1;
	end

	self.messageLength = 0;
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:writeMsgLength()
	local stream = self.streamList[1];
	stream:WriteUShort(self.messageLength);
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:fini(issend)
	if(self.numMessage > 0) then
		if (self.msgtype.msglen == -1) then
			self:writeMsgLength();
		end
		table.insert(self.streamList, self.stream);
		self.stream = VectorBuffer();
	end
	
	if issend then
		self.numMessage = 0;
		self.msgtype = nil;
	end
end

function KBEngineLua.Bundle:send()
	local networkInterface = KBEngineLua._networkInterface;
	
	logInfo("KBEngineLua network data send [C2S], msgid: " .. self.msgtype.id .. ", length: " .. self.messageLength);

	self:fini(true);
	
	if(networkInterface.serverConnection:IsConnected()) then
		for i = 1, #self.streamList, 1 do
			self.stream = self.streamList[i];
			logInfo("Bundle::send: packet length: " .. self.stream.size);
			networkInterface.serverConnection:SendMessage(0, true, true, self.stream);
		end
	else
		logInfo("Bundle::send: networkInterface invalid!");  
	end
	
	self.streamList = {};
	self.stream:Clear();
end

function KBEngineLua.Bundle:checkStream(v)
	self.messageLength = self.messageLength + v;
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:writeInt8(v)
	self:checkStream(1);
	self.stream:WriteByte(v);
end

function KBEngineLua.Bundle:writeInt16(v)
	self:checkStream(2);
	self.stream:WriteShort(v);
end
	
function KBEngineLua.Bundle:writeInt32(v)
	self:checkStream(4);
	self.stream:WriteInt(v);
end

function KBEngineLua.Bundle:writeInt64(v)
	self:checkStream(8);
	self.stream:WriteInt64(v);
end

function KBEngineLua.Bundle:writeUint8(v)
	self:checkStream(1);
	self.stream:WriteUByte(v);
end

function KBEngineLua.Bundle:writeUint16(v)
	self:checkStream(2);
	self.stream:WriteUShort(v);
end
	
function KBEngineLua.Bundle:writeUint32(v)
	self:checkStream(4);
	self.stream:WriteUInt(v);
end

function KBEngineLua.Bundle:writeUint64(v)
	self:checkStream(8);
	self.stream:WriteUInt64(v);
end

function KBEngineLua.Bundle:writeFloat(v)
	self:checkStream(4);
	self.stream:WriteFloat(v);
end

function KBEngineLua.Bundle:writeDouble(v)
	self:checkStream(8);
	self.stream:WriteDouble(v);
end

function KBEngineLua.Bundle:writeString(v)
	self:checkStream(string.len(v) + 1);
	self.stream:WriteString(v);
end

function KBEngineLua.Bundle:writeStringToStream(v)
	self:checkStream(string.len(v));
	for i = 1, string.len(v) do
		char = string.sub(v, i, i);
		self.stream:WriteUByte(char);
	end
end

function KBEngineLua.Bundle:writeBlob(v)
	if type(v) == "string" then
		self:writeUint32(#v);
		if #v > 0 then
			self:writeStringToStream(v);
		end
	else
		self:writeUint32(v.size);
		if v.size > 0 then
			self:checkStream(v.size);
			self.stream:SetData(v, v.size);
		end
	end
end
