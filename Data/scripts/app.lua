
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
		this.libnetwork.init();
	end

	if (this.login == nil) then
		this.login = require "scripts/login/login";
		this.login.init();
	end

	if (this.scene == nil) then
		this.scene = require "scripts/scene/scene";
		this.scene.init();
	end

	if (this.map == nil) then
		this.map = require "scripts/map/map";
		this.map.init();
	end

	if (this.event == nil) then
		this.event = require "scripts/event/event";
		this.event.init();
	end

end

return app;
