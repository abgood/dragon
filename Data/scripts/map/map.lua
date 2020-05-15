require "scripts/network/Dbg"

local game = require 'game.game'
local libnetwork = require 'network.KBEngine'

local map = {}
setmetatable(map, map)

local mt = {}

map.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'map'
mt.name = 'map'
mt.entities = {}



function map.init()
	print("map init")
end


return map
