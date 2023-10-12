dofile_once("data/scripts/game_helpers.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("HungryHealingController")

--Public vars
This.Modifier = 0

---comment
---@param MaxLife number
---@return number
function GetHealingPerPoint(MaxLife)
    --Healing per point = 0.5% MaxLife + 1 + modifier
    --Life is stored as a float where each 1.0 = 25 for some reason
    MaxLife = MaxLife * 25
    return (0.005 * MaxLife) + 1 + This.Modifier
end

---@param Context table
function This.Tick(Context)

    --Entities/Components
    local Player = GetUpdatedEntityID()
    local HealthStatus = EntityGetFirstComponent(Player, "DamageModelComponent")

    --No healing available
    if (Context.StoredHealing == 0) then
        return
    end

    --Settings
    local MaxHealthRestoredPerFrame = 0.025
    local ThisHealPercent

    --Check if Tummy or HealthStatus is missing
    if (HealthStatus == nil) then
        This:ModPrint("Unable to read Health Component")
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
    local HealingPerPoint = GetHealingPerPoint(HealthMax)
    local ThisHealingCost = (HealthMax * 25 * ThisHealPercent) / HealingPerPoint

    This:ModPrint("Healing per point: "..tostring(HealingPerPoint))
    This:ModPrint("Healing cost: "..tostring(ThisHealingCost))

    if (ThisHealingCost > Context.StoredHealing) then

        ThisHealingCost = Context.StoredHealing
        if (ThisHealingCost < 0.25) then
            This:ModPrint("Skipping heal, too low")
            return
        end
    end

    local ThisHealTotal = ThisHealingCost * HealingPerPoint

    This:ModPrint("Doing heal for "..tostring(ThisHealTotal))

    --Perform the heal
    heal_entity(Player, ThisHealTotal / 25)

    --Pay for the heal
    Context:ModifyStoredHealth(-ThisHealingCost)

end

return This