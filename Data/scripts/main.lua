
require "scripts/libs/Base"

function Start()
	BaseStart()

	local game = require 'game.game'
	local network = require 'network.KBEngine'
	local login = require 'login.login'

	game.init()
	network.init()
	login.init()
end

function Stop()
end
