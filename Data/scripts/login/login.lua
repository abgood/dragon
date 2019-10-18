
local game = require 'game.game'

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

function createLoginUI()
	print("create login ui")
    local style = cache:GetResource("XMLFile", "UI/DefaultStyle.xml")
    ui.root.defaultStyle = style

    local cursor = ui.root:CreateChild("Cursor")
    cursor:SetStyleAuto()
    ui.cursor = cursor
    cursor:SetPosition(graphics.width / 2, graphics.height / 2)

    local layoutRoot = ui:LoadLayout(cache:GetResource("XMLFile", "UI/login/login.xml"))
	layoutRoot.name = "layout"
    ui.root:AddChild(layoutRoot)

    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)
	pawdEdit.echoCharacter = 42

    local button = layoutRoot:GetChild("loginBtn", true)
    if button ~= nil then
        SubscribeToEvent(button, "Released", "requestLogin")
    end
end

function requestLogin()
	print ("request login");
	layoutRoot = ui.root:GetChild("layout")
    local userEdit = layoutRoot:GetChild("user_edit", true)
    local pawdEdit = layoutRoot:GetChild("pawd_edit", true)
	print ("lj input", userEdit.text, pawdEdit.text)
end


return login
