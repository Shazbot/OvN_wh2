--events = get_events();

local cod_ll_popularity_regions = {};
local power_of_authority_vfx = {full = "scripted_effect7", half = "scripted_effect8"};
local cod_naval_defender_faction = "wh2_main_hef_citadel_of_dusk";
local cod_naval_defender_effect = "";
local cod_naval_defender_level = 1;
local cod_naval_action_level = 0;

local cod_regions = {
	["main_warhammer"] = {
		["outer"] = {
			["wh2_main_eataine_angerrial"] = true,
			["wh2_main_eataine_lothern"] = true,
			["wh2_main_eataine_shrine_of_asuryan"] = true,
			["wh2_main_eataine_tower_of_lysean"] = true
        },
		["inner"] = {
			["wh2_main_volcanic_islands_fuming_serpent"] = true,
			["wh2_main_volcanic_islands_the_star_tower"] = true,
			["wh2_main_vampire_coast_pox_marsh"] = true,
			["wh2_main_vampire_coast_the_awakening"] = true,
			["wh2_main_vampire_coast_the_blood_swamps"] = true,
			["wh2_main_headhunters_jungle_chupayotl"] = true,
			["wh2_main_headhunters_jungle_mangrove_coast"] = true,
			["wh2_main_headhunters_jungle_marks_of_the_old_ones"] = true,
			["wh2_main_headhunters_jungle_oyxl"] = true
		},
		["outer_lost"] = 0,
		["inner_lost"] = 0
	},
	["wh2_main_great_vortex"] = {
		["outer"] = {
		["wh2_main_vor_eataine_angerrial"] = true,
		["wh2_main_vor_eataine_shrine_of_asuryan"] = true,
		["wh2_main_vor_straits_of_lothern_glittering_tower"] = true,
		["wh2_main_vor_straits_of_lothern_lothern"] = true,
		["wh2_main_vor_straits_of_lothern_tower_of_lysean"] = true
		},
		["inner"] = {
		["wh2_main_vor_headhunters_jungle_altar_of_the_horned_rat"] = true,
		["wh2_main_vor_headhunters_jungle_marks_of_the_old_ones"] = true,
		["wh2_main_vor_the_capes_citadel_of_dusk"] = true,
		["wh2_main_vor_the_capes_tip_of_lustria"] = true,
		["wh2_main_vor_culchan_plains_xlansec"] = true,
		["wh2_main_vor_the_vampire_coast_pox_marsh"] = true,
		["wh2_main_vor_the_vampire_coast_the_awakening"] = true,
		["wh2_main_vor_the_vampire_coast_the_blood_swamps"] = true,
		["wh2_main_vor_the_vampire_coast_the_star_tower"] = true,
		["wh2_main_vor_volcanic_islands_fuming_serpent"] = true,
		["wh2_main_vor_culchan_plains_chupayotl"] = true,
		["wh2_main_vor_culchan_plains_the_hissing_god"] = true,
		["wh2_main_vor_river_qurveza_mouth_of_qurveza"] = true,
		["wh2_main_vor_river_qurveza_axlotl"] = true
		},
		["outer_lost"] = 0,
		["inner_lost"] = 0
	}
};

function add_cod_naval_listeners()
	out("#### Adding cod_naval Listeners ####");
	local cod_naval = cm:model():world():faction_by_key(cod_naval_defender_faction);
	if cod_naval:is_human() == true then

	-- POWER OF AUTHORITY
	core:add_listener(
		"cod_power_of_authority",
		"CharacterTurnStart",
		function(context)
			local current_char = context:character();
			return current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_dlc10_hef_alarielle") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_dlc10_hef_alith_anar") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_main_hef_teclis") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_main_hef_tyrion") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("ovn_stormrider")
		end,
		function(context)
			local current_char = context:character();
			local region = current_char:region();
			
			if region:is_abandoned() == false and region:owning_faction():name() == cod_naval_defender_faction then
				local region_key = region:name();
				cm:remove_effect_bundle_from_region("ovn_cod_power_of_authority", region_key);
				cm:apply_effect_bundle_to_region("ovn_cod_power_of_authority", region_key, 10);
				cod_ll_popularity_regions[region_key] = 10;
				local garrison_residence = region:garrison_residence();
				local garrison_residence_CQI = garrison_residence:command_queue_index();
				cm:add_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.full, false);
				core:trigger_event("ScriptEventPowerOfNatureTriggered");
			end
		end,
		true
	);
	core:add_listener(
		"cod_power_of_authority_region",
		"RegionTurnStart",
		function(context)
			local region = context:region();
			return cod_ll_popularity_regions[region:name()] ~= nil;
		end,
		function(context)
			local region = context:region();
			local region_key = region:name();
			local garrison_residence = region:garrison_residence();
			local garrison_residence_CQI = garrison_residence:command_queue_index();
			
			if region:is_abandoned() == true or region:owning_faction():culture() ~= "wh2_main_hef_high_elves" then
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.full);
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.half);
				cm:remove_effect_bundle_from_region("ovn_cod_power_of_authority", region_key);
			end
			
			local turns_remaining = cod_ll_popularity_regions[region_key];
			turns_remaining = turns_remaining - 1;
			
			if turns_remaining > 5 then
				-- Display full VFX
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.full);
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.half);
				cm:add_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.full, false);
				cod_ll_popularity_regions[region_key] = turns_remaining;
			elseif turns_remaining > 0 then
				-- Switch to half strength VFX
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.full);
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.half);
				cm:add_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.half, false);
				cod_ll_popularity_regions[region_key] = turns_remaining;
			else
				-- Remove all VFX
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.full);
				cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_nature_vfx.half);
				cod_ll_popularity_regions[region_key] = nil;
			end
		end,
		true
	);
		
	core:add_listener(
		"cod_naval_action_region_update",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():is_human()
		end,
		function(context)
			if cod_regions["all"] then
				cod_naval_action_level = cod_naval_action_level + 4;
				cm:apply_effect_bundle("cod_influence", "wh2_main_hef_citadel_of_dusk", 2);
				cm:apply_dilemma_diplomatic_bonus("wh2_main_hef_citadel_of_dusk", "wh2_main_hef_eataine", 4)
				cm:apply_dilemma_diplomatic_bonus("wh2_main_hef_citadel_of_dusk", "wh2_main_hef_order_of_loremasters", 4)
			
		end
		end,
		true
	);
		-- COD NAVAL DEFENDER MECH
		core:add_listener(
			"cod_naval_defender_region_update",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				if cod_regions["all"] then
					local region_key = context:garrison_residence():region():name();
					return cod_regions["all"][region_key] == true;
				else
					return false;
				end
			end,
			function(context)
				local region = context:garrison_residence():region();
				cod_naval_defender_update(region);
			end,
			true
		);

		core:add_listener(
			"cod_naval_defender_update_listener",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == cod_naval_defender_faction;
			end,
			function(context)
				local campaign_key = "main_warhammer";
				if cm:model():campaign_name("wh2_main_great_vortex") then
					campaign_key = "wh2_main_great_vortex";
				end
				if cod_regions[campaign_key]["inner_lost"] > 0 then
				cod_naval_defender_level = cod_regions[campaign_key]["inner_lost"] - cod_naval_action_level;
				if cod_naval_defender_level < 1 then
				cod_naval_defender_level = 1
				elseif cod_naval_defender_level > 10 then
				cod_naval_defender_level = 10
				end
				if cod_naval_action_level > 0 then
					cod_naval_action_level = cod_naval_action_level - 1;
				end	
				elseif cod_naval_defender_level < 10 then
				cod_naval_defender_level = cod_naval_defender_level + 1;
				end
				local turn = cm:model():turn_number();
                local cooldown = 4
                if turn % cooldown == 0 then
				cod_naval_defender_initialize_invasion_and_supply()
				end
				cod_naval_defender_remove_effects(cod_naval_defender_faction);
				cm:apply_effect_bundle(cod_naval_defender_effect.."_"..cod_naval_defender_level, cod_naval_defender_faction, 0);
			end,
			true
		);
				
		if cm:is_new_game() == true then
			cod_naval_defender_initialize(true);
			cod_naval_intro_listeners();
			if cm:model():campaign_name("wh2_main_great_vortex") then
			cod_naval_action_level = 32
			else
			cod_naval_action_level = 28
			end
		else
			cod_naval_defender_initialize(false);
		end
	end
end

function cod_naval_defender_initialize(new_game)
	local campaign_key = "main_warhammer";
	local naval_route_types = {"inner", "outer"};
	
	if cm:model():campaign_name("wh2_main_great_vortex") then
		campaign_key = "wh2_main_great_vortex";
		cod_regions["main_warhammer"] = nil;
	else
		cod_regions["wh2_main_great_vortex"] = nil;
	end
	
	-- Populate a lookup table of all relevant regions
	cod_regions["all"] = {};
	
	for i = 1, #naval_route_types do
		for region_key, value in pairs(cod_regions[campaign_key][naval_route_types[i]]) do
			cod_regions["all"][region_key] = true;
			local region = cm:model():world():region_manager():region_by_key(region_key);
			
			if region:is_null_interface() == false then
				if region:is_abandoned() == true or region:owning_faction():culture() ~= "wh2_main_hef_high_elves" then
					cod_regions[campaign_key][naval_route_types[i]][region_key] = false;
					cod_regions[campaign_key][naval_route_types[i].."_lost"] = cod_regions[campaign_key][naval_route_types[i].."_lost"] + 1;
				end
			end
		end
	end
	
	cod_naval_defender_remove_effects(cod_naval_defender_faction);
	
	if cod_regions[campaign_key]["inner_lost"] > 0 then
		if new_game == true then
			cod_naval_defender_level = 1;
		end
		cod_naval_defender_effect = "ovn_cod_naval_defender_inner";
		cm:apply_effect_bundle(cod_naval_defender_effect.."_"..cod_naval_defender_level, cod_naval_defender_faction, 0);
	elseif cod_regions[campaign_key]["outer_lost"] > 0 then
		if new_game == true then
			cod_naval_defender_level = 1;
		end
		cod_naval_defender_effect = "ovn_cod_naval_defender_outer";
		cm:apply_effect_bundle(cod_naval_defender_effect.."_"..cod_naval_defender_level, cod_naval_defender_faction, 0);
	else
		if new_game == true then
			cod_naval_defender_level = 1;
		end
		cod_naval_defender_effect = "ovn_cod_naval_defender_all";
		cm:apply_effect_bundle(cod_naval_defender_effect.."_"..cod_naval_defender_level, cod_naval_defender_faction, 0);
	end

	--- COD NAVAL DEFENDER INVASION RAM
	random_army_manager:new_force("ovn_cod_vamp_coast_force");
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 2); 
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 3);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_1", 3);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_necrofex_colossus_0", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1); 
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_terrorgheist", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_syreens", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_deck_gunners_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_art_mortar", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_mournguls_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_bloated_corpse_0", 2);
	random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_cav_deck_droppers_1", 2);
	random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 3);
	random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_fell_bats", 2);
	
    random_army_manager:new_force("ovn_cod_norsca_force");
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_fimir_1", 2); 
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_war_mammoth_2", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_champions_0", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_skinwolves_1", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_art_hellcannon_battery", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_war_mammoth_1", 1); 
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_main_nor_cav_marauder_horsemen_1", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_norscan_giant_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_champions_1", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_fimir_0", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_norscan_ice_trolls_0", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_main_nor_cav_chaos_chariot", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_berserkers_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_main_nor_inf_chaos_marauders_0", 4);

    random_army_manager:new_force("ovn_cod_skaven_force");
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1); 
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_main_skv_art_plagueclaw_catapult", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_stormvermin_0", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_art_warp_lightning_cannon", 1); 
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_plague_monk_censer_bearer", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_poison_wind_globadiers", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_dlc14_skv_inf_eshin_triads_0", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_gutter_runners_1", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_night_runners_1", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_warpfire_thrower", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_stormvermin_1", 2);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_mon_rat_ogres", 2);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_veh_doomwheel", 1);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_dlc12_skv_veh_doom_flayer_0", 1);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_skavenslaves_0", 4);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_skavenslave_slingers_0", 2);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_clanrats_1", 3);
	
	random_army_manager:new_force("ovn_cod_greenskin_force");
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_art_doom_diver_catapult", 1); 
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1); 
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_orc_big_uns", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_night_goblin_fanatics", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_mon_arachnarok_spider_0", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_mon_trolls", 1); 
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_mon_giant", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_1", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_orc_boar_boy_big_uns", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_goblin_wolf_riders_1", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_dlc06_grn_inf_squig_herd_0", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_dlc06_grn_inf_nasty_skulkers_0", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_night_goblin_archers", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_night_goblins", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_goblin_archers", 1);
	random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);
	
	random_army_manager:new_force("ovn_cod_dark_elves_force");
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_har_ganeth_executioners_0", 2); 
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_darkshards_1", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_art_reaper_bolt_thrower", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_0", 3); 
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_1", 3); 
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_witch_elves_0", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_harpies", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_shades_2", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_mon_war_hydra", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_black_guard_0", 2);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_dlc10_def_cav_doomfire_warlocks_0", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_cav_cold_one_knights_1", 2);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_cav_cold_one_chariot", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_mon_black_dragon", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_dlc10_def_mon_kharibdyss_0", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1);

    random_army_manager:new_force("ovn_cod_chaos_force");
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh_dlc01_chs_inf_chosen_2", 3); 
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh_dlc01_chs_mon_dragon_ogre", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh_main_chs_inf_chosen_1", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh_main_chs_art_hellcannon", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1); 
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_mon_trolls_1", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_inf_chosen_0", 2);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc06_chs_cav_marauder_horsemasters_0", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_cav_chaos_chariot", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_cav_gorebeast_chariot", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_cav_chaos_knights_1", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_cav_chaos_knights_0", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_mon_giant", 1);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_mon_chaos_spawn", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_inf_forsaken_0", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_inf_chaos_warriors_0", 4);
	
end

function cod_naval_defender_update(region)
	if region ~= nil and region:is_null_interface() == false then
		local region_key = region:name();
		out("COD NAVAL DEFENDER MECH Region Update: "..region_key);
		local naval_route_type = nil;
		local campaign_key = "main_warhammer";
		
		if cm:model():campaign_name("wh2_main_great_vortex") then
			campaign_key = "wh2_main_great_vortex";
		end
		
		if cod_regions[campaign_key]["outer"][region_key] ~= nil then
			naval_route_type = "outer";
		elseif cod_regions[campaign_key]["inner"][region_key] ~= nil then
			naval_route_type = "inner";
		end
		
		if naval_route_type ~= nil then
			if cod_regions[campaign_key][naval_route_type][region_key] == true then
				if region:is_abandoned() == true or region:owning_faction():culture() ~= "wh2_main_hef_high_elves" then
					cod_regions[campaign_key][naval_route_type][region_key] = false;
					cod_regions[campaign_key][naval_route_type.."_lost"] = cod_regions[campaign_key][naval_route_type.."_lost"] + 1;
					cod_naval_action_level = cod_naval_action_level - 2;
					out("\tRegion was true and is now false - Value "..naval_route_type.."_lost count is "..tostring(cod_regions[campaign_key][naval_route_type.."_lost"]).." (+1)");
				end
			elseif cod_regions[campaign_key][naval_route_type][region_key] == false then
				if region:owning_faction():culture() == "wh2_main_hef_high_elves" then
				cod_regions[campaign_key][naval_route_type][region_key] = true;
				cod_regions[campaign_key][naval_route_type.."_lost"] = cod_regions[campaign_key][naval_route_type.."_lost"] - 1;
				out("\tRegion was false and is now true - Value "..naval_route_type.."_lost count is "..tostring(cod_regions[campaign_key][naval_route_type.."_lost"]).." (-1)");
				end
			else
				out("\tNo changes made");
			end
			
			cod_naval_defender_remove_effects(cod_naval_defender_faction);
			
			if cod_regions[campaign_key]["inner_lost"] > 0 then
				if cod_naval_defender_effect == "ovn_cod_naval_defender_all" or cod_naval_defender_effect == "ovn_cod_naval_defender_outer" then
					cod_naval_defender_show_event(region, "inner_lost");
					core:trigger_event("ScriptEventCodNavalDefenderInnerLost");
				end
				cod_naval_defender_level = cod_regions[campaign_key]["inner_lost"] - cod_naval_action_level;
				if cod_naval_defender_level < 1 then
					cod_naval_defender_level = 1
				end
				cod_naval_defender_effect = "ovn_cod_naval_defender_inner";
			elseif cod_regions[campaign_key]["outer_lost"] > 0 then
				if cod_naval_defender_effect == "ovn_cod_naval_defender_all" then
					cod_naval_defender_show_event(region, "outer_lost");
					core:trigger_event("ScriptEventCodNavalDefenderOuterLost");
				elseif cod_naval_defender_effect == "ovn_cod_naval_defender_inner" then
					core:trigger_event("ScriptEventCodNavalDefenderInnerRegained");
				end
				cod_naval_defender_level = 1;
				cod_naval_defender_effect = "ovn_cod_naval_defender_outer";
			else
				if cod_naval_defender_effect == "ovn_cod_naval_defender_outer" or cod_naval_defender_effect == "ovn_cod_naval_defender_inner" then
					cod_naval_defender_show_event(region, "united");
					core:trigger_event("ScriptEventCodNavalDefenderUnited");
				end
				cod_naval_defender_level = 1;
				cod_naval_defender_effect = "ovn_cod_naval_defender_all";
			end
			
			cm:apply_effect_bundle(cod_naval_defender_effect.."_"..cod_naval_defender_level, cod_naval_defender_faction, 0);
		end
	end
end

function cod_naval_defender_remove_effects(faction_str)
	local effects = {"inner", "outer", "all"};
	local faction = cm:get_faction(faction_str);
	
	for i = 1, 10 do
		for j = 1, #effects do
			local effect_bundle = "ovn_cod_naval_defender_" .. effects[j] .. "_" .. i;
			
			if faction:has_effect_bundle(effect_bundle) then
				cm:remove_effect_bundle(effect_bundle, faction_str);
			end
		end
	end
end

function cod_naval_defender_show_event(region, event_type)
	if event_type == "united" then
		cm:show_message_event(
			cod_naval_defender_faction,
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_title",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_united_primary_detail",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_united_secondary_detail",
			false,
			1012
		);
	else
		local x = region:settlement():logical_position_x();
		local y = region:settlement():logical_position_y();
	
		cm:show_message_event_located(
			cod_naval_defender_faction,
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_title",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_"..event_type.."_primary_detail",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_"..event_type.."_secondary_detail",
			x,
			y,
			false,
			1013
		);
	end
end

function cod_naval_intro_listeners()
	core:add_listener(
		"cod_naval_PanelOpenedCampaign",
		"PanelOpenedCampaign",
		function(context)
			local event_type, event_target, event_group = UIComponent(context.component):InterfaceFunction("GetEventType");
			
			if event_group == "wh_main_event_feed_scripted_intro_empire" then
				return true;
			end
			return false;
		end,
		function(context)
			local cod_naval_defender = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "topbar_list_parent", "alarielle_holder", "icon_effect");
			
			if cod_naval_defender then
				pulse_uicomponent(cod_naval_defender, true, 5);
			end
		end,
		false
	);
	core:add_listener(
		"cod_naval_PanelClosedCampaign",
		"PanelClosedCampaign",
		function(context)
			local event_type, event_target, event_group = UIComponent(context.component):InterfaceFunction("GetEventType");
			
			if event_group == "wh_main_event_feed_scripted_intro_empire" then
				return true;
			end
			return false;
		end,
		function(context)
			local cod_naval_defender = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "topbar_list_parent", "alarielle_holder", "icon_effect");
			
			if cod_naval_defender then
				pulse_uicomponent(cod_naval_defender, false);
			end
		end,
		false
	);
end

function cod_naval_defender_initialize_invasion_and_supply()

	local faction_name_str = cm:get_local_faction()
    local faction = cm:get_faction(faction_name_str);
	local high_roll = cm:random_number(4, 1) -- 25% Chance
	local standard_roll = cm:random_number(6, 1) -- 16.67% Chance
	local low_roll = cm:random_number(8, 1) -- 12.5% Chance
	local very_low_roll = cm:random_number(16, 1) -- 6.25% Chance
	
	for i = 6, 10 do
			local threat_v_high = "ovn_cod_naval_defender_inner_" .. i;
			
			if faction:has_effect_bundle(threat_v_high) then
				if high_roll == 1 then
				cod_invasion_start()
				end
				if very_low_roll == 2 then
				cod_reinforce_start()
				end
			end
		end

		for i = 1, 5 do
			local threat_high = "ovn_cod_naval_defender_inner_" .. i;
			
			if faction:has_effect_bundle(threat_high) then
				if standard_roll == 1 then
				cod_invasion_start()
				end
				if low_roll == 2 then
				cod_reinforce_start()
				end
				if very_low_roll == 3 then
				cod_beast_invasion_start()
				end	
			end
		end

		for i = 1, 10 do
			local threat_low = "ovn_cod_naval_defender_outer_" .. i;
			local threat_very_low = "ovn_cod_naval_defender_all_" .. i;

			if faction:has_effect_bundle(threat_low) then
				if low_roll == 1 then
				cod_invasion_start()
				elseif low_roll == 5 then
				cod_beast_invasion_start()
				end
				if standard_roll == 2 then
				cod_reinforce_start()
				end
			elseif faction:has_effect_bundle(threat_very_low) then
				if very_low_roll == 1 then
				cod_invasion_start()
				end
				if standard_roll == 6 then
				cod_beast_invasion_start()
				end	
				if high_roll == 2 then
				cod_reinforce_start()
				end
			end
        end
end

function cod_invasion_start()

local faction_name_str = cm:get_local_faction()
local faction_name = cm:get_faction(faction_name_str)
local char_faction_leader = cm:get_faction(faction_name_str):faction_leader()
local character_str = cm:char_lookup_str(char_faction_leader)
local faction_capital = faction_name:home_region():name();
local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, faction_capital, true, false, 45)
if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
	w, z = cm:find_valid_spawn_location_for_character_from_character(faction_name_str, character_str, false, 35)
end
local location = {x = w, y = z};
local location_patrol_create = w + 15, z + 50;
local location_patrol = {location_patrol_create};
local faction
local army
local upa -- units per army
local random_number = cm:random_number(6, 1)
local experience_amount
local turn_number = cm:model():turn_number();
local cod_invasion_patrol = {{location}, {location_patrol}};
local cod_invasion_targets = {
	"wh2_main_hef_citadel_of_dusk",
	"wh2_main_hef_order_of_loremasters",
	"wh2_main_hef_eataine",
	"wh2_dlc12_lzd_cult_of_sotek",
	"wh2_main_lzd_itza",
	"wh2_dlc13_emp_the_huntmarshals_expedition"
}
cod_invasion_mess()

    if cm:model():turn_number() < 25 then 
        upa = {8, 9}
        experience_amount = cm:random_number(3,1)
    elseif cm:model():turn_number() < 45 and cm:model():turn_number() > 10 then 
        upa = {15, 18}
        experience_amount = cm:random_number(5,1)
    elseif cm:model():turn_number() < 69 and cm:model():turn_number() > 24 then 
        upa = {16, 18}
        experience_amount = cm:random_number(7,1)
    elseif cm:model():turn_number() > 70 then 
        upa = {17, 19}
        experience_amount = cm:random_number(12,1)
    end

    if random_number == 1 then 
        faction = "wh2_dlc11_cst_vampire_coast_qb1"
		army = random_army_manager:generate_force("ovn_cod_vamp_coast_force", upa, false);
		cm:change_custom_faction_name("wh2_dlc11_cst_vampire_coast_qb1", "Harkon's Sea Dogs")          
    elseif random_number == 2 then 
        faction = "wh_main_nor_norsca_qb1"
		army = random_army_manager:generate_force("ovn_cod_norsca_force", upa, false);
		cm:change_custom_faction_name("wh_main_nor_norsca_qb1", "Skeggi Raiders")                
    elseif random_number == 3 then 
		faction = "wh2_main_skv_skaven_qb1"
		army = random_army_manager:generate_force("ovn_cod_skaven_force", upa, false);   
		cm:change_custom_faction_name("wh2_main_skv_skaven_qb1", "Clan Skurvy")             
    elseif random_number == 4 then 
        faction = "wh_main_grn_greenskins_qb1"
		army = random_army_manager:generate_force("ovn_cod_greenskin_force", upa, false); 
		cm:change_custom_faction_name("wh_main_grn_greenskins_qb1", "River Ratz")              
    elseif random_number == 5 then 
        faction = "wh2_main_def_dark_elves_qb1"
		army = random_army_manager:generate_force("ovn_cod_dark_elves_force", upa, false);
		cm:change_custom_faction_name("wh2_main_def_dark_elves_qb1", "Teilancarr's Corsairs")          
    elseif random_number == 6 then 
        faction = "wh_main_chs_chaos_qb1"
		army = random_army_manager:generate_force("ovn_cod_chaos_force", upa, false);
		cm:change_custom_faction_name("wh_main_chs_chaos_qb1", "Plaguefleet")          
    end       

    local cod_invasion = invasion_manager:new_invasion("cod_invasion_"..turn_number, faction, army, location);

	--cod_invasion:set_target("PATROL", cod_invasion_patrol, faction_name_str);
	
	if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
		cod_invasion:set_target("CHARACTER", faction_name:faction_leader():command_queue_index(), faction_name_str);
		else
		cod_invasion:set_target("REGION", faction_capital, faction_name_str);
	end

     cod_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
     cod_invasion:add_character_experience(experience_amount, true);
	 cod_invasion:add_unit_experience(experience_amount);
	 cod_invasion:add_aggro_radius(12000, cod_invasion_targets, 5, 3);
     cod_invasion:start_invasion(true);
end

function cod_beast_invasion_start()

	local faction_name_str = cm:get_local_faction()
	local faction_name = cm:get_faction(faction_name_str)
	local char_faction_leader = cm:get_faction(faction_name_str):faction_leader()
	local character_str = cm:char_lookup_str(char_faction_leader)
	local faction_capital = faction_name:home_region():name();
	local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, faction_capital, false, false, 25)
	if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
		 w, z = cm:find_valid_spawn_location_for_character_from_character(faction_name_str, character_str, false, 35)
	end
	local location = {x = w, y = z};
	local location_patrol_create = w + 15, z + 50;
	local location_patrol = {location_patrol_create};
	local faction = "wh2_main_lzd_lizardmen_qb1"
	local army
	local random_number = cm:random_number(4, 1)
	local experience_amount
	local turn_number = cm:model():turn_number();
	local cod_invasion_patrol = {{location}, {location_patrol}};
	local cod_invasion_targets = {
		"wh2_main_hef_citadel_of_dusk",
		"wh2_main_hef_order_of_loremasters",
		"wh2_main_hef_eataine",
		"wh2_dlc13_emp_the_huntmarshals_expedition"
	}
	cod_beast_invasion_mess()
	
		if cm:model():turn_number() < 25 then 
			experience_amount = cm:random_number(6,1)
		elseif cm:model():turn_number() < 45 and cm:model():turn_number() > 10 then 
			experience_amount = cm:random_number(8,1)
		elseif cm:model():turn_number() < 69 and cm:model():turn_number() > 24 then 
			experience_amount = cm:random_number(10,1)
		elseif cm:model():turn_number() > 70 then
			experience_amount = cm:random_number(12,1)
		end
	
		if random_number == 1 then 
			army = "wh2_dlc13_lzd_mon_dread_saurian_0,wh2_dlc13_lzd_mon_dread_saurian_0,wh2_dlc13_lzd_mon_dread_saurian_0"
		elseif random_number == 2 then 
			army = "wh2_dlc10_lzd_mon_carnosaur_boss,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0"
		elseif random_number == 3 then 
			army = "wh2_main_lzd_mon_stegadon_0,wh2_main_lzd_mon_stegadon_0,wh2_main_lzd_mon_stegadon_0,wh2_main_lzd_mon_bastiladon_0,wh2_main_lzd_mon_bastiladon_0,wh2_main_lzd_mon_bastiladon_0,wh2_main_lzd_mon_bastiladon_0"
		elseif random_number == 4 then 
			army = "wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0"
		end
	
		cm:change_custom_faction_name("wh2_main_lzd_lizardmen_qb1", "Beasts of the Jungle")  

		local cod_beast_invasion = invasion_manager:new_invasion("cod_beast_invasion_"..turn_number, faction, army, location);
	
		--cod_beast_invasion:set_target("PATROL", cod_invasion_patrol, faction_name_str);

		if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
			cod_beast_invasion:set_target("CHARACTER", faction_name:faction_leader():command_queue_index(), faction_name_str);
            else
        	cod_beast_invasion:set_target("REGION", faction_capital, faction_name_str);
    	end
	
		cod_beast_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
		cod_beast_invasion:add_character_experience(experience_amount, true);
		cod_beast_invasion:add_unit_experience(experience_amount);
		cod_beast_invasion:add_aggro_radius(12000, cod_invasion_targets, 5, 3);
		cod_beast_invasion:start_invasion(true);
	end

function cod_reinforce_start()
	   
    local ovn_cod_reinforcement_unit_pool = {
        "ovn_hef_cav_ellyrian_reavers_shore",
        "ovn_hef_inf_archers_sea",
        "ovn_hef_inf_archers_fire",
        "ovn_hef_inf_archers_wind",
        "ovn_hef_inf_spearmen_falcon",
        "ovn_hef_inf_spearmen_sapphire"
	}
	
-- COULD ADD EXTRAS IF THE USER IS USING CATAPHS SEA ELF NAVY MOD
   --[[ if cm:get_saved_value("Cataph_TEB") == true then
        local cataph_units = {
            "teb_ricco",
            "teb_origo"
        }
        for i = 1, #cataph_units do
            table.insert(ovn_reinforcement_unit_pool, cataph_units [i])
        end;
    end]]

    local human_faction = cm:get_human_factions();
    local faction_name = cm:get_faction(human_faction[1])
    local faction_str = faction_name:name()
    local random_number = cm:random_number(#ovn_cod_reinforcement_unit_pool, 1)
    local unit_key = ovn_cod_reinforcement_unit_pool[random_number]
	
	cm:add_unit_to_faction_mercenary_pool(faction_name, unit_key, 1, 0, 5, 0, 0, "", "", "", false);
	cod_unit_gained_mess()
	cod_naval_action_level = cod_naval_action_level + 2;
end

function cod_unit_gained_mess()

	local human_factions = cm:get_human_factions();	
								
		for i = 1, #human_factions do
									
			cm:show_message_event(
				human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_unit_gained_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_unit_gained_secondary_detail",
					true,
					2502
					);
		end;
											
end

function cod_invasion_mess()

	local human_factions = cm:get_human_factions();	
								
		for i = 1, #human_factions do
									
			cm:show_message_event(
				human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_invasion_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_invasion_secondary_detail",
					true,
					2501
					);
		end;
											
end

function cod_beast_invasion_mess()

	local human_factions = cm:get_human_factions();	
								
		for i = 1, #human_factions do
									
			cm:show_message_event(
				human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_beast_invasion_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_beast_invasion_secondary_detail",
					true,
					2500
					);
		end;
											
end

cm:add_first_tick_callback(function() add_cod_naval_listeners() end)

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("cod_naval_defender_level", cod_naval_defender_level, context);
		cm:save_named_value("cod_naval_action_level", cod_naval_action_level, context);
		cm:save_named_value("cod_ll_popularity_regions", cod_ll_popularity_regions, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		cod_naval_defender_level = cm:load_named_value("cod_naval_defender_level", 1, context);
		cod_naval_action_level = cm:load_named_value("cod_naval_action_level", 1, context);
		cod_ll_popularity_regions = cm:load_named_value("cod_ll_popularity_regions", {}, context);
	end
);
