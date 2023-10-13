local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")
local BASController = dofile_once("mods/AdventureMode/files/TummySim/BasicController.lua")
local ADVController = dofile_once("mods/AdventureMode/files/TummySim/AdvancedController.lua")
local Context = dofile_once("mods/AdventureMode/files/TummySim/SharedContext.lua")

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
    Context.HealBlocker:BlockHealing()
end

function wand_fired( gun_entity_id )
    Context.HealBlocker:BlockHealing()
end

if (Settings.TummyType == "BAS") then
    BASController:TickOnTimer(Context)
elseif (Settings.TummyType == "ADV") then
    ADVController:TickOnTimer(Context)
end