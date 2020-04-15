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

	if(self.msgtype.msglen ~= -1) then
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

	-- num = self:twoByteEndian(self.messageLength);
	num = self.messageLength;
	stream:WriteUShort(num);
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
	-- v = self:twoByteEndian(v);
	self.stream:WriteShort(v);
end
	
function KBEngineLua.Bundle:writeInt32(v)
	self:checkStream(4);
	-- v = self:fourByteEndian(v);
	self.stream:WriteInt(v);
end

function KBEngineLua.Bundle:writeInt64(v)
	self:checkStream(8);
	-- v = self:eightByteEndian(v);
	self.stream:WriteInt64(v);
end

function KBEngineLua.Bundle:writeUint8(v)
	self:checkStream(1);
	self.stream:WriteUint8(v);
end

function KBEngineLua.Bundle:writeUint16(v)
	self:checkStream(2);
	-- v = self:twoByteEndian(v);
	self.stream:WriteUShort(v);
end
	
function KBEngineLua.Bundle:writeUint32(v)
	self:checkStream(4);
	-- v = self:fourByteEndian(v);
	self.stream:WriteUint(v);
end

function KBEngineLua.Bundle:writeUint64(v)
	self:checkStream(8);
	-- v = self:eightByteEndian(v);
	self.stream:WriteUint64(v);
end

function KBEngineLua.Bundle:writeFloat(v)
	self:checkStream(4);
	self.stream:WriteFloat(v);
end

function KBEngineLua.Bundle:writeDouble(v)
	self:checkStream(8);
	-- v = self:eightByteEndian(v);
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

function KBEngineLua.Bundle:twoByteEndian(v)
	v1 = bit.band(bit.lshift(v, 8), 0xff00);
	v2 = bit.band(bit.rshift(v, 8), 0x00ff);
	n = bit.bor(v1, v2);
	return n;
end

function KBEngineLua.Bundle:fourByteEndian(v)
	v1 = bit.band(bit.rshift(v, 16), 0xffff);
	v2 = bit.band(v, 0xffff);

	v3 = self:twoByteEndian(v1);
	v4 = self:twoByteEndian(v2);

	v5 = bit.band(v3, 0xffff0000);
	v6 = bit.band(v4, 0x0000ffff);

	n = bit.bor(v1, v2);
	return n;
end

function KBEngineLua.Bundle:eightByteEndian(v)
	v1 = bit.band(bit.rshift(v, 32), 0xffffffff);
	v2 = bit.band(v, 0xffffffff);

	v3 = self:fourByteEndian(v1);
	v4 = self:fourByteEndian(v2);

	v5 = bit.band(v3, 0xffffffff00000000);
	v6 = bit.band(v4, 0x00000000ffffffff);

	n = bit.bor(v1, v2);
	return n;
end
