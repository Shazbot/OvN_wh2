local localized_hlf_moulder_ability_icon = nil

local update = function()
	if not localized_hlf_moulder_ability_icon then return end

	local ui_root = core:get_ui_root()
	local ability_list = find_uicomponent(ui_root, "layout", "info_panel_holder", "secondary_info_panel_holder", "info_panel_background", "UnitInfoPopup", "ability_list")
	if not ability_list then return end

	for i=0, ability_list:ChildCount()-1 do
		local ability_icon = find_uicomponent(ability_list, "unit_ability_icon"..i)
		if ability_icon then
			if ability_icon:GetTooltipText() == localized_hlf_moulder_ability_icon then
				ability_icon:SetImagePath("ui/battle ui/ability_icons/wh_main_emp_empire/moulder_monster.png")
			end
		end
	end
end

core:remove_listener("pj_ui_adjust_hlf_moulder_ability_icon_cb")
core:add_listener(
		"pj_ui_adjust_hlf_moulder_ability_icon_cb",
		"RealTimeTrigger",
		function(context)
				return context.string == "pj_ui_adjust_hlf_moulder_ability_icon"
		end,
		function()
			update()
		end,
		true
)

cm:add_first_tick_callback(function()
	localized_hlf_moulder_ability_icon = effect.get_localised_string("ui_text_replacements_localised_text_ovn_moulder_monster_name_wh_main_sc_emp_empire")

	real_timer.unregister("pj_ui_adjust_hlf_moulder_ability_icon")
	real_timer.register_repeating("pj_ui_adjust_hlf_moulder_ability_icon", 0)
end)