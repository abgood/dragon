
require "scripts/network/Entity"
require "scripts/network/Dbg"


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
	logDbg("KBEAccount::__init__");
	self.avatars = {};

	KBEngineLua.Event.Brocast("onLoginSuccessfully", KBEngineLua.entity_uuid, self.id, self);

	self:baseCall("reqAvatarList");
end

function KBEngineLua.Account:onCreateAvatarResult(retcode, info)
	logDbg("KBEAccount::onCreateAvatarResult: " .. retcode);
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
	logDbg("KBEAccount::onReqAvatarList");
	self.avatars = infos;

	logDbg("KBEAccount::onReqAvatarList: avatarsize = " .. #self.avatars["values"]);

	for k, v in ipairs(self.avatars["values"]) do
		logDbg("KBEAccount::onReqAvatarList: name_" .. k .. " = (" .. v["name"] .. ")");
	end

	KBEngineLua.Event.Brocast("onReqAvatarList", self.avatars);
end

function KBEngineLua.Account:reqCreateAvatar(roleType, name)
	logDbg("KBEAccount::reqCreateAvatar roleType: " .. roleType .. ", name: " .. name);
	self:baseCall("reqCreateAvatar", roleType, name);
end

function KBEngineLua.Account:selectAvatarGame(dbid)
	logDbg("KBEAccount::selectAvatarGame dbid: " .. dbid);
	self:baseCall("selectAvatarGame", dbid);
end
