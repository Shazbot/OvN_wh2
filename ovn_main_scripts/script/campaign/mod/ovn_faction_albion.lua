local function setup_diplo()

local ovn_albion_anc_pool = {
"albion_hunting_dog",
"albion_lone_huntress",
"albion_woad_raider",
"albion_tame_raven",
"albion_druid_advisor",
"albion_chief",
"albion_old_warrior",
"albion_scavanger",
"albion_woman",
"fenbeast_follower",
"hearthguard_follower",
"druid_neophyte",
"albion_hardened_warrior",
"albion_scary_banner",
"anc_albion_triskele_banner",
"anc_danu_banner",
"anc_albion_hunter_banner",
"anc_albion_staff_of_light",
"anc_albion_talisman_triskele",
"anc_albion_hammer_giant",
"anc_albion_sun_shield",
"anc_hunter_spear",
"anc_dagger_shadow",
"anc_albion_chainmail",
"anc_albion_helmet_leader",
"anc_albion_talisman_danu",
"anc_albion_talisman_belakor",
"anc_albion_scepter_old_ones",
"anc_albion_staff_of_darkness",
"anc_albion_hound_statue",
"anc_albion_skull_trophies"
}

local random_number = cm:random_number(#ovn_albion_anc_pool, 1)
local anc_key = ovn_albion_anc_pool[random_number]

    core:add_listener(
     "albion_anc_random_drop",
     "CharacterTurnStart",
     function(context)
    return context:character():faction():name() == "wh2_main_nor_albion" end,
     function(context)
        local random_number = cm:random_number(#ovn_albion_anc_pool, 1)
        local anc_key = ovn_albion_anc_pool[random_number]
        local current_char = context:character()
        if not current_char:character_type("colonel") then
        effect.ancillary(anc_key, 5, context)
        end
    end,
    true)

    core:add_listener(
        "albion_anc_win_battle_drop",
        "CharacterCompletedBattle",
            function(context)
                local char = context:character()
                return context:character():faction():name() == "wh2_main_nor_albion"
                and char:won_battle()
                and not char:is_wounded()
                and not char:routed_in_battle()
            end,
            function(context)
                     effect.ancillary(anc_key, 8, context)

            end,
            true
            );

            if cm:get_faction("wh2_main_nor_albion"):is_human() then
            if cm:model():turn_number() < 3 then


                core:add_listener(
                    "ovn_dilemma_alb_alt_leader_listener_trigger",
                    "FactionTurnStart",
                    function(context) return context:faction():is_human() and cm:model():turn_number() == 2
                    end,
                    function(context)
                        local faction_name_str = cm:get_local_faction_name()

                            core:add_listener(
                                "ovn_dilemma_alb_alt_leader_listener",
                                "DilemmaChoiceMadeEvent",
                                function(context) return context:dilemma():starts_with("ovn_dilemma_alb_alt_leader") end,
                                function(context)
                                    local choice = context:choice()
                                    if choice == 1 then
                                        if cm:model():campaign_name("main_warhammer") then
                                            cm:create_force_with_general(
                                            "wh2_main_nor_albion",
                                            "elo_youngbloods,albion_centaurs,albion_giant,elo_albion_warriors,albion_hearthguard,druid_neophytes",
                                            "wh2_main_great_desert_of_araby_el-kalabad",
                                            321,
                                            547,
                                            "general",
                                            "bl_elo_dural_durak",
                                            "names_name_77777202",
                                            "",
                                            "names_name_77777201",
                                            "",
                                            true,
                                            function(cqi)
                                            cm:set_character_immortality("faction:wh2_main_nor_albion,forename:77777202", true);
                                            cm:set_character_unique("character_cqi:" .. cqi, true)
                                        end)

                                            else

                                            cm:create_force_with_general(
                                            "wh2_main_nor_albion",
                                            "elo_youngbloods,albion_centaurs,albion_giant,elo_albion_warriors,albion_hearthguard,druid_neophytes",
                                            "wh2_main_vor_coast_of_araby_al_haikk",
                                            655,
                                            656,
                                            "general",
                                            "bl_elo_dural_durak",
                                            "names_name_77777202",
                                            "",
                                            "names_name_77777201",
                                            "",
                                            true,
                                            function(cqi)
                                            cm:set_character_immortality("faction:wh2_main_nor_albion,forename:77777202", true);
                                            cm:set_character_unique("character_cqi:" .. cqi, true)
                                        end)

                                        end

                                        elseif choice == 0 then

                                        if cm:model():campaign_name("main_warhammer") then
                                        cm:create_force_with_general(
                                        "wh2_main_nor_albion",
                                        "elo_youngbloods,albion_giant,albion_swordmaiden,elo_albion_warriors,albion_hearthguard,albion_riders_spear",
                                        "wh2_main_great_desert_of_araby_el-kalabad",
                                        321,
                                        547,
                                        "general",
                                        "albion_morrigan",
                                        "names_name_77777001",
                                        "",
                                        "names_name_77777002",
                                        "",
                                        true,
                                        function(cqi)
                                        cm:set_character_immortality("faction:wh2_main_nor_albion,forename:77777001", true);
                                        cm:set_character_unique("character_cqi:" .. cqi, true)
                                    end)

                                        else

                                        cm:create_force_with_general(
                                        "wh2_main_nor_albion",
                                        "elo_youngbloods,albion_giant,albion_swordmaiden,elo_albion_warriors,albion_hearthguard,albion_riders_spear",
                                        "wh2_main_vor_coast_of_araby_al_haikk",
                                        655,
                                        656,
                                        "general",
                                        "albion_morrigan",
                                        "names_name_77777001",
                                        "",
                                        "names_name_77777002",
                                        "",
                                        true,
                                        function(cqi)
                                        cm:set_character_immortality("faction:wh2_main_nor_albion,forename:77777001", true);
                                        cm:set_character_unique("character_cqi:" .. cqi, true)
                                    end)

                                        end

                                end

                                end,
                                false
                                )

                            cm:trigger_dilemma(faction_name_str, "ovn_dilemma_alb_alt_leader")

                    end,
                    true
                );

            end
        elseif cm:model():turn_number() < 3 then


            core:add_listener(
                    "ovn_dilemma_alb_alt_leader_listener_trigger",
                    "FactionTurnStart",
                    function(context) return context:faction():is_human() and cm:model():turn_number() == 2
                    end,
                    function(context)

                        cm:spawn_character_to_pool(
                            "wh2_main_nor_albion",
                            "names_name_77777001",
                            "names_name_77777002",
                            "",
                            "",
                            18,
                            true,
                            "general",
                            "albion_morrigan",
                            true,
                            ""
                        )

            if cm:model():campaign_name("main_warhammer") then
                cm:create_force_with_general(
                "wh2_main_nor_albion",
                "elo_youngbloods,albion_centaurs,albion_giant,elo_albion_warriors,albion_swordmaiden",
                "wh2_main_great_desert_of_araby_el-kalabad",
                321,
                547,
                "general",
                "bl_elo_dural_durak",
                "names_name_77777202",
                "",
                "names_name_77777201",
                "",
                true,
                function(cqi)
                cm:set_character_immortality("faction:wh2_main_nor_albion,forename:77777202", true);
                cm:set_character_unique("character_cqi:" .. cqi, true)
            end)

                else

                cm:create_force_with_general(
                "wh2_main_nor_albion",
                "elo_youngbloods,albion_centaurs,albion_giant,elo_albion_warriors,albion_swordmaiden",
                "wh2_main_vor_coast_of_araby_al_haikk",
                655,
                656,
                "general",
                "bl_elo_dural_durak",
                "names_name_77777202",
                "",
                "names_name_77777201",
                "",
                true,
                function(cqi)
                cm:set_character_immortality("faction:wh2_main_nor_albion,forename:77777202", true);
                cm:set_character_unique("character_cqi:" .. cqi, true)
            end)
        end

        end,
        true
    );

end

    if cm:model():campaign_name("main_warhammer") then
--- ALBION MIST MECHANIC (ME ONLY)
	random_army_manager:new_force("ovn_albion_mist_vamp_coast_force");
    random_army_manager:add_mandatory_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_1", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_necrofex_colossus_0", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_terrorgheist", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_inf_syreens", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_inf_deck_gunners_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_art_mortar", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_mournguls_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_bloated_corpse_0", 2);
	random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_cav_deck_droppers_1", 2);
	random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 3);
	random_army_manager:add_unit("ovn_albion_mist_vamp_coast_force", "wh2_dlc11_cst_mon_fell_bats", 2);

    random_army_manager:new_force("ovn_albion_mist_norsca_force");
    random_army_manager:add_mandatory_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_fimir_1", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_war_mammoth_2", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_inf_marauder_champions_0", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_norsca_force", "elo_woadraider", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_skinwolves_1", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_art_hellcannon_battery", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_war_mammoth_1", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_main_nor_cav_marauder_horsemen_1", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "albion_centaurs", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "albion_giant", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "ovn_alb_inf_stone_throw_giant", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_inf_marauder_champions_1", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_fimir_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_mon_norscan_ice_trolls_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "albion_huntresses", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "albion_riders", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_dlc08_nor_inf_marauder_berserkers_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "wh_main_nor_inf_chaos_marauders_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_norsca_force", "elo_woadraider", 2);

    random_army_manager:new_force("ovn_albion_mist_skaven_force");
    random_army_manager:add_mandatory_unit("ovn_albion_mist_skaven_force", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_art_plagueclaw_catapult", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_stormvermin_0", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_skaven_force", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_art_warp_lightning_cannon", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_plague_monk_censer_bearer", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_poison_wind_globadiers", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_dlc14_skv_inf_eshin_triads_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_gutter_runners_1", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_night_runners_1", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_warpfire_thrower", 1);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_stormvermin_1", 2);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_mon_rat_ogres", 2);
    random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_veh_doomwheel", 1);
	random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_dlc12_skv_veh_doom_flayer_0", 1);
	random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_skavenslaves_0", 4);
	random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_skavenslave_slingers_0", 2);
	random_army_manager:add_unit("ovn_albion_mist_skaven_force", "wh2_main_skv_inf_clanrats_1", 3);

	random_army_manager:new_force("ovn_albion_mist_greenskin_force");
    random_army_manager:add_mandatory_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_art_doom_diver_catapult", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_inf_orc_big_uns", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_inf_night_goblin_fanatics", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_mon_arachnarok_spider_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_mon_trolls", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_mon_giant", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_1", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_cav_orc_boar_boy_big_uns", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_cav_goblin_wolf_riders_1", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_dlc06_grn_inf_squig_herd_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_dlc06_grn_inf_nasty_skulkers_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_inf_night_goblin_archers", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_inf_night_goblins", 1);
    random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_inf_goblin_archers", 1);
	random_army_manager:add_unit("ovn_albion_mist_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);

	random_army_manager:new_force("ovn_albion_mist_dark_elves_force");
    random_army_manager:add_mandatory_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_har_ganeth_executioners_0", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_dark_elves_force", "wh2_dlc10_def_inf_sisters_of_slaughter", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_darkshards_1", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_art_reaper_bolt_thrower", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_0", 2);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_1", 2);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_witch_elves_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_harpies", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_shades_2", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_mon_war_hydra", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_inf_black_guard_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_dlc10_def_cav_doomfire_warlocks_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_cav_cold_one_knights_1", 2);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_cav_cold_one_chariot", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_main_def_mon_black_dragon", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_dlc10_def_mon_kharibdyss_0", 1);
    random_army_manager:add_unit("ovn_albion_mist_dark_elves_force", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1);

    random_army_manager:new_force("ovn_albion_mist_chaos_force");
    random_army_manager:add_mandatory_unit("ovn_albion_mist_chaos_force", "wh_dlc01_chs_inf_chosen_2", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_chaos_force", "elo_fenbeast", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_chaos_force", "albion_fenhulk", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_chaos_force", "albion_giant", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_chaos_force", "albion_hearthguard", 1);
    random_army_manager:add_mandatory_unit("ovn_albion_mist_chaos_force", "wh_main_chs_art_hellcannon", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_dlc01_chs_mon_trolls_1", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_dlc01_chs_inf_chosen_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "albion_centaurs", 2);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "elo_albion_warriors_2h", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_main_chs_cav_chaos_chariot", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "ovn_alb_inf_stone_throw_giant", 2);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "albion_riders", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_main_chs_cav_chaos_knights_0", 2);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "albion_riders_javelins", 1);
    random_army_manager:add_unit("ovn_albion_mist_chaos_force", "albion_riders_spear", 1);
	random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_main_chs_mon_chaos_spawn", 2);
	random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_dlc01_chs_inf_forsaken_0", 2);
	random_army_manager:add_unit("ovn_albion_mist_chaos_force", "wh_main_chs_inf_chaos_warriors_0", 4);
	random_army_manager:add_unit("ovn_albion_mist_chaos_force", "albion_huntresses", 2);

        core:add_listener(
		"Mist_BuildingExists",
		"FactionTurnStart",
        function(context) return context:faction():name() == "wh2_main_nor_albion"
        end,
        function(context)

            out("TEST 1 OVN" )
            local faction = context:faction();
			local region_list = faction:region_list();

			for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i);
                local current_region_name = region:name();


            if region:building_exists("ovn_Waystone_1") then
            cm:create_storm_for_region(current_region_name, 1, 1, "ovn_albion_mist");
             if cm:random_number(20, 1) ==  1 and not cm:get_saved_value("disable_albion_mist_invasions") then
                 albion_mist_invasion_start(current_region_name)
             end
            elseif region:building_exists("ovn_Waystone_2") then
            cm:create_storm_for_region(current_region_name, 1, 1, "ovn_albion_mist");
                if cm:random_number(15, 1) ==  1 and not cm:get_saved_value("disable_albion_mist_invasions") then
                    albion_mist_invasion_start(current_region_name)
                end
            elseif region:building_exists("ovn_Waystone_3") then
            cm:create_storm_for_region(current_region_name, 1, 1, "ovn_albion_mist");
                if cm:random_number(10, 1) ==  1 and not cm:get_saved_value("disable_albion_mist_invasions")then
                    albion_mist_invasion_start(current_region_name)
                end
            end

            out("TEST 2 OVN" )

            ALBION_REGION =  "wh2_main_albion_albion"
            alb_region = cm:get_region(ALBION_REGION);
            COL_REGION =  "wh2_main_albion_citadel_of_lead"
            lead_region = cm:get_region(COL_REGION);
            IOW_REGION =  "wh2_main_albion_isle_of_wights"
            wight_region = cm:get_region(IOW_REGION);

            if alb_region:building_exists("ovn_Waystone_3")
            and lead_region:building_exists("ovn_Waystone_3")
            and wight_region:building_exists("ovn_Waystone_3") then

                local albion_faction_str = "wh2_main_nor_albion";
                local faction = cm:get_faction(albion_faction_str);

                for i = 1, 4 do

                    local effect_bundle = "albion_global_mist_".. i;

                    if faction:has_effect_bundle(effect_bundle) then
                        cm:remove_effect_bundle(effect_bundle, "wh2_main_nor_albion");
                    end
                    end

                cm:apply_effect_bundle("albion_global_mist_4", "wh2_main_nor_albion", -1);

                if not cm:get_saved_value("disable_albion_mist_invasions") then
                albion_mist_invasion_start(ALBION_REGION)
                albion_mist_invasion_start(COL_REGION)
                albion_mist_invasion_start(IOW_REGION)


                    local faction_key = "wh2_main_nor_albion" -- factions key
                    local albion = cm:get_faction(faction_key)
                    if albion:faction_leader():character_subtype("bl_elo_dural_durak") then

                        cm:spawn_character_to_pool(
                            "wh2_main_nor_albion",
                            "names_name_77777001",
                            "names_name_77777002",
                            "",
                            "",
                            18,
                            true,
                            "general",
                            "albion_morrigan",
                            true,
                            ""
                        )
                    else
                        cm:spawn_character_to_pool(
                            "wh2_main_nor_albion",
                            "names_name_77777202",
                            "names_name_77777201",
                            "",
                            "",
                            18,
                            true,
                            "general",
                            "bl_elo_dural_durak",
                            true,
                            ""
                        )

                end


                cm:set_saved_value("disable_albion_mist_invasions", true);
            end

        elseif (alb_region:building_exists("ovn_Waystone_3") or alb_region:building_exists("ovn_Waystone_2"))
        and (lead_region:building_exists("ovn_Waystone_3") or lead_region:building_exists("ovn_Waystone_2"))
        and (wight_region:building_exists("ovn_Waystone_3") or wight_region:building_exists("ovn_Waystone_2")) then
            local albion_faction_str = "wh2_main_nor_albion";
            local faction = cm:get_faction(albion_faction_str);

            for i = 1, 4 do

                local effect_bundle = "albion_global_mist_".. i;

                if faction:has_effect_bundle(effect_bundle) then
                    cm:remove_effect_bundle(effect_bundle, "wh2_main_nor_albion");
                end
                end
            cm:apply_effect_bundle("albion_global_mist_3", "wh2_main_nor_albion", -1);

        elseif (alb_region:building_exists("ovn_Waystone_3") or alb_region:building_exists("ovn_Waystone_2") or alb_region:building_exists("ovn_Waystone_1"))
        and (lead_region:building_exists("ovn_Waystone_3") or lead_region:building_exists("ovn_Waystone_2") or lead_region:building_exists("ovn_Waystone_1"))
        and (wight_region:building_exists("ovn_Waystone_3") or wight_region:building_exists("ovn_Waystone_2") or wight_region:building_exists("ovn_Waystone_1")) then
            local albion_faction_str = "wh2_main_nor_albion";
            local faction = cm:get_faction(albion_faction_str);

            for i = 1, 4 do

                local effect_bundle = "albion_global_mist_".. i;

                if faction:has_effect_bundle(effect_bundle) then
                    cm:remove_effect_bundle(effect_bundle, "wh2_main_nor_albion");
                end
                end
            cm:apply_effect_bundle("albion_global_mist_2", "wh2_main_nor_albion", -1);
        else

            out("TEST 3 OVN" )
            local albion_faction_str = "wh2_main_nor_albion";
            local faction = cm:get_faction(albion_faction_str);

            for i = 1, 4 do

                local effect_bundle = "albion_global_mist_".. i;

                if faction:has_effect_bundle(effect_bundle) then
                    cm:remove_effect_bundle(effect_bundle, "wh2_main_nor_albion");
                end
                end

            cm:apply_effect_bundle("albion_global_mist_1", "wh2_main_nor_albion", -1);
        end
        end


        end,
		true
    );

    end

end

function albion_mist_invasion_start(region)

 if cm:get_faction("wh2_main_nor_albion"):is_human() then
    local faction_name_str = cm:get_local_faction_name()
    local faction_name = cm:get_faction(faction_name_str)
    local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, region, false, false, 50)
    local location = {x = w, y = z};
    local faction
    local army
    local upa -- units per army
    local random_number = cm:random_number(6, 1)
    local experience_amount
    local turn_number = cm:model():turn_number();




        if cm:model():turn_number() < 25 then
            upa = {8, 10}
            experience_amount = cm:random_number(3,1)
        elseif cm:model():turn_number() < 45 and cm:model():turn_number() > 10 then
            upa = {12, 14}
            experience_amount = cm:random_number(5,1)
        elseif cm:model():turn_number() < 69 and cm:model():turn_number() > 24 then
            upa = {15, 17}
            experience_amount = cm:random_number(7,1)
        elseif cm:model():turn_number() > 70 then
            upa = {17, 19}
            experience_amount = cm:random_number(12,1)
        end

        if random_number == 1 then
            faction = "wh2_dlc11_cst_vampire_coast_qb1"
            army = random_army_manager:generate_force("ovn_albion_mist_vamp_coast_force", upa, false);
            cm:change_custom_faction_name("wh2_dlc11_cst_vampire_coast_qb1", "Harkon's Sea Dogs")
        elseif random_number == 2 then
            faction = "wh_main_nor_norsca_qb1"
            army = random_army_manager:generate_force("ovn_albion_mist_norsca_force", upa, false);
            cm:change_custom_faction_name("wh_main_nor_norsca_qb1", "Be'lakor's Defilers")
        elseif random_number == 3 then
            faction = "wh2_main_skv_skaven_qb1"
            army = random_army_manager:generate_force("ovn_albion_mist_skaven_force", upa, false);
            cm:change_custom_faction_name("wh2_main_skv_skaven_qb1", "Clan Skurvy")
        elseif random_number == 4 then
            faction = "wh_main_grn_greenskins_qb1"
            army = random_army_manager:generate_force("ovn_albion_mist_greenskin_force", upa, false);
            cm:change_custom_faction_name("wh_main_grn_greenskins_qb1", "River Ratz")
        elseif random_number == 5 then
            faction = "wh2_main_def_dark_elves_qb1"
            army = random_army_manager:generate_force("ovn_albion_mist_dark_elves_force", upa, false);
            cm:change_custom_faction_name("wh2_main_def_dark_elves_qb1", "Teilancarr's Corsairs")
        elseif random_number == 6 then
            faction = "wh_main_chs_chaos_qb1"
            army = random_army_manager:generate_force("ovn_albion_mist_chaos_force", upa, false);
            cm:change_custom_faction_name("wh_main_chs_chaos_qb1", "Dark Emissaries")
        end

        local albion_mist_invasion = invasion_manager:new_invasion("albion_mist_invasion_"..region.."_"..turn_number, faction, army, location);

         albion_mist_invasion:set_target("REGION", region, faction_name_str);
         albion_mist_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
         albion_mist_invasion:apply_effect("wh_main_reduced_movement_range_60", 3);
         albion_mist_invasion:add_character_experience(experience_amount, true);
         albion_mist_invasion:add_unit_experience(experience_amount);
         albion_mist_invasion:start_invasion(true);

         if region == "wh2_main_albion_albion" then
            cm:show_message_event(
                "wh2_main_nor_albion",
                "event_feed_strings_text_ovn_event_feed_string_scripted_event_alb_invasion_primary_detail",
                "",
                "event_feed_strings_text_ovn_event_feed_string_scripted_event_alb_invasion_secondary_detail",
                true,
                2501
                );
            elseif region == "wh2_main_albion_citadel_of_lead" then
                cm:show_message_event(
                    "wh2_main_nor_albion",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_alb_invasion_n_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_alb_invasion_n_secondary_detail",
					true,
					2501
					);
                elseif region == "wh2_main_albion_isle_of_wights" then
                    cm:show_message_event(
                        "wh2_main_nor_albion",
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_alb_invasion_s_primary_detail",
                        "",
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_alb_invasion_s_secondary_detail",
                        true,
                        2501
                        );
                end


   end
end

local function albion_init()
    setup_diplo()
end

cm:add_first_tick_callback(
    function()
        albion_init()
    end
)
