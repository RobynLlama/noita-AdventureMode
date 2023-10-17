dofile_once("mods/AdventureMode/files/utils/ComponentUtils.lua")

--Private vars
local BaseModule = dofile_once("mods/AdventureMode/files/ObjFactory/ObjModule.lua")

--Init new module
local This = BaseModule.New("ContextUpdater", 30)

---@param Context table
function This.Tick(_, Context)
    --Check if we need updating
    local Self = GetUpdatedEntityID()
    local UpdateComponent = GetComponentByName(Self, "VariableStorageComponent", "AdventureController_NeedsUpdating")

    if (UpdateComponent) then
        NeedsUpdating = ComponentGetValue2(UpdateComponent, "value_bool")

        if (NeedsUpdating) then
            This:ModPrint("Updating Context", 1)
            Context.Settings.UpdateCache()
            ComponentSetValue2(UpdateComponent, "value_bool", false)
        end
    end
end

return This
