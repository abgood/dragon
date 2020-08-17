
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


--debug输出日志--
function logDbg(str)
	if (DEBUGLEVEL.DEBUG >= this.debugLevel) then
		log:Write(LOG_DEBUG, "S_DBG: " .. str)
	end
end

--警告日志--
function logWarn(str) 
	if (DEBUGLEVEL.WARNING >= this.debugLevel) then
		log:Write(LOG_WARNING, "S_WARN: " .. str)
	end
end

--输出日志--
function logInfo(str)
	if (DEBUGLEVEL.INFO >= this.debugLevel) then
		log:Write(LOG_INFO, "S_INFO: " .. str)
	end
end

--错误日志--
function logError(str) 
	if (DEBUGLEVEL.ERROR >= this.debugLevel) then
		log:Write(LOG_ERROR, "S_ERR: " .. str)
	end
end
