PJ_OVN_ROTBLOOD_WARPSTONE_MERCS = PJ_OVN_ROTBLOOD_WARPSTONE_MERCS or {}
local mod = PJ_OVN_ROTBLOOD_WARPSTONE_MERCS

mod.res_bundle_key = "pj_ovn_rotbloods_warpstone_mercs_res"

local rotblood_faction_key = "wh_dlc08_nor_naglfarlings"

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

mod.player_res = mod.player_res or
	{
		warpstone = 0,
	}

mod.player_res_per_turn = mod.player_res_per_turn or
{
	warpstone = 0,
}

mod.region_to_num_warpstone = {
	wh2_main_skavenblight_skavenblight = 15,
	wh_main_ostermark_mordheim = 15,
	wh2_main_hell_pit_hell_pit = 15,
}

mod.label_settlement_to_data = {
	["label_settlement:wh2_main_skavenblight_skavenblight"] = 15,
	["label_settlement:wh_main_ostermark_mordheim"] = 15,
	["label_settlement:wh2_main_hell_pit_hell_pit"] = 15,
}

mod.get_num_res_from_region_key = function(region_key, region_key_to_num_resource_lookup)
	return region_key_to_num_resource_lookup[region_key] or 0
end

mod.increase_resources = function(num_resources)
	local rotblood_faction = cm:get_faction(rotblood_faction_key)
	cm:pooled_resource_mod(rotblood_faction:command_queue_index(), "pj_rot_warpstone", "wh2_main_resource_factor_other", num_resources)
end

mod.increase_resources_networked = function(num_resources)
	local rotblood_faction = cm:get_faction(rotblood_faction_key)
	CampaignUI.TriggerCampaignScriptEvent(
		rotblood_faction:command_queue_index(),
		"pj_ovn_rotbloods_warpstone_mercs_resource_mod|"..tostring(num_resources)
	)

	mod.refresh_resource_value_in_ui()
end

core:remove_listener("pj_ovn_rotbloods_warpstone_mercs_resource_mod_trigger")
core:add_listener("pj_ovn_rotbloods_warpstone_mercs_resource_mod_trigger",
"UITrigger",
function(context)
    return context:trigger():starts_with("pj_ovn_rotbloods_warpstone_mercs_resource_mod|")
end,
function(context)
    local hash_without_prefix = context:trigger():gsub("pj_ovn_rotbloods_warpstone_mercs_resource_mod|", "")

    local args = {}
    hash_without_prefix:gsub("([^|]+)", function(w)
        if (type(w)=="string") then
            table.insert(args, w)
        end
    end)

	local num_resources = tonumber(args[1])
	local rotblood_faction = cm:get_faction(rotblood_faction_key)

	cm:pooled_resource_mod(rotblood_faction:command_queue_index(), "pj_rot_warpstone", "wh2_main_resource_factor_other", num_resources)
end,
true
)

---@param faction CA_FACTION
mod.calculate_per_turn_resources = function(faction)
	local warpstone = 0

	---@type CA_REGION
	for region in binding_iter(faction:region_list()) do
		local region_key = region:name()
		warpstone = warpstone + mod.get_num_res_from_region_key(region_key, mod.region_to_num_warpstone)
	end

	mod.player_res_per_turn.warpstone = warpstone
end

core:remove_listener("pj_ovn_rotbloods_warpstone_mercs_on_garrison_occupied")
core:add_listener(
	"pj_ovn_rotbloods_warpstone_mercs_on_garrison_occupied",
	"GarrisonOccupiedEvent",
	function()
		return true
	end,
	function(context)
		---@type CA_GARRISON_RESIDENCE
		local gr = context:garrison_residence()
		local faction = gr:faction()
		if faction:name() ~= rotblood_faction_key then return end

		local region = gr:region()
		local region_name = region:name()

		if not mod.region_to_num_warpstone[region_name] then return end

		mod.calculate_per_turn_resources(faction)
		mod.refresh_resource_value_in_ui()
	end,
	true
)

core:remove_listener('pj_ovn_rotbloods_warpstone_mercs_on_faction_turn_start')
core:add_listener(
	'pj_ovn_rotbloods_warpstone_mercs_on_faction_turn_start',
	'FactionTurnStart',
	function()
		return true
	end,
	function(context)
		---@type CA_FACTION
		local faction = context:faction()
		if not faction:is_human() then
			return
		end
		if faction:name() ~= rotblood_faction_key then return end

		mod.calculate_per_turn_resources(faction)

		local warpstone_res = faction:pooled_resource("pj_rot_warpstone")
		if not warpstone_res or warpstone_res:is_null_interface() then return end
		mod.player_res.warpstone = warpstone_res:value()

		mod.refresh_resource_value_in_ui()
	end,
	true
)

mod.refresh_resource_value_in_ui = function()
	local local_faction_obj = cm:get_faction(cm:get_local_faction_name(true))
	local warpstone_res = local_faction_obj:pooled_resource("pj_rot_warpstone")
	if not warpstone_res or warpstone_res:is_null_interface() then return end

	local prestige_effect = find_ui_component_str("root > layout > resources_bar > topbar_list_parent > warden_supply_holder > prestige_effect")
	if not prestige_effect then return end

	local prestige_text = find_uicomponent(prestige_effect, "prestige_text")
	if not prestige_text then return end

	local res_value = warpstone_res:value()

	prestige_text:SetStateText(res_value)

	mod.player_res.warpstone = res_value

	local localized_tooltip = "Warpstone"
	local stockpiled_localized_tooltip = effect.get_localised_string("effects_description_pj_ovn_rotbloods_warpstone_mercs_warpstone")
	localized_tooltip = localized_tooltip.."\n\n"
		..string.gsub(stockpiled_localized_tooltip, "%%n", mod.player_res["warpstone"])
	local stockpiled_localized_tooltip = effect.get_localised_string("effects_description_pj_ovn_rotbloods_warpstone_mercs_warpstone_per_turn")
	localized_tooltip = localized_tooltip.."\n"
		..string.gsub(stockpiled_localized_tooltip, "%%n", mod.player_res_per_turn["warpstone"])

	prestige_effect:SetTooltipText(localized_tooltip, true)
end

mod.init_ui = function()
	local wsh = find_ui_component_str("root > layout > resources_bar > topbar_list_parent > warden_supply_holder")
	wsh:SetVisible(true)

	local prestige_effect = find_ui_component_str(wsh, "prestige_effect")
	prestige_effect:SetTooltipText("Warpstone", true)

	local prestige_icon = find_ui_component_str(prestige_effect, "prestige_icon")
	prestige_icon:SetImagePath("ui/skins/warhammer2/pj_rot_warpstone.png", 0)

	local prestige_text = find_ui_component_str(prestige_effect, "prestige_text")
	prestige_text:SetStateText(0)
end

core:remove_listener('pj_ovn_rotbloods_warpstone_mercs_on_faction_turn_end')
core:add_listener(
	'pj_ovn_rotbloods_warpstone_mercs_on_faction_turn_end',
	'FactionTurnEnd',
	function()
		return true
	end,
	function(context)
		---@type CA_FACTION
		local faction = context:faction()
		if not faction:is_human() then
			return
		end
		if faction:name() ~= rotblood_faction_key then return end

		mod.calculate_per_turn_resources(faction)
		mod.increase_resources(mod.player_res_per_turn.warpstone)
		mod.refresh_resource_value_in_ui()
	end,
	true
)

cm:add_first_tick_callback(function()
	local local_faction_key = cm:get_local_faction_name(true)
	if local_faction_key ~= rotblood_faction_key then return end

	local faction = cm:get_faction(local_faction_key)

	mod.init_ui()
	mod.calculate_per_turn_resources(faction)
	mod.refresh_resource_value_in_ui()

	real_timer.unregister("pj_ovn_rotbloods_warpstone_mercs_campaign_ui_tweaks_real_timer")
	real_timer.register_repeating("pj_ovn_rotbloods_warpstone_mercs_campaign_ui_tweaks_real_timer", 0)
end)

if debug.traceback():find('pj_loadfile') then
	local local_faction_key = cm:get_local_faction_name(true)
	local faction = cm:get_faction(local_faction_key)

	mod.init_ui()
	mod.calculate_per_turn_resources(faction)
	mod.refresh_resource_value_in_ui()

	real_timer.unregister("pj_ovn_rotbloods_warpstone_mercs_campaign_ui_tweaks_real_timer")
	real_timer.register_repeating("pj_ovn_rotbloods_warpstone_mercs_campaign_ui_tweaks_real_timer", 0)
end

mod.player_res = mod.player_res or {
	warpstone = 0,
}

local data = {
	warpstone = {
		banner_path = "ui/campaign ui/effect_bundles/icon_ritual_currency_skv.png",
		units = {
			wh2_dlc12_skv_inf_ratling_gun_0 = 30,
			wh2_dlc12_skv_inf_warplock_jezzails_0 = 30,
			wh2_dlc12_skv_veh_doom_flayer_0 = 30,
			wh2_dlc14_skv_inf_eshin_triads_0 = 20,
			wh2_dlc14_skv_inf_poison_wind_mortar_0 = 30,
			wh2_dlc14_skv_inf_warp_grinder_0 = 20,
			wh2_main_skv_art_plagueclaw_catapult = 30,
			wh2_main_skv_art_warp_lightning_cannon = 40,
			wh2_main_skv_inf_death_globe_bombardiers = 20,
			wh2_main_skv_inf_death_runners_0 = 20,
			wh2_main_skv_inf_plague_monk_censer_bearer = 20,
			wh2_main_skv_inf_plague_monks = 10,
			wh2_main_skv_inf_poison_wind_globadiers = 20,
			wh2_main_skv_inf_warpfire_thrower = 20,
			wh2_main_skv_mon_hell_pit_abomination = 60,
			wh2_main_skv_veh_doomwheel = 40,
			wh2_dlc16_skv_mon_brood_horror_0 = 40,
			wh2_dlc16_skv_mon_rat_ogre_mutant = 40,
		},
	},
}

mod.num_times_purchased = mod.num_times_purchased or
{
	wh2_dlc12_skv_inf_ratling_gun_0 = 0,
	wh2_dlc12_skv_inf_warplock_jezzails_0 = 0,
	wh2_dlc12_skv_veh_doom_flayer_0 = 0,
	wh2_dlc14_skv_inf_eshin_triads_0 = 0,
	wh2_dlc14_skv_inf_poison_wind_mortar_0 = 0,
	wh2_dlc14_skv_inf_warp_grinder_0 = 0,
	wh2_main_skv_art_plagueclaw_catapult = 0,
	wh2_main_skv_art_warp_lightning_cannon = 0,
	wh2_main_skv_inf_death_globe_bombardiers = 0,
	wh2_main_skv_inf_death_runners_0 = 0,
	wh2_main_skv_inf_plague_monk_censer_bearer = 0,
	wh2_main_skv_inf_plague_monks = 0,
	wh2_main_skv_inf_poison_wind_globadiers = 0,
	wh2_main_skv_inf_warpfire_thrower = 0,
	wh2_main_skv_mon_hell_pit_abomination = 0,
	wh2_main_skv_veh_doomwheel = 0,
	wh2_dlc16_skv_mon_brood_horror_0 = 0,
	wh2_dlc16_skv_mon_rat_ogre_mutant = 0,
}

local function handle_unit_component(unit_component, num_res_req, is_valid, banner_path, localized_tooltip, unit_key)
	local unit_icon = find_uicomponent(unit_component, "unit_icon")
	if not unit_icon then return end

	if not is_valid then
		unit_component:SetState("inactive")
		unit_icon:SetState("inactive")
	end

	mod.unit_to_unit_img[unit_key] = unit_icon:GetImagePath(0)

	local FoodCost = find_uicomponent(unit_component, "pj_resource_cost")
	local food = find_uicomponent(FoodCost, "icon")
	if not FoodCost or not food then return end

	FoodCost:SetVisible(true)
	food:SetVisible(true)

	FoodCost:SetDockOffset(38,80)

	FoodCost:SetStateText(num_res_req)
	food:SetImagePath(banner_path, 0)

	if not is_valid then
		FoodCost:TextShaderTechniqueSet("red_pulse_t0", true)
		FoodCost:TextShaderVarsSet(1, 0, 0)
	else
		FoodCost:TextShaderTechniqueSet("normal_t0", true)
	end

	FoodCost:SetTooltipText(localized_tooltip, true)
end

local function handle_unit_components()
	local ui_root = core:get_ui_root()
	local recruitment_docker = find_uicomponent(ui_root, "units_panel", "main_units_panel", "recruitment_docker")
	if not recruitment_docker then
		return
	end

	local recruitment_listbox = find_uicomponent(recruitment_docker, "recruitment_options", "recruitment_listbox")
	if not recruitment_listbox then
		return
	end

	for _, intermediate_id in ipairs({"global", "local1", "local2"}) do
		local intermediate_parent = find_uicomponent(recruitment_listbox, intermediate_id)
		if intermediate_parent then
			local unit_parent = find_uicomponent(intermediate_parent, "unit_list", "listview", "list_clip", "list_box")
			if unit_parent then
				for res_key, res_data in pairs(data) do
					for unit_key, num_res_req in pairs(res_data.units) do
						local unit_component = find_uicomponent(unit_parent, unit_key.."_recruitable")
						if unit_component then
							local scaled_num_res_req = num_res_req+(mod.num_times_purchased[unit_key] or 0)*(num_res_req/2)
							local is_valid = mod.player_res[res_key] >= scaled_num_res_req
							local localized_tooltip = effect.get_localised_string("pj_ovn_rotbloods_warpstone_mercs_res_tooltip_"..res_key)
							localized_tooltip = localized_tooltip.." "..scaled_num_res_req
							if not is_valid then
								localized_tooltip = "[[col:red]]"..localized_tooltip.."[[/col]]"
							end
							local stockpiled_localized_tooltip = effect.get_localised_string("effects_description_pj_ovn_rotbloods_warpstone_mercs_"..res_key)
							localized_tooltip = localized_tooltip.."\n"
								..string.gsub(stockpiled_localized_tooltip, "%%n", mod.player_res[res_key])

							local pj_resource_cost = find_uicomponent(unit_component, "pj_resource_cost")
							if not pj_resource_cost then
								local cd = find_uicomponent(unit_component, "cooldown")
								if cd then
									cd:CopyComponent("pj_resource_cost")
								end
							end

							handle_unit_component(unit_component, scaled_num_res_req, is_valid, res_data.banner_path, localized_tooltip, unit_key)
						end
					end
				end
			end
		end
	end
end

core:remove_listener("pj_ovn_rotbloods_warpstone_mercs_reserves_on_panel_opened")
core:add_listener(
	"pj_ovn_rotbloods_warpstone_mercs_reserves_on_panel_opened",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "units_recruitment" or context.string == "mercenary_recruitment"
	end,
	function()
		local faction = cm:get_faction(cm:get_local_faction_name(true))
		if faction:name() ~= rotblood_faction_key then
			return
		end

		handle_unit_components()
	end,
	true
)

mod.unit_to_unit_img = mod.unit_to_unit_img or {}

core:remove_listener('pj_ovn_rotbloods_warpstone_mercs_on_component_clicked')
core:add_listener(
	'pj_ovn_rotbloods_warpstone_mercs_on_component_clicked',
	'ComponentLClickUp',
	true,
	function(context)
		local local_faction_key = cm:get_local_faction_name(true)
		if local_faction_key ~= rotblood_faction_key then return end

		local local_faction_obj = cm:get_faction(local_faction_key)

		if context.string:starts_with("QueuedLandUnit") then
			local comp = UIComponent(context.component)
			local icon_path = comp:GetImagePath(0)

			for unit_key, unit_icon_path in pairs(mod.unit_to_unit_img) do
				if icon_path == unit_icon_path then
					for res_key, res_data in pairs(data) do
						for data_unit_key, num_res_req in pairs(res_data.units) do
							if unit_key == data_unit_key then
								mod.player_res[res_key] = mod.player_res[res_key] + num_res_req
								mod.num_times_purchased[unit_key] = math.max(0, (mod.num_times_purchased[unit_key] or 0)-1)
								mod.increase_resources_networked(num_res_req)
								return
							end
						end
					end
				end
			end
			return
		end

		if not string.find(context.string, "_recruitable") then return end

		for res_key, res_data in pairs(data) do
			for unit_key, num_res_req in pairs(res_data.units) do
				if unit_key.."_recruitable" == context.string then
					local comp = UIComponent(context.component)
					local unit_icon = find_uicomponent(comp, "unit_icon")
					local icon_path = unit_icon:GetImagePath(0)
					mod.unit_to_unit_img[unit_key] = icon_path
					if comp:CurrentState() ~= "active" then return end
					mod.player_res[res_key] = mod.player_res[res_key] - num_res_req
					mod.num_times_purchased[unit_key] = (mod.num_times_purchased[unit_key] or 0)+1
					mod.increase_resources_networked(-num_res_req)
					break
				end
			end
		end
	end,
	true
)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("pj_ovn_rotbloods_warpstone_mercs_player_res", mod.player_res, context)
		cm:save_named_value("pj_ovn_rotbloods_warpstone_mercs_num_times_purchased", mod.num_times_purchased, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mod.player_res = cm:load_named_value("pj_ovn_rotbloods_warpstone_mercs_player_res", mod.player_res, context)
		mod.num_times_purchased = cm:load_named_value("pj_ovn_rotbloods_warpstone_mercs_num_times_purchased", mod.player_res, context)
	end
)

mod.apply_campaign_ui_changes = function()
	local ui_parent_3d = find_uicomponent(
			core:get_ui_root(),
			"3d_ui_parent"
	)

	if not ui_parent_3d then
			return
	end

	for i = 0, ui_parent_3d:ChildCount() - 1 do
			local uic_child = UIComponent(ui_parent_3d:Find(i));

			local settlement_data = mod.label_settlement_to_data[uic_child:Id()]
			if settlement_data then
					local icon_holder = find_uicomponent(
						uic_child,
						"list_parent",
						"icon_holder"
					)

					local pj_rot_warpstone = find_uicomponent(
						icon_holder,
						"pj_rot_warpstone5"
					)

					if icon_holder and not pj_rot_warpstone then
						pj_rot_warpstone = UIComponent(icon_holder:CreateComponent("pj_rot_warpstone5", "ui/templates/custom_image"))
						pj_rot_warpstone:SetImagePath("ui/skins/warhammer2/pj_rot_warpstone.png", 4)
						pj_rot_warpstone:SetTooltipText("Warpstone||This region contains warpstone that can be used to bargain with clan Fester.\n\nHolding the region will give you "..settlement_data.." warpstone per turn.", true)
						pj_rot_warpstone:SetCanResizeWidth(true)
						pj_rot_warpstone:SetCanResizeHeight(true)
						pj_rot_warpstone:Resize(24, 24)
						icon_holder:Layout()
					end
					if not pj_rot_warpstone:Visible() then
						pj_rot_warpstone:SetVisible(true)
					end
			end
	end
end

core:add_listener(
	"pj_ovn_rotbloods_warpstone_mercs_campaign_ui_tweaks_real_timer_cb",
	"RealTimeTrigger",
	function(context)
			return context.string == "pj_ovn_rotbloods_warpstone_mercs_campaign_ui_tweaks_real_timer"
	end,
	function()
		mod.apply_campaign_ui_changes()
	end,
	true
)

core:remove_listener("pj_ovn_rotbloods_warpstone_mercs_on_unit_trained")
core:add_listener(
	"pj_ovn_rotbloods_warpstone_mercs_on_unit_trained",
	"UnitTrained",
	function()
		return true
	end,
	function(context)
		local local_faction_key = cm:get_local_faction_name(true)
		if local_faction_key ~= rotblood_faction_key then return end

		---@type CA_UNIT
		local unit = context:unit()
		local unit_key = unit:unit_key()

		local num_times_purchased = mod.num_times_purchased[unit_key]
		if num_times_purchased then
			mod.num_times_purchased[unit_key] = mod.num_times_purchased[unit_key] + 1
		end
	end,
	true
)

local empire_prestige_kill_income_mod = 0.1
local empire_prestige_kill_value_mod = 0.05
local empire_prestige_kill_income_cap = 100

mod.handle_battle_rewards = function(context)
	if cm:model():pending_battle():has_been_fought() == true then
		local attacker_result = cm:model():pending_battle():attacker_battle_result();
		local defender_result = cm:model():pending_battle():defender_battle_result();
		local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory");
		local defender_won = (defender_result == "heroic_victory") or (defender_result == "decisive_victory") or (defender_result == "close_victory") or (defender_result == "pyrrhic_victory");
		local attacker_value = cm:pending_battle_cache_attacker_value();
		local defender_value = cm:pending_battle_cache_defender_value();
		local already_awarded = {};

		local is_rotblood_present = false
		local is_rootblood_attacker = true
		local is_skaven_present = false
		local is_skaven_attacker = false
		local is_skaven_defender = false
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)
			if attacker_name == rotblood_faction_key then
				is_rotblood_present = true
				is_rootblood_attacker = true
			end
			local attacker = cm:model():world():faction_by_key(attacker_name)
			if not attacker then return end

			if attacker:subculture() == "wh2_main_sc_skv_skaven" then
				is_skaven_present = true
				is_skaven_attacker = true
			end
		end
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i)
			if defender_name == rotblood_faction_key then
				is_rotblood_present = true
				is_rootblood_attacker = false
			end
			local defender = cm:model():world():faction_by_key(defender_name)
			if not defender then return end

			if defender:subculture() == "wh2_main_sc_skv_skaven" then
				is_skaven_present = true
				is_skaven_defender = true
			end
		end

		if not is_rotblood_present then return end
		if not is_skaven_present then return end
		if is_rootblood_attacker and not is_skaven_defender or not is_rootblood_attacker and not is_skaven_attacker then
			return
		end

		if is_rootblood_attacker and attacker_won == true then
			local attacker_prestige = (defender_value * empire_prestige_kill_value_mod);
			local kill_ratio = cm:model():pending_battle():percentage_of_defender_killed()
			out("OVN ROTBLOOD VS SKAVEN:")
			out("attacker_prestige:")
			out(attacker_prestige)
			out("kill_ration:")
			out(kill_ratio)
			attacker_prestige = attacker_prestige * kill_ratio

			for i = 1, cm:pending_battle_cache_num_attackers() do
				local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)

				if already_awarded[attacker_name] == nil then
					local attacker = cm:model():world():faction_by_key(attacker_name)

					if attacker:is_null_interface() == false and attacker:has_pooled_resource("pj_rot_warpstone") == true then
						local prestige_reward = attacker_prestige * empire_prestige_kill_income_mod
						if prestige_reward > empire_prestige_kill_income_cap then
							prestige_reward = empire_prestige_kill_income_cap
						end
						prestige_reward = math.ceilTo(prestige_reward, 5)
						out("reward:")
						out(prestige_reward)
						cm:trigger_custom_incident(attacker:name(), "pj_rot_warpstone_incident", true, "payload{faction_pooled_resource_transaction{resource pj_rot_warpstone;factor wh2_main_resource_factor_other;amount "..tostring(prestige_reward)..";};}");
						already_awarded[attacker_name] = true
						cm:callback(
							function()
								mod.refresh_resource_value_in_ui()
							end,
							1
						)
					end
				end
			end
		elseif not is_rootblood_attacker and defender_won == true then
			local defender_prestige = (attacker_value * empire_prestige_kill_value_mod);
			local kill_ratio = cm:model():pending_battle():percentage_of_attacker_killed()
			defender_prestige = defender_prestige * kill_ratio

			for i = 1, cm:pending_battle_cache_num_defenders() do
				local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i)

				if already_awarded[defender_name] == nil then
					local defender = cm:model():world():faction_by_key(defender_name)

					if defender:is_null_interface() == false and defender:has_pooled_resource("pj_rot_warpstone") == true then
						local prestige_reward = defender_prestige * empire_prestige_kill_income_mod
						if prestige_reward > empire_prestige_kill_income_cap then
							prestige_reward = empire_prestige_kill_income_cap
						end
						prestige_reward = math.ceilTo(prestige_reward, 5)
						out("reward:")
						out(prestige_reward)
						cm:trigger_custom_incident(defender:name(), "pj_rot_warpstone_incident", true, "payload{faction_pooled_resource_transaction{resource pj_rot_warpstone;factor wh2_main_resource_factor_other;amount "..tostring(prestige_reward)..";};}");
						already_awarded[defender_name] = true
						cm:callback(
							function()
								mod.refresh_resource_value_in_ui()
							end,
							1
						)
					end
				end
			end
		end
	end
end

core:remove_listener("pj_ovn_rotbloods_warpstone_mercs_BattleCompleted")
core:add_listener(
	"pj_ovn_rotbloods_warpstone_mercs_BattleCompleted",
	"BattleCompleted",
	true,
	function(context)
		mod.handle_battle_rewards(context);
	end,
	true
);


--- Stuff that helps when debugging:
-- spawn wh2_main_skv_warlord wh2_main_skv_clan_mors wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_0
-- add unit wh2_main_skv_inf_stormvermin_0 30
-- add unit wh2_main_skv_inf_clanrats_0 30

-- local mod = PJ_OVN_ROTBLOOD_WARPSTONE_MERCS
-- local rotblood_faction_key = "wh_dlc08_nor_naglfarlings"
-- local rotblood_faction = cm:get_faction(rotblood_faction_key)
-- cm:pooled_resource_mod(rotblood_faction:command_queue_index(), "pj_rot_warpstone", "wh2_main_resource_factor_other", 100)
-- mod.refresh_resource_value_in_ui()
