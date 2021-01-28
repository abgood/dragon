
require "scripts/network/Dbg"
require "scripts/app"

login.input_password = {};

login.input_password.New = function(self, me)
	me = me or {};
	setmetatable(me, self);
	self.__index = self;
    return me;  
end

login.input_password.init = function(self)
	logInfo("input_password init");
	self:input_password_UI();
end

login.input_password.input_password_UI = function(self)
	logInfo("show input_password ui");

	local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/input_password.xml"));
	ui.root:AddChild(layoutRoot);

    local old_password_edit = layoutRoot:GetChild("old_password_edit", true);
	old_password_edit.echoCharacter = 42;

    local new_password_edit = layoutRoot:GetChild("new_password_edit", true);
	new_password_edit.echoCharacter = 42;

	local button = layoutRoot:GetChild("inputPasswordBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.input_password.request_input_password");
	end

	local button = layoutRoot:GetChild("returnLoginBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.input_password.showLoginUIByInputPasswordUI");
	end
end

login.input_password.showLoginUIByInputPasswordUI = function(self, eventType, eventData)
	login.input_password.show_input_password_UI(false);
	login.showLoginUI(true);
end

login.input_password.show_input_password_UI = function(self, flag)
    local inputPasswordUI = ui.root:GetChild("inputPasswordUI");
	inputPasswordUI:SetVisible(flag);
end

login.input_password.request_input_password = function(self, eventType, eventData)
	local layoutRoot = ui.root:GetChild("inputPasswordUI");
	local old_password_edit = layoutRoot:GetChild("old_password_edit", true);
	local new_password_edit = layoutRoot:GetChild("new_password_edit", true);

	old_password = old_password_edit.text;
	new_password = new_password_edit.text;

	if (#old_password <= 0) then
		logInfo("please input old password edit");
		return;
	end

	if (#new_password <= 0) then
		logInfo("please input new password edit");
		return;
	end

	app.libnetwork.newPassword(old_password, new_password);
end
