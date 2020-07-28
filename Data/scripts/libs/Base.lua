
package.path = package.path .. fileSystem:GetCurrentDir() .. [[Data/scripts/?.lua]]

scene_ = nil
cameraNode = nil
tileMapNode = nil

useMouseMode_ = MM_ABSOLUTE

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

