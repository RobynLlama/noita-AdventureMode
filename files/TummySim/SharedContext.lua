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

local Controller = {
    Type = nil,
}

function Controller.ForceUpdate(Self)
    if (Settings.TummyType == "BAS") then
        Self.Type = dofile_once("mods/AdventureMode/files/TummySim/BasicController.lua")
    else
        Self.Type = dofile_once("mods/AdventureMode/files/TummySim/AdvancedController.lua")
    end
end

Controller:ForceUpdate()

local Context = {
    Modifier = 0,
    HealBlocker = BlockHandler,
    Settings = Settings,
    Controller = Controller,
    Initialized = true,
}

return Context