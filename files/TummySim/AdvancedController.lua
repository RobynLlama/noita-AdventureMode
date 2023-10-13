--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")

--Init new module
local This = BaseModule.New("TummySimAdvancedController", 0)

--Load the Advanced controller components
local DigestionController = dofile_once("mods/AdventureMode/files/TummySim/HungryDigestionController.lua")
local HealingController = dofile_once("mods/AdventureMode/files/TummySim/HungryHealingController.lua")
local IconController = dofile_once("mods/AdventureMode/files/TummySim/NourishmentIconController.lua")

--Init variables
local Player = GetUpdatedEntityID()
local Storage = EntityGetFirstComponent(Player, "VariableStorageComponent", "HungryStorageComponent")

if (Storage == nil) then
    This:ModPrint("Unable to load player storage", 4)
    return
end

--Load mod settings
local MaximumStoredHealing = Settings.MaxNourishment

--Initialize HealthStorage context for modules
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

---@param Context table
function This.Tick(Context)

    --Update entities in case we get polymorphed
    Player = GetUpdatedEntityID()
    Storage = EntityGetFirstComponent(Player, "VariableStorageComponent", "HungryStorageComponent")

    if (Storage == nil) then
        This:ModPrint("Unable to load storage object", 4)
        return
    end

    This:ModPrint("Tick on frame "..tostring(GameGetFrameNum()), 1)

    --Update the HealingController with the modifier
    HealingController.Modifier = IconController.Modifier

    --Run heartbeats
    DigestionController:TickOnTimer(HealthStorage)
    HealingController:TickOnTimer(HealthStorage)
    IconController:TickOnTimer(HealthStorage)

    --Store the new StoredHealing value
    ComponentSetValue2(Storage, "value_float", HealthStorage.StoredHealing)
end

return This