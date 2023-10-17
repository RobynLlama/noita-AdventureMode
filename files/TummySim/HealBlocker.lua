local BlockHandler = {
    BlockedUntil = 0
}

---@param Self table
function BlockHandler.BlockHealing(Self, Seconds)
    Self.BlockedUntil = GameGetFrameNum() + Seconds * 60
end

---@param Self table
---@return boolean
function BlockHandler.IsHealingBlocked(Self)
    return not (GameGetFrameNum() > Self.BlockedUntil)
end

return BlockHandler