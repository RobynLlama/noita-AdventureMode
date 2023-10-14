--[[
Module: AdventureMode
Authors: MamaLlama, Flowerful
Licensing:
	This module and all of it component files are provied under the CC-BY-NC-4 license
	A short and simple summary may be found at the following web address:
	https://www.creativecommons.org/licenses/by-nc/4.0/deed.en

	See the full legal code here:
	https://www.creativecommons.org/licenses/by-nc/4.0/legalcode.en
]]--

dofile_once("mods/AdventureMode/files/DebugPrint.lua")
local Settings = dofile_once("mods/AdventureMode/files/SettingsCache.lua")

-- all functions below are optional and can be left out
--[[

function OnModPreInit()
	print("Mod - OnModPreInit()") -- First this is called for all mods
end

function OnModInit()
	print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
	print("Mod - OnModPostInit()") -- Then this is called for all mods
end

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	GamePrint( "OnPlayerSpawned() - Player entity id: " .. tostring(player_entity) )
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
	GamePrint( "OnWorldInitialized() " .. tostring(GameGetFrameNum()) )
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
	GamePrint( "Pre-update hook " .. tostring(GameGetFrameNum()) )
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
	GamePrint( "Post-update hook " .. tostring(GameGetFrameNum()) )
end

]]--

--Update the tummy controller
function CreateOrUpdateTummyController(SendSignals)

	local Player = EntityGetWithTag( "player_unit" )[1]

	--Fetch controllers for checking
	local TummyController = EntityGetFirstComponent(Player, "LuaComponent", "TummySimController")
	local Icon = EntityGetFirstComponentIncludingDisabled(Player, "UIIconComponent", "NourishIcon")
	local Storage = EntityGetFirstComponent(Player, "VariableStorageComponent", "HungryStorageComponent")

	dPrint("SimType="..tostring(Settings.TummyType), "UpdateTummyController", 1)

	---@param AddController boolean
	---@param AddIcon boolean
	---@param AddStorage boolean
	function SetControllerComponentStates(AddController, AddIcon, AddStorage)

		dPrint("Setting Controller States", "UpdateTummyController", 1)

		--Do we want the controller?
		if (AddController) then
			dPrint("Adding Controller", "UpdateTummyController", 1)

			if (TummyController ~= nil) then
				--Always cycle the controller here, it needs to dofile again to change its type
				EntityRemoveComponent(Player, TummyController)
			end

			EntityLoadToEntity("mods/AdventureMode/files/TummySim/TummyController.xml", Player)
		else
			dPrint("Removing Controller", "UpdateTummyController", 1)
			if (TummyController ~= nil) then
				EntityRemoveComponent(Player, TummyController)
			end
		end

		if (AddIcon) then
			dPrint("Add Icon", "UpdateTummyController", 1)
			if (Icon == nil) then
				EntityLoadToEntity("mods/AdventureMode/files/TummySim/TummyIcon.xml", Player)
			end
		else
			dPrint("Removing Icon", "UpdateTummyController", 1)
			if (Icon ~= nil) then
				EntityRemoveComponent(Player, Icon)
			end
		end

		if (AddStorage) then
			dPrint("Add Storage", "UpdateTummyController", 1)
			if (Storage == nil) then
				EntityLoadToEntity("mods/AdventureMode/files/TummySim/TummyStorage.xml", Player)
			end
		else
			dPrint("Removing Storage", "UpdateTummyController", 1)
			if (Storage ~= nil) then
				EntityRemoveComponent(Player, Storage)
			end
		end
	end

	--Send an update signal to the component hosting our controller
	function SendUpdateSignal()

		if (not SendSignals) then
			return
		end

		TummyController = EntityGetFirstComponent(Player, "LuaComponent", "TummySimController")

		if (TummyController ~= nil) then
			--Flick the lights, as it were
			EntitySetComponentIsEnabled(Player, TummyController, false)
			EntitySetComponentIsEnabled(Player, TummyController, true)
		end
	end

	local States = {
		["OFF"] = function() SetControllerComponentStates(false, false, false) end,
		["BAS"] = function() SetControllerComponentStates(true, false, false) SendUpdateSignal() end,
		["ADV"] = function() SetControllerComponentStates(true, true, true) SendUpdateSignal() end
	}

	States[Settings.TummyType]()
	Settings.TummyChanged = false
end

--Assume the player has modified mod settings in the pause screen cuz there is no way to know
function OnPausedChanged( is_paused, is_inventory_pause)
	--If the player is unpausing
	if (not is_paused) then
		Settings.UpdateCache()

		if (Settings.TummyChanged) then
			CreateOrUpdateTummyController(true)
		end
	end
end

function OnPlayerSpawned(player_entity)
	dPrint("Frame: "..tostring(GameGetFrameNum()), "Init", 1)

	CreateOrUpdateTummyController(false)

	--This is the sloppy way I check if we're at the start of a run
	--Always seems to start at frame 10 when I try so we'll see
	if (GameGetFrameNum() < 12) then
		
		--Powder bag starting item
		if (Settings.StartWithPouch) then
			local powder_bag = EntityLoad("mods/AdventureMode/files/StartingItems/RandomPouch.xml")
			GamePickUpInventoryItem(player_entity, powder_bag, true)
		end

		--Set starting nourishment
		local Storage = EntityGetFirstComponent(player_entity, "VariableStorageComponent", "HungryStorageComponent")
		if (Storage ~= nil) then
			dPrint("MaxNourishment is "..tostring(Settings.MaxNourishment), "Init", 1)
			dPrint("StartNourishment is "..tostring(Settings.StartingNourshment), "Init", 1)
			ComponentSetValue2(Storage, "value_float", Settings.StartingNourshment * Settings.MaxNourishment)
		end
	end
	

	dPrint("Setup complete", "Init", 1)
end

print("[ Adventure Mode Exit Init ]")