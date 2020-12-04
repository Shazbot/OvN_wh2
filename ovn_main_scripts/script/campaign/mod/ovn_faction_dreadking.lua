--------------------------------------------------------------
--------- DREAD KING LEGIONS GROWING POWER MECHANIC ----------
--------------------------------------------------------------

--[[   if not cm:get_saved_value("dk_power_one") then
    core:add_listener(
                "dk_power_one_listener",
                "FactionRoundStart",
                function(context) return context:faction():name() == "wh2_dlc09_tmb_the_sentinels" and cm:model():turn_number() == 25 end,
                function()
                local human_players = cm:get_human_factions();
                cm:apply_effect_bundle("dk_power_one", "wh2_dlc09_tmb_the_sentinels", -1)
                cm:set_saved_value("dk_power_one", true);
                end,
                false
                );
end;

if not cm:get_saved_value("dk_power_two") then
    core:add_listener(
                "dk_power_two_listener",
                "FactionRoundStart",
                function(context) return context:faction():name() == "wh2_dlc09_tmb_the_sentinels" and cm:model():turn_number() == 55 end,
                function()
                local human_players = cm:get_human_factions();
                cm:remove_effect_bundle("dk_power_one", "wh2_dlc09_tmb_the_sentinels", -1)
                cm:apply_effect_bundle("dk_power_two", "wh2_dlc09_tmb_the_sentinels", -1)
                cm:set_saved_value("dk_power_two", true);
                end,
                false
                );
end;

if not cm:get_saved_value("dk_power_three") then
    core:add_listener(
                "dk_power_three_listener",
                "FactionRoundStart",
                function(context) return context:faction():name() == "wh2_dlc09_tmb_the_sentinels" and cm:model():turn_number() == 90 end,
                function()
                local human_players = cm:get_human_factions();
                cm:remove_effect_bundle("dk_power_two", "wh2_dlc09_tmb_the_sentinels", -1)
                cm:apply_effect_bundle("dk_power_three", "wh2_dlc09_tmb_the_sentinels", -1)
                cm:set_saved_value("dk_power_three", true);
                end,
                false
                );
end;]]

local function setup_diplo(is_human)
	-- allow diplomacy with all (can't make peace with Grudgebringers, defined in grudgebringers_setup())
    cm:force_diplomacy("faction:wh2_dlc09_tmb_the_sentinels", "all", "all", true, true, true);
end


local function dreadking_init()
    local faction_key = "wh2_dlc09_tmb_the_sentinels"
    local faction_obj = cm:get_faction(faction_key)

    if faction_obj:is_null_interface() then
        return false
    end

    -- remove vanilla nerf
    cm:remove_effect_bundle("wh2_main_negative_research_speed_50", "wh2_dlc09_tmb_the_sentinels", -1)

    setup_diplo(faction_obj:is_human())

       --MORTAL EMPIRES MISSION--
    if cm:get_faction("wh2_dlc09_tmb_the_sentinels"):is_human() then
       if cm:model():campaign_name("main_warhammer") then
        if not cm:get_saved_value("morgheim_rescue") then

            core:add_listener(
                "dk_Morgheim_ME_Mission",
                "FactionTurnStart",
                function(context)
                    local fact = context:faction()
                    return fact:is_human() and fact:name() == faction_key and cm:model():turn_number() == 2
                end,
                function(context)
                    cm:trigger_mission("wh2_dlc09_tmb_the_sentinels", "ovn_dk_me_take_morgheim", true)
                end,
                false
            )

            core:add_listener(
                    "dk_Take_ME_Morgheim_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_dk_me_take_morgheim"
                    end,
                    function(context)

                        cm:spawn_character_to_pool(
                            "wh2_dlc09_tmb_the_sentinels",
                            "names_name_247259237",
                            "",
                            "names_name_247259238",
                            "",
                            18,
                            true,
                            "general",
                            "elo_hand_of_nagash",
                            false,
                            ""
                        )

                        cm:set_saved_value("morgheim_rescue", true)
                    end,
                    false
                )
            end

        --VORTEX MISSION--
        elseif not cm:get_saved_value("morgheim_rescue") then

            core:add_listener(
                "dk_Morgheim_vor_Mission",
                "FactionTurnStart",
                function(context)
                    local fact = context:faction()
                    return fact:is_human() and fact:name() == faction_key and cm:model():turn_number() == 2
                end,
                function(context)
                    cm:trigger_mission("wh2_dlc09_tmb_the_sentinels", "ovn_dk_vortex_take_morgheim", true)
                end,
                false
            )

            core:add_listener(
                    "dk_Take_vor_Morgheim_Listener",
                    "MissionSucceeded",
                    function(context)
                        return context:mission():mission_record_key() == "ovn_dk_vortex_take_morgheim"
                    end,
                    function(context)

                        cm:spawn_character_to_pool(
                            "wh2_dlc09_tmb_the_sentinels",
                            "names_name_247259237",
                            "names_name_247259238",
                            "",
                            "",
                            18,
                            true,
                            "general",
                            "elo_hand_of_nagash",
                            false,
                            ""
                        )

                        cm:set_saved_value("morgheim_rescue", true)
                    end,
                    false
                )
            end

    else
		if cm:is_new_game() then

        local dreadking = cm:get_faction("wh2_dlc09_tmb_the_sentinels");
            cm:force_add_ancillary(dreadking:faction_leader(), "malach_sword", true, true);
            cm:force_add_ancillary(dreadking:faction_leader(), "chalcidar_orb", true, true);
            cm:apply_effect_bundle("dk_hon_spawn", "wh2_dlc09_tmb_the_sentinels", -1)

            cm:spawn_character_to_pool(
                "wh2_dlc09_tmb_the_sentinels",
                "names_name_247259237",
                "names_name_247259238",
                "",
                "",
                18,
                true,
                "general",
                "elo_hand_of_nagash",
                false,
                ""
            )
end
end
end


cm:add_first_tick_callback(
    function()
        dreadking_init()
    end
)
