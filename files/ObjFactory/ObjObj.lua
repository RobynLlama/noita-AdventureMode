dofile_once("mods/AdventureMode/files/DebugPrint.lua")

--[[
    ObjObj

    Members
        Name
        Parent

    Methods
        ModPrint
        New
]]

local ThisFactory = {}

--Public vars
ThisFactory.Name = "ObjObj"
ThisFactory.Parent = nil

function ThisFactory.ModPrint(This, Message, Level)
    if (not This.Name) then
        dPrint(Message, "[NameMissing]", Level)
        return
    end

    dPrint(Message, This.Name, Level)
end

---Initializes the calling table as an object
---@param ObjName string
---@return table
function ThisFactory.New(ObjName)

    local NewObject = {}

    --Setup Members
    NewObject.Name = ObjName

    --Give Access to methods
    NewObject.ModPrint = ThisFactory.ModPrint

    --Set parent
    NewObject.Parent = ThisFactory

    return NewObject
end

return ThisFactory