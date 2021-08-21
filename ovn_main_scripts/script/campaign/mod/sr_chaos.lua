OVN_ROT_SKITTERGATE = OVN_ROT_SKITTERGATE or {}

local rotbloods_faction_key = "wh2_main_nor_rotbloods"

local function sr_chaos_new_game_setup(rotblood_tribe)
	local unit_count = 1 -- card32 count
	local rcp = 20 -- float32 replenishment_chance_percentage
	local max_units = 1 -- int32 max_units
	local murpt = 0.1 -- float32 max_units_replenished_per_turn
	local xp_level = 0 -- card32 xp_level
	local frr = "" -- (may be empty) String faction_restricted_record
	local srr = "" -- (may be empty) String subculture_restricted_record
	local trr = "" -- (may be empty) String tech_restricted_record
	local units = {
		"wh_pro04_chs_art_hellcannon_ror_0",
		"wh_pro04_chs_cav_chaos_knights_ror_0",
		"wh_pro04_chs_inf_chaos_warriors_ror_0",
		"wh_pro04_chs_inf_forsaken_ror_0",
		"wh_pro04_chs_mon_chaos_spawn_ror_0",
		"wh_pro04_chs_mon_dragon_ogre_ror_0",
		"wh_pro04_nor_inf_chaos_marauders_ror_0"
	}

	for _, unit in ipairs(units) do
		cm:add_unit_to_faction_mercenary_pool(
			rotblood_tribe,
			unit,
			unit_count,
			rcp,
			max_units,
			murpt,
			xp_level,
			frr,
			srr,
			trr,
			true
		)
	end


	cm:create_force_with_general(
		"wh2_main_nor_rotbloods",
		"wh_main_nor_inf_chaos_marauders_0,wh_main_chs_inf_chaos_warriors_0,wh_main_chs_mon_chaos_spawn,wh_main_chs_cav_chaos_knights_0,wh_dlc08_nor_inf_marauder_berserkers_0",
		"wh2_main_kingdom_of_beasts_serpent_coast",
		583,
		700,
		"general",
		"ribspreader",
		"names_name_999982317",
		"",
		"",
		"",
		true,
		function(cqi)
			cm:set_character_unique("character_cqi:" .. cqi, true)
			cm:set_character_immortality("character_cqi:" .. cqi, true)

			local x, y = cm:find_valid_spawn_location_for_character_from_character("wh2_main_nor_rotbloods", cm:char_lookup_str(cqi), true)
			if x == -1 then return end

			cm:create_agent(
				"wh2_main_nor_rotbloods",
				"wizard",
				"rbt_blightstormer",
				x,
				y,
				false,
				function(cqi)
					cm:replenish_action_points(cm:char_lookup_str(cqi))
				end
			)
		end
	)

	if not rotblood_tribe:is_human() then
			cm:transfer_region_to_faction("wh2_main_chrace_elisia", "wh2_main_nor_rotbloods")
			cm:transfer_region_to_faction("wh_main_blightwater_kradtommen", "wh2_main_nor_rotbloods")
			cm:transfer_region_to_faction("wh2_main_northern_great_jungle_xahutec", "wh2_main_nor_rotbloods")
			cm:transfer_region_to_faction("wh_main_hochland_brass_keep", "wh2_main_nor_rotbloods")

			cm:force_religion_factors("wh_main_blightwater_kradtommen", "wh_main_religion_chaos", 1)
			cm:force_religion_factors("wh2_main_northern_great_jungle_xahutec", "wh_main_religion_chaos", 1)
			cm:force_religion_factors("wh2_main_chrace_elisia", "wh_main_religion_chaos", 1)
			cm:force_religion_factors("wh_main_hochland_brass_keep", "wh_main_religion_untainted", 0.7, "wh_main_religion_chaos", 0.3)

			cm:heal_garrison(cm:get_region("wh2_main_northern_great_jungle_xahutec"):cqi())
			cm:heal_garrison(cm:get_region("wh2_main_chrace_elisia"):cqi())

			local grimhold_region = cm:get_region("wh_main_blightwater_kradtommen")
			cm:instantly_set_settlement_primary_slot_level(grimhold_region:settlement(), 1)
			cm:heal_garrison(grimhold_region:cqi())

			local brasskeep_region = cm:get_region("wh_main_hochland_brass_keep")
			cm:instantly_set_settlement_primary_slot_level(brasskeep_region:settlement(), 2)
			cm:heal_garrison(brasskeep_region:cqi())

			cm:force_change_cai_faction_personality("wh2_main_nor_rotbloods", "wh_norsca_default_hard")

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_dlc01_chs_inf_chaos_warriors_2,wh_main_chs_cav_chaos_knights_0,wh_dlc01_chs_inf_forsaken_0,wh_main_chs_mon_trolls",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				740,
				194,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("ovn_Slaa", cqi, -1, true)
				end
			)

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_dlc01_chs_inf_chaos_warriors_2,wh_main_chs_mon_chaos_spawn,wh_main_chs_cav_chaos_knights_0,wh_dlc01_chs_inf_forsaken_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				640,
				470,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("ovn_Tzeen", cqi, -1, true)
				end
			)

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_inf_chaos_warriors_0,wh_dlc01_chs_inf_chaos_warriors_2,wh_main_chs_mon_chaos_spawn,wh_dlc01_chs_inf_forsaken_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				170,
				155,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("ovn_Khar", cqi, -1, true)
				end
			)

			if cm:get_faction("wh2_dlc12_lzd_cult_of_sotek"):is_human() then
				local xahutec_region = cm:model():world():region_manager():region_by_key("wh2_main_northern_great_jungle_xahutec")
				cm:instantly_set_settlement_primary_slot_level(xahutec_region:settlement(), 1)
			end

			if cm:get_faction("wh_main_emp_empire"):is_human() then
				cm:transfer_region_to_faction("wh_main_reikland_helmgart", "wh2_main_nor_rotbloods")
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_emp_empire", true, true)
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_emp_empire_separatists", true, true)
			end
	end

	local aos_region = cm:get_region("wh_main_mountains_of_hel_altar_of_spawns")
	cm:transfer_region_to_faction("wh_main_mountains_of_hel_altar_of_spawns", "wh2_main_nor_rotbloods")
	cm:heal_garrison(aos_region:cqi())

	cm:instantly_set_settlement_primary_slot_level(aos_region:settlement(), 2)

	cm:force_make_peace("wh_dlc08_nor_wintertooth", "wh2_main_nor_rotbloods")
end

function new_ovn_sr_chaos()
	if cm:model():campaign_name("main_warhammer") then
		cm:force_diplomacy("subculture:wh_main_sc_nor_warp", "culture:wh_main_chs_chaos", "all", true, true, true)
		local rotblood_tribe = cm:get_faction("wh2_main_nor_rotbloods")

		local mct = core:get_static_object("mod_configuration_tool")
		local rotblood_value
		local enable_value
		if mct then
			local lost_factions_mod = mct:get_mod_by_key("lost_factions")
			local rotblood_option = lost_factions_mod:get_option_by_key("rotblood")
			rotblood_value = rotblood_option:get_finalized_setting()
			rotblood_option:set_read_only(true)
			local enable_option = lost_factions_mod:get_option_by_key("enable")
			enable_value = enable_option:get_finalized_setting()
			enable_option:set_read_only(true)
		end

		if not rotblood_tribe then return end

		local old_leader_cqi = rotblood_tribe:faction_leader():command_queue_index()
		cm:callback(
			function()
				local str = "character_cqi:"..old_leader_cqi
				cm:set_character_immortality(str, false)
				cm:kill_character(old_leader_cqi, true, true)
			end,
			0
		)

		if rotblood_tribe and (rotblood_tribe:is_human() or not mct or rotblood_value and enable_value) then
			if cm:is_new_game() then
				sr_chaos_new_game_setup(rotblood_tribe)
			end
		end
	end
end

function ovn_rotblood_skit_reinforcements_new()

    core:add_listener(
        "generate_rotblood_skit_dilemma_listener",
        "FactionTurnStart",
        function(context)
            return context:faction():name() == "wh2_main_nor_rotbloods" and context:faction():is_human()
        end,
		function(context)
			local faction_name_str = "wh2_main_nor_rotbloods"
			local faction_name = cm:get_faction(faction_name_str)
            local turn = cm:model():turn_number();
            local cooldown = 9
			if turn % cooldown == 0 and 1 ~= cm:random_number(6, 1)
			and faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then

                core:add_listener(
                    "rotblood_skit_dilemma_listener",
                    "DilemmaChoiceMadeEvent",
                    function(context) return context:dilemma():starts_with("ovn_dilemma_rotblood_skit") end,
                    function(context)
                        local faction_name_str = "wh2_main_nor_rotbloods"
                        local faction_name = cm:get_faction(faction_name_str)
                        local choice = context:choice()
                        if choice == 0 then
                            local rb_tele_location = "wh_main_blightwater_kradtommen"
                            local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, rb_tele_location, false, false, 45)
                            if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
                                cm:teleport_to("faction:wh2_main_nor_rotbloods,forename:999982317", w, z, false)
                            end

                    elseif choice == 1 then
                        local rb_tele_location = "wh2_main_northern_great_jungle_xahutec"
                        local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, rb_tele_location, false, false, 45)
                        if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
                            cm:teleport_to("faction:wh2_main_nor_rotbloods,forename:999982317", w, z, false)
                        end

                    elseif choice == 2 then
                        local rb_tele_location = "wh_main_ostermark_mordheim"
                        local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, rb_tele_location, false, false, 45)
                        if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
                            cm:teleport_to("faction:wh2_main_nor_rotbloods,forename:999982317", w, z, false)
                        end

                    end

                    end,
                    false
                    )

                cm:trigger_dilemma("wh2_main_nor_rotbloods" , "ovn_dilemma_rotblood_skit")

                end
                end,
                true
                );
end

function new_chshordespawn()
	local kradtommen_region = cm:get_region("wh_main_blightwater_kradtommen")
	local altar_of_spawns_region = cm:get_region("wh_main_mountains_of_hel_altar_of_spawns")
	local xahutec_region = cm:get_region("wh2_main_northern_great_jungle_xahutec")
	local brass_keep_region = cm:get_region("wh_main_hochland_brass_keep")

	----  CWD HOLD KRADTOMMEN - Settlement 1

	if kradtommen_region:owning_faction():name() == "wh2_main_nor_rotbloods" then
		----  Badlands Spawn: Option 1A
		if 1 == cm:random_number(75, 1) then

				new_chshordespawnmess()

				cm:create_force(
					"wh2_main_nor_rotbloods",
					"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
					"wh2_main_kingdom_of_beasts_serpent_coast",
					767,
					251,
					true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
					end
				)


			cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_dwf_karak_azul", true, true)

			if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_dwf_dwarfs", true, true)
			end

			if cm:get_faction("wh_main_grn_greenskins"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_grn_greenskins", true, true)
			end


		elseif 2 == cm:random_number(75, 1) then
			----  Kingdom of Beasts Spawn: Option 1B

				new_chshordespawnmess()

				cm:create_force(
					"wh2_main_nor_rotbloods",
					"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
					"wh2_main_kingdom_of_beasts_serpent_coast",
					809,
					173,
					true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
					end
				)


			cm:force_declare_war("wh2_main_nor_rotbloods", "wh2_dlc09_tmb_lybaras", true, true)

			if cm:get_faction("wh2_main_lzd_last_defenders"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh2_main_lzd_last_defenders", true, true)
			end

		end
	end

	----  CWD HOLD Altar of Spawns - Settlement 2
	if altar_of_spawns_region:owning_faction():name() == "wh2_main_nor_rotbloods" then
		----  Sylvania Spawn: Option 2A
		if 3 == cm:random_number(75, 1) then
			new_chshordespawnmessgrn()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				696,
				415,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_vmp_vampire_counts", true, true)

			if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_dwf_dwarfs", true, true)
			end

		elseif 4 == cm:random_number(75, 1) then
			----  North Worlds Edge Mountains Spawn: Option 2B
			new_chshordespawnmessgrn()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				775,
				450,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_dwf_karak_kadrin", true, true)

			if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_dwf_dwarfs", true, true)
			end

		end
	end

	----  CWD HOLD Brass Keep - Settlement 3
	if brass_keep_region:owning_faction():name() == "wh2_main_nor_rotbloods" then
		----  Brass Keep Spawn: Option 3A
		if 5 == cm:random_number(75, 1) then
			new_chshordespawnmessvalten()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				563,
				532,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_emp_middenland", true, true)

			if cm:get_faction("wh_main_emp_empire"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_emp_empire", true, true)
			end


		elseif 6 == cm:random_number(75, 1) then
			----  West Kislev Spawn: Option 3B
                new_chshordespawnmesskislev()

				cm:create_force(
					"wh2_main_nor_rotbloods",
					"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
					"wh2_main_kingdom_of_beasts_serpent_coast",
					610,
					617,
					true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
					end
				)

			cm:force_declare_war("wh2_main_nor_rotbloods", "wh_main_ksl_kislev", true, true)

		end
	end

	----  CWD HOLD Xahutec - Settlement 4
	if xahutec_region:owning_faction():name() == "wh2_main_nor_rotbloods" then
		if 7 == cm:random_number(75, 1) then
			----  Xauhutec Spawn: Option 4A

			new_chshordespawnmessliz()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				170,
				150,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh2_main_nor_rotbloods", "wh2_main_lzd_itza", true, true)

			if cm:get_faction("wh2_main_lzd_hexoatl"):is_human() then
				cm:force_declare_war("wh2_main_nor_rotbloods", "wh2_main_lzd_hexoatl", true, true)
			end


		elseif 8 == cm:random_number(75, 1) then
			----  East Ulthuan Sea Spawn: Option 4B

			new_chshordespawnmessdelf()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				160,
				450,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh2_main_nor_rotbloods", "wh2_main_hef_eataine", true, true)
	end
end
end

function new_chshordestartmess()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosstart_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosstart_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmess()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawn_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawn_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmessvalten()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnvalten_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnvalten_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmessdwf()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndwf_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndwf_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmessgrn()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawngrn_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawngrn_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmessliz()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnliz_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnliz_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmessdelf()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndelf_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndelf_secondary_detail",
			true,
			2510
		)
	end
end

function new_chshordespawnmesskislev()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnkislev_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnkislev_secondary_detail",
			true,
			2510
		)
	end
end

function new_setup_cwd_and_fimir_raze_region_monitor() -- Applies Chaos corruption via an effect bundle to a region that is razed by an army belonging to CWD & Fimir
	core:add_listener(
		"cwd_and_fimir_raze_region_monitor",
		"CharacterRazedSettlement",
		function(context)
			return context:character():faction():subculture() == "wh_main_sc_nor_warp" or
				context:character():faction():subculture() == "wh_main_sc_nor_fimir"
		end,
		function(context)
			local char = context:character()
			if char:has_region() then
				local region = char:region():name()
				cm:apply_effect_bundle_to_region("wh_main_bundle_region_chaos_corruption", region, 5)
			end
		end,
		true
	)
end

local sorc_agent_art_set_ids = {
	"nurgle_chs_ch_sorcerer_campaign_01",
	"nurgle_chs_ch_sorcerer_campaign_02",
	"nurgle_chs_ch_sorcerer_campaign_03",
	"nurgle_chs_ch_sorcerer_campaign_04",
}

local sorcerer_lord_art_set_ids = {
	"nurgle_chs_ch_sorcerer_lord_campaign_01",
	"nurgle_chs_ch_sorcerer_lord_campaign_02",
	"nurgle_chs_ch_sorcerer_lord_campaign_03",
	"nurgle_chs_ch_sorcerer_lord_campaign_04",
}

local chaos_lord_art_set_ids = {
	"nurgle_chs_ch_chaos_lord_campaign_01",
	"nurgle_chs_ch_chaos_lord_campaign_02",
	"nurgle_chs_ch_chaos_lord_campaign_03",
}

local exalted_hero_art_set_ids = {
	"nurgle_chs_ch_exalted_hero_campaign_01",
	"nurgle_chs_ch_exalted_hero_campaign_02",
	"nurgle_chs_ch_exalted_hero_campaign_03",
	"nurgle_chs_ch_exalted_hero_campaign_04",
	"nurgle_chs_ch_exalted_hero_campaign_05",
}

local forced_art_sets = {}
local blightstomer_campaign_plague_skill_points = {}

---@param char CA_CHAR
local function handle_rotblood_character_art_set(char)
	if char:faction():name() ~= rotbloods_faction_key then return end

	local subtype = char:character_subtype_key()
	local fam_cqi = char:family_member():command_queue_index()

	if forced_art_sets[fam_cqi] then return end

	local art_set_ids = nil
	if subtype == "chs_exalted_hero" then
		art_set_ids = exalted_hero_art_set_ids
	elseif subtype == "chs_lord" then
		art_set_ids = chaos_lord_art_set_ids
	elseif string.find(subtype, "sorcerer_lord") then
		art_set_ids = sorcerer_lord_art_set_ids
	elseif string.find(subtype, "chs_chaos_sorcerer") then
		art_set_ids = sorc_agent_art_set_ids
	end

	if not art_set_ids then return end

	local new_art_set = art_set_ids[cm:random_number(#art_set_ids)]

	forced_art_sets[fam_cqi] = new_art_set
	cm:add_unit_model_overrides(cm:char_lookup_str(char), new_art_set);
end

core:remove_listener("ovn_rotbloods_force_art_set_on_character_created")
core:add_listener(
	"ovn_rotbloods_force_art_set_on_character_created",
	"CharacterCreated",
	true,
	function(context)
		---@type CA_CHAR
		local char = context:character()
		handle_rotblood_character_art_set(char)
	end,
	true
)

core:remove_listener("ovn_rotbloods_force_art_set_on_replaced_general")
core:add_listener(
	"ovn_rotbloods_force_art_set_on_replaced_general",
	"CharacterReplacingGeneral",
	true,
	function(context)
		local char = context:character()
		handle_rotblood_character_art_set(char)
	end,
	true
);

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ovn_rotbloods_forced_art_sets", forced_art_sets, context)
		cm:save_named_value("ovn_rotbloods_blightstomer_campaign_plague_skill_points", blightstomer_campaign_plague_skill_points, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		forced_art_sets = cm:load_named_value("ovn_rotbloods_forced_art_sets", forced_art_sets, context)
		blightstomer_campaign_plague_skill_points = cm:load_named_value("ovn_rotbloods_blightstomer_campaign_plague_skill_points", blightstomer_campaign_plague_skill_points, context)
		OVN_ROT_SKITTERGATE.blightstomer_campaign_plague_skill_points = blightstomer_campaign_plague_skill_points
	end
)

local building_key_from_to_lookup = {
	["wh_main_nor_beasts_1"] = "ovn_rot_monsters_1",
	["wh_main_nor_creatures_1"] = "ovn_rot_monsters_2",
	["wh_main_nor_creatures_2"] = "ovn_rot_monsters_3",
	["wh_main_nor_creatures_3"] = "ovn_rot_monsters_4",
	["ovn_warp_military_1"] = "ovn_rot_military_1",
	["ovn_warp_military_2"] = "ovn_rot_military_2",
	["ovn_warp_military_3"] = "ovn_rot_military_3",
	["ovn_warp_military_4"] = "ovn_rot_military_4",
	["ovn_warp_stables_1"] = "ovn_rot_stables_1",
	["ovn_warp_stables_2"] = "ovn_rot_stables_2",
	["ovn_warp_stables_3"] = "ovn_rot_stables_3",
	["ovn_warp_stables_4"] = "ovn_rot_stables_4",
}

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

local function replace_old_buildings()
	local f = cm:get_faction(rotbloods_faction_key)
	if f and not f:is_null_interface() then
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
end

local function give_visibility_over_clan_fester_regions()
	local clan_fester = cm:get_faction("wh2_dlc12_skv_clan_fester")
	if not clan_fester then return end

	---@type CA_REGION
	for region in binding_iter(clan_fester:region_list()) do
		cm:make_region_visible_in_shroud("wh2_main_nor_rotbloods", region:name())
	end
end

local rotblood_region_visiblity_techs = {
	tech_dlc08_nor_other_13 = true,
	tech_dlc08_nor_nw_01 = true,
	tech_dlc08_nor_other_06 = true,
}

local tech_to_regions_visibility = {
	tech_dlc08_nor_other_06 = {
		"wh_main_couronne_et_languille_couronne",
		"wh_main_the_silver_road_karaz_a_karak",
		"wh_main_tilea_miragliano",
	},
	tech_dlc08_nor_other_13 = {
		"wh_main_reikland_altdorf",
		"wh_main_eastern_sylvania_castle_drakenhof",
		"wh_main_death_pass_karak_drazh",
	},
	tech_dlc08_nor_nw_01 = {
		"wh2_main_iron_mountains_naggarond",
		"wh2_main_eataine_lothern",
		"wh2_main_isthmus_of_lustria_hexoatl",
		"wh2_main_skavenblight_skavenblight",
		"wh2_main_land_of_the_dead_khemri",
		"wh2_main_vampire_coast_the_awakening",
	},
}

local rotblood_faction_key = "wh2_main_nor_rotbloods"

local function give_visibility_over_technology_regions()
	for tech_key in pairs(rotblood_region_visiblity_techs) do
		if cm:get_saved_value("pj_rot_"..tostring(tech_key).."_completed") then
			local regions = tech_to_regions_visibility[tech_key]
			for _, region_key in ipairs(regions) do
				cm:make_region_seen_in_shroud(rotblood_faction_key, region_key)
			end
		end
	end
end

local rotblood_region_visiblity_localized_techs = {
	["Marauders of the West"] = true,
	["Raiders of the East"] = true,
	["Scavengers of the New World"] = true,
}

core:remove_listener("pj_rot_add_tech_effects_cb")
core:add_listener(
	"pj_rot_add_tech_effects_cb",
	"RealTimeTrigger",
	function(context)
		return context.string == "pj_rot_add_tech_effects"
	end,
	function()
			local ui_root = core:get_ui_root()

			local technology_panel = find_uicomponent(ui_root, "technology_panel")
			if not technology_panel then
				real_timer.unregister("pj_rot_add_tech_effects")
				return
			end

			local fod = find_uicomponent(ui_root, "TechTooltipPopup")
			if not fod then return end

			local effects_list = find_uicomponent(fod, "list_parent", "effects_list")
			local title = find_uicomponent(fod, "dy_title")

			if rotblood_region_visiblity_localized_techs[title:GetStateText()] then
				local ui_address = effects_list:Find("pj_new_rot_effect")
				if not ui_address then
					local comp = UIComponent(effects_list:Find(0))
					if not comp then return end
					ui_address = comp:CopyComponent("pj_new_rot_effect")
					if not ui_address then return end
				end

				local comp = UIComponent(ui_address)
				if not comp then return end

				comp:SetImagePath("ui/campaign ui/effect_bundles/treasure_map.png", 0)
				comp:SetStateText("[[col:green]]Gain vision over the targeted regions (and vision over a region is needed to set the region as a Skittergate target).[[/col]]")
			end
	end,
	true
)

core:remove_listener("pj_rot_on_technology_panel_opened")
core:add_listener(
	"pj_rot_on_technology_panel_opened",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "technology_panel"
	end,
	function()
		if cm:get_local_faction_name(true) ~= rotblood_faction_key then return end

		real_timer.unregister("pj_rot_add_tech_effects")
		real_timer.register_repeating("pj_rot_add_tech_effects", 0)
	end,
	true
)

local function spawn_rasknitt()
	local first_region_name = cm:model():world():region_manager():region_list():item_at(0):name()
	local fester_key = "wh2_dlc12_skv_clan_fester"
	cm:get_faction(fester_key):home_region()
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(fester_key, cm:get_faction(fester_key):home_region():name(), false, true, 1);
	if x == -1 then return end

	cm:create_force_with_general(
		fester_key,
		"",
		first_region_name,
		x,
		y,
		"general",
		"wh2_main_skv_grey_seer_ruin",
		"",
		"",
		"names_name_638517960",
		"",
		true,
		function()
			cm:callback(
				function()
					local char = cm:get_faction(fester_key):faction_leader()
					local char_lookup_str = cm:char_lookup_str(char)
					cm:set_character_immortality(char_lookup_str, true)
					cm:set_character_unique(char_lookup_str, true)
					cm:force_add_trait(char_lookup_str, "ovn_trait_rasknitt", false)
					cm:add_unit_model_overrides(char_lookup_str, "wh2_main_art_set_skv_grey_seer_ruin_01");
				end,
				0
			)
		end
	)
end

local blightstormer_plague_chance_per_skill_points = {
	[1] = 8,
	[2] = 12,
	[3] = 15,
}

local blightstormer_plague_friendly_chance_per_skill_points = {
	[1] = 6,
	[2] = 9,
	[3] = 12,
}

local function apply_blightstormer_plagues()
	local faction = cm:get_faction("wh2_main_nor_rotbloods")

	---@type CA_CHAR
	for char in binding_iter(faction:character_list()) do
		if char:character_subtype("rbt_blightstormer") then
			local region = char:has_region() and char:region()
			if region then
				local char_permanent_cqi = tostring(char:family_member():command_queue_index())

				local skill_points = blightstomer_campaign_plague_skill_points[char_permanent_cqi] or 1
				local plague_chance = blightstormer_plague_chance_per_skill_points[skill_points]

				if region:owning_faction():name() == char:faction():name() then
					plague_chance = blightstormer_plague_friendly_chance_per_skill_points[skill_points]
				end

				if cm:random_number(plague_chance) == 1 then
					cm:spawn_plague_at_region(region, "wh2_main_plague_skaven")
				end
			end
		end
	end
end

cm:add_first_tick_callback(
    function()
				-- replace_old_buildings()

				local rotblood_tribe = cm:get_faction("wh2_main_nor_rotbloods")
				if not rotblood_tribe then return end

				if rotblood_tribe:is_human() then
					cm:force_diplomacy("culture:wh2_main_skv_skaven", "faction:wh2_dlc12_skv_clan_fester", "form confederation", false, false, true)

					local new_fester_personality = "wh2_skaven_early_major_hard"
					if cm:model():turn_number() >= 25 then
						new_fester_personality = "wh2_skaven_major_hard"
					end
					cm:callback(function()
						cm:force_change_cai_faction_personality("wh2_dlc12_skv_clan_fester", new_fester_personality);
					end, 1)

					if cm:is_multiplayer() then
						ovn_rotblood_skit_reinforcements_new()
					end
					give_visibility_over_clan_fester_regions()
					give_visibility_over_technology_regions()

					core:remove_listener("ovn_rot_visibility_over_clan_fester_regions")
					core:add_listener(
						"ovn_rot_visibility_over_clan_fester_regions",
						"ScriptEventHumanFactionTurnStart",
						function(context)
							return context:faction():name() == "wh2_main_nor_rotbloods"
						end,
						function()
							give_visibility_over_clan_fester_regions()
							give_visibility_over_technology_regions()
						end,
						true
					)
				end

				cm:force_diplomacy("faction:wh2_main_nor_rotbloods", "faction:wh2_dlc12_skv_clan_fester", "war", false, false, true)
				cm:force_diplomacy("faction:wh2_main_nor_rotbloods", "faction:wh2_dlc12_skv_clan_fester", "break alliance", false, false, true)
				if cm:is_new_game() then
					cm:apply_dilemma_diplomatic_bonus("wh2_main_nor_rotbloods", "wh2_dlc12_skv_clan_fester", 6)
					cm:force_grant_military_access("wh2_dlc12_skv_clan_fester", "wh2_main_nor_rotbloods", false)
					cm:force_alliance("wh2_main_nor_rotbloods", "wh2_dlc12_skv_clan_fester", true)
				end

				local mct = core:get_static_object("mod_configuration_tool")
				local rotblood_value
				local enable_value
				if mct then
					local lost_factions_mod = mct:get_mod_by_key("lost_factions")
					local rotblood_option = lost_factions_mod:get_option_by_key("rotblood")
					rotblood_value = rotblood_option:get_finalized_setting()
					local enable_option = lost_factions_mod:get_option_by_key("enable")
					enable_value = enable_option:get_finalized_setting()
				end

				if rotblood_tribe:is_human() or not mct or rotblood_value and enable_value then
					if cm:is_new_game() then
						spawn_rasknitt()
					end

					core:remove_listener("ovn_rot_apply_blightstormer_plagues")
					core:add_listener(
						"ovn_rot_apply_blightstormer_plagues",
						"FactionTurnStart",
						function(context)
							return context:faction():name() == "wh2_main_nor_rotbloods"
						end,
						function()
							apply_blightstormer_plagues()
						end,
						true
					)

					new_setup_cwd_and_fimir_raze_region_monitor()

					if not rotblood_tribe:is_human() then
						---- Start Event Message Pop Up
						core:add_listener(
							"new_chshordestartmesslistner",
							"FactionRoundStart",
							function(context)
								return context:faction():is_human() and cm:model():turn_number() == 15
							end,
							function()
								new_chshordestartmess()
							end,
							false
						)

						core:add_listener(
							"chshordespawnlistener2",
							"FactionRoundStart",
							function(context)
									return context:faction():name() == "wh2_main_nor_rotbloods" and cm:model():turn_number() > 16
							end,
							function()
									new_chshordespawn()
							end,
							true
						)
					end
				end
    end
)

local original_upkeep_penalty_condition = upkeep_penalty_condition

upkeep_penalty_condition = function(faction, ...)
	local faction_name = faction:name()
	if faction_name == rotblood_faction_key or faction_name == "wh2_main_nor_trollz" then
		return false
	end

	return original_upkeep_penalty_condition(faction, ...)
end;

core:remove_listener("ovn_rot_check_blightstomer_campaign_plague_points")
core:add_listener(
	"ovn_rot_check_blightstomer_campaign_plague_points",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on();
		return skill == "ovn_blightstomer_campaign_plague"
	end,
	function(context)
		local char_permanent_cqi = tostring(context:character():family_member():command_queue_index())
		blightstomer_campaign_plague_skill_points[char_permanent_cqi] = (blightstomer_campaign_plague_skill_points[char_permanent_cqi] or 1) + 1
		OVN_ROT_SKITTERGATE.blightstomer_campaign_plague_skill_points = blightstomer_campaign_plague_skill_points
	end,
	true
)
