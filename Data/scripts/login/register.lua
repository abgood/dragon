require "scripts/network/Dbg"

local game = require 'scripts/game/game'
local scene = require 'scripts/scene/scene'
local libnetwork = require 'scripts/network/KBEngine'

local register = {}
setmetatable(register, register)

local mt = {}

register.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'register'
mt.name = 'register'


account_id = 2;


function register.init()
	logInfo(register:get_type() .. " init");
	createRegisterUI()
end

function createRegisterUI()
	logInfo("show register ui");

	local style = cache:GetResource("XMLFile", "UI/DefaultStyle.xml")
	ui.root.defaultStyle = style
	
	local cursor = ui.root:CreateChild("Cursor")
	cursor:SetStyleAuto()
	ui.cursor = cursor
	cursor:SetPosition(graphics.width / 2, graphics.height / 2)
	
	local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/register.xml"))
	ui.root:AddChild(layoutRoot)

    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)
	pawdEdit.echoCharacter = 42

	local button = layoutRoot:GetChild("registerBtn", true)
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "requestRegister")
	end

	local button = layoutRoot:GetChild("returnLoginBtn", true)
	if button ~= nil then
	    SubscribeToEvent(button, "Released", "showLoginUIByRegisterUI")
	end
end

function showRegisterUI(flag)
    local registerUI = ui.root:GetChild("registerUI");
	registerUI:SetVisible(flag);
end

function showLoginUIByRegisterUI(eventType, eventData)
	ui.root:RemoveAllChildren();

	local login = require 'scripts/login/login'
	login.init();
end

function requestRegister(eventType, eventData)
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

	libnetwork.createAccount(user, pawd, "kbengine_urho3d_demo");
end


return register
