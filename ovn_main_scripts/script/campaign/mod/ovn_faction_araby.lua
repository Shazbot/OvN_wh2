local function setup_diplo()
	cm:force_diplomacy("faction:wh2_main_arb_caliphate_of_araby", "culture:wh_main_brt_bretonnia", "military alliance", false, false, true)
    cm:force_diplomacy("faction:wh2_main_arb_caliphate_of_araby", "culture:wh_main_brt_bretonnia", "defensive alliance", false, false, true)

	cm:force_diplomacy("faction:wh2_main_arb_aswad_scythans", "culture:wh_main_brt_bretonnia", "military alliance", false, false, true)
    cm:force_diplomacy("faction:wh2_main_arb_aswad_scythans", "culture:wh_main_brt_bretonnia", "defensive alliance", false, false, true)

	cm:force_diplomacy("faction:wh2_main_arb_flaming_scimitar", "culture:wh_main_brt_bretonnia", "military alliance", false, false, true)
	cm:force_diplomacy("faction:wh2_main_arb_flaming_scimitar", "culture:wh_main_brt_bretonnia", "defensive alliance", false, false, true)

    cm:force_diplomacy("faction:wh2_main_arb_aswad_scythans", "faction:wh2_dlc09_tmb_numas", "all", true, true, true);
    cm:force_diplomacy("faction:wh2_main_arb_aswad_scythans", "faction:wh2_dlc09_tmb_numas", "war", false, false, true);
    cm:force_diplomacy("faction:wh2_main_arb_aswad_scythans", "faction:wh2_dlc09_tmb_numas", "break alliance", false, false, true);

    cm:force_diplomacy("subculture:wh_main_sc_emp_araby", "culture:wh_main_chs_chaos", "all", true, true, true);

end

local araby_faction_names_lookup = {
	wh2_main_arb_flaming_scimitar = true,
	wh2_main_arb_aswad_scythans = true,
	wh2_main_arb_caliphate_of_araby = true,
}

local function is_faction_an_araby_faction(faction)
	return not not araby_faction_names_lookup[faction:name()]
end

local function setup_arb_excavations()

    if not (cm:get_faction("wh2_main_arb_flaming_scimitar"):is_human()
			or cm:get_faction("wh2_main_arb_aswad_scythans"):is_human()
			or cm:get_faction("wh2_main_arb_caliphate_of_araby"):is_human())
		then
			return
		end

    core:add_listener(
    "araby_slave_BuildingExists",
    "FactionTurnStart",
    function(context) return context:faction():is_human() and is_faction_an_araby_faction(context:faction())
    end,
    function(context)
        local faction_name_str = context:faction():name()
        local faction = context:faction();
        local region_list = faction:region_list();
        for i = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(i);

            if region:building_exists("ovn_arb_industry_basic_1") then
                cm:modify_faction_slaves_in_a_faction(faction_name_str, 9)
            elseif region:building_exists("ovn_arb_industry_basic_2") then
                cm:modify_faction_slaves_in_a_faction(faction_name_str, 17)
            elseif region:building_exists("ovn_arb_industry_basic_3") then
                cm:modify_faction_slaves_in_a_faction(faction_name_str, 26)
            end
        end

    end,
    true
    )

    local tooltip_to_image_path = {
        ["Buy Weapons"] = "mortuary_cult_title_frame.png",
        ["Buy Armor"] = "mortuary_cult_title_frame_b.png",
        ["Buy Enchanted Items"] = "mortuary_cult_title_frame_c.png",
        ["Buy Talismans"] = "mortuary_cult_title_frame_d.png",
        ["Buy Arcane Items"] = "mortuary_cult_title_frame_e.png",
    }

    core:remove_listener('pj_araby_bazaar_change_header_image')
    core:add_listener(
        'pj_araby_bazaar_change_header_image',
        'ComponentLClickUp',
        true,
        function(context)
            local ui_root = core:get_ui_root()
            local pt = find_uicomponent(ui_root, "mortuary_cult", "panel_title")
            if not pt then return end

            local tooltip_text = UIComponent(context.component):GetTooltipText()

            local image_path = tooltip_to_image_path[tooltip_text]
            if not image_path then return end

            pt:SetImagePath("ui/skins/ovn_araby/"..image_path)
        end,
        true
    )

        random_army_manager:new_force("ovn_arb_excavation_tomb_king_force");
        random_army_manager:add_mandatory_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_inf_tomb_guard_1", 3);
        random_army_manager:add_mandatory_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_inf_skeleton_archers_0", 3);
        random_army_manager:add_mandatory_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 1);
        random_army_manager:add_mandatory_unit("ovn_arb_excavation_tomb_king_force", "wh2_pro06_tmb_mon_bone_giant_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_carrion_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_heirotitan_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_necrosphinx_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_sepulchral_stalkers_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_tomb_scorpion_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_ushabti_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_mon_ushabti_1", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_veh_skeleton_chariot_0", 2);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_inf_tomb_guard_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_art_casket_of_souls_0", 1);
        random_army_manager:add_unit("ovn_arb_excavation_tomb_king_force", "wh2_dlc09_tmb_cav_necropolis_knights_1", 1);

    random_army_manager:new_force("ovn_arb_excavation_chaos_force");
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_inf_chosen_2", 3);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_mon_dragon_ogre", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_inf_chosen_1", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_art_hellcannon", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_mon_trolls_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_inf_chosen_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_dlc06_chs_cav_marauder_horsemasters_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_cav_chaos_chariot", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_cav_gorebeast_chariot", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_cav_chaos_knights_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_cav_chaos_knights_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_mon_giant", 1);
	random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_mon_chaos_spawn", 2);
	random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_dlc01_chs_inf_forsaken_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_chaos_force", "wh_main_chs_inf_chaos_warriors_0", 4);

    random_army_manager:new_force("ovn_arb_excavation_skaven_force");
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_skaven_force", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_art_plagueclaw_catapult", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_stormvermin_0", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_skaven_force", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_art_warp_lightning_cannon", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_plague_monk_censer_bearer", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_poison_wind_globadiers", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_dlc14_skv_inf_eshin_triads_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_gutter_runners_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_night_runners_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_warpfire_thrower", 1);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_stormvermin_1", 2);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_mon_rat_ogres", 2);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_veh_doomwheel", 1);
	random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_dlc12_skv_veh_doom_flayer_0", 1);
	random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_skavenslaves_0", 4);
	random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_skavenslave_slingers_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_skaven_force", "wh2_main_skv_inf_clanrats_1", 3);

    random_army_manager:new_force("ovn_arb_excavation_dark_elves_force");
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_har_ganeth_executioners_0", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_dark_elves_force", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_darkshards_1", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_art_reaper_bolt_thrower", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_0", 3);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_1", 3);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_witch_elves_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_harpies", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_shades_2", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_mon_war_hydra", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_inf_black_guard_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_dlc10_def_cav_doomfire_warlocks_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_cav_cold_one_knights_1", 2);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_cav_cold_one_chariot", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_main_def_mon_black_dragon", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_dlc10_def_mon_kharibdyss_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_dark_elves_force", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1);

    random_army_manager:new_force("ovn_arb_excavation_tilea_force");
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_handgunners", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_art_great_cannon", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_art_helstorm_rocket_battery", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_halberdiers", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_greatswords", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_tilea_force", "wh_dlc04_emp_cav_knights_blazing_sun_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_dlc04_emp_cav_knights_blazing_sun_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_art_mortar", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_spearmen_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_spearmen_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_handgunners", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_crossbowmen", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_cav_pistoliers_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_halberdiers", 2);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_cav_empire_knights", 3);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_greatswords", 1);
	random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh2_dlc12_skv_veh_doom_flayer_0", 1);
	random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_main_emp_inf_swordsmen", 4);
	random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh_dlc04_emp_inf_flagellants_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_tilea_force", "wh2_dlc13_emp_inf_archers_0", 3);

    random_army_manager:new_force("ovn_arb_excavation_norsca_force");
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_fimir_1", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_war_mammoth_2", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_inf_marauder_champions_0", 2);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_skinwolves_1", 1);
    random_army_manager:add_mandatory_unit("ovn_arb_excavation_norsca_force", "wh_main_chs_art_hellcannon", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_war_mammoth_1", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_main_nor_cav_marauder_horsemen_1", 2);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_norscan_giant_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_inf_marauder_champions_1", 2);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_fimir_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_mon_norscan_ice_trolls_0", 2);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_main_nor_cav_chaos_chariot", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_dlc08_nor_inf_marauder_berserkers_0", 1);
    random_army_manager:add_unit("ovn_arb_excavation_norsca_force", "wh_main_nor_inf_chaos_marauders_0", 4);

		core:add_listener(
				"arb_excavation_BuildingExists",
				"FactionTurnStart",
        function(context) return context:faction():is_human() and is_faction_an_araby_faction(context:faction())
        end,
        function(context)
            local faction_name_str = context:faction():name()
            local faction = context:faction();
						local region_list = faction:region_list();
						for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i);
                local current_region_name = region:name();

								if region:building_exists("ovn_Nehekharan") then
										if cm:random_number(20, 1) ==  1 then
												core:add_listener(
														"arb_excavation_dilemma_listener",
														"DilemmaChoiceMadeEvent",
														function(context) return context:dilemma():starts_with("ovn_dilemma_arb_excavation") end,
														function(context)
																local faction_name_str = cm:whose_turn_is_it()
																local choice = context:choice()
																if choice == 0 then
																		if cm:random_number(2, 1) == 1 then
																				arb_excavation_invasion_start(current_region_name)
																		end
																end
														end,
														false
												)

												cm:trigger_dilemma(faction_name_str, "ovn_dilemma_arb_excavation")
										end
								end
						end
        end,
				true
				);
end

function arb_excavation_invasion_start(region)


    local faction_name_str = cm:whose_turn_is_it()
    local faction_name = cm:get_faction(faction_name_str)
    local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, region, false, false, 45)
    local location = {x = w, y = z};
    local faction
    local army
    local upa -- units per army
    local random_number = cm:random_number(10, 1)
    local experience_amount
    local turn_number = cm:model():turn_number();

        if cm:model():turn_number() < 25 then
            upa = {8, 9}
            experience_amount = cm:random_number(3,1)
        elseif cm:model():turn_number() < 45 and cm:model():turn_number() > 10 then
            upa = {15, 18}
            experience_amount = cm:random_number(5,2)
        elseif cm:model():turn_number() < 69 and cm:model():turn_number() > 24 then
            upa = {16, 18}
            experience_amount = cm:random_number(7,4)
        elseif cm:model():turn_number() > 70 then
            upa = {17, 19}
            experience_amount = cm:random_number(12,7)
        end

        if random_number == 1 or random_number == 7 or random_number == 8 or random_number == 9 or random_number == 10 then
            faction = "wh2_dlc09_tmb_tombking_qb1"
            army = random_army_manager:generate_force("ovn_arb_excavation_tomb_king_force", upa, false);
            cm:change_custom_faction_name("wh2_dlc09_tmb_tombking_qb1", "Tomb Guardians")
        elseif random_number == 2 then
            faction = "wh_main_nor_norsca_qb1"
            army = random_army_manager:generate_force("ovn_arb_excavation_norsca_force", upa, false);
            cm:change_custom_faction_name("wh_main_nor_norsca_qb1", "Khagul's Raiders")
        elseif random_number == 3 then
            faction = "wh2_main_skv_skaven_qb1"
            army = random_army_manager:generate_force("ovn_arb_excavation_skaven_force", upa, false);
            cm:change_custom_faction_name("wh2_main_skv_skaven_qb1", "Clan Skab")
        elseif random_number == 4 then
            faction = "wh_main_emp_empire_qb1"
            army = random_army_manager:generate_force("ovn_arb_excavation_tilea_force", upa, false);
            cm:change_custom_faction_name("wh_main_emp_empire_qb1", "Tilean Adventurers")
        elseif random_number == 5 then
            faction = "wh2_main_def_dark_elves_qb1"
            army = random_army_manager:generate_force("ovn_arb_excavation_dark_elves_force", upa, false);
            cm:change_custom_faction_name("wh2_main_def_dark_elves_qb1", "Teilancarr's Corsairs")
        elseif random_number == 6 then
            faction = "wh_main_chs_chaos_qb1"
            army = random_army_manager:generate_force("ovn_arb_excavation_chaos_force", upa, false);
            cm:change_custom_faction_name("wh_main_chs_chaos_qb1", "Nehekharan Blood Cult")
        end

        local arb_excavation_invasion = invasion_manager:new_invasion("arb_excavation_invasion_"..region.."_"..turn_number, faction, army, location);

         arb_excavation_invasion:set_target("REGION", region, faction_name_str);
         arb_excavation_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
         arb_excavation_invasion:add_character_experience(experience_amount, true);
         arb_excavation_invasion:add_unit_experience(experience_amount);
         arb_excavation_invasion:start_invasion(true);

         local human_factions = cm:get_human_factions()
         for i = 1, #human_factions do

         if random_number == 1 or random_number == 7 or random_number == 8 or random_number == 9 or random_number == 10 then
            cm:show_message_event(
                human_factions[i],
                "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_primary_detail",
                "",
                "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_secondary_detail",
                true,
                2505
                );
            elseif random_number == 2 then
                cm:show_message_event(
                    human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_2_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_2_secondary_detail",
					true,
					2505
					);
                elseif random_number == 3 then
                    cm:show_message_event(
                        human_factions[i],
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_3_primary_detail",
                        "",
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_3_secondary_detail",
                        true,
                        2505
                        );
                elseif random_number == 4 then
                        cm:show_message_event(
                            human_factions[i],
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_4_primary_detail",
                        "",
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_4_secondary_detail",
                        true,
                        2505
                        );
                elseif random_number == 5 then
                    cm:show_message_event(
                        human_factions[i],
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_5_primary_detail",
                        "",
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_5_secondary_detail",
                        true,
                        2505
                        );
                elseif random_number == 6 then
                    cm:show_message_event(
                        human_factions[i],
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_6_primary_detail",
                        "",
                        "event_feed_strings_text_ovn_event_feed_string_scripted_event_arb_invasion_6_secondary_detail",
                        true,
                        2505
                        );
                end
                end



end

local function araby_init()
    setup_diplo()
    setup_arb_excavations()
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
	["wh_main_teb_walls_1"] = "ovn_araby_walls_1",
	["wh_main_teb_walls_2"] = "ovn_araby_walls_2",
	["wh_main_teb_walls_3"] = "ovn_araby_walls_3",
	["wh_main_teb_walls_4"] = "ovn_araby_walls_3",
}

local function replace_old_buildings()
	for faction_key, _ in pairs(araby_faction_names_lookup) do
		local f = cm:get_faction(faction_key)
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
end

local araby_trebuchet_bonus_bundle_name = "ovn_enable_araby_trebuchet_bonus_in_sieges"

local function araby_trebuchet_bonus_handle_attackers(remove_bonus)
	for i = 1, cm:pending_battle_cache_num_attackers() do
		local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)

		local attacker = cm:model():world():faction_by_key(attacker_name)

		if attacker and not attacker:is_null_interface() and attacker:subculture() == "wh_main_sc_emp_araby" then
			if remove_bonus then
				local custom_bundle = cm:create_new_custom_effect_bundle(araby_trebuchet_bonus_bundle_name)
				cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, cm:get_character_by_cqi(attacker_cqi))
			else
				local char = cm:get_character_by_cqi(attacker_cqi)
				if char and char:has_military_force() then
					local unit_list = char:military_force():unit_list()
					if unit_list and (unit_list:has_unit("ovn_bom_ror") or unit_list:has_unit("ovn_arb_art_grand_bombard")) then
						local custom_bundle = cm:create_new_custom_effect_bundle(araby_trebuchet_bonus_bundle_name)
						custom_bundle:add_effect("ovn_enable_araby_trebuchet_bonus_in_sieges", "character_to_force_own", 100)
						cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, char)
					end
				end
			end
		end
	end
end

local function add_araby_trebuchet_bonus_listeners()
	core:remove_listener("ovn_enable_araby_trebuchet_bonus_in_sieges_pending_battle_cb")
	core:add_listener(
		"ovn_enable_araby_trebuchet_bonus_in_sieges_pending_battle_cb",
		"PendingBattle",
		function()
			return true
		end,
		function(context)
			local pending_battle = context:pending_battle()

			if not cm:pending_battle_cache_human_is_involved() then
				return
			end
			if not cm:pending_battle_cache_human_is_attacker() then
				return
			end
			if not cm:pending_battle_cache_subculture_is_attacker("wh_main_sc_emp_araby") then
				return
			end
			if not pending_battle:seige_battle() then
				return
			end

			araby_trebuchet_bonus_handle_attackers()
		end,
		true
	)

	core:remove_listener("ovn_enable_araby_trebuchet_bonus_in_sieges_battle_completed_cb")
	core:add_listener(
		"ovn_enable_araby_trebuchet_bonus_in_sieges_battle_completed_cb",
		"BattleCompleted",
		true,
		function(context)
			local pending_battle = cm:model():pending_battle()

			if not cm:pending_battle_cache_human_is_involved() then
				return
			end
			if not cm:pending_battle_cache_human_is_attacker() then
				return
			end
			if not cm:pending_battle_cache_subculture_is_attacker("wh_main_sc_emp_araby") then
				return
			end
			if not pending_battle:seige_battle() then
				return
			end

			araby_trebuchet_bonus_handle_attackers(true)
		end,
		true
	)
end

local jehad_regions = {
	["wh2_main_ash_river_numas"] = true,
	["wh2_main_ash_river_quatar"] = true,
	["wh2_main_ash_river_springs_of_eternal_life"] = true,
	["wh2_main_atalan_mountains_martek"] = true,
	["wh2_main_coast_of_araby_al_haikk"] = true,
	["wh2_main_coast_of_araby_copher"] = true,
	["wh2_main_coast_of_araby_fyrus"] = true,
	["wh2_main_great_desert_of_araby_bel_aliad"] = true,
	["wh2_main_great_desert_of_araby_black_tower_of_arkhan"] = true,
	["wh2_main_great_desert_of_araby_el-kalabad"] = true,
	["wh2_main_great_desert_of_araby_pools_of_despair"] = true,
	["wh2_main_great_mortis_delta_black_pyramid_of_nagash"] = true,
	["wh2_main_land_of_assassins_lashiek"] = true,
	["wh2_main_land_of_assassins_palace_of_the_wizard_caliph"] = true,
	["wh2_main_land_of_assassins_sorcerers_islands"] = true,
	["wh2_main_land_of_the_dead_khemri"] = true,
	["wh2_main_land_of_the_dead_pyramid_of_nagash"] = true,
	["wh2_main_land_of_the_dead_zandri"] = true,
	["wh2_main_land_of_the_dervishes_plain_of_tuskers"] = true,
	["wh2_main_land_of_the_dervishes_sudenburg"] = true,
	["wh2_main_shifting_sands_antoch"] = true,
	["wh2_main_shifting_sands_bhagar"] = true,
	["wh2_main_shifting_sands_ka-sabar"] = true,
	["wh2_main_atalan_mountains_eye_of_the_panther"] = true,
	["wh2_main_atalan_mountains_vulture_mountain"] = true,
	["wh2_main_western_jungles_tlaqua"] = true,
}

local turn_when_jehad_region_icons_were_added = -1

---@param region CA_REGION
local function add_jehad_region_icon_to_region(region)
	local region_key = region:name()
	if not is_faction_an_araby_faction(region:owning_faction()) then
		cm:apply_effect_bundle_to_region("ovn_arb_jehad_region", region_key, -1)
	else
		cm:remove_effect_bundle_from_region("ovn_arb_jehad_region", region_key)
	end
end

local function add_jehad_region_icons()
	if cm:model():turn_number() == turn_when_jehad_region_icons_were_added then
		return
	end

	for region_key, _ in pairs(jehad_regions) do
		local region = cm:get_region(region_key)
		if region then
			add_jehad_region_icon_to_region(region)
		end
	end

	turn_when_jehad_region_icons_were_added = cm:model():turn_number()
end

core:remove_listener("onv_araby_add_jehad_region_icons_on_city_changed_owner")
core:add_listener(
	"onv_araby_add_jehad_region_icons_on_city_changed_owner",
	"RegionFactionChangeEvent",
	true,
	function(context)
		---@type CA_REGION
		local region = context:region()

		if not jehad_regions[region:name()] then
			return
		end

		add_jehad_region_icon_to_region(region)
	end,
	true
)

core:remove_listener("onv_araby_add_jehad_region_icons_on_turn_start")
core:add_listener(
	"onv_araby_add_jehad_region_icons_on_turn_start",
	"FactionTurnStart",
	function(context) return context:faction():is_human() and is_faction_an_araby_faction(context:faction())
	end,
	function()
		add_jehad_region_icons()
	end,
	true
)

cm:add_first_tick_callback(
    function()
        araby_init()
				-- replace_old_buildings()
				add_araby_trebuchet_bonus_listeners()

				local human_factions = cm:get_human_factions()
				for araby_faction_key, _ in pairs(araby_faction_names_lookup) do
					if table_contains(human_factions, araby_faction_key) then
						add_jehad_region_icons()
						break
					end
				end
    end
)
