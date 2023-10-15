---Gets a specific named child entity from the given Entity
---@param Entity integer
---@param ChildName string
---@return integer?
function GetChildByName(Entity, ChildName)
    local Children = EntityGetAllChildren(Entity)

    if (Children == nil) then
        return nil
    end

    for _, Child in pairs(Children) do
        if (EntityGetName(Child) == ChildName) then
            return Child
        end
    end

    return nil
end

---Gets a specific named component from the given Entity
---@param Entity integer
---@param ComponentType string
---@param ComponentName string
---@return integer?
function GetComponentByName(Entity, ComponentType, ComponentName)
    local Components = EntityGetComponentIncludingDisabled(Entity, ComponentType)

    if (Components == nil) then
        return nil
    end

    for _, Comp in pairs(Components) do
        if (ComponentGetValue2( Comp, "name" ) == ComponentName) then
            return Comp
        end
    end

    return nil
end