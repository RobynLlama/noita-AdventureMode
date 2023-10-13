dofile_once("mods/AdventureMode/files/DebugPrint.lua")

--[[
    ObjModule

    Members
        UpdateNext
        UpdateEvery


    Methods
        Tick
        TickOnTimer
]]

local ThisFactory = {}
local BaseObj = dofile_once("mods/AdventureMode/files/ObjFactory/ObjObj.lua")

BaseObj.New("BaseModule")

---@param This table
---@param Context table
function ThisFactory.Tick(This, Context)
    ThisFactory:ModPrint("Undefined tick called on child of ObjModule", 2)
end

---@param This table
---@param Context table
function ThisFactory.TickOnTimer(This, Context)
    --Check if we're ready to update
    local frame = GameGetFrameNum()
    if (frame >= This.UpdateNext) then
        This.UpdateNext = frame + This.UpdateEvery
        This.Tick(Context)
    end
end

---Initializes the calling object as a module
---@param ObjName string
---@return table
function ThisFactory.New(ObjName, Ticks)

    --Give access to our parent
    local NewObject = BaseObj.New(ObjName)

    --Give access to our methods/members
    NewObject.UpdateEvery = Ticks
    NewObject.UpdateNext = GameGetFrameNum() + Ticks
    NewObject.Tick = ThisFactory.Tick
    NewObject.TickOnTimer = ThisFactory.TickOnTimer

    --Set parent type to Module
    NewObject.Parent = ThisFactory

    return NewObject
end

return ThisFactory