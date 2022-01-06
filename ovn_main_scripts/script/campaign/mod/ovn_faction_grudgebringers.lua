local function binding_iter(binding)
	local pos = 0
	local num_items = binding:num_items()
	return function()
			if pos < num_items then
					local item = binding:item_at(pos)
					pos = pos + 1
					return item
			end
			return
	end
end

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
				local faction_leader = grudebringers:faction_leader()
        cm:force_add_ancillary(faction_leader, "ovn_anc_magic_standard_ptolos", true, true);
        cm:force_add_ancillary(faction_leader, "grudge_item_grudgebringer_sword", true, true);
        cm:force_add_ancillary(faction_leader, "grudge_item_horn_of_urgok", true, true);
    end;
end

local function create_replenishment_button_tutorial()
	local dialogue_box = core:get_or_create_component("ovn_grudgebringers_replenish_button_tutorial", "ui/common ui/dialogue_box")
	core:add_listener(
		"ovn_grudgebringers_replenish_button_tutorial_real_time_trigger_cb",
		"RealTimeTrigger",
		function(context)
			return context.string == "ovn_grudgebringers_replenish_button_tutorial_real_time_trigger"
		end,
		function(context)
			local dialogue_box = find_uicomponent(core:get_ui_root(), "ovn_grudgebringers_replenish_button_tutorial")
			if not dialogue_box then return end

			dialogue_box:SetCanResizeWidth(true)
			dialogue_box:SetCanResizeHeight(true)
			dialogue_box:Resize(600,850)
			local replenish_text = find_uicomponent(dialogue_box, "DY_text")
			replenish_text:SetStateText("[[col:white]]You can manually replenish your units near Empire settlements.[[/col]]")
			replenish_text:SetDockingPoint(5)
			replenish_text:SetDockOffset(1,280)

			local button_cancel = find_uicomponent(dialogue_box, "both_group", "button_cancel")
			button_cancel:SetVisible(false)

			local button_tick = find_uicomponent(dialogue_box, "both_group", "button_tick")
			button_tick:SetDockingPoint(8)
			button_tick:SetDockOffset(0,-30)

			local bg_image = UIComponent(dialogue_box:CreateComponent("pj_selectable_start_bg_image", "ui/templates/custom_image"))
			bg_image:SetImagePath("ui/ovn/ovn_grudgebringers_replenish_button_tutorial.png", 4)
			bg_image:SetDockingPoint(5)
			bg_image:SetCanResizeWidth(true)
			bg_image:SetCanResizeHeight(true)
			bg_image:Resize(542,542)
			bg_image:SetDockOffset(0,-115)
		end,
		false
	)
	real_timer.register_singleshot("ovn_grudgebringers_replenish_button_tutorial_real_time_trigger", 0)
end

local function add_replenishment_to_all_garrisons()
	local f = cm:get_faction("wh2_main_emp_grudgebringers")

	local custom_bundle = cm:create_new_custom_effect_bundle("ovn_grudgebringers_garrison_replenishment")
	custom_bundle:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "character_to_force_own", 20)

	---@type CA_CHAR
	for char in binding_iter(f:character_list()) do
		if char:has_military_force() and char:military_force():is_armed_citizenry() then
			cm:apply_custom_effect_bundle_to_character(custom_bundle, char)
		end
	end
end

core:remove_listener("ovn_grudgebringers_apply_garrison_replenishment")
core:add_listener(
	"ovn_grudgebringers_apply_garrison_replenishment",
	"FactionTurnEnd",
	function(context)
		---@type CA_FACTION
		local faction = context:faction()
		return faction:name() == "wh2_main_emp_grudgebringers"
	end,
	function(context)
		add_replenishment_to_all_garrisons()
	end,
	true
)

local function set_up_grudgebingers_ME_confed_listener()
    if not cm:get_saved_value("ovn_grudge_hire_save") and (cm:get_faction("wh_main_emp_empire"):is_human() or cm:get_faction("wh2_dlc13_emp_golden_order"):is_human()) then
        core:add_listener(
            "ovn_grudge_hire_dilemma",
            "FactionTurnStart",
            function(context)
                local faction = context:faction()
                return 1 == cm:random_number(33, 1)
                and (
                    (
                        faction:name() == "wh_main_emp_empire"
                        and faction:is_human()
                    )
                    or
                    (
                        faction:name() == "wh2_dlc13_emp_golden_order"
                        and faction:is_human()
                    )
                )
            end,
            function(context)
                local faction_string = context:faction():name()

                core:remove_listener("ovn_grudge_hire_confed_choice")
                core:add_listener(
                    "ovn_grudge_hire_confed_choice",
                    "DilemmaChoiceMadeEvent",
                    function(context) return context:dilemma():starts_with("ovn_dilemma_grudge_hire") end,
                    function(context)
                        local faction_string = context:faction():name()
                        if context:choice() == 0 then
                            local grudebringers_string = "wh2_main_emp_grudgebringers"
                            local faction_interface = cm:get_faction(faction_string)
                            cm:disable_event_feed_events(true, "", "", "diplomacy_trespassing")
                            cm:disable_event_feed_events(true, "", "", "faction_joins_confederation")
                            if cm:get_faction("wh2_main_emp_grudgebringers"):is_dead() then
                                cm:create_force_with_general(
                                    faction_string,
                                    "grudgebringer_infantry,grudgebringer_cannon,grudgebringer_crossbow,eusebio_flagellants",
                                    "wh2_main_dragon_isles_shattered_stone_isle",
                                    687,
                                    333,
                                    "general",
                                    "morgan_bernhardt",
                                    "names_name_3110890001",
                                    "",
                                    "names_name_3110890002",
                                    "",
                                    false,
                                    function(cqi)
                                        cm:set_character_immortality("character_cqi:"..cqi, true);
                                        cm:add_agent_experience("character_cqi:"..cqi, 2500)
                                        cm:set_character_unique("character_cqi:"..cqi, true);
                                        local character = cm:get_character_by_cqi(cqi)
                                        cm:force_add_ancillary(character, "ovn_anc_magic_standard_ptolos", true, false)
                                        cm:force_add_ancillary(character, "grudge_item_grudgebringer_sword", true, false)
                                        cm:force_add_ancillary(character, "grudge_item_horn_of_urgok", true, false)
                                    end
                                )
                            else
                                cm:teleport_to("faction:wh2_main_emp_grudgebringers,forename:3110890001", 687, 333, true)
                                cm:force_confederation(faction_string, "wh2_main_emp_grudgebringers")
                            end

                            cm:callback(
                                function()
                                    cm:disable_event_feed_events(false, "", "", "diplomacy_trespassing")
                                    cm:disable_event_feed_events(false, "", "", "faction_joins_confederation")
                                end,
                                1
                            )

                            local unit_count = 1 -- card32 count
                            local rcp = 20 -- float32 replenishment_chance_percentage
                            local max_units = 1 -- int32 max_units
                            local murpt = 0.1 -- float32 max_units_replenished_per_turn
                            local xp_level = 0 -- card32 xp_level
                            local frr = "" -- (may be empty) String faction_restricted_record
                            local srr = "" -- (may be empty) String subculture_restricted_record
                            local trr = "" -- (may be empty) String tech_restricted_record
                            local units = {
                                "grudgebringer_infantry",
                                "grudgebringer_cannon",
                                "grudgebringer_crossbow",
                            }

                            for _, unit in ipairs(units) do
                                cm:add_unit_to_faction_mercenary_pool(
                                    faction_interface,
                                    unit,
                                    unit_count,
                                    rcp,
                                    max_units,
                                    murpt,
                                    xp_level,
                                    frr,
                                    srr,
                                    trr,
                                    true
                                )
                            end

                            cm:set_saved_value("ovn_grudge_hire_save", true)
                        end
                    end,
                    false
                )

                cm:trigger_dilemma(faction_string, "ovn_dilemma_grudge_hire")
            end,
            true
        )
    end
end

local function set_up_grudgebingers_vortex_confed_listener()
    if not cm:get_saved_value("ovn_grudge_hire_save") and cm:get_faction("wh2_dlc13_emp_the_huntmarshals_expedition"):is_human() then
        core:add_listener(
            "ovn_grudge_hire_dilemma",
            "FactionTurnStart",
            function(context)
                local faction = context:faction()
                return 1 == cm:random_number(33, 1)
                    and faction:name() == "wh2_dlc13_emp_the_huntmarshals_expedition"
                    and faction:is_human()
            end,
            function(context)
                local faction_string = context:faction():name()

                core:remove_listener("ovn_grudge_hire_confed_choice")
                core:add_listener(
                    "ovn_grudge_hire_confed_choice",
                    "DilemmaChoiceMadeEvent",
                    function(context) return context:dilemma():starts_with("ovn_dilemma_grudge_hire_vortex") end,
                    function(context)
                        local faction_string = context:faction():name()
                        if context:choice() == 0 then
                            local grudebringers_string = "wh2_main_emp_grudgebringers"
                            local faction_interface = cm:get_faction(faction_string)
                            cm:disable_event_feed_events(true, "", "", "diplomacy_trespassing")
                            cm:disable_event_feed_events(true, "", "", "faction_joins_confederation")
                            if cm:get_faction("wh2_main_emp_grudgebringers"):is_dead() then
                                cm:create_force_with_general(
                                    faction_string,
                                    "grudgebringer_infantry,grudgebringer_cannon,grudgebringer_crossbow,eusebio_flagellants",
                                    "wh2_main_dragon_isles_shattered_stone_isle",
                                    687,
                                    333,
                                    "general",
                                    "morgan_bernhardt",
                                    "names_name_3110890001",
                                    "",
                                    "names_name_3110890002",
                                    "",
                                    false,
                                    function(cqi)
                                        cm:set_character_immortality("faction:wh2_main_emp_grudgebringers,surname:3110890002", true);
                                        cm:set_character_unique("character_cqi:"..cqi, true);
                                        local character = cm:get_character_by_cqi(cqi)
                                        cm:force_add_ancillary(character, "ovn_anc_magic_standard_ptolos", true, false)
                                        cm:force_add_ancillary(character, "grudge_item_grudgebringer_sword", true, false)
                                    end
                                )
                            else
                                cm:teleport_to("faction:wh2_main_emp_grudgebringers,forename:3110890001", 342, 275, true)
                                cm:force_confederation(faction_string, "wh2_main_emp_grudgebringers")
                            end

                            cm:callback(
                                function()
                                    cm:disable_event_feed_events(false, "", "", "diplomacy_trespassing")
                                    cm:disable_event_feed_events(false, "", "", "faction_joins_confederation")
                                end,
                                1
                            )

                            local unit_count = 1 -- card32 count
                            local rcp = 20 -- float32 replenishment_chance_percentage
                            local max_units = 1 -- int32 max_units
                            local murpt = 0.1 -- float32 max_units_replenished_per_turn
                            local xp_level = 0 -- card32 xp_level
                            local frr = "" -- (may be empty) String faction_restricted_record
                            local srr = "" -- (may be empty) String subculture_restricted_record
                            local trr = "" -- (may be empty) String tech_restricted_record
                            local units = {
                                "grudgebringer_infantry",
                                "grudgebringer_cannon",
                                "grudgebringer_crossbow",
                            }

                            for _, unit in ipairs(units) do
                                cm:add_unit_to_faction_mercenary_pool(
                                    faction_interface,
                                    unit,
                                    unit_count,
                                    rcp,
                                    max_units,
                                    murpt,
                                    xp_level,
                                    frr,
                                    srr,
                                    trr,
                                    true
                                )
                            end

                            cm:set_saved_value("ovn_grudge_hire_save", true)
                        end
                    end,
                    false
                )

                cm:trigger_dilemma(faction_string, "ovn_dilemma_grudge_hire_vortex")
            end,
            true
        )
    end
end

local function grudgebringers_init()
    -- ALLOW EMPIRE FACTIONS TO HIRE GRUDGEBRINGERS IN MORTAL EMPIRES
    if cm:model():campaign_name("main_warhammer") then
        set_up_grudgebingers_ME_confed_listener()
    else
        set_up_grudgebingers_vortex_confed_listener()
    end

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
				if cm:is_new_game() then
					cm:callback(
						function()
							create_replenishment_button_tutorial()
						end,
						6
					)
				end

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
      --[[  if campaign_name == "main_warhammer" then

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
        end ]]

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
                "blacktoweroccupylistner",
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

                    cm:force_add_ancillary(character, "malach_sword", false, false)
                    cm:set_saved_value("black_tower_storm", true);
                end,
                false
            )
        end

        --MORTAL EMPIRES MISSIONS --
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
                        cm:add_unit_to_faction_mercenary_pool(faction_interface, "azguz_bloodfist_dwarf_warriors", 1, 20, 1, 0.1, 0, "", "", "", true)

                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_take_zandri", true)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_move_to_swem", true)
                        cm:force_add_ancillary(character, "chalcidar_orb", true, false)
                        message(faction_key, "grudge_rescue")
                        cm:set_saved_value("morgheim_rescue", true)
                    end,
                    false
                )
            end

              -- CERIDIAN --
             --[[ if not cm:get_saved_value("ceridan_rescue") then
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
                );]]

              --[[  core:add_listener(
                    "ME_kill_dk_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_me_kill_dk"
                    end,
                    function(context)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_kill_arkhan", true)
                    end,
                    false
                )
                ]]

                core:add_listener(
                    "Enter_ME_Swem_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_me_move_to_swem"
                    end,
                    function(context)
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "ceridan", 1, 20, 1, 0.1, 0, "", "", "", true)
                        --cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_me_take_kasabar", true)
                       -- cm:set_saved_value("ceridan_rescue", true)
                    end,
                    false
                )

            -- end

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
                                            cm:add_agent_experience("character_cqi:"..cqi, 4000)
                                        end
                                elseif choice == 2 then
                                    subtype = "emp_celestial_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_ubersbrom", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 4000)
                                    end
                                elseif choice == 3 then
                                    subtype = "emp_bright_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_luther_flamestrike", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 4000)
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
           --[[ if not cm:get_saved_value("ceridan_rescue") then
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
                ); ]]



                core:add_listener(
                    "Enter_Swem_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_grudge_vortex_move_to_swem"
                    end,
                    function(context)
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "ceridan", 1, 20, 1, 0.1, 0, "", "", "", true)
                        --cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_take_kasabar", true)
                        --cm:set_saved_value("ceridan_rescue", true)

                    end,
                    false
                )

           -- end

          --[[ core:add_listener(
            "vor_kill_dk_Listener",
            "MissionSucceeded",
            function(context)
                return context:mission():mission_record_key() == "ovn_grudge_vortex_kill_dk"
            end,
            function(context)
                cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_kill_arkhan", true)
            end,
            false
        )]]

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
                        cm:add_unit_to_faction_mercenary_pool(faction_obj, "azguz_bloodfist_dwarf_warriors", 1, 20, 1, 0.1, 0, "", "", "", true)
                        cm:force_add_ancillary(character, "chalcidar_orb", true, false)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_move_to_swem", true)
                        cm:trigger_mission("wh2_main_emp_grudgebringers", "ovn_grudge_vortex_take_zandri", true)

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
                                            cm:add_agent_experience("character_cqi:"..cqi, 4000)
                                        end
                                elseif choice == 2 then
                                    subtype = "emp_celestial_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_ubersbrom", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 4000)
                                    end
                                elseif choice == 3 then
                                    subtype = "emp_bright_wizard"
                                    callback =
                                    function(cqi)
                                        cm:force_add_trait(cm:char_lookup_str(cqi), "grudge_trait_name_dummy_luther_flamestrike", false);
                                        cm:replenish_action_points(cm:char_lookup_str(cqi));
                                        cm:add_agent_experience("character_cqi:"..cqi, 4000)
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

		for char in binding_iter(faction:character_list()) do
			cm:set_character_excluded_from_trespassing(char, true)
		end

		if not faction:is_human() then
			handle_grudgebringers_ai_unit_gifts(faction)
			return
		end
	end,
	true
)

core:remove_listener("ovn_grudgebringers_on_character_created_remove_trespass_penalty")
core:add_listener(
	"ovn_grudgebringers_on_character_created_remove_trespass_penalty",
	"CharacterCreated",
	function(context)
		---@type CA_FACTION
		local faction = context:character():faction()
		return faction:name() == grudebringers_faction_key
	end,
	function(context)
		local char = context:character()
		cm:set_character_excluded_from_trespassing(char, true)
	end,
	true
)

core:remove_listener("ovn_grudgebringers_on_character_replacing_general_remove_trespass_penalty")
core:add_listener(
	"ovn_grudgebringers_on_character_replacing_general_remove_trespass_penalty",
	"CharacterReplacingGeneral",
	function(context)
		---@type CA_FACTION
		local faction = context:character():faction()
		return faction:name() == grudebringers_faction_key
	end,
	function(context)
		local char = context:character()
		cm:set_character_excluded_from_trespassing(char, true)
	end,
	true
)
