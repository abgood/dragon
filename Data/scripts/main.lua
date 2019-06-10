
require "scripts/libs/Base"

function Start()
	BaseStart()

	local game = require 'game.game'
	local login = require 'login.login'

	game.init()
	login.init()
end

function Stop()
end
