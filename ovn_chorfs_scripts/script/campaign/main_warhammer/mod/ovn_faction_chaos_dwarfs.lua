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

					local agent_label = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent", "button_group_agents", "champion", "label")
					if agent_label then
							agent_label:SetStateText("Infernal Castellan")
					end
					agent_label = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent", "button_group_agents", "wizard", "label")
					if agent_label then
							agent_label:SetStateText("Daemonsmith")
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
					end
				)
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
cm:add_first_tick_callback(function() sr_chaos_dwarfs() end)
