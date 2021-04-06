local grudebringers_faction_key = "wh2_main_emp_grudgebringers"

local function message(faction_key, event_key)
    if not is_string(faction_key) or not is_string(event_key) then
        return false
    end

    cm:show_message_event(
        faction_key,
        "event_feed_strings_text_wh_event_feed_string_scripted_event_"..event_key.."_primary_detail",
        "event_feed_strings_text_wh_event_feed_string_scripted_event_"..event_key.."_secondary_detail",
        true,
        591
    )
end

local function setup_diplo()
    -- prevent war with brt/emp/dwf
    cm:force_diplomacy("faction:wh2_main_emp_grudgebringers", "culture:wh_main_brt_bretonnia", "war", false, false, true);
    cm:force_diplomacy("faction:wh2_main_emp_grudgebringers", "subculture:wh_main_emp_empire", "war", false, false, true);
    cm:force_diplomacy("faction:wh2_main_emp_grudgebringers", "culture:wh_main_dwf_dwarfs", "war", false, false, true);

    -- prevent peace with Dread King
    cm:force_diplomacy("faction:wh2_main_emp_grudgebringers", "faction:wh2_dlc09_tmb_the_sentinels", "peace", false, false, true)
end

local function add_grudge_anc()
    local grudebringers = cm:get_faction("wh2_main_emp_grudgebringers");
    if grudebringers then
        cm:force_add_ancillary(grudebringers:faction_leader(), "ovn_anc_magic_standard_ptolos", true, true);
        cm:force_add_ancillary(grudebringers:faction_leader(), "grudge_item_grudgebringer_sword", true, true);
    end;
end

local function grudgebringers_init()
    local faction_key = "wh2_main_emp_grudgebringers"
    local faction_obj = cm:get_faction(faction_key)

    if faction_obj:is_null_interface() then
        return
    end

    local campaign_name = "wh2_main_great_vortex"
    local papa_faction = "wh2_dlc13_emp_the_huntmarshals_expedition"

    if cm:model():campaign_name("main_warhammer") then
        papa_faction = "wh_main_emp_empire"
        campaign_name = "main_warhammer"
    end

    setup_diplo()

    if cm:is_new_game() then
     cm:callback(function()
        add_grudge_anc()
      end, 3)
    end

    if faction_obj:is_human() then
        -- diplo with papa faction
        cm:force_diplomacy("faction:wh2_main_emp_grudgebringers", "faction:"..papa_faction, "war", false, false, true)

        if cm:is_new_game() then
        cm:force_alliance("wh2_main_emp_grudgebringers", papa_faction, true)
        end

     -- Random Grudgebringer Dilemma
        core:add_listener(
            "generate_grudge_dilemma_listener",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == faction_key and cm:model():turn_number() >= 2
            end,
            function(context)
                local turn = cm:model():turn_number();
                local cooldown = 7
                if turn % cooldown == 0 and 1 ~= cm:random_number(5, 1) then

                    core:add_listener(
                        "grudge_dilemma_listener",
                        "DilemmaChoiceMadeEvent",
                        function(context) return context:dilemma():starts_with("ovn_dilemma_grudge_occupy") end,
                        function(context)
													if context:choice() == 0 then
															ovn_grudge_dilemma_reinforcements(faction_key)
													end

												end,
                        false
										)

                    cm:trigger_dilemma("wh2_main_emp_grudgebringers" , "ovn_dilemma_grudge_occupy")
							end
						end,
						true
				);


        -- occupy settlements mechanic
             -- gift settlement
             core:add_listener(
                "grudge_gift_listener",
                "CharacterPerformsSettlementOccupationDecision",
                function(context)
                    return context:character():faction():name() == faction_key
                    and (context:occupation_decision() == "2205198929" or context:occupation_decision() == "2205198930")
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

            --MORTAL EMPIRES--
        -- early-game listeners
        if campaign_name == "main_warhammer" then

            core:add_listener(
                "grudgestartmemissionlistner",
                "FactionRoundStart",
                function(context)
                    local fact = context:faction()
                    return fact:is_human() and fact:name() == faction_key and cm:model():turn_number() == 1
                end,
                function(context)
                    local fact = context:faction()

                    cm:trigger_mission(fact:name(), "ovn_grudge_me_take_zandri", true)
                end,
                false
            )

        else
            -- VORTEX --

            core:add_listener(
                "grudgestartvormissionlistner",
                "FactionRoundStart",
                function(context)
                    local fact = context:faction()
                    return fact:is_human() and fact:name() == faction_key and cm:model():turn_number() == 2
                end,
                function(context)
                    local fact = context:faction()

                    cm:trigger_mission(fact:name(), "ovn_grudge_vortex_take_zandri", true)
                end,
                false
            )
        end

        --------------------------------------------------------------
        -------- GRUDGEBRINGER RoR & ANCILLARY MECHANIC --------------
        --------------------------------------------------------------
        local do_nothing_array = {
            [1051] = true,
            [1134] = true,
            [1822456386] = true,
            [406] = true,
            [422] = true,
            [555] = true,
            [784] = true,
            [860] = true
        }

        -- campaign-agnostic listeners

        --BLACK TOWER OF ARKHAN--
        if not cm:get_saved_value("black_tower_storm") then
            core:add_listener(
                "morgheimoccupylistner",
                "CharacterPerformsSettlementOccupationDecision",
                function(context)
                    local char = context:character()
                    local fact = char:faction()
                    local region_key = char:region():name()

                    return (not do_nothing_array[context:occupation_decision()])
                    and (region_key ==  "wh2_main_great_desert_of_araby_black_tower_of_arkhan" or region_key == "wh2_main_vor_the_great_desert_black_tower_of_arkhan")
                    and fact:is_human() and fact:name() == faction_key
                end,
                function(context)
                    local character = context:character()
                    message(faction_key, "black_tower_storm")

                    cm:force_add_ancillary(character, "malach_sword", true, false)
                    cm:set_saved_value("black_tower_storm", true);
                end,
                false
            )
        end

        --MORTAL EMPIRES MISSIONS--
        if cm:model():campaign_name("main_warhammer") then
            if not cm:get_saved_value("morgheim_rescue") then

                core:add_listener(
                    "Morgheim_ME_Mission",
                    "FactionTurnStart",
                    function(context)
                        local fact = context:faction()
                        return fact:is_human() and fact:name() == faction_key and cm:model():turn_number() == 2
                    end,
                    function(context)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_kill_dk", true)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_take_morgheim", true)
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "azguz_bloodfist_dwarf_warriors", 1, 20, 1, 0.1, 0, "", "", "", true)
                    end,
                    false
                )

                core:add_listener(
                    "Take_ME_Morgheim_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_me_take_morgheim"
                    end,
                    function(context)
                        local faction_interface = context:mission():faction()
                        local character = faction_interface:faction_leader()

                        cm:add_unit_to_faction_mercenary_pool(faction_interface, "elrod_wood_elf_glade_guards", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:add_unit_to_faction_mercenary_pool(faction_interface, "dargrimm_firebeard_dwarf_warriors", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:force_add_ancillary(character, "chalcidar_orb", true, false)
                        message(faction_key, "grudge_rescue")
                        cm:set_saved_value("morgheim_rescue", true)
                    end,
                    false
                )
            end

              -- CERIDIAN --
              if not cm:get_saved_value("ceridan_rescue") then
                core:add_listener(
                    "Ceridan_ME_Mission",
                    "FactionTurnStart",
                    function(context)
                        return context:faction():is_human() and context:faction():name() == "wh2_main_emp_grudgebringers" and cm:model():turn_number() == 3
                    end,
                    function(context)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_move_to_swem", true)
                    end,
                    false
                );

                core:add_listener(
                    "Enter_ME_Swem_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_me_move_to_swem"
                    end,
                    function(context)
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "ceridan", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:set_saved_value("ceridan_rescue", true)
                    end,
                    false
                )

            end

             --KA-SABAAR AND THE FOUNTAIN OF LIGHT--
             if not cm:get_saved_value("sabarr_occupied") then
                core:add_listener(
                    "take_me_ka_sabar_listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_me_take_kasabar"
                    end,
                    function(context)
                        core:add_listener(
                            "sabaaroccupydilemma",
                            "DilemmaChoiceMadeEvent",
                            function(context) return context:dilemma():starts_with("ovn_dilemma_sabaar_occupy") end,
                            function(context)
                            if context:choice() == 0 then
                                cm:apply_effect_bundle("sabaar_fountain", "wh2_main_emp_grudgebringers", -1)
                                cm:set_saved_value("sabarr_occupied", true);
                            end
                            end,
                            true
                        )

                        cm:trigger_dilemma("wh2_main_emp_grudgebringers" , "ovn_dilemma_sabaar_occupy")
                    end,
                    false
                );

            else
                if not cm:get_saved_value("sabarr_ai_occupied") then
                    -- check if someone else conquers ka-sabar
                    core:add_listener(
                        "grudge_lose_me_ka_sabaar_listner",
                        "RegionFactionChangeEvent",
                        function(context)
                            local previous_owner = context:previous_faction()
                            local region_key = context:region():name()

                            return previous_owner:is_human() and previous_owner:name() == faction_key and
                            region_key == "wh2_main_shifting_sands_ka-sabar"
                        end,
                        function(context)
                            message(faction_key, "lose_kasabaar")

                            cm:remove_effect_bundle("sabaar_fountain", faction_key)
                            cm:set_saved_value("sabarr_ai_occupied", true)
                        end,
                        false
                    )
                end
            end

            ---ME ZANDRI
            if not cm:get_saved_value("zandri_occupied") then
                core:add_listener(
                    "zandri_me_occupylistner",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_me_take_zandri"
                    end,
                    function(context)
                        core:add_listener(
                            "zandrioccupymedilemma",
                            "DilemmaChoiceMadeEvent",
                            function(context)
                                return context:dilemma():starts_with("ovn_dilemma_zandri_occupy")
                            end,
                            function(context)
                                message(faction_key, "grudge_zandri")
                                local type = "wizard"
                                local subtype = "vladimir_stormbringer"
                                local x, y = 510, 140
                                local callback = function(cqi) cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_vladimir_stormbringer", false) end

                                local choice = context:choice()

                                if choice == 1 then
                                    subtype = "dlc03_emp_amber_wizard"
                                    callback =
                                        function(cqi)
                                            cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_alloy", false);
                                            cm:replenish_action_points(cm:char_lookup_str(cqi));
                                            cm:add_agent_experience("character_cqi:"..cqi, 1000)
                                        end
                                elseif choice == 2 then
                                    subtype = "emp_celestial_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_ubersbrom", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 1500)
                                    end
                                elseif choice == 3 then
                                    subtype = "emp_bright_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_luther_flamestrike", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 1500)
                                    end
                                end

                                cm:create_agent(
                                    faction_key,
                                    type,
                                    subtype,
                                    x,
                                    y,
                                    false,
                                    callback
                                )
                            end,
                            true
                        )
                        cm:trigger_dilemma("wh2_main_emp_grudgebringers" , "ovn_dilemma_zandri_occupy")
                        cm:set_saved_value("zandri_occupied", true)
                    end,
                    false
                )
            end

     --VORTEX MISSIONS--
        else

            -- CERIDIAN --
            if not cm:get_saved_value("ceridan_rescue") then
                core:add_listener(
                    "Ceridan_Vortex_Mission",
                    "FactionTurnStart",
                    function(context)
                        return context:faction():is_human() and context:faction():name() == "wh2_main_emp_grudgebringers" and cm:model():turn_number() == 3
                    end,
                    function(context)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_move_to_swem", true)
                    end,
                    false
                );

                core:add_listener(
                    "Enter_Swem_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_vortex_move_to_swem"
                    end,
                    function(context)
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "ceridan", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:set_saved_value("ceridan_rescue", true)
                    end,
                    false
                )

            end

            if not cm:get_saved_value("morgheim_rescue") then

                core:add_listener(
                    "Morgheim_Vortex_Mission",
                    "FactionTurnStart",
                    function(context)
                        local fact = context:faction()
                        return fact:is_human() and fact:name() == faction_key and cm:model():turn_number() == 2
                    end,
                    function(context)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_kill_dk", true)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_take_morgheim", true)
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "azguz_bloodfist_dwarf_warriors", 1, 20, 1, 0.1, 0, "", "", "", true)

                        message(faction_key, "grudge_start_two")
                    end,
                    false
                )

                core:add_listener(
                    "Take_Morgheim_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_vortex_take_morgheim"
                    end,
                    function(context)
                        local faction_interface = context:mission():faction()
                        local character = faction_interface:faction_leader()

                        cm:add_unit_to_faction_mercenary_pool(faction_interface, "elrod_wood_elf_glade_guards", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:add_unit_to_faction_mercenary_pool(faction_interface, "dargrimm_firebeard_dwarf_warriors", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:force_add_ancillary(character, "chalcidar_orb", true, false)

                        message(faction_key, "grudge_rescue")
                        cm:set_saved_value("morgheim_rescue", true)
                    end,
                    false
                )
            end

            --KA-SABAAR AND THE FOUNTAIN OF LIGHT--
            if not cm:get_saved_value("sabarr_occupied") then
                core:add_listener(
                    "take_ka_sabar_listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_vortex_take_kasabar"
                    end,
                    function(context)
                        core:add_listener(
                            "sabaaroccupydilemma",
                            "DilemmaChoiceMadeEvent",
                            function(context) return context:dilemma():starts_with("ovn_dilemma_sabaar_occupy") end,
                            function(context)
                            if context:choice() == 0 then
                                cm:apply_effect_bundle("sabaar_fountain", "wh2_main_emp_grudgebringers", -1)
                                cm:set_saved_value("sabarr_occupied", true);
                            end
                            end,
                            true
                        )

                        cm:trigger_dilemma("wh2_main_emp_grudgebringers" , "ovn_dilemma_sabaar_occupy")
                    end,
                    false
                );

            else
                if not cm:get_saved_value("sabarr_ai_occupied") then
                    -- check if someone else conquers ka-sabar
                    core:add_listener(
                        "grudge_lose_ka_sabaar_listner",
                        "RegionFactionChangeEvent",
                        function(context)
                            local previous_owner = context:previous_faction()
                            local region_key = context:region():name()

                            return previous_owner:is_human() and previous_owner:name() == faction_key and
                            region_key == "wh2_main_vor_shifting_sands_ka-sabar"
                        end,
                        function(context)
                            message(faction_key, "lose_kasabaar")

                            cm:remove_effect_bundle("sabaar_fountain", faction_key)
                            cm:set_saved_value("sabarr_ai_occupied", true)
                        end,
                        false
                    )
                end
            end

            if not cm:get_saved_value("zandri_occupied") then
                core:add_listener(
                    "zandrioccupylistner",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_vortex_take_zandri"
                    end,
                    function(context)
                        core:add_listener(
                            "zandrioccupydilemma",
                            "DilemmaChoiceMadeEvent",
                            function(context)
                                return context:dilemma():starts_with("ovn_dilemma_zandri_occupy")
                            end,
                            function(context)
                                message(faction_key, "grudge_zandri")
                                local type = "wizard"
                                local subtype = "vladimir_stormbringer"
                                local x, y = 636, 309
                                local callback = function(cqi) cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_vladimir_stormbringer", false) end

                                local choice = context:choice()

                                if choice == 1 then
                                    subtype = "dlc03_emp_amber_wizard"
                                    callback =
                                        function(cqi)
                                            cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_alloy", false);
                                            cm:replenish_action_points(cm:char_lookup_str(cqi));
                                            cm:add_agent_experience("character_cqi:"..cqi, 1000)
                                        end
                                elseif choice == 2 then
                                    subtype = "emp_celestial_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_ubersbrom", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 1500)
                                    end
                                elseif choice == 3 then
                                    subtype = "emp_bright_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_luther_flamestrike", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 1500)
                                    end
                                end

                                cm:create_agent(
                                    faction_key,
                                    type,
                                    subtype,
                                    x,
                                    y,
                                    false,
                                    callback
                                )
                            end,
                            true
                        )
                        cm:trigger_dilemma("wh2_main_emp_grudgebringers" , "ovn_dilemma_zandri_occupy")
                        cm:set_saved_value("zandri_occupied", true)
                    end,
                    false
                )
            end
        end
    end
end

cm:add_first_tick_callback(
    function()
        grudgebringers_init()
    end
)

local grudgebringers_ai_unit_gifts_cooldown = 6

---@param grudgebringers_faction CA_FACTION
local function handle_grudgebringers_ai_unit_gifts(grudgebringers_faction)
	local current_turn_num = cm:model():turn_number()
	if current_turn_num % grudgebringers_ai_unit_gifts_cooldown ~= 0 then
		return
	end

	if current_turn_num < 25 then
		ovn_early_imperial_reinforcements(grudebringers_faction_key, true)
	else
		ovn_late_imperial_reinforcements(grudebringers_faction_key, true)
	end
end

core:remove_listener('ovn_grudgebringers_on_faction_turn_start')
core:add_listener(
	'ovn_grudgebringers_on_faction_turn_start',
	'FactionTurnStart',
	true,
	function(context)
		---@type CA_FACTION
		local faction = context:faction()
		if faction:name() ~= grudebringers_faction_key then return end

		if not faction:is_human() then
			handle_grudgebringers_ai_unit_gifts(faction)
			return
		end
	end,
	true
)
