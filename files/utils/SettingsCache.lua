--[[
    Settings Cache
    
    Will cache all the mod settings in one place to avoid the overhead of reading
    them every update for certain components
]]

--dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

local Cache = {
    TummyChanged = false,
    TummyType = "NOTYPE",
}

function Cache.UpdateCache() 
    --Adventure Settings
    Cache.StartWithPouch = ModSettingGet("AdventureMode.StartingItems_Pouch")
    Cache.StartWithMeal = ModSettingGet("AdventureMode.StartingItems_Meal")
    Cache.NewSpells = ModSettingGet("AdventureMode.Adventure_NewSpells")
    
    --Tummy Type Change detection
    Cache.TummyType = ModSettingGet("AdventureMode.TummySimType")

    Cache.HealBlockFrames = tonumber(ModSettingGet("AdventureMode.RegenHealBlockFrames"))
    Cache.HealBlockFrames = math.floor(Cache.HealBlockFrames + 0.5)

    --Basic Tummy Settings
    Cache.SatietyCostForEachPercent = tonumber(ModSettingGet("AdventureMode.CostForPercent"))
    Cache.MaxHealthRestoredPerFrame = tonumber(ModSettingGet("AdventureMode.MaxHealPerFrame"))
    
    --Advanced Tummy Settings
    Cache.MaxNourishment = tonumber(ModSettingGet("AdventureMode.Adv_MaxNourishment"))
    Cache.StartingNourshment = tonumber(ModSettingGet("AdventureMode.Adv_StartingNourishment"))/100
        --Experimental Settings
        Cache.ExpSatiationRatio = tonumber(ModSettingGet("AdventureMode.Exp_SatiationRatio"))
        Cache.ExpSatiationTarget = tonumber(ModSettingGet("AdventureMode.Exp_SatiationTarget"))

    --Debug
    Cache.DebugPrintingLevel = ModSettingGet("AdventureMode.DebugPrintingLevel")
end

--Initialize
Cache.UpdateCache()

return Cache