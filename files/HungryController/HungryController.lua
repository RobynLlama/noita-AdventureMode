dofile_once("data/scripts/game_helpers.lua")
dofile_once("mods/HungryMina/files/DebugPrint.lua")

--Entities/Components
local Player = GetUpdatedEntityID()
local Tummy = EntityGetFirstComponent(Player, "IngestionComponent")
local HealthStatus = EntityGetFirstComponent(Player, "DamageModelComponent")

--Settings
--Default max tummy size is 7500 so this is 1%
local SatietyCostForEachPercent = tonumber(ModSettingGet("HungryMina.CostForPercent"))
local MaxHealthRestoredPerFrame = tonumber(ModSettingGet("HungryMina.MaxHealPerFrame"))/100

--Cost tracking
local ThisHealPercent = 0.0
local ThisSatCost = 0.0

dPrint("Tick on frame "..tostring(GameGetFrameNum()), "BASTummySim")

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

dPrint("Doing heal for "..tostring(ThisHealPercent).. " for "..tostring(ThisSatCost).." satiation", "BASTummySim")

--Perform the heal
heal_entity(Player, HealthMax * ThisHealPercent)

--Pay for the heal
ComponentSetValue2(Tummy, "ingestion_size", CurrentSatiety - ThisSatCost)