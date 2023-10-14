--[[
    SharedContext

    Helper to initialize the Context state for Tummysim
]]

local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")

local BlockHandler = {
    BlockedUntil = 0
}

---@param Self table
function BlockHandler.BlockHealing(Self)
    Self.BlockedUntil = GameGetFrameNum() + Settings.HealBlockFrames * 60
end

---@param Self table
---@return boolean
function BlockHandler.IsHealingBlocked(Self)
    return not (GameGetFrameNum() > Self.BlockedUntil)
end

local Context = {
    Modifier = 0,
    HealBlocker = BlockHandler,
    Settings = Settings,
    Initialized = true,
}

return Context