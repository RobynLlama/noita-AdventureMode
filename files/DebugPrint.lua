--[[
Module: dPrint
Authors: MamaLlama, Flowerful
Licensing:
	This module and all of it component files are provied under the CC-BY-NC-4 license
	A short and simple summary may be found at the following web address:
	https://www.creativecommons.org/licenses/by-nc/4.0/deed.en

	See the full legal code here:
	https://www.creativecommons.org/licenses/by-nc/4.0/legalcode.en
]]--

local LogLevel = 1

local Levels = {
	[1] = "[INFO]",
	[2] = "[WARN]",
	[3] = "[ERROR]",
	[4] = "[CRITICAL]",
	[5] = "[DEBUG]",
}

local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")

--Quick little hack to enable globally controlling print statements
--without needing to comment out each one
local MODULE_TAG = "[ADVENTURE]"

---@param message string
---@param from string
---@param level integer
---@return nil
function dPrint(message, from, level)
	local DEBUG_PRINT = Settings.DebugPrintingLevel
	if (DEBUG_PRINT == 0) then
		return
	end

	if (level > DEBUG_PRINT - 1) then
		if (level > 0) then
			print(MODULE_TAG..Levels[level]..from.." > "..message)
		else
			print(MODULE_TAG..from.." > "..message)
		end
	end
end