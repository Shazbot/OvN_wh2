function ovn_victory_conditions()
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
							total 9;
							region wh_main_reikland_altdorf;
							region wh_main_southern_oblast_kislev;
							region wh2_main_great_mortis_delta_black_pyramid_of_nagash;
							region wh_main_lyonesse_mousillon;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh2_main_marshes_of_madness_morgheim;
							region wh_main_southern_grey_mountains_karak_norn;
							region wh_main_northern_grey_mountains_blackstone_post;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
						}
						objective
						{
							type DO_NOT_LOSE_REGION;
							region wh2_main_great_mortis_delta_black_pyramid_of_nagash;
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
							total 9;
							region wh_main_reikland_altdorf;
							region wh_main_southern_oblast_kislev;
							region wh2_main_great_mortis_delta_black_pyramid_of_nagash;
							region wh_main_lyonesse_mousillon;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh2_main_marshes_of_madness_morgheim;
							region wh_main_southern_grey_mountains_karak_norn;
							region wh_main_northern_grey_mountains_blackstone_post;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
						}
						objective
						{
							type DO_NOT_LOSE_REGION;
							region wh2_main_great_mortis_delta_black_pyramid_of_nagash;
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
							province wh2_main_the_creeping_jungle;
							province wh2_main_northern_great_jungle;
							province wh2_main_southern_great_jungle;
							province wh2_main_vampire_coast;
							province wh2_main_jungles_of_green_mists;
							province wh2_main_headhunters_jungle;
							province wh2_main_volcanic_islands;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc12_skv_clan_fester;
							faction wh2_main_skv_clan_gnaw;
							faction wh2_dlc12_skv_clan_mange;
							faction wh2_main_skv_clan_pestilens;
							faction wh2_main_grn_blue_vipers;
							faction wh2_dlc11_cst_vampire_coast;
							faction wh2_dlc11_def_the_blessed_dread;
							faction wh2_dlc13_emp_the_huntmarshals_expedition;
							faction wh2_main_nor_skeggi;
							confederation_valid;
						}
						objective
						{
							type CAPTURE_X_BATTLE_CAPTIVES;
							total 15000;
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
							province wh2_main_the_creeping_jungle;
							province wh2_main_northern_great_jungle;
							province wh2_main_southern_great_jungle;
							province wh2_main_vampire_coast;
							province wh2_main_jungles_of_green_mists;
							province wh2_main_headhunters_jungle;
							province wh2_main_volcanic_islands;
							province wh2_main_huahuan_desert;
							province wh2_main_southern_jungle_of_pahualaxa;
							province wh2_main_northern_jungle_of_pahualaxa;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc12_skv_clan_fester;
							faction wh2_main_skv_clan_gnaw;
							faction wh2_dlc12_skv_clan_mange;
							faction wh2_main_skv_clan_pestilens;
							faction wh2_main_grn_blue_vipers;
							faction wh2_main_def_cult_of_pleasure;
							faction wh2_dlc11_def_the_blessed_dread;
							faction wh2_dlc11_cst_vampire_coast;
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
							type OWN_N_UNITS;
							total 8;
							additive;
							unit roy_amz_ror_moon_warriors;
							unit roy_amz_ror_guardians_of_the_elixir;
							unit roy_amz_ror_parrot_riders;
							unit roy_amz_ror_cold_one_riders;
							unit roy_amz_ror_sunstaff_kalim;
							unit roy_amz_ror_anakondas_amazons;
							unit roy_amz_ror_starblade_warriors;
							unit roy_amz_inf_jungle_stalkers_ror;
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
							total 5;
							building_level roy_amz_smithy_2;
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
							type CAPTURE_REGIONS;
							region wh_main_blood_river_valley_varenka_hills;
							ignore_allies;
						}
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 8;
							province wh2_main_ash_river;
							province wh2_main_shifting_sands;
							province wh_main_southern_badlands;
							province wh2_main_charnel_valley;
							province wh2_main_southlands_worlds_edge_mountains;
							province wh2_main_coast_of_araby;
							province wh2_main_great_desert_of_araby;
							province wh2_main_land_of_the_dervishes;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_vmp_necrarch_brotherhood;
							faction wh2_main_grn_arachnos;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							faction wh2_main_brt_thegans_crusaders;
							faction wh2_main_brt_knights_of_the_flame;
							faction wh2_main_brt_knights_of_origo;
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
							type CAPTURE_REGIONS;
							region wh_main_blood_river_valley_varenka_hills;
							ignore_allies;
						}
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 12;
							province wh2_main_ash_river;
							province wh2_main_shifting_sands;
							province wh_main_southern_badlands;
							province wh2_main_heart_of_the_jungle;
							province wh2_main_charnel_valley;
							province wh2_main_great_desert_of_araby;
							province wh2_main_southlands_worlds_edge_mountains;
							province wh2_main_coast_of_araby;
							province wh2_main_land_of_assassins;
							province wh2_main_land_of_the_dervishes;
							province wh2_main_land_of_the_dead;
							province wh2_main_great_mortis_delta;
							province wh2_main_atalan_mountains;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_vmp_necrarch_brotherhood;
							faction wh2_main_grn_arachnos;
							faction wh_main_grn_top_knotz;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							faction wh2_main_brt_thegans_crusaders;
							faction wh2_main_brt_knights_of_the_flame;
							faction wh2_main_brt_knights_of_origo;
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
							province wh2_main_coast_of_araby;
							province wh2_main_great_desert_of_araby;
							province wh2_main_land_of_assassins;
							province wh2_main_land_of_the_dervishes;
							province wh2_main_land_of_the_dead;
							province wh2_main_great_mortis_delta;
							province wh_main_southern_badlands;
							province wh2_main_atalan_mountains;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc14_brt_chevaliers_de_lyonesse;
							faction wh2_main_brt_knights_of_the_flame;
							faction wh2_main_brt_thegans_crusaders;
							faction wh2_main_brt_knights_of_origo;
							faction wh_main_grn_top_knotz;
							faction wh2_dlc09_tmb_followers_of_nagash;
							faction wh2_main_lzd_tlaqua;
							faction wh2_dlc09_tmb_rakaph_dynasty;
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
							province wh2_main_coast_of_araby;
							province wh2_main_great_desert_of_araby;
							province wh2_main_land_of_assassins;
							province wh2_main_land_of_the_dervishes;
							province wh2_main_ash_river;
							province wh2_main_land_of_the_dead;
							province wh2_main_great_mortis_delta;
							province wh2_main_shifting_sands;
							province wh_main_southern_badlands;
							province wh2_main_atalan_mountains;
							province wh2_main_heart_of_the_jungle;
							province wh_main_tilea;
							province wh2_main_skavenblight;
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
							faction wh2_dlc09_tmb_rakaph_dynasty;
							faction wh2_main_dwf_greybeards_prospectors;
							faction wh2_dlc09_tmb_the_sentinels;
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
							province wh2_main_galleons_graveyard;
							province wh2_main_vampire_coast;
							province wh2_main_volcanic_islands;
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
							region wh2_main_northern_great_jungle_temple_of_tlencan;
							region wh2_main_vampire_coast_pox_marsh;
							region wh2_main_vampire_coast_the_awakening;
							region wh2_main_headhunters_jungle_chupayotl;
							region wh2_main_coast_of_araby_copher;
							region wh2_main_land_of_assassins_sorcerers_islands;
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
							province wh2_main_galleons_graveyard;
							province wh2_main_vampire_coast;
							province wh2_main_volcanic_islands;
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
							region wh2_main_northern_great_jungle_temple_of_tlencan;
							region wh2_main_vampire_coast_pox_marsh;
							region wh2_main_vampire_coast_the_awakening;
							region wh2_main_headhunters_jungle_chupayotl;
							region wh2_main_coast_of_araby_copher;
							region wh2_main_land_of_assassins_sorcerers_islands;
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
							faction wh_main_vmp_vampire_counts;
							faction wh2_main_skv_clan_skyre;
							faction wh2_dlc15_skv_clan_ferrik;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 9;
							region wh_main_reikland_altdorf;
							region wh_main_southern_oblast_kislev;
							region wh2_main_great_mortis_delta_black_pyramid_of_nagash;
							region wh_main_lyonesse_mousillon;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh2_main_marshes_of_madness_morgheim;
							region wh_main_southern_grey_mountains_karak_norn;
							region wh_main_northern_grey_mountains_blackstone_post;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
							region wh_main_zhufbar_zhufbar;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 30;
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
							faction wh_main_vmp_vampire_counts;
							faction wh2_main_skv_clan_skyre;
							faction wh2_dlc15_skv_clan_ferrik;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 9;
							region wh_main_reikland_altdorf;
							region wh_main_southern_oblast_kislev;
							region wh2_main_great_mortis_delta_black_pyramid_of_nagash;
							region wh_main_lyonesse_mousillon;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh2_main_marshes_of_madness_morgheim;
							region wh_main_southern_grey_mountains_karak_norn;
							region wh_main_northern_grey_mountains_blackstone_post;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
							region wh_main_zhufbar_zhufbar;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 75;
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

		--wh2_main_emp_the_moot
		elseif cm:get_faction("wh2_main_emp_the_moot"):is_human() then
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
							type SCRIPTED;
							script_key ovn_hlf_collect_all_ingredients;
							override_text mission_text_text_hlf_collect_all_ingredients_description;
						}
						objective
						{
							type SCRIPTED;
							script_key ovn_hlf_establish_restaurants;
							override_text mission_text_text_hlf_establish_restaurants_description;
						}
						objective
						{
							type OWN_N_PROVINCES;
							total 1;
						}
						objective
						{
							type OWN_N_UNITS;
							total 6;
							unit halfling_cook;
							unit hlf_roast_pig;
						}
						objective
						{
							type OWN_N_UNITS;
							total 3;
							unit wh_main_mtl_veh_soupcart;
							unit halfling_cook_ror;
							unit sr_ogre_ror;
						}
						objective
						{
							type SEARCH_RUINS;
							total 5;
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
							type CONTROL_N_REGIONS_FROM;
							total 10;
							region wh_main_stirland_the_moot;
							region wh_main_reikland_altdorf;
							region wh_main_wissenland_nuln;
							region wh_main_middenland_middenheim;
							region wh_main_talabecland_talabheim;
							region wh_main_stirland_wurtbad;
							region wh_main_ostermark_bechafen;
							region wh_main_ostland_wolfenburg;
							region wh_main_hochland_hergig;
							region wh_main_nordland_salzenmund;
							region wh_main_averland_averheim;
							region wh_main_southern_oblast_kislev;
						}
						objective
						{
							type SCRIPTED;
							script_key ovn_hlf_collect_all_ingredients;
							override_text mission_text_text_hlf_collect_all_ingredients_description;
						}
						objective
						{
							type SCRIPTED;
							script_key ovn_hlf_establish_restaurants;
							override_text mission_text_text_hlf_establish_restaurants_description;
						}
						objective
						{
							type OWN_N_UNITS;
							total 10;
							unit halfling_cook;
							unit hlf_roast_pig;
						}
						objective
						{
							type OWN_N_UNITS;
							total 5;
							unit wh_main_mtl_veh_soupcart;
							unit halfling_cook_ror;
							unit halfling_cat_ror;
							unit halfling_cock;
							unit sr_ogre_ror;
						}
						objective
						{
							type SEARCH_RUINS;
							total 10;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_emp_the_moot", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_emp_the_moot", mission[2]);

		--Albion
		elseif cm:get_faction("wh2_main_nor_albion"):is_human() then

	--		objective
	--		{
	--			override_text mission_text_text_mis_activity_archaon_spawned;
	--			type SCRIPTED;
	--			script_key archaon_spawned;
	--		}
		--	objective
		--	{
		--		type HAVE_CHARACTER_WOUNDED;
		--		override_text mission_text_text_wh_main_objective_override_archaon_wounded;
		--		start_pos_character 2140782858;
		--	}
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
							province wh2_main_albion;
						}
						objective
						{
							type LIMIT_FACTION_TO_REGIONS;
							faction wh_main_chs_chaos;
							faction wh_dlc03_bst_beastmen_chaos;
							region wh_main_chaos_wastes;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_nor_harbingers_of_doom;
							faction wh2_main_nor_rotbloods;
							faction wh_dlc08_nor_norsca;
							confederation_valid;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_nor_albion;
							total 3;
							building_level ovn_Waystone_3;
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
							province wh2_main_albion;
						}
						objective
						{
							type LIMIT_FACTION_TO_REGIONS;
							faction wh_main_chs_chaos;
							faction wh_dlc03_bst_beastmen_chaos;
							region wh_main_chaos_wastes;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_nor_harbingers_of_doom;
							faction wh2_main_nor_rotbloods;
							faction wh_dlc08_nor_norsca;
							faction wh_dlc08_nor_wintertooth;
							faction wh_dlc08_nor_vanaheimlings;
							confederation_valid;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction wh2_main_nor_albion;
							total 3;
							building_level ovn_Waystone_3;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_nor_albion", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_nor_albion", mission[2]);

		--Ugma Tribe
		elseif cm:get_faction("wh2_main_nor_trollz"):is_human() then

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
							total 1;
							province wh_main_blightwater;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh_main_grn_red_fangs;
							faction wh_main_grn_broken_nose;
							faction wh_main_dwf_karak_azul;
							confederation_valid;
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
							type CONTROL_N_PROVINCES_INCLUDING;
							total 1;
							province wh_main_blightwater;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh_main_grn_red_fangs;
							faction wh_main_grn_broken_nose;
							faction wh_main_dwf_karak_azul;
							confederation_valid;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 85;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_nor_trollz", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_nor_trollz", mission[2]);

		--Harbingers of Doom
		elseif cm:get_faction("wh2_main_nor_harbingers_of_doom"):is_human() then
			--objective
			--{
			--	type AT_LEAST_X_RELIGION_IN_PROVINCES;
			--	province wh2_main_albion;
			--	total 100;
			--}

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
							province wh2_main_albion;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_nor_albion;
							confederation_valid;
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
							type CONTROL_N_PROVINCES_INCLUDING;
							total 15;
							province wh2_main_albion;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_main_nor_albion;
							confederation_valid;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 80;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_nor_harbingers_of_doom", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_nor_harbingers_of_doom", mission[2]);

		elseif cm:get_faction("wh2_main_vmp_blood_dragons"):is_human() then

			local mission = [[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 17;
							region wh_main_couronne_et_languille_couronne;
							region wh_main_reikland_altdorf;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
							region wh_main_tilea_miragliano;
							region wh2_main_skavenblight_skavenblight;
							region wh_main_southern_oblast_kislev;
							region wh2_main_hell_pit_hell_pit;
							region wh_main_the_silver_road_karaz_a_karak;
							region wh_main_eastern_badlands_karak_eight_peaks;
							region wh_main_death_pass_karak_drazh;
							region wh2_main_devils_backbone_lahmia;
							region wh2_main_land_of_the_dead_khemri;
							region wh2_main_southern_great_jungle_itza;
							region wh2_main_isthmus_of_lustria_hexoatl;
							region wh2_main_iron_mountains_naggarond;
							region wh2_main_eataine_lothern;
							region wh2_main_avelorn_gaean_vale;
							region wh2_main_vampire_coast_the_awakening;
							region wh2_main_the_galleons_graveyard;
							region wh2_main_sartosa_sartosa;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]

			cm:trigger_custom_mission_from_string("wh2_main_vmp_blood_dragons", mission);

		elseif cm:get_faction("wh2_main_nor_rotbloods"):is_human() then

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
							type CONTROL_N_REGIONS_FROM;
							total 5;
							region wh_main_reikland_altdorf;
							region wh_main_blightwater_karak_azgal;
							region wh2_main_northern_great_jungle_xahutec;
							region wh_main_hochland_brass_keep;
							region wh_main_blightwater_kradtommen;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh_main_emp_empire;
							faction wh2_dlc13_emp_golden_order;
							confederation_valid;
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
							type CONTROL_N_REGIONS_FROM;
							total 5;
							region wh_main_reikland_altdorf;
							region wh_main_blightwater_karak_azgal;
							region wh2_main_northern_great_jungle_xahutec;
							region wh_main_hochland_brass_keep;
							region wh_main_blightwater_kradtommen;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh_main_emp_empire;
							faction wh2_dlc13_emp_golden_order;
							faction wh_main_emp_hochland;
							faction wh_main_emp_middenland;
							confederation_valid;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 80;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_nor_rotbloods", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_nor_rotbloods", mission[2]);

		elseif cm:get_faction("wh2_main_nor_servants_of_fimulneid"):is_human() then

			local mission = [[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 17;
							region wh_main_couronne_et_languille_couronne;
							region wh_main_reikland_altdorf;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
							region wh_main_tilea_miragliano;
							region wh2_main_skavenblight_skavenblight;
							region wh_main_southern_oblast_kislev;
							region wh2_main_hell_pit_hell_pit;
							region wh_main_the_silver_road_karaz_a_karak;
							region wh_main_eastern_badlands_karak_eight_peaks;
							region wh_main_death_pass_karak_drazh;
							region wh2_main_devils_backbone_lahmia;
							region wh2_main_land_of_the_dead_khemri;
							region wh2_main_southern_great_jungle_itza;
							region wh2_main_isthmus_of_lustria_hexoatl;
							region wh2_main_iron_mountains_naggarond;
							region wh2_main_eataine_lothern;
							region wh2_main_avelorn_gaean_vale;
							region wh2_main_vampire_coast_the_awakening;
							region wh2_main_the_galleons_graveyard;
							region wh2_main_sartosa_sartosa;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]

			cm:trigger_custom_mission_from_string("wh2_main_nor_servants_of_fimulneid", mission);

		--Citadel of Dusk
		elseif cm:get_faction("wh2_main_hef_citadel_of_dusk"):is_human() then

			local mission = [[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_REGIONS_FROM;
							total 17;
							region wh_main_couronne_et_languille_couronne;
							region wh_main_reikland_altdorf;
							region wh_main_eastern_sylvania_castle_drakenhof;
							region wh_main_yn_edri_eternos_the_oak_of_ages;
							region wh_main_tilea_miragliano;
							region wh2_main_skavenblight_skavenblight;
							region wh_main_southern_oblast_kislev;
							region wh2_main_hell_pit_hell_pit;
							region wh_main_the_silver_road_karaz_a_karak;
							region wh_main_eastern_badlands_karak_eight_peaks;
							region wh_main_death_pass_karak_drazh;
							region wh2_main_devils_backbone_lahmia;
							region wh2_main_land_of_the_dead_khemri;
							region wh2_main_southern_great_jungle_itza;
							region wh2_main_isthmus_of_lustria_hexoatl;
							region wh2_main_iron_mountains_naggarond;
							region wh2_main_eataine_lothern;
							region wh2_main_avelorn_gaean_vale;
							region wh2_main_vampire_coast_the_awakening;
							region wh2_main_the_galleons_graveyard;
							region wh2_main_sartosa_sartosa;
						}
						payload
						{
							game_victory;
						}
					}
				}
			]]

			cm:trigger_custom_mission_from_string("wh2_main_hef_citadel_of_dusk", mission);
		end
	end
end

    cm:add_first_tick_callback(function() ovn_victory_conditions() end)
