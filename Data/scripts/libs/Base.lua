
package.path = package.path .. fileSystem:GetCurrentDir() .. [[Data/scripts/?.lua]]

scene_ = nil

function BaseStart()
	SubscribeToEvent("KeyDown", "HandleKeyDown");

	SubscribeToEvent("KeyUp", "HandleKeyUp");
end

function HandleKeyDown(eventType, eventData)
	local key = eventData["Key"]:GetInt();
end

function HandleKeyUp(eventType, eventData)
	local key = eventData["Key"]:GetInt();

	if key == KEY_ESCAPE then
		engine:Exit();
	end
end
