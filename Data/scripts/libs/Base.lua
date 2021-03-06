
package.path = package.path .. fileSystem:GetCurrentDir() .. [[Data/scripts/?.lua]]

scene_ = nil
cameraNode = nil
tileMapNode = nil

useMouseMode_ = MM_ABSOLUTE

function BaseStart()
	CreateConsoleAndDebugHud();

	SubscribeToEvent("KeyDown", "HandleKeyDown");

	SubscribeToEvent("KeyUp", "HandleKeyUp");
end

function CreateConsoleAndDebugHud()
	local uiStyle = cache:GetResource("XMLFile", "UI/DefaultStyle.xml");
	if uiStyle == nil then
		return;
	end

	engine:CreateConsole();
	console.defaultStyle = uiStyle;
	console.background.opacity = 0.8;

	engine:CreateDebugHud();
	debugHud.defaultStyle = uiStyle;
end

function HandleKeyDown(eventType, eventData)
	local key = eventData["Key"]:GetInt();

	if (key == KEY_F1) then
		console:Toggle();

	elseif (key == KEY_F2) then
		debugHud:ToggleAll();

	end
end

function HandleKeyUp(eventType, eventData)
	local key = eventData["Key"]:GetInt();

	if (key == KEY_ESCAPE) then
		engine:Exit();

	elseif (key == KEY_RETURN) then
		app.libnetwork.Event.Brocast("HandleReturnKeyUp", eventType, eventData);

	end
end

function SampleInitMouseMode(mode)
	useMouseMode_ = mode
	if GetPlatform() ~= "Web" then
		if useMouseMode_ == MM_FREE then
			input.mouseVisible = true
		end

		if useMouseMode_ ~= MM_ABSOLUTE then
			input.mouseMode = useMouseMode_

			if console ~= nil and console.visible then
				input:SetMouseMode(MM_ABSOLUTE, true)
			end
		end
	else
		input.mouseVisible = true
		SubscribeToEvent("MouseButtonDown", "HandleMouseModeRequest")
		SubscribeToEvent("MouseModeChanged", "HandleMouseModeChange")
	end
end

function HandleMouseModeRequest(eventType, eventData)
	if console ~= nil and console.visible then
		return
	end

	if input.mouseMode == MM_ABSOLUTE then
		input.mouseVisible = false
	elseif useMouseMode_ == MM_FREE then
		input.mouseVisible = true
	end

	input.mouseMode = useMouseMode_
end

function HandleMouseModeChange(eventType, eventData)
	mouseLocked = eventData["MouseLocked"]:GetBool()
	input.mouseVisible = not mouseLocked
end
