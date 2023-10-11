--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")

--Init new module
local This = BaseModule.New("TummySimAdvancedController")

--Load the Advanced controller components
local DigestionController = dofile_once("mods/AdventureMode/files/TummySim/HungryDigestionController.lua")
local HealingController = dofile_once("mods/AdventureMode/files/TummySim/HungryHealingController.lua")
local IconController = dofile_once("mods/AdventureMode/files/TummySim/NourishmentIconController.lua")

--Init variables
local Player = GetUpdatedEntityID()
local Storage = EntityGetFirstComponent(Player, "VariableStorageComponent", "HungryStorageComponent")

if (Storage == nil) then
    This:ModPrint("Unable to load player storage")
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

    if (Storage == nil) then
        This:ModPrint("Unable to load storage object")
        return
    end

    This:ModPrint("Tick on frame "..tostring(GameGetFrameNum()))

    --Run heartbeats
    DigestionController.Tick(HealthStorage)
    HealingController.Tick(HealthStorage)
    IconController.Tick(HealthStorage)

    --Update the HealingController with the new modifier
    HealingController.Modifier = IconController.Modifier

    --Store the new StoredHealing value
    ComponentSetValue2(Storage, "value_float", HealthStorage.StoredHealing)
end

return This