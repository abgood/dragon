
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
	app.libnetwork.Event.AddListener("onCreateAccountResult", app.login.onCreateAccountResult);
	app.libnetwork.Event.AddListener("onResetPassword", app.login.onResetPassword);

	app.libnetwork.Event.AddListener("set_direction", app.scene.set_direction);
	app.libnetwork.Event.AddListener("set_position", app.scene.set_position);
	app.libnetwork.Event.AddListener("onEnterWorld", app.scene.onEnterWorld);
	app.libnetwork.Event.AddListener("addSpaceGeometryMapping", app.scene.addSpaceGeometryMapping);
	app.libnetwork.Event.AddListener("onAvatarEnterWorld", app.scene.onAvatarEnterWorld);

	app.libnetwork.Event.AddListener("HandleReturnKeyUp", event.HandleReturnKeyUp);
end

event.uninstallEvents = function()
	app.libnetwork.Event.RemoveListener("onLoginSuccessfully", app.login.onLoginSuccessfully);
	app.libnetwork.Event.RemoveListener("onReqAvatarList", app.login.onReqAvatarList);
	app.libnetwork.Event.RemoveListener("onCreateAvatarResult", app.login.onCreateAvatarResult);
	app.libnetwork.Event.RemoveListener("onCreateAccountResult", app.login.onCreateAccountResult);
	app.libnetwork.Event.RemoveListener("onResetPassword", app.login.onResetPassword);

	app.libnetwork.Event.RemoveListener("set_direction", app.scene.set_direction);
	app.libnetwork.Event.RemoveListener("set_position", app.scene.set_position);
	app.libnetwork.Event.RemoveListener("onEnterWorld", app.scene.onEnterWorld);
	app.libnetwork.Event.RemoveListener("addSpaceGeometryMapping", app.scene.addSpaceGeometryMapping);
	app.libnetwork.Event.RemoveListener("onAvatarEnterWorld", app.scene.onAvatarEnterWorld);

	app.libnetwork.Event.RemoveListener("HandleReturnKeyUp", event.HandleReturnKeyUp);
end

event.HandleReturnKeyUp = function(eventType, eventData)
	local b_register_show = false;
	local b_create_plaer_show = false;

	if (app.login.register) then
		b_register_show = app.login.register.is_show();
	end
	if (app.login.create_player) then
		b_create_plaer_show = app.login.create_player.is_show();
	end

	if (app.login and app.login.is_show()) then
		app.libnetwork.Event.Brocast("HandleLoginReturnKeyUp", eventType, eventData);

	elseif (b_register_show) then
		app.libnetwork.Event.Brocast("HandleRegisterReturnKeyUp", eventType, eventData);

	elseif (b_create_plaer_show) then
		app.libnetwork.Event.Brocast("HandleCreatePlayerReturnKeyUp", eventType, eventData);
	end
end


return event;
