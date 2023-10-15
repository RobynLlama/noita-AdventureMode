--Persist context between script runs
local Context = dofile_once("mods/AdventureMode/files/TummySim/SharedContext.lua")
local Controller = dofile_once("mods/AdventureMode/files/TummySim/ModuleBasicController.lua")
local Updater = dofile_once("mods/AdventureMode/files/TummySim/ModuleContextUpdater.lua")
dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
    Context.HealBlocker:BlockHealing()
end

function wand_fired(gun_entity_id)
    Context.HealBlocker:BlockHealing()
end

Updater:TickOnTimer(Context)
Controller:TickOnTimer(Context)
