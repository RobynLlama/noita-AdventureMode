dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

--[[
    ObjModule

    Members
        UpdateNext
        UpdateEvery
        EventCallBacks

    Methods
        Init
        Tick
        TickOnTimer
]]

local BaseObj = dofile_once("mods/AdventureMode/files/ObjFactory/ObjObj.lua")
local ThisFactory = BaseObj.New("BaseModule")

ThisFactory.Ticks = -1

---@param This table
---@param Context table
function ThisFactory.Tick(This, Context)
    ThisFactory:ModPrint("Undefined tick called on child of ObjModule", 2)
end

---@param This table
---@param Context table
function ThisFactory.TickOnTimer(This, Context)
    --Some modules will opt out of tick updates
    if (This.UpdateEvery < 0) then
        return
    end
    
    --Check if we're ready to update
    local frame = GameGetFrameNum()
    if (frame >= This.UpdateNext) then
        This.UpdateNext = frame + This.UpdateEvery
        This:Tick(Context)
    end
end

---@param This table
---@param CallBackID string
---@param CallBackFn function
function ThisFactory.AddCallback(This, CallBackID, CallBackFn)
    This.EventCallBacks[CallBackID] = CallBackFn
end

---@param EntityID integer
function ThisFactory.Init(EntityID, Context)
end

--MetaFunction
function ThisFactory.MetaFunction(Table, Index)
    --print(string.format("%s searching for index %s in %s", Table, Index, ThisFactory.Name))
    return ThisFactory[Index]
end

---Initializes the calling object as a module
---@param ObjName string
---@return table
function ThisFactory.New(ObjName, Ticks)
    --Give access to our parent
    local NewObject = BaseObj.New(ObjName)

    if (Ticks == nil) then
        ThisFactory:ModPrint(string.format("Nil ticks value in %s", ObjName), 2)
        Ticks = -1
    end

    --Give access to our methods/members
    NewObject.UpdateEvery = Ticks
    NewObject.UpdateNext = GameGetFrameNum() + Ticks
    NewObject.EventCallBacks = {}
    --Methods

    --Set the metatable to point to us
    setmetatable(NewObject,{ __index = ThisFactory.MetaFunction });

    --Set parent type to Module
    NewObject.Parent = ThisFactory

    return NewObject
end

return ThisFactory
