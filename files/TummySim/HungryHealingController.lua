dofile_once("data/scripts/game_helpers.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("HungryHealingController")

--Public vars
This.Modifier = 0

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
    local MaxHealthRestoredPerFrame = 0.05
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

    --Don't use more healing than we have stored
    if (ThisHealPercent * 100 > Context.StoredHealing) then
        ThisHealPercent = Context.StoredHealing / 100
    end

    --Experimental idea
    ThisHealPercent = ThisHealPercent + This.Modifier

    if (ThisHealPercent <= 0) then
        return
    end

    This:ModPrint("Doing heal for "..tostring(ThisHealPercent))

    --Perform the heal
    heal_entity(Player, HealthMax * ThisHealPercent)

    --Pay for the heal
    Context:ModifyStoredHealth(-ThisHealPercent * 100)

end

return This