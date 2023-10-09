--Load dPrint
dofile_once("mods/HungryMina/files/DebugPrint.lua")

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
	--Check if the player already has a controller entity
	local controller = EntityGetFirstComponent(player_entity, "LuaComponent", "HungryController")

	if (controller == nil) then
		dPrint("[HM] Init > Add new HungryController to player")
		EntityLoadToEntity("mods/HungryMina/files/HungryController/HungryControllerEnt.xml", player_entity)
	end
	dPrint("[HM] Init > OnPlayerSpawned Complete")
end

print("Hungry Mina loaded")