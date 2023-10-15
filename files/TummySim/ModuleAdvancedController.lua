dofile_once("mods/AdventureMode/files/utils/ComponentUtils.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("TummySimAdvancedController", 0)

--Load the Advanced controller components
local DigestionController = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedDigestionController.lua")
local HealingController = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedHealingController.lua")
local IconController = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedIconController.lua")

---@return number
local function ReadVariableStorage()
    local name = "AdvTummySim_StoredHealing"
    local Player = GetUpdatedEntityID()
    local Storage = GetComponentByName(Player, "VariableStorageComponent", name)
    if (Storage == nil) then
        This:ModPrint("Unable to load healing storage", 4)
        return 0
    end

    local Value = ComponentGetValue2(Storage, "value_float")

    if (Value == nil) then
        This:ModPrint("Unable to read value from healing storage", 4)
        return 0
    end

    return Value
end

---@param Value number
local function WriteVariableStorage(Value)
    local name = "AdvTummySim_StoredHealing"
    local Player = GetUpdatedEntityID()
    local Storage = GetComponentByName(Player, "VariableStorageComponent", name)

    if (Value == nil) then
        This:ModPrint("Nil value passed in WriteVariableStorage", 3)
        return
    end
    if (Storage == nil) then
        This:ModPrint("Unable to load healing storage for writing", 4)
        return
    end

    ComponentSetValue2(Storage, "value_float", Value)
end

--Initialize HealthStorage context for modules
local HealthStorage = {
    StoredHealing=ReadVariableStorage(),
    ParentContext = nil,
}

---@param Self table
---@param Amount integer
function HealthStorage.ModifyStoredHealth(Self, Amount)

    if (Amount == nil) then
        This:ModPrint("Amount is nil", 4)
        return
    end

    if (Self.ParentContext == nil) then
        This:ModPrint("ParentContext is nil", 4)
        return
    end

    Self.StoredHealing = Self.StoredHealing + Amount

    if (Self.StoredHealing > Self.ParentContext.Settings.MaxNourishment) then
        Self.StoredHealing = Self.ParentContext.Settings.MaxNourishment
    elseif (Self.StoredHealing < 0) then
        Self.StoredHealing = 0
    end
end

---@param Context table
function This.Tick(Context)

    --Prepare context
    Context.Health = HealthStorage
    Context.Health.ParentContext = Context

    --Run heartbeats
    DigestionController:TickOnTimer(Context)
    HealingController:TickOnTimer(Context)
    IconController:TickOnTimer(Context)

    --Store the new StoredHealing value
    WriteVariableStorage(Context.Health.StoredHealing)
end

return This