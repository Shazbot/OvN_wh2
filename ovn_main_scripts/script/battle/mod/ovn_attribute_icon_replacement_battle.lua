local localized = effect.get_localised_string("ui_text_replacements_localised_text_ovn_moulder_monster_name_wh_main_sc_emp_empire")

local update = function()
	local ui_root = core:get_ui_root()

	local tx_unit_type = find_uicomponent(ui_root, "layout", "info_panel_holder", "UnitInfoPopup", "top_section", "tx_unit-type")

	if is_uicomponent(tx_unit_type) then
		local ability_list = find_uicomponent(ui_root, "layout", "info_panel_holder", "UnitInfoPopup", "ability_list")
		if is_uicomponent(ability_list) then
			for i=0, ability_list:ChildCount()-1 do
				local ability_icon = find_uicomponent(ui_root, "layout", "info_panel_holder", "UnitInfoPopup", "ability_list", "unit_ability_icon"..i)
				if is_uicomponent(ability_icon) then
					if ability_icon:GetTooltipText() == localized then
						ability_icon:SetImagePath("ui/battle ui/ability_icons/wh_main_emp_empire/moulder_monster.png")
					end
				end
			end
		end
	end
end

core:remove_listener("pj_ui_real_timer_adjust_attribute_icons_cb")
core:add_listener(
		"pj_ui_real_timer_adjust_attribute_icons_cb",
		"RealTimeTrigger",
		function(context)
				return context.string == "pj_ui_real_timer_adjust_attribute_icons"
		end,
		function()
			update()
		end,
		true
)

real_timer.unregister("pj_ui_real_timer_adjust_attribute_icons")
real_timer.register_repeating("pj_ui_real_timer_adjust_attribute_icons", 0)