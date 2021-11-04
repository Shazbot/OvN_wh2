---@return CA_UIC
local digForComponent = function(startingComponent, componentName, max_depth)
	local function digForComponent_iter(startingComponent, componentName, max_depth, current_depth)
		local childCount = startingComponent:ChildCount()
		for i=0, childCount-1  do
				local child = UIComponent(startingComponent:Find(i))
				if child:Id() == componentName then
						return child
				else
					if not max_depth or current_depth+1 <= max_depth then
						local dugComponent = digForComponent_iter(child, componentName, max_depth, current_depth+1)
						if dugComponent then
								return dugComponent
						end
					end
				end
		end
		return nil
	end

	return digForComponent_iter(startingComponent, componentName, max_depth, 1)
end

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

local move_rel = function(comp, comp_pivot, x_offset, y_offset)
	local x, y = comp_pivot:Position()
	comp:MoveTo(x+x_offset, y+y_offset)
end

local starting_lord = nil

local trees = {
	"zhatan",
	"immortal",
	"draz"
}
local tree_to_x_offset = {
	draz = 23,
	immortal = 535,
	zhatan = 1049,
}
local tree_to_x_offset_div = {
	draz = 27,
	immortal = 535+4,
	zhatan = 1049,
}
local tree_to_locked_x_offset = {
	draz = 0,
	immortal = 1,
	zhatan = 1,
}

local tree_to_favor = {
	draz = "The Black Fortress",
	immortal = "Zharr-Naggrund",
	zhatan = "Ghorth the Cruel",
}

local tree_to_unlocked_tier = {
	zhatan = 0,
	immortal = 0,
	draz = 0,
}

local tree_to_bundle = {
	zhatan = "pj_zhatan",
	immortal = "pj_immortal",
	draz = "pj_draz",
}

local tree_to_img = {
	zhatan = "ui/pj_chorf_panel/tier1.png",
	immortal = "ui/pj_chorf_panel/tier2.png",
	draz = "ui/pj_chorf_panel/tier3.png",
}

--- Moved to first tick so we can fill with loc values.
local tree_to_bonuses = {
}

local unit_to_give = {
	["slave_ogre"] = true,
	["bull_centaur_render"] = true,
	["infernal_guard_acolytes"] = true,
	["immortals"] = true,
	["infernal_guard"] = true,
	["infernal_guard_great_weapons"] = true,
	["infernal_guard_deathmask_naphta"] = true,
	["chaos_dwarf_annihilators"] = true,
}

local show_unit_tutorial_on_panel_close = false

-- remove units we gave via the mercenary pool
core:remove_listener("pj_chorf_panel_on_unit_trained")
core:add_listener(
	"pj_chorf_panel_on_unit_trained",
	"UnitTrained",
	function()
		return true
	end,
	function(context)
		---@type CA_UNIT
		local unit = context:unit()

		if unit:faction():name() ~= "wh2_main_ovn_chaos_dwarfs" then return end

		if unit:has_force_commander() then
			local fc = unit:force_commander()
			if not fc or fc:is_null_interface() then return end

			local reg = fc:region()
			if not reg or reg:is_null_interface() then return end

			if not unit_to_give[unit:unit_key()]  then return end

			cm:add_unit_to_faction_mercenary_pool(
				unit:faction(),
					unit:unit_key(),
					0, -- unit count
					0, -- replenishment
					0, -- max_units
					0, -- max_units_replenished_per_turn
					4, -- xplevel
					"",
					"",
					"",
					false
				)
		end
	end,
	true
)

local just_gave_free_unit = false

--- Highlight the mercenaries of renown UI button or turn highlighting off.
local function toggle_renown_button_highlight(toggle_on)
	local button_group_army = find_ui_component_str("root > layout > hud_center_docker > hud_center > small_bar > button_group_army")
	if button_group_army and button_group_army:Visible() then
		local button_renown = find_uicomponent(button_group_army, "button_renown")
		if button_renown and button_renown:Visible() then
			if toggle_on then
				button_renown:StartPulseHighlight(5)
				return true
			else
				button_renown:StopPulseHighlight()
			end
		end
	end
end

local function give_unit(unit_key)
	cm:add_unit_to_faction_mercenary_pool(
		cm:get_faction("wh2_main_ovn_chaos_dwarfs"),
		unit_key,
		1, -- unit count
		0, -- replenishment
		1, -- max_units
		0, -- max_units_replenished_per_turn
		0, -- xplevel
		"",
		"",
		"",
		false
	)

	local succesfully_applied_highlight = toggle_renown_button_highlight(true)
	if not succesfully_applied_highlight then
		just_gave_free_unit = true
	end

	if not cm:get_saved_value("ovn_chorfs_unit_tutorial_was_shown") then
		show_unit_tutorial_on_panel_close = true
		cm:set_saved_value("ovn_chorfs_unit_tutorial_was_shown", true)
end
end

local function unclock_ror(unit_key)
	cm:remove_event_restricted_unit_record_for_faction(unit_key, "wh2_main_ovn_chaos_dwarfs")
end

local tree_to_other_bonuses = {
	zhatan = {
		{
			function()
				give_unit("slave_ogre")
			end
		},
		{},
		{
			function()
				unclock_ror("magma_beasts")
			end
		},
		{
			function()
				unclock_ror("bull_centaur_ba'hal_guardians")
			end
		},
		{
			function()
				unclock_ror("wh_pro04_chs_art_hellcannon_ror_0")
			end
		},
		{
			function()
				if starting_lord ~= "pj_chorf_panel_starting_lord_zhatan" then
					cm:spawn_character_to_pool("wh2_main_ovn_chaos_dwarfs", "names_name_995467592", "names_name_995467595", "", "", 18, true, "general", "zhatan_the_black", true, "")
				end
			end
		}
	},
	immortal = {
		{
			function()
				give_unit("bull_centaur_render")
			end
		},
		{
			function()
				unclock_ror("chaos_dwarf_warriors_horde")
			end
		},
		{
			function()
				give_unit("infernal_guard_acolytes")
			end
		},
		{
			function()
				give_unit("immortals")
			end
		},
		{
			function()
				give_unit("chaos_dwarf_annihilators")
			end
		},
		{
			function()
				unclock_ror("granite_guard")
				if starting_lord ~= "pj_chorf_panel_starting_lord_immortal" then
					cm:spawn_character_to_pool("wh2_main_ovn_chaos_dwarfs", "names_name_995467591", "names_name_995467594", "", "", 18, true, "general", "rykarth_the_unbreakable", true, "")
				end
			end
		}
	},
	draz = {
		{
			function()
				unclock_ror("infernal_guard")
				give_unit("infernal_guard")
			end
		},
		{},
		{
			function()
				give_unit("infernal_guard_great_weapons")
				unclock_ror("infernal_guard_great_weapons")
			end
		},
		{
			function()
			end
		},
		{
			function()
				give_unit("infernal_guard_deathmask_naphta")
				unclock_ror("infernal_guard_deathmask_naphta")
			end
		},
		{
			function()
				if starting_lord ~= "pj_chorf_panel_starting_lord_ash" then
					cm:spawn_character_to_pool("wh2_main_ovn_chaos_dwarfs", "names_name_995467590", "names_name_995467593", "", "", 18, true, "general", "drazhoath_the_ashen", true, "")
				end
				unclock_ror("ironsworn")
				cm:set_saved_value("pj_chorf_panel_heal_infernals_after_battle", true)
			end
		}
	},
}

local tree_to_effect_bonuses = {
	zhatan = {
		{
			{"ads_slave_upkeep", "faction_to_force_own_unseen", -8},
			{"ovn_chorfs_effect_hobgoblin_lords_recruitment_rank",	"faction_to_province_own_unseen", 2},
		},
		{
			{"wh_main_effect_agent_enable_recruitment_wizard_chaos_chorfs", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_recruitment_xp_wizard_chaos_chorfs", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_cap_increase_wizard_chaos_sorcerer_chorfs", "faction_to_faction_own_unseen", 1}
		},
		{
			{"wh_main_effect_military_force_winds_of_magic_depletion_mod_other", "faction_to_force_own", 4},
			{"wh_main_effect_military_force_winds_of_magic_starting_mod", "faction_to_force_own", 2},
			{"pj_chorf_panel_unlock_ror_magma_beasts", "faction_to_faction_own_unseen", 1},
		},
		{
			{"wh_main_effect_agent_recruitment_xp_wizard_chaos_chorfs", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_cap_increase_wizard_chaos_sorcerer_chorfs", "faction_to_faction_own_unseen", 1},
			{"wh_main_effect_military_force_winds_of_magic_depletion_mod_other", "faction_to_force_own", 4},
			{"wh_main_effect_military_force_winds_of_magic_starting_mod", "faction_to_force_own", 2},
			{"pj_chorf_panel_unlock_ror_bull_centaur_ba'hal_guardians", "faction_to_faction_own_unseen", 1},
		},
		{
			{"wh_main_effect_agent_recruitment_xp_wizard_chaos_chorfs", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_cap_increase_wizard_chaos_sorcerer_chorfs", "faction_to_faction_own_unseen", 1},
			{"wh_main_effect_military_force_winds_of_magic_depletion_mod_other", "faction_to_force_own", 4},
			{"wh_main_effect_military_force_winds_of_magic_starting_mod", "faction_to_force_own", 2},
			{"pj_chorf_panel_unlock_ror_wh_pro04_chs_art_hellcannon_ror_0", "faction_to_faction_own_unseen", 1},
		},
		{
			{"wh_main_effect_military_force_winds_of_magic_depletion_mod_other", "faction_to_force_own", 4},
			{"wh_main_effect_military_force_winds_of_magic_starting_mod", "faction_to_force_own", 2},
		},
	},
	immortal = {
		{
			{"ads_chaosdwarf_upkeep", "faction_to_force_own_unseen", -5},
			{"wh_main_effect_public_order_global", "faction_to_province_own", 1},
		},
		{
			{"wh_main_faction_xp_increase_generals", "province_to_province_own_factionwide", 1},
			{"pj_chorf_panel_unlock_ror_chaos_dwarf_warriors_horde", "faction_to_faction_own_unseen", 1},
			{"wh_main_effect_public_order_global", "faction_to_province_own", 1},
		},
		{
			{"pj_chorfs_acolytes_upkeep", "faction_to_force_own_unseen", -5},
			{"wh_main_effect_public_order_global", "faction_to_province_own", 1},
		},
		{
			{"pj_chorfs_immortals_upkeep", "faction_to_force_own_unseen", -5},
			{"wh_main_effect_unit_recruitment_points", "faction_to_province_own_unseen", 1},
			{"wh_main_faction_xp_increase_generals", "province_to_province_own_factionwide", 1},
		},
		{
			{"pj_chorfs_immortals_upkeep", "faction_to_force_own_unseen", -5},
			{"pj_chorfs_acolytes_upkeep", "faction_to_force_own_unseen", -5},
			{"wh_dlc05_effect_global_recruitment_duration_all", "faction_to_faction_own_unseen", -1}
		},
		{
			{"pj_chorf_panel_unlock_ror_granite_guard", "faction_to_faction_own_unseen", 1},
			{"wh_main_faction_xp_increase_generals", "province_to_province_own_factionwide", 1},
		}
	},
	draz = {
		{
			{"pj_chorfs_infernals_upkeep", "faction_to_force_own_unseen", -5},
			{"pj_chorfs_infernals_xp", "faction_to_province_own_unseen", 1},
			{"pj_chorfs_unlock_infernals", "faction_to_faction_own_unseen", 1}
		},
		{
			{"wh_main_effect_agent_recruitment_xp_champion_chaos_chorfs", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_cap_increase_champion_exalted_hero_chorfs", "faction_to_faction_own_unseen", 1},
			{"wh_main_effect_agent_enable_recruitment_champion_chaos_chorfs", "faction_to_province_own_unseen", 1}
		},
		{
			{"pj_chorfs_infernals_upkeep", "faction_to_force_own_unseen", -5},
			{"pj_chorfs_infernals_xp", "faction_to_province_own_unseen", 1}
		},
		{
			{"pj_chorfs_unlock_infernals_fireglaive", "faction_to_faction_own_unseen", 1},
			{"pj_chorfs_infernals_xp", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_recruitment_xp_champion_chaos_chorfs", "faction_to_province_own_unseen", 1},
			{"wh_main_effect_agent_cap_increase_champion_exalted_hero_chorfs", "faction_to_faction_own_unseen", 1},
			{"pj_chorfs_infernals_fatigue", "faction_to_force_own", -20},
		},
		{
			{"pj_chorfs_unlock_infernals_naptha", "faction_to_faction_own_unseen", 1},
			{"pj_chorfs_infernals_upkeep", "faction_to_force_own_unseen", -5},
			{"pj_chorfs_infernals_md", "faction_to_force_own", 5},
		},
		{
			{"pj_chorf_panel_unlock_ror_ironsworn", "faction_to_faction_own_unseen", 1},
			{"pj_chorfs_infernals_heal", "faction_to_faction_own_unseen", 1},
		}
	},
}

local function get_cost()
	local total_unlocked_tiers = 0
	for _, unlocked_tiers_in_tree in pairs(tree_to_unlocked_tier) do
		total_unlocked_tiers = total_unlocked_tiers + unlocked_tiers_in_tree
	end
	return 100 + (total_unlocked_tiers*100)
end

local function faction_has_enough_slaves(num_slaves_req)
	local f = cm:get_faction(cm:get_local_faction_name(true))
	return num_slaves_req <= f:num_faction_slaves()
end

local function get_tooltip(tree_name, index)
	local is_unlocked = tree_to_unlocked_tier[tree_name] > index
	local is_too_far_up = tree_to_unlocked_tier[tree_name]+1 <= index

	local tooltip = effect.get_localised_string("pj_chorf_panel_script_tree_tribute_for_"..tree_name).."\n\n"
	if is_unlocked then
		tooltip = tooltip..effect.get_localised_string("pj_chorf_panel_script_tree_tribute_fulfilled")
	elseif is_too_far_up then
		tooltip = tooltip..effect.get_localised_string("pj_chorf_panel_script_tree_tribute_fulfill_previous")
	else
		if not faction_has_enough_slaves(get_cost()) then
			local not_enough_slaves_loc = effect.get_localised_string("pj_chorf_panel_script_tree_other_1")
			not_enough_slaves_loc = not_enough_slaves_loc:gsub("SLAVE_COST_REPLACEMENT", get_cost())
			tooltip = tooltip..not_enough_slaves_loc
		else
			local has_enough_slaves_loc = effect.get_localised_string("pj_chorf_panel_script_tree_other_2")
			has_enough_slaves_loc = has_enough_slaves_loc:gsub("SLAVE_COST_REPLACEMENT", get_cost())
			tooltip = tooltip..has_enough_slaves_loc
		end
	end
	tooltip = tooltip.."\n"
	if is_unlocked then
		tooltip = tooltip.."\n"..effect.get_localised_string("pj_chorf_panel_script_earned_"..tree_name).."\n"
	else
		tooltip = tooltip.."\n"..effect.get_localised_string("pj_chorf_panel_script_will_earn_"..tree_name).."\n"
	end
	for i, bonus in ipairs(tree_to_bonuses[tree_name][index+1]) do
		tooltip = tooltip.."".."[[col:green]]"..bonus.."[[/col]]\n"
		if i ~= #tree_to_bonuses[tree_name][index+1] then
			tooltip = tooltip.."\n"
		end
	end
	return tooltip
end

local function draw_moving_parts()
	local ui_root = core:get_ui_root()
	local chorf_panel = digForComponent(ui_root, "pj_chorf_panel", 1)
	if not chorf_panel then return end

	local char_panel_width_ration = 0.335
	local panel_w = chorf_panel:Width()

	for tree_index, tree_name in ipairs(trees) do
		local tree_x = tree_to_x_offset[tree_name]
		local tree_x_div = tree_to_x_offset_div[tree_name]
		local locked_x_offset = tree_to_locked_x_offset[tree_name]
		local unlocked_tier = tree_to_unlocked_tier[tree_name]
		local tree_img = tree_to_img[tree_name]
		for i=0, 5 do
			local div = digForComponent(chorf_panel, "pj_chorf_panel_divider_"..tree_name.."_"..i)
			if not div then
				div = UIComponent(chorf_panel:CreateComponent("pj_chorf_panel_divider_"..tree_name.."_"..i, "ui/templates/custom_image"))
			end
			if div then
				div:SetImagePath("ui/pj_chorf_panel/panel_back_divider.png", 4)
				div:Resize(panel_w*0.912*char_panel_width_ration, 5)
				move_rel(div, chorf_panel, tree_x_div, 700-(i*100))
				local is_visible = i-1 < unlocked_tier
				div:SetVisible(is_visible)
			end
		end

		for i=0, 5 do
			local up = digForComponent(chorf_panel, "pj_chorf_panel_tier_"..tree_name.."_"..i)
			if not up then
				up = UIComponent(chorf_panel:CreateComponent("pj_chorf_panel_tier_"..tree_name.."_"..i, "ui/templates/custom_image"))
			end
			if up then
				up:SetImagePath(tree_img, 4)
				up:Resize(558/3, 283/3)
				move_rel(up, chorf_panel, tree_x+147+5, 610-(i*100))
				up:SetOpacity(255)
				up:SetVisible(true)
				local tooltip = get_tooltip(tree_name, i)
				up:SetTooltipText(tooltip, true)

				if i > unlocked_tier then up:SetOpacity(0) end
				if i == unlocked_tier then up:SetOpacity(150) end
			end
		end

		for i=0, 5 do
			local up = digForComponent(chorf_panel, "pj_chorf_panel_locked_tier_"..tree_name.."_"..i)
			if not up then
				up = UIComponent(chorf_panel:CreateComponent("pj_chorf_panel_locked_tier_"..tree_name.."_"..i, "ui/templates/custom_image"))
			end
			if up then
				up:SetImagePath("ui/pj_chorf_panel/unit_renown_locked_overlay.png", 4)
				up:Resize(72, 89)
				move_rel(up, chorf_panel, tree_x+locked_x_offset+201+5, 610-(i*100))
				up:SetOpacity(255)
				local is_visible = i == unlocked_tier
				up:SetVisible(is_visible)
				local tooltip = get_tooltip(tree_name, i)
				up:SetTooltipText(tooltip, true)
				if i == 2 then up:SetOpacity(255) end
			end
		end
	end
end

local function draw_panel()
	local ui_root = core:get_ui_root()
	local chorf_panel = digForComponent(core:get_ui_root(), "pj_chorf_panel", 1)
	if not chorf_panel then
		chorf_panel = UIComponent(ui_root:CreateComponent("pj_chorf_panel", "ui/campaign ui/temples_of_the_old_ones"))
	end

	local panel_w, panel_h = chorf_panel:Width(), chorf_panel:Height()
	local char_panel_width_ration = 0.335

	local panel_back_top = digForComponent(chorf_panel, "panel_back_top")
	if not panel_back_top then
		panel_back_top = UIComponent(chorf_panel:CreateComponent("panel_back_top", "ui/templates/custom_image"))
	end
	if panel_back_top then
		panel_back_top:SetImagePath("ui/pj_chorf_panel/panel_back_top.png", 4)
		panel_back_top:MoveTo(179,200-52)
		panel_back_top:Resize(216*2.5,220*3.5)
		panel_back_top:Resize(panel_w*char_panel_width_ration,panel_h*0.87)
		move_rel(panel_back_top, chorf_panel, 4, 50)
	end

	local ash = digForComponent(chorf_panel, "ash")
	if not ash then
		ash = UIComponent(chorf_panel:CreateComponent("ash", "ui/templates/custom_image"))
	end
	if ash then
		ash:SetImagePath("ui/pj_chorf_panel/ash.png", 4)
		ash:Resize(panel_w*char_panel_width_ration, panel_h*0.87)
		move_rel(ash, panel_back_top, 0, 0)
	end

	local panel_back_top2 = digForComponent(chorf_panel, "panel_back_top2")
	if not panel_back_top2 then
		panel_back_top2 = UIComponent(chorf_panel:CreateComponent("panel_back_top2", "ui/templates/custom_image"))
	end
	if panel_back_top2 then
		panel_back_top2:SetImagePath("ui/pj_chorf_panel/panel_back_top.png", 4)
		panel_back_top2:Resize(panel_w*char_panel_width_ration,panel_h*0.87)
		move_rel(panel_back_top2, chorf_panel, 4+511, 50)
	end

	local bg2 = digForComponent(chorf_panel, "bg2")
	if not bg2 then
		bg2 = UIComponent(chorf_panel:CreateComponent("bg2", "ui/templates/custom_image"))
	end
	if bg2 then
		bg2:SetImagePath("ui/pj_chorf_panel/bg.png", 4)
		bg2:Resize(panel_w*char_panel_width_ration*0.912, panel_h*0.87*0.915)
		move_rel(bg2, panel_back_top2, panel_w*0.016,  panel_h*0.035)
	end

	local immortal = digForComponent(chorf_panel, "immortal")
	if not immortal then
		immortal = UIComponent(chorf_panel:CreateComponent("immortal", "ui/templates/custom_image"))
	end
	if immortal then
		immortal:SetImagePath("ui/pj_chorf_panel/immortal.png", 4)
		immortal:Resize(panel_w*char_panel_width_ration*1.09804*0.95, panel_h*0.87*0.67882*0.95)
		immortal:Resize(panel_w*char_panel_width_ration*1.09804*0.95, panel_w*char_panel_width_ration*1.09804*0.95*484/560)
		move_rel(immortal, panel_back_top2, -panel_w*0.01923, panel_h*0.3)
	end

	local panel_back_top3 = digForComponent(chorf_panel, "panel_back_top3")
	if not panel_back_top3 then
		panel_back_top3 = UIComponent(chorf_panel:CreateComponent("panel_back_top3", "ui/templates/custom_image"))
	end
	if panel_back_top3 then
		panel_back_top3:SetImagePath("ui/pj_chorf_panel/panel_back_top.png", 4)
		panel_back_top3:Resize(panel_w*char_panel_width_ration,panel_h*0.87)
		move_rel(panel_back_top3, chorf_panel, 4+511+510, 50)
	end

	local bg3 = digForComponent(chorf_panel, "bg3")
	if not bg3 then
		bg3 = UIComponent(chorf_panel:CreateComponent("bg3", "ui/templates/custom_image"))
	end
	if bg3 then
		bg3:SetImagePath("ui/pj_chorf_panel/bg.png", 4)
		bg3:Resize(panel_w*char_panel_width_ration*0.912, panel_h*0.87*0.915)
		move_rel(bg3, panel_back_top3, panel_w*0.016,  panel_h*0.035)
	end

	local zhatan = digForComponent(chorf_panel, "zhatan")
	if not zhatan then
		zhatan = UIComponent(chorf_panel:CreateComponent("zhatan", "ui/templates/custom_image"))
	end
	if zhatan then
		zhatan:SetImagePath("ui/pj_chorf_panel/zhatan.png", 4)
		zhatan:Resize(panel_w*char_panel_width_ration*0.97, panel_w*char_panel_width_ration*0.97*713/510)
		move_rel(zhatan, panel_back_top3, panel_w*0.00128, panel_h*0.01744)
	end

	local header_ash = digForComponent(chorf_panel, "pj_header_ash")
	if not header_ash then
		local tx_header = digForComponent(chorf_panel, "tx_header")
		if tx_header then
			header_ash = UIComponent(tx_header:CopyComponent("pj_header_ash"))
		end
	end
	if header_ash then
		header_ash:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_1"))
		header_ash:PropagatePriority(200)
		header_ash:SetImagePath("ui/pj_chorf_panel/panel_title.png", 0)
		ash:Adopt(header_ash:Address())
		move_rel(header_ash, panel_back_top, 0, 0)
		header_ash:SetOpacity(255)
		move_rel(header_ash, panel_back_top, 10, -panel_h*0.02)

		local header_ash_tooltip = digForComponent(chorf_panel, "pj_header_ash_tooltip")
		if not header_ash_tooltip then
			header_ash_tooltip = UIComponent(chorf_panel:CreateComponent("pj_header_ash_tooltip", "ui/templates/custom_image"))
		end
		if header_ash_tooltip then
			header_ash_tooltip:SetImagePath("ui/pj_chorf_panel/trans.png", 4)
			header_ash_tooltip:Resize(panel_w*0.18, header_ash:Height())
			header_ash:Adopt(header_ash_tooltip:Address())
			move_rel(header_ash_tooltip, header_ash, panel_w*0.08, 0)
			header_ash_tooltip:SetTooltipText(
				effect.get_localised_string("pj_chorf_panel_script_inline_14"),
				true
			)
		end
	end

	local header_zhatan = digForComponent(chorf_panel, "pj_header_zhatan")
	if not header_zhatan then
		local tx_header = digForComponent(chorf_panel, "tx_header")
		if tx_header then
			header_zhatan = UIComponent(tx_header:CopyComponent("pj_header_zhatan"))
		end
	end
	if header_zhatan then
		header_zhatan:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_2"))
		header_zhatan:SetImagePath("ui/pj_chorf_panel/panel_title.png", 0)
		zhatan:Adopt(header_zhatan:Address())
		move_rel(header_zhatan, panel_back_top3, 15, -panel_h*0.02)

		local header_zhatan_tooltip = digForComponent(chorf_panel, "pj_header_zhatan_tooltip")
		if not header_zhatan_tooltip then
			header_zhatan_tooltip = UIComponent(chorf_panel:CreateComponent("pj_header_zhatan_tooltip", "ui/templates/custom_image"))
		end
		if header_zhatan_tooltip then
			header_zhatan_tooltip:SetImagePath("ui/pj_chorf_panel/trans.png", 4)
			header_zhatan_tooltip:Resize(panel_w*0.18, header_zhatan:Height())
			header_zhatan:Adopt(header_zhatan_tooltip:Address())
			move_rel(header_zhatan_tooltip, header_zhatan, panel_w*0.08, 0)
			header_zhatan_tooltip:SetTooltipText(
				effect.get_localised_string("pj_chorf_panel_script_inline_15"),
				true
			)
		end
	end

	local header_immortal = digForComponent(chorf_panel, "pj_header_immortal")
	if not header_immortal then
		local tx_header = digForComponent(chorf_panel, "tx_header")
		if tx_header then
			header_immortal = UIComponent(tx_header:CopyComponent("pj_header_immortal"))
		end
	end
	if header_immortal then
		header_immortal:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_3"))
		header_immortal:SetImagePath("ui/pj_chorf_panel/panel_title.png", 0)
		immortal:Adopt(header_immortal:Address())
		move_rel(header_immortal, panel_back_top2, 25, -panel_h*0.02)

		local header_immortal_tooltip = digForComponent(chorf_panel, "pj_header_immortal_tooltip")
		if not header_immortal_tooltip then
			header_immortal_tooltip = UIComponent(chorf_panel:CreateComponent("pj_header_immortal_tooltip", "ui/templates/custom_image"))
		end
		if header_immortal_tooltip then
			header_immortal_tooltip:SetImagePath("ui/pj_chorf_panel/trans.png", 4)
			header_immortal_tooltip:Resize(panel_w*0.18, header_immortal:Height())
			header_immortal:Adopt(header_immortal_tooltip:Address())
			move_rel(header_immortal_tooltip, header_immortal, panel_w*0.08, 0)
			header_immortal_tooltip:SetTooltipText(
				effect.get_localised_string("pj_chorf_panel_script_inline_16"),
				true
			)
		end
	end

	local pj_parchment = digForComponent(chorf_panel, "pj_parchment")
	if not pj_parchment then
		pj_parchment = UIComponent(ash:CreateComponent("pj_parchment", "ui/templates/parchment_divider_title"))
	end
	if pj_parchment then
		pj_parchment:SetImagePath("ui/pj_chorf_panel/trans.png", 1)
		pj_parchment:SetImagePath("ui/pj_chorf_panel/trans.png", 2)
		pj_parchment:SetImagePath("ui/pj_chorf_panel/parchment_divider_title.png", 0)
		pj_parchment:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_4"))
		pj_parchment:Resize(300, pj_parchment:Height())
		pj_parchment:SetOpacity(200)
		move_rel(pj_parchment, panel_back_top, 115, 690)
		pj_parchment:SetTooltipText(effect.get_localised_string("pj_chorf_panel_script_inline_5"), true)
	end

	local pj_parchment_immortals = digForComponent(chorf_panel, "pj_parchment_immortals")
	if not pj_parchment_immortals then
		pj_parchment_immortals = UIComponent(immortal:CreateComponent("pj_parchment_immortals", "ui/templates/parchment_divider_title"))
	end
	if pj_parchment_immortals then
		pj_parchment_immortals:SetImagePath("ui/pj_chorf_panel/parchment_divider_title.png", 0)
		pj_parchment_immortals:SetImagePath("ui/pj_chorf_panel/trans.png", 1)
		pj_parchment_immortals:SetImagePath("ui/pj_chorf_panel/trans.png", 2)
		pj_parchment_immortals:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_6"))
		pj_parchment_immortals:Resize(300, pj_parchment_immortals:Height())
		pj_parchment_immortals:SetOpacity(200)
		move_rel(pj_parchment_immortals, panel_back_top2, 120, 690)
		pj_parchment_immortals:SetTooltipText(effect.get_localised_string("pj_chorf_panel_script_inline_7"), true)
	end

	local pj_parchment_zhatan = digForComponent(chorf_panel, "pj_parchment_zhatan")
	if not pj_parchment_zhatan then
		pj_parchment_zhatan = UIComponent(zhatan:CreateComponent("pj_parchment_zhatan", "ui/templates/parchment_divider_title"))
	end
	if pj_parchment_zhatan then
		pj_parchment_zhatan:SetImagePath("ui/pj_chorf_panel/parchment_divider_title.png", 0)
		pj_parchment_zhatan:SetImagePath("ui/pj_chorf_panel/trans.png", 1)
		pj_parchment_zhatan:SetImagePath("ui/pj_chorf_panel/trans.png", 2)
		pj_parchment_zhatan:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_8"))
		pj_parchment_zhatan:Resize(300, pj_parchment_zhatan:Height())
		pj_parchment_zhatan:SetOpacity(200)
		move_rel(pj_parchment_zhatan, panel_back_top3, 120, 690)
		pj_parchment_zhatan:SetTooltipText(effect.get_localised_string("pj_chorf_panel_script_inline_9"), true)
	end

	local header = digForComponent(chorf_panel, "header")
	local tx_header = digForComponent(header, "tx_header")
	if tx_header then
		tx_header:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_10"))
		tx_header:SetImagePath("ui/pj_chorf_panel/panel_title.png", 0)
	end

	draw_moving_parts()
	return chorf_panel
end

core:remove_listener('pj_chorf_panel_on_mouse_over')
core:add_listener(
	'pj_chorf_panel_on_mouse_over',
	'ComponentMouseOn',
	function(context)
		return context.string:starts_with("pj_chorf_panel_tier_")
	end,
	function(context)
		if cm:get_local_faction_name(true) ~= "wh2_main_ovn_chaos_dwarfs" then return end

		local comp = UIComponent(context.component)
		if comp:Opacity() ~= 0 then return end
			UIComponent(context.component):SetVisible(true)
			UIComponent(context.component):SetOpacity(150)

		core:add_listener(
			'pj_chorf_panel_on_mouse_over_restore_opacity',
			'ComponentMouseOn',
			function(context)
				return UIComponent(context.component) ~= comp
			end,
			function()
				comp:SetOpacity(0)
			end,
			false
		)
	end,
	true
)

local function open_chorf_panel()
local chorf_panel = digForComponent(core:get_ui_root(), "pj_chorf_panel", 1)
	if not chorf_panel then
		chorf_panel = draw_panel()
	end
	if not chorf_panel then return end

	draw_moving_parts()

	chorf_panel:SetVisible(true)
end

core:remove_listener('pj_chorf_panel_on_open_chorf_panel')
core:add_listener(
	'pj_chorf_panel_on_open_chorf_panel',
	'ComponentLClickUp',
	true,
	function(context)
		if context.string ~= "pj_button_chorf_panel" then return end
		if cm:get_local_faction_name(true) ~= "wh2_main_ovn_chaos_dwarfs" then return end

		-- this is dumb, but we're manually deselecting our button since it's actually a toggle button after we copied it
		cm:repeat_callback(function()
			local pj_button_chorf_panel = find_uicomponent(core:get_ui_root(), "layout", "faction_buttons_docker", "button_group_management", "pj_button_chorf_panel")
			if pj_button_chorf_panel:CurrentState() == "selected_hover" then
				pj_button_chorf_panel:SetState("hover")
				cm:remove_callback("pj_chorf_panel_deselect_chorf_panel_button")
			end
		end, 0, "pj_chorf_panel_deselect_chorf_panel_button")

		open_chorf_panel()
	end,
	true
)

local function create_unit_from_tribute_tutorial()
	local dialogue_box = core:get_or_create_component("ovn_chorfs_unit_tutorial", "ui/common ui/dialogue_box")
	core:add_listener(
		"ovn_chorfs_unit_tutorial_real_time_trigger_cb",
		"RealTimeTrigger",
		function(context)
			return context.string == "ovn_chorfs_unit_tutorial_real_time_trigger"
		end,
		function(context)
			local dialogue_box = find_uicomponent(core:get_ui_root(), "ovn_chorfs_unit_tutorial")
			if not dialogue_box then return end

			dialogue_box:SetCanResizeWidth(true)
			dialogue_box:SetCanResizeHeight(true)
			dialogue_box:Resize(600,850)
			local tutorial_text = find_uicomponent(dialogue_box, "DY_text")
			tutorial_text:SetStateText(string.format("[[col:white]]%s[[/col]]", effect.get_localised_string("ovn_chorfs_unit_tutorial_text")))
			tutorial_text:SetDockingPoint(5)
			tutorial_text:SetDockOffset(1,280)

			local button_cancel = find_uicomponent(dialogue_box, "both_group", "button_cancel")
			button_cancel:SetVisible(false)

			local button_tick = find_uicomponent(dialogue_box, "both_group", "button_tick")
			button_tick:SetDockingPoint(8)
			button_tick:SetDockOffset(0,-30)

			local bg_image = UIComponent(dialogue_box:CreateComponent("pj_selectable_start_bg_image", "ui/templates/custom_image"))
			bg_image:SetImagePath("ui/pj_chorf_panel/slave_tribute_unit_tutorial.png", 4)
			bg_image:SetDockingPoint(5)
			bg_image:SetCanResizeWidth(true)
			bg_image:SetCanResizeHeight(true)
			bg_image:Resize(542,542)
			bg_image:SetDockOffset(0,-115)
		end,
		false
	)
	real_timer.register_singleshot("ovn_chorfs_unit_tutorial_real_time_trigger", 0)
end

--- Close the panel.
core:remove_listener('pj_chorf_panel_on_close_chorf_panel')
core:add_listener(
	'pj_chorf_panel_on_close_chorf_panel',
	'ComponentLClickUp',
	true,
	function(context)
		if context.string ~= "button_ok" then return end
		if cm:get_local_faction_name(true) ~= "wh2_main_ovn_chaos_dwarfs" then return end

		local chorf_panel = digForComponent(core:get_ui_root(), "pj_chorf_panel", 1)
		if not chorf_panel then return end

		chorf_panel:SetVisible(false)

		if show_unit_tutorial_on_panel_close then
			create_unit_from_tribute_tutorial()
			show_unit_tutorial_on_panel_close = false
		end
	end,
	true
)

local function play_rite()
	local ui_root = core:get_ui_root()
	local rite = UIComponent(ui_root:CreateComponent("pj_chorf_rite", "ui/campaign ui/rite_performed"))
	for i = 0, rite:ChildCount() - 1 do
		local uic_child = UIComponent(rite:Find(i));
		uic_child:SetVisible(false)
	end;
	local wh2_main_def_hag_graef = digForComponent(rite, "wh2_main_def_hag_graef")
	wh2_main_def_hag_graef:SetVisible(true)
	for i = 0, wh2_main_def_hag_graef:ChildCount() - 1 do
		local uic_child = UIComponent(wh2_main_def_hag_graef:Find(i));
		if uic_child:Id() ~= "circle2" then
			uic_child:SetVisible(false)
		end
		if uic_child:Id() == "circle2" then
			uic_child:SetDockOffset(-10, 0)
			uic_child:SetImagePath("ui/pj_chorf_panel/rite_image.png", 0)
		end
		if uic_child:Id() == "text_holder" then
			uic_child:SetImagePath("ui/pj_chorf_panel/rite_text_background.png", 0)
			uic_child:SetVisible(true)
			uic_child:SetDockOffset(0, 24-24-25)
			local rite_text = find_uicomponent(uic_child, "tx_rite_reformed")
			if rite_text then
				rite_text:SetDockOffset(-15, 0)
				rite_text:SetStateText(effect.get_localised_string("pj_chorf_panel_script_inline_11"))
			end
		end
	end
end

core:remove_listener("pj_chorf_panel_upgrade_clicked_trigger")
core:add_listener("pj_chorf_panel_upgrade_clicked_trigger",
"UITrigger",
function(context)
    return context:trigger():starts_with("pj_chorf_panel_upgrade_clicked|")
end,
function(context)
	local hash_without_prefix = context:trigger():gsub("pj_chorf_panel_upgrade_clicked|", "")

	local args = {}
	hash_without_prefix:gsub("([^|]+)", function(w)
		if (type(w)=="string") then
			table.insert(args, w)
		end
	end)

	local faction_key, tree_name, tree_index, slaves_cost = args[1], args[2], args[3], tonumber(args[4])

	tree_to_unlocked_tier[tree_name] = tree_to_unlocked_tier[tree_name] + 1

	cm:modify_faction_slaves_in_a_faction(faction_key, -slaves_cost)

	for _, fun in ipairs(tree_to_other_bonuses[tree_name][tree_index+1]) do
		fun()
	end

	for tree_name, unlocked_tier in pairs(tree_to_unlocked_tier) do
		local upkeep_bundle = cm:create_new_custom_effect_bundle(tree_to_bundle[tree_name])
		local is_bundle_empty = true
		for i=0, unlocked_tier-1 do
			for _, packed_bonus in ipairs(tree_to_effect_bonuses[tree_name][i+1]) do
				upkeep_bundle:add_effect(unpack(packed_bonus))
				is_bundle_empty = false
			end
		end
		if not is_bundle_empty then
			cm:apply_custom_effect_bundle_to_faction(upkeep_bundle, cm:get_faction(faction_key))
		end
	end

	if cm:get_local_faction_name(true) == faction_key then
		core:remove_listener('pj_chorf_panel_on_mouse_over_restore_opacity')
		draw_moving_parts()

		play_rite()
	end
end,
true
)

local function upgrade_clicked(tree_name, tree_index)
	if tree_to_unlocked_tier[tree_name] ~= tree_index then return end

	local slaves_cost = get_cost()
	if not faction_has_enough_slaves(slaves_cost) then return end

	local faction_key = cm:get_local_faction_name(true)

	CampaignUI.TriggerCampaignScriptEvent(
		cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
		"pj_chorf_panel_upgrade_clicked|"..tostring(faction_key).."|"..tostring(tree_name).."|"..tostring(tree_index).."|"..tostring(slaves_cost)
	)
end

core:remove_listener('pj_chorf_panel_on_component_left_clicked')
core:add_listener(
	'pj_chorf_panel_on_component_left_clicked',
	'ComponentLClickUp',
	function(context)
		return context.string:starts_with("pj_chorf_panel_tier_") or context.string:starts_with("pj_chorf_panel_locked_tier_")
	end,
	function(context)
		if cm:get_local_faction_name(true) ~= "wh2_main_ovn_chaos_dwarfs" then return end

		local s = context.string
		local prefix = context.string:starts_with("pj_chorf_panel_tier_") and "pj_chorf_panel_tier_" or "pj_chorf_panel_locked_tier_"
		local tree_name, tree_index_as_string = s:match(prefix.."([^_]+)_(.+)")
		local tree_index = tonumber(tree_index_as_string)
		upgrade_clicked(tree_name, tree_index)
	end,
	true
)

local function create_slave_tribute_button()
	local ui_root = core:get_ui_root()

	local pj_button_chorf_panel = find_uicomponent(ui_root, "layout", "faction_buttons_docker", "button_group_management", "pj_button_chorf_panel")
	if not pj_button_chorf_panel then
		local button = find_uicomponent(ui_root, "layout", "faction_buttons_docker", "button_group_management", "button_diplomacy")
		pj_button_chorf_panel = UIComponent(button:CopyComponent("pj_button_chorf_panel"))
	end

	pj_button_chorf_panel:SetImagePath("ui/pj_chorf_panel/skull.png", 0)
	pj_button_chorf_panel:SetTooltipText(effect.get_localised_string("pj_chorf_panel_script_inline_12"), true)
end

local function spawn_starting_lord(subtype, forename, surname)
	cm:create_force_with_general(
		"wh2_main_ovn_chaos_dwarfs",
		"hobgoblin_wolf_bow_raider,hobgoblin_cuthroats,orc_slaves,chaos_dwarf_warriors,chaos_dwarf_warriors,chaos_dwarf_warriors_rifles",
		"wh2_main_the_plain_of_bones_ash_ridge_mountains",
		835,
		274,
		"general",
		subtype,
		forename,
		"",
		surname,
		"",
		true,
		function(cqi)
			cm:set_character_immortality("character_cqi:"..cqi, true)
			cm:set_character_unique("character_cqi:"..cqi, true);
		end
	)
end

local infernal_guard_units = {
	["infernal_guard"] = true,
	["infernal_guard_deathmask_naphta"] = true,
	["infernal_guard_great_weapons"] = true,
	["ironsworn"] = true,
}

local loser_hp_val = 0.2
local winner_hp_val = 0.2

---@param unit CA_UNIT
---@param additive_hp_val number
local adjust_health = function(unit, additive_hp_val)
	local hp = unit:percentage_proportion_of_full_strength()
	local new_hp = hp/100 + additive_hp_val
	cm:set_unit_hp_to_unary_of_maximum(unit, new_hp)
end

---@param unit CA_UNIT
local adjust_health_loser = function(unit)
	adjust_health(unit, loser_hp_val)
end

---@param unit CA_UNIT
local adjust_health_winner = function(unit)
	adjust_health(unit, winner_hp_val)
end

local adjust_mf_units = function(mf, hp_cb)
	if mf and not mf:is_null_interface() then
		for unit in binding_iter(mf:unit_list()) do
			if infernal_guard_units[unit:unit_key()] then
				hp_cb(unit)
			end
		end
	end
end

core:remove_listener("pj_chorf_panel_heal_infernals_trigger")
core:add_listener("pj_chorf_panel_heal_infernals_trigger",
"UITrigger",
function(context)
    return context:trigger():starts_with("pj_chorf_panel_heal_infernals|")
end,
function(context)
	local hash_without_prefix = context:trigger():gsub("pj_chorf_panel_heal_infernals|", "")

	local args = {}
	hash_without_prefix:gsub("([^|]+)", function(w)
			if (type(w)=="string") then
					table.insert(args, w)
			end
	end)

	local mf_cqi, attacker_defender_str = tonumber(args[1]), args[2]

	local heal_cb = adjust_health_winner
	if attacker_defender_str == "adjust_health_loser" then
		heal_cb = adjust_health_loser
	end

	local mf = cm:get_military_force_by_cqi(mf_cqi)
	adjust_mf_units(mf, heal_cb)
end)

--- healing infernal guard units after battle
core:remove_listener("pj_chorf_panel_on_battle_completed_cb")
core:add_listener(
	"pj_chorf_panel_on_battle_completed_cb",
	"BattleCompleted",
	true,
	function()
		if not cm:get_saved_value("pj_chorf_panel_heal_infernals_after_battle") then return end

		local is_winner_attacker = cm:pending_battle_cache_attacker_victory()

		if cm:pending_battle_cache_num_defenders() >= 1 then
			local defender_cb = is_winner_attacker and "adjust_health_loser" or "adjust_health_winner"
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local _, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
				---@type CA_MILITARY_FORCE
				local mf = cm:get_military_force_by_cqi(mf_cqi)
				if faction_name == cm:get_local_faction_name(true)
					and faction_name == "wh2_main_ovn_chaos_dwarfs"
					and mf and not mf:is_null_interface() then
					CampaignUI.TriggerCampaignScriptEvent(
						cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
						"pj_chorf_panel_heal_infernals|"..tostring(mf:command_queue_index()).."|"..tostring(defender_cb)
					)
				end
			end
		end

		if cm:pending_battle_cache_num_attackers() >= 1 then
			local attacker_cb = is_winner_attacker and "adjust_health_winner" or "adjust_health_loser"
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local _, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
				---@type CA_MILITARY_FORCE
				local mf = cm:get_military_force_by_cqi(mf_cqi)
				if faction_name == cm:get_local_faction_name(true)
					and faction_name == "wh2_main_ovn_chaos_dwarfs"
					and mf and not mf:is_null_interface() then
					CampaignUI.TriggerCampaignScriptEvent(
						cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
						"pj_chorf_panel_heal_infernals|"..tostring(mf:command_queue_index()).."|"..tostring(attacker_cb)
					)
				end
			end
		end
	end,
	true
)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("pj_chorf_panel_tree_unlocks", tree_to_unlocked_tier, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		tree_to_unlocked_tier = cm:load_named_value("pj_chorf_panel_tree_unlocks", tree_to_unlocked_tier, context)
	end
)

-- fix a missing icon for the event restricted infernal guard units
local function fix_missing_ui_icon(unit_component)
	local component = find_uicomponent(unit_component, "disabled_script")
	if component and component:Visible() then
		component:SetImagePath("ui/skins/default/bullet_point_locked.png", 0)
	end
end

core:remove_listener("pj_chorf_panel_on_panel_opened_units_recruitment")
core:add_listener(
	"pj_chorf_panel_on_panel_opened_units_recruitment",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "units_recruitment"
	end,
	function()
		if cm:get_local_faction_name(true) ~= "wh2_main_ovn_chaos_dwarfs" then return end

		local ig_units = {
			"infernal_guard_recruitable",
			"infernal_guard_deathmask_naphta_recruitable",
			"infernal_guard_great_weapons_recruitable"
		}

		local recruitment_listbox = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox")

		for _, intermediate_id in ipairs({"global", "local1", "local2"}) do
			local intermediate_parent = find_uicomponent(recruitment_listbox, intermediate_id)
			if intermediate_parent then
				for _, unit_key in ipairs(ig_units) do
					local unit_comp = find_ui_component_str(intermediate_parent, "unit_list > listview > list_clip > list_box > "..unit_key)
					if unit_comp then
						if unit_comp:CurrentState() == "inactive" then
							fix_missing_ui_icon(unit_comp)
							unit_comp:SetTooltipText(effect.get_localised_string("pj_chorf_panel_script_inline_13"), true)
						end
					end
				end
			end
		end
	end,
	true
)

if debug.traceback():find('pj_loadfile') then
	open_chorf_panel()
	draw_panel()
end

local function update_settings(mct)
	local my_mod = mct:get_mod_by_key("lost_factions")

	local starting_lord_option = my_mod:get_option_by_key("pj_chorf_panel_starting_lord")
	starting_lord = starting_lord_option:get_finalized_setting()
	starting_lord_option:set_read_only(true)
end

core:remove_listener("pj_chorf_panel_mct_init_cb")
core:add_listener(
	"pj_chorf_panel_mct_init_cb",
	"MctInitialized",
	true,
	function(context)
			local mct = context:mct()
			update_settings(mct)
	end,
	true
)

--- Highlight the mercenaries of renown UI button when we give the player a free unit.
core:remove_listener("pj_chorf_panel_CharacterSelected_renown_highlight")
core:add_listener(
"pj_chorf_panel_CharacterSelected_renown_highlight",
"CharacterSelected",
function(context)
	return context:character():character_type_key() == "general"
end,
function(context)
	cm:callback(
		function()
			local succesfully_applied_highlight = toggle_renown_button_highlight(just_gave_free_unit)
			if succesfully_applied_highlight and just_gave_free_unit then
				just_gave_free_unit = false
			end
		end,
		0
	)
end,
true
)

local function fill_loc_values()
	tree_to_bonuses = {
		zhatan = {
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_1"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_2"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_63"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_3"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_4"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_5"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_6"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_7"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_8"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_9"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_10"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_11"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_12"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_13"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_14"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_15"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_16"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_17"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_18"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_19"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_20"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_21"),
			},
		},
		immortal = {
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_22"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_23"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_24"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_25"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_26"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_27"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_28"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_29"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_30"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_31"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_32"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_33"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_34"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_64"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_35"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_36"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_37"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_38"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_39"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_40"),
			},
		},
		draz = {
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_41"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_42"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_43"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_44"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_45"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_46"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_47"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_48"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_49"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_50"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_51"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_52"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_53"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_54"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_55"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_56"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_57"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_58"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_59"),
			},
			{
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_60"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_61"),
				effect.get_localised_string("pj_chorf_panel_script_tree_rewards_62"),
			},
		},
	}
end

local function new_game_setup()
	local forename = "names_name_1611617482"
	local surname = "names_name_760507122"
	local subtype = "warrhak_skullcrusher"

	local chorf_faction_name = "wh2_main_ovn_chaos_dwarfs"
	if not cm:model():world():faction_exists(chorf_faction_name) then return end

	local chorf_faction = cm:get_faction(chorf_faction_name)
	if not chorf_faction or chorf_faction:is_null_interface() then return end

	if not chorf_faction:is_human() then
		cm:spawn_character_to_pool("wh2_main_ovn_chaos_dwarfs", "names_name_995467592", "names_name_995467595", "", "", 18, true, "general", "zhatan_the_black", true, "")
		cm:spawn_character_to_pool("wh2_main_ovn_chaos_dwarfs", "names_name_995467591", "names_name_995467594", "", "", 18, true, "general", "rykarth_the_unbreakable", true, "")
		cm:spawn_character_to_pool("wh2_main_ovn_chaos_dwarfs", "names_name_995467590", "names_name_995467593", "", "", 18, true, "general", "drazhoath_the_ashen", true, "")
		spawn_starting_lord(subtype, forename, surname)
		return
	end

	-- infernal guard units
	cm:add_event_restricted_unit_record_for_faction("infernal_guard", chorf_faction_name, "pj_chorf_panel_infernals_lock")
	cm:add_event_restricted_unit_record_for_faction("infernal_guard_deathmask_naphta", chorf_faction_name, "pj_chorf_panel_infernals_lock")
	cm:add_event_restricted_unit_record_for_faction("infernal_guard_great_weapons", chorf_faction_name, "pj_chorf_panel_infernals_lock")

	-- ror units
	cm:add_event_restricted_unit_record_for_faction("ironsworn", chorf_faction_name, "pj_chorf_panel_ror_lock")
	cm:add_event_restricted_unit_record_for_faction("chaos_dwarf_warriors_horde", chorf_faction_name, "pj_chorf_panel_ror_lock_zharr")
	cm:add_event_restricted_unit_record_for_faction("granite_guard", chorf_faction_name, "pj_chorf_panel_ror_lock_zharr")
	cm:add_event_restricted_unit_record_for_faction("magma_beasts", chorf_faction_name, "pj_chorf_panel_ror_lock_ghorth")
	cm:add_event_restricted_unit_record_for_faction("bull_centaur_ba'hal_guardians", chorf_faction_name, "pj_chorf_panel_ror_lock_ghorth")
	cm:add_event_restricted_unit_record_for_faction("wh_pro04_chs_art_hellcannon_ror_0", chorf_faction_name, "pj_chorf_panel_ror_lock_ghorth")

	if starting_lord == "pj_chorf_panel_starting_lord_zhatan" then
		forename = "names_name_995467592"
		surname = "names_name_995467595"
		subtype = "zhatan_the_black"
	elseif starting_lord == "pj_chorf_panel_starting_lord_immortal" then
		forename = "names_name_995467591"
		surname = "names_name_995467594"
		subtype = "rykarth_the_unbreakable"
	elseif starting_lord == "pj_chorf_panel_starting_lord_ash" then
		forename = "names_name_995467590"
		surname = "names_name_995467593"
		subtype = "drazhoath_the_ashen"
	end

	spawn_starting_lord(subtype, forename, surname)
end

cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name(true) == "wh2_main_ovn_chaos_dwarfs" then
			fill_loc_values()
			create_slave_tribute_button()
		end

		if cm:is_new_game() then
			new_game_setup()
		end
	end
)

--- Give some levels to the LLs received from the panel.
local panel_legendary_lord_subtypes = {
	"rykarth_the_unbreakable",
	"zhatan_the_black",
	"drazhoath_the_ashen",
}

core:remove_listener("ovn_chorfs_on_char_selected_LL_xp_boost")
core:add_listener(
	"ovn_chorfs_on_char_selected_LL_xp_boost",
	"CharacterCreated",
	true,
	function(context)
		---@type CA_CHAR
		local char = context:character()

		if char:faction():name() ~= "wh2_main_ovn_chaos_dwarfs" then return end
		if char:is_faction_leader() then return end

		local is_char_subtype_panel_legendary_lord = false
		for _, subtype in ipairs(panel_legendary_lord_subtypes) do
			is_char_subtype_panel_legendary_lord = is_char_subtype_panel_legendary_lord or char:character_subtype(subtype)
		end
		if not is_char_subtype_panel_legendary_lord then return end

		if char:rank() ~= 1 then return end

		local char_str = cm:char_lookup_str(char)
		local xp_boost_tier = cm:get_saved_value("ovn_chorfs_legendary_lords_xp_boost_tier")
		if not xp_boost_tier then
			cm:set_saved_value("ovn_chorfs_legendary_lords_xp_boost_tier", 1)
			cm:add_agent_experience(char_str, 4200)
		elseif xp_boost_tier == 1 then
			cm:set_saved_value("ovn_chorfs_legendary_lords_xp_boost_tier", 2)
			cm:add_agent_experience(char_str, 11510)
		elseif xp_boost_tier == 2 then
			cm:set_saved_value("ovn_chorfs_legendary_lords_xp_boost_tier", 3)
			cm:add_agent_experience(char_str, 19400)
		end
	end,
	true
)
