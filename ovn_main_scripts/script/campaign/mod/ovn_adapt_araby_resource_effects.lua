--- Uses a script to adapt the Epire building effects for Araby.
--- We hide some and rewrite other effects.

local building_name_to_unit_name = nil

local function create_table()
	local get_localised_string = effect.get_localised_string
	local iron_new = "Recruitment cost: %+n% for Arabyan Knights, Sipahis, Elephants, Scorpions, Jaguar Champions and Arabyan Guard recruits"

	local subbed_iron = string.gsub(get_localised_string("effects_description_wh_main_effect_tech_recruitment_cost_reduction_emp_swords_knights"), "%%%+n", "(.+)")
	subbed_iron = string.gsub(subbed_iron, "%%", "%%%%")

	local subbed_gold = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_recruitment_cost_reduction_emp_free_company"), "%%%+n", "(.+)")
	subbed_gold = string.gsub(subbed_gold, "%%", "%%%%")
	local subbed_gold2 = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_unit_xp_levels_emp_free_company"), "%%%+n", "(.+)")
	subbed_gold2 = string.gsub(subbed_gold2, "%%", "%%%%")
	local subbed_gold3 = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_upkeep_cost_reduction_emp_free_company"), "%%%+n", "(.+)")
	subbed_gold3 = string.gsub(subbed_gold3, "%%", "%%%%")
	local subbed_gold4 = string.gsub(get_localised_string("effects_description_wh_main_effect_agent_recruitment_xp_champion_empire"), "%%%+n", "(.+)")
	subbed_gold4 = string.gsub(subbed_gold4, "%%", "%%%%")

	local subbed_timber = string.gsub(get_localised_string("effects_description_wh_main_effect_tech_recruitment_cost_reduction_emp_crossbowmen_spearmen"), "%%%+n", "(.+)")
	subbed_timber = string.gsub(subbed_timber, "%%", "%%%%")
	local subbed_timber2 = string.gsub(get_localised_string("effects_description_wh_main_effect_tech_unit_xp_levels_emp_crossbowmen_spearmen"), "%%%+n", "(.+)")
	subbed_timber2 = string.gsub(subbed_timber2, "%%", "%%%%")
	local subbed_timber3 = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_upkeep_reduction_emp_crossbowmen_spearmen"), "%%%+n", "(.+)")
	subbed_timber3 = string.gsub(subbed_timber3, "%%", "%%%%")

	local subbed_animals = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_recruitment_cost_reduction_emp_demigryphs"), "%%%+n", "(.+)")
	subbed_animals = string.gsub(subbed_animals, "%%", "%%%%")

	local subbed_animals2 = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_upkeep_cost_reduction_emp_demigryphs"), "%%%+n", "(.+)")
	subbed_animals2 = string.gsub(subbed_animals2, "%%", "%%%%")
	local subbed_animals3 = string.gsub(get_localised_string("effects_description_wh2_main_effect_resource_unit_xp_levels_emp_demigryphs"), "%%%+n", "(.+)")
	subbed_animals3 = string.gsub(subbed_animals3, "%%", "%%%%")

	building_name_to_unit_name = {
		[get_localised_string("building_culture_variants_name_wh_main_emp_resource_iron_1")] =
			{
				[subbed_iron] = iron_new,
			},
		[get_localised_string("building_culture_variants_name_wh_main_emp_resource_iron_2")] =
			{
				[subbed_iron] = iron_new,
			},
		[get_localised_string("building_culture_variants_name_wh_main_emp_resource_iron_3")] =
			{
				[subbed_iron] = iron_new,
			},
		[get_localised_string("building_culture_variants_name_wh_main_emp_resource_gold_1")] =
			{
				[subbed_gold] = "",
			},
		[get_localised_string("building_culture_variants_name_wh_main_emp_resource_gold_2")] =
			{
				[subbed_gold] = "",
				[subbed_gold2] = "",
			},
		[get_localised_string("building_culture_variants_name_wh_main_emp_resource_gold_3")] =
			{
				[subbed_gold] = "",
				[subbed_gold2] = "",
				[subbed_gold3] = "",
				[subbed_gold4] = "",
			},
			[get_localised_string("building_culture_variants_name_wh_main_emp_resource_timber_1")] =
			{
				[subbed_timber] = "",
			},
			[get_localised_string("building_culture_variants_name_wh_main_emp_resource_timber_2")] =
				{
					[subbed_timber] = "",
					[subbed_timber2] = "",
				},
			[get_localised_string("building_culture_variants_name_wh_main_emp_resource_timber_3")] =
				{
					[subbed_timber] = "",
					[subbed_timber2] = "",
					[subbed_timber3] = "",
				},
		[get_localised_string("building_culture_variants_name_wh2_main_emp_resource_animals_1")] =
			{
				[subbed_animals] = "",
			},
		[get_localised_string("building_culture_variants_name_wh2_main_emp_resource_animals_2")] =
			{
				[subbed_animals] = "",
				[subbed_animals3] = "",
			},
		[get_localised_string("building_culture_variants_name_wh2_main_emp_resource_animals_3")] =
			{
				[subbed_animals] = "",
				[subbed_animals2] = "",
				[subbed_animals3] = "",
			},
	}
end

local function hide_or_rewrite_building_effects()
	if not building_name_to_unit_name then return end

	local ui_root = core:get_ui_root()
	local bip = find_uicomponent(ui_root, "building_browser", "info_panel_background", "BuildingInfoPopup")

	if not bip or not bip:Visible() then
		bip = find_uicomponent(ui_root, "layout", "info_panel_holder", "secondary_info_panel_holder", "info_panel_background", "BuildingInfoPopup")
	end
	if not bip or not bip:Visible() then return end

	local dy_title = find_uicomponent(bip, "dy_title")

	local entry_parent = find_uicomponent(bip, "effects_list")
	local current_building_name = dy_title:GetStateText()
	for building_name, unit_names in pairs(building_name_to_unit_name) do
		if current_building_name == building_name then
			local we_hid_all_child_comps = true
			for i=0, entry_parent:ChildCount()-1 do
				local child = UIComponent(entry_parent:Find(i))
				local unit_name_text = child:GetStateText()
				local we_hid_this_child_comp = false
				for unit_name1, substitute_to  in pairs(unit_names) do
					local ret = string.match(unit_name_text, unit_name1)
					if string.match(unit_name_text, unit_name1) then
						if substitute_to ~= "" then
							local gsubbed = string.gsub(substitute_to, "%%%+n", ret)
							child:SetStateText("[[col:dark_g]]"..gsubbed.."[[/col]]")
						else
							we_hid_this_child_comp = true
							child:SetVisible(false)
						end
					end
				end
				we_hid_all_child_comps = we_hid_all_child_comps and we_hid_this_child_comp
			end

			if we_hid_all_child_comps then
				UIComponent(entry_parent:Parent()):SetVisible(false)
			end
		end
	end
end

local function init()
	create_table()

	core:remove_listener("ovn_adapt_araby_resource_effects_cb")
	core:add_listener(
			"ovn_adapt_araby_resource_effects_cb",
			"RealTimeTrigger",
			function(context)
					return context.string == "ovn_adapt_araby_resource_effects"
			end,
			function()
				hide_or_rewrite_building_effects()
			end,
			true
	)

	real_timer.unregister("ovn_adapt_araby_resource_effects")
	real_timer.register_repeating("ovn_adapt_araby_resource_effects", 0)
end

cm:add_first_tick_callback(function()
	cm:callback(function()
		if cm:get_local_faction(true):subculture() == "wh_main_sc_emp_araby" then
			init()
		end
	end, 3)
end)
