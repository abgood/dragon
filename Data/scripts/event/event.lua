
event = {}

local this = event;

require "scripts/network/Dbg"
require "scripts/app"

event.init = function()
	logInfo("event init");
	this.installEvents();
end

event.installEvents = function()
	app.libnetwork.Event.AddListener("onLoginSuccessfully", app.login.onLoginSuccessfully);
	app.libnetwork.Event.AddListener("onReqAvatarList", app.login.onReqAvatarList);
	app.libnetwork.Event.AddListener("onCreateAvatarResult", app.login.onCreateAvatarResult);

	app.libnetwork.Event.AddListener("set_direction", app.scene.set_direction);
	app.libnetwork.Event.AddListener("set_position", app.scene.set_position);
	app.libnetwork.Event.AddListener("onEnterWorld", app.scene.onEnterWorld);
	app.libnetwork.Event.AddListener("addSpaceGeometryMapping", app.scene.addSpaceGeometryMapping);
	app.libnetwork.Event.AddListener("onAvatarEnterWorld", app.scene.onAvatarEnterWorld);
end

event.uninstallEvents = function()
	app.libnetwork.Event.RemoveListener("onLoginSuccessfully", app.login.onLoginSuccessfully);
	app.libnetwork.Event.RemoveListener("onReqAvatarList", app.login.onReqAvatarList);

	app.libnetwork.Event.RemoveListener("set_direction", app.scene.set_direction);
	app.libnetwork.Event.RemoveListener("set_position", app.scene.set_position);
	app.libnetwork.Event.RemoveListener("onEnterWorld", app.scene.onEnterWorld);
	app.libnetwork.Event.RemoveListener("addSpaceGeometryMapping", app.scene.addSpaceGeometryMapping);
	app.libnetwork.Event.RemoveListener("onAvatarEnterWorld", app.scene.onAvatarEnterWorld);
end


return event;
