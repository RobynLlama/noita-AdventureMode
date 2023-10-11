--Load the Advanced controller components
dofile_once("mods/AdventureMode/files/DebugPrint.lua")
local DigestionController = dofile_once("mods/AdventureMode/files/HungryControllerAdv/HungryDigestionController.lua")
local HealingController = dofile_once("mods/AdventureMode/files/HungryControllerAdv/HungryHealingController.lua")
local IconController = dofile_once("mods/AdventureMode/files/HungryControllerAdv/NourishmentIconController.lua")

local Player = GetUpdatedEntityID()
local Storage = EntityGetFirstComponent(Player, "VariableStorageComponent", "HungryStorageComponent")
local MaximumStoredHealing = ModSettingGet("AdventureMode.Adv_MaxStoredHealing")

if (Storage == nil) then
    dPrint("Unable to load storage object", "HungryControllerAdv")
    return
end

dPrint("Tick on frame "..tostring(GameGetFrameNum()), "HungryControllerAdv")

local HealthStorage = {
    StoredHealing=ComponentGetValue2(Storage, "value_float"),
    ModifyStoredHealth=
    ---@param This table
    ---@param Amount integer
    function(This, Amount)
        This.StoredHealing = This.StoredHealing + Amount

        if (This.StoredHealing > MaximumStoredHealing) then
            This.StoredHealing = MaximumStoredHealing
        elseif (This.StoredHealing < 0) then
            This.StoredHealing = 0
        end
    end,
}

--Run heartbeats
DigestionController.Tick(HealthStorage)
HealingController.Tick(HealthStorage)
IconController.Tick(HealthStorage)

--Update the HealingController with the new modifier
HealingController.Modifier = IconController.Modifier

--Store the new StoredHealing value
ComponentSetValue2(Storage, "value_float", HealthStorage.StoredHealing)

