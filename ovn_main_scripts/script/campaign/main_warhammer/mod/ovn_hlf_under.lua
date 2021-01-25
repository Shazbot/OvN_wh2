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

local function refresh_foreign_slots()
	region_labels_with_foreign_slots = {}
	---@type CA_FACTION
	local lf = cm:get_local_faction(true)
	for fsm in binding_iter(lf:foreign_slot_managers()) do
		region_labels_with_foreign_slots["label_settlement:"..fsm:region():name()] = true
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
		if faction_name ~= cm:get_local_faction_name(true) then return end
		if faction_name ~= "wh2_main_emp_the_moot" then return end

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
						restaurant_icon:SetTooltipText("Restaurant||This region contains a Halfling restaurant.", true)
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
