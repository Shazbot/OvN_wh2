function ovn_victory_conditions()
    if cm:model():campaign_name("main_warhammer") then
    if cm:is_new_game() then

        --DREAD KING LEGIONS
        if cm:get_faction("wh2_dlc09_tmb_the_sentinels"):is_human() then

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

        cm:trigger_custom_mission_from_string("wh2_dlc09_tmb_the_sentinels", mission);

        --Amazons
        elseif cm:get_faction("wh2_main_amz_amazons"):is_human() then

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

                    cm:trigger_custom_mission_from_string("wh2_main_amz_amazons", mission);

        --aswad_scythans
        elseif cm:get_faction("wh2_main_arb_aswad_scythans"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_arb_aswad_scythans", mission);

                   --caliphate_of_araby
        elseif cm:get_faction("wh2_main_arb_caliphate_of_araby"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_arb_caliphate_of_araby", mission);

                   --flaming_scimitar
        elseif cm:get_faction("wh2_main_arb_flaming_scimitar"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_arb_flaming_scimitar", mission);

                   --grudgebringers
        elseif cm:get_faction("wh2_main_emp_grudgebringers"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_emp_grudgebringers", mission);

                   --wh2_main_emp_the_moot
        elseif cm:get_faction("wh2_main_emp_the_moot"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_emp_the_moot", mission);

                   --aswad_scythans
        elseif cm:get_faction("wh2_main_nor_albion"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_nor_albion", mission);

                   --Ugma Tribe
        elseif cm:get_faction("wh2_main_nor_trollz"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_nor_trollz", mission);

                   --Fimir Ghost Fells
        elseif cm:get_faction("wh2_main_wef_treeblood"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh2_main_wef_treeblood", mission);

							elseif cm:get_faction("wh2_main_nor_harbingers_of_doom"):is_human() then

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

										cm:trigger_custom_mission_from_string("wh2_main_nor_harbingers_of_doom", mission);

                   --Blood Dragons
        elseif cm:get_faction("wh_main_vmp_rival_sylvanian_vamps"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh_main_vmp_rival_sylvanian_vamps", mission);

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
                   --Rotblood Tribe
        elseif cm:get_faction("wh_dlc08_nor_naglfarlings"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh_dlc08_nor_naglfarlings", mission);

							elseif cm:get_faction("wh2_main_nor_rotbloods"):is_human() then

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

										cm:trigger_custom_mission_from_string("wh2_main_nor_rotbloods", mission);
                   --Fimir servants
        elseif cm:get_faction("wh_dlc08_nor_goromadny_tribe"):is_human() then

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

                cm:trigger_custom_mission_from_string("wh_dlc08_nor_goromadny_tribe", mission);

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

                --Chorfs
            elseif cm:get_faction("wh2_main_ovn_chaos_dwarfs"):is_human() then

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

                    cm:trigger_custom_mission_from_string("wh2_main_ovn_chaos_dwarfs", mission);
        end
    end
    end
    end

    cm:add_first_tick_callback(function() ovn_victory_conditions() end)
