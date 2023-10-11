local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")
local BASController = dofile_once("mods/AdventureMode/files/TummySim/BasicController.lua")
local ADVController = dofile_once("mods/AdventureMode/files/TummySim/AdvancedController.lua")

if (Settings.TummyType == "BAS") then
    BASController.Tick()
elseif (Settings.TummyType == "ADV") then
    ADVController.Tick()
end