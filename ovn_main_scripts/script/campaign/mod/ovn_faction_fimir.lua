local function setup_diplo()
    if cm:model():campaign_name("main_warhammer") then
        
core:add_listener(
    "fimir_region_mist",
    "FactionTurnStart",
    function(context) return context:faction():name() == "wh_dlc08_nor_goromadny_tribe" or context:faction():name() == "wh2_main_wef_treeblood"
    end,
    function(context)

        local faction = context:faction();
        local region_list = faction:region_list();
        
        for i = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(i);
            local current_region_name = region:name();

        cm:create_storm_for_region(current_region_name, 1, 1, "ovn_fimir_mist");
        cm:remove_effect_bundle_from_region("ovn_fimir_region_mist", current_region_name);
        cm:apply_effect_bundle_to_region("ovn_fimir_region_mist", current_region_name, 2)
       
        end
        
    end,
    true
);

    end
end

local function fimir_init()
    setup_diplo()
end

cm:add_first_tick_callback(
    function()
        fimir_init()
    end
)