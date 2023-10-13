local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")
local BASController = dofile_once("mods/AdventureMode/files/TummySim/BasicController.lua")
local ADVController = dofile_once("mods/AdventureMode/files/TummySim/AdvancedController.lua")

local Context = {}

if (Settings.TummyType == "BAS") then
    BASController:TickOnTimer(Context)
elseif (Settings.TummyType == "ADV") then
    ADVController:TickOnTimer(Context)
end