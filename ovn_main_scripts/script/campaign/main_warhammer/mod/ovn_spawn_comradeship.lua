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
					local char_cqi = context:character():command_queue_index()
					cm:set_character_immortality("character_cqi:"..char_cqi, true);
					--cm:replenish_action_points("character_cqi:"..char_cqi);
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
					local char_cqi = context:character():command_queue_index()
					cm:set_character_immortality("character_cqi:"..char_cqi, true);
					--cm:replenish_action_points("character_cqi:"..char_cqi);
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
					local char_cqi = context:character():command_queue_index()
					cm:set_character_immortality("character_cqi:"..char_cqi, true);
					--cm:replenish_action_points("character_cqi:"..char_cqi);
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
		cm:callback(
			function()
				local faction = cm:get_faction(faction_key)
				if not faction then return end
				if faction:has_effect_bundle("ovn_hlf_comradeship_unlock") then
					cm:remove_effect_bundle("ovn_hlf_comradeship_unlock", faction:name())
				end
			end,
			1
		)
		spawn_the_comradeship()
	end
end

local function handle_ai_halfling_comradeship_unlocking()
	local rand = cm:random_number(20, 1)
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
		cm:callback(function()
			cm:trigger_custom_mission_from_string(faction_key, comradeship_mission);
			cm:set_saved_value("ovn_comradeship_has_mission_been_issues", true);
		end, 8)
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
			if cm:get_saved_value("ovn_comradeship_been_spawned") then return end

			if faction:is_human() then
				handle_human_halfling_comradeship_unlocking()
			else
				handle_ai_halfling_comradeship_unlocking()
			end
		end,
		true
	)
end)

local unlocked_comradeskip_ancies = {
	["ovn_anc_weapon_glammyding"] = false,
	["ovn_anc_talisman_bottomless_hat_of_rabbit"] = false,
	["ovn_anc_arcane_item_cathay_fireworks"] = false,
	["ovn_anc_weapon_aragands_sword"] = false,
	["ovn_anc_enchanted_item_pig_swill"] = false,
	["ovn_anc_talisman_friendship_bracelet_legles"] = false,
	["ovn_anc_enchanted_item_ring_of_concealment"] = false,
	["ovn_anc_talisman_friendship_bracelet_giblit"] = false,
	["ovn_anc_enchanted_item_bimbos_book"] = false,
}

local comradeskip_ancies_to_level = {
	["ovn_anc_weapon_glammyding"] = 10,
	["ovn_anc_talisman_bottomless_hat_of_rabbit"] = 14,
	["ovn_anc_arcane_item_cathay_fireworks"] = 18,
	["ovn_anc_weapon_aragands_sword"] = 12,
	["ovn_anc_enchanted_item_pig_swill"] = 7,
	["ovn_anc_talisman_friendship_bracelet_legles"] = 12,
	["ovn_anc_enchanted_item_ring_of_concealment"] = 7,
	["ovn_anc_talisman_friendship_bracelet_giblit"] = 12,
	["ovn_anc_enchanted_item_bimbos_book"] = 7,
}

local comradeskip_subtype_and_ancies = {
	["ovn_com_olorin_the_grey_wizard"] = {
		["ovn_anc_weapon_glammyding"] = true,
		["ovn_anc_talisman_bottomless_hat_of_rabbit"] = true,
		["ovn_anc_arcane_item_cathay_fireworks"] = true,
	},
	["ovn_com_aragand_the_layabout"] = {
		["ovn_anc_weapon_aragands_sword"] = true,
		["ovn_anc_enchanted_item_pig_swill"] = true,
	},
	["ovn_com_legles_the_elf"] = {
		["ovn_anc_enchanted_item_ring_of_concealment"] = true,
		["ovn_anc_talisman_friendship_bracelet_legles"] = true,
	},
	["ovn_com_giblit_the_dwarf"] = {
		["ovn_anc_enchanted_item_bimbos_book"] = true,
		["ovn_anc_talisman_friendship_bracelet_giblit"] = true,
	},
}

core:remove_listener("ovn_com_give_ancies")
core:add_listener(
	"ovn_com_give_ancies",
	"CharacterRankUp",
	function(context)
		---@type CA_CHAR
		local char = context:character()
		return comradeskip_subtype_and_ancies[char:character_subtype_key()] ~= nil
	end,
	function(context)
		---@type CA_CHAR
		local char = context:character()
		local rank = char:rank()

		local ancies = comradeskip_subtype_and_ancies[char:character_subtype_key()]
		if not ancies then return end
		for anci, _ in pairs(ancies) do
			if unlocked_comradeskip_ancies[anci] == false and comradeskip_ancies_to_level[anci] <= rank then
				unlocked_comradeskip_ancies[anci] = true
				cm:force_add_ancillary(char, anci, true, false)
			end
		end
	end,
	true
)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ovn_com_ancies", unlocked_comradeskip_ancies, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		unlocked_comradeskip_ancies = cm:load_named_value("ovn_com_ancies", unlocked_comradeskip_ancies, context)
	end
)

-- DEBUG STUFF
--- This snippet unocks all the ingredients.
-- OVN_HLF_MISSIONS.ingredients_by_continent = OVN_HLF_MISSIONS.ingredients_by_continent or {}
-- for _, continent_ingredient_list in pairs(OVN_HLF_MISSIONS.ingredients_by_continent) do
-- 	for _, ingredient in ipairs(continent_ingredient_list) do
-- 		cm:unlock_cooking_ingredient(cm:get_local_faction(true), ingredient)
-- 	end
-- end
