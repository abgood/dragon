require "scripts/network/Dbg"

local game = require 'game.game'
local libnetwork = require 'network.KBEngine'

local login = {}
setmetatable(login, login)

local mt = {}

login.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'login'
mt.name = 'login'



function login.init()
	print("login init")
	createLoginUI()
end

function login.onLoginSuccessfully()
	logInfo("Login is successfully!(登陆成功!)");

	showLoginUI(false);

    local enterUI = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/enter.xml"))
    ui.root:AddChild(enterUI)

	-- showEnterUI(true);

	coroutine.start(setbar)
end

function login.onReqAvatarList(avatars)
	value = avatars["values"];
	logInfo("login.onReqAvatarList num: " .. #value);

	if (#value <= 0) then
		showCreatePlayerUI(true)
	else
		showPlayerInfoUI(value[1]);
	end
end

function login.onCreateAvatarResult(retcode, info, avatars)
	logInfo("login.onCreateAvatarResult: retcode(" .. info["dbid"] .. "), " .. "name(" .. info["name"] .. "), " .. "roleType(" .. info["roleType"] .. "), " .. "level(" .. info["level"] .. "), ");
	if (retcode == 0) then
		showCreatePlayerUI(false)
		libnetwork.player():selectAvatarGame(info["dbid"]);
	end
end

function showCreatePlayerUI(flag)
	if flag then
		libnetwork.player():reqCreateAvatar(1, "june");
	end
end

function showPlayerInfoUI(info)
end

function setbar()
    local enterUI = ui.root:GetChild("enterUI");
	for i = 1, enterUI.range do
		enterUI:ChangeValue(1);
		coroutine.sleep(0.1)
	end
end

function createLoginUI()
	print("create login ui")
    local style = cache:GetResource("XMLFile", "UI/DefaultStyle.xml")
    ui.root.defaultStyle = style

    local cursor = ui.root:CreateChild("Cursor")
    cursor:SetStyleAuto()
    ui.cursor = cursor
    cursor:SetPosition(graphics.width / 2, graphics.height / 2)

    local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/login.xml"))
    ui.root:AddChild(layoutRoot)

	showLoginUI(true)

    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)
	pawdEdit.echoCharacter = 42

    local button = layoutRoot:GetChild("loginBtn", true)
    if button ~= nil then
        SubscribeToEvent(button, "Released", "requestLogin")
    end

	showLoginUI(false)
	libnetwork.login("119", "456", "789")
end

function showLoginUI(flag)
    local loginUI = ui.root:GetChild("loginUI");
	loginUI:SetVisible(flag);
end

function showEnterUI(flag)
    local enterUI = ui.root:GetChild("enterUI");
	enterUI:SetVisible(flag);
    enterUI:SetWidth(ui.root.width);
	enterUI.value = 0;
	enterUI.range = 100;
    SubscribeToEvent(enterUI, "ProgressBarChanged", "changeScrollBar")
end

function requestLogin(eventType, eventData)
	print ("request login");
	layoutRoot = ui.root:GetChild("layout")
    local userEdit = layoutRoot:GetChild("user_edit", true)
    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)
	print ("lj input", userEdit.text, pawdEdit.text)
	user = userEdit.text;
	pawd = pawdEdit.text;
	libnetwork.login(user, pawd)
end

function changeScrollBar(eventType, eventData)
    local enterUI = eventData["Element"]:GetPtr("UIElement")
    local value = eventData["Value"]:GetFloat()

	if (value == enterUI.range) then
		showEnterUI(false);
	end
end


return login
