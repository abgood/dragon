
require "scripts/libs/Base"

Dbg = {}
local this = Dbg;


DEBUGLEVEL = {
	DEBUG = 0,
	INFO = 1,
	WARNING = 2,
	ERROR = 3,
	NOLOG = 4,  -- 放在最后面，使用这个时表示不输出任何日志（!!!慎用!!!）
}


this.debugLevel = DEBUGLEVEL.DEBUG;


this.getHead = function()
	return "";
end

this.INFO_MSG = function( s )
	if (DEBUGLEVEL.INFO >= this.debugLevel) then
		KBELuaUtil.Log(this.getHead() .. s);
	end
end

this.DEBUG_MSG = function( s )
	if (DEBUGLEVEL.DEBUG >= this.debugLevel) then
		KBELuaUtil.Log(this.getHead() .. s);
	end
end

this.WARNING_MSG = function(s)
	if (DEBUGLEVEL.WARNING >= this.debugLevel) then
		KBELuaUtil.LogWarning(this.getHead() .. s);
	end
end

this.ERROR_MSG = function(s)
	if (DEBUGLEVEL.ERROR >= this.debugLevel) then
		KBELuaUtil.LogError(this.getHead() .. s);
	end
end


--debug输出日志--
function logDbg(str)
    -- Dbg.DEBUG_MSG(str);
	log:Write(LOG_DEBUG, "S_DBG: " .. str)
end

--输出日志--
function logInfo(str)
    -- Dbg.INFO_MSG(str);
	log:Write(LOG_INFO, "S_INFO: " .. str)
end

--错误日志--
function logError(str) 
    -- Dbg.ERROR_MSG(str);
    log:Write(LOG_ERROR, "S_ERR: " .. str)
end

--警告日志--
function logWarn(str) 
    -- Dbg.WARNING_MSG(str);
    log:Write(LOG_WARNING, "S_WARN: " .. str)
end
