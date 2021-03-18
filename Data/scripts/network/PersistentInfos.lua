--	持久化引擎协议，在检测到协议版本发生改变时会清理协议


require "scripts/network/Dbg"


KBEngineLua.PersistentInfos = {}

function KBEngineLua.PersistentInfos:New( path )
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me._persistentDataPath = path;
	me._digest = "";

	me._isGood = me:loadAll();

	return me;
end

function KBEngineLua.PersistentInfos:isGood()
	return self._isGood;
end

function KBEngineLua.PersistentInfos:_getSuffixBase()
	local clientVersion, clientScriptVersion, ip, port = KBEngineLua.GetArgs();
	return clientVersion .. "_" .. clientScriptVersion .. "_" .. ip .. "_" .. port;
end

function KBEngineLua.PersistentInfos:_getSuffix()
	return self._digest .. "_" .. self:_getSuffixBase();
end

function KBEngineLua.PersistentInfos:loadFileToStream(fileName)
	local stream = VectorBuffer();

	if (fileName.empty) then
		return stream;
	end

	if (not fileSystem:FileExists(fileName)) then
		return stream;
	end

	fp = File(fileName, FILE_READ);
	if (fp.open) then
		while(not fp.eof)
		do
			byte = fp:ReadByte();
			stream:WriteByte(byte);
		end

		stream:Seek(0);

		fp:Close();
	end

	return stream;
end

function KBEngineLua.PersistentInfos:loadFileToString(fileName)
	infos = "";

	if (fileName.empty) then
		return infos;
	end

	if (not fileSystem:FileExists(fileName)) then
		return infos;
	end

	fp = File(fileName, FILE_READ);
	if (fp.open) then
		while(not fp.eof)
		do
			infos = infos .. fp:ReadLine();
		end

		fp:Close();
	end

	return infos;
end

function KBEngineLua.PersistentInfos:saveFileByStream(fileName, stream)
	fileSystem:Delete(fileName);

	fp = File(fileName, FILE_WRITE);
	if (fp.open) then
		stream:Seek(0);

		while(not stream:IsEof())
		do
			byte = stream:ReadByte();
			fp:WriteByte(byte);
		end

		stream:Seek(0);

		fp:Close();
	end
end

function KBEngineLua.PersistentInfos:saveFileByString(fileName, infos)
	fileSystem:Delete(fileName);

	fp = File(fileName, FILE_WRITE);
	if (fp.open) then
		fp:WriteLine(infos);
		fp:Close();
	end
end

function KBEngineLua.PersistentInfos:loadAll()
	local kbengine_digest = self:loadFileToString(self._persistentDataPath .. "kbengine.digest_" .. self:_getSuffixBase());
	if(#kbengine_digest <= 0) then
		self:clearMessageFiles();
		return false;
	end

	self._digest = kbengine_digest;

	local loginapp_onImportClientMessages = self:loadFileToStream(self._persistentDataPath .. "loginapp_clientMessages_" .. self:_getSuffix());

	local baseapp_onImportClientMessages = self:loadFileToStream(self._persistentDataPath .. "baseapp_clientMessages_" .. self:_getSuffix());

	local onImportServerErrorsDescr = self:loadFileToStream(self._persistentDataPath .. "serverErrorsDescr_" .. self:_getSuffix());

	local onImportClientEntityDef = self:loadFileToStream(self._persistentDataPath .. "clientEntityDef_" .. self:_getSuffix());

	if(loginapp_onImportClientMessages.size > 0 and baseapp_onImportClientMessages.size > 0) then
		local re = KBEngineLua.importMessagesFromVectorBuffer(loginapp_onImportClientMessages, baseapp_onImportClientMessages, onImportClientEntityDef, onImportServerErrorsDescr);
		if (not re) then
			self:clearMessageFiles();
			return false;
		end
	end

	return true;
end

function KBEngineLua.PersistentInfos:onImportClientMessages(currserver, stream)
	if(currserver == "loginapp") then
		self:saveFileByStream(self._persistentDataPath .. "loginapp_clientMessages_" .. self:_getSuffix(), stream);
	else
		self:saveFileByStream(self._persistentDataPath .. "baseapp_clientMessages_" .. self:_getSuffix(), stream);
	end
end

function KBEngineLua.PersistentInfos:onImportServerErrorsDescr(stream)
	self:saveFileByStream(self._persistentDataPath .. "serverErrorsDescr_" .. self:_getSuffix(), stream);
end

function KBEngineLua.PersistentInfos:onImportClientEntityDef(stream)
	self:saveFileByStream(self._persistentDataPath .. "clientEntityDef_" .. self:_getSuffix(), stream);
end

function KBEngineLua.PersistentInfos:onVersionNotMatch(verInfo, serVerInfo)
	self:clearMessageFiles();
end

function KBEngineLua.PersistentInfos:onScriptVersionNotMatch(verInfo, serVerInfo)
	self:clearMessageFiles();
end

function KBEngineLua.PersistentInfos:onServerDigest(currserver, serverProtocolMD5, serverEntitydefMD5)
	-- 我们不需要检查网关的协议， 因为登录loginapp时如果协议有问题已经删除了旧的协议
	if(currserver == "baseapp") then
		return;
	end

	if(self._digest ~= serverProtocolMD5 .. serverEntitydefMD5) then
		self._digest = serverProtocolMD5 .. serverEntitydefMD5;
		self:clearMessageFiles();
	else
		return;
	end

	self:saveFileByString(self._persistentDataPath .. "kbengine.digest_" .. self:_getSuffixBase(), serverProtocolMD5 .. serverEntitydefMD5);
end

function KBEngineLua.PersistentInfos:clearMessageFiles()
	fileSystem:Delete(self._persistentDataPath .. "kbengine.digest_" .. self:_getSuffixBase());
	fileSystem:Delete(self._persistentDataPath .. "loginapp_clientMessages_" .. self:_getSuffix());
	fileSystem:Delete(self._persistentDataPath .. "baseapp_clientMessages_" .. self:_getSuffix());
	fileSystem:Delete(self._persistentDataPath .. "serverErrorsDescr_" .. self:_getSuffix());
	fileSystem:Delete(self._persistentDataPath .. "clientEntityDef_" .. self:_getSuffix());
end
