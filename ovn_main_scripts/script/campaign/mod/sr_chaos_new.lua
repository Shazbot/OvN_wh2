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

	local oldleader = rotblood_tribe:faction_leader():command_queue_index()

	if rotblood_tribe:is_human() then
			cm:create_force_with_general(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_inf_chaos_warriors_0,wh_main_chs_mon_chaos_spawn,wh_main_chs_cav_chaos_knights_0,wh_dlc01_chs_inf_forsaken_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				583,
				700,
				"general",
				"chs_lord",
				"names_name_1734900068",
				"",
				"",
				"",
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("ovn_Nurgh", cqi, -1, true)
					cm:set_character_unique("character_cqi:" .. cqi, true)
					cm:set_character_immortality("character_cqi:" .. cqi, true)
				end
			)
	else
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
			cm:create_force_with_general(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_inf_chaos_warriors_0,wh_main_chs_mon_chaos_spawn,wh_main_chs_cav_chaos_knights_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				563,
				537,
				"general",
				"chs_lord",
				"names_name_1734900068",
				"",
				"",
				"",
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("ovn_Nurgh", cqi, -1, true)
					cm:set_character_unique("character_cqi:" .. cqi, true)
					cm:set_character_immortality("character_cqi:" .. cqi, true)
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

	cm:transfer_region_to_faction("wh_main_mountains_of_hel_aeslings_conclave", "wh_dlc08_nor_helspire_tribe")
	cm:heal_garrison(cm:get_region("wh_main_mountains_of_hel_aeslings_conclave"):cqi())

	local aos_region = cm:model():world():region_manager():region_by_key("wh_main_mountains_of_hel_altar_of_spawns")
	cm:instantly_set_settlement_primary_slot_level(aos_region:settlement(), 2)

	cm:callback(
		function()
			cm:kill_character(oldleader, true, true)
		end,
		0
	)
	cm:force_make_peace("wh_dlc08_nor_wintertooth", "wh2_main_nor_rotbloods")

	---- Start Event Message Pop Up
	core:add_listener(
		"chshordestartmesslistner",
		"FactionRoundStart",
		function(context)
			return context:faction():is_human() and cm:model():turn_number() == 15
		end,
		function()
			chshordestartmess()
		end,
		false
	)

	---- Chaos Army Spawn Script listener
	if rotblood_tribe:is_human() then
				ovn_rotblood_skit_reinforcements()
	else
			core:add_listener(
					"chshordespawnlistener2",
					"FactionRoundStart",
					function(context)
							return context:faction():name() == "wh2_main_nor_rotbloods" and cm:model():turn_number() > 16
					end,
					function()
							chshordespawn()
					end,
					true
			)
	end

	setup_cwd_and_fimir_raze_region_monitor()
end

function ovn_sr_chaos()
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

		if rotblood_tribe and (rotblood_tribe:is_human() or not mct or rotblood_value and enable_value) then
			if cm:is_new_game() then
				sr_chaos_new_game_setup(rotblood_tribe)
			else -- AKA NOT A NEW GAME - Chaos Army Spawn Script listener loaded on saved game
					if rotblood_tribe:is_human() then
							ovn_rotblood_skit_reinforcements()
					else
							core:add_listener(
									"chshordespawnlistener2",
									"FactionRoundStart",
									function(context)
											return context:faction():name() == "wh2_main_nor_rotbloods" and cm:model():turn_number() > 16
									end,
									function()
											chshordespawn()
									end,
									true
							)
					end

					setup_cwd_and_fimir_raze_region_monitor()
			end
		end
	end
end

function ovn_rotblood_skit_reinforcements()

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

function chshordespawn()
	local kradtommen_region = cm:get_region("wh_main_blightwater_kradtommen")
	local mordheim_region = cm:get_region("wh_main_ostermark_mordheim")
	local xahutec_region = cm:get_region("wh2_main_northern_great_jungle_xahutec")
	local brass_keep_region = cm:get_region("wh_main_hochland_brass_keep")

	----  CWD HOLD KRADTOMMEN - Settlement 1

	if kradtommen_region:owning_faction():name() == "wh2_main_nor_rotbloods" then
		----  Badlands Spawn: Option 1A
		if 1 == cm:random_number(75, 1) then

				chshordespawnmess()

				cm:create_force(
					"wh2_main_nor_rotbloods",
					"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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

				chshordespawnmess()

				cm:create_force(
					"wh2_main_nor_rotbloods",
					"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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

	----  CWD HOLD Mordheim - Settlement 2
	if mordheim_region:owning_faction():name() == "wh2_main_nor_rotbloods" then
		----  Sylvania Spawn: Option 2A
		if 3 == cm:random_number(75, 1) then
			chshordespawnmess()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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
			chshordespawnmessgrn()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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
			chshordespawnmessvalten()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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


				cm:create_force(
					"wh2_main_nor_rotbloods",
					"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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

			chshordespawnmessliz()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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

			chshordespawnmessdelf()

			cm:create_force(
				"wh2_main_nor_rotbloods",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
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

function chshordestartmess()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosstart_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosstart_secondary_detail",
			true,
			595
		)
	end
end

function chshordespawnmess()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawn_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawn_secondary_detail",
			true,
			595
		)
	end
end

function chshordespawnmessvalten()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnvalten_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnvalten_secondary_detail",
			true,
			591
		)
	end
end

function chshordespawnmessdwf()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndwf_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndwf_secondary_detail",
			true,
			595
		)
	end
end

function chshordespawnmessgrn()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawngrn_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawngrn_secondary_detail",
			true,
			593
		)
	end
end

function chshordespawnmessliz()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnliz_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawnliz_secondary_detail",
			true,
			775
		)
	end
end

function chshordespawnmessdelf()
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		cm:show_message_event(
			human_factions[i],
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndelf_primary_detail",
			"",
			"event_feed_strings_text_wh_event_feed_string_scripted_event_chaosspawndelf_secondary_detail",
			true,
			773
		)
	end
end

function setup_cwd_and_fimir_raze_region_monitor() -- Applies Chaos corruption via an effect bundle to a region that is razed by an army belonging to CWD & Fimir
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
