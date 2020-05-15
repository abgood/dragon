require "scripts/network/Dbg"

local game = require 'game.game'
local libnetwork = require 'network.KBEngine'

local scene = {}
setmetatable(scene, scene)

local mt = {}

scene.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'scene'
mt.name = 'scene'
mt.entities = {}



function scene.init()
	print("scene init")
end

function scene.set_direction(entity)
	print ("lj set_direction");
end

function scene.set_position(entity)
	print ("lj set_position");
end

function scene.onEnterWorld(entity)
	print ("lj scene onEnterWorld");
end


return scene
