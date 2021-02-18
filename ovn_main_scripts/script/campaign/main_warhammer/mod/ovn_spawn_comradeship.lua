local mission_key = "ovn_hlf_comradeship"

local comradeship_mission = [[
	mission
	{
			key ]]..mission_key..[[;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					type SCRIPTED;
					script_key ]]..mission_key..[[;
					override_text mission_text_override_ovn_hlf_comradeship;
				}
				payload
				{
					effect_bundle{bundle_key ovn_hlf_comradeship_unlock;turns 0;};
				};
		};
	};
]]


-- Spawns the Comradeship in the Moot region
-- Olorin is a general, Aragand, Legles, and Giblit are all heroes embeded in his army
-- They're all legendary lord/heroes
local function spawn_the_comradeship()
	local faction_key = "wh2_main_emp_the_moot";
	local faction_obj = cm:get_faction(faction_key);
	
	if not faction_obj or faction_obj:is_null_interface() then
		--ModLog("faction doesn't exist in this campaign or has already died")
		return false
	end

	-- for some reason the "home region" stuff wasn't working
	local region_key = "wh_main_stirland_the_moot"
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 4);
	if pos_x == -1 or pos_y == -1 then return end

	local names = {"names_name_162509577", "names_name_2147358913", "names_name_271572567", "names_name_2147358913"};
	cm:create_force_with_general(
		faction_key,
		"",
		region_key,	pos_x, pos_y,
		"general", "ovn_com_olorin_the_grey_wizard",
		names[1],
		names[2],
		names[3],
		names[4],
		false,
		function(cqi)
			local olorin_cqi = cqi;
			cm:replenish_action_points("character_cqi:"..olorin_cqi);
			cm:set_character_immortality("character_cqi:"..olorin_cqi, true);

			-- Spawn and embed Aragand, Legles, and Giblit
			core:add_listener(
				"aragand_created",
				"CharacterCreated",
				function(context)
					return olorin_cqi and context:character():character_subtype("ovn_com_aragand_the_layabout");
				end,
				function(context)
					cm:embed_agent_in_force(context:character(), cm:get_character_by_cqi(olorin_cqi):military_force());
					--local char_cqi = context:character():command_queue_index()
					--cm:replenish_action_points("character_cqi:"..char_cqi);
					--cm:set_character_immortality("character_cqi:"..char_cqi, true);
				end,
				false
			);
			core:add_listener(
				"legles_created",
				"CharacterCreated",
				function(context)
					return olorin_cqi and context:character():character_subtype("ovn_com_legles_the_elf");
				end,
				function(context)
					cm:embed_agent_in_force(context:character(), cm:get_character_by_cqi(olorin_cqi):military_force());
					--local char_cqi = context:character():command_queue_index()
					--cm:replenish_action_points("character_cqi:"..char_cqi);
					--cm:set_character_immortality("character_cqi:"..char_cqi, true);
				end,
				false
			);
			core:add_listener(
				"giblit_created",
				"CharacterCreated",
				function(context)
					return olorin_cqi and context:character():character_subtype("ovn_com_giblit_the_dwarf");
				end,
				function(context)
					cm:embed_agent_in_force(context:character(), cm:get_character_by_cqi(olorin_cqi):military_force());
					--local char_cqi = context:character():command_queue_index()
					--cm:replenish_action_points("character_cqi:"..char_cqi);
					--cm:set_character_immortality("character_cqi:"..char_cqi, true);
				end,
				false
			);
			cm:spawn_unique_agent_at_character(cm:get_character_by_cqi(olorin_cqi):faction():command_queue_index(), "ovn_com_aragand_the_layabout", olorin_cqi, true);
			cm:spawn_unique_agent_at_character(cm:get_character_by_cqi(olorin_cqi):faction():command_queue_index(), "ovn_com_legles_the_elf", olorin_cqi, true);
			cm:spawn_unique_agent_at_character(cm:get_character_by_cqi(olorin_cqi):faction():command_queue_index(), "ovn_com_giblit_the_dwarf", olorin_cqi, true);

			--message event
			if faction_obj:is_human() then
				local loc_prefix = "event_feed_strings_text_ovn_comradeship_spawned_"
				cm:show_message_event_located(
					faction_key,
					loc_prefix.."title",
					loc_prefix.."primary_detail",
					loc_prefix.."secondary_detail",
					pos_x,
					pos_y,
					true,
					812
				)
			end;
			
			cm:set_saved_value("ovn_comradeship_been_spawned", true);
		end
	);
end

local function handle_human_halfling_comradeship_unlocking()
	local faction_key = "wh2_main_emp_the_moot"
	local faction = cm:get_faction(faction_key)
	if not faction or faction:is_null_interface() or faction:is_dead() then return end

	local faction_cooking_info = cm:model():world():cooking_system():faction_cooking_info(faction)
				
	OVN_HLF_MISSIONS.ingredients_by_continent = OVN_HLF_MISSIONS.ingredients_by_continent or {}

	local num_ingredients_unlocked = 0
	for _, continent_ingredient_list in pairs(OVN_HLF_MISSIONS.ingredients_by_continent) do
		for _, ingredient in ipairs(continent_ingredient_list) do
			if faction_cooking_info:is_ingredient_unlocked(ingredient) then
				num_ingredients_unlocked = num_ingredients_unlocked + 1
			end
		end
	end

	if num_ingredients_unlocked >= 12 then
		cm:complete_scripted_mission_objective(mission_key, mission_key, true);
		spawn_the_comradeship()
	end
end

local function handle_ai_halfling_comradeship_unlocking()
	local rand = cm:random_number(10, 1)
	if rand == 1 then
		spawn_the_comradeship()
	end
end

--Ideally they would be a quest reward for Mootland, but then the starting army for a Comradeship faction, available in both ME and Vortex
--Maybe a reward for collecting a certain % of the cooking ingredients - "All those good smells luring them back home" something like that
cm:add_first_tick_callback(function()
	local faction_key = "wh2_main_emp_the_moot"
	local faction = cm:get_faction(faction_key)
	if not faction or faction:is_null_interface() or faction:is_dead() then return end

	if cm:get_saved_value("ovn_comradeship_been_spawned") then return end

	if not cm:get_saved_value("ovn_comradeship_has_mission_been_issues") and faction:is_human() then
		cm:trigger_custom_mission_from_string(faction_key, comradeship_mission);
		cm:set_saved_value("ovn_comradeship_has_mission_been_issues", true);
	end

	core:add_listener(
		'ovn_hlf_random_comradeship_spawn',
		'FactionTurnStart',
		function(context)
			return context:faction():name() == faction_key
		end,
		function()
			local faction = cm:get_faction(faction_key)
			if not faction or faction:is_null_interface() or faction:is_dead() then return end
			
			if faction:is_human() then
				handle_human_halfling_comradeship_unlocking()
			else
				handle_ai_halfling_comradeship_unlocking()
			end
		end,
		true
	)
end)

-- DEBUG STUFF
--- This snippet unocks all the ingredients.
-- OVN_HLF_MISSIONS.ingredients_by_continent = OVN_HLF_MISSIONS.ingredients_by_continent or {}
-- for _, continent_ingredient_list in pairs(OVN_HLF_MISSIONS.ingredients_by_continent) do
-- 	for _, ingredient in ipairs(continent_ingredient_list) do
-- 		cm:unlock_cooking_ingredient(cm:get_local_faction(true), ingredient)
-- 	end
-- end