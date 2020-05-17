
local game = {}
setmetatable(game, game)

local mt = {}

game.__index = mt

mt.id = 'g_0001'
mt.type = 'game'
mt.name = 'baidu_0001'

function mt:get_id()
	return self.id
end

function mt:get_type()
	return self.type
end

function mt:get_name()
	return self.name
end

function game.init()
end

return game
