dofile_once("data/scripts/game_helpers.lua")
dofile_once("mods/AdventureMode/files/DebugPrint.lua")

--vars
local DataStorage

---@param HealthStorage table
---@return nil
function RunHealHeartBeat(HealthStorage)

    --Entities/Components
    DataStorage = HealthStorage
    local Player = GetUpdatedEntityID()
    local HealthStatus = EntityGetFirstComponent(Player, "DamageModelComponent")

    --No healing available
    if (DataStorage.StoredHealing == 0) then
        return
    end

    --Settings
    local MaxHealthRestoredPerFrame = 0.05
    local ThisHealPercent

    --Check if Tummy or HealthStatus is missing
    if (HealthStatus == nil) then
        dPrint("Unable to read Health Component", "AdvHealingController")
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

    --Don't use more healing than we have stored
    if (ThisHealPercent * 100 > DataStorage.StoredHealing) then
        ThisHealPercent = DataStorage.StoredHealing / 100
    end

    if (ThisHealPercent == 0) then
        return
    end

    dPrint("Doing heal for "..tostring(ThisHealPercent), "AdvHealingController")

    --Perform the heal
    heal_entity(Player, HealthMax * ThisHealPercent)

    --Pay for the heal
    DataStorage:ModifyStoredHealth(-ThisHealPercent * 100)
    


end