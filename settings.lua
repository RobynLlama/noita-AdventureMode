dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

-- This file can't access other files from this or other mods in all circumstances.
-- Settings will be automatically saved.
-- Settings don't have access unsafe lua APIs.

-- Use ModSettingGet() in the game to query settings.
-- For some settings (for example those that affect world generation) you might want to retain the current value until a certain point, even
-- if the player has changed the setting while playing.
-- To make it easy to define settings like that, each setting has a "scope" (e.g. MOD_SETTING_SCOPE_NEW_GAME) that will define when the changes
-- will actually become visible via ModSettingGet(). In the case of MOD_SETTING_SCOPE_NEW_GAME the value at the start of the run will be visible
-- until the player starts a new game.
-- ModSettingSetNextValue() will set the buffered value, that will later become visible via ModSettingGet(), unless the setting scope is MOD_SETTING_SCOPE_RUNTIME.

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

--[[
function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	
end
]]--

local mod_id = "AdventureMode" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings = 
{
	{
		category_id = "AdventureModeSettings_Root",
		ui_name = "Adventure Settings",
		ui_description = "Settings that tweak the game a bit",
		foldable = true,
		_folded = false,
		settings = {
			{
				id = "StartingItems_Pouch",
				ui_name = "Start with random pouch",
				ui_description = "Gives the player a random pouch on new game start",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "StartingItems_Meal",
				ui_name = "Start with a small meal",
				ui_description = "Starts the player with a non-refillable flask of something edible",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "Adventure_NewSpells",
				ui_name = "Enable new spells",
				ui_description = "Enables some new spells to show up in the game world",
				value_default = false,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
		}
	},
	{
		category_id = "HungryMinaSettings_Root",
		ui_name = "Tummy Simulation Settings",
		ui_description = "Settings for player healing from food",
		foldable = true,
		_folded = false,
		settings = {
			{
				id = "TummySimType",
				ui_name = "Tummy Simulation Type",
				ui_description = "Basic\n    Only considers if the player has anything in the\n    tummy for healing\nAdvanced\n    Demands a more healthy lifestyle with per-material\n    rules",
				value_default = "BAS",
				values = {{"OFF", "Disabled"}, {"BAS","Basic"}, {"ADV","Advanced"}},
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "RegenHealBlockFrames",
				ui_name = "Healing Blocked in Combat",
				ui_description = "In seconds, how long healing is blocked in combat",
				value_default = 3,
				value_min = 0,
				value_max = 30,
				value_display_formatting = " $0 Seconds",
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				ui_fn = mod_setting_vertical_spacing,
				not_setting = true,
			},
			{
				category_id = "tummy_basic_settings_root",
				ui_name = "Basic Simulation Settings",
				ui_description = "Settings for the basic tummy simulation",
				foldable = true,
				_folded = true,
				settings = {
					{
						ui_fn = mod_setting_vertical_spacing,
						not_setting = true,
					},
					{
						category_id = "settings_regen",
						ui_name = "Regneration Settings",
						ui_description = "Fine-tune how the regen works",
						settings = {
							{
								id = "MaxHealPerFrame",
								ui_name = "Max Heal Per Frame",
								ui_description = "In percent, how much life can be restored in one frame",
								value_default = 3,
								value_min = 1,
								value_max = 100,
								value_display_formatting = " $0 Percent",
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "CostForPercent",
								ui_name = "Satiety Cost Per Percent Heal",
								ui_description = "Each percent of the player's life healed in a frame\nwill cost this much satiety. By defalt the stomach can\ncontain 7500 units of stuff",
								value_default = "100",
								text_max_length = 4,
								allowed_characters = "0123456789",
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
						},
					},
				},
			},
			{
				category_id = "tummy_advanced_settings_root",
				ui_name = "Advanced Simulation Settings",
				ui_description = "Settings for the advanced tummy simulation",
				foldable = true,
				_folded = true,
				settings = {
					{
						ui_fn = mod_setting_vertical_spacing,
						not_setting = true,
					},
					{
						id = "Adv_MaxNourishment",
						ui_name = "Max Nourishment",
						ui_description = "How much healing the player can store for later\nEach unit can restore 1% max life\nReasonable range is from 50-300",
						value_default = "100",
						text_max_length = 3,
						allowed_characters = "0123456789",
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "Adv_StartingNourishment",
						ui_name = "Starting Nourishment",
						ui_description = "How much healing the player starts with",
						value_default = "40",
						values = {{"0", "Starving [0%]"}, {"20","Meagre [20%]"}, {"40","Satiated [40%]"}, {"60","Pleasantly Full [60%]"}, {"80","Well-Fed [80%]"}, {"100","Fit To Burst [100%]"}},
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
					{
						ui_fn = mod_setting_vertical_spacing,
						not_setting = true,
					},
					{
						category_id = "Adv_Experimental_Root",
						ui_name = "Experimental Settings",
						ui_description="These settings don't generally need to be changed\nModify at your own risk\nTip: Right-click to reset most fields to default",
						foldable = true,
						_folded = true,
						settings = {
							{
								ui_fn = mod_setting_vertical_spacing,
								not_setting = true,
							},
							{
								id = "Exp_SatiationRatio",
								ui_name = "Cell Digestion Waste Ratio",
								ui_description = "Modifies how quickly satiation is consumed",
								value_default = "0.40",
								text_max_length = 4,
								allowed_characters = "0123456789.",
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "Exp_SatiationTarget",
								ui_name = "Satiation Target",
								ui_description = "How much satiation is removed from the tummy each update\nDefault 6.0",
								value_default = "5.0",
								text_max_length = 4,
								allowed_characters = "0123456789.",
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
						}
					},
				},
			},
		}
	},
	{
		id = "DebugPrintingLevel",
		ui_name = "Debug Printing Level",
		ui_description = "Requires debug mode or the enable logging mod",
		value_default = "0",
		values = {{"0", "OFF"}, {"1","ALL"}, {"2","WARNING+"}, {"3","ERROR+"}, {"4","CRITICAL ONLY"}},
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}

-- This function is called to ensure the correct setting values are visible to the game via ModSettingGet(). your mod's settings don't work if you don't have a function like this defined in settings.lua.
-- This function is called:
--		- when entering the mod settings menu (init_scope will be MOD_SETTINGS_SCOPE_ONLY_SET_DEFAULT)
-- 		- before mod initialization when starting a new game (init_scope will be MOD_SETTING_SCOPE_NEW_GAME)
--		- when entering the game after a restart (init_scope will be MOD_SETTING_SCOPE_RESTART)
--		- at the end of an update when mod settings have been changed via ModSettingsSetNextValue() and the game is unpaused (init_scope will be MOD_SETTINGS_SCOPE_RUNTIME)
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic.
-- The value will be used to determine whether or not to display various UI elements that link to mod settings.
-- At the moment it is fine to simply return 0 or 1 in a custom implementation, but we don't guarantee that will be the case in the future.
-- This function is called every frame when in the settings menu.
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
