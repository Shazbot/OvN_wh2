local function ovn_weather()	
    if cm:model():campaign_name("main_warhammer") then
        core:add_listener(
            "albion_weather", 
            "FactionTurnStart", 
            function(context) 
                return context:faction():is_human()
            end,
            function(context)
                local random_number = cm:random_number(13,1)

                if random_number == 1 then
                    cm:create_storm_for_region("wh2_main_albion_albion", 1, 1, "ovn_albion_storm")
                elseif random_number == 2 then
                    cm:create_storm_for_region("wh2_main_albion_citadel_of_lead", 1, 1, "ovn_albion_storm")
                elseif random_number == 3 then
                    cm:create_storm_for_region("wh2_main_albion_isle_of_wights", 1, 1, "ovn_albion_storm")
                end
            end,
            true 
        )
    else
        core:add_listener(
            "albion_weather", 
            "FactionTurnStart", 
            function(context) 
                return context:faction():is_human()
            end,
            function(context)

                local random_number = cm:random_number(8,1)

                if random_number == 1 then
                    cm:create_storm_for_region("wh2_main_vor_albion_albion", 1, 1, "ovn_albion_storm")
                end
            end,
            true 
        )
    end
end


cm:add_first_tick_callback(function() ovn_weather() end)