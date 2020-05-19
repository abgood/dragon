require "scripts/network/Dbg"

local game = require 'game.game'
local libnetwork = require 'network.KBEngine'
local login = require 'login.login'
local scene = require 'scene.scene'

local event = {}
setmetatable(event, event)

local mt = {}

event.__index = mt

--- 继承game
setmetatable(mt, game)

mt.id = 'l_0001'
mt.type = 'event'
mt.name = 'event'


function event.init()
	logInfo(event:get_type() .. " init");
	installEvents()
end

function installEvents()
	libnetwork.Event.AddListener("onLoginSuccessfully", login.onLoginSuccessfully);
	libnetwork.Event.AddListener("onReqAvatarList", login.onReqAvatarList);
	libnetwork.Event.AddListener("onCreateAvatarResult", login.onCreateAvatarResult);

	libnetwork.Event.AddListener("set_direction", scene.set_direction);
	libnetwork.Event.AddListener("set_position", scene.set_position);
	libnetwork.Event.AddListener("onEnterWorld", scene.onEnterWorld);
	libnetwork.Event.AddListener("addSpaceGeometryMapping", scene.addSpaceGeometryMapping);
end

function event.uninstallEvents()
	libnetwork.Event.RemoveListener("onLoginSuccessfully", login.onLoginSuccessfully);
	libnetwork.Event.RemoveListener("onReqAvatarList", login.onReqAvatarList);

	libnetwork.Event.RemoveListener("set_direction", scene.set_direction);
	libnetwork.Event.RemoveListener("set_position", scene.set_position);
	libnetwork.Event.RemoveListener("onEnterWorld", scene.onEnterWorld);
	libnetwork.Event.RemoveListener("addSpaceGeometryMapping", scene.addSpaceGeometryMapping);
end


return event
