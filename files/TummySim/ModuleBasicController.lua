dofile_once("data/scripts/game_helpers.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local Enabled = true

--Init new module
local This = BaseModule.New("TummySimBasicController", 120)

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

    --Callbacks
    This:AddCallback(CB_TYPE_DAMAGE, CombatCallBack)
    This:AddCallback(CB_TYPE_WAND_FIRED, CombatCallBack)
    This:AddCallback(CB_TYPE_PROJECTILE, CombatCallBack)
end

---@param Context table
function This.Tick(_, Context)

    --Update Enabled status
    Enabled = Context.Settings.TummyType == "BAS"

    if (not Enabled) then
        return
    end

    --Entities/Components
    local Player = GetUpdatedEntityID()
    local Tummy = EntityGetFirstComponent(Player, "IngestionComponent")
    local HealthStatus = EntityGetFirstComponent(Player, "DamageModelComponent")

    --Check if we're healblocked
    if (Context.HealBlocker:IsHealingBlocked()) then
        return
    end

    --Settings
    --Default max tummy size is 7500 so this is 1%
    local SatietyCostForEachPercent = Context.Settings.SatietyCostForEachPercent
    local MaxHealthRestoredPerFrame = Context.Settings.MaxHealthRestoredPerFrame / 100

    --Cost tracking
    local ThisHealPercent = 0.0
    local ThisSatCost = 0.0

    This:ModPrint("Tick on frame " .. tostring(GameGetFrameNum()), 1)

    --Check if Tummy or HealthStatus is missing
    if (Tummy == nil) or (HealthStatus == nil) then
        return
    end

    --Read from components
    local CurrentSatiety = ComponentGetValue2(Tummy, "ingestion_size")
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

    ThisSatCost = ThisHealPercent * 100 * SatietyCostForEachPercent

    --If we don't have enough Satiety to pay the heal cost modify it down
    if (ThisSatCost > CurrentSatiety) then
        ThisHealPercent = ThisHealPercent * (CurrentSatiety / ThisSatCost)
        ThisSatCost = CurrentSatiety
    end

    if (ThisSatCost == 0) or (ThisHealPercent == 0) then
        return
    end

    This:ModPrint("Doing heal for " .. tostring(ThisHealPercent) .. " for " .. tostring(ThisSatCost) .. " satiation", 1)

    --Perform the heal
    heal_entity(Player, HealthMax * ThisHealPercent)

    --Pay for the heal
    ComponentSetValue2(Tummy, "ingestion_size", CurrentSatiety - ThisSatCost)
end

return This
