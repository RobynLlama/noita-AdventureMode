--[[
    SharedContext

    Helper to initialize the Context state for Tummysim
]]

local Settings = dofile_once("mods/AdventureMode/files/utils/SettingsCache.lua")

local Modules = {}

local Context = {
    Modifier = 0,
    Settings = Settings,
    Modules = Modules,
}

return Context
