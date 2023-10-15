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

dofile_once("mods/AdventureMode/files/utils/DebugPrint.lua")
dofile_once("mods/AdventureMode/files/utils/ComponentUtils.lua")
local Settings = dofile_once("mods/AdventureMode/files/utils/SettingsCache.lua")

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

--Add a new controller
function AddTummyController()

	local Player = EntityGetWithTag( "player_unit" )[1]

	---@param EntityFile string
	function AddController(EntityFile)
		EntityLoadToEntity(EntityFile, Player)
	end

	local States = {
		["OFF"] = function() end,
		["BAS"] = function() AddController("mods/AdventureMode/files/TummySim/TummyControllerBasic.xml") end,
		["ADV"] = function() AddController("mods/AdventureMode/files/TummySim/TummyControllerAdvanced.xml") end
	}

	States[Settings.TummyType]()
end

--Send an update signal to the component hosting our controller
function SendUpdateSignal()

	local Player = EntityGetWithTag( "player_unit" )[1]
	local UpdateComponent = GetComponentByName(Player, "VariableStorageComponent", "TummySim_NeedsUpdating")
	if (UpdateComponent) then
		ComponentSetValue2(UpdateComponent, "value_bool", true)
		dPrint("Signal sent", "SendUpdateSignal", 1)
	end
end

--Assume the player has modified mod settings in the pause screen cuz there is no way to know
function OnPausedChanged( is_paused, is_inventory_pause)
	--If the player is unpausing
	if (not is_paused) then
		Settings.UpdateCache()
		SendUpdateSignal()
	end
end

function OnPlayerSpawned(player_entity)
	--This is the sloppy way I check if we're at the start of a run
	--Always seems to start at frame 10 when I try so we'll see
	if (GameGetFrameNum() < 12) then

		dPrint("Adding Tummy Controller ", "Init", 1)
		AddTummyController()

		---@param ItemEntity string
		function AddStartingItem(ItemEntity)
			local Item = EntityLoad(ItemEntity)
			GamePickUpInventoryItem(player_entity, Item, true)
		end
		
		--Powder bag starting item
		if (Settings.StartWithPouch) then
			AddStartingItem("mods/AdventureMode/files/StartingItems/RandomSmallPouch.xml")
		end

		if (Settings.StartWithMeal) then
			AddStartingItem("mods/AdventureMode/files/StartingItems/Meal.xml")
		end

		--Set starting nourishment
		if (Settings.TummyType == "ADV") then

			local Storage = GetComponentByName(player_entity, "VariableStorageComponent", "AdvTummySim_StoredHealing")
			if (Storage ~= nil) then
				dPrint("MaxNourishment is "..tostring(Settings.MaxNourishment), "Init", 1)
				dPrint("StartNourishment is "..tostring(Settings.StartingNourshment), "Init", 1)
				ComponentSetValue2(Storage, "value_float", Settings.StartingNourshment * Settings.MaxNourishment)
			end	
			
		end
	end
	

	dPrint("Setup complete", "Init", 1)
end

--GunActions for new spells
if (Settings.NewSpells) then
	ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/AdventureMode/files/Spells/GunActionsAppends.lua")
end

--Translations
local TRANSLATIONS_FILE = "data/translations/common.csv"
local translations = ModTextFileGetContent(TRANSLATIONS_FILE) .. ModTextFileGetContent("mods/AdventureMode/files/Strings.csv")
ModTextFileSetContent(TRANSLATIONS_FILE, translations:gsub("\r\n","\n"):gsub("\n\n","\n"))

print("[ Adventure Mode Exit Init ]")