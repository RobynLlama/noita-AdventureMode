dofile_once("data/scripts/game_helpers.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("AdvancedHealingController", 180)

---comment
---@param MaxLife number
---@param Context table
---@return number
function GetHealingPerPoint(MaxLife, Context)
    --Healing per point = 0.5% MaxLife + 1 + modifier
    --Life is stored as a float where each 1.0 = 25 for some reason
    MaxLife = MaxLife * 25
    return (0.005 * MaxLife) + 1 + Context.Modifier
end

---@param Context table
function This.Tick(_, Context)
    --Check if we're healblocked
    if (Context.HealBlocker:IsHealingBlocked()) then
        return
    end

    --Entities/Components
    local Player = GetUpdatedEntityID()
    local HealthStatus = EntityGetFirstComponent(Player, "DamageModelComponent")

    --No healing available
    if (Context.Health.StoredHealing == 0) then
        return
    end

    --Settings
    local MaxHealthRestoredPerFrame = 0.05
    local ThisHealPercent

    --Check if Tummy or HealthStatus is missing
    if (HealthStatus == nil) then
        This:ModPrint("Unable to read Health Component", 3)
        return
    end

    --Read from components
    local HealthCur = ComponentGetValue2(HealthStatus, "hp")
    local HealthMax = ComponentGetValue2(HealthStatus, "max_hp")

    --Shortcut out if we don't need to heal at all
    if (HealthMax == HealthCur) then
        return
    end

    ThisHealPercent = 1 - (HealthCur / HealthMax)

    --Don't heal more than the max per frame
    if (ThisHealPercent > MaxHealthRestoredPerFrame) then
        ThisHealPercent = MaxHealthRestoredPerFrame
    end

    --Calculate healing cost
    local HealingPerPoint = GetHealingPerPoint(HealthMax, Context)
    local ThisHealingCost = (HealthMax * 25 * ThisHealPercent) / HealingPerPoint

    This:ModPrint("Healing per point: " .. tostring(HealingPerPoint), 1)
    This:ModPrint("Healing cost: " .. tostring(ThisHealingCost), 1)

    if (ThisHealingCost > Context.Health.StoredHealing) then
        ThisHealingCost = Context.Health.StoredHealing
        if (ThisHealingCost < 0.25) then
            This:ModPrint("Skipping heal, too low", 1)
            return
        end
    end

    local ThisHealTotal = ThisHealingCost * HealingPerPoint

    This:ModPrint("Doing heal for " .. tostring(ThisHealTotal), 1)

    --Perform the heal
    heal_entity(Player, ThisHealTotal / 25)

    --Pay for the heal
    Context.Health:ModifyStoredHealth(-ThisHealingCost)
end

return This
