--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")
local MaximumStoredHealing = Settings.MaximumStoredHealing

--Init new module
local This = BaseModule.New("NourishmentIconController")

--Public vars
This.Modifier = 1.0

---@param Context table
function This.Tick(Context)

    local Icon = EntityGetFirstComponent(GetUpdatedEntityID(), "UIIconComponent", "NourishIcon")

    --UIManagement
    if (Icon == nil) then
        This:ModPrint("Unable to access status icon")
        return
    end

    --Set Icon
    local IconPath = "mods/AdventureMode/files/TummySim/img/store_waning.png"
    local IconName = "Nourishment (Barren) "

    if (Context.StoredHealing >= 0.65 * MaximumStoredHealing) then
        IconPath = "mods/AdventureMode/files/TummySim/img/store_good.png"
        IconName = "Nourishment (Good) "
        This.Modifier = 1.15
    elseif (Context.StoredHealing >= 0.40 * MaximumStoredHealing) then
        IconPath = "mods/AdventureMode/files/TummySim/img/store_fair.png"
        IconName = "Nourishment (Fair) "
        This.Modifier = 1.1
    elseif (Context.StoredHealing >= 0.1 * MaximumStoredHealing) then
        IconPath = "mods/AdventureMode/files/TummySim/img/store_waning.png"
        IconName = "Nourishment (Waning) "
        This.Modifier = 1.0
    else
        IconPath = "mods/AdventureMode/files/TummySim/img/store_barren.png"
        IconName = "Nourishment (Barren) "
        This.Modifier = 0.9
    end

    ComponentSetValue2(Icon, "icon_sprite_file", IconPath)

    --Update description
    local FormattedAmount = string.format("%.1f", Context.StoredHealing)
    ComponentSetValue2(Icon, "name", IconName)
    ComponentSetValue2(Icon, "description", "Stored: "..FormattedAmount)
end

return This