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

local function binding_iter(binding)
	local pos = 0
	local num_items = binding:num_items()
	return function()
			if pos < num_items then
					local item = binding:item_at(pos)
					pos = pos + 1
					return item
			end
	end
end

OVN_ROT_SKITTERGATE = OVN_ROT_SKITTERGATE or {}
local mod = OVN_ROT_SKITTERGATE

local rotblood_faction_key = "wh2_main_nor_rotbloods"

mod.switch_state = function(new_state, old_state)
	out("OVN ROTBLOODS: SWITCHING STATE")
	if old_state then out("FROM: "..old_state.name) end
	if new_state then out("TO: "..new_state.name) end

	if old_state and old_state.exit then
		old_state:exit()
	end

	mod.current_state = new_state

	for state_key, state in pairs(mod.states) do
		if state == mod.current_state then
			cm:set_saved_value("pj_rot_skittergate_current_state", state_key)
			break
		end
	end

	if new_state.init then
		new_state:init()
	end
end

core:remove_listener("ovn_rotbloods_skittergate_check_building_exists")
core:add_listener(
	"ovn_rotbloods_skittergate_check_building_exists",
	"FactionTurnStart",
	true,
	function(context)
		if context:faction():name() ~= "wh2_main_nor_rotbloods" then return end

		local state = mod.current_state
		if not state then return end

		if state.on_turn_start then
			state:on_turn_start()
		end

	end,
	true
)

mod.check_skittergate_exists = function()
	local region = cm:get_region("wh_main_mountains_of_hel_altar_of_spawns")
	if not region or region:is_null_interface() then return false end

	local are_rotbloods_owners = region:owning_faction():name() == "wh2_main_nor_rotbloods"
	local does_skittergate_exist = region:building_exists("ovn_rot_skittergate")

	if not are_rotbloods_owners or not does_skittergate_exist then
		mod.switch_state(mod.states.not_built, mod.current_state)
	end

	return are_rotbloods_owners and does_skittergate_exist
end

mod.create_skittergate_tutorial = function()
	local dialogue_box = core:get_or_create_component("ovn_skittergate_tutorial", "ui/common ui/dialogue_box")
	core:add_listener(
		"ovn_skittergate_tutorial_real_time_trigger_cb",
		"RealTimeTrigger",
		function(context)
			return context.string == "ovn_skittergate_tutorial_real_time_trigger"
		end,
		function(context)
			dialogue_box:SetCanResizeWidth(true)
			dialogue_box:SetCanResizeHeight(true)
			dialogue_box:Resize(1000,700)

			local replenish_text = find_ui_component_str("root > ovn_skittergate_tutorial > DY_text")
			replenish_text:SetDockingPoint(5)
			replenish_text:SetStateText("[[col:white]]First select a region on the world map as the Skittergate target.[[/col]]")
			replenish_text:SetDockOffset(-250,205)
			replenish_text:SetCanResizeHeight(true)
			replenish_text:Resize(replenish_text:Width(), 50)

			local tutorial_text = UIComponent(replenish_text:CopyComponent("ovn_skittergate_tutorial_text1"))
			tutorial_text:SetStateText("How to use the Skittergate:")
			tutorial_text:SetDockingPoint(5)
			tutorial_text:SetDockOffset(0,-305)
			dout(tutorial_text:Height())
			tutorial_text:SetCanResizeHeight(true)
			tutorial_text:Resize(tutorial_text:Width(), 50)

			local reserves_text = UIComponent(replenish_text:CopyComponent("ovn_skittergate_tutorial_text2"))
			reserves_text:SetDockingPoint(5)
			reserves_text:SetDockOffset(250,205)
			reserves_text:SetCanResizeHeight(true)
			reserves_text:Resize(reserves_text:Width(), 50)
			reserves_text:SetStateText("[[col:white]]Once the Skittergate is active move your army into the red\nteleportation spot and click the button to teleport to the other region.[[/col]]")

			local button_cancel = find_ui_component_str("root > ovn_skittergate_tutorial > both_group > button_cancel")
			button_cancel:SetVisible(false)

			local button_tick = find_ui_component_str("root > ovn_skittergate_tutorial > both_group > button_tick")
			button_tick:SetDockingPoint(8)
			button_tick:SetDockOffset(0,-60)

			local bg_image = UIComponent(dialogue_box:CreateComponent("ovn_skittergate_tutorial_image1", "ui/templates/custom_image"))
			bg_image:SetImagePath("ui/ovn/skittergate/skittergate_tutorial1.png", 4)
			bg_image:SetDockingPoint(5)
			bg_image:SetCanResizeWidth(true)
			bg_image:SetCanResizeHeight(true)
			bg_image:Resize(417,417)
			bg_image:SetDockOffset(-250,-68)

			local bg_image = UIComponent(dialogue_box:CreateComponent("ovn_skittergate_tutorial_image2", "ui/templates/custom_image"))
			bg_image:SetImagePath("ui/ovn/skittergate/skittergate_tutorial2.png", 4)
			bg_image:SetDockingPoint(5)
			bg_image:SetDockOffset(250,-68)
			bg_image:SetCanResizeWidth(true)
			bg_image:SetCanResizeHeight(true)
			bg_image:Resize(417,417)
		end,
		false
	)
	real_timer.register_singleshot("ovn_skittergate_tutorial_real_time_trigger", 0)
end

mod.init = function()
	local topbar_list_parent = find_ui_component_str("root > layout > resources_bar > topbar_list_parent")

	local dragon_taming_holder = find_ui_component_str("root > layout > resources_bar > topbar_list_parent > dragon_taming_holder")
	dragon_taming_holder:SetVisible(true)
	local dragon_taming_icon = find_ui_component_str("root > layout > resources_bar > topbar_list_parent > dragon_taming_holder > dragon_taming_icon")
	dragon_taming_icon:SetVisible(false)

	local skittergate_button_parent = core:get_or_create_component("pj_rot_skittergate_parent", "UI/campaign ui/script_dummy", topbar_list_parent)
	local sk = core:get_or_create_component("pj_rot_skittergate", "ui/templates/round_large_button", skittergate_button_parent)

	dragon_taming_holder:Adopt(skittergate_button_parent:Address())

	skittergate_button_parent:SetDockingPoint(1)
	skittergate_button_parent:SetDockOffset(0,0)
	sk:SetDockingPoint(1)
	sk:SetDockOffset(15,0)

	skittergate_button_parent:Resize(85, skittergate_button_parent:Height())

	topbar_list_parent:Layout()

	local timer = find_uicomponent(sk, "pj_rot_skittergate_timer")
	if not timer then
		local game_ui_counter = find_ui_component_str("root > layout > bar_small_top > TabGroup > tab_missions > counter")
		timer = UIComponent(game_ui_counter:CopyComponent("pj_rot_skittergate_timer"))
		sk:Adopt(timer:Address())
	end
	timer:SetStateText("0")
	timer:SetVisible(false)
	timer:SetDockingPoint(9)
	timer:SetDockOffset(3,9)

	sk:SetImagePath("ui/ovn/skittergate/skittergate_button_locked.png", 0)
	sk:SetState("inactive")
	sk:SetInteractive(true)

	mod.states = {
		not_built = {
			tooltip = "Unbuilt Skittergate||The Skittergate needs to be built first! Order the Skittergate be built in the Altar of Spawns region, and your Skaven allies of Clan Fester will jump to the task!",
			timer_tooltip = "",
			init = function(state)
				timer:SetVisible(false)

				sk:SetTooltipText(state.tooltip or "", true)
				timer:SetTooltipText(state.timer_tooltip or "", true)
				sk:SetImagePath("ui/ovn/skittergate/skittergate_button_locked.png", 0)
				sk:SetState("inactive")
				sk:SetInteractive(true)
			end,
			on_turn_start = function(state)
				local region = cm:get_region("wh_main_mountains_of_hel_altar_of_spawns")
				if not region or region:is_null_interface() then return end

				if region:building_exists("ovn_rot_skittergate") then
					cm:set_saved_value("pj_rot_skittergate_was_just_built", true)
					mod.switch_state(mod.states.cooldown, state)
				end
			end,
		},
		cooldown = {
			tooltip = "Damaged Skittergate||The Skittergate lies dormant and is being repaired by Clan Fester Warlock-Engineers!",
			timer_tooltip = "Number of turns until Skittergate is brought online.",
			current_cooldown = nil,
			init = function(state)
				sk:SetTooltipText(state.tooltip or "", true)

				sk:SetImagePath("ui/ovn/skittergate/skittergate_button_repair.png", 0)
				sk:SetState("inactive")
				sk:SetInteractive(true)

				timer:SetVisible(true)
				timer:SetInteractive(true)

				state.current_cooldown = cm:get_saved_value("pj_rot_skittergate_current_cooldown")
				if not state.current_cooldown then
					state.current_cooldown = cm:random_number(12,8)
					if cm:get_saved_value("pj_rot_tech_skv_3_completed") then
						state.current_cooldown = state.current_cooldown - 2
					end
					if cm:get_saved_value("pj_rot_tech_skv_4_completed") then
						state.current_cooldown = state.current_cooldown - 2
					end
				end

				if cm:get_saved_value("pj_rot_skittergate_was_just_built") then
					cm:set_saved_value("pj_rot_skittergate_was_just_built", false)
					state.current_cooldown = 4
				end
				cm:set_saved_value("pj_rot_skittergate_current_cooldown", state.current_cooldown)

				timer:SetTooltipText(state.timer_tooltip or "", true)
				timer:SetStateText(string.format("%d", state.current_cooldown))

				local ski = core:get_or_create_component("pj_rot_skittergate_icon", "ui/templates/custom_image", sk)
				ski:SetImagePath("ui/skins/default/icon_repair.png", 4)
				ski:Resize(50,50)
				ski:SetDockingPoint(5)
				ski:SetDockOffset(1,1)
				ski:SetVisible(true)
				ski:SetTooltipText(state.tooltip or "", true)
			end,
			on_turn_start = function(state)
				if not mod.check_skittergate_exists() then return end
				state.current_cooldown = state.current_cooldown - 1
				cm:set_saved_value("pj_rot_skittergate_current_cooldown", state.current_cooldown)
				timer:SetStateText(string.format("%d", state.current_cooldown))
				if state.current_cooldown < 1 then
					mod.switch_state(mod.states.usable, state)
				end
			end,
			exit = function(state)
				local ski = find_uicomponent(sk, "pj_rot_skittergate_icon")
				if ski then
					ski:SetVisible(false)
				end

				cm:set_saved_value("pj_rot_skittergate_current_cooldown", false)
				timer:SetVisible(false)
			end
		},
		usable = {
			tooltip = "Primed Skittergate||The Skittergate is ready for activation! Choose a target settlement on the campaign map!",
			timer_tooltip = "",
			init = function(state)
				sk:SetTooltipText(state.tooltip or "", true)
				timer:SetTooltipText(state.timer_tooltip or "", true)

				if not cm:get_saved_value("ovn_skittergate_tutorial_was_shown") then
					cm:set_saved_value("ovn_skittergate_tutorial_was_shown", true)
					mod.create_skittergate_tutorial()
				end

				sk:SetState("active")
				sk:SetImagePath("ui/ovn/skittergate/skittergate_button_yellow.png", 0)
				sk:ShaderTechniqueSet("distortion", true)
				sk:ShaderVarsSet(0.2, 1, 1)
			end,
			on_turn_start = function(state)
				if not mod.check_skittergate_exists() then return end
			end,
			exit = function(state)
				sk:ShaderTechniqueSet("normal_t0", true)
			end,
		},
		active = {
			tooltip = "Active Skittergate||The Skittergate is open and your generals and agents can freely use it."
				.." It will remain open for a number of turns but you can manually close it at any time."
				.."\n\n[[col:yellow]]Click the button to manually close the Skittergate.[[/col]]",
			timer_tooltip = "Number of turns the Skittergate will remain open.",
			current_cooldown = nil,
			init = function(state)
				sk:SetTooltipText(state.tooltip or "", true)
				timer:SetTooltipText(state.timer_tooltip or "", true)

				sk:SetState("active")
				sk:SetImagePath("ui/ovn/skittergate/skittergate_button_green.png", 0)
				state.current_cooldown = cm:get_saved_value("pj_rot_skittergate_active_cooldown") or cm:random_number(12,8)
				cm:set_saved_value("pj_rot_skittergate_active_cooldown", state.current_cooldown)
				timer:SetStateText(string.format("[[col:white]]%d[[/col]]", state.current_cooldown))
				timer:SetVisible(true)
				timer:SetInteractive(true)
				mod.add_sk_markers()
			end,
			on_turn_start = function(state)
				if not mod.check_skittergate_exists() then return end
				state.current_cooldown = state.current_cooldown - 1
				cm:set_saved_value("pj_rot_skittergate_active_cooldown", state.current_cooldown)
				timer:SetStateText(string.format("[[col:white]]%d[[/col]]", state.current_cooldown))
				if state.current_cooldown < 1 then
					mod.switch_state(mod.states.cooldown, state)
				end
			end,
			exit = function(state)
				cm:set_saved_value("pj_rot_skittergate_active_cooldown", false)
				timer:SetVisible(false)
				mod.remove_sk_markers()
			end
		},
	}

	-- add a name field to inside state that mirrors the table key
	for state_key, state in pairs(mod.states) do
		state.name = state_key
	end

	local saved_state = cm:get_saved_value("pj_rot_skittergate_current_state") or "not_built"
	for state_key, state in pairs(mod.states) do
		if state_key == saved_state then
			mod.switch_state(state, mod.current_state)
			break
		end
	end
end

mod.add_sk_markers = function()
	local region_key = mod.current_region_key or cm:get_saved_value("pj_rot_skittergate_current_region")
	if not region_key then return end

	local x, y = cm:find_valid_spawn_location_for_character_from_settlement("wh2_main_nor_rotbloods", region_key, false, false, 0)
	mod.skittergate_exit_coordinates = {x=x, y=y}
	local key = "ovn_skittergate_marker_exit"
	cm:remove_interactable_campaign_marker(key)
	cm:add_interactable_campaign_marker(key, "ovn_rot_skittergate_exit", x, y, 0, "wh2_main_nor_rotbloods", "")

	x, y = cm:find_valid_spawn_location_for_character_from_settlement("wh2_main_nor_rotbloods", "wh_main_mountains_of_hel_altar_of_spawns", false, false, 0)
	mod.skittergate_entrance_coordinates = {x=x, y=y}
	key = "ovn_skittergate_marker_entrance"
	cm:remove_interactable_campaign_marker(key)
	cm:add_interactable_campaign_marker(key, "ovn_rot_skittergate_entrance", x, y, 0, "wh2_main_nor_rotbloods", "")
end

mod.remove_sk_markers = function()
	local key = "ovn_skittergate_marker_exit"
	cm:remove_interactable_campaign_marker(key)

	local key = "ovn_skittergate_marker_entrance"
	cm:remove_interactable_campaign_marker(key)
end

mod.handle_char_ui_label = function(label, char_cqi, set_visible)
	local existing_parent = find_uicomponent(label, "dy_name")
	local is_hero = false
	if not existing_parent then
		is_hero = true
		existing_parent = find_uicomponent(label, "faction")
	end
	if not existing_parent then return end

	local skittergate_button_parent = core:get_or_create_component("ovn_sk_char_button_parent", "UI/campaign ui/script_dummy", is_hero and existing_parent or label)
	local skittergate_button = core:get_or_create_component("ovn_sk_char_button_"..char_cqi, "ui/templates/round_large_button", skittergate_button_parent)

	if mod.current_state.name ~= "active" or not set_visible then
		skittergate_button_parent:SetVisible(false)
	else
		skittergate_button_parent:SetVisible(true)
		local size = is_hero and 30 or 48
		if skittergate_button:Width() ~= size then
			skittergate_button_parent:SetDockingPoint(5)
			skittergate_button_parent:SetDockOffset(0, is_hero and 30 or -15)
			skittergate_button:SetDockingPoint(5)
			skittergate_button:SetDockOffset(0, 0)
			skittergate_button:SetCanResizeHeight(true)
			skittergate_button:SetCanResizeWidth(true)
			skittergate_button:Resize(size, size)
			skittergate_button:SetImagePath("ui/ovn/skittergate/skittergate_button_green.png", 0)
			skittergate_button:SetTooltipText("Enter The Skittergate||The character will enter the Skittergate and appear at the other side!", true)
		end
	end
end

core:remove_listener("ovn_rot_sk_real_time_cb")
core:add_listener(
	"ovn_rot_sk_real_time_cb",
	"RealTimeTrigger",
	function(context)
		return context.string == "ovn_rot_sk_real_time"
	end,
	function()
			local ui_root = core:get_ui_root()

			local pj_rot_skittergate_parent = find_ui_component_str("root > layout > resources_bar > topbar_list_parent > dragon_taming_holder > pj_rot_skittergate_parent")
			if pj_rot_skittergate_parent and pj_rot_skittergate_parent:Width() ~= 85 then
				pj_rot_skittergate_parent:Resize(85, pj_rot_skittergate_parent:Height())
			end

			local ui_parent = find_uicomponent(ui_root, "3d_ui_parent")
			if not ui_parent then return end

			if not mod.current_state then return end

			for i=0, ui_parent:ChildCount()-1 do
				local comp = UIComponent(ui_parent:Find(i))
				local id = comp:Id()
				if id ~= "label_settlement:wh_main_mountains_of_hel_altar_of_spawns" and id:starts_with("label_settlement") then
					comp = find_uicomponent(comp, "list_parent", "list", "faction_symbol_holder")
					local skittergate_button_parent = core:get_or_create_component("pj_skittergate_settlement_button_parent", "UI/campaign ui/script_dummy", comp)
					local skittergate_button = core:get_or_create_component("pj_skittergate_settlement_button", "ui/templates/round_large_button", skittergate_button_parent)
					if mod.current_state.name ~= "usable" then
						skittergate_button_parent:SetVisible(false)
					else
						skittergate_button_parent:SetVisible(true)
						skittergate_button_parent:SetDockingPoint(1)
						skittergate_button_parent:SetDockOffset(-25, 15)
						skittergate_button:SetDockingPoint(1)
						skittergate_button:SetDockOffset(0, 0)
						if skittergate_button:Width() ~= 48 then
							skittergate_button:SetCanResizeHeight(true)
							skittergate_button:SetCanResizeWidth(true)
							skittergate_button:Resize(48, 48)
							skittergate_button:SetImagePath("ui/ovn/skittergate/skittergate_button_green.png", 0)
							skittergate_button:SetTooltipText("Open The Skittergate||The Skittergate will connect the Altar of Spawns with this settlement!", true)
						end
					end
				end
			end

			local rotbloods = cm:get_faction("wh2_main_nor_rotbloods")
			if not rotbloods then return end

			local skittergate_exit_coordinates = mod.skittergate_exit_coordinates
			local skittergate_entrance_coordinates = mod.skittergate_entrance_coordinates

			---@type CA_CHAR
			for char in binding_iter(rotbloods:character_list()) do
				local has_military_force = char:has_military_force()
				if not has_military_force and not char:is_embedded_in_military_force()
					or has_military_force and not char:military_force():is_armed_citizenry()
				then
					local comp_address = ui_parent:Find("label_"..char:command_queue_index())
					if comp_address then
						local comp = UIComponent(comp_address)
						local char_x, char_y = char:logical_position_x(), char:logical_position_y()

						if skittergate_exit_coordinates and skittergate_entrance_coordinates then
							local exit_dist_sq = distance_squared(char_x, char_y, skittergate_exit_coordinates.x, skittergate_exit_coordinates.y)
							local entrance_dist_sq = distance_squared(char_x, char_y, skittergate_entrance_coordinates.x, skittergate_entrance_coordinates.y)
							mod.handle_char_ui_label(comp, char:command_queue_index(), exit_dist_sq < 4 or entrance_dist_sq < 4)
						else
							mod.handle_char_ui_label(comp, char:command_queue_index(), false)
						end
					end
				end
			end
	end,
	true
)

core:remove_listener('ovn_rot_skittergate_dialogue_confirm_region_ticked')
core:add_listener(
	'ovn_rot_skittergate_dialogue_confirm_region_ticked',
	'ComponentLClickUp',
	function(context)
		return context.string == "button_tick"
			and UIComponent(UIComponent(UIComponent(context.component):Parent()):Parent()):Id() == "ovn_rot_skittergate_dialogue_confirm_region"
	end,
	function(context)
		cm:set_saved_value("pj_rot_skittergate_current_region", mod.next_region_key)
		mod.switch_state(mod.states.active, mod.current_state)
	end,
	true
)

core:remove_listener('ovn_rot_skittergate_dialogue_confirm_close_skittergate_ticked')
core:add_listener(
	'ovn_rot_skittergate_dialogue_confirm_close_skittergate_ticked',
	'ComponentLClickUp',
	function(context)
		return context.string == "button_tick"
			and UIComponent(UIComponent(UIComponent(context.component):Parent()):Parent()):Id() == "ovn_rot_skittergate_dialogue_confirm_close_skittergate"
	end,
	function(context)
		mod.switch_state(mod.states.cooldown, mod.current_state)
	end,
	true
)

core:remove_listener('ovn_rot_skittergate_close_skittergate')
core:add_listener(
	'ovn_rot_skittergate_close_skittergate',
	'ComponentLClickUp',
	function(context)
		return context.string == "pj_rot_skittergate" and mod.current_state.name == "active"
	end,
	function(context)
		local dialogue_box = core:get_or_create_component("ovn_rot_skittergate_dialogue_confirm_close_skittergate", "ui/common ui/dialogue_box")
		core:add_listener(
			"ovn_rot_skittergate_dialogue_confirm_close_skittergate",
			"RealTimeTrigger",
			function(context)
				return context.string == "ovn_rot_skittergate_dialogue_confirm_close_skittergate_real_timer"
			end,
			function()
				local dialogue_text = find_ui_component_str("root > ovn_rot_skittergate_dialogue_confirm_close_skittergate > DY_text")
				dialogue_text:SetStateText("Would you like to close the Skittergate? You will be able to use it again after a few turns of necessary maintenance.")
			end,
			false
		)
		real_timer.register_singleshot("ovn_rot_skittergate_dialogue_confirm_close_skittergate_real_timer", 0)
	end,
	true
)

core:remove_listener('ovn_rot_skittergate_region_button_clicked')
core:add_listener(
	'ovn_rot_skittergate_region_button_clicked',
	'ComponentLClickUp',
	function(context)
		return context.string == "pj_skittergate_settlement_button"
	end,
	function(context)
		local comp = UIComponent(context.component)
		local dialogue_box = core:get_or_create_component("ovn_rot_skittergate_dialogue_confirm_region", "ui/common ui/dialogue_box")
		core:add_listener(
			"pj_ai_unit_upgrades_real_time_trigger_11",
			"RealTimeTrigger",
			function(context)
				return context.string == "pj_ai_unit_upgrades_real_time_trigger_1"
			end,
			function(context)
				for _=1, 5 do
					comp = UIComponent(comp:Parent())
				end
				local region_key = comp:Id():gsub("label_settlement:", "")

				local a = find_ui_component_str("root > ovn_rot_skittergate_dialogue_confirm_region > DY_text")
				a:SetStateText("Would you like connect the Altar of Spawns with "
					..effect.get_localised_string("regions_onscreen_"..tostring(region_key))
					.." using the Skittergate?")
			end,
			false
		)
		real_timer.register_singleshot("pj_ai_unit_upgrades_real_time_trigger_1", 0)

		local comp = UIComponent(context.component)
		for _=1, 5 do
			comp = UIComponent(comp:Parent())
		end
		local region_key = comp:Id():gsub("label_settlement:", "")

		mod.next_region_key = region_key
	end,
	true
)

core:remove_listener('ovn_rot_skittergate_char_button_clicked')
core:add_listener(
	'ovn_rot_skittergate_char_button_clicked',
	'ComponentLClickUp',
	function(context)
		return context.string:starts_with("ovn_sk_char_button_")
	end,
	function(context)
		local char_cqi = context.string:gsub("ovn_sk_char_button_", "")
		if not tonumber(char_cqi) then return end
		local char = cm:get_character_by_cqi(char_cqi)
		if not char then return end

		local skittergate_exit_coordinates = mod.skittergate_exit_coordinates
		local skittergate_entrance_coordinates = mod.skittergate_entrance_coordinates
		local char_x, char_y = char:logical_position_x(), char:logical_position_y()
		local exit_dist_sq = distance_squared(char_x, char_y, skittergate_exit_coordinates.x, skittergate_exit_coordinates.y)
		local entrance_dist_sq = distance_squared(char_x, char_y, skittergate_entrance_coordinates.x, skittergate_entrance_coordinates.y)

		local new_coords = skittergate_exit_coordinates
		if exit_dist_sq < entrance_dist_sq then
			new_coords = skittergate_entrance_coordinates
		end

		local x, y = cm:find_valid_spawn_location_for_character_from_position(
			"wh2_main_nor_rotbloods",
			new_coords.x,
			new_coords.y,
			false,
			0
		)
		if x == -1 then return end

		cm:teleport_to(cm:char_lookup_str(char_cqi), x, y, false)
		cm:callback(function()
			cm:scroll_camera_with_cutscene_to_character(2, nil, tonumber(char_cqi))
		end, 0.5)
	end,
	true
)

local rotblood_region_visiblity_techs = {
	tech_dlc08_nor_other_13 = true,
	tech_dlc08_nor_nw_01 = true,
	tech_dlc08_nor_other_06 = true,
}

core:remove_listener("pj_ovn_rotbloods_on_tech_researched")
core:add_listener(
	"pj_ovn_rotbloods_on_tech_researched",
	"ResearchCompleted",
	function(context)
		return context:faction():name() == rotblood_faction_key and context:faction():is_human()
	end,
	function(context)
		local tech = context:technology()
		if tech == "rot_tech_skv_3" then
			cm:set_saved_value("pj_rot_tech_skv_3_completed", true)
		end
		if tech == "rot_tech_skv_4" then
			cm:set_saved_value("pj_rot_tech_skv_4_completed", true)
		end

		if rotblood_region_visiblity_techs[tech] then
			cm:set_saved_value("pj_rot_"..tostring(tech).."_completed", true)
		end
	end,
	true
)

cm:add_first_tick_callback(function()
	if cm:get_local_faction_name(true) ~= "wh2_main_nor_rotbloods" then
		return
	end

	if cm:is_multiplayer() then
		return
	end

	mod.init()

	real_timer.unregister("ovn_rot_sk_real_time")
	real_timer.register_repeating("ovn_rot_sk_real_time", 0)
end)

if debug.traceback():find('pj_loadfile') then
	mod.init()

	real_timer.unregister("ovn_rot_sk_real_time")
	real_timer.register_repeating("ovn_rot_sk_real_time", 0)
end

-- mod.switch_state(mod.states.usable)
-- dout(mod.current_state.name)
-- cm:set_saved_value("pj_rot_skittergate_current_cooldown", 1)

-- mod.current_state = mod.states.cooldown
-- mod.current_state:init()
-- mod.switch_state(mod.states.usable, mod.states.cooldown)
-- mod.switch_state(mod.states.active, mod.states.usable)
