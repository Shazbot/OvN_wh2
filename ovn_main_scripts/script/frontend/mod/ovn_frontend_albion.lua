-- number is the startpos ID from start_pos_character tables, name can be whatever you want as long it's the same in both here and in local starting units

local current_starting_lord = "albion_morrigan"

local your_cool_lords_me = {
	["937413525"] = "albion",
}

local your_cool_lords_vortex = {
	["794782611"] = "albion",
}

local starting_units = {
	["albion_morrigan"] = {
		number_of_units = 3,
		starting_unit_1 = "albion_swordmaiden", unit_card_1 = "albion_swordmaiden",
		starting_unit_2 = "albion_giant", unit_card_2 = "albion_giant",
		starting_unit_3 = "albion_hearthguard", unit_card_3 = "albion_hearthguard"
	},
	["bl_elo_dural_durak"] = {
		number_of_units = 3,
		starting_unit_1 = "albion_centaurs", unit_card_1 = "albion_centaurs",
		starting_unit_2 = "albion_giant", unit_card_2 = "albion_giant",
		starting_unit_3 = "albion_hearthguard", unit_card_3 = "albion_hearthguard"
	}
}

local lord_effects = {
	["albion_morrigan"] = {
		["remove"] = {
			"lord_effect9",
			"lord_effect10",
			"lord_effect11"
		},
		["add"] = {
			"lord_effect5",
			"lord_effect6",
			"lord_effect7",
			"lord_effect8"
		}
	},
	["bl_elo_dural_durak"] = {
		["remove"] = {
			"lord_effect5",
			"lord_effect6",
			"lord_effect7",
			"lord_effect8"
		},
		["add"] = {
			"lord_effect9",
			"lord_effect10",
			"lord_effect11"
		}

	}
}

local function startpos_id_check(startpos_id)
	if your_cool_lords_me[startpos_id] then
		return your_cool_lords_me[startpos_id]
	end
	if your_cool_lords_vortex[startpos_id] then
		return your_cool_lords_vortex[startpos_id]
	end
end

-----------------------------------------------
---	Create the frontend unit card
-----------------------------------------------
local function create_unit_card_for_frontend(unit_key, unit_card, id)
	local parent = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "lord_details_panel", "units", "start_units", "card_holder")
    if not is_uicomponent(parent) then script_error("[parent] expected to be a UIComponent, wrong type!") return end

    -- create the UI Component
    local uic = core:get_or_create_component("ovn_unit_card_"..id, "ui/templates/custom_image", parent)

    -- check that it worked
    if not uic then script_error("UIC was not able to be made or found!") return end

	local unit_name = effect.get_localised_string("land_units_onscreen_name_"..unit_key)

	uic:SetVisible(true)
    uic:SetImagePath("ui/units/icons/"..unit_card..".png", 4)
    uic:Resize(50, 110)
    uic:SetOpacity(255)
	uic:SetTooltipText(unit_name, true)

	parent:Adopt(uic:Address())
end

local function update_starting_lord_button(should_be_visible)
	local portrait_frame = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame")
    local uic = core:get_or_create_component("ovn_albion_starting_lord_button", "ui/templates/square_large_text_button", portrait_frame)

	uic:SetVisible(should_be_visible)
	if should_be_visible == true then
		uic:SetDockingPoint(8)
		uic:SetDockOffset(0, 60)

		local txt = find_uicomponent(uic, "button_txt")
		-- local blurb = effect.get_localised_string("campaign_localised_strings_string_mixu_frontend_starting_lord_change_blurb")
		txt:SetStateText("Change the starting lord")
	end
end

local function update_faction_effects(starting_lord)
	for l = 1, #lord_effects[starting_lord]["remove"] do
		local current_faction_effect = lord_effects[starting_lord]["remove"][l]
		local faction_effect = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "lord_details_panel", "faction", "faction_traits", "effects", "listview", "list_clip", "list_box", current_faction_effect)
		if faction_effect then
			faction_effect:SetVisible(false)
		end
	end

	for l = 1, #lord_effects[starting_lord]["add"] do
		local current_faction_effect = lord_effects[starting_lord]["add"][l]
		local faction_effect = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "lord_details_panel", "faction", "faction_traits", "effects", "listview", "list_clip", "list_box", current_faction_effect)
		if faction_effect then
			faction_effect:SetVisible(true)
		end
	end
end

local function update_frontend_lord_picture(custom_image, lord, first_time, lord_select_icon)
	custom_image:SetImagePath("ui/portraits/frontend/"..lord..".png")

	if first_time == true then
		custom_image:SetVisible(true)
		local movie_frame = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame", "movie_frame")
		local x, y = movie_frame:Position()

		custom_image:MoveTo(x, y)
		custom_image:PropagatePriority(movie_frame:Priority())
		custom_image:SetCanResizeHeight(true)
		custom_image:SetCanResizeWidth(true)
		custom_image:Resize(464, 624)
		custom_image:SetCanResizeHeight(false)
		custom_image:SetCanResizeWidth(false)
	end

	if lord_select_icon then
		lord_select_icon:SetImagePath("ui/portraits/faction_leaders/"..lord..".png")
	end
end

local function set_starting_lord(lord)
	core:svr_save_bool("ovn_albion_dural_durak_is_leader", lord == "bl_elo_dural_durak")
end

local function add_unit_card_listener()

core:remove_listener("ovn_albion_CampaignTransitionListener")
core:add_listener(
	"ovn_albion_CampaignTransitionListener",
	"FrontendScreenTransition",
	function(context) return context.string == "sp_grand_campaign" end,
	function(context)
		local uic_grand_campaign = find_uicomponent("sp_grand_campaign")

		if not uic_grand_campaign then
			script_error("ERROR: add_unit_card_listener() couldn't find uic_grand_campaign, how can this be?");
			return false;
		end;

		local faction_list = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "top_docker", "lord_select_list", "list", "list_clip", "list_box")
		if not faction_list then
			return
		end

		for i = 0, faction_list:ChildCount() - 1 do
			local child = UIComponent(faction_list:Find(i))
			local startpos_id = child:GetProperty("lord_key")
			local is_this_albion = startpos_id_check(startpos_id)

			if is_this_albion then
				-- child:SetTooltipText('{{tt:ui/mousillon/mixu_tooltip_campaign_select_lord}}', true)

				core:remove_listener("mallobaude_hovered_on")
				core:add_listener(
					"mallobaude_hovered_on",
					"ComponentMouseOn",
					function(context)
						local startpos_id = child:GetProperty("lord_key")
						return child == UIComponent(context.component)
					end,
					function(context)
						core:add_listener("ovn_albion_hovered_on_tooltip", "RealTimeTrigger", function(context) return context.string == "ovn_albion_hovered_on_tooltip" end,
							function(context)
								-- local tooltip = find_uicomponent(core:get_ui_root(), "mixu_tooltip_campaign_select_lord")
								-- local label_lord = find_uicomponent(tooltip, "label_lord")
								-- local label_race = find_uicomponent(tooltip, "label_race")
								-- local label_faction = find_uicomponent(tooltip, "label_faction")
								-- local lord_name = ""
								-- -- local race_blurb = effect.get_localised_string("campaign_localised_strings_string_mixu_mallobaude_frontend_end_race_tooltip")
								-- -- local faction_blurb = effect.get_localised_string("campaign_localised_strings_string_mixu_mallobaude_frontend_end_faction_tooltip")

								-- if current_starting_lord == "albion_morrigan" then
								-- 	lord_name = effect.get_localised_string("land_units_onscreen_name_albion_morrigan")
								-- else
								-- 	lord_name = effect.get_localised_string("land_units_onscreen_name_bl_elo_dural_durak")
								-- end


								-- label_lord:SetStateText(lord_name)
								-- label_race:SetStateText(race_blurb)
								-- label_faction:SetStateText(faction_blurb)
							end,
						false)

						real_timer.register_singleshot("ovn_albion_hovered_on_tooltip", 0)
					end,
					true
				)
			end

			core:remove_listener("ovn_albion_button_clicked_"..tostring(startpos_id))
			core:add_listener(
				"ovn_albion_button_clicked_"..tostring(startpos_id),
				"ComponentLClickUp",
				function(context)
					return child == UIComponent(context.component)
				end,
				function(context)
					local portrait_frame = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame")
					local custom_image = core:get_or_create_component("mixu_custom_image_mousillino", "ui/campaign ui/region_info_pip", portrait_frame)

					if not custom_image then
						script_error("UIC was not able to be made or found!")
						return
					end

					if not is_this_albion then
						custom_image:SetVisible(false)
						update_starting_lord_button(false)
						current_starting_lord = "albion_morrigan"
					else
						update_starting_lord_button(true)
						update_frontend_lord_picture(custom_image, current_starting_lord, true, child)
						set_starting_lord(current_starting_lord)

						core:add_listener("ovn_albion_frontend", "RealTimeTrigger", function(context) return context.string == "ovn_albion_frontend" end,
							function(context)
								local units = starting_units[current_starting_lord]
								if units ~= nil then
									-- add the starting units
									create_unit_card_for_frontend(units.starting_unit_1, units.unit_card_1, 1)
									create_unit_card_for_frontend(units.starting_unit_2, units.unit_card_2, 2)
									create_unit_card_for_frontend(units.starting_unit_3, units.unit_card_3, 3)

									-- update the lord name
									local faction_leader = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame", "dy_faction_leader")
									faction_leader:SetStateText(effect.get_localised_string("land_units_onscreen_name_albion_morrigan"))

									-- update faction & lord effects
									-- update_faction_effects(current_starting_lord)
								end
							end,
						false)

						real_timer.register_singleshot("ovn_albion_frontend", 0)
					end
				end,
				true
			)
		end
	end,
	true
)

core:remove_listener("ovn_albion_starting_lord_button_clicked")
core:add_listener(
	"ovn_albion_starting_lord_button_clicked",
	"ComponentLClickUp",
	function(context)
		return context.string == "ovn_albion_starting_lord_button"
	end,
	function(context)
		if current_starting_lord == "albion_morrigan" then
			current_starting_lord = "bl_elo_dural_durak"
		else
			current_starting_lord = "albion_morrigan"
		end

		set_starting_lord(current_starting_lord)

		local faction_list = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "top_docker", "lord_select_list", "list", "list_clip", "list_box")
		local lord_select_icon
		if not faction_list then
			return
		end

		for i = 0, faction_list:ChildCount() - 1 do
			local child = UIComponent(faction_list:Find(i))
			local startpos_id = child:GetProperty("lord_key")
			local is_this_albion = startpos_id_check(startpos_id)

			if is_this_albion then
				lord_select_icon = child
			end
		end

		local portrait_frame = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame")
		local custom_image = core:get_or_create_component("mixu_custom_image_mousillino", "ui/campaign ui/region_info_pip", portrait_frame)
		update_frontend_lord_picture(custom_image, current_starting_lord, true, lord_select_icon)

		core:add_listener("ovn_albion_frontend_button", "RealTimeTrigger", function(context) return context.string == "ovn_albion_frontend_button" end,
		function(context)
			local units = starting_units[current_starting_lord]
			if units ~= nil then
				-- update starting units
				local parent = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "lord_details_panel", "units", "start_units", "card_holder")
				local unit_1 = core:get_or_create_component("ovn_unit_card_1", "ui/templates/custom_image", parent)
				local unit_1_name = effect.get_localised_string("land_units_onscreen_name_"..units.starting_unit_1)

				local unit_2 = core:get_or_create_component("ovn_unit_card_2", "ui/templates/custom_image", parent)
				local unit_2_name = effect.get_localised_string("land_units_onscreen_name_"..units.starting_unit_2)

				local unit_3 = core:get_or_create_component("ovn_unit_card_3", "ui/templates/custom_image", parent)
				local unit_3_name = effect.get_localised_string("land_units_onscreen_name_"..units.starting_unit_3)

				unit_1:SetImagePath("ui/units/icons/"..units.unit_card_1..".png", 4)
				unit_1:SetTooltipText(unit_1_name, true)

				unit_2:SetImagePath("ui/units/icons/"..units.unit_card_2..".png", 4)
				unit_2:SetTooltipText(unit_2_name, true)

				unit_3:SetImagePath("ui/units/icons/"..units.unit_card_3..".png", 4)
				unit_3:SetTooltipText(unit_3_name, true)

				-- update the lord name
				local faction_leader = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame", "dy_faction_leader")
				if current_starting_lord == "albion_morrigan" then
					faction_leader:SetStateText(effect.get_localised_string("land_units_onscreen_name_albion_morrigan"))
				else
					faction_leader:SetStateText(effect.get_localised_string("land_units_onscreen_name_bl_elo_dural_durak"))
				end

				-- update faction & lord effects
				-- update_faction_effects(current_starting_lord)
			end
		end,
		false)

		real_timer.register_singleshot("ovn_albion_frontend_button", 0)
	end,
	true
)
end




core:add_ui_created_callback(
	function(context)
		add_unit_card_listener()
	end
)
