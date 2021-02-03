
require "scripts/network/Dbg"
require "scripts/app"

login.create_player = {};

login.create_player.New = function(self, me)
	me = me or {};
	setmetatable(me, self);
	self.__index = self;
    return me;  
end

login.create_player.init = function(self)
	logInfo("create_player init");
	self:create_player_UI();
end

login.create_player.create_player_UI = function(self)
	logInfo("show create_player ui");

	local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/create_player.xml"));
	ui.root:AddChild(layoutRoot);

	local userEdit = layoutRoot:GetChild("user_edit", true);
	userEdit:SetFocus(true);
	local button = layoutRoot:GetChild("createPlayerBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.create_player.request_create_player");
	end

	local button = layoutRoot:GetChild("returnLoginBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.create_player.showLoginUIByCreatePlayerUI");
	end
end

login.create_player.showLoginUIByCreatePlayerUI = function(self, eventType, eventData)
	login.create_player.show_create_player_UI(false);
	login.showLoginUI(true);
end

login.create_player.show_create_player_UI = function(self, flag)
	local createPlayerUI = ui.root:GetChild("createPlayerUI");
	createPlayerUI:SetVisible(flag);

	if (not flag) then
		app.libnetwork.Event.RemoveListener("HandleCreatePlayerReturnKeyUp", app.login.addCreatePlayerHandleReturnKeyUp);
	end
end

login.create_player.is_show = function()
	local flag = false;

	local createPlayerUI = ui.root:GetChild("createPlayerUI");
	if (createPlayerUI) then
		flag = createPlayerUI:IsVisible();
	end
	return flag;
end

login.create_player.HandleReturnKeyUp = function(eventType, eventData)
	login.create_player.request_create_player(eventType, eventData);
end

login.create_player.request_create_player = function(self, eventType, eventData)
	local layoutRoot = ui.root:GetChild("createPlayerUI")
    local userEdit = layoutRoot:GetChild("user_edit", true)

	user = userEdit.text;
	logDbg("request create_player: " .. "account_name(" .. user .. ")");

	if (#user <= 0) then
		logInfo("please input username");
		return;
	end

	app.libnetwork.player():reqCreateAvatar(1, user);
end
