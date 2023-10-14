--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

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

--Initialize HealthStorage context for modules
local HealthStorage = {
    StoredHealing=ComponentGetValue2(Storage, "value_float"),
    ModifyStoredHealth=
    ---@param Self table
    ---@param Amount integer
    function(Self, Amount)
        Self.StoredHealing = Self.StoredHealing + Amount

        if (Self.StoredHealing > Self.Parent.Settings.MaxNourishment) then
            Self.StoredHealing = Self.Parent.MaxNourishment
        elseif (Self.StoredHealing < 0) then
            Self.StoredHealing = 0
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

    --Setup context for the modules
    Context.Health = HealthStorage
    Context.Health.Parent = Context

    --Run heartbeats
    DigestionController:TickOnTimer(Context)
    HealingController:TickOnTimer(Context)
    IconController:TickOnTimer(Context)

    --Store the new StoredHealing value
    ComponentSetValue2(Storage, "value_float", HealthStorage.StoredHealing)
end

return This