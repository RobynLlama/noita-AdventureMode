--[[
    Sets potion capacity properly since the default script always
    overwrites the capacity to 1000 for some reason
]]

dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")


local OriginalInit = init

function DetourInit(Entity)
    --Run the original init first
    OriginalInit(Entity)

    local components = EntityGetComponent(Entity, "VariableStorageComponent")
    local potion_material
    local potion_capacity
    local potion_clear

    dPrint("Running on Entity: " .. tostring(Entity), "PotionVariableCapacity", 1)
    if (components ~= nil) then
        dPrint("Found VariableStorageComponent", "PotionVariableCapacity", 1)
        for _, comp_id in pairs(components) do
            local var_name = ComponentGetValue2(comp_id, "name")
            if (var_name == "potion_material") then
                potion_material = ComponentGetValue2(comp_id, "value_string")
                potion_capacity = ComponentGetValue2(comp_id, "value_float")
                potion_clear = ComponentGetValue2(comp_id, "value_bool")
            end
        end
    end

    if (potion_clear) then
        dPrint("Running potion clear", "PotionVariableCapacity", 1)
        --Clear any other material and set it to the amount we specified
        local Material = GetMaterialInventoryMainMaterial(Entity, false)
        while (Material > 0) do
            dPrint("Clearing " .. CellFactory_GetName(Material), "PotionVariableCapacity", 1)
            AddMaterialInventoryMaterial(Entity, CellFactory_GetName(Material), 0)
            Material = GetMaterialInventoryMainMaterial(Entity, false)
        end
    end

    if (potion_material == nil) or (potion_capacity == nil) then
        return
    end

    dPrint("Adding new material", "PotionVariableCapacity", 1)
    AddMaterialInventoryMaterial(Entity, potion_material, potion_capacity)
end

init = DetourInit
