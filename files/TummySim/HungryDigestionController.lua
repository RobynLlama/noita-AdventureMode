--[[
    HungryDigestionController
    
    Attempts to digest whatever material is most prominent in the player's
    MaterialInventoryComponent each time Tick is called. Requires a small
    amount of satiation from the IngestionComponent to ensure the player
    hasn't "relieved" themselves from the contents of their stomach early

    TODO:
        1. Possibly use material value to modify SatiationRatio
            This would have the effect of making junkier food use
            less satiation and make it harder to heal with ex: water
        2. Possibly stop digestion when the ingestion component is
            on cooldown
]]

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")
dofile_once("mods/AdventureMode/files/TummySim/MaterialDataTable.lua")

--Init new module
local This = BaseModule.New("TummyDigestionController", 10)

--How much Satiation we want to spend from the MaterialInventory each frame
local SatiationMaxAnyUpdate = Settings.ExpSatiationTarget
--Modifier for Satiation cost per cell
local CellWasteRatio = Settings.ExpSatiationRatio
--This is to match a constant the game uses, do not modify
local SatiationPerCell = 6

---@param Material integer
---@param Amount number
---@return number
function GetHealingAmount(Material, Amount)
    return TryGetMaterialValue(Material) * Amount
end

---@param Material integer
---@param Amount number
---@return number
function GetSatiationCostToDigest(Material, Amount)
    local mValue = TryGetMaterialValue(Material)

    if (mValue < 0) then
        mValue = 0
    end

    return SatiationPerCell * (1 - mValue) * Amount
end

---@param Material integer
---@param Satiety number
---@return number
function GetDigestableAmount(Material, Satiety)
    local CostPerUnit = GetSatiationCostToDigest(Material, 1)
    return Satiety / CostPerUnit
end

---@param Context table
function This.Tick(Context)
    --Get Entities
    local Player = GetUpdatedEntityID()
    local CellInventory = EntityGetFirstComponent(Player, "MaterialInventoryComponent")
    local Tummy = EntityGetFirstComponent(Player, "IngestionComponent")

    --I see you, polymorph bug in the making
    if (Tummy == nil) then
        This:ModPrint("Player is probably polymorphed, skipping digestion", 1)
        return
    end

    if (CellInventory == nil) then
        This:ModPrint("CellInventory missing on player", 3)
        return
    end

    local CellInventoryTable = ComponentGetValue2(CellInventory, "count_per_material_type")
    if (CellInventoryTable == nil) then
        This:ModPrint("CellInventoryTable doesn't exist on player", 4)
        return
    end

    --set variables
    local SatiationThisUpdate = 0
    local Satiation = ComponentGetValue2(Tummy, "ingestion_size")
    local NextMaterial = GetMaterialInventoryMainMaterial(Player, false)
    local MaxStorage = Settings.MaxNourishment

    --Main loop
    while (NextMaterial > 0) and (SatiationThisUpdate < SatiationMaxAnyUpdate) do
        --Consume materials

        --Seriously reduce digestion if we're at max healing
        if (Context.StoredHealing == MaxStorage) then
            SatiationThisUpdate = SatiationThisUpdate + (SatiationMaxAnyUpdate * 0.7)
            This:ModPrint("Slow digestion this frame", 1)
        end

        --We have to do this because the table is off by 1 (??)
        local Amount = CellInventoryTable[NextMaterial+1]
        local TotalAmount = Amount
        local MaxAmount = GetDigestableAmount(NextMaterial, SatiationMaxAnyUpdate - SatiationThisUpdate)

        --Trim the amount we're digesting if it is too high
        if (MaxAmount < Amount) then
            Amount = MaxAmount
        end

        local Cost = GetSatiationCostToDigest(NextMaterial, Amount)

        This:ModPrint("Material "..tostring(CellFactory_GetName(NextMaterial).." amount: "..tostring(Amount).." cost: "..tostring(Cost)), 1)

        SatiationThisUpdate = SatiationThisUpdate + Cost
        
        --Don't do health/tummy if tummy is empty
        if(Satiation > 0) then
            --Modify health storage
            Context:ModifyStoredHealth(GetHealingAmount(NextMaterial, Amount))
            --Modify tummy storage
            ComponentSetValue2(Tummy, "ingestion_size", Satiation - (Cost * CellWasteRatio))

            This:ModPrint("Added to health storage this update", 1)

            --Modify material inventory
            AddMaterialInventoryMaterial(Player, CellFactory_GetName(NextMaterial), TotalAmount - Amount)
        else
            --Clear material inventory, tummy is empty
            AddMaterialInventoryMaterial(Player, CellFactory_GetName(NextMaterial), 0)
            This:ModPrint("Cleared a material inventory due to empty tummy", 1)
        end

        --Update our control values
        Satiation = ComponentGetValue2(Tummy, "ingestion_size")
        NextMaterial = GetMaterialInventoryMainMaterial(Player, false)
    end
end

return This