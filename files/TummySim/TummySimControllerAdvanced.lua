--Persist context between script runs
local Context = dofile_once("mods/AdventureMode/files/TummySim/SharedContext.lua")
local Controller = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedController.lua")
dofile_once("mods/AdventureMode/files/DebugPrint.lua")

--Super jank but we're using this as a signal to update our settings context
function enabled_changed( entity_id, is_enabled)
    if (is_enabled) then
        Context.Settings.UpdateCache()
    end
end

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
    Context.HealBlocker:BlockHealing()
end

function wand_fired( gun_entity_id )
    Context.HealBlocker:BlockHealing()
end

Controller:TickOnTimer(Context)