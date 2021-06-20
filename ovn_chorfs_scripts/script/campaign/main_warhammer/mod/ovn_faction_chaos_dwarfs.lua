local chorf_faction_key = "wh2_main_ovn_chaos_dwarfs"

local function sr_chaos_dwarfs()
	if cm:model():campaign_name("main_warhammer") then
		core:add_listener(
			"pj_chorf_rename_chorf_agents",
			"PanelOpenedCampaign",
			function(context)
				return context.string == "character_panel"
			end,
			function()
				if cm:get_local_faction_name(true) ~= "wh2_main_ovn_chaos_dwarfs" then return end

				local ui_root = core:get_ui_root()
				local list_box = find_uicomponent(ui_root, "character_panel", "agent_parent", "list_clip", "holder", "list_box")

				if not list_box then return end

				local champion = find_uicomponent(list_box, "champion")
				local champion_label = champion and find_uicomponent(champion, "label")
				if champion_label then
						champion:SetTooltipText(effect.get_localised_string("pj_chorf_ui_infernal_castellan_tooltip"), true)
						champion_label:SetStateText(effect.get_localised_string("pj_chorf_ui_infernal_castellan_label"))
				end

				local wizard = find_uicomponent(list_box, "wizard")
				local wizard_label = wizard and find_uicomponent(wizard, "label")
				if wizard_label then
						wizard:SetTooltipText(effect.get_localised_string("pj_chorf_ui_daemonsmith_tooltip"), true)
						wizard_label:SetStateText(effect.get_localised_string("pj_chorf_ui_daemonsmith_label"))
				end
			end,
			true
		)

		if cm:is_new_game() then
			local chorf = cm:get_faction("wh2_main_ovn_chaos_dwarfs");
			local chorf_faction_leader_cqi = chorf:faction_leader():command_queue_index();

			cm:set_character_immortality(cm:char_lookup_str(chorf_faction_leader_cqi), false);

			cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "")
			cm:callback(function() cm:kill_character(chorf_faction_leader_cqi, true, true) end, 2)
			cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 2.1)

			cm:transfer_region_to_faction("wh2_main_the_plain_of_bones_ash_ridge_mountains", "wh2_main_ovn_chaos_dwarfs");

			local ash_region = cm:get_region("wh2_main_the_plain_of_bones_ash_ridge_mountains")
			cm:instantly_set_settlement_primary_slot_level(ash_region:settlement(), 2)

			cm:heal_garrison(ash_region:cqi());

			cm:force_religion_factors("wh2_main_the_plain_of_bones_the_fortress_of_vorag", "wh_main_religion_untainted", 0.5, "wh_main_religion_chaos", 0.5)

			if chorf:is_human() then
				-- give them an enemy army to fight turn 1
				cm:create_force(
					"wh2_dlc15_dwf_clan_helhein",
					"wh_dlc06_dwf_inf_rangers_0,wh_main_dwf_inf_dwarf_warrior_0,wh_main_dwf_inf_miners_0,wh_main_dwf_inf_miners_0,wh_main_dwf_inf_miners_0",
					"wh2_main_the_plain_of_bones_ash_ridge_mountains",
					833,
					285,
					true,
					function(cqi)
						local char = cm:get_character_by_cqi(cqi)
						if not char or char:is_null_interface() then return end

						cm:force_character_force_into_stance(cm:char_lookup_str(char), "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MARCH")
					end
				)

				cm:force_declare_war("wh2_dlc15_dwf_clan_helhein", "wh2_main_ovn_chaos_dwarfs", false, false)
			else
				-- if not played by a human give them the Mount Greyhag region
				cm:transfer_region_to_faction("wh2_main_the_wolf_lands_mount_greyhag", "wh2_main_ovn_chaos_dwarfs")
				cm:force_religion_factors("wh2_main_the_plain_of_bones_the_fortress_of_vorag", "wh_main_religion_untainted", 0.5, "wh_main_religion_chaos", 0.5)
			end

			local faction_key = "wh2_main_ovn_chaos_dwarfs"; -- factions key
			local faction_name = cm:model():world():faction_by_key(faction_key); -- FACTION_SCRIPT_INTERFACE faction
				--local unit_key = "chosen_asur_lions"; -- String unit_record
			local unit_count = 1; -- card32 count
			local rcp = 20; -- float32 replenishment_chance_percentage
			local max_units = 1; -- int32 max_units
			local murpt = 0.1; -- float32 max_units_replenished_per_turn
			local xp_level = 0; -- card32 xp_level
			local frr = ""; -- (may be empty) String faction_restricted_record
			local srr = ""; -- (may be empty) String subculture_restricted_record
			local trr = ""; -- (may be empty) String tech_restricted_record

			cm:add_unit_to_faction_mercenary_pool(faction_name, "ironsworn", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
			cm:add_unit_to_faction_mercenary_pool(faction_name, "wh_pro04_chs_art_hellcannon_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
			cm:add_unit_to_faction_mercenary_pool(faction_name, "chaos_dwarf_warriors_horde", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
			cm:add_unit_to_faction_mercenary_pool(faction_name, "bull_centaur_ba'hal_guardians", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
			cm:add_unit_to_faction_mercenary_pool(faction_name, "granite_guard", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
			cm:add_unit_to_faction_mercenary_pool(faction_name, "magma_beasts", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
		end
	end
end

--- Remove the additional army upkeep for Hobgoblin Lords.
local army_upkeep_bundles = {
	"wh_main_bundle_force_additional_army_upkeep_easy",
	"wh_main_bundle_force_additional_army_upkeep_normal",
	"wh_main_bundle_force_additional_army_upkeep_hard",
	"wh_main_bundle_force_additional_army_upkeep_very_hard",
	"wh_main_bundle_force_additional_army_upkeep_legendary",
}

local original_apply_upkeep_penalty = apply_upkeep_penalty

apply_upkeep_penalty = function(faction, ...)
	if faction:name() ~= "wh2_main_ovn_chaos_dwarfs" then
		return original_apply_upkeep_penalty(faction, ...)
	end

	original_apply_upkeep_penalty(faction, ...)

	local mf_list = faction:military_force_list();

	for i = 0, mf_list:num_items() - 1 do
		local current_mf = mf_list:item_at(i);
		local force_type = current_mf:force_type():key()

		if current_mf:is_armed_citizenry() == false and current_mf:has_general() == true and force_type ~= "SUPPORT_ARMY"  then
			local general = current_mf:general_character();
			local character_subtype_key = general:character_subtype_key();
			local cqi = general:command_queue_index();

			if character_subtype_key == "hobgoblin_greatkhan" or character_subtype_key == "hobgoblin_greatsorcerer" then
				for _, army_upkeep_bundle in ipairs(army_upkeep_bundles) do
					cm:remove_effect_bundle_from_characters_force(army_upkeep_bundle, cqi)
				end
			end
		end
	end
end

local function binding_iter(binding)
	local pos = 0
	local num_items = binding:num_items()
	return function()
			if pos < num_items then
					local item = binding:item_at(pos)
					pos = pos + 1
					return item
			end
			return
	end
end

local building_key_from_to_lookup = {
	["ovn_chs_agent"] = "ovn_chorf_agent_1",
	["ovn_chs_agent_chorfs_1"] = "ovn_chorf_agent_1",
	["ovn_chs_agent_1"] = "ovn_chorf_agent_2",
	["wh_main_nor_creatures_3"] = "ovn_chorf_creatures_2",
	["wh_main_nor_creatures_2"] = "ovn_chorf_creatures_2",
	["wh_main_nor_creatures_1"] = "ovn_chorf_creatures_1",
	["wh_main_nor_outpost_experience_1"] = "ovn_chorf_experience_1",
	["wh_main_nor_outpost_experience_2"] = "ovn_chorf_experience_2",
	["wh_main_nor_outpost_experience_3"] = "ovn_chorf_experience_3",
	["wh_main_nor_outpost_growth_3"] = "ovn_chorf_worship_3",
	["wh_main_nor_outpost_growth_2"] = "ovn_chorf_worship_2",
	["wh_main_nor_outpost_growth_1"] = "ovn_chorf_worship_1",
	["wh_main_nor_loot_1"] = "ovn_chorf_loot_1",
	["wh_main_nor_loot_2"] = "ovn_chorf_loot_2",
	["wh_main_nor_loot_3"] = "ovn_chorf_loot_3",
	["wh_main_nor_outpost_income_1"] = "ovn_chorf_loot_1",
	["wh_main_nor_outpost_income_2"] = "ovn_chorf_loot_2",
	["wh_main_nor_outpost_income_3"] = "ovn_chorf_loot_3",
	["ovn_evil_income_1"] = "ovn_chorf_slaves_1",
	["ovn_evil_income_2"] = "ovn_chorf_slaves_2",
	["ovn_evil_income_3"] = "ovn_chorf_slaves_3",
	["wh_main_nor_military_1"] = "ovn_chorf_military_1",
	["wh_main_nor_military_2"] = "ovn_chorf_military_2",
	["wh_main_nor_military_3"] = "ovn_chorf_military_3",
	["wh_main_nor_outpost_military_1"] = "ovn_chorf_military_1",
	["wh_main_nor_outpost_military_2"] = "ovn_chorf_military_2",
	["wh_main_nor_outpost_military_3"] = "ovn_chorf_military_3",
	["wh_main_nor_outpost_military_4"] = "ovn_chorf_military_4",
	["wh_main_nor_slaves_1"] = "ovn_chorf_slaves_1",
	["wh_main_nor_slaves_2"] = "ovn_chorf_slaves_2",
	["wh_main_nor_slaves_3"] = "ovn_chorf_slaves_3",
	["wh_main_nor_stables_3"] = "ovn_chorf_stables_3",
	["wh_main_nor_stables_2"] = "ovn_chorf_stables_2",
	["wh_main_nor_stables_1"] = "ovn_chorf_stables_1",
	["wh_main_nor_outpost_stables_4"] = "ovn_chorf_stables_4",
	["wh_main_nor_outpost_stables_3"] = "ovn_chorf_stables_3",
	["wh_main_nor_outpost_stables_2"] = "ovn_chorf_stables_2",
	["wh_main_nor_outpost_stables_1"] = "ovn_chorf_stables_1",
	["ovn_cd_work_1"] = "ovn_chorf_workshop_1",
	["ovn_cd_work_2"] = "ovn_chorf_workshop_2",
	["ovn_cd_work_3"] = "ovn_chorf_workshop_3",
	["wh_main_nor_worship_4"] = "ovn_chorf_worship_4",
	["wh_main_nor_worship_3"] = "ovn_chorf_worship_3",
	["wh_main_nor_worship_2"] = "ovn_chorf_worship_2",
	["wh_main_nor_worship_1"] = "ovn_chorf_worship_1",
	["ovn_cd_boss_1"] = "ovn_chorf_creatures_1",
	["ovn_cd_boss_2"] = "ovn_chorf_creatures_2",
}

local function replace_old_buildings()
	if not cm:model():campaign_name("main_warhammer") then return end

	local f = cm:get_faction(chorf_faction_key)
	if not f or f:is_null_interface() then return end

	---@type CA_REGION
	for region in binding_iter(f:region_list()) do
		---@type CA_SLOT
		for slot in binding_iter(region:slot_list()) do
			if slot and slot:has_building() then
				local key_to = building_key_from_to_lookup[slot:building():name()]
				if key_to then
					cm:region_slot_instantly_dismantle_building(slot)

					cm:region_slot_instantly_upgrade_building(slot, key_to)
					cm:callback(
						function()
							cm:region_slot_instantly_repair_building(slot)
						end,
						0
					)
				end
			end
		end
	end
end

cm:add_first_tick_callback(
	function()
		sr_chaos_dwarfs()
		replace_old_buildings()
	end
)
