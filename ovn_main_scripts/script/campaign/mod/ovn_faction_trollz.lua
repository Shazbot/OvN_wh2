local function setup_diplo(is_human)
	cm:force_declare_war("wh2_main_rogue_troll_skullz", "wh_main_ksl_kislev", false, false)
	cm:force_declare_war("wh2_main_nor_trollz", "wh_main_dwf_karak_azul", false, false)
	cm:force_declare_war("wh2_main_nor_trollz", "wh2_main_dwf_greybeards_prospectors", false, false)
	cm:force_declare_war("wh2_main_rogue_troll_skullz", "wh2_main_dwf_greybeards_prospectors", false, false)
	cm:force_declare_war("wh2_main_nor_trollz", "wh_main_grn_red_fangs", false, false)

	cm:force_diplomacy("faction:wh2_main_nor_trollz", "all", "all", false, false, true)
	cm:force_diplomacy("faction:wh2_main_rogue_troll_skullz", "all", "all", false, false, true)
	cm:force_diplomacy("faction:wh2_main_nor_trollz", "all", "war", true, true, true)
	cm:force_diplomacy("faction:wh2_main_rogue_troll_skullz", "all", "war", true, true, true)

	local cultures_diplo_allow = {
		"wh2_main_rogue",
		"wh2_main_skv_skaven",
		"wh_dlc03_bst_beastmen",
		"wh_main_chs_chaos",
		"wh_main_grn_greenskins"
	}

	-- Trollz can only do diplomacy with Chaos, Norsca, Greenskins, Beastmen, Skaven & Rogue Armies
	for i = 1, #cultures_diplo_allow do
		cm:force_diplomacy("faction:wh2_main_nor_trollz", "culture:" .. cultures_diplo_allow[i], "all", true, true, true)
		cm:force_diplomacy("faction:wh2_main_rogue_troll_skullz", "culture:" .. cultures_diplo_allow[i], "all", true, true, true)
	end
end

local function troll_init()
    local faction_key = "wh2_main_nor_trollz"
    local faction_obj = cm:get_faction(faction_key)

if not faction_obj or faction_obj:is_null_interface() then
  -- faction doesn't exist in this campaign or has already died
  return false
end

    local is_human = faction_obj:is_human()

    setup_diplo(is_human)

    if is_human then
        start_loyalty_interventions = true

        local function troll_army_lost()                
            cm:show_message_event(
                faction_key,
                "event_feed_strings_text_wh_event_feed_string_scripted_event_troll_army_lost_primary_detail",
                "",
                "event_feed_strings_text_wh_event_feed_string_scripted_event_troll_army_lost_secondary_detail",
                true,
                2503
            )							
        end

        local function troll_army_cannibal()                
            cm:show_message_event(
                faction_key,
                "event_feed_strings_text_wh_event_feed_string_scripted_event_troll_army_cannibal_primary_detail",
                "",
                "event_feed_strings_text_wh_event_feed_string_scripted_event_troll_army_cannibal_secondary_detail",
                true,
                2504
            )							
        end

        core:add_listener(
            "troll_karak_azgal_mission",
            "FactionTurnStart",
            function(context)
                return context:faction():is_human() and context:faction():name() == faction_key and cm:model():turn_number() == 2
            end,
            function(context) 
                cm:trigger_mission(faction_key, "ovn_troll_me_take_karak_azgal", true)
            end, 		
            false
        )

        core:add_listener(
            "troll_lord_recruited_add_wellfed_eb",
            "CharacterCreated",
            function(context)
                return context:character():character_subtype_key() == "elo_cha_troll_lord" and context:character():faction():name() == faction_key
            end,
            function(context)
              local current_char_cqi = context:character():command_queue_index()
              local current_char = context:character()

                if not current_char:character_type("colonel") then
                    cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", current_char_cqi, 7, false);
                end
            end, 		
            true
        )

        core:add_listener(
            "troll_loyalty_low",
            "FactionTurnStart",
            function(context) 
                return context:faction():is_human() and context:faction():name() == faction_key and cm:model():turn_number() > 1
            end,
            function(context)
                local faction = context:faction()
                local character_list = faction:character_list()
                for i = 0, character_list:num_items() - 1 do
                    local current_char = character_list:item_at(i)
                    local current_char_cqi = current_char:command_queue_index()

                    if not current_char:character_type("colonel") then
                        if not current_char:is_faction_leader() and current_char:has_military_force() and current_char:loyalty() < 3 and 1 == cm:random_number(5, 1) then
                            cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "")
                            cm:set_character_immortality("character_cqi:"..current_char_cqi, false)
                            cm:kill_character_and_commanded_unit("character_cqi:"..current_char_cqi, true, false)
                            cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1)
                            troll_army_lost()
                        else
                            if not current_char:is_faction_leader() and current_char:military_force():has_effect_bundle("ovn_troll_devour") and 1 == cm:random_number(4, 1) then
                                cm:modify_character_personal_loyalty_factor("character_cqi:"..current_char_cqi, 1);
                            elseif not current_char:is_faction_leader() and not current_char:military_force():has_effect_bundle("ovn_troll_devour") and 1 == cm:random_number(4, 1) then
                                cm:modify_character_personal_loyalty_factor("character_cqi:"..current_char_cqi, -1)
                            elseif not current_char:military_force():has_effect_bundle("ovn_troll_devour") and 1 == cm:random_number(5, 1) then
                                cm:apply_effect_bundle_to_characters_force("ovn_troll_devour", current_char_cqi, 3, false);
                                cm:apply_effect_bundle_to_characters_force("ovn_troll_cannibal", current_char_cqi, 3, false);
                                troll_army_cannibal()
                            end
                        end
                    end
                end
            end,
        true
        )
    end
end

cm:add_first_tick_callback(
    function() 
        troll_init() 
    end
)