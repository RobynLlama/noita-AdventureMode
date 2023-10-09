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

function dPrint(message)
    if (DEBUG_PRINT) then
        print(message)
    end
end