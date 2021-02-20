OVN_HLF_MISSIONS = OVN_HLF_MISSIONS or {}
local mod = OVN_HLF_MISSIONS

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

---@return CA_UIC
local function find_ui_component_str(starting_comp, str)
	local has_starting_comp = str ~= nil
	if not has_starting_comp then
		str = starting_comp
	end
	local fields = {}
	local pattern = string.format("([^%s]+)", " > ")
	string.gsub(str, pattern, function(c)
		if c ~= "root" then
			fields[#fields+1] = c
		end
	end)
	return find_uicomponent(has_starting_comp and starting_comp or core:get_ui_root(), unpack(fields))
end

local halfling_faction_name = "wh2_main_emp_the_moot"

core:remove_listener('ovn_hlf_missions_on_event_opened')
core:add_listener(
	'ovn_hlf_missions_on_event_opened',
	'ComponentLClickUp',
	function(context)
		return context.string == "pj_mission_obj_button" -- RENAME THIS
	end,
	function(context)
		local title = find_ui_component_str("root > events > event_mission > quest_details > quest_list_details > tab_details_child > objectives > dy_title")
		if not title then
			title = find_ui_component_str("root > quest_details > quest_list_details > tab_details_child > objectives > dy_title")
		end
		if not title then return end

		local title_text = title:GetStateText()
		local mission_key = mod.title_string_to_mission_key[title_text]
		if not mission_key then return end

		mod.mission_key_to_extend = mission_key
		mod.region_key_for_extension = mod.mission_key_to_force_cqi[mission_key]
		cm:complete_scripted_mission_objective(mission_key, mission_key, false)

		local tab_events = find_ui_component_str("root > layout > bar_small_top > TabGroup > tab_events")
		if tab_events then
			tab_events:SimulateLClick()
		end
	end,
	true
)

core:remove_listener("ovn_hlf_missions_real_repeat_cb")
core:add_listener(
	"ovn_hlf_missions_real_repeat_cb",
	"RealTimeTrigger",
	function(context)
			return context.string == "ovn_hlf_missions_real_repeat"
	end,
	function()
		local quest_list_details = find_ui_component_str("root > events > event_mission > quest_details > quest_list_details")
		if not quest_list_details then
			quest_list_details = find_ui_component_str("root > quest_details > quest_list_details")
		end
		if not quest_list_details then
			return
		end

		local title = find_ui_component_str(quest_list_details, "tab_details_child > objectives > dy_title")
		if not title then return end

		local title_text = title:GetStateText()
		local mission_key = mod.title_string_to_mission_key[title_text]
		if not mission_key then return end

		local events = find_ui_component_str(quest_list_details, "tab_details_child > objectives > objective > dy_objective")
		events:SetStateText(effect.get_localised_string("ovn_hlf_missions_"..tostring(mod.mission_key_to_force_type[mission_key]).."_units"))

		local stamp_complete = find_ui_component_str(quest_list_details, "stamp_complete")
		if not stamp_complete or stamp_complete:Visible() then return end
		local stamp_failed = find_ui_component_str(quest_list_details, "stamp_failed")
		if not stamp_failed or stamp_failed:Visible() then return end

		local accept_holder = find_ui_component_str("root > events > button_set > accept_holder")
		if accept_holder and accept_holder:Visible() then return end

		local obj = find_ui_component_str(quest_list_details, "tab_details_child > objectives > objective")
		local target_window = find_ui_component_str(obj, "target_window")
		local pj_mission_obj_button = find_ui_component_str(obj, "target_window > pj_mission_obj_button")
		if not pj_mission_obj_button then
			pj_mission_obj_button = UIComponent(target_window:CreateComponent("pj_mission_obj_button", "ui/templates/round_small_button"))
			pj_mission_obj_button:SetTooltipText(effect.get_localised_string("ovn_hlf_missions_extend_mission"), true)
			pj_mission_obj_button:SetImagePath(effect.get_skinned_image_path("icon_check.png"), 0)
		end
		pj_mission_obj_button:SetDockingPoint(1)
		pj_mission_obj_button:SetDockOffset(185,25)
	end,
	true
)

core:remove_listener("ovn_hlf_missions_on_MissionF11ailed")
core:add_listener(
	"ovn_hlf_missions_on_MissionF11ailed",
	"ForceAdoptsStance",
	function(context)
		return true
	end,
	function(context)
		if cm:whose_turn_is_it() ~= "wh2_main_emp_the_moot" then return end

		---@type CA_MILITARY_FORCE
		local mf = context:military_force()

		if mf:faction():name() ~= "wh2_main_emp_the_moot" then return end

		local region = mf:general_character():region()
		if not region or region:is_null_interface() then return end

		local region_key = region:name()
		local valid_mission_key = nil
		for mission_key, mission_region_key in pairs(mod.mission_key_to_force_cqi) do
			if mission_region_key == region_key then
				valid_mission_key = mission_key
			end
		end

		if not valid_mission_key then
			return
		end

		local force_type = mod.mission_key_to_force_type[valid_mission_key]
		if not force_type then return end

		local num_max_units_in_force = mod.force_type_to_max_units[force_type]
		if not num_max_units_in_force then return end

		if num_max_units_in_force < mf:unit_list():num_items() then
			cm:trigger_incident("wh2_main_emp_the_moot", "ovn_hlf_missions_army_too_big", true)
			return
		end

		local active_stance = mf:active_stance()
		if active_stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP" then
			local continent = mod.region_to_continent_lookup[region_key]
			if not continent then return end

			local factions = mod.continent_to_factions[continent]
			if not factions then return end

			cm:set_saved_value("ovn_hlf_missions_current_continent", continent)

			local faction_key = factions[cm:random_number(#factions)]
			if not faction_key then return end

			cm:complete_scripted_mission_objective(valid_mission_key, valid_mission_key, true)

			local uim = cm:get_campaign_ui_manager();
			uim:override("retreat"):lock();

			mod.trigger_battle(faction_key, mf, num_max_units_in_force-1)
		end
	end,
	true
);

mod.get_attacking_force_power = function()
	local turn_number = cm:turn_number()
	local turn_mod = 0

	turn_mod = math.floor(turn_number/10) + 1

	local difficulty = cm:get_difficulty()

	local difficulty_mod = 1
	if difficulty < 2 then
		difficulty_mod = 0
	elseif difficulty >= 3 then
		difficulty_mod = 2
	end

	return turn_mod + difficulty_mod
end

---@param faction_key string
---@param military_force CA_MILITARY_FORCE
mod.trigger_battle = function(faction_key, military_force, units_in_force_to_fight)
	local subculture = mod.faction_to_subculture[faction_key]
	if not subculture then return end

	local power = mod.get_attacking_force_power()

	cm:set_saved_value("ovn_hlf_missions_player_force_cqi", military_force:command_queue_index())
	Forced_Battle_Manager:trigger_forced_battle_against_generated_ai_army(
		military_force:command_queue_index(),
		faction_key,
		subculture,
		units_in_force_to_fight,
		power,
		true,
		true,
		false,
		nil,
		nil,
		nil,
		power,
		nil
		)
end

mod.continent_to_factions = {
	["dark_lands"] = {"wh2_main_skv_skaven_qb4", "wh_main_grn_greenskins_qb4"},
	["lustria"] = {"wh2_main_lzd_lizardmen_qb3", "wh2_dlc11_cst_vampire_coast_qb4"},
	["naggaroth"] = {"wh2_main_def_dark_elves_qb4"},
	["norsca"] = {"wh2_dlc11_nor_norsca_qb4", "wh2_dlc16_chs_acolytes_of_the_keeper"},
	["old_world"] = {"wh_main_emp_empire_separatists", "wh2_dlc13_bst_beastmen_invasion"},
	["southlands"] = {"wh2_dlc09_tmb_tombking_qb_followers_of_nagash"},
	["ulthuan"] = {"wh2_main_hef_high_elves_qb3"},
}

mod.faction_to_subculture = {
	["wh2_main_hef_high_elves_qb3"] = "wh2_main_sc_hef_high_elves",
	["wh2_dlc09_tmb_tombking_qb_followers_of_nagash"] = "wh2_dlc09_sc_tmb_tomb_kings",
	["wh2_dlc13_bst_beastmen_invasion"] = "wh_dlc03_sc_bst_beastmen",
	["wh_main_emp_empire_separatists"] = "wh_main_sc_emp_empire",
	["wh2_dlc16_chs_acolytes_of_the_keeper"] = "wh_main_sc_chs_chaos",
	["wh2_dlc11_nor_norsca_qb4"] = "wh_main_sc_nor_norsca",
	["wh2_main_def_dark_elves_qb4"] = "wh2_main_sc_def_dark_elves",
	["wh2_dlc11_cst_vampire_coast_qb4"] = "wh2_dlc11_sc_cst_vampire_coast",
	["wh2_main_lzd_lizardmen_qb3"] = "wh2_main_sc_lzd_lizardmen",
	["wh_main_grn_greenskins_qb4"] = "wh_main_sc_grn_greenskins",
	["wh2_main_skv_skaven_qb4"] = "wh2_main_sc_skv_skaven",
}

--- fixing a bug with battle_location_x not getting assigned inside this function
function forced_battle:trigger_battle(attacker_force, target_force, opt_target_x, opt_target_y, opt_is_ambush)
	self.target = {}
	self.attacker = {}

	--set up the defender first
	---if a number is given, we assume it's a cqi
	if is_number(target_force) then
		local target_force_interface = cm:model():military_force_for_command_queue_index(target_force)
		if target_force_interface:is_null_interface() then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle "..self.key.." with an invalid attacker CQI!")
			return false
		end
		self.target.cqi = target_force
		self.target.interface = target_force_interface
		self.target.is_existing = true
		self.target.faction_interface = target_force_interface:faction()
	---if a key is given, then we try and generate a force from the stored forces
	elseif is_string(target_force) then
		if self.force_list[target_force] == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with a generated force, but cannot find force with key "..target_force..". Has it been defined yet?")
			return false
		end

		if opt_target_x == nil or opt_target_y == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with generated defender "..target_force..", but we haven't been given x/y coords")
			return false
		end

		self.battle_location_x = opt_target_x
		self.battle_location_y = opt_target_y
		self.target.force_key = target_force
		self.target.is_existing = false
		self.target.destroy_after_battle = self.force_list[target_force].destroy_after_battle
		self.target.faction_interface = cm:get_faction(self.force_list[target_force].faction_key)
	end

	---now do all the same with the attacker
	if is_number(attacker_force) then
		local attacker_force_interface = cm:model():military_force_for_command_queue_index(attacker_force)
		if attacker_force_interface:is_null_interface() then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle "..self.key.." with an invalid attacker CQI!")
			return false
		end
		self.attacker.cqi = attacker_force
		self.attacker.interface = attacker_force_interface
		self.attacker.is_existing = true
		self.attacker.faction_interface = attacker_force_interface:faction()
	elseif is_string(attacker_force) then
		if self.force_list[attacker_force] == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with a generated force, but cannot find force with key "..attacker_force..". Has it been defined yet?")
			return false
		end

		if opt_target_x == nil or opt_target_y == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with generated attacker "..attacker_force..", but we haven't been given x/y coords")
			return false
		end
		self.battle_location_x = opt_target_x
		self.battle_location_y = opt_target_y
		self.attacker.force_key = attacker_force
		self.attacker.is_existing  = false
		self.attacker.destroy_after_battle = self.force_list[attacker_force].destroy_after_battle
		self.attacker.faction_interface = cm:get_faction(self.force_list[attacker_force].faction_key)
	end

	self.is_ambush = opt_is_ambush or false

	if not self.attacker.is_existing then
		self:spawn_generated_force(self.attacker.force_key, self.battle_location_x, self.battle_location_y )
	end

	if not self.target.is_existing then
		self:spawn_generated_force(self.target.force_key, self.battle_location_x, self.battle_location_y )
	end

	Forced_Battle_Manager.active_battle = self.key
	Forced_Battle_Manager:setup_battle_completion_listener()
end

mod.ingredients_by_continent = {
	["old_world"] = { "ovn_spelt", "ovn_beef", "ovn_fennel", "ovn_lettuce", "ovn_apple" },
	["norsca"] = { "ovn_rye", "ovn_salmon", "ovn_juniper", "ovn_kale", "ovn_lingonberry" },
	["southlands"] = { "ovn_teff", "ovn_lamb", "ovn_cumin", "ovn_lentil", "ovn_date" },
	["ulthuan"] = { "ovn_emmer", "ovn_calamari", "ovn_marjoram", "ovn_olive", "ovn_pomegranate" },
	["dark_lands"] = { "ovn_rice", "ovn_pork", "ovn_cardamom", "ovn_onion", "ovn_walnut" },
	["lustria"] = { "ovn_maize", "ovn_iguana", "ovn_vanilla", "ovn_tomatoe", "ovn_pitaya" },
	["naggaroth"] = { "ovn_barley", "ovn_turkey", "ovn_pepper", "ovn_potatoe", "ovn_cranberry" },
}

mod.unlock_ingredient = function()
	local moot_faction = cm:get_faction("wh2_main_emp_the_moot")
	if not moot_faction or moot_faction:is_null_interface() then return end

	local continent = cm:get_saved_value("ovn_hlf_missions_current_continent")
	if not continent then return end

	local ingredients_in_continent = mod.ingredients_by_continent[continent]

	local valid_ingredient_choices = {}
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(moot_faction)
	for _, ingredient in ipairs(ingredients_in_continent) do
		if not cooking_interface:is_ingredient_unlocked(ingredient) then
			table.insert(valid_ingredient_choices, ingredient)
		end
	end

	if #valid_ingredient_choices == 0 then return end

	local chosen_ingredient = valid_ingredient_choices[cm:random_number(#valid_ingredient_choices)]
	cm:unlock_cooking_ingredient(moot_faction, chosen_ingredient);
	cm:trigger_incident("wh2_main_emp_the_moot", "ovn_hlf_missions_ingredient_unlocked", true)
end

core:remove_listener("ovn_hlf_missions_on_battle_completed_cb")
core:add_listener(
	"ovn_hlf_missions_on_battle_completed_cb",
	"BattleCompleted",
	true,
	function()
		local player_force_cqi = cm:get_saved_value("ovn_hlf_missions_player_force_cqi")
		if not player_force_cqi then return end
		player_force_cqi = tonumber(player_force_cqi)

		local uim = cm:get_campaign_ui_manager();
		uim:override("retreat"):unlock();

		if not cm:model():pending_battle():has_been_fought() then
			cm:set_saved_value("ovn_hlf_missions_player_force_cqi", false)
			return
		end

		local is_winner_attacker = cm:pending_battle_cache_attacker_victory()

		if is_winner_attacker then
			if cm:pending_battle_cache_num_attackers() >= 1 then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local _, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
					if faction_name == "wh2_main_emp_the_moot" and mf_cqi == player_force_cqi then
						mod.unlock_ingredient()
						break
					end
				end
			end
		else
			if cm:pending_battle_cache_num_defenders() >= 1 then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local _, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
					if faction_name == "wh2_main_emp_the_moot" and mf_cqi == player_force_cqi then
						mod.unlock_ingredient()
						break
					end
				end
			end
		end

		cm:set_saved_value("ovn_hlf_missions_player_force_cqi", false)
	end,
	true
)

-- table matching province to their continent (not a science)
-- this is just for Mortal Empires, btw
local province_continent_lookup = {
	--dark lands + silver road
  ["wh2_main_dragon_isles"] = "dark_lands",
	["wh2_main_gnoblar_country"] = "dark_lands",
	["wh2_main_the_broken_teeth"] = "dark_lands",
	["wh2_main_the_plain_of_bones"] = "dark_lands",
	["wh2_main_the_wolf_lands"] = "dark_lands",
	["wh_main_death_pass"] = "dark_lands",
	["wh_main_desolation_of_nagash"] = "dark_lands",
	["wh_main_eastern_badlands"] = "dark_lands",
	["wh_main_the_silver_road"] = "dark_lands",
	--lustria
	["wh2_main_headhunters_jungle"] = "lustria",
	["wh2_main_huahuan_desert"] = "lustria",
	["wh2_main_isthmus_of_lustria"] = "lustria",
	["wh2_main_jungles_of_green_mists"] = "lustria",
	["wh2_main_northern_great_jungle"] = "lustria",
	["wh2_main_northern_jungle_of_pahualaxa"] = "lustria",
	["wh2_main_southern_great_jungle"] = "lustria",
	["wh2_main_southern_jungle_of_pahualaxa"] = "lustria",
	["wh2_main_spine_of_sotek"] = "lustria",
	["wh2_main_the_creeping_jungle"] = "lustria",
	["wh2_main_vampire_coast"] = "lustria",
	["wh2_main_volcanic_islands"] = "lustria",
	--naggaroth
	["wh2_main_aghol_wastelands"] = "naggaroth",
	["wh2_main_blackspine_mountains"] = "naggaroth",
	["wh2_main_deadwood"] = "naggaroth",
	["wh2_main_doom_glades"] = "naggaroth",
	["wh2_main_iron_mountains"] = "naggaroth",
	["wh2_main_ironfrost_glacier"] = "naggaroth",
	["wh2_main_obsidian_peaks"] = "naggaroth",
	["wh2_main_the_black_coast"] = "naggaroth",
	["wh2_main_the_black_flood"] = "naggaroth",
	["wh2_main_the_broken_land"] = "naggaroth",
	["wh2_main_the_chill_road"] = "naggaroth",
	["wh2_main_the_clawed_coast"] = "naggaroth",
	["wh2_main_the_road_of_skulls"] = "naggaroth",
	["wh2_main_titan_peaks"] = "naggaroth",
	--norsca
	["wh2_main_albion"] = "norsca",
	["wh2_main_hell_pit"] = "norsca",
	["wh_main_gianthome_mountains"] = "norsca",
	["wh_main_goromadny_mountains"] = "norsca",
	["wh_main_helspire_mountains"] = "norsca",
	["wh_main_ice_tooth_mountains"] = "norsca",
	["wh_main_mountains_of_hel"] = "norsca",
	["wh_main_mountains_of_naglfari"] = "norsca",
	["wh_main_trollheim_mountains"] = "norsca",
	["wh_main_vanaheim_mountains"] = "norsca",
	--empire/bretonnia/teb/some badlands
	["wh2_main_fort_bergbres"] = "old_world",
	["wh2_main_fort_helmgart"] = "old_world",
	["wh2_main_fort_soll"] = "old_world",
	["wh2_main_laurelorn_forest"] = "old_world",
	["wh2_main_misty_hills"] = "old_world",
	["wh2_main_sartosa"] = "old_world",
	["wh2_main_shifting_sands"] = "old_world",
	["wh2_main_skavenblight"] = "old_world",
	["wh2_main_solland"] = "old_world",
	["wh2_main_the_moot"] = "old_world",
	["wh_main_argwylon"] = "old_world",
	["wh_main_averland"] = "old_world",
	["wh_main_bastonne_et_montfort"] = "old_world",
	["wh_main_black_mountains"] = "old_world",
	["wh_main_blood_river_valley"] = "old_world",
	["wh_main_bordeleaux_et_aquitaine"] = "old_world",
	["wh_main_carcassone_et_brionne"] = "old_world",
	["wh_main_couronne_et_languille"] = "old_world",
	["wh_main_eastern_border_princes"] = "old_world",
	["wh_main_eastern_oblast"] = "old_world",
	["wh_main_eastern_sylvania"] = "old_world",
	["wh_main_estalia"] = "old_world",
	["wh_main_forest_of_arden"] = "old_world",
	["wh_main_hochland"] = "old_world",
	["wh_main_lyonesse"] = "old_world",
	["wh_main_massif_orcal"] = "old_world",
	["wh_main_middenland"] = "old_world",
	["wh_main_nordland"] = "old_world",
	["wh_main_northern_grey_mountains"] = "old_world",
	["wh_main_northern_oblast"] = "old_world",
	["wh_main_northern_worlds_edge_mountains"] = "old_world",
	["wh_main_ostermark"] = "old_world",
	["wh_main_ostland"] = "old_world",
	["wh_main_parravon_et_quenelles"] = "old_world",
	["wh_main_peak_pass"] = "old_world",
	["wh_main_reikland"] = "old_world",
	["wh_main_rib_peaks"] = "old_world",
	["wh_main_southern_grey_mountains"] = "old_world",
	["wh_main_southern_oblast"] = "old_world",
	["wh_main_stirland"] = "old_world",
	["wh_main_talabecland"] = "old_world",
	["wh_main_talsyn"] = "old_world",
	["wh_main_the_vaults"] = "old_world",
	["wh_main_the_wasteland"] = "old_world",
	["wh_main_tilea"] = "old_world",
	["wh_main_torgovann"] = "old_world",
	["wh_main_troll_country"] = "old_world",
	["wh_main_western_badlands"] = "old_world",
	["wh_main_western_border_princes"] = "old_world",
	["wh_main_western_sylvania"] = "old_world",
	["wh_main_wissenland"] = "old_world",
	["wh_main_wydrioth"] = "old_world",
	["wh_main_yn_edri_eternos"] = "old_world",
	["wh_main_zhufbar"] = "old_world",
	--southlands+some badlands
	["wh2_main_ash_river"] = "southlands",
	["wh2_main_atalan_mountains"] = "southlands",
	["wh2_main_charnel_valley"] = "southlands",
	["wh2_main_coast_of_araby"] = "southlands",
	["wh2_main_crater_of_the_walking_dead"] = "southlands",
	["wh2_main_devils_backbone"] = "southlands",
	["wh2_main_great_desert_of_araby"] = "southlands",
	["wh2_main_great_mortis_delta"] = "southlands",
	["wh2_main_heart_of_the_jungle"] = "southlands",
	["wh2_main_kingdom_of_beasts"] = "southlands",
	["wh2_main_land_of_assassins"] = "southlands",
	["wh2_main_land_of_the_dead"] = "southlands",
	["wh2_main_land_of_the_dervishes"] = "southlands",
	["wh2_main_marshes_of_madness"] = "southlands",
	["wh2_main_southlands_jungle"] = "southlands",
	["wh2_main_southlands_worlds_edge_mountains"] = "southlands",
	["wh_main_blightwater"] = "southlands",
	["wh_main_southern_badlands"] = "southlands",
	--ulthuan
	["wh2_main_avelorn"] = "ulthuan",
	["wh2_main_caledor"] = "ulthuan",
	["wh2_main_chrace"] = "ulthuan",
	["wh2_main_cothique"] = "ulthuan",
	["wh2_main_eagle_gate"] = "ulthuan",
	["wh2_main_eataine"] = "ulthuan",
	["wh2_main_ellyrion"] = "ulthuan",
	["wh2_main_griffon_gate"] = "ulthuan",
	["wh2_main_nagarythe"] = "ulthuan",
	["wh2_main_phoenix_gate"] = "ulthuan",
	["wh2_main_saphery"] = "ulthuan",
	["wh2_main_tiranoc"] = "ulthuan",
	["wh2_main_unicorn_gate"] = "ulthuan",
	["wh2_main_yvresse"] = "ulthuan",
	--added in twilight and twilight dlc
	["wh2_main_lustria_glade"] = "lustria",
	["wh2_main_old_world_glade"] = "old_world",
	["wh2_main_naggaroth_glade"] = "naggaroth",
	["wh2_main_badlands_glade"] = "old_world",
	["wh2_main_northern_dark_lands"] = "dark_lands",
	["wh2_main_southern_dark_lands"] = "dark_lands"
}

mod.region_to_continent_lookup = mod.region_to_continent_lookup or {}

mod.create_lookups = function()
	---@type CA_REGION
	for region in binding_iter(cm:model():world():region_manager():region_list()) do
		local continent = province_continent_lookup[region:province_name()]
		if continent then
			mod.region_to_continent_lookup[region:name()] = continent
		end
	end

	mod.continent_to_regions = {}
	for region, continent in pairs(mod.region_to_continent_lookup) do
		mod.continent_to_regions[continent] = mod.continent_to_regions[continent] or {}
		table.insert(mod.continent_to_regions[continent], region)
	end

	local continents_lookup = {}
	for continent, _ in pairs(mod.continent_to_regions) do
		continents_lookup[continent] = true
	end

	mod.continents = {}
	for continent, _ in pairs(continents_lookup) do
		table.insert(mod.continents, continent)
	end
	table.sort(mod.continents)

	mod.title_string_to_mission_key = {
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_1")] = "ovn_halfling_ingredient_quest_1",
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_2")] = "ovn_halfling_ingredient_quest_2",
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_3")] = "ovn_halfling_ingredient_quest_3",
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_4")] = "ovn_halfling_ingredient_quest_4",
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_5")] = "ovn_halfling_ingredient_quest_5",
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_6")] = "ovn_halfling_ingredient_quest_6",
		[effect.get_localised_string("missions_localised_title_ovn_halfling_ingredient_quest_7")] = "ovn_halfling_ingredient_quest_7",
	}
end

mod.mission_key_to_force_cqi = mod.mission_key_to_force_cqi or {}
mod.mission_key_to_force_type = mod.mission_key_to_force_type or {}

local function get_random_region_in_continent(continent, faction_key_to_exclude)
	local regions = {}

	if not faction_key_to_exclude then
		regions = mod.continent_to_regions[continent]
	else
		for _, region_key in ipairs(mod.continent_to_regions[continent]) do
			if not cm:is_region_owned_by_faction(region_key, faction_key_to_exclude) then
				table.insert(regions, region_key)
			end
		end
	end

	return regions[cm:random_number(#regions)]
end

local force_types = {
	"ten",
	"fifteen",
	"twenty",
}

local force_types_early_game = {
	"ten",
	"ten",
	"fifteen",
	"fifteen",
	"twenty",
}

mod.force_type_to_max_units = {
	["ten"] = 10,
	["fifteen"] = 15,
	["twenty"] = 20,
}

mod.give_new_targets = function()
	local faction_name = halfling_faction_name
	local halfling_faction = cm:get_faction(halfling_faction_name)
	if not halfling_faction or halfling_faction:is_null_interface() then return end

	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(halfling_faction)

	for i, continent in ipairs(mod.continents) do
		local region_key = get_random_region_in_continent(continent, faction_name)
		if not region_key then
			region_key = get_random_region_in_continent(continent)
		end

		local mission_key = "ovn_halfling_ingredient_quest_"..i

		local is_time_extension = false
		if mod.mission_key_to_extend and mission_key == mod.mission_key_to_extend and mod.region_key_for_extension then
			region_key = mod.region_key_for_extension
			mod.mission_key_to_extend = nil
			is_time_extension = true
		end

		local ingredients_in_continent = mod.ingredients_by_continent[continent]

		local valid_ingredient_choices = {}
		for _, ingredient in ipairs(ingredients_in_continent) do
			if not cooking_interface:is_ingredient_unlocked(ingredient) then
				table.insert(valid_ingredient_choices, ingredient)
			end
		end

		if not mod.mission_key_to_force_cqi[mission_key] and #valid_ingredient_choices > 0 then
		-- if true then

			local mission_time_limit = cm:random_number(22, 15)
			if is_time_extension then
				mission_time_limit = 20
			end

			local mission = [[
				mission
				{
						key ]]..mission_key..[[;
						issuer CLAN_ELDERS;
						turn_limit ]]..mission_time_limit..[[;
						primary_objectives_and_payload
						{
							objective
							{
								type SCRIPTED;
								script_key ]]..mission_key..[[;
							}
							objective
							{
								type MOVE_TO_REGION;
								region ]]..region_key..[[;
							}
							payload
							{
								effect_bundle{bundle_key ovn_hlf_missions_unlock_ingredient;turns 0;};
							};
					};
				};
			]]
			cm:trigger_custom_mission_from_string(halfling_faction_name, mission);

			mod.mission_key_to_force_cqi[mission_key] = region_key
			if not is_time_extension then
				if cm:turn_number() < 35 then
					mod.mission_key_to_force_type[mission_key] = force_types_early_game[cm:random_number(#force_types_early_game)]
				else
					mod.mission_key_to_force_type[mission_key] = force_types[cm:random_number(#force_types)]
				end
			end
		end
	end
end

cm:add_first_tick_callback(
	function()
		cm:callback(
			function()
				local halflings = cm:get_faction(halfling_faction_name)
				if not halflings or not halflings:is_human() then
					return
				end

				mod.create_lookups()
				mod.give_new_targets()

				real_timer.unregister("ovn_hlf_missions_real_repeat")
				real_timer.register_repeating("ovn_hlf_missions_real_repeat", 0)
			end,
			4
		)
	end
)

local function overwrite_mission(mission_key)
	if mod.mission_key_to_force_cqi[mission_key] then
		mod.mission_key_to_force_cqi[mission_key] = nil
		mod.give_new_targets()
	end
end

core:remove_listener("ovn_hlf_missions_on_MissionFailed")
core:add_listener(
	"ovn_hlf_missions_on_MissionFailed",
	"MissionFailed",
	function(context)
		return context:faction():name() == halfling_faction_name
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mod.mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

core:remove_listener("ovn_hlf_missions_on_MissionCancelled")
core:add_listener(
	"ovn_hlf_missions_on_MissionCancelled",
	"MissionCancelled",
	function(context)
		return context:faction():name() == halfling_faction_name
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mod.mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

core:remove_listener("ovn_hlf_missions_on_MissionSucceeded")
core:add_listener(
	"ovn_hlf_missions_on_MissionSucceeded",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == halfling_faction_name
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		local faction_key = context:faction():name()

		if mod.mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end

		cm:callback(
			function()
				local faction = cm:get_faction(faction_key)
				if not faction then return end
				if faction:has_effect_bundle("ovn_hlf_missions_unlock_ingredient") then
					cm:remove_effect_bundle("ovn_hlf_missions_unlock_ingredient", faction:name())
				end
			end,
			1
		)
	end,
	true
);

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ovn_hlf_missions_mission_key_to_force_cqi", mod.mission_key_to_force_cqi, context)
		cm:save_named_value("ovn_hlf_missions_mission_key_to_force_type", mod.mission_key_to_force_type, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mod.mission_key_to_force_cqi = cm:load_named_value("ovn_hlf_missions_mission_key_to_force_cqi", mod.mission_key_to_force_cqi, context)
		mod.mission_key_to_force_type = cm:load_named_value("ovn_hlf_missions_mission_key_to_force_type", mod.mission_key_to_force_type, context)
	end
)

--- We'll call first_tick_cb directly if hot-reloading during dev.
--- We're checking for presence of execute external lua file in the traceback.
if debug.traceback():find('pj_loadfile') then
	real_timer.unregister("ovn_hlf_missions_real_repeat")
	real_timer.register_repeating("ovn_hlf_missions_real_repeat", 0)
end

-- mod.give_new_targets()
