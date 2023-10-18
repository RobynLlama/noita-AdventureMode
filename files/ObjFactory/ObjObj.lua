dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

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

--MetaFunction
function ThisFactory.MetaFunction(Table, Index)
    --print(string.format("%s searching for index %s in %s", Table, Index, ThisFactory.Name))
    return ThisFactory[Index]
end

---Initializes the calling table as an object
---@param ObjName string
---@return table
function ThisFactory.New(ObjName)
    local NewObject = {}

    --Setup Members
    NewObject.Name = ObjName

    --Set the metatable to point to us
    setmetatable(NewObject, { __index = ThisFactory.MetaFunction });

    --Set parent
    NewObject.Parent = ThisFactory

    return NewObject
end

return ThisFactory
