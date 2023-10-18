--[[
    AdventureController

    Holds a reference to every other module that either ticks or does something
    in response to a callback on the player
]]

--[[
    CallBackIDs:
        script_damage_received
        OnDamage(context, damage:number, message:string, entity_thats_responsible:int, is_fatal:bool, projectile_thats_responsible:int ))
        
        script_shot
        OnShotProjectile(context, projectile_entity_id )

        script_wand_fired
        OnWandFired(context, gun_entity_id )

        script_teleported
        OnTeleported(context, from_x, from_y, to_x, to_y )

        script_portal_teleport_used
        OnTeleportalUse(context, entity_that_was_teleported, from_x, from_y, to_x, to_y )

        script_polymorphing_to
        OnPolyMorphingTo(context, string_entity_we_are_about_to_polymorph_to )
]]

CB_TYPE_DAMAGE = 1
CB_TYPE_PROJECTILE = 2
CB_TYPE_WAND_FIRED = 3
CB_TYPE_TELEPORTED = 4
CB_TYPE_TELEPORTAL = 5
CB_TYPE_POLYMORPHING = 6

local Context = dofile_once("mods/AdventureMode/files/AdventureController/SharedContext.lua")
local Updater = dofile_once("mods/AdventureMode/files/AdventureController/ModuleContextUpdater.lua")
dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

---@param Module table
function RegisterModule(Module)
    dPrint(string.format("Registering module %s", Module.Name), "AdventureController", 1)
    table.insert(Context.Modules, Module)
    Module.Init(GetUpdatedEntityID(), Context)
end

--Modders: Detour this function to add your own modules here
function init(entity_id)
    dPrint("Adventure Controller startup", "AdventureController", 1)

    --default modules
    RegisterModule(dofile_once("mods/AdventureMode/files/TummySim/ModuleBasicController.lua"))
    RegisterModule(dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedController.lua"))
    RegisterModule(dofile_once("mods/AdventureMode/files/Items/Wonders/WonderController.lua"))
end

--Check out if we don't have modules yet
if (#Context.Modules == 0) then
    dPrint("Skipping Modules this frame", "AdventureController", 1)
    return
end

--Run context updater
Updater:TickOnTimer(Context)

--Run each module's tick
for _, Module in pairs(Context.Modules) do
    Module:TickOnTimer(Context)
end

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
    --Run all callbacks for this message
    dPrint("Sending Event CB_TYPE_DAMAGE", "AdventureController", 1)
    for _, Module in pairs(Context.Modules) do
        if (Module.EventCallBacks[CB_TYPE_DAMAGE]) then
            Module.EventCallBacks[CB_TYPE_DAMAGE](Context, damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
        end
    end
end

function wand_fired( gun_entity_id )
    --Run all callbacks for this message
    dPrint("Sending Event CB_TYPE_WAND_FIRED", "AdventureController", 1)
    for _, Module in pairs(Context.Modules) do
        if (Module.EventCallBacks[CB_TYPE_WAND_FIRED]) then
            Module.EventCallBacks[CB_TYPE_WAND_FIRED](Context, gun_entity_id)
        end
    end
end