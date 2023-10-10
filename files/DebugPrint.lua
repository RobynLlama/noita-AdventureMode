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

--Quick little hack to enable globally controlling print statements
--without needing to comment out each one
local DEBUG_PRINT = false
local MODULE_TAG = "[HM] "

---@param message string
---@param from string
---@return nil
function dPrint(message, from)
    if (DEBUG_PRINT) then
        print(MODULE_TAG..from.." > "..message)
    end
end