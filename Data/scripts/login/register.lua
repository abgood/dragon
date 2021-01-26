
require "scripts/network/Dbg"

login.register = {};

login.register.New = function(self, me)
	me = me or {};
	setmetatable(me, self);
	self.__index = self;
    return me;  
end

login.register.init = function(self)
	logInfo("register init");
	self:createRegisterUI();
end

login.register.createRegisterUI = function(self)
	logInfo("show register ui");

	local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/register.xml"));
	ui.root:AddChild(layoutRoot);

    local pawdEdit = layoutRoot:GetChild("pawd_edit", true);
	pawdEdit.echoCharacter = 42;

	local button = layoutRoot:GetChild("registerBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.register.requestRegister");
	end

	local button = layoutRoot:GetChild("returnLoginBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.register.showLoginUIByRegisterUI");
	end
end

login.register.showLoginUIByRegisterUI = function(self, eventType, eventData)
	login.register.showRegisterUI(false);
	login.showLoginUI(true);
end

login.register.showRegisterUI = function(self, flag)
    local registerUI = ui.root:GetChild("registerUI");
	registerUI:SetVisible(flag);
end

login.register.requestRegister = function(self, eventType, eventData)
	local layoutRoot = ui.root:GetChild("registerUI")
    local userEdit = layoutRoot:GetChild("user_edit", true)
    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)

	user = userEdit.text;
	pawd = pawdEdit.text;
	logDbg("request register: " .. "username(" .. user .. "), " .. "password(" .. pawd .. ")")

	if (#user <= 0) then
		logInfo("please input username");
		return;
	end
	if (#pawd <= 0) then
		logInfo("please input password");
		return;
	end

	login.libnetwork.createAccount(user, pawd, "kbengine_urho3d_demo");
end
