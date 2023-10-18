--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local ObjectName = "WonderSystem"
local AllWonderItems = {}
local EquippedItems = {}

--Global Slot ENUM
WONDER_SLOT_HEAD = 1
WONDER_SLOT_BODY = 2
WONDER_SLOT_FEET = 3
WONDER_SLOT_OUTER_BODY = 4
WONDER_SLOT_FINERY = 5
WONDER_SLOT_CARRIED = 6

--Init new module
local This = BaseModule.New("WonderController", 2)

function LoadData()
    local Entity = GetUpdatedEntityID()
    local DataObj = GetChildByName(Entity, ObjectName)
    local CompType = "VariableStorageComponent"

    if (DataObj == nil) then
        This:ModPrint("Unable to fetch WonderSystem", 4)
        return
    end

    ---@param EquipType string
    function FetchItem(EquipType)
        local DataComp = GetComponentByName(DataObj, CompType, EquipType)

        if (DataComp == nil) then
            This:ModPrint(string.format("Missing datacomp: %s", EquipType), 3)
            return
        end

        local ID = ComponentGetValue2(DataComp, "value_string")
        local IsEquipped = ComponentGetValue2(DataComp, "value_bool")

        if (IsEquipped) then
            EquipItem(ID, false)
        end
    end

    FetchItem("EQUIP_HEAD")
    FetchItem("EQUIP_BODY")
    FetchItem("EQUIP_FEET")
    FetchItem("EQUIP_OUTER_BODY")
    FetchItem("EQUIP_FINERY")
    FetchItem("EQUIP_CARRIED")
end

---@param WonderItem table
function RegisterWonderItem(WonderItem)
    This:ModPrint(string.format("Registered item: %s", WonderItem.EquipID), 1)
    AllWonderItems[WonderItem.EquipID] = WonderItem
end

---Initializes the wonder controller and adds default items. Modders: Detour this function to add new items
---@param EntityID integer
---@param Context table
function This.Init(EntityID, Context)
    --Only at the beginning of the game
    if (GameGetFrameNum() < 12) then
        EntityAddChild(GetUpdatedEntityID(), EntityLoad("mods/AdventureMode/files/Items/Wonders/WonderController.xml"))
    end

    RegisterWonderItem(dofile_once("mods/AdventureMode/files/Items/Wonders/WonderItemBoots.lua"))
end

---@param EquipID string
---@param DoEffect boolean
function EquipItem(EquipID, DoEffect)
    if (AllWonderItems[EquipID]) then
        local Item = AllWonderItems[EquipID]

        if (EquippedItems[Item.SlotID]) then
            UnEquipItem(Item.SlotID)
        end

        EquippedItems[Item.SlotID] = Item

        if (DoEffect) then
            Item:OnEquip(GetUpdatedEntityID())
        end
    end
end

---@param ItemSlot integer
function UnEquipItem(ItemSlot)
    if (EquippedItems[ItemSlot]) then
        EquippedItems[ItemSlot]:OnUnEquip(GetUpdatedEntityID())
        EquippedItems[ItemSlot] = nil
    end
end

function FindAndEquipNewItem()
    local Inventory = GetChildByName(GetUpdatedEntityID(), "inventory_quick")

    if (Inventory) then
        local NewItem = GetChildByName(Inventory, "WonderEquipment")

        if (NewItem) then
            local ItemInfoComp = GetComponentByName(NewItem, "VariableStorageComponent", "WonderItemData")

            if (ItemInfoComp) then
                EquipItem(ComponentGetValue2(ItemInfoComp, "value_string"), true)
                EntityKill(NewItem)
            end
        end
    end
end

---@param Context table
function This.Tick(_, Context)
    --Tick each item that is equipped
    if (EquippedItems[WONDER_SLOT_HEAD]) then
        EquippedItems[WONDER_SLOT_HEAD]:TickOnTimer(Context)
    end
    if (EquippedItems[WONDER_SLOT_BODY]) then
        EquippedItems[WONDER_SLOT_BODY]:TickOnTimer(Context)
    end
    if (EquippedItems[WONDER_SLOT_FEET]) then
        EquippedItems[WONDER_SLOT_FEET]:TickOnTimer(Context)
    end
    if (EquippedItems[WONDER_SLOT_OUTER_BODY]) then
        EquippedItems[WONDER_SLOT_OUTER_BODY]:TickOnTimer(Context)
    end
    if (EquippedItems[WONDER_SLOT_FINERY]) then
        EquippedItems[WONDER_SLOT_FINERY]:TickOnTimer(Context)
    end
    if (EquippedItems[WONDER_SLOT_CARRIED]) then
        EquippedItems[WONDER_SLOT_CARRIED]:TickOnTimer(Context)
    end

    --Find and equip new items
    FindAndEquipNewItem()
end

return This
