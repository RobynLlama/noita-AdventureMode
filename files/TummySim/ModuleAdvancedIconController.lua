dofile_once("mods/AdventureMode/files/utils/ComponentUtils.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("NourishmentIconController", 10)

---@param Context table
function This.Tick(_, Context)
    local AdvObj = GetChildByName(GetUpdatedEntityID(), "TummySimAdvanced")

    if (AdvObj == nil) then
        This:ModPrint("Unable to access AdvObj", 4)
        return
    end

    local Icon = GetComponentByName(AdvObj, "UIIconComponent", "Nourishment")

    --UIManagement
    if (Icon == nil) then
        This:ModPrint("Unable to access status icon", 3)
        return
    end

    --Set Icon
    local IconPath = "mods/AdventureMode/files/TummySim/img/store_waning.png"
    local IconName = " (Barren) "

    if (Context.Health.StoredHealing >= 0.75 * Context.Settings.MaxNourishment) then
        IconPath = "mods/AdventureMode/files/TummySim/img/store_good.png"
        IconName = " (Good) "
        Context.Modifier = 0.75
    elseif (Context.Health.StoredHealing >= 0.50 * Context.Settings.MaxNourishment) then
        IconPath = "mods/AdventureMode/files/TummySim/img/store_fair.png"
        IconName = " (Satiated) "
        Context.Modifier = 0.50
    elseif (Context.Health.StoredHealing >= 0.25 * Context.Settings.MaxNourishment) then
        IconPath = "mods/AdventureMode/files/TummySim/img/store_waning.png"
        IconName = " (Meagre) "
        Context.Modifier = 0.00
    else
        IconPath = "mods/AdventureMode/files/TummySim/img/store_barren.png"
        IconName = " (Barren) "
        Context.Modifier = -0.50
    end

    ComponentSetValue2(Icon, "icon_sprite_file", IconPath)

    --Update description
    local FormattedAmount = string.format("%.1f", Context.Health.StoredHealing)
    ComponentSetValue2(Icon, "description", "Nourishment" .. IconName .. "\nStored: " .. FormattedAmount)
end

return This
