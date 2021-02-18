function ovn_victory_conditions_vortex()
	if cm:is_new_game() then
		--DREAD KING LEGIONS
		if cm:get_faction("wh2_dlc09_tmb_the_sentinels"):is_human() then
			local mission = {[[
				mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_emp_grudgebringers;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 3;
							region wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash;
							region wh2_main_vor_land_of_the_dead_khemri;
							region wh2_main_vor_the_great_desert_black_tower_of_arkhan;
						}
						objective
						{
							type DO_NOT_LOSE_REGION;
							region wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash;
						}
						objective
						{
							type OWN_N_UNITS;
							total 100;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]],
			[[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_emp_grudgebringers;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 3;
							region wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash;
							region wh2_main_vor_land_of_the_dead_khemri;
							region wh2_main_vor_the_great_desert_black_tower_of_arkhan;
						}
						objective
						{
							type DO_NOT_LOSE_REGION;
							region wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash;
						}
						objective
						{
							type OWN_N_UNITS;
							total 150;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_dlc09_tmb_the_sentinels", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_dlc09_tmb_the_sentinels", mission[2]);

		--Amazons
		elseif cm:get_faction("wh2_main_amz_amazons"):is_human() then
			local mission = {[[
				mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 8;
							province wh2_main_vor_the_creeping_jungle;
							province wh2_main_vor_northern_great_jungle;
							province wh2_main_vor_southern_great_jungle;
							province wh2_main_vor_the_vampire_coast;
							province wh2_main_vor_jungles_of_green_mist;
							province wh2_main_vor_headhunters_jungle;
							province wh2_main_vor_volcanic_islands;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc12_skv_clan_fester;
							faction wh2_main_def_blood_hall_coven;
							faction wh2_dlc12_skv_clan_mange;
							faction wh2_main_skv_clan_pestilens;
							faction wh2_dlc11_cst_vampire_coast;
							faction wh2_main_grn_blue_vipers;
							faction wh2_dlc13_emp_the_huntmarshals_expedition;
							faction wh2_main_nor_skeggi;
							confederation_valid;
						}
						objective
						{
							type CAPTURE_X_BATTLE_CAPTIVES;
							total 10000;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_amz_amazons;
							total 3;
							building_level roy_amz_rigg_3;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_amz_amazons;
							total 1;
							building_level roy_amz_temple_3;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_amz_amazons;
							total 3;
							building_level roy_amz_smithy_2;
						}
						objective
						{
							type OWN_N_UNITS;
							total 5;
							additive;
							unit roy_amz_ror_moon_warriors;
							unit roy_amz_ror_guardians_of_the_elixir;
							unit roy_amz_ror_parrot_riders;
							unit roy_amz_ror_cold_one_riders;
							unit roy_amz_ror_sunstaff_kalim;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]],
			[[
				mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 12;
							province wh2_main_vor_the_creeping_jungle;
							province wh2_main_vor_northern_great_jungle;
							province wh2_main_vor_southern_great_jungle;
							province wh2_main_vor_the_vampire_coast;
							province wh2_main_vor_jungles_of_green_mist;
							province wh2_main_vor_headhunters_jungle;
							province wh2_main_vor_volcanic_islands;
							province wh2_main_vor_the_forbidden_jungle;
							province wh2_main_vor_jungle_of_pahualaxa;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc12_skv_clan_fester;
							faction wh2_main_skv_clan_gnaw;
							faction wh2_dlc12_skv_clan_mange;
							faction wh2_main_skv_clan_pestilens;
							faction wh2_main_def_blood_hall_coven;
							faction wh2_dlc11_def_the_blessed_dread;
							faction wh2_dlc11_cst_vampire_coast;
							faction wh2_main_grn_blue_vipers;
							faction wh2_main_nor_skeggi;
							faction wh2_dlc13_emp_the_huntmarshals_expedition;
							confederation_valid;
						}
						objective
						{
							type CAPTURE_X_BATTLE_CAPTIVES;
							total 25000;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_amz_amazons;
							total 5;
							building_level roy_amz_rigg_3;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_amz_amazons;
							total 3;
							building_level roy_amz_temple_3;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_amz_amazons;
							total 7;
							building_level roy_amz_smithy_2;
						}
						objective
						{
							type OWN_N_UNITS;
							total 8;
							additive;
							unit roy_amz_ror_moon_warriors;
							unit roy_amz_ror_guardians_of_the_elixir;
							unit roy_amz_ror_parrot_riders;
							unit roy_amz_ror_cold_one_riders;
							unit roy_amz_ror_sunstaff_kalim;
							unit roy_amz_ror_starblade_warriors;
							unit roy_amz_inf_jungle_stalkers_ror;
							unit roy_amz_ror_anakondas_amazons;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_amz_amazons", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_amz_amazons", mission[2]);

		--aswad_scythans
		elseif cm:get_faction("wh2_main_arb_aswad_scythans"):is_human() then
			local mission = {[[
				mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 10;
							province wh2_main_vor_ash_river;
							province wh2_main_vor_shifting_sands;
							province wh2_main_vor_southern_badlands;
							province wh2_main_vor_land_of_the_dead;
							province wh2_main_vor_southlands_world_edge_mountains;
							province wh2_main_vor_coast_of_araby;
							province wh2_main_vor_the_great_desert;
							province wh2_main_vor_land_of_the_dervishes;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_vmp_necrarch_brotherhood;
							faction wh2_main_grn_arachnos;
							faction wh_main_grn_top_knotz;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							confederation_valid;
						}
						objective
						{
							type ASSASSINATE_X_CHARACTERS;
							total 10;
						}
						objective
						{
							type OWN_N_UNITS;
							total 5;
							additive;
							unit wh2_dlc09_tmb_veh_skeleton_chariot_0;
							unit wh2_dlc09_tmb_cav_necropolis_knights_0;
							unit wh2_dlc09_tmb_mon_ushabti_0;
							unit wh2_dlc09_tmb_inf_nehekhara_warriors_0;
							unit wh2_dlc09_tmb_inf_tomb_guard_1;
							unit ovn_scor;
							unit ovn_arb_cav_scorpion;
							unit wh_main_grn_mon_giant;
						}
						objective
						{
							type OWN_N_UNITS;
							total 12;
							additive;
							unit ovn_yeomanarchers;
							unit OtF_khemri_rangers;
							unit ovn_jez;
							unit ovn_arb_cav_lancer_camel;
							unit ovn_arb_cav_archer_camel;
							unit ovn_arb_cav_jezzail_camel;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_aswad_scythans;
							total 3;
							building_level ovn_arb_nomad_4;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_aswad_scythans;
							total 1;
							building_level ovn_Nehekharan;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]],
			[[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 15;
							province wh2_main_vor_ash_river;
							province wh2_main_vor_shifting_sands;
							province wh2_main_vor_southern_badlands;
							province wh2_main_vor_land_of_the_dead;
							province wh2_main_vor_southlands_world_edge_mountains;
							province wh2_main_vor_coast_of_araby;
							province wh2_main_vor_the_great_desert;
							province wh2_main_vor_land_of_the_dervishes;
							province wh2_main_vor_heart_of_the_jungle;
							province wh2_main_vor_land_of_assassins;
							province wh2_main_vor_great_mortis_delta;
							province wh2_main_vor_cobra_pass;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_vmp_necrarch_brotherhood;
							faction wh2_main_grn_arachnos;
							faction wh_main_grn_top_knotz;
							faction wh2_main_brt_knights_of_origo;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							faction wh2_main_brt_thegans_crusaders;
							faction wh2_main_brt_knights_of_the_flame;
							confederation_valid;
						}
						objective
						{
							type ASSASSINATE_X_CHARACTERS;
							total 25;
						}
						objective
						{
							type OWN_N_UNITS;
							total 8;
							additive;
							unit wh2_dlc09_tmb_veh_skeleton_chariot_0;
							unit wh2_dlc09_tmb_cav_necropolis_knights_0;
							unit wh2_dlc09_tmb_mon_ushabti_0;
							unit wh2_dlc09_tmb_inf_nehekhara_warriors_0;
							unit wh2_dlc09_tmb_inf_tomb_guard_1;
							unit ovn_scor;
							unit ovn_arb_cav_scorpion;
							unit wh_main_grn_mon_giant;
						}
						objective
						{
							type OWN_N_UNITS;
							total 20;
							additive;
							unit ovn_yeomanarchers;
							unit OtF_khemri_rangers;
							unit ovn_jez;
							unit ovn_arb_cav_lancer_camel;
							unit ovn_arb_cav_archer_camel;
							unit ovn_arb_cav_jezzail_camel;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_aswad_scythans;
							total 5;
							building_level ovn_arb_nomad_4;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_aswad_scythans;
							total 1;
							building_level ovn_Nehekharan;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_arb_aswad_scythans", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_arb_aswad_scythans", mission[2]);

		--caliphate_of_araby
		elseif cm:get_faction("wh2_main_arb_caliphate_of_araby"):is_human() then
			local mission = {[[
				mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 10;
							province wh2_main_vor_coast_of_araby;
							province wh2_main_vor_the_great_desert;
							province wh2_main_vor_land_of_assassins;
							province wh2_main_vor_land_of_the_dervishes;
							province wh2_main_vor_land_of_the_dead;
							province wh2_main_vor_great_mortis_delta;
							province wh2_main_vor_southern_badlands;
							province wh2_main_vor_cobra_pass;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							faction wh2_main_brt_thegans_crusaders;
							faction wh2_main_brt_knights_of_origo;
							faction wh_main_grn_top_knotz;
							faction wh2_dlc09_tmb_followers_of_nagash;
							faction wh2_main_lzd_tlaqua;
							faction wh2_dlc09_tmb_rakaph_dynasty;
							faction wh2_main_wef_bowmen_of_oreon;
							confederation_valid;
						}
						objective
						{
							type OWN_N_UNITS;
							total 5;
							unit wh_main_arb_mon_war_elephant;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_caliphate_of_araby;
							total 3;
							building_level ovn_arb_worship_2;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_caliphate_of_araby;
							total 3;
							building_level ovn_arb_stables_3;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_caliphate_of_araby;
							total 1;
							building_level ovn_Nehekharan;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]],
			[[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 15;
							province wh2_main_vor_coast_of_araby;
							province wh2_main_vor_the_great_desert;
							province wh2_main_vor_land_of_assassins;
							province wh2_main_vor_land_of_the_dervishes;
							province wh2_main_vor_ash_river;
							province wh2_main_vor_land_of_the_dead;
							province wh2_main_vor_great_mortis_delta;
							province wh2_main_vor_shifting_sands;
							province wh2_main_vor_southern_badlands;
							province wh2_main_vor_cobra_pass;
							province wh2_main_vor_heart_of_the_jungle;
							province wh2_main_vor_western_jungles;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							faction wh2_main_brt_thegans_crusaders;
							faction wh2_main_brt_knights_of_the_flame;
							faction wh2_main_brt_knights_of_origo;
							faction wh_main_grn_top_knotz;
							faction wh2_dlc09_tmb_followers_of_nagash;
							faction wh2_main_lzd_tlaqua;
							faction wh2_main_dwf_greybeards_prospectors;
							faction wh2_dlc09_tmb_rakaph_dynasty;
							faction wh2_dlc09_tmb_the_sentinels;
							faction wh2_main_wef_bowmen_of_oreon;
							confederation_valid;
						}
						objective
						{
							type OWN_N_UNITS;
							total 10;
							unit wh_main_arb_mon_war_elephant;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_caliphate_of_araby;
							total 5;
							building_level ovn_arb_worship_2;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_caliphate_of_araby;
							total 5;
							building_level ovn_arb_stables_3;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_arb_caliphate_of_araby;
							total 1;
							building_level ovn_Nehekharan;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_arb_caliphate_of_araby", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_arb_caliphate_of_araby", mission[2]);

		--flaming_scimitar
		elseif cm:get_faction("wh2_main_arb_flaming_scimitar"):is_human() then
			local mission = {[[
				mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 5;
							province wh2_main_vor_galleons_graveyard;
							province wh2_main_vor_the_vampire_coast;
							province wh2_main_vor_volcanic_islands;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc11_cst_noctilus;
							faction wh2_dlc11_cst_vampire_coast;
							faction wh2_dlc12_skv_clan_fester;
							faction wh2_main_hef_order_of_loremasters;
							faction wh2_dlc11_def_the_blessed_dread;
							confederation_valid;
						}
						objective
						{
							type OWN_N_UNITS;
							total 5;
							unit ovn_prometheans;
						}
						objective
						{
							type OWN_N_PORTS_INCLUDING;
							total 8;
							region wh2_main_vor_scorpion_coast_temple_of_tlencan;
							region wh2_main_vor_the_vampire_coast_pox_marsh;
							region wh2_main_vor_the_vampire_coast_the_awakening;
							region wh2_main_vor_culchan_plains_chupayotl;
							region wh2_main_vor_coast_of_araby_copher;
							region wh2_main_vor_land_of_assassins_sorcerers_islands;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]],
			[[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 12;
							province wh2_main_vor_galleons_graveyard;
							province wh2_main_vor_the_vampire_coast;
							province wh2_main_vor_volcanic_islands;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc11_cst_noctilus;
							faction wh2_dlc11_cst_vampire_coast;
							faction wh2_dlc12_skv_clan_fester;
							faction wh2_main_hef_order_of_loremasters;
							faction wh2_dlc11_def_the_blessed_dread;
							faction wh2_dlc11_cst_rogue_bleak_coast_buccaneers;
							faction wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast;
							faction wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean;
							faction wh2_dlc11_cst_rogue_grey_point_scuttlers;
							faction wh2_dlc11_cst_rogue_terrors_of_the_dark_straights;
							faction wh2_dlc11_cst_rogue_the_churning_gulf_raiders;
							confederation_valid;
						}
						objective
						{
							type OWN_N_UNITS;
							total 10;
							unit ovn_prometheans;
						}
						objective
						{
							type OWN_N_PORTS_INCLUDING;
							total 16;
							region wh2_main_vor_scorpion_coast_temple_of_tlencan;
							region wh2_main_vor_the_vampire_coast_pox_marsh;
							region wh2_main_vor_the_vampire_coast_the_awakening;
							region wh2_main_vor_culchan_plains_chupayotl;
							region wh2_main_vor_coast_of_araby_copher;
							region wh2_main_vor_land_of_assassins_sorcerers_islands;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_arb_flaming_scimitar", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_arb_flaming_scimitar", mission[2]);

		--grudgebringers
		elseif cm:get_faction("wh2_main_emp_grudgebringers"):is_human() then
			local mission = {[[
				mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc09_tmb_the_sentinels;
							faction wh2_main_skv_clan_skyre;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 1;
							region wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 50;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]],
			[[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc09_tmb_the_sentinels;
							faction wh2_main_skv_clan_skyre;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 1;
							region wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 100;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_emp_grudgebringers", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_emp_grudgebringers", mission[2]);

	--	--Albion
	--	elseif cm:get_faction("wh2_main_nor_albion"):is_human() then
	--
	--		local mission = {[[
	--			 mission
	--			{
	--				victory_type ovn_victory_type_short;
	--				key wh_main_short_victory;
	--				issuer CLAN_ELDERS;
	--				primary_objectives_and_payload
	--				{
	--					objective
	--					{
	--						type CONTROL_N_PROVINCES_INCLUDING;
	--						total 8;
	--						province wh2_main_vor_albion;
	--					}
	--					objective
	--					{
	--						type DESTROY_FACTION;
	--						faction wh2_main_nor_aghol;
	--						faction wh_main_nor_skaeling;
								-- confederation_valid;
	--					}
	--					objective
	--					{
	--						type CONSTRUCT_N_OF_A_BUILDING;
	--						faction wh2_main_nor_albion;
	--						total 1;
	--						building_level elo_great_ogham;
	--					}
	--					payload
	--					{
	--						game_victory;
	--					}
	--				}
	--			}
	--		]],
	--		[[
	--			 mission
	--			{
	--				victory_type ovn_victory_type_long;
	--				key wh_main_long_victory;
	--				issuer CLAN_ELDERS;
	--				primary_objectives_and_payload
	--				{
	--					objective
	--					{
	--						type CONTROL_N_PROVINCES_INCLUDING;
	--						total 15;
	--						province wh2_main_vor_albion;
	--					}
	--					objective
	--					{
	--						type DESTROY_FACTION;
	--						faction wh2_main_nor_aghol;
	--						faction wh_main_nor_skaeling;
								-- confederation_valid;
	--					}
	--					objective
	--					{
	--						type CONSTRUCT_N_OF_A_BUILDING;
	--						faction wh2_main_nor_albion;
	--						total 1;
	--						building_level elo_great_ogham;
	--					}
	--					payload
	--					{
	--						game_victory;
	--					}
	--				}
	--			}
	--		]]}
	--
	--		cm:trigger_custom_mission_from_string("wh2_main_nor_albion", mission[1]);
	--		cm:trigger_custom_mission_from_string("wh2_main_nor_albion", mission[2]);
		end
	end
end

cm:add_first_tick_callback(function() ovn_victory_conditions_vortex() end)
