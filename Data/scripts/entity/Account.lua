
require "scripts/network/Entity"


KBEngineLua.Account = {}

function KBEngineLua.Account:New()
	setmetatable(self, KBEngineLua.Entity)

	me = me or {};
	me = KBEngineLua.Entity:New(me);
	setmetatable(me, self);

	self.__index = self;

    return me;
end

function KBEngineLua.Account:__init__()
	print ("lj Account __init__");
	self.avatars = {};

	KBEngineLua.Event.Brocast("onLoginSuccessfully", KBEngineLua.entity_uuid, KBEngineLua.entity_id, KBEngineLua);

	self:baseCall("reqAvatarList");
end

function KBEngineLua.Account:onCreateAvatarResult(retcode, info)
	print ("lj onCreateAvatarResult", retcode, info);
	if (retcode == 0) then
		dbid = info["dbid"];
		self.avatars[dbid] = info;
		table.insert(self.avatars["values"], info);
	end

	KBEngineLua.Event.Brocast("onCreateAvatarResult", retcode, info, self.avatars);
end

function KBEngineLua.Account:onRemoveAvatar(dbid)
	print ("lj onRemoveAvatar", dbid);
end

function KBEngineLua.Account:onReqAvatarList(infos)
	print ("lj onReqAvatarList", infos);
	self.avatars = infos;

	KBEngineLua.Event.Brocast("onReqAvatarList", self.avatars);
end

function KBEngineLua.Account:reqCreateAvatar(roleType, name)
	print ('lj reqCreateAvatar', roleType, name);
	self:baseCall("reqCreateAvatar", roleType, name);
end

function KBEngineLua.Account:selectAvatarGame(dbid)
	print ('lj selectAvatarGame', dbid);
	self:baseCall("selectAvatarGame", dbid);
end
