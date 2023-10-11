dofile_once("mods/AdventureMode/files/DebugPrint.lua")

--[[
    ObjModule

    Methods
        Tick
]]

local ThisFactory = {}
local BaseObj = dofile_once("mods/AdventureMode/files/ObjFactory/ObjObj.lua")

BaseObj.New("BaseModule")

---@param This table
---@param Context table
function ThisFactory.Tick(This, Context)
    ThisFactory:ModPrint("Undefined tick called on child of ObjModule")
end

---Initializes the calling object as a module
---@param ObjName string
---@return table
function ThisFactory.New(ObjName)

    local NewObject = BaseObj.New(ObjName)

    --Give access to our members
    NewObject.Tick = ThisFactory.Tick

    --Set parent type to Module
    NewObject.Parent = ThisFactory

    return NewObject
end

return ThisFactory