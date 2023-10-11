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

--[[
	TODO List:
		Combine the advanced and basic hungry controllers
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

function OnPlayerSpawned(player_entity)

	--Fetch controllers for checking
	local TummyController = EntityGetFirstComponent(player_entity, "LuaComponent", "TummySimController")
	local Icon

	dPrint("Frame: "..tostring(GameGetFrameNum()), "Init")

	---@param Delay integer
	---@param NFrames integer
	function SetPlayerMetabolism(Delay, NFrames)
		local Comp = EntityGetFirstComponent(player_entity, "IngestionComponent")

		if (Comp ~= nil) then
			ComponentSetValue2(Comp, "ingestion_cooldown_delay_frames", Delay)
			ComponentSetValue2(Comp, "ingestion_reduce_every_n_frame", NFrames)
		end
	end

	---@param Visible boolean
	function SetNourishIconVisibility(Visible)

		Icon = EntityGetFirstComponentIncludingDisabled(player_entity, "UIIconComponent", "NourishIcon")
		dPrint("Changing Icon state to "..tostring(Visible), "Init")

		if (Visible) and (Icon == nil) then
			dPrint("Adding Icon", "Init")
			EntityLoadToEntity("mods/AdventureMode/files/TummySim/Icon.xml", player_entity)
		elseif (not Visible) and (Icon ~= nil) then
			dPrint("Removing Icon", "Init")
			EntityRemoveComponent(player_entity, Icon)
		end

	end

	dPrint("TummyType: "..tostring(Settings.TummyType), "Init")
	if (Settings.TummyType ~= "OFF") then
		--Load controller if we don't already have one
		if (TummyController == nil) then
			EntityLoadToEntity("mods/AdventureMode/files/TummySim/Entity.xml", player_entity)
		end

		--Specific controller checks
		if (Settings.TummyType == "BAS") then

			--Don't need this for the basic controller
			SetNourishIconVisibility(false)

			--Player metabolism is normal (this is in case we switched from advanced)
			SetPlayerMetabolism(600, 5)
		elseif (Settings.TummyType == "ADV") then

			--Activate the icon (in case we switched from basic)
			SetNourishIconVisibility(true)

			--Setup faster metabolism (in case we switched from basic)
			SetPlayerMetabolism(300, 3)
		end

	else
		--This will be active if we switched from Advanced
		SetNourishIconVisibility(false)

		--Player metabolism is normal (this is in case we switched from advanced)
		SetPlayerMetabolism(600, 5)
	end
	if (Settings.StartWithPouch) then
		--This is the sloppy way I check if we're at the start of a run
		--Always seems to start at frame 10 when I try so we'll see
		if (GameGetFrameNum() < 12) then
			local powder_bag = EntityLoad("mods/AdventureMode/files/StartingItems/RandomPouch.xml")
			GamePickUpInventoryItem(player_entity, powder_bag, true)
		end
	end

	dPrint("Setup complete", "Init")
end

print("[ Adventure Mode Exit Init ]")