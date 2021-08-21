local function setup_diplo()
    cm:force_diplomacy("faction:wh2_main_emp_the_moot", "faction:wh_main_emp_empire", "all", true, true, true);
    if cm:get_faction("wh2_main_emp_the_moot"):is_human() then
			cm:force_diplomacy("faction:wh2_main_emp_the_moot", "faction:wh_main_emp_empire", "war", false, false, true);
    end
end

local function give_new_game_restaurant_quest()
	local mission = [[
		mission
		{
				key ovn_halfling_establish_restaurant_mission;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						type SCRIPTED;
						script_key ovn_halfling_establish_restaurant_mission;
						override_text mission_text_override_ovn_halfling_establish_restaurant_mission;
					}
					payload
					{
						money 1000;
					};
			};
		};
	]]
	cm:trigger_custom_mission_from_string("wh2_main_emp_the_moot", mission);
end

local function halflings_init()
    local faction_key = "wh2_main_emp_the_moot"
    local faction_obj = cm:get_faction(faction_key)

    if not faction_obj or faction_obj:is_null_interface() then
      return false
    end

		if cm:is_new_game() then
			cm:callback(function()
				give_new_game_restaurant_quest()
			end, 8)
		end

    setup_diplo()

		--- kill the qb faction after the new campaign starting battle
		core:remove_listener("ovn_hlf_after_starting_battle")
		core:add_listener(
			"ovn_hlf_after_starting_battle",
			"BattleCompleted",
			true,
			function(context)
				local starting_fight_faction_key = "wh_main_vmp_vampire_counts_qb3"

				local has_been_fought = cm:model():pending_battle():has_been_fought()
				if not has_been_fought then return end -- don't do stuff if the player retreated

				if cm:pending_battle_cache_num_attackers() >= 1 then
					for i = 1, cm:pending_battle_cache_num_attackers() do
						local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
						if current_faction_name == starting_fight_faction_key then
							cm:disable_event_feed_events(true, "","","diplomacy_faction_destroyed");
							cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
							cm:kill_character(this_char_cqi, true, true)
							cm:callback(function() cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed") end, 3);
							cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 3);
						end
					end
				end
				if cm:pending_battle_cache_num_defenders() >= 1 then
					for i = 1, cm:pending_battle_cache_num_defenders() do
						local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
						if current_faction_name == starting_fight_faction_key then
							cm:disable_event_feed_events(true, "","","diplomacy_faction_destroyed");
							cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
							cm:kill_character(this_char_cqi, true, true)
							cm:callback(function() cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed") end, 3);
							cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 3);
						end
					end
				end
			end,
			true
		)

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
    end

    if cm:get_faction("wh_main_emp_empire"):is_human() or cm:get_faction("wh2_dlc13_emp_golden_order"):is_human() then
        core:add_listener(
            "ovn_moot_confed_dilemma",
            "FactionTurnStart",
            function(context)
							local faction = context:faction()
							return not cm:get_faction("wh2_main_emp_the_moot"):is_dead()
							and 1 == cm:random_number(33, 1)
							and (
								(
									faction:name() == "wh_main_emp_empire"
									and faction:is_human()
									and faction:diplomatic_standing_with("wh2_main_emp_the_moot") > 0
								)
								or
								(
									faction:name() == "wh2_dlc13_emp_golden_order"
									and faction:is_human()
									and faction:diplomatic_standing_with("wh2_main_emp_the_moot") > 0
								)
							)
            end,
            function(context)
                local faction_string = context:faction():name()

								core:remove_listener("ovn_dilemma_moot_confed_choice")
                core:add_listener(
                    "ovn_dilemma_moot_confed_choice",
                    "DilemmaChoiceMadeEvent",
                    function(context) return context:dilemma():starts_with("ovn_dilemma_moot_confed") end,
                    function(context)
                        local faction_string = context:faction():name()
                    if context:choice() == 0 then
                        cm:force_confederation(faction_string, "wh2_main_emp_the_moot")
                    end
                    end,
                    false
                )

                cm:trigger_dilemma(faction_string, "ovn_dilemma_moot_confed")
            end,
            true
        )
    end
end

cm:add_first_tick_callback(
    function()
        halflings_init()
    end
)
