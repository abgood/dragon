
require "scripts/libs/Base"
require "scripts/network/Dbg"
require "scripts/app"


function Start()
	BaseStart();

	app.init();

	SampleInitMouseMode(MM_FREE);

	SubscribeToEvents();

	app.libnetwork.encode();

	-- app.scene.addSpaceGeometryMapping();
end

function Stop()
	app.event.uninstallEvents()
	app.libnetwork.Destroy();
end

function SubscribeToEvents()
	SubscribeToEvent("Update", "HandleUpdate");
	SubscribeToEvent("PostUpdate", "HandlePostUpdate");
	
	SubscribeToEvent("NetworkMessage", "HandleNetworkMessage");
	SubscribeToEvent("ServerConnected", "HandleConnectionStatus");
	SubscribeToEvent("ServerDisconnected", "HandleConnectionServerDisconnected");
	SubscribeToEvent("ConnectFailed", "HandleConnectionFailed");
end

function HandleUpdate(eventType, eventData)
	app.libnetwork.update(eventType, eventData);
	app.scene.update(eventType, eventData);
end

function HandlePostUpdate(eventType, eventData)
	app.scene.post_update(eventType, eventData);
end
