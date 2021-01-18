function ovn_sr_chaos()
	if cm:model():campaign_name("main_warhammer") then
		cm:force_diplomacy("subculture:wh_main_sc_nor_warp", "culture:wh_main_chs_chaos", "all", true, true, true)
		local rotblood_tribe = cm:get_faction("wh_dlc08_nor_naglfarlings")

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
			if not cm:is_new_game() then -- AKA NOT A NEW GAME - Chaos Army Spawn Script listener loaded on saved game
					if rotblood_tribe:is_human() then
							ovn_rotblood_skit_reinforcements()
					else
							core:add_listener(
									"chshordespawnlistener2",
									"FactionRoundStart",
									function(context)
											return context:faction():name() == "wh_dlc08_nor_naglfarlings" and cm:model():turn_number() > 16
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
            return context:faction():name() == "wh_dlc08_nor_naglfarlings" and context:faction():is_human()
        end,
		function(context)
			local faction_name_str = "wh_dlc08_nor_naglfarlings"
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
                        local faction_name_str = "wh_dlc08_nor_naglfarlings"
                        local faction_name = cm:get_faction(faction_name_str)
                        local choice = context:choice()
                        if choice == 0 then
                            local rb_tele_location = "wh_main_blightwater_kradtommen"
                            local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, rb_tele_location, false, false, 45)
                            if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
                                cm:teleport_to("faction:wh_dlc08_nor_naglfarlings,forename:999982317", w, z, false)
                            end

                    elseif choice == 1 then
                        local rb_tele_location = "wh2_main_northern_great_jungle_xahutec"
                        local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, rb_tele_location, false, false, 45)
                        if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
                            cm:teleport_to("faction:wh_dlc08_nor_naglfarlings,forename:999982317", w, z, false)
                        end

                    elseif choice == 2 then
                        local rb_tele_location = "wh_main_ostermark_mordheim"
                        local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, rb_tele_location, false, false, 45)
                        if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
                            cm:teleport_to("faction:wh_dlc08_nor_naglfarlings,forename:999982317", w, z, false)
                        end

                    end

                    end,
                    false
                    )

                cm:trigger_dilemma("wh_dlc08_nor_naglfarlings" , "ovn_dilemma_rotblood_skit")

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

	if kradtommen_region:owning_faction():name() == "wh_dlc08_nor_naglfarlings" then
		----  Badlands Spawn: Option 1A
		if 1 == cm:random_number(75, 1) then

				chshordespawnmess()

				cm:create_force(
					"wh_dlc08_nor_naglfarlings",
					"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
					"wh2_main_kingdom_of_beasts_serpent_coast",
					767,
					251,
					true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
					end
				)


			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_dwf_karak_azul", true, true)

			if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_dwf_dwarfs", true, true)
			end

			if cm:get_faction("wh_main_grn_greenskins"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_grn_greenskins", true, true)
			end


		elseif 2 == cm:random_number(75, 1) then
			----  Kingdom of Beasts Spawn: Option 1B

				chshordespawnmess()

				cm:create_force(
					"wh_dlc08_nor_naglfarlings",
					"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
					"wh2_main_kingdom_of_beasts_serpent_coast",
					809,
					173,
					true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
					end
				)


			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh2_dlc09_tmb_lybaras", true, true)

			if cm:get_faction("wh2_main_lzd_last_defenders"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh2_main_lzd_last_defenders", true, true)
			end

		end
	end

	----  CWD HOLD Mordheim - Settlement 2
	if mordheim_region:owning_faction():name() == "wh_dlc08_nor_naglfarlings" then
		----  Sylvania Spawn: Option 2A
		if 3 == cm:random_number(75, 1) then
			chshordespawnmess()

			cm:create_force(
				"wh_dlc08_nor_naglfarlings",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				696,
				415,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_vmp_vampire_counts", true, true)

			if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_dwf_dwarfs", true, true)
			end

		elseif 4 == cm:random_number(75, 1) then
			----  North Worlds Edge Mountains Spawn: Option 2B
			chshordespawnmessgrn()

			cm:create_force(
				"wh_dlc08_nor_naglfarlings",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				775,
				450,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_dwf_karak_kadrin", true, true)

			if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_dwf_dwarfs", true, true)
			end

		end
	end

	----  CWD HOLD Brass Keep - Settlement 3
	if brass_keep_region:owning_faction():name() == "wh_dlc08_nor_naglfarlings" then
		----  Brass Keep Spawn: Option 3A
		if 5 == cm:random_number(75, 1) then
			chshordespawnmessvalten()

			cm:create_force(
				"wh_dlc08_nor_naglfarlings",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				563,
				532,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_emp_middenland", true, true)

			if cm:get_faction("wh_main_emp_empire"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_emp_empire", true, true)
			end


		elseif 6 == cm:random_number(75, 1) then
			----  West Kislev Spawn: Option 3B


				cm:create_force(
					"wh_dlc08_nor_naglfarlings",
					"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
					"wh2_main_kingdom_of_beasts_serpent_coast",
					610,
					617,
					true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
					end
				)

			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh_main_ksl_kislev", true, true)

		end
	end

	----  CWD HOLD Xahutec - Settlement 4
	if xahutec_region:owning_faction():name() == "wh_dlc08_nor_naglfarlings" then
		if 7 == cm:random_number(75, 1) then
			----  Xauhutec Spawn: Option 4A

			chshordespawnmessliz()

			cm:create_force(
				"wh_dlc08_nor_naglfarlings",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				170,
				150,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh2_main_lzd_itza", true, true)

			if cm:get_faction("wh2_main_lzd_hexoatl"):is_human() then
				cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh2_main_lzd_hexoatl", true, true)
			end


		elseif 8 == cm:random_number(75, 1) then
			----  East Ulthuan Sea Spawn: Option 4B

			chshordespawnmessdelf()

			cm:create_force(
				"wh_dlc08_nor_naglfarlings",
				"wh_main_chs_cav_chaos_knights_1,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_1,wh_main_chs_art_hellcannon,wh_main_chs_mon_giant,wh_dlc06_chs_feral_manticore,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh2_main_skv_mon_rat_ogres,wh_main_chs_cav_chaos_knights_0,wh2_main_skv_inf_clanrats_1,wh_dlc01_chs_inf_chaos_warriors_2,wh2_main_skv_inf_stormvermin_1,wh_dlc01_chs_inf_forsaken_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0,wh2_main_skv_inf_skavenslaves_0",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				160,
				450,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, -1, true)
				end
			)

			cm:force_declare_war("wh_dlc08_nor_naglfarlings", "wh2_main_hef_eataine", true, true)

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
