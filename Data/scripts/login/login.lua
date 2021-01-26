
login = {};

local this = login;
local register = nil;

require "scripts/network/Dbg"
require "scripts/app"
require "scripts/login/register"

account_id = 3;


login.init = function()
	logInfo("login init");
	this.createLoginUI();
end

login.onLoginSuccessfully = function(rndUUID, eid, accountEntity)
	logInfo("Login is successfully!(登陆成功!)");

	local enterUI = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/enter.xml"));
	ui.root:AddChild(enterUI);

	this.showLoginUI(false);
	this.showEnterUI(true);

	coroutine.start(this.setbar);
end

login.onReqAvatarList = function(avatars)
	value = avatars["values"];

	if (#value <= 0) then
		this.showCreatePlayerUI(true);
	else
		this.showPlayerInfoUI(value[1]);
	end
end

login.onCreateAvatarResult = function(retcode, info, avatars)
	logDbg("login.onCreateAvatarResult: retcode(" .. info["dbid"] .. "), " .. "name(" .. info["name"] .. "), " .. "roleType(" .. info["roleType"] .. "), " .. "level(" .. info["level"] .. "), ");
	if (retcode == 0) then
		this.showCreatePlayerUI(false);
		app.libnetwork.player():selectAvatarGame(info["dbid"]);

		scene.enter_scene();
	end
end

login.showCreatePlayerUI = function(flag)
	if flag then
		app.libnetwork.player():reqCreateAvatar(account_id, "june_" .. tostring(account_id));
	end
end

login.showPlayerInfoUI = function(info)
	logDbg("show player info, dbid:(" .. info["dbid"] .. "), name:(" .. info["name"] .. ")");
	app.libnetwork.player():selectAvatarGame(info["dbid"]);

	scene.enter_scene();
end

login.setbar = function()
    local enterUI = ui.root:GetChild("enterUI");
	for i = 1, enterUI.range do
		enterUI:ChangeValue(1);
		coroutine.sleep(0.1);
	end
end

login.createLoginUI = function()
	logInfo("show login ui");

	local style = cache:GetResource("XMLFile", "UI/DefaultStyle.xml");
	ui.root.defaultStyle = style;
	
	local cursor = ui.root:CreateChild("Cursor");
	cursor:SetStyleAuto();
	ui.cursor = cursor;
	cursor:SetPosition(graphics.width / 2, graphics.height / 2);
	
	local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/login.xml"));
	ui.root:AddChild(layoutRoot);

	this.showLoginUI(true);

    local pawdEdit = layoutRoot:GetChild("pawd_edit", true);
	pawdEdit.echoCharacter = 42;

	local button = layoutRoot:GetChild("loginBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.requestLogin");
	end

	local button = layoutRoot:GetChild("registerBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.showRegisterUI");
	end

	local button = layoutRoot:GetChild("resetBtn", true);
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "login.showResetPasswordrUI");
	end
end

login.requestLogin = function(eventType, eventData)
	local layoutRoot = ui.root:GetChild("loginUI");
    local userEdit = layoutRoot:GetChild("user_edit", true);
    local pawdEdit = layoutRoot:GetChild("pawd_edit", true);

	user = userEdit.text;
	pawd = pawdEdit.text;
	logDbg("request login: " .. "username(" .. user .. "), " .. "password(" .. pawd .. ")");

	if (#user <= 0) then
		logInfo("please input username");
		return;
	end
	if (#pawd <= 0) then
		logInfo("please input password");
		return;
	end

	app.libnetwork.login(user, pawd, "kbengine_urho3d_demo");
end

login.showRegisterUI = function(eventType, eventData)
	this.showLoginUI(false);

	if (register == nil) then
		register = login.register:New();
		register:init();
	else
		register:showRegisterUI(true);
	end
end

login.showResetPasswordrUI = function(eventType, eventData)
	this.showLoginUI(false);
end

login.showLoginUI = function(flag)
    local loginUI = ui.root:GetChild("loginUI");
	loginUI:SetVisible(flag);
end

login.showEnterUI = function(flag)
    local enterUI = ui.root:GetChild("enterUI");
	enterUI:SetVisible(flag);
    enterUI:SetWidth(ui.root.width);
	enterUI.value = 0;
	enterUI.range = 100;
    SubscribeToEvent(enterUI, "ProgressBarChanged", "login.changeScrollBar")
end

login.changeScrollBar = function(eventType, eventData)
	local enterUI = eventData["Element"]:GetPtr("UIElement")
	local value = eventData["Value"]:GetFloat()

	if (value == enterUI.range) then
		this.showEnterUI(false);
	end
end

return login
