-------------------------------------------------------------------------------------------
--												entity
-----------------------------------------------------------------------------------------*/


KBEngineLua.Entity = 
{
	-- 当前玩家最后一次同步到服务端的位置与朝向
	-- 这两个属性是给引擎KBEngine.cs用的，别的地方不要修改
	_entityLastLocalPos = Vector3(0.0, 0.0, 0.0),
	_entityLastLocalDir = Vector3(0.0, 0.0, 0.0),
	id = 0,
	className = "",
	position = Vector3(0.0, 0.0, 0.0),
	direction = Vector3(0.0, 0.0, 0.0),
	velocity = 0.0,

	cell = nil,
	base = nil,

	-- enterworld之后设置为true
	inWorld = false,


	-- 对于玩家自身来说，它表示是否自己被其它玩家控制了；
	-- 对于其它entity来说，表示我本机是否控制了这个entity
	isControlled = false;

	-- __init__调用之后设置为true
	inited = false,		
	renderObj = nil,

}

KBEngineLua.Entity.New = function( self , me )
	me = me or {};
	setmetatable(me, self);
	self.__index = self;
    return me;  
end

KBEngineLua.Entity.__init__ = function(self)
end

KBEngineLua.Entity.callPropertysSetMethods = function(self)

	local currModule = KBEngineLua.moduledefs[self.className];
	for k,v in pairs(currModule.propertys) do
		local propertydata = v;
		local properUtype = propertydata[1];
		local name = propertydata[3];
		local setmethod = propertydata[6];
		local flags = propertydata[7];
		local oldval = self[name];

		if(setmethod ~= nil) then
			-- base类属性或者进入世界后cell类属性会触发set_*方法
			if(flags == 0x00000020 or flags == 0x00000040) then
				if(self.inited and not self.inWorld) then
					setmethod(self, oldval);
				end
			else
				if(self.inWorld) then
					setmethod(self, oldval);
				end
			end
		end
	end
end

KBEngineLua.Entity.onDestroy = function(self)
end

KBEngineLua.Entity.isPlayer = function(self)
	return self.id == KBEngineLua.entity_id;
end

KBEngineLua.Entity.baseCall = function(self, ...)
	local arguments = {...};

	if(#arguments < 1) then
		logInfo('KBEngineLua.Entity::baseCall: not fount interfaceName~');  
		return;
	end

	if(self.base == nil) then 
		logInfo('KBEngineLua.Entity::baseCall: base is None~');  
		return;			
	end

	local method = KBEngineLua.moduledefs[self.className].base_methods[arguments[1]];
	local methodID = method[1];
	local args = method[4];

	if(#arguments - 1 ~= #args) then
		logInfo("KBEngineLua.Entity::baseCall: args(" .. (#arguments - 1) .. "~= " .. #args .. ") size is error!");  
		return;
	end

	self.base:newCall();
	self.base.bundle:writeUint16(methodID);

	for i = 1, #args do
		if(args[i]:isSameType(arguments[i + 1])) then
			args[i]:addToStream(self.base.bundle, arguments[i + 1]);
        end     
	end

	self.base:sendCall(nil);
end

KBEngineLua.Entity.cellCall = function(self, ...)
	local arguments = {...};

	if(#arguments < 1) then
		logInfo('KBEngineLua.Entity::cellCall: not fount interfaceName!');  
		return;
	end

	if(self.cell == nil) then
		logInfo('KBEngineLua.Entity::cellCall: cell is None!');  
		return;			
	end

	local method = KBEngineLua.moduledefs[self.className].cell_methods[arguments[1]];
	local methodID = method[1];
	local args = method[4];

	if(#arguments - 1 ~= #args) then
		logInfo("KBEngineLua.Entity::cellCall: args(" .. (#arguments - 1) .. "~= " .. #args .. ") size is error!");  
		return;
	end

	self.cell:newCall();
	self.cell.bundle:writeUint16(methodID);

	for i = 1, #args do
		if(args[i]:isSameType(arguments[i + 1])) then
			args[i]:addToStream(self.base.bundle, arguments[i + 1]);
        end     
	end

	self.cell:sendCall(nil);
end

KBEngineLua.Entity.enterWorld = function(self)
	logInfo(self.className .. '::enterWorld: ' .. self.id); 
	self.inWorld = true;
	self:onEnterWorld();

	KBEngineLua.Event.Brocast("onEnterWorld", self);
end

KBEngineLua.Entity.onEnterWorld = function(self)
end

KBEngineLua.Entity.leaveWorld = function(self)
	logInfo(self.className .. '::leaveWorld: ' .. self.id); 
	self.inWorld = false;
	self.onLeaveWorld();

	KBEngineLua.Event.Brocast("onLeaveWorld", self);
end

KBEngineLua.Entity.onLeaveWorld = function(self)
end

KBEngineLua.Entity.enterSpace = function(self)
	logInfo(self.className .. '::enterSpace: ' .. self.id); 
	self.onEnterSpace();
	KBEngineLua.Event.Brocast("onEnterSpace", self);

	KBEngineLua.Event.Brocast("set_position", self);
	KBEngineLua.Event.Brocast("set_direction", self);
end

KBEngineLua.Entity.onEnterSpace = function(self)
end

KBEngineLua.Entity.leaveSpace = function(self)
	logInfo(self.className .. '::leaveSpace: ' .. self.id); 
	self.onLeaveSpace();
	KBEngineLua.Event.Brocast("onLeaveSpace", self);
end

KBEngineLua.Entity.onLeaveSpace = function(self)
end

KBEngineLua.Entity.onUpdateVolatileData = function(self)
end

-- 对于玩家自身来说，它表示是否自己被其它玩家控制了；
-- 对于其它entity来说，表示我本机是否控制了这个entity
KBEngineLua.Entity.onControlled = function(self, isControlled_)
end

KBEngineLua.Entity.set_position = function(self, old)
	KBEngineLua.Event.Brocast("set_position", self);
end

KBEngineLua.Entity.set_direction = function(self, old)
	KBEngineLua.Event.Brocast("set_direction", self);
end

KBEngineLua.Entity.setDirection = function(self, dir)
	logInfo(self.className .. '::setDirection: ' .. self.id .. ", dir: " .. dir); 
    local vehicle = self.renderObj:GetScriptObject();
	if (vehicle) then
		vehicle:SetDir(dir);
	end
end

KBEngineLua.Entity.SetPosition = function(self, x, y, z)
	logInfo(self.className .. '::SetPosition: ' .. self.id .. ", x: " .. x .. ", y: " .. y .. ", z: " .. z); 
	if (self.renderObj) then
		self.renderObj:SetPosition(Vector3(x, y, z));
	end
end
