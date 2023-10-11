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

--Load dPrint
dofile_once("mods/AdventureMode/files/DebugPrint.lua")

print("[ Adventure Mode Init ]")

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

local ControllerType = ModSettingGet("AdventureMode.TummySimType")

function OnPlayerSpawned(player_entity)

	--Fetch controllers for checking
	local ControllerBas = EntityGetFirstComponent(player_entity, "LuaComponent", "HungryController")
	local ControllerAdv = EntityGetFirstComponent(player_entity, "LuaComponent", "HungryControllerAdv")

	---@param Controller any
	function RemoveController(Controller)
		if (Controller ~= nil) then
			dPrint("Deleting a controller", "Init")
			EntityRemoveComponent(player_entity, Controller)
		end
	end

	---@param Delay integer
	---@param NFrames integer
	function SetPlayerIngestion(Delay, NFrames)
		local Comp = EntityGetFirstComponent(player_entity, "IngestionComponent")

			if (Comp ~= nil) then
				ComponentSetValue2(Comp, "ingestion_cooldown_delay_frames", Delay)
				ComponentSetValue2(Comp, "ingestion_reduce_every_n_frame", NFrames)
			end
	end

	function DisableAdvIcons()
		local Comp = EntityGetFirstComponent(player_entity, "UIIconComponent", "HungryNourishIcon")
		if (Comp ~= nil) then
		EntityRemoveComponent(player_entity, Comp)
		end
	end

	if (ControllerType == "ADV") then
		dPrint("Using advanced controller", "Init")

		--Remove any existing basic controller
		RemoveController(ControllerBas)

		--Add ADV controller if we need it
		if (ControllerAdv == nil) then
			dPrint("Adding a new advanced controller", "Init")
			EntityLoadToEntity("mods/AdventureMode/files/HungryControllerAdv/HungryControllerAdvEnt.xml", player_entity)

			--Modify player metabolism
			SetPlayerIngestion(300, 3)
		end
	elseif (ControllerType == "BAS") then
		dPrint("Using Basic Controller", "Init")

		--Remove any existing advanced controller
		RemoveController(ControllerAdv)
		DisableAdvIcons()

		--Set metabolism to defaults
		SetPlayerIngestion(600, 5)

		--Add the basic controller if we need it
		if (ControllerBas == nil) then
			dPrint("Adding a new basic controller", "Init")
			EntityLoadToEntity("mods/AdventureMode/files/HungryController/HungryControllerEnt.xml", player_entity)
		end

	else
		--Disabled
		dPrint("TummySim disabled", "Init")

		RemoveController(ControllerBas)
		RemoveController(ControllerAdv)
		DisableAdvIcons()
	end

	if (ModSettingGet("AdventureMode.StartingItems_Pouch")) then
		local world = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")
		local time = ComponentGetValue2(world, "time_total")

		--This is the sloppy way I check if we're at the start of a run
		if (time < 0.0003) then
			local powder_bag = EntityLoad("mods/AdventureMode/files/StartingItems/RandomPouch.xml")
			GamePickUpInventoryItem(player_entity, powder_bag, true)
		end
	end

	dPrint("Setup complete", "Init")
end

print("[ Adventure Mode Exit Init ]")