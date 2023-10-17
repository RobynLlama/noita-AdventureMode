dofile_once("mods/AdventureMode/files/utils/ComponentUtils.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("TummySimAdvancedController", 2)

--Load the Advanced controller components
local DigestionController = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedDigestionController.lua")
local HealingController = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedHealingController.lua")
local IconController = dofile_once("mods/AdventureMode/files/TummySim/ModuleAdvancedIconController.lua")
local Enabled = true

local ObjectName = "TummySimAdvanced"
local ObjectExists = GetChildByName(GetUpdatedEntityID(), ObjectName) ~= nil

---@return number
local function ReadVariableStorage()
    local name = "AdvTummySim_StoredHealing"
    local AdvObj = GetChildByName(GetUpdatedEntityID(), ObjectName)

    if (AdvObj == nil) then
        This:ModPrint("Unable to acces AdvObj", 4)
        return 0
    end

    local Storage = GetComponentByName(AdvObj, "VariableStorageComponent", name)

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
    local AdvObj = GetChildByName(GetUpdatedEntityID(), ObjectName)

    if (AdvObj == nil) then
        This:ModPrint("Unable to acces AdvObj", 4)
        return
    end

    local Storage = GetComponentByName(AdvObj, "VariableStorageComponent", name)

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
    StoredHealing = 0,
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

local function CombatCallBack(Context)

    if (not Enabled) then
        return
    end

    This:ModPrint("Combat call back recieved", 1)
    Context.HealBlocker:BlockHealing(Context.Settings.HealBlockFrames)
end

---@param EntityID integer
---@param Context table
function This.Init(EntityID, Context)
    Context.HealBlocker = dofile_once("mods/AdventureMode/files/Tummysim/HealBlocker.lua")
    Context.Health = HealthStorage
    Context.Health.ParentContext = Context

    --Callbacks
    This:AddCallback(CB_TYPE_DAMAGE, CombatCallBack)
    This:AddCallback(CB_TYPE_WAND_FIRED, CombatCallBack)
    This:AddCallback(CB_TYPE_PROJECTILE, CombatCallBack)
end

function CreateObject()
    if ( not ObjectExists) then
        EntityAddChild(GetUpdatedEntityID(), EntityLoad("mods/AdventureMode/files/TummySim/TummyControllerAdvanced.xml"))
        HealthStorage.StoredHealing = ReadVariableStorage()
        ObjectExists = true
    end
end

function CleanupObject()
    if (ObjectExists) then

        local AdvObj = GetChildByName(GetUpdatedEntityID(), ObjectName)

        if (AdvObj) then
            EntityKill(AdvObj)
            ObjectExists = false
        end
    end

end

---@param Context table
function This.Tick(_, Context)

    --Update Enabled status
    Enabled = Context.Settings.TummyType == "ADV"

    if (not Enabled) then
        CleanupObject()
        return
    end

    CreateObject()

    --Run heartbeats
    DigestionController:TickOnTimer(Context)
    HealingController:TickOnTimer(Context)
    IconController:TickOnTimer(Context)

    --Store the new StoredHealing value
    WriteVariableStorage(Context.Health.StoredHealing)
end

return This
