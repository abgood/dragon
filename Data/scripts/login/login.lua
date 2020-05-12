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

	showEnterUI(true);

	coroutine.start(setbar)
end

function setbar()
    local enterUI = ui.root:GetChild("enterUI");
	for i = 1, 100 do
		enterUI:ChangeValue(1);
		coroutine.sleep(0.1)

		if (enterUI.value == 100) then
			showEnterUI(false);
			break;
		end
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

	libnetwork.login("123", "456", "789")
end

function showLoginUI(flag)
    local loginUI = ui.root:GetChild("loginUI");
	loginUI:SetVisible(flag);
end

function showEnterUI(flag)
    local enterUI = ui.root:GetChild("enterUI");
	enterUI:SetVisible(flag);
	enterUI:SetValue(0);
	enterUI:SetRange(100);
end

function requestLogin()
	print ("request login");
	layoutRoot = ui.root:GetChild("layout")
    local userEdit = layoutRoot:GetChild("user_edit", true)
    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)
	print ("lj input", userEdit.text, pawdEdit.text)
	user = userEdit.text;
	pawd = pawdEdit.text;
	libnetwork.login(user, pawd)
end


return login
