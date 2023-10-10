--Load dPrint
dofile_once("mods/AdventureMode/files/DebugPrint.lua")

--Entities
local Player
local CellInventory
local CellInventoryTable
local DataStorage

--Vars
local DigestionPerFrame = 500
local DigestedThisFrame

---@param Material integer
function DigestMaterial(Material)

    local Healing = 0

    --We have to do this because the table is off
    local Amount = CellInventoryTable[Material+1]
    local TotalAmount = Amount
    local MaterialString = CellFactory_GetName(Material)
    local DigestionLeftThisFrame = DigestionPerFrame - DigestedThisFrame

    if (Amount == 0) then
        dPrint("[WARNING] amount is 0 for MaterialID: "..tostring(Material).." "..MaterialString, "AdvTummySim")
    end

    if (MaterialDataTable[MaterialString]) then
        if (Amount > DigestionLeftThisFrame) then
            Amount = DigestionLeftThisFrame
        end

        --This function deceptively does not care what is already in the container and just
        --Overwrites it so we have to do the math for it
        AddMaterialInventoryMaterial(Player, MaterialString, TotalAmount - Amount)

        --Get healing
        Healing = MaterialDataTable[MaterialString] * Amount
        --Add healing
        DataStorage:ModifyStoredHealth(Healing)
        DigestedThisFrame = DigestedThisFrame + Amount

        dPrint("Digesting "..tostring(Amount).." "..MaterialString.." for "..tostring(Healing).." healing.", "AdvTummySim")
    else
        --Clear this material from the inventory
        AddMaterialInventoryMaterial(Player, MaterialString, 0)

        dPrint("Skipping material "..MaterialString, "AdvTummySim")
    end
end

---@param HealthStorage table
---@return nil
function RunDigestHeartBeat(HealthStorage)
    --Get Entities
    Player = GetUpdatedEntityID()
    CellInventory = EntityGetFirstComponent(Player, "MaterialInventoryComponent")
    DataStorage = HealthStorage

    --set variables
    DigestedThisFrame = 0

    if (CellInventory == nil) then
        dPrint("Unable to find MaterialInventory on Player", "AdvTummySim")
        return
    end

    CellInventoryTable = ComponentGetValue2(CellInventory, "count_per_material_type")

    if (CellInventoryTable == nil) then
        dPrint("CellInventoryTable is nil", "AdvTummySim")
        return
    end

    --[[
    for key, value in pairs(CellInventoryTable) do
        if (value > 0) then
            dPrint(tostring(key), tostring(value))
        end
    end
    ]]--



    --Load MaterialDataTable
    dofile_once("mods/AdventureMode/files/HungryControllerAdv/MaterialDataTable.lua")

    local Material = GetMaterialInventoryMainMaterial(Player, false)

    --Consume the material we have the most of until we've hit our cap for the frame
    while((DigestedThisFrame < DigestionPerFrame) and (Material ~= 0))
    do
        DigestMaterial(Material)
        Material = GetMaterialInventoryMainMaterial(Player, false)
    end
end

