dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

--[[
    ObjWonderItem

    Members
        EntityPath
        EquipID
        SlotID

    Methods
        OnEquip
        OnUnEquip
]]

--[[
    SlotID Enum
    1 = Head (Crowns, Circlets, Diadems, Hats, Helms, Coifs)
    2 = Body (Robes, Clothes, Coats, Mail)
    3 = Feet (Boots, Slippers, Anklets, Hose, Sandals)
    4 = OuterBody (Capes, Amulets, Tabbards, Belts, Bandoliers, Sashes)
    5 = Finery (Rings, Bracelets, Thighlets, Gloves, Glasses, Hairpins, Earrings)
    6 = Carried (Censers, Scepters, Shields, Lamps/Lanters, Orbs/Crystals)
]]

local BaseObj = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local ThisFactory = BaseObj.New("BaseModule", -1)

BaseObj.New("BaseWonderItem")

function ThisFactory.OnEquip(This, Entity)
    GamePrint(string.format("%s equipped", This.FriendlyName))
end

function ThisFactory.OnUnEquip(This, Entity)
    GamePrint(string.format("%s removed", This.FriendlyName))
end

--MetaFunction
function ThisFactory.MetaFunction(Table, Index) 
    --print(string.format("%s searching for index %s in %s", Table, Index, ThisFactory.Name))
    return ThisFactory[Index]
end

---Initializes the calling object as a WonderItem
---@param EquipID string
---@param FriendlyName string
---@param SlotID integer
---@param Ticks integer
---@return table
function ThisFactory.New(EquipID, FriendlyName, SlotID, Ticks)
    --Give access to our parent
    local NewObject = BaseObj.New(EquipID, Ticks)

    --Give access to our methods/members
    NewObject.UpdateEvery = Ticks
    NewObject.UpdateNext = GameGetFrameNum() + Ticks
    NewObject.EquipID = EquipID
    NewObject.SlotID = SlotID
    NewObject.FriendlyName = FriendlyName
    --Methods

    --Set the metatable to point to us
    setmetatable(NewObject,{ __index = ThisFactory.MetaFunction });

    --Set parent type to WonderItem
    NewObject.Parent = ThisFactory

    return NewObject
end

return ThisFactory
