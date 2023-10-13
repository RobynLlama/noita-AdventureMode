--[[
    SharedContext

    Since the top level LUA script always gets run outside of a do_file_once we
    need to use a seperate file to create the context or all values just get reset
    each time
]]

local BlockHandler = {
    BlockedUntil = 0
}

---@param Self table
function BlockHandler.BlockHealing(Self)
    Self.BlockedUntil = GameGetFrameNum() + 59
end

---@param Self table
---@return boolean
function BlockHandler.IsHealingBlocked(Self)
    return not (GameGetFrameNum() > Self.BlockedUntil)
end

local Context = {
    Modifier = 0,
    HealBlocker = BlockHandler,
}

return Context