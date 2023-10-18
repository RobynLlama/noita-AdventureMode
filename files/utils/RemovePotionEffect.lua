--[[
    RemovePotionEffect

    Attach to new items that have a potion effect pickup and it will be magically
    removed. Wow, so good script
]]

dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")

local Entity = GetUpdatedEntityID()
local Scripts = EntityGetComponent(Entity, "LuaComponent")

dPrint("examining scripts count: " .. tostring(Scripts), "RemovePotionEffect", 1)

if (Scripts) then
    for _, Script in pairs(Scripts) do
        if (ComponentGetValue2(Script, "script_item_picked_up") == "data/scripts/items/potion_effect.lua") then
            EntityRemoveComponent(Entity, Script)
            dPrint("effect deleted", "RemovePotionEffect", 1)
            break
        else
            dPrint("skipping script id " .. tostring(Script), "RemovePotionEffect", 1)
        end
    end
end
