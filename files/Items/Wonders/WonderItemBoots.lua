--Private vars
local BaseItem = dofile_once("mods/AdventureMode/files/ObjFactory/ObjWonderItem.lua")
local This = BaseItem.New("WonderItem_BootsOfLeaping", "Boots of Leaping", WONDER_SLOT_FEET, -1)

--store defaults
local DefaultJumpX = 56.0
local DefaultJumpY = -95.0

--store enhanced
local EnhancedJumpX = 250.0
local EnhancedJumpY = -190.0

function This.OnEquip(_, Entity)
    local Comp = EntityGetFirstComponent(Entity, "CharacterPlatformingComponent")

    if (Comp) then
        ComponentSetValue2(Comp, "jump_velocity_x", EnhancedJumpX)
        ComponentSetValue2(Comp, "jump_velocity_y", EnhancedJumpY)
    end
    This.Parent.OnEquip(This, Entity)
end

function This.OnUnEquip(_, Entity)
    local Comp = EntityGetFirstComponent(Entity, "CharacterPlatformingComponent")

    if (Comp) then
        ComponentSetValue2(Comp, "jump_velocity_x", DefaultJumpX)
        ComponentSetValue2(Comp, "jump_velocity_y", DefaultJumpY)
    end
    This.Parent.OnUnEquip(This, Entity)
end

return This
