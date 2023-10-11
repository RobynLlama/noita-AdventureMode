--Load the Advanced controller components
dofile_once("mods/AdventureMode/files/DebugPrint.lua")
dofile_once("mods/AdventureMode/files/HungryControllerAdv/HungryDigestionController.lua")
dofile_once("mods/AdventureMode/files/HungryControllerAdv/HungryHealingController.lua")

local Player = GetUpdatedEntityID()
local Storage = EntityGetFirstComponent(Player, "VariableStorageComponent", "HungryStorageComponent")
local Icon = EntityGetFirstComponent(Player, "UIIconComponent", "HungryNourishIcon")
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
RunDigestHeartBeat(HealthStorage)
RunHealHeartBeat(HealthStorage)

--Store the new StoredHealing value
ComponentSetValue2(Storage, "value_float", HealthStorage.StoredHealing)

--UIManagement
if (Icon == nil) then
    dPrint("Unable to access status icon", "HungryControllerAdv")
    return
end

--Set Icon
local IconPath = "mods/AdventureMode/files/HungryControllerAdv/img/store_waning.png"
local IconName = "Nourishment (Waning) "

if (HealthStorage.StoredHealing > 0.50 * MaximumStoredHealing) then
    IconPath = "mods/AdventureMode/files/HungryControllerAdv/img/store_good.png"
    IconName = "Nourishment (Good) "
elseif (HealthStorage.StoredHealing > 0.25 * MaximumStoredHealing) then
    IconPath = "mods/AdventureMode/files/HungryControllerAdv/img/store_fair.png"
    IconName = "Nourishment (Fair) "
end

ComponentSetValue2(Icon, "icon_sprite_file", IconPath)

--Update description
local FormattedAmount = string.format("%.1f", HealthStorage.StoredHealing)
ComponentSetValue2(Icon, "name", IconName)
ComponentSetValue2(Icon, "description", "Healing reserves: "..FormattedAmount)