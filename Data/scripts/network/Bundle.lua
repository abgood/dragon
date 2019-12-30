require "bit"
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
	me._curMsgStreamIndex = 0;

    return me;
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:newMessage(mt)
	self:fini(false);
	
	self.msgtype = mt;
	self.numMessage = self.numMessage + 1;

	self:writeUint16(self.msgtype.id);
	
	if(self.msgtype.msglen == -1) then
		self:writeUint16(0);
		self.messageLength = 0;
	end

	self._curMsgStreamIndex = 0;
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:writeMsgLength()

	if(self.msgtype.msglen ~= -1) then
		return;
	end

	local stream = self.stream;
	if(self._curMsgStreamIndex > 0) then
		idx = #self.streamList - self._curMsgStreamIndex;
		idx = math.max(1, idx);
		stream = self.streamList[idx];
	end

	stream:writeUint16(self.messageLength);
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:fini(issend)
	if(self.numMessage > 0) then
		if (self.msgtype.msglen ~= -1) then
			self:writeMsgLength();
		end
		table.insert(self.streamList, self.stream);
		self.stream = VectorBuffer();
	end
	
	if issend then
		self.numMessage = 0;
		self.msgtype = nil;
	end

	self._curMsgStreamIndex = 0;
end

function KBEngineLua.Bundle:send()
	local networkInterface = KBEngineLua._networkInterface;
	
	self:fini(true);
	
	if(networkInterface.serverConnection:IsConnected()) then
		for i = 1, #self.streamList, 1 do
			self.stream = self.streamList[i];
			print ("lj sendmsg", self.stream, self.stream:GetSize());
			networkInterface.serverConnection:SendMessage(0, true, true, self.stream);
		end
	else
		logInfo("Bundle::send: networkInterface invalid!");  
	end
	
	self.streamList = {};
	self.stream:Clear();
end

function KBEngineLua.Bundle:checkStream(v)
	if(self.stream:GetSize() > 0 and v > self.stream:GetSize()) then
		table.insert(self.streamList, self.stream);
		self.stream = VectorBuffer();
		self._curMsgStreamIndex = self._curMsgStreamIndex + 1;
	end
	self.messageLength = self.messageLength + v;
end

---------------------------------------------------------------------------------
function KBEngineLua.Bundle:writeInt8(v)
	self:checkStream(1);
	self.stream:WriteInt8(v);
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
	self.stream:WriteUint8(v);
end

function KBEngineLua.Bundle:writeUint16(v)
	self:checkStream(2);
	self.stream:WriteUShort(v);
end
	
function KBEngineLua.Bundle:writeUint32(v)
	self:checkStream(4);
	self.stream:WriteUint(v);
end

function KBEngineLua.Bundle:writeUint64(v)
	self:checkStream(8);
	self.stream:WriteUint64(v);
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

function KBEngineLua.Bundle:writeBlob(v)
	if #v > 0 then
		self:checkStream(v.Length + 4);
		self.stream:WriteBuffer(v);
	end
end
