--[[
    Settings Cache
    
    Will cache all the mod settings in one place to avoid the overhead of reading
    them every update for certain components

    Todo:
        Refresh these settings after the player has unpaused using OnPausedChanged?
        OnModSettingsChanged() doesn't work so we gotta hack around it
]]

local Cache = {}

function Cache.UpdateCache() 
    --Adventure Settings
    Cache.StartWithPouch = ModSettingGet("AdventureMode.StartingItems_Pouch")
    
    --Tummy Settings
    Cache.TummyType = ModSettingGet("AdventureMode.TummySimType")

    --Basic Tummy Settings
    Cache.SatietyCostForEachPercent = tonumber(ModSettingGet("AdventureMode.CostForPercent"))
    Cache.MaxHealthRestoredPerFrame = tonumber(ModSettingGet("AdventureMode.MaxHealPerFrame"))
    
    --Advanced Tummy Settings
    Cache.MaxNourishment = tonumber(ModSettingGet("AdventureMode.Adv_MaxNourishment"))
    Cache.StartingNourshment = tonumber(ModSettingGet("AdventureMode.Adv_StartingNourishment"))/100
        --Experimental Settings
        Cache.ExpSatiationRatio = tonumber(ModSettingGet("AdventureMode.Exp_SatiationRatio"))
        Cache.ExpDigestionRate = tonumber(ModSettingGet("AdventureMode.Exp_DigestionRate"))

    --Debug
    Cache.DebugPrinting = ModSettingGet("AdventureMode.DebugPrinting")
end

--Initialize
Cache.UpdateCache()

return Cache