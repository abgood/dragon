
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
end

return login
