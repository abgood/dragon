
app = {}

local this = app;


require "scripts/network/Dbg"


app.libnetwork = nil;
app.login = nil;
app.event = nil;
app.scene = nil;
app.map = nil;


app.init = function()
	logInfo("app init");

	if (this.libnetwork == nil) then
		this.libnetwork = require "scripts/network/KBEngine";
	end

	if (this.login == nil) then
		this.login = require "scripts/login/login";
	end

	if (this.event == nil) then
		this.event = require "scripts/event/event";
	end

	if (this.scene == nil) then
		this.scene = require "scripts/scene/scene";
	end

	if (this.map == nil) then
		this.map = require "scripts/map/map";
	end

	this.libnetwork.init();
	this.login.init();
	this.event.init();
	this.scene.init();
	this.map.init();
end

return app;
