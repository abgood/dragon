
require "scripts/network/Dbg"
require "scripts/app"

login.reset_password = {};

login.reset_password.New = function(self, me)
	me = me or {};
	setmetatable(me, self);
	self.__index = self;
    return me;  
end

login.reset_password.init = function(self)
	logInfo("reset_password init");
	self:reset_password_UI();
end

login.reset_password.reset_password_UI = function(self)
	logInfo("show reset_password ui");

	local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/reset_password.xml"));
	ui.root:AddChild(layoutRoot);

	local button = layoutRoot:GetChild("resetPasswordBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.reset_password.request_reset_password");
	end

	local button = layoutRoot:GetChild("returnLoginBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.reset_password.showLoginUIByCreatePlayerUI");
	end
end

login.reset_password.showLoginUIByCreatePlayerUI = function(self, eventType, eventData)
	login.reset_password.show_reset_password_UI(false);
	login.showLoginUI(true);
end

login.reset_password.show_reset_password_UI = function(self, flag)
    local resetPasswordUI = ui.root:GetChild("resetPasswordUI");
	resetPasswordUI:SetVisible(flag);
end

login.reset_password.request_reset_password = function(self, eventType, eventData)
	local layoutRoot = ui.root:GetChild("resetPasswordUI")
    local userEdit = layoutRoot:GetChild("user_edit", true)

	user = userEdit.text;
	logDbg("request reset_password: " .. "account_name(" .. user .. ")");

	if (#user <= 0) then
		logInfo("please input username");
		return;
	end

	app.libnetwork.resetPassword(user);
end
