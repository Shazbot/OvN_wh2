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

local region_labels_with_foreign_slots = {}
local regions_with_restaurant_recruit_buttons = {}

local function refresh_foreign_slots()
	region_labels_with_foreign_slots = {}
	---@type CA_FACTION
	local lf = cm:get_local_faction(true)
	for fsm in binding_iter(lf:foreign_slot_managers()) do
		region_labels_with_foreign_slots["label_settlement:"..fsm:region():name()] = true
		regions_with_restaurant_recruit_buttons[fsm:region():name()] = true
	end

	for region_key, _ in pairs(regions_with_restaurant_recruit_buttons) do
		cm:apply_effect_bundle_to_region("ovn_hlf_recruit_general", region_key, -1)
		cm:apply_effect_bundle_to_region("ovn_hlf_recruit_wizard", region_key, -1)
	end
end

local function check_restaurant_victory_conditions()
	local num_restaurants = 0
	---@type CA_FACTION
	local faction = cm:get_faction("wh2_main_emp_the_moot")
	for fsm in binding_iter(faction:foreign_slot_managers()) do
		num_restaurants = num_restaurants + 1
	end
	if faction:is_human() and num_restaurants >= 15 then
		cm:complete_scripted_mission_objective("wh_main_short_victory", "ovn_hlf_establish_restaurants", true)
		cm:complete_scripted_mission_objective("wh_main_long_victory", "ovn_hlf_establish_restaurants", true)
	end
end

core:add_listener(
	"ovn_hlf_under_established_restaurant_with_agent",
	"CharacterGarrisonTargetAction",
	true,
	function(context)
		if context:mission_result_critial_success() or context:mission_result_success() then
			if context:agent_action_key():find("ovn_create_restaurant") then
				cm:complete_scripted_mission_objective("ovn_halfling_establish_restaurant_mission", "ovn_halfling_establish_restaurant_mission", true);
			end
		end
	end,
	true
)

local function add_passive_income_building_to_restaurant()
	local faction = cm:get_faction("wh2_main_emp_the_moot")
	for fsm in binding_iter(faction:foreign_slot_managers()) do
		local fsm_slots = fsm:slots()
		if fsm_slots:num_items() > 0 then
			local first_slot = fsm_slots:item_at(0)
			if not first_slot:has_building() then
				cm:foreign_slot_instantly_upgrade_building(first_slot, "ovn_hlf_under_barn_1")
			end
		end
	end
end

core:remove_listener("ovn_hlf_under_occupation_decision_made")
core:add_listener(
	"ovn_hlf_under_occupation_decision_made",
	"CharacterPerformsSettlementOccupationDecision",
	true,
	function(context)
		if context:occupation_decision() ~= "2205198931" then
			return
		end

		---@type CA_REGION
		local region = context:garrison_residence():region()

		---@type CA_CHAR
		local character = context:character();
		if not character then return end
		local char_faction_cqi = character:faction():command_queue_index()
		local region_cqi = region:cqi()

		cm:callback(
			function()
				cm:add_foreign_slot_set_to_region_for_faction(char_faction_cqi, region_cqi, "ovn_restaurant");
				refresh_foreign_slots()
				cm:callback(
					function()
						add_passive_income_building_to_restaurant()
					end,
					0
				)
			end,
			0
		)
	end,
	true
)

core:remove_listener("ovn_hlf_under_on_settlement_captured_panel_opened")
core:add_listener(
	"ovn_hlf_under_on_settlement_captured_panel_opened",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "settlement_captured"
	end,
	function()
		local decision = find_ui_component_str("root > settlement_captured > button_parent > 5165439")
		if decision then
			decision:SetVisible(false)
		end
	end,
	true
)

core:remove_listener("ovn_create_restaurant_cooldown")
core:add_listener(
	"ovn_create_restaurant_cooldown",
	"CharacterGarrisonTargetAction",
	true,
	function(context)
		if context:mission_result_critial_success() or context:mission_result_success() then
			if context:agent_action_key() == "ovn_create_restaurant" then
				local agent_faction = context:character():faction():name();
				cm:remove_effect_bundle("ovn_create_restaurant_cooldown", agent_faction);
				cm:apply_effect_bundle("ovn_create_restaurant_cooldown", agent_faction, 10);
				cm:callback(
					function()
						refresh_foreign_slots()
						add_passive_income_building_to_restaurant()
					end,
					0
				)
			end
		end
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
		local faction_name = faction:name()
		if faction_name ~= "wh2_main_emp_the_moot" then return end
		check_restaurant_victory_conditions()

		if faction_name ~= cm:get_local_faction_name(true) then return end
		refresh_foreign_slots()
	end,
	true
)

local function apply_campaign_ui_changes()
	local ui_parent_3d = find_uicomponent(
			core:get_ui_root(),
			"3d_ui_parent"
	)

	if not ui_parent_3d then
			return
	end

	for i = 0, ui_parent_3d:ChildCount() - 1 do
			local uic_child = UIComponent(ui_parent_3d:Find(i));

			local settlement_data = region_labels_with_foreign_slots[uic_child:Id()]
			if settlement_data then
					local icon_holder = find_uicomponent(
						uic_child,
						"list_parent",
						"icon_holder"
					)

					local restaurant_icon = find_uicomponent(
						icon_holder,
						"ovn_restoraunt_icon"
					)

					if icon_holder and not restaurant_icon then
						restaurant_icon = UIComponent(icon_holder:CreateComponent("ovn_restoraunt_icon", "ui/templates/custom_image"))
						restaurant_icon:SetImagePath("ui/skins/warhammer2/restaurant_48.png", 4)
						restaurant_icon:SetTooltipText(effect.get_localised_string("ovn_hlf_under_region_restaurant_tooltip"), true)
						restaurant_icon:SetCanResizeWidth(true)
						restaurant_icon:SetCanResizeHeight(true)
						restaurant_icon:Resize(40, 40)

						restaurant_icon:SetDockingPoint(1)
						restaurant_icon:SetDockOffset(0, -10)
						icon_holder:Layout()
					end
					if not restaurant_icon:Visible() then
						restaurant_icon:SetVisible(true)
					end
			end
	end
end

core:remove_listener("ovn_hlf_under_campaign_real_timer")
core:add_listener(
	"ovn_hlf_under_campaign_real_timer",
	"RealTimeTrigger",
	function(context)
			return context.string == "ovn_hlf_under_campaign_real_timer"
	end,
	function()
		apply_campaign_ui_changes()
	end,
	true
)

local hlf_forenames = {
	"858211990",
	"858211991",
	"858211992",
	"858211993",
	"858211994",
	"858211995",
	"858211996",
	"858211997",
	"858211998",
	"858211999",
	"858212000",
	"858212001",
	"858212002",
	"858212003",
	"858212004",
	"858212005",
	"858212006",
	"858212007",
	"858212008",
	"858212009",
	"858212010",
	"858212011",
	"858212012",
	"858212013",
	"858212014",
	"858212015",
	"858212016",
	"858212017",
	"858212018",
	"858212019",
	"858212020",
	"858212021",
	"858212022",
	"858212023",
	"858212024",
	"858212025",
	"858212026",
	"858212027",
	"858212028",
	"858212029",
	"858212030",
	"858212031",
	"858212032",
	"858212033",
	"858212034",
	"858212035",
	"858212036",
	"858212037",
	"858212038",
	"858212039",
	"858212040",
	"858212041",
	"858212042",
	"858212043",
}

local hlf_surnames = {
	"858212044",
	"858212045",
	"858212046",
	"858212047",
	"858212048",
	"858212049",
	"858212050",
	"858212051",
	"858212052",
	"858212053",
	"858212054",
	"858212055",
	"858212056",
	"858212057",
	"858212058",
	"858212059",
	"858212060",
	"858212061",
	"858212062",
	"858212063",
	"858212064",
	"858212065",
	"858212066",
	"858212067",
	"858212068",
	"858212069",
	"858212070",
	"858212071",
	"858212072",
	"858212073",
	"858212074",
	"858212075",
	"858212076",
	"858212077",
	"858212078",
	"858212079",
	"858212080",
	"858212081",
	"858212082",
	"858212083",
	"858212084",
	"858212085",
	"858212086",
	"858212087",
	"858212088",
	"858212089",
	"858212090",
	"858212091",
	"858212092",
	"858212093",
	"858212094",
	"858212095",
	"858212096",
	"858212097",
	"858212098",
	"858212099",
}

core:remove_listener('ovn_hlf_recruit_general_from_restaurant')
core:add_listener(
	'ovn_hlf_recruit_general_from_restaurant',
	'ComponentLClickUp',
	function(context)
		return context.string == "CcoEffectBundleovn_hlf_recruit_wizard_0"
			or context.string == "CcoEffectBundleovn_hlf_recruit_general_0"
	end,
	function(context)
		local subtype = "ovn_hlf_moot_general"
		if context.string == "CcoEffectBundleovn_hlf_recruit_wizard_0" then
			subtype = "ovn_hlf_ll"
		end

		local comp = UIComponent(context.component)
		for _=1, 4 do
			comp = UIComponent(comp:Parent())
		end
		local region_key = comp:Id():gsub("label_settlement:", "")

		local x, y = cm:find_valid_spawn_location_for_character_from_settlement("wh2_main_emp_the_moot", region_key, false, false, 0)
		if x == -1 then return end

		cm:create_force_with_general(
			"wh2_main_emp_the_moot",
			"halfling_militia,halfling_militia,halfling_milittia_arch",
			region_key,
			x, y,
			"general", subtype,
			"names_name_"..tostring(hlf_forenames[cm:random_number(#hlf_forenames)]), "",
			"names_name_"..tostring(hlf_surnames[cm:random_number(#hlf_surnames)]), "",
			false,
			function(cqi)
				local char = cm:get_character_by_cqi(cqi)
				cm:replenish_action_points(cm:char_lookup_str(char))
			end
		)

		cm:remove_effect_bundle_from_region("ovn_hlf_recruit_general", region_key)
		cm:remove_effect_bundle_from_region("ovn_hlf_recruit_wizard", region_key)
	end,
	true
)

core:remove_listener('ovn_hlf_restaurant_destroyed')
core:add_listener(
	"ovn_hlf_restaurant_destroyed",
	"ForeignSlotManagerRemovedEvent",
	true,
	function(context)
		local owner = context:owner()
		local owner_key = owner:name()

		if owner_key == "wh2_main_emp_the_moot" then
			local region = context:region()
			local region_name = region:name()
			regions_with_restaurant_recruit_buttons[region_name] = nil
			cm:remove_effect_bundle_from_region("ovn_hlf_recruit_general", region_name)
			cm:remove_effect_bundle_from_region("ovn_hlf_recruit_wizard", region_name)
			refresh_foreign_slots()
		end
	end,
	true
)

cm:add_first_tick_callback(function()
	local local_faction_key = cm:get_local_faction_name(true)
	if local_faction_key ~= "wh2_main_emp_the_moot" then return end

	refresh_foreign_slots()

	real_timer.unregister("ovn_hlf_under_campaign_real_timer")
	real_timer.register_repeating("ovn_hlf_under_campaign_real_timer", 0)
end)

if debug.traceback():find('pj_loadfile') then
	refresh_foreign_slots()
	cm:remove_effect_bundle("ovn_create_restaurant_cooldown", cm:get_local_faction_name(true));
end
