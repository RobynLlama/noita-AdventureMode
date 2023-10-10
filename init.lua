--[[
Module: HungryMina
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

	if (ControllerType == "ADV") then
		dPrint("Using advanced controller", "Init")

		--Remove any existing basic controller
		if (ControllerBas ~= nil) then
			dPrint("Deleting an existing basic controller", "Init")
			EntityRemoveComponent(player_entity, ControllerBas)
		end

		--Add ADV controller if we need it
		if (ControllerAdv == nil) then
			dPrint("Adding a new advanced controller", "Init")
			EntityLoadToEntity("mods/AdventureMode/files/HungryControllerAdv/HungryControllerAdvEnt.xml", player_entity)

			--Modify player metabolism
			local Comp = EntityGetFirstComponent(player_entity, "IngestionComponent")

			if (Comp ~= nil) then
				ComponentSetValue2(Comp, "ingestion_cooldown_delay_frames", 300)
				ComponentSetValue2(Comp, "ingestion_reduce_every_n_frame", 3)
			end
		end
	else
		dPrint("Using Basic Controller", "Init")

		--Remove any existing advanced controller
		if (ControllerAdv ~= nil) then
			dPrint("Deleting an existing advanced controller", "Init")
			EntityRemoveComponent(player_entity, ControllerAdv)

			--Modify player metabolism to default
			local Comp = EntityGetFirstComponent(player_entity, "IngestionComponent")

			if (Comp ~= nil) then
				ComponentSetValue2(Comp, "ingestion_cooldown_delay_frames", 600)
				ComponentSetValue2(Comp, "ingestion_reduce_every_n_frame", 5)
			end
		end

		--Add the basic controller if we need it
		if (ControllerBas == nil) then
			dPrint("Adding a new basic controller", "Init")
			EntityLoadToEntity("mods/AdventureMode/files/HungryController/HungryControllerEnt.xml", player_entity)
		end

	end

	dPrint("Setup complete", "Init")
end

print("Hungry Mina loaded")