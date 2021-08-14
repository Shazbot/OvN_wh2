local new_forces = {
    ["main_warhammer"] = {

        wh2_main_arb_caliphate_of_araby = {
            faction_key = "wh2_main_arb_caliphate_of_araby",
            unit_list = "ovn_cat_knights,ovn_jez,wh_main_arb_cav_magic_carpet_0,OtF_khemri_swordsmen,OtF_khemri_archers,ovn_arb_art_grand_bombard",
            region_key = "wh2_main_great_desert_of_araby_el-kalabad",
            x = 450,
            y = 135,
            type = "general",
            subtype = "Sultan_Jaffar",
            name1 = "names_name_999982322",
            name2 = "",
            name3 = "names_name_999982323",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
										cm:set_character_immortality("character_cqi:"..cqi, true)
                    cm:set_character_unique("character_cqi:"..cqi, true)
                end
        },

        wh2_main_arb_aswad_scythans = {
            faction_key = "wh2_main_arb_aswad_scythans",
            unit_list = "ovn_arb_cav_lancer_camel,ovn_arb_cav_lancer_camel,ovn_arb_cav_archer_camel,wh_main_arb_mon_war_elephant,OtF_khemri_rangers,ovn_scor,OtF_khemri_spearmen",
            region_key = "wh2_main_great_desert_of_araby_el-kalabad",
            x = 690,
            y = 125,
            type = "general",
            subtype = "arb_fatandira",
            name1 = "names_name_999982308",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_immortality("faction:wh2_main_arb_aswad_scythans,forename:999982308", true)
                    cm:set_character_unique("character_cqi:"..cqi, true);
                end
        },

        wh2_main_arb_flaming_scimitar = {
            faction_key = "wh2_main_arb_flaming_scimitar",
            unit_list = "wh_main_arb_cav_magic_carpet_0,ovn_jez,OtF_khemri_kepra_guard,ovn_glad,OtF_khemri_swordsmen,ovn_ifreet,ovn_corsairs,ovn_prometheans",
            region_key = "wh2_main_great_desert_of_araby_el-kalabad",
            x = 255,
            y = 185,
            type = "general",
            subtype = "arb_golden_magus",
            name1 = "names_name_999982318",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_immortality("character_cqi:"..cqi, true)
                    cm:set_character_unique("character_cqi:"..cqi, true)
                end
        },

        wh2_main_nor_harbingers_of_doom = {
            faction_key = "wh2_main_nor_harbingers_of_doom",
            unit_list = "kho_bloodletter,ovn_shearl,wh_main_chs_inf_chaos_marauders_0,ovn_fimm,ovn_boglar,ovn_boglar,elo_fenbeast",
            region_key = "wh2_main_great_desert_of_araby_el-kalabad",
            x = 330,
            y = 600,
            type = "general",
            subtype = "belakor",
            name1 = "names_name_247258464",
            name2 = "",
            name3 = "names_name_247258465",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
										cm:set_character_immortality("character_cqi:"..cqi, true)
                    cm:set_character_unique("character_cqi:"..cqi, true)
                end
        },

        wh2_main_nor_servants_of_fimulneid = {
            faction_key = "wh2_main_nor_servants_of_fimulneid",
            unit_list = "wh_dlc08_nor_mon_fimir_1,ovn_shearl,wh2_dlc15_grn_mon_river_trolls_0_no_scrap,ovn_fimm,ovn_boglar,ovn_boglar,ovn_boglar,elo_fenbeast",
            region_key = "wh2_main_great_desert_of_araby_el-kalabad",
            x = 653,
            y = 170,
            type = "general",
            subtype = "fim_meargh_skattach",
            name1 = "names_name_999982314",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_immortality("faction:wh2_main_nor_servants_of_fimulneid,forename:999982314", true);
                    cm:set_character_unique("character_cqi:"..cqi, true);
                end
        },

        wh2_dlc09_tmb_the_sentinels = {
            faction_key = "wh2_dlc09_tmb_the_sentinels",
            unit_list = "wh2_dlc09_tmb_inf_skeleton_archers_0,wh2_dlc09_tmb_inf_skeleton_warriors_0,elo_tomb_guardian_2h_waepons,wh2_dlc09_tmb_inf_tomb_guard_1,wh2_dlc09_tmb_inf_skeleton_spearmen_0,wh2_dlc09_tmb_inf_crypt_ghouls,wh2_dlc09_tmb_cav_hexwraiths",
            region_key = "wh2_main_great_desert_of_araby_el-kalabad",
            x = 585,
            y = 85,
            type = "general",
            subtype = "Dread_King",
            name1 = "names_name_247259235",
            name2 = "",
            name3 = "names_name_247259236",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    local str = "character_cqi:"..cqi
                    cm:set_character_immortality(str, true)
                    cm:add_unit_model_overrides(str, "Dread_King");
                    cm:set_character_unique("character_cqi:"..cqi, true);
                end
        },

        wh2_main_nor_trollz1 = {
            faction_key = "wh2_main_nor_trollz",
            unit_list = "elo_mountain_trolls,elo_river_trolls,elo_river_trolls,elo_bile_trolls",
            region_key = "wh_main_southern_badlands_galbaraz",
            x = 643,
            y = 150,
            type = "general",
            subtype = "elo_chief_ugma",
            name1 = "names_name_77779001",
            name2 = "",
            name3 = "names_name_77779002",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 7, true);
                    cm:set_character_unique("character_cqi:"..cqi, true);
                end
        },
        wh2_rogue_troll0 = {
            faction_key = "wh2_main_rogue_troll_skullz",
            unit_list = "elo_mountain_trolls,elo_southern_trolls,elo_southern_trolls,elo_southern_trolls,elo_bile_trolls",
            region_key = "wh2_main_great_desert_of_araby_bel_aliad",
            x = 485,
            y = 75,
            type = "general",
            subtype = "elo_cha_troll_lord",
            name1 = "names_name_2147344497",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = false,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 0, true);
                end
        },

        wh2_rogue_troll = {
            faction_key = "wh2_main_rogue_troll_skullz",
            unit_list = "elo_mountain_trolls,wh_main_grn_mon_trolls,elo_forest_trolls,elo_river_trolls",
            region_key = "wh_main_averland_grenzstadt",
            x = 600,
            y = 390,
            type = "general",
            subtype = "elo_cha_troll_lord",
            name1 = "names_name_2147344529",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 0, true);
                end
        },

        wh2_rogue_troll2 = {
            faction_key = "wh2_main_rogue_troll_skullz",
            unit_list = "elo_mountain_trolls,elo_forest_trolls,wh_main_grn_mon_trolls,elo_river_trolls",
            region_key = "wh_main_talabecland_kappelburg",
            x = 530,
            y = 545,
            type = "general",
            subtype = "elo_cha_troll_lord",
            name1 = "names_name_2147344759",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = false,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 0, true);
                end
        },


        wh2_rogue_troll3 = {
            faction_key = "wh2_main_rogue_troll_skullz",
            unit_list = "elo_mountain_trolls,wh_main_grn_mon_trolls,elo_forest_trolls,elo_snow_troll",
            region_key = "wh_main_troll_country_zoishenk",
            x = 660,
            y = 580,
            type = "general",
            subtype = "elo_cha_troll_lord",
            name1 = "names_name_2147344489",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = false,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 0, true);
                end
        },

        wh2_rogue_troll4 = {
            faction_key = "wh2_main_rogue_troll_skullz",
            unit_list = "elo_mountain_trolls,elo_southern_trolls,elo_southern_trolls,elo_southern_trolls",
            region_key = "wh2_main_great_desert_of_araby_bel_aliad",
            x = 685,
            y = 75,
            type = "general",
            subtype = "elo_cha_troll_lord",
            name1 = "names_name_2147344443",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = false,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 0, true);
                end
        },

        wh2_rogue_troll5 = {
            faction_key = "wh2_main_rogue_troll_skullz",
            unit_list = "elo_mountain_trolls,elo_southern_trolls,elo_southern_trolls,elo_southern_trolls",
            region_key = "wh2_main_great_desert_of_araby_bel_aliad",
            x = 680,
            y = 328,
            type = "general",
            subtype = "elo_cha_troll_lord",
            name1 = "names_name_2147344501",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = false,
            callback =
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", cqi, 0, true);
                end
        },

        wh2_main_emp_the_moot = {
            faction_key = "wh2_main_emp_the_moot",
            unit_list = "halfling_archer,ovn_mtl_cav_poultry_riders_0,sr_ogre,halfling_cook,halfling_spear,halfling_inf",
            region_key = "wh2_main_northern_great_jungle_temple_of_tlencan",
            x = 620,
            y = 407,
            type = "general",
            subtype = "ovn_hlf_glibfoot",
            name1 = "names_name_999982316",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_immortality("faction:wh2_main_emp_the_moot,forename:999982316", true);
                    cm:set_character_unique("character_cqi:"..cqi, true);
                end
        }
    },

    ["wh2_main_great_vortex"] = {
        wh2_dlc09_tmb_the_sentinels = {
            faction_key = "wh2_dlc09_tmb_the_sentinels",
            unit_list = "wh2_dlc09_tmb_inf_skeleton_archers_0,wh2_dlc09_tmb_inf_skeleton_warriors_0,elo_tomb_guardian_2h_waepons,wh2_dlc09_tmb_inf_tomb_guard_1,wh2_dlc09_tmb_inf_skeleton_spearmen_0,wh2_dlc09_tmb_inf_crypt_ghouls,wh2_dlc09_tmb_cav_hexwraiths",
            region_key = "wh2_main_vor_ash_river_quatar",
            x = 630,
            y = 275,
            type = "general",
            subtype = "Dread_King",
            name1 = "names_name_247259235",
            name2 = "",
            name3 = "names_name_247259236",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_immortality("faction:wh2_dlc09_tmb_the_sentinels,forename:247259235", true)
                    cm:add_unit_model_overrides("faction:wh2_dlc09_tmb_the_sentinels,forename:247259235", "Dread_King")
                    cm:set_character_unique("character_cqi:"..cqi, true);
                end
        },

        wh2_main_arb_caliphate_of_araby = {
            faction_key = "wh2_main_arb_caliphate_of_araby",
            unit_list = "ovn_cat_knights,ovn_jez,wh_main_arb_cav_magic_carpet_0,OtF_khemri_swordsmen,OtF_khemri_archers,ovn_arb_art_grand_bombard",
            region_key = "wh2_main_vor_coast_of_araby_al_haikk",
            x = 560,
            y = 330,
            type = "general",
            subtype = "Sultan_Jaffar",
            name1 = "names_name_999982322",
            name2 = "",
            name3 = "names_name_999982323",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_unique("character_cqi:"..cqi, true)
                    cm:set_character_immortality("faction:wh2_main_arb_caliphate_of_araby,forename:247258412", true)
                end
        },

        wh2_main_arb_aswad_scythans = {
            faction_key = "wh2_main_arb_aswad_scythans",
            unit_list = "ovn_arb_cav_lancer_camel,ovn_arb_cav_lancer_camel,ovn_arb_cav_archer_camel,wh_main_arb_mon_war_elephant,OtF_khemri_rangers,ovn_scor",
            region_key = "wh2_main_vor_coast_of_araby_al_haikk",
            x = 700,
            y = 265,
            type = "general",
            subtype = "arb_fatandira",
            name1 = "names_name_999982308",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_unique("character_cqi:"..cqi, true)
                    cm:set_character_immortality("faction:wh2_main_arb_aswad_scythans,forename:999982308", true)
                end
        },

        wh2_main_arb_flaming_scimitar = {
            faction_key = "wh2_main_arb_flaming_scimitar",
            unit_list = "wh_main_arb_cav_magic_carpet_0,ovn_jez,OtF_khemri_kepra_guard,ovn_glad,OtF_khemri_swordsmen,ovn_ifreet,ovn_corsairs,ovn_prometheans",
            region_key = "wh2_main_vor_coast_of_araby_al_haikk",
            x = 277,
            y = 310,
            type = "general",
            subtype = "arb_golden_magus",
            name1 = "names_name_999982318",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_unique("character_cqi:"..cqi, true)
                    cm:set_character_immortality("faction:wh2_main_arb_flaming_scimitar,forename:999982318", true)
                end
        },

        wh2_dlc11_cst_vampire_coast_rebels = {
            faction_key = "wh2_dlc11_cst_vampire_coast_rebels",
            unit_list = "wh2_dlc11_cst_inf_depth_guard_0,wh2_dlc11_cst_inf_depth_guard_1,wh2_dlc11_cst_mon_rotting_leviathan_0,wh2_dlc11_cst_mon_scurvy_dogs,wh2_dlc11_cst_inf_syreens,wh2_dlc11_cst_mon_mournguls_0,wh2_dlc11_cst_inf_zombie_deckhands_mob_1",
            region_key = "wh2_main_vor_coast_of_araby_copher",
            x = 240,
            y = 315,
            type = "general",
            subtype = "wh2_dlc11_vmp_bloodline_lahmian",
            name1 = "names_name_999982306",
            name2 = "",
            name3 = "",
            name4 = "",
            make_faction_leader = true,
            callback =
                function(cqi)
                    cm:set_character_unique("character_cqi:"..cqi, true);
                    cm:set_character_immortality("faction:wh2_dlc11_cst_vampire_coast_rebels,forename:999982306", true)
                    cm:add_unit_model_overrides("faction:wh2_dlc11_cst_vampire_coast_rebels,forename:999982306", "wh2_dlc11_art_set_vmp_bloodline_lahmian_01");
                    -- MODEL OVERRIDE NECESSCARY OR WILL DEFAULT TO BRIGHT WIZARD
                end
        },
    }
}

return new_forces
