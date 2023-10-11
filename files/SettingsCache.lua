--[[
    Settings Cache
    
    Will cache all the mod settings in one place to avoid the overhead of reading
    them every update for certain components
]]

local Cache = {
    TummyType = ModSettingGet("AdventureMode.TummySimType"),
    StartWithPouch = ModSettingGet("AdventureMode.StartingItems_Pouch"),
    DebugPrinting = ModSettingGet("AdventureMode.DebugPrinting"),
    MaximumStoredHealing = ModSettingGet("AdventureMode.Adv_MaxStoredHealing"),
    SatietyCostForEachPercent = tonumber(ModSettingGet("AdventureMode.CostForPercent")),
    MaxHealthRestoredPerFrame = tonumber(ModSettingGet("AdventureMode.MaxHealPerFrame"))
}

function Cache.UpdateCache() 
    Cache.TummyType = ModSettingGet("AdventureMode.TummySimType")
    Cache.StartWithPouch = ModSettingGet("AdventureMode.StartingItems_Pouch")
    Cache.DebugPrinting = ModSettingGet("AdventureMode.DebugPrinting")
    Cache.MaximumStoredHealing = ModSettingGet("AdventureMode.Adv_MaxStoredHealing")
    Cache.SatietyCostForEachPercent = tonumber(ModSettingGet("AdventureMode.CostForPercent"))
    Cache.MaxHealthRestoredPerFrame = tonumber(ModSettingGet("AdventureMode.MaxHealPerFrame"))
end

return Cache