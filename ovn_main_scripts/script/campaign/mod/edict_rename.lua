
local function ovn_edict_rename()

local edict_text_to_new_text = {
	["Host Festag"] = "Second Breakfast",
	["Sigmarite Dogma"] = " Esmeralda's Blessings",
	["Imperial Taxation"] = "River Tax",
	["Council of Burgomeisters"] = "Pie Festivities",
	["State Troop Levy"] = "Ring the Village Bell",
}

core:remove_listener("pj_moot_edicts_rename_on_repeat_callback_triggered")
core:add_listener(
		"pj_moot_edicts_rename_on_repeat_callback_triggered",
		"RealTimeTrigger",
		function(context)
				return context.string == "pj_moot_edicts_rename_repeat_callback"
		end,
		function()
			local EdictTooltipPopup = find_uicomponent(core:get_ui_root(), "EdictTooltipPopup")
			if not EdictTooltipPopup then
				real_timer.unregister("pj_moot_edicts_rename_repeat_callback")
				return
			end

			local edict_header = find_uicomponent(EdictTooltipPopup, "list_parent", "dy_heading_textbox_copy_0")
			if not edict_header then
				real_timer.unregister("pj_moot_edicts_rename_repeat_callback")
				return
			end

			local new_text = edict_text_to_new_text[edict_header:GetStateText()]
			if new_text then
				edict_header:SetStateText(new_text)
			end
		end,
		true
)

core:remove_listener('pj_moot_edicts_rename_on_mouseover')
core:add_listener(
	'pj_moot_edicts_rename_on_mouseover',
	'ComponentMouseOn',
	function(context)
		if cm:get_local_faction_name(true) ~= "wh2_main_emp_the_moot" then return end

		local component_id = context.string
		return component_id == "button_wh_main_edict_state_troop_levy"
			or component_id == "button_wh_main_edict_council_of_burgomeisters"
			or component_id == "button_wh_main_edict_imperial_taxation"
			or component_id == "button_wh_main_edict_sigmarite_dogma"
			or component_id == "button_wh_main_edict_host_festag"
	end,
	function()
		real_timer.register_repeating("pj_moot_edicts_rename_repeat_callback", 0)
	end,
	true
)
end

cm:add_first_tick_callback(function() ovn_edict_rename() end)
