local function setup_diplo()

    cm:force_diplomacy("faction:wh2_main_emp_the_moot", "faction:wh_main_emp_empire", "all", true, true, true);
    if cm:get_faction("wh2_main_emp_the_moot"):is_human() then
    cm:force_diplomacy("faction:wh2_main_emp_the_moot", "faction:wh_main_emp_empire", "war", false, false, true);
    end
end

local function halflings_init()
    local faction_key = "wh2_main_emp_the_moot"
    local faction_obj = cm:get_faction(faction_key)

    if not faction_obj or faction_obj:is_null_interface() then
      -- faction doesn't exist in this campaign or has already died
      return false
    end

    setup_diplo()

		core:remove_listener("pj_moot_rename_hlf_agents")
		core:add_listener(
			"pj_moot_rename_hlf_agents",
			"PanelOpenedCampaign",
			function(context)
					return context.string == "character_panel"
			end,
			function()
					if cm:get_local_faction_name(true) ~= "wh2_main_emp_the_moot" then return end

					local ui_root = core:get_ui_root()
					local list_box = find_uicomponent(ui_root, "character_panel", "agent_parent", "list_clip", "holder", "list_box")

					if not list_box then return end

					local champion = find_uicomponent(list_box, "champion")
					local champion_label = champion and find_uicomponent(champion, "label")
					if champion_label then
							local agent_desc = effect.get_localised_string("agent_subtypes_description_text_override_ovn_hlf_sheriff")
							local existing_tooltip_text = champion:GetTooltipText()

							existing_tooltip_text = agent_desc.."\n\n"..existing_tooltip_text
							champion:SetTooltipText(existing_tooltip_text, true)
							champion_label:SetStateText(effect.get_localised_string("ovn_hlf_ui_champion_label"))
					end

					local spy = find_uicomponent(list_box, "spy")
					local spy_label = spy and find_uicomponent(spy, "label")
					if spy_label then
							local agent_desc = effect.get_localised_string("agent_subtypes_description_text_override_ovn_hlf_fieldwarden")
							local existing_tooltip_text = spy:GetTooltipText()

							existing_tooltip_text = agent_desc.."\n\n"..existing_tooltip_text
							spy:SetTooltipText(existing_tooltip_text, true)
							spy_label:SetStateText(effect.get_localised_string("ovn_hlf_ui_spy_label"))
					end

					local dignitary = find_uicomponent(list_box, "dignitary")
					local dignitary_label = dignitary and find_uicomponent(dignitary, "label")
					if dignitary_label then
							local agent_desc = effect.get_localised_string("agent_subtypes_description_text_override_ovn_hlf_master_chef")
							local existing_tooltip_text = dignitary:GetTooltipText()

							existing_tooltip_text = agent_desc.."\n\n"..existing_tooltip_text
							dignitary:SetTooltipText(existing_tooltip_text, true)
							dignitary_label:SetStateText(effect.get_localised_string("ovn_hlf_ui_dignitary_label"))
					end
			end,
			true
		)

    if faction_obj:is_human() then
        core:add_listener(
            "halfling_gift_listener",
            "CharacterPerformsSettlementOccupationDecision",
            function(context)
                return context:character():faction():name() == faction_key
                and context:occupation_decision() == "2205198931"
            end,
            function(context)
                if cm:model():turn_number() < 25 then
                    ovn_early_imperial_reinforcements(faction_key)
                else
                    ovn_late_imperial_reinforcements(faction_key)
                end
            end,
            true
        )
    end;
end

cm:add_first_tick_callback(
    function()
        halflings_init()
    end
)
