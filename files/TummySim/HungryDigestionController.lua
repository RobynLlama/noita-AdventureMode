--[[
    HungryDigestionController
    
    Attempts to digest whatever material is most prominent in the player's
    MaterialInventoryComponent each time Tick is called. Requires a small
    amount of satiation from the IngestionComponent to ensure the player
    hasn't "relieved" themselves from the contents of their stomach early

    TODO:
        1. Add more configuration options to the settings file
]]

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")
local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")

--Init new module
local This = BaseModule.New("TummyDigestionController")

--Entities
local Player
local CellInventory
local CellInventoryTable
local Tummy

--Vars
local DigestionPerFrame
local MaxDigestionAnyFrame = 12.5
local MinDigestionAnyFrame = math.ceil(MaxDigestionAnyFrame * 0.1)
local DigestedThisFrame
--[[
    Digesting one cell of material costs this much satiation cells

    The base game effectively handles 1 - (Ratio) cells of metabolic processes

    This should never exceed 1 because it would become impossible to empty the
    character's MaterialInventoryComponent anymore and cells would just pile up
    forever and break the system at some point
]]--
local SatiationRatio = 0.40
--This is to match a constant the game uses, do not modify
local SatiationPerCell = 6

---@param Amount number
function ConsumeSatiationForCellDigestion(Amount)
    local TummySize = ComponentGetValue2(Tummy, "ingestion_size")

    Total = TummySize - (Amount * SatiationRatio) * SatiationPerCell

    if (Total < 0) then
        Total = 0
    end

    ComponentSetValue2(Tummy, "ingestion_size", Total)
end

---@param Material integer
---@param Context table
function DigestMaterial(Material, Context)

    local Healing = 0

    --We have to do this because the table is off
    local Amount = CellInventoryTable[Material+1]

    --Never digest less than a single cell
    if (Amount < 1) then
        This:ModPrint("Skipping digestion this frame, too low contents")
        DigestedThisFrame = DigestionPerFrame
        return
    end

    local TotalAmount = Amount
    local MaterialString = CellFactory_GetName(Material)
    local DigestionLeftThisFrame = DigestionPerFrame - DigestedThisFrame
    local MaterialValue = 0
    local SkipHealing = false

    if (Amount == 0) then
        This:ModPrint("[WARNING] amount is 0 for MaterialID: "..tostring(Material).." "..MaterialString)
    end

    if (GetIsInSpecificTable(MaterialString)) then
        MaterialValue = GetSpecificMaterialValue(MaterialString)
    else
        MaterialValue = GetGenericMaterialValue(Material)
    end

    --Empty tummy means player probably vomited
    SkipHealing = (ComponentGetValue2(Tummy, "ingestion_size") == 0)

    if (MaterialValue ~= 0) then
        if (Amount > DigestionLeftThisFrame) then
            Amount = DigestionLeftThisFrame
        end

            --This function deceptively does not care what is already in the container and just
            --Overwrites it so we have to do the math for it
            AddMaterialInventoryMaterial(Player, MaterialString, TotalAmount - Amount)
            --Burn satiation for this digestion action
            ConsumeSatiationForCellDigestion(Amount)

            --Get healing
            Healing = MaterialValue * Amount

            if (SkipHealing) then
                Healing = 0
            end

            --Add healing
            Context:ModifyStoredHealth(Healing)
            DigestedThisFrame = DigestedThisFrame + Amount

            This:ModPrint("Digesting "..tostring(Amount).." "..MaterialString.." for "..tostring(Healing).." healing.")
    else
        --Clear this material from the inventory
        AddMaterialInventoryMaterial(Player, MaterialString, 0)

        --I dunno if we should consume satiation for this action or not

        This:ModPrint("Skipping material "..MaterialString)
    end
end

---@param Context table
function This.Tick(Context)
    --Get Entities
    Player = GetUpdatedEntityID()
    CellInventory = EntityGetFirstComponent(Player, "MaterialInventoryComponent")
    Tummy = EntityGetFirstComponent(Player, "IngestionComponent")

    --I see you, polymorph bug in the making
    if (Tummy == nil) then
        return
    end

    --set variables
    DigestedThisFrame = 0
    DigestionPerFrame = MaxDigestionAnyFrame

    --Set digestion to the max we can handle if we are low on satiation
    local IngestionCells = ComponentGetValue2(Tummy, "ingestion_size") / SatiationPerCell
    local MaxDigestionFromSat = IngestionCells * (1 / SatiationRatio)
    if (DigestionPerFrame > MaxDigestionFromSat) then
        This:ModPrint("Digestion: "..tostring(DigestionPerFrame).." is too high for satiation: "..tostring(MaxDigestionFromSat))
        DigestionPerFrame = MaxDigestionFromSat
    end

    --Set digestion to low if we're at max healing
    if (Context.StoredHealing == Settings.MaxNourishment) or (MaxDigestionFromSat < MinDigestionAnyFrame) then
        This:ModPrint("Slow digestion this frame (Full healing or empty tummy)")
        DigestionPerFrame = MinDigestionAnyFrame
    end

    if (CellInventory == nil) then
        This:ModPrint("Unable to find MaterialInventory on Player")
        return
    end

    CellInventoryTable = ComponentGetValue2(CellInventory, "count_per_material_type")

    if (CellInventoryTable == nil) then
        This:ModPrint("CellInventoryTable is nil")
        return
    end

    --[[
    for key, value in pairs(CellInventoryTable) do
        if (value > 0) then
            print(tostring(key), tostring(value))
        end
    end
    ]]--

    --Load MaterialDataTable
    dofile_once("mods/AdventureMode/files/TummySim/MaterialDataTable.lua")

    local Material = GetMaterialInventoryMainMaterial(Player, false)

    --Consume the material we have the most of until we've hit our cap for the frame
    while((DigestedThisFrame < DigestionPerFrame) and (Material ~= 0))
    do
        DigestMaterial(Material, Context)
        Material = GetMaterialInventoryMainMaterial(Player, false)
    end
end

return This