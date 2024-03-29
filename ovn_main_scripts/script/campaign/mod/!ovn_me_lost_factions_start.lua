local new_forces_file = require("script/ovn_tables/new_forces")
local new_forces = new_forces_file["main_warhammer"]
local grudgebringers = require("script/ovn_tables/grudgebringers_force")["main_warhammer"]

local mct = core:get_static_object("mod_configuration_tool")
local settings_table --:map<string, WHATEVER>

local factions = {}

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

--- We make sure we don't start spawning people before we killed all the vanilla armies.
local done_killing_people = false

local function spawn_new_force(data)
	cm:create_force_with_general(
		data.faction_key,
		data.unit_list,
		data.region_key,
		data.x,
		data.y,
		data.type,
		data.subtype,
		data.name1,
		data.name2,
		data.name3,
		data.name4,
		data.make_faction_leader,
		data.callback
	)
end

local function spawn_new_forces()
	if not done_killing_people then
		cm:callback(spawn_new_forces, 0)
		return
	end

	local i = 0
	for _, data in pairs(new_forces) do
		if data and table_contains(factions, data.faction_key) then
			cm:callback(
				function()
					spawn_new_force(data)
				end,
				i
			)

			i = i + 0.2
		end
	end
end

-- list of CQI's for characters to be murdered
local murdered = {}

local function kill_people()
	out("OvN needs to kill "..tostring(#murdered).." characters!")
	local cutoff = math.ceil(#murdered/2)

	for i = 1, cutoff do
		local str = "character_cqi:" .. murdered[i]
		cm:set_character_immortality(str, false)
		cm:kill_character_and_commanded_unit(str, true, false)
	end

	cm:callback(
		function()
			for i = cutoff+1, #murdered do
				local str = "character_cqi:" .. murdered[i]
					cm:set_character_immortality(str, false)
					cm:kill_character_and_commanded_unit(str, true, false)
				end
				done_killing_people = true
		end,
		0
	)
end

local function add_cqi_to_murdered_list(cqi)
	murdered[#murdered + 1] = cqi
end

local function apply_diplo_bonuses()
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_dlc09_tmb_followers_of_nagash", -3)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_dlc09_tmb_exiles_of_nehek", -3)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_dlc09_tmb_khemri", -3)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_dlc09_tmb_lybaras", -3)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_main_emp_sudenburg", -3)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_main_arb_aswad_scythans", 2)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_main_arb_flaming_scimitar", 2)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_caliphate_of_araby", "wh2_main_skv_clan_mors", 3)

	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_dlc09_tmb_followers_of_nagash", -6)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_dlc09_tmb_exiles_of_nehek", 6)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_dlc09_tmb_khemri", 6)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_dlc09_tmb_lybaras", 6)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_dlc09_tmb_numas", 6)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_main_emp_sudenburg", -1)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_aswad_scythans", "wh2_main_arb_caliphate_of_araby", 2)

	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_flaming_scimitar", "wh2_main_skv_clan_pestilens", 6)
	cm:apply_dilemma_diplomatic_bonus("wh2_main_arb_flaming_scimitar", "wh2_main_skv_clan_pestilens", 6)

	cm:apply_dilemma_diplomatic_bonus("wh2_main_hef_citadel_of_dusk", "wh2_main_hef_order_of_loremasters", 6)

	cm:apply_dilemma_diplomatic_bonus("wh2_main_nor_trollz", "wh_main_grn_red_fangs", -6)

	cm:apply_dilemma_diplomatic_bonus("wh_main_emp_empire", "wh2_main_emp_the_moot", 5)
end

--------------------------------------------------------------
------------------------ AMAZONS  ----------------------------
--------------------------------------------------------------

local function amazon_setup()
	local faction_key = "wh2_main_amz_amazons" -- factions key
	local amazon = cm:get_faction(faction_key)
	local amazon_faction_leader_cqi = amazon:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(amazon_faction_leader_cqi)

	if effect.get_localised_string("land_units_onscreen_name_roy_amz_inf_eagle_warriors") == "" then
		return
	end

	if amazon and (amazon:is_human() or not mct or settings_table.amazon and settings_table.enable) then
		-- give Tlanxla to Amazons, do some work for them
		if amazon:is_human() then
			cm:transfer_region_to_faction("wh2_main_jungles_of_green_mists_wellsprings_of_eternity", "wh2_dlc12_skv_clan_mange")
			cm:heal_garrison(cm:get_region("wh2_main_jungles_of_green_mists_wellsprings_of_eternity"):cqi());
		end

		local is_lwaxana_starting_lord = core:svr_load_bool("ovn_amazon_lords_lwaxana_is_leader")
		if not amazon:is_human() then
			is_lwaxana_starting_lord = cm:random_number(2) == 1
		end

		local subtype = "roy_amz_penthesilea"
		local firstname = "names_name_3508823034"
		local surname = ""
		local units = "roy_amz_inf_warriors,roy_amz_inf_scouts,roy_amz_mon_wildcats,roy_amz_inf_scouts,roy_amz_inf_warriors,roy_amz_inf_eagle_warriors,roy_amz_cav_culchan_riders_ranged"
		local spawnX = 76
		local spawnY = 160

		if is_lwaxana_starting_lord then
			subtype = "roy_amz_lwaxana"
			firstname = "names_name_3508823024"
			surname = ""
			units = "roy_amz_inf_warriors,roy_amz_inf_scouts,roy_amz_mon_curse_bats,roy_amz_mon_curse_bats,roy_amz_inf_warriors,roy_amz_inf_koka_kalim,roy_amz_inf_koka_kalim_devouts"
			cm:transfer_region_to_faction("wh2_main_the_creeping_jungle_tlanxla", "wh2_dlc12_skv_clan_mange")
			cm:heal_garrison(cm:get_region("wh2_main_the_creeping_jungle_tlanxla"):cqi());

			spawnX = 138
			spawnY = 232
		else
			cm:transfer_region_to_faction("wh2_main_the_creeping_jungle_tlanxla", "wh2_main_amz_amazons")
			local tlanxa_region = cm:model():world():region_manager():region_by_key("wh2_main_the_creeping_jungle_tlanxla")
			cm:instantly_set_settlement_primary_slot_level(tlanxa_region:settlement(), 3)
			cm:heal_garrison(tlanxa_region:cqi())
		end

		cm:create_force_with_general(
			"wh2_main_amz_amazons",
			units,
			"wh2_main_the_creeping_jungle_tlanxla",
			spawnX,
			spawnY,
			"general",
			subtype,
			firstname,
			"",
			surname,
			"",
			true,
			function(cqi)
				cm:set_character_immortality("character_cqi:" .. cqi, true)
				cm:set_character_unique("character_cqi:" .. cqi, true)
			end
		)

		table.insert(factions, faction_key)
	end
end

local function araby_diplomacy_setup()
	-------- Araby Race (All 3 Factions) Diplomacy Extras ------

	cm:apply_effect_bundle("sr_arab_bundle", "wh2_main_skv_clan_mors", -1)
	cm:apply_effect_bundle("sr_arab_bundle", "wh2_main_skv_clan_eshin", -1)
	cm:apply_effect_bundle("sr_arab_bundle", "wh2_main_arb_aswad_scythans", -1)
	cm:apply_effect_bundle("sr_arab_bundle", "wh2_main_arb_caliphate_of_araby", -1)

	cm:apply_effect_bundle("sr_arab_bundle_bad", "wh2_main_brt_knights_of_origo", -1)
	cm:apply_effect_bundle("sr_arab_bundle_bad", "wh2_main_brt_thegans_crusaders", -1)
	cm:apply_effect_bundle("sr_arab_bundle_bad", "wh2_main_brt_knights_of_the_flame", -1)
	cm:apply_effect_bundle("sr_arab_bundle_bad", "wh2_main_emp_sudenburg", -1)

	----------------------Buff Knights of Origo---------------
	--cm:transfer_region_to_faction("wh2_main_atalan_mountains_martek", "wh2_main_brt_knights_of_origo")
	--cm:heal_garrison(cm:get_region("wh2_main_atalan_mountains_martek"):cqi())
end

--------------------------------------------------------------
----------------------- ARABY CALIPHATE-----------------------
--------------------------------------------------------------
local araby_rors = {
	"ovn_jag_ror",
	"ovn_jez_ror",
	"ovn_bom_ror",
	"ovn_knights_ror",
	"ovn_cat_knights_ror",
	"ovn_elephant_ror",
	"ovn_arb_mon_war_elephant_ror",
	"ovn_arb_cav_flying_carpet_ror"
}

local function araby_caliphate_setup()
	local flame = cm:get_faction("wh2_main_arb_caliphate_of_araby")
	local flame_faction_leader_cqi = flame:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(flame_faction_leader_cqi)

	if flame and (flame:is_human() or not mct or settings_table.araby and settings_table.enable) then
		cm:create_agent("wh2_main_arb_caliphate_of_araby", "champion", "roy_arb_champion", 445, 132, false)
		cm:replenish_action_points("faction:wh2_main_arb_caliphate_of_araby,type:champion")

		cm:teleport_to("faction:wh2_main_brt_thegans_crusaders", 450, 105, true)

		local martek_region = cm:model():world():region_manager():region_by_key("wh2_main_atalan_mountains_martek")
		cm:instantly_set_settlement_primary_slot_level(martek_region:settlement(), 3)

		local al_haikk_region = cm:get_region("wh2_main_coast_of_araby_al_haikk")
		cm:transfer_region_to_faction("wh2_main_coast_of_araby_al_haikk", "wh2_main_arb_caliphate_of_araby")
		cm:heal_garrison(al_haikk_region:cqi())
		--cm:override_building_chain_display("wh_main_BRETONNIA_settlement_major_coast", "wh_main_special_settlement_kislev", "wh2_main_coast_of_araby_al_haikk")

		local kalabad_region = cm:model():world():region_manager():region_by_key("wh2_main_great_desert_of_araby_el-kalabad")
		cm:transfer_region_to_faction("wh2_main_great_desert_of_araby_el-kalabad", "wh2_main_arb_caliphate_of_araby")
		cm:instantly_set_settlement_primary_slot_level(kalabad_region:settlement(), 2)
		cm:heal_garrison(kalabad_region:cqi())

		local faction_key = "wh2_main_arb_caliphate_of_araby" -- factions key

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record

		for _, unit in ipairs(araby_rors) do
			cm:add_unit_to_faction_mercenary_pool(
				flame,
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

		table.insert(factions, faction_key)
	end
end

	--------------------------------------------------------------
	----------------------- SCYTHANS -----------------------------
	--------------------------------------------------------------
local function araby_scythans_setup()
	local scythans = cm:get_faction("wh2_main_arb_aswad_scythans")
	local scythans_faction_leader_cqi = scythans:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(scythans_faction_leader_cqi)

	if scythans and (scythans:is_human() or not mct or settings_table.araby and settings_table.enable) then
		cm:transfer_region_to_faction("wh2_main_ash_river_quatar", "wh2_main_arb_aswad_scythans")
		cm:transfer_region_to_faction("wh2_main_shifting_sands_ka-sabar", "wh2_main_arb_aswad_scythans")

		cm:heal_garrison(cm:get_region("wh2_main_ash_river_quatar"):cqi())
		cm:heal_garrison(cm:get_region("wh2_main_shifting_sands_ka-sabar"):cqi())

		cm:create_agent("wh2_main_arb_aswad_scythans", "spy", "roy_arb_nomad", 694, 121, false)
		cm:replenish_action_points("faction:wh2_main_arb_aswad_scythans,type:spy")

		cm:apply_effect_bundle("sr_arab_bundle", "wh2_main_arb_aswad_scythans", -1)

		cm:teleport_to("faction:wh2_main_vmp_necrarch_brotherhood,forename:2147359170", 675, 65, true)

		cm:force_alliance("wh2_main_arb_aswad_scythans", "wh2_dlc09_tmb_numas", true)

		if cm:get_faction("wh2_main_arb_aswad_scythans"):is_human() then
			cm:create_force_with_general(
				"wh_main_chs_chaos_qb1",
				"wh_main_chs_inf_chaos_warriors_0,wh_main_chs_cav_chaos_knights_0,wh_main_arb_mon_elephant,ovn_slave,OtF_khemri_spearmen,OtF_khemri_archers,ovn_southlander",
				"wh2_main_great_desert_of_araby_el-kalabad",
				686,
				115,
				"general",
				"ovn_araby_ll",
				"names_name_3508823266",
				"",
				"names_name_3508823267",
				"",
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, -1, true)
					cm:disable_movement_for_character("character_cqi:" .. cqi)
				end
			)

		cm:change_custom_faction_name("wh_main_chs_chaos_qb1", "Grand Scythan Coalition")
		cm:force_declare_war("wh_main_chs_chaos_qb1", "wh2_main_arb_aswad_scythans", false, false)

		end

		local faction_key = "wh2_main_arb_aswad_scythans" -- factions key

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record

		for _, unit in ipairs(araby_rors) do
			cm:add_unit_to_faction_mercenary_pool(
				scythans,
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

		table.insert(factions, faction_key)
	end
end

	--------------------------------------------------------------
	-------------- FLAMING SCIMITAR  -----------------------------
	--------------------------------------------------------------
local function araby_scimitar_setup()
	local scimitar = cm:get_faction("wh2_main_arb_flaming_scimitar")
	local scimitar_faction_leader_cqi = scimitar:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(scimitar_faction_leader_cqi)

	if scimitar and (scimitar:is_human() or not mct or settings_table.araby and settings_table.enable) then
		cm:transfer_region_to_faction("wh2_main_vampire_coast_pox_marsh", "wh2_main_arb_flaming_scimitar")

		cm:heal_garrison(cm:get_region("wh2_main_vampire_coast_pox_marsh"):cqi())

		cm:force_religion_factors(
			"wh2_main_vampire_coast_the_awakening",
			"wh_main_religion_undeath",
			0.5,
			"wh_main_religion_untainted",
			0.5
		)

		local faction_key = "wh2_main_arb_flaming_scimitar" -- factions key

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record

		for _, unit in ipairs(araby_rors) do
			cm:add_unit_to_faction_mercenary_pool(
				scimitar,
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

		table.insert(factions, faction_key)
	end
end

--------------------------------------------------------------
--------------------- BLOOD DRAGONS --------------------------
--------------------------------------------------------------

local function blood_dragon_setup()
	local blood_dragons = cm:get_faction("wh2_main_vmp_blood_dragons")
	local blood_dragons_leader = blood_dragons:faction_leader()

	if blood_dragons_leader and not blood_dragons_leader:is_null_interface() then
		local blood_dragons_leader_cqi = blood_dragons:faction_leader():command_queue_index()
		add_cqi_to_murdered_list(blood_dragons_leader_cqi)
		-- out("OVN: OLD BLOOD DRAGONS FACTION LEADER TO KILL CQI: "..tostring(blood_dragons_leader_cqi))
	end

	if blood_dragons and (blood_dragons:is_human() or not mct or settings_table.blood_dragon and settings_table.enable) then

		cm:override_building_chain_display(
			"wh_main_DWARFS_settlement_major",
			"wh_main_VAMPIRES_settlement_major",
			"wh_main_southern_grey_mountains_karak_norn"
		)

		-- this was moved to new_game_startup to make sure we don't auto-lose the game with no armies and regions
		-- cm:transfer_region_to_faction("wh_main_southern_grey_mountains_karak_norn", "wh2_main_vmp_blood_dragons")

		local karaknorn_region = cm:model():world():region_manager():region_by_key("wh_main_southern_grey_mountains_karak_norn")
		local karaknorn_settlement = karaknorn_region:settlement()
		cm:instantly_set_settlement_primary_slot_level(karaknorn_settlement, 2)
		cm:change_custom_settlement_name(karaknorn_region:settlement(), effect.get_localised_string("ovn_wh_main_southern_grey_mountains_karak_norn_new_region_name"))

		cm:heal_garrison(karaknorn_region:cqi())
		cm:force_religion_factors(
			"wh_main_southern_grey_mountains_karak_norn",
			"wh_main_religion_undeath",
			0.5,
			"wh_main_religion_untainted",
			0.5
		)

		-- KARAK NORN DWARF REHOMING
		if not cm:get_faction("wh_main_dwf_karak_izor"):is_human() then
			cm:transfer_region_to_faction("wh_main_the_vaults_karak_bhufdar", "wh_main_dwf_karak_norn")
			local bhufdar_region = cm:model():world():region_manager():region_by_key("wh_main_the_vaults_karak_bhufdar")
			cm:instantly_set_settlement_primary_slot_level(bhufdar_region:settlement(), 3)
			cm:region_slot_instantly_upgrade_building(
				bhufdar_region:settlement():active_secondary_slots():item_at(2),
				"wh_main_dwf_garrison_2"
			)
			cm:heal_garrison(bhufdar_region:cqi())
			cm:kill_character_and_commanded_unit("faction:wh_main_dwf_karak_norn,surname:2147345835", true, true)
		end

		if cm:get_faction("wh2_main_vmp_blood_dragons"):is_human() then
			cm:create_force_with_general(
				"wh_main_emp_empire_qb1",
				"wh2_dlc13_emp_inf_archers_0,wh_dlc04_emp_cav_knights_blazing_sun_0,wh_dlc04_emp_inf_flagellants_0,wh_main_emp_inf_spearmen_0",
				"wh2_main_volcanic_islands_fuming_serpent",
				512,
				376,
				"general",
				"dlc04_emp_arch_lector",
				"names_name_2147355060",
				"",
				"names_name_270789187",
				"",
				true,
				function(cqi)
					local mil_force = cm:get_character_by_cqi(cqi):military_force()
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, 25, true)

					local x, y = cm:find_valid_spawn_location_for_character_from_character("wh_main_emp_empire_qb1", cm:char_lookup_str(cm:get_character_by_cqi(cqi)), true)
					if x ~= -1 then
						cm:create_agent(
							"wh_main_emp_empire_qb1",
							"spy",
							"emp_witch_hunter",
							x,
							y,
							false,
							function(agent_cqi)
								cm:embed_agent_in_force(cm:get_character_by_cqi(agent_cqi), mil_force)
							end
						)
					end
				end
			)

			cm:change_custom_faction_name("wh_main_emp_empire_qb1", "Van Hal's Crusade")
			cm:force_declare_war("wh2_main_vmp_blood_dragons", "wh_main_emp_empire_qb1", false, false)
		end

		cm:callback(
			--- There is a strange timing issue where the blood_dragons_leader_cqi CQI
			--- is the same as the CQI of the guy we spawn below.
			--- That's why it's wrapped in a callback.
			--- Alternatively we can just kill the blood_dragons_leader_cqi instead of
			--- putting him in add_cqi_to_murdered_list.
			function()
				cm:create_force_with_general(
					"wh2_main_vmp_blood_dragons",
					"wh_dlc02_vmp_cav_blood_knights_0,wh_dlc02_vmp_cav_blood_knights_0,dismounted_blood_knights_shield,wh_main_vmp_inf_skeleton_warriors_1",
					"wh2_main_land_of_assassins_sorcerers_islands",
					510,
					380,
					"general",
					"vmp_cha_walach",
					"names_name_8888277188",
					"",
					"names_name_8888277189",
					"",
					true,
					function(cqi)
						-- out("OVN: WALLACH HARKON CQI IS "..tostring(cqi))
						local str = "character_cqi:" .. cqi
						cm:set_character_immortality(str, true)
						cm:set_character_unique(str, true)
					end
				)
			end,
			1
		)

		cm:force_declare_war("wh2_main_vmp_blood_dragons", "wh_main_emp_wissenland", false, false)

		table.insert(factions, "wh2_main_vmp_blood_dragons")
	end
end

--------------------------------------------------------------
------------------- CITADEL OF DUSK --------------------------
--------------------------------------------------------------

local function citadel_setup()
	local dusk = cm:get_faction("wh2_main_hef_citadel_of_dusk")
	local dusk_faction_leader_cqi = dusk:faction_leader():command_queue_index()

	if dusk and (dusk:is_human() or not mct or settings_table.citadel and settings_table.enable) then
		add_cqi_to_murdered_list(dusk_faction_leader_cqi)

		cm:override_building_chain_display(
			"wh2_main_lzd_settlement_minor_coast",
			"wh2_main_hef_settlement_major_coast",
			"wh2_main_headhunters_jungle_mangrove_coast"
		)

		cm:create_force_with_general(
			"wh2_main_hef_citadel_of_dusk",
			"wh2_dlc10_hef_inf_the_storm_riders_ror_0,wh2_main_hef_inf_spearmen_0,wh2_main_hef_inf_swordmasters_of_hoeth_0,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_art_eagle_claw_bolt_thrower,wh2_main_hef_mon_great_eagle",
			"wh2_main_land_of_assassins_sorcerers_islands",
			215,
			15,
			"general",
			"ovn_stormrider",
			"names_name_999982321",
			"",
			"",
			"",
			true,
			function(cqi)
				local str = "character_cqi:" .. cqi
				cm:set_character_unique(str, true)
				cm:set_character_immortality(str, true)
			end
		)

		if not vfs.exists("script/campaign/mod/sr_vermintide.lua") then
			cm:create_force(
				"wh2_main_skv_clan_gnaw",
				"wh2_main_skv_mon_rat_ogres,wh2_main_skv_inf_poison_wind_globadiers,wh2_main_skv_inf_warpfire_thrower,wh2_main_skv_inf_clanrats_0,wh2_main_skv_inf_clanrat_spearmen_1",
				"wh2_main_kingdom_of_beasts_serpent_coast",
				290,
				420,
				true,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh2_main_sr_fervour", cqi, 25, true)
				end
			)
		end

		cm:transfer_region_to_faction("wh2_main_headhunters_jungle_mangrove_coast", "wh2_main_hef_citadel_of_dusk")

		local mangrove_region = cm:model():world():region_manager():region_by_key("wh2_main_headhunters_jungle_mangrove_coast")
		cm:instantly_set_settlement_primary_slot_level(mangrove_region:settlement(), 3)
		cm:region_slot_instantly_upgrade_building(
			mangrove_region:settlement():active_secondary_slots():item_at(1),
			"ovn_Citadel_of_dusk"
		)

		cm:heal_garrison(mangrove_region:cqi())

		cm:add_unit_to_faction_mercenary_pool(dusk, "ovn_hef_inf_archers_fire", 1, 0, 5, 0, 0, "", "", "", false)

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"cr_hef_veh_lothern_skycutter_ror",
		}

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				dusk,
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

		table.insert(factions, "wh2_main_hef_citadel_of_dusk")
	end
end

--------------------------------------------------------------
----------------------- HALFLINGS  ---------------------------
--------------------------------------------------------------
local function set_up_moot_turn_one_fight()
	local starting_fight_faction_key = "wh_main_vmp_vampire_counts_qb3"

	local first_region_name = cm:model():world():region_manager():region_list():item_at(0):name()
	cm:create_force_with_general(
		starting_fight_faction_key,
		"wh_main_vmp_inf_skeleton_warriors_0,wh_main_vmp_inf_skeleton_warriors_0,wh_main_vmp_inf_skeleton_warriors_1,wh_main_vmp_inf_skeleton_warriors_1,wh_main_vmp_veh_black_coach,wh_main_vmp_mon_crypt_horrors,wh_main_vmp_inf_crypt_ghouls,wh_main_vmp_mon_fell_bats,wh_main_vmp_inf_zombie,wh_main_vmp_mon_dire_wolves",
		first_region_name,
		622,
		417,
		"general",
		"vmp_lord",
		"names_name_2147345100",
		"",
		"names_name_1305581408",
		"",
		true,
		function(cqi)
			cm:force_declare_war("wh2_main_emp_the_moot", starting_fight_faction_key, true, true)
			local lookup_str = "character_cqi:" .. cqi
			cm:attack_region(lookup_str, "wh_main_stirland_the_moot", true)
		end
	)
end

local function halflings_setup()
	local moot_string = "wh2_main_emp_the_moot"
	local moot = cm:get_faction(moot_string)
	local moot_faction_leader_cqi = moot:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(moot_faction_leader_cqi)

	if moot and (moot:is_human() or not mct or settings_table.halflings and settings_table.enable) then
		cm:transfer_region_to_faction("wh_main_stirland_the_moot", moot_string)

		local moot_region = cm:model():world():region_manager():region_by_key("wh_main_stirland_the_moot")

		if moot:is_human() then
			set_up_moot_turn_one_fight()
			--cm:instantly_set_settlement_primary_slot_level(moot_region:settlement(), 2)

			cm:treasury_mod("wh2_main_emp_the_moot", -1000)

			cm:force_alliance("wh2_main_emp_the_moot", "wh_main_emp_empire", true)
		else
			cm:instantly_set_settlement_primary_slot_level(moot_region:settlement(), 3)
		end

		cm:heal_garrison(moot_region:cqi())

		cm:create_agent(
			"wh2_main_emp_the_moot",
			"dignitary",
			"ovn_hlf_master_chef",
			616,
			408,
			false,
			function(cqi)
				cm:replenish_action_points(cm:char_lookup_str(cqi))
			end
		)

		--local unit_key = "chosen_asur_lions" -- String unit_record
		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"halfling_warfoot",
			"sr_ogre_ror",
			"halfling_cock",
			"wh_main_mtl_veh_soupcart",
			"halfling_cat_ror",
			"halfling_pantry_guards_ror",
			"halfling_lords_of_harvest_ror",
			"halfling_knights_kitchentable_ror",
		}

		cm:add_unit_to_faction_mercenary_pool(
			moot,
			"wh2_dlc13_emp_cav_pistoliers_1_imperial_supply",
			1,
			0,
			5,
			0,
			xp_level,
			frr,
			srr,
			trr,
			true
		)

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				moot,
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

		table.insert(factions, "wh2_main_emp_the_moot")
	end
end

--------------------------------------------------------------
------------------------- TROLL  -----------------------------
--------------------------------------------------------------

local function trollz_setup()
	local troll_string = "wh2_main_nor_trollz"
	local troll = cm:get_faction("wh2_main_nor_trollz")
	local troll_faction_leader_cqi = troll:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(troll_faction_leader_cqi)

	if troll and (troll:is_human() or not mct or settings_table.trollz and settings_table.enable)then

		local char_cqi = cm:get_faction("wh2_main_dwf_greybeards_prospectors"):faction_leader():command_queue_index()
		cm:teleport_to(cm:char_lookup_str(char_cqi), 439, 40, true)

		cm:transfer_region_to_faction("wh_main_southern_badlands_agrul_migdhal", "wh2_main_nor_trollz")
        cm:transfer_region_to_faction("wh_main_blightwater_karak_azgal", "wh_main_grn_red_fangs")

		local agrul_region = cm:get_region("wh_main_southern_badlands_agrul_migdhal")
		cm:heal_garrison(agrul_region:cqi())
		cm:instantly_set_settlement_primary_slot_level(agrul_region:settlement(), 2)
        
        local azgal_region = cm:get_region("wh_main_blightwater_karak_azgal")
		cm:instantly_set_settlement_primary_slot_level(agrul_region:settlement(), 2)
        cm:heal_garrison(azgal_region:cqi())
        
        	cm:force_religion_factors("wh2_main_albion_albion", "wh_main_religion_untainted", 0.5, "wh_main_religion_chaos", 0.5)


		if not troll:is_human() then
			cm:transfer_region_to_faction("wh_main_vanaheim_mountains_troll_fjord", "wh2_main_nor_trollz")
			cm:transfer_region_to_faction("wh2_main_misty_hills_wreckers_point", "wh2_main_nor_trollz")
			cm:transfer_region_to_faction("wh_main_rib_peaks_grom_peak", "wh2_main_nor_trollz")
            cm:transfer_region_to_faction("wh2_main_atalan_mountains_eye_of_the_panther", "wh2_main_nor_trollz")
			cm:heal_garrison(cm:get_region("wh_main_vanaheim_mountains_troll_fjord"):cqi())
			cm:heal_garrison(cm:get_region("wh2_main_misty_hills_wreckers_point"):cqi())
			cm:heal_garrison(cm:get_region("wh_main_rib_peaks_grom_peak"):cqi())
            cm:heal_garrison(cm:get_region("wh2_main_atalan_mountains_eye_of_the_panther"):cqi())
            
            cm:force_religion_factors("wh2_main_albion_albion", "wh_main_religion_untainted", 0.25, "wh_main_religion_chaos", 0.75)

		end

		--local unit_key = "chosen_asur_lions" -- String unit_record
		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"elo_red_avalanche",
			"elo_shipwreckers",
			"elo_kin",
			"elo_night_trolls_ror",
			"wh2_dlc15_grn_mon_river_trolls_ror_0",
      "elo_warpstone_trolls",
		}

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				troll,
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

		table.insert(factions, troll_string)
	end
end

--------------------------------------------------------------
----------------- TREEBLOOD AKA Be'lakor----------------------
--------------------------------------------------------------

local function treeblood_setup()
	local tree = cm:get_faction("wh2_main_nor_harbingers_of_doom")

	local tree_faction_leader = tree:faction_leader()
	if tree_faction_leader and not tree_faction_leader:is_null_interface() then
		local tree_faction_leader_cqi = tree_faction_leader:command_queue_index()
			add_cqi_to_murdered_list(tree_faction_leader_cqi)
	end

	if tree and (tree:is_human() or not mct or settings_table.treeblood and settings_table.enable) then

		if tree:is_human() then
			cm:transfer_region_to_faction("wh2_main_albion_citadel_of_lead", "wh2_main_nor_harbingers_of_doom")
			cm:heal_garrison(cm:get_region("wh2_main_albion_citadel_of_lead"):cqi())

			local albion_region = cm:model():world():region_manager():region_by_key("wh2_main_albion_albion")
			cm:instantly_set_settlement_primary_slot_level(albion_region:settlement(), 2)

			local belakor_spawn_data = new_forces["wh2_main_nor_harbingers_of_doom"]
			if belakor_spawn_data then
				belakor_spawn_data.x = 326
				belakor_spawn_data.y = 571
			end

			cm:force_declare_war("wh2_main_nor_harbingers_of_doom", "wh2_main_nor_albion", false, false)
		else
			cm:transfer_region_to_faction("wh_main_helspire_mountains_serpent_jetty", "wh2_main_nor_harbingers_of_doom")
			cm:transfer_region_to_faction("wh_main_the_wasteland_aarnau", "wh2_main_nor_harbingers_of_doom")

			local serpent_region = cm:model():world():region_manager():region_by_key("wh_main_helspire_mountains_serpent_jetty")
			cm:instantly_set_settlement_primary_slot_level(serpent_region:settlement(), 2)

			cm:heal_garrison(serpent_region:cqi())
			cm:heal_garrison(cm:get_region("wh_main_the_wasteland_aarnau"):cqi())
		end

		local faction_key = "wh2_main_nor_harbingers_of_doom" -- factions key

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"wh_pro04_nor_mon_marauder_warwolves_ror_0",
			"ovn_killing_eye",
			"wh_pro04_nor_mon_fimir_ror_0",
			"ovn_gharnus_demon",
			"ovn_finmor_belakor",
            "ovn_daemonomaniac_ror",
            "ovn_marsh_hornets_ror",
            "ovn_moor_hounds_ror"
		}

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				tree,
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

		table.insert(factions, faction_key)
	end
end

--------------------------------------------------------------
------------------------- ALBION  ----------------------------
--------------------------------------------------------------

local function albion_setup()
	local albion = cm:get_faction("wh2_main_nor_albion")
	local albion_faction_leader_cqi = albion:faction_leader():command_queue_index()

	add_cqi_to_murdered_list(albion_faction_leader_cqi)

	local harbingers_of_doom = cm:get_faction("wh2_main_nor_harbingers_of_doom")

	if albion and (albion:is_human() or not mct or settings_table.albion and settings_table.enable) then
		cm:transfer_region_to_faction("wh2_main_albion_albion", "wh2_main_nor_albion")
		cm:heal_garrison(cm:get_region("wh2_main_albion_albion"):cqi())

		cm:force_religion_factors("wh2_main_albion_albion", "wh_main_religion_untainted", 0.75, "wh_main_religion_chaos", 0.25)
		cm:force_diplomacy("faction:wh2_main_nor_albion", "all", "all", true, true, true)

		cm:force_diplomacy("faction:wh2_main_nor_albion", "culture:wh2_main_hef_high_elves", "vassal", false, false, true);

		-- if Be'lakor isn't played by human Vanaheimling start at Citadel of Lead
		if not harbingers_of_doom or not harbingers_of_doom:is_human() then
			local vanaheimlings = cm:get_faction("wh_dlc08_nor_vanaheimlings")
			local vanaheimlings_leader = vanaheimlings and vanaheimlings:faction_leader()
			if vanaheimlings_leader then
				local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement("wh_dlc08_nor_vanaheimlings", "wh2_main_albion_citadel_of_lead", false, true, 1)
				if pos_x ~= -1 then
					cm:teleport_to(cm:char_lookup_str(vanaheimlings_leader), pos_x, pos_y, true)
				end
			end
		else
			-- human Be'lakor start at Citadel of Lead so kill all the Vanaheimling characters on Albion
			local vanaheimlings = cm:get_faction("wh_dlc08_nor_vanaheimlings")
			if vanaheimlings then
				for char in binding_iter(vanaheimlings:character_list()) do
					add_cqi_to_murdered_list(char:command_queue_index())
				end
			end
		end

		cm:force_declare_war("wh2_twa03_def_rakarth", "wh2_main_nor_albion", false, false)

		local is_durak_starting_lord = core:svr_load_bool("ovn_albion_dural_durak_is_leader")

		if not albion:is_human() then
			is_durak_starting_lord = cm:random_number(2) == 1

			if is_durak_starting_lord then
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
		end

		local subtype = "bl_elo_dural_durak"
		local forename = "names_name_77777202"
		local surname = "names_name_77777201"
		local starting_army = "elo_youngbloods,albion_centaurs,albion_giant,elo_albion_warriors,albion_hearthguard,druid_neophytes"

		if not is_durak_starting_lord then
			subtype = "albion_morrigan"
			forename = "names_name_77777001"
			surname = "names_name_77777002"
			starting_army = "elo_youngbloods,albion_giant,albion_swordmaiden,elo_albion_warriors,albion_hearthguard,albion_riders_spear"
		end

		local x = 317
		local y = 548

		-- Be'lakor starts in the north Albion settlement, so make the ALbion LL his turn 1 fight
		local human_factions = cm:get_human_factions()
		if table_contains(human_factions, "wh2_main_nor_harbingers_of_doom") then
			x = 330
			y = 566
		end

		-- if Albion is human make the Rakarth fight easier for him
		if albion:is_human() then
			starting_army = starting_army..",elo_albion_warriors,elo_bloodhounds"
		end

		cm:create_force_with_general(
			"wh2_main_nor_albion",
			starting_army,
			"wh2_main_great_desert_of_araby_el-kalabad",
			x,
			y,
			"general",
			subtype,
			forename,
			"",
			surname,
			"",
			true,
			function(cqi)
				local char_lookup_str = "character_cqi:" .. cqi
				cm:set_character_immortality(char_lookup_str, true)
				cm:set_character_unique(char_lookup_str, true)
			end
		)

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"albion_shieldmaiden_ror",
			"albion_bologs_giant_ror",
			"elo_fly_infested_rotwood",
			"albion_woadraider_sworn_ror",
			"alb_cav_noble_first_ror",
			"albion_warriors_lugh",
			"albion_huntresses_warden_ror",
			"albion_centaur_hunter_ror",
			"albion_cachtorr_stonethrower",
			"albion_highlander_ror"
		}

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				albion,
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

		table.insert(factions, "wh2_main_nor_albion")
	end
end
--------------------------------------------------------------
-------------------------- FIMIR  ----------------------------
--------------------------------------------------------------

local function fimir_setup()
	local fimir = cm:get_faction("wh2_main_nor_servants_of_fimulneid")

	local fimir_faction_leader = fimir:faction_leader()
	if fimir_faction_leader and not fimir_faction_leader:is_null_interface() then
		local fimir_faction_leader_cqi = fimir_faction_leader:command_queue_index()
		add_cqi_to_murdered_list(fimir_faction_leader_cqi)
	end

	if fimir and (fimir:is_human() or not mct or settings_table.fimir and settings_table.enable) then
		cm:transfer_region_to_faction("wh2_main_marshes_of_madness_floating_village", "wh2_main_nor_servants_of_fimulneid")
		local floating_region = cm:get_region("wh2_main_marshes_of_madness_floating_village")
		cm:heal_garrison(floating_region:cqi())
		cm:instantly_set_settlement_primary_slot_level(floating_region:settlement(), 2)


		local faction_key = "wh2_main_nor_servants_of_fimulneid" -- factions key

		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"wh_pro04_nor_mon_marauder_warwolves_ror_0",
			"ovn_killing_eye",
			"wh_pro04_nor_mon_fimir_ror_0",
			"ovn_gharnus_demon",
            "ovn_daemonomaniac_ror",
            "ovn_marsh_hornets_ror",
            "ovn_moor_hounds_ror"
		}

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				fimir,
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

        if not fimir:is_human() then
            cm:transfer_region_to_faction("wh_main_mountains_of_naglfari_naglfari_plain", "wh2_main_nor_servants_of_fimulneid")
            local naglfari_region = cm:get_region("wh_main_mountains_of_naglfari_naglfari_plain")
            cm:heal_garrison(naglfari_region:cqi())
        end

		table.insert(factions, faction_key)
	end
end

--------------------------------------------------------------
-------------------- GRUDGEBRINGERS  -------------------------
--------------------------------------------------------------

local function grudgebringers_setup()
	local grudebringers_string = "wh2_main_emp_grudgebringers"
	local gru = cm:get_faction(grudebringers_string)

	local chars = gru:character_list()
	for i=0, chars:num_items()-1 do
		local char = chars:item_at(i)
		if char:character_subtype_key() == "teb_lord" then
			add_cqi_to_murdered_list(char:cqi())
		end
	end

	if gru and (gru:is_human() or not mct or settings_table.grudgebringers and settings_table.enable) then
		cm:treasury_mod("wh2_main_emp_grudgebringers", -2000)

		--ADD GRUDGEBRINGER RoR--

		--local unit_key = "chosen_asur_lions" -- String unit_record
		local unit_count = 1 -- card32 count
		local rcp = 20 -- float32 replenishment_chance_percentage
		local max_units = 1 -- int32 max_units
		local murpt = 0.1 -- float32 max_units_replenished_per_turn
		local xp_level = 0 -- card32 xp_level
		local frr = "" -- (may be empty) String faction_restricted_record
		local srr = "" -- (may be empty) String subculture_restricted_record
		local trr = "" -- (may be empty) String tech_restricted_record
		local units = {
			"ragnar_wolves",
			"grudgebringer_infantry",
			"grudgebringer_cannon",
			"grudgebringer_crossbow",
			"treeman_gnarl_fist",
			"urblab_rotgut_mercenary_ogres",
			"galed_elf_archers",
			"eusebio_flagellants"
		}

		cm:add_unit_to_faction_mercenary_pool(
			gru,
			"wh2_dlc13_emp_cav_pistoliers_1_imperial_supply",
			1,
			0,
			5,
			0,
			xp_level,
			frr,
			srr,
			trr,
			true
		)

		for _, unit in ipairs(units) do
			cm:add_unit_to_faction_mercenary_pool(
				gru,
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

		cm:force_grant_military_access("wh_main_emp_empire", "wh2_main_emp_grudgebringers", false)
		cm:force_grant_military_access("wh2_main_emp_grudgebringers", "wh_main_brt_bretonnia", true)
		cm:force_grant_military_access("wh2_main_emp_grudgebringers", "wh_main_brt_carcassonne", false)
		cm:force_grant_military_access("wh_main_brt_bordeleaux", "wh2_main_emp_grudgebringers", true)

		table.insert(factions, grudebringers_string)
	end
end

--------------------------------------------------------------
----------------------- DREAD KING  --------------------------
--------------------------------------------------------------
--- Disable undead units if the faction is disabled with MCT
local undead_dread_king_units = {
	["ovn_dkl_mon_skeleton_giant"] = true,
	["wh2_dlc09_tmb_mon_fell_bats"] = true,
	["wh2_dlc09_tmb_mon_dire_wolves"] = true,
	["wh_main_vmp_mon_crypt_horrors"] = true,
	["wh_main_vmp_inf_grave_guard_0"] = true,
	["elo_dread_inf_grave_guard_0"] = true,
	["wh2_dlc09_tmb_inf_crypt_ghouls"] = true,
	["black_grail_knights_tmb"] = true,
	["elo_tomb_guardian"] = true,
	["elo_tomb_guardian_2h_waepons"] = true,
	["elo_tomb_guardian_spears"] = true,
	["elo_tomb_guardian_archers"] = true,
}

local function dreadking_setup()
	local dread_king = cm:get_faction("wh2_dlc09_tmb_the_sentinels")
	local dread_king_faction_leader_cqi = dread_king:faction_leader():command_queue_index()

	if dread_king and (dread_king:is_human() or not mct or settings_table.dreadking and settings_table.enable) then
		cm:change_custom_faction_name("wh2_dlc09_tmb_the_sentinels", effect.get_localised_string("ovn_dread_king_legions_faction_name"))
		cm:force_add_trait(cm:char_lookup_str(dread_king_faction_leader_cqi), "dk_trait_name_dummy", false)

		add_cqi_to_murdered_list(dread_king_faction_leader_cqi)

		--- Give a diplo bonus with Arkhan.
		local custom_bundle = cm:create_new_custom_effect_bundle("ovn_tomb_king_diplo_hidden")
		custom_bundle:add_effect("ovn_diplo_bonus_with_arkhan", "faction_to_faction_own_unseen", 150)
		cm:apply_custom_effect_bundle_to_faction(custom_bundle, dread_king)

		cm:create_agent(
			"wh2_dlc09_tmb_the_sentinels",
			"wizard",
			"elo_dread_larenscheld",
			590,
			90,
			false,
			function(cqi)
				cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_gunther", false)
				cm:replenish_action_points(cm:char_lookup_str(cqi))
				cm:add_unit_model_overrides("faction:wh2_dlc09_tmb_the_sentinels,type:wizard", "elo_dread_larenscheld")
			end
		)

		local pyramid_region = cm:get_region("wh2_main_great_mortis_delta_black_pyramid_of_nagash")
		cm:region_slot_instantly_dismantle_building(pyramid_region:settlement():active_secondary_slots():item_at(0))

		if dread_king:is_human() then
			cm:teleport_to("faction:wh2_dlc09_rogue_eyes_of_the_jungle", 157, 20, true)
		end

		table.insert(factions, "wh2_dlc09_tmb_the_sentinels")
	else
		for unit_key, _ in pairs(undead_dread_king_units) do
			cm:add_event_restricted_unit_record_for_faction(unit_key, "wh2_dlc09_tmb_the_sentinels")
		end

		cm:force_change_cai_faction_personality("wh2_dlc09_tmb_the_sentinels", "wh2_dlc09_tmb_the_sentinels")
	end
end

local faction_key_to_how_they_play_data = {
	wh2_main_ovn_chaos_dwarfs = {
		loc = "ovn_how_they_play_chorfs",
		image_id = 2508,
	},
	wh2_main_nor_rotbloods = {
		loc = "ovn_how_they_play_rotbloods",
		image_id = 2509,
	},
	wh2_main_nor_albion = {
		loc = "ovn_how_they_play_albion",
		image_id = 2506,
	},
	wh2_main_emp_the_moot = {
		loc = "ovn_how_they_play_hlf",
		image_id = 2507,
	},
}
local function show_how_they_play_event()
	local local_faction_key = cm:get_local_faction_name()
	local data = faction_key_to_how_they_play_data[local_faction_key]
	if not data then return end

	local loc_prefix = "event_feed_strings_text_ovn_comradeship_spawned_"
	cm:show_message_event(
		local_faction_key,
		"event_feed_strings_text_wh2_scripted_event_how_they_play_title",
		"factions_screen_name_"..local_faction_key,
		data.loc,
		true,
		data.image_id
	)
end

local mct_options_list = {
	"enable",
	"amazon",
	"araby",
	"blood_dragon",
	"citadel",
	"halflings",
	"trollz",
	"treeblood",
	"albion",
	"fimir",
	"grudgebringers",
	"dreadking"
} --:vector<string>

local function new_game_startup()
	if mct then
		local lost_factions_mod = mct:get_mod_by_key("lost_factions")
		settings_table = lost_factions_mod:get_settings()
		-- lock mct options
		for i = 1, #mct_options_list do
			local option = lost_factions_mod:get_option_by_key(mct_options_list[i])
			option:set_read_only(true)
		end
	end
	-- turn off event feeds
	cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_faction", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_provinces", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_world", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_military", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "")
	cm:disable_event_feed_events(true, "", "", "character_trait_lost")
	cm:disable_event_feed_events(true, "", "", "character_ancillary_lost")
	cm:disable_event_feed_events(true, "", "", "character_wounded")
	cm:disable_event_feed_events(true, "", "", "character_dies_in_action")
	cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed")
	cm:disable_event_feed_events(true, "", "", "diplomacy_trespassing")
	cm:disable_event_feed_events(true, "", "", "faction_resource_lost")
	cm:disable_event_feed_events(true, "", "", "faction_resource_gained")
	cm:disable_event_feed_events(true, "", "", "conquest_province_secured")

	local grudebringers_string = "wh2_main_emp_grudgebringers"
	local gru = cm:get_faction(grudebringers_string)
	if gru and (gru:is_human() or not mct or settings_table.grudgebringers and settings_table.enable) then
		spawn_new_force(grudgebringers)
	end

	local blood_dragons = cm:get_faction("wh2_main_vmp_blood_dragons")
	if blood_dragons and (blood_dragons:is_human() or not mct or settings_table.blood_dragon and settings_table.enable) then
		cm:transfer_region_to_faction("wh_main_southern_grey_mountains_karak_norn", "wh2_main_vmp_blood_dragons")
	end

	local start_functions_names = {
		"apply_diplo_bonuses",
		"amazon_setup",
		"araby_diplomacy_setup",
		"araby_caliphate_setup",
		"araby_scythans_setup",
		"araby_scimitar_setup",
		"citadel_setup",
		"halflings_setup",
		"trollz_setup",
		"treeblood_setup",
		"albion_setup",
		"fimir_setup",
		"grudgebringers_setup",
		"dreadking_setup",
		"new_ovn_sr_chaos",
		"blood_dragon_setup",
		"kill_people",
		"spawn_new_forces",
	}

	local start_functions = {
		apply_diplo_bonuses,
		amazon_setup,
		araby_diplomacy_setup,
		araby_caliphate_setup,
		araby_scythans_setup,
		araby_scimitar_setup,
		citadel_setup,
		halflings_setup,
		trollz_setup,
		treeblood_setup,
		albion_setup,
		fimir_setup,
		grudgebringers_setup,
		dreadking_setup,
		new_ovn_sr_chaos,
		blood_dragon_setup,
		-- kill all of the faction leaders that have to go
		kill_people,
		-- spawn new forces for all da factions
		spawn_new_forces,
	}

	-- stagger startup logic accross ticks
	local start_functions_index = 1
	local function stagger_functions()
			local next_start_function = start_functions[start_functions_index]
			local next_start_function_name = start_functions_names[start_functions_index]
			if not next_start_function then
				return
			end

			start_functions_index = start_functions_index + 1
			cm:callback(stagger_functions, 0)
			local start_timestamp = os.clock();

			next_start_function()

			local calltime = os.clock() - start_timestamp;
			out("OVN START FUNCTION "..next_start_function_name.." TOOK "..tostring(calltime))
	end

	cm:callback(stagger_functions, 1.5)

	-- turn on event feeds
	cm:callback(
		function()
			cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_faction", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_provinces", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_world", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_military", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
			cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "")
			cm:disable_event_feed_events(false, "", "", "character_trait_lost")
			cm:disable_event_feed_events(false, "", "", "character_ancillary_lost")
			cm:disable_event_feed_events(false, "", "", "character_wounded")
			cm:disable_event_feed_events(false, "", "", "character_dies_in_action")
			cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed")
			cm:disable_event_feed_events(false, "", "", "diplomacy_trespassing")
			cm:disable_event_feed_events(false, "", "", "faction_resource_lost")
			cm:disable_event_feed_events(false, "", "", "faction_resource_gained")
			cm:disable_event_feed_events(false, "", "", "conquest_province_secured")

			show_how_they_play_event()
		end,
		7
	)
end

cm:add_first_tick_callback(
	function()
		if cm:is_new_game() then
			if cm:model():campaign_name("main_warhammer") then
				local ok, err =
					pcall(
					function()
						new_game_startup()
					end
				)
				if not ok then
					script_error(err)
				end
			end
		end
	end
)
