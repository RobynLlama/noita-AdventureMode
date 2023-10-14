--[[
    Sets potion capacity properly since the default script always
    overwrites the capacity to 1000 for some reason
]]

local Entity = GetUpdatedEntityID()
local components = EntityGetComponent( Entity, "VariableStorageComponent")

if( components ~= nil ) then
    for _ , comp_id in pairs(components) do 
        local var_name = ComponentGetValue2( comp_id, "name" )
        if( var_name == "potion_material") then
            potion_material = ComponentGetValue2( comp_id, "value_string" )
            potion_capacity = ComponentGetValue2( comp_id, "value_float" )
        end
    end
end

if (potion_material == nil) or (potion_capacity == nil) then
    return
end

--Set material amount
AddMaterialInventoryMaterial(Entity, potion_material, potion_capacity)