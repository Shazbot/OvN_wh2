cm:add_first_tick_callback(function()
    if cm:get_local_faction(true) == "wh2_main_ovn_chaos_dwarfs" 
    or cm:get_local_faction(true) == "wh2_main_arb_aswad_scythans" 
    or cm:get_local_faction(true) == "wh2_main_arb_caliphate_of_araby" 
    or cm:get_local_faction(true) == "wh2_main_arb_flaming_scimitar" 
    or cm:get_local_faction(true) == "wh2_main_wef_treeblood" 
    or cm:get_local_faction(true) == "wh_dlc08_nor_naglfarlings" 
    or cm:get_local_faction(true) == "wh_dlc08_nor_goromadny_tribe" 
    then

        local button_slaves = find_uicomponent(
            core:get_ui_root(),
            "layout", "faction_buttons_docker", "button_group_management", "button_slaves"
        )
        if button_slaves then
            local icon_path = effect.get_skinned_image_path("icon_button_slaves.png") 
            button_slaves:SetImagePath(icon_path, 0)
            icon_path = effect.get_skinned_image_path("button_round_large_selected_inactive.png")
            button_slaves:SetImagePath(icon_path, 1)
            icon_path = effect.get_skinned_image_path("button_round_large_pressed.png")
            button_slaves:SetImagePath(icon_path, 2)
            icon_path = effect.get_skinned_image_path("button_round_large_selected_hover.png")
            button_slaves:SetImagePath(icon_path, 3)
            icon_path = effect.get_skinned_image_path("button_round_large_hover.png")
            button_slaves:SetImagePath(icon_path, 4)
            icon_path = effect.get_skinned_image_path("button_round_large_active.png")
            button_slaves:SetImagePath(icon_path, 5)
            icon_path = effect.get_skinned_image_path("button_round_large_inactive.png")
            button_slaves:SetImagePath(icon_path, 6)
            icon_path = effect.get_skinned_image_path("button_round_large_selected.png")
            button_slaves:SetImagePath(icon_path, 7)
            icon_path = effect.get_skinned_image_path("button_round_large_selected_pressed.png")
            button_slaves:SetImagePath(icon_path, 8)
            icon_path = effect.get_skinned_image_path("spell_dial_frame.png")
            button_slaves:SetImagePath(icon_path, 9)
        end
    
        core:add_listener(
            "pj_chorfs_fix_slaves_panel_slaves_buttons",
            "PanelOpenedCampaign",
            function(context)
                return context.string == "slaves_panel"
            end,
            function()
                cm:callback(function()
                    local slaves_buttonset = find_uicomponent(
                        core:get_ui_root(),
                        "slaves_panel", "listview", "list_clip", "list_box", "0", "slaves_buttonset"
                    )
                    if not slaves_buttonset then
                        return
                    end
                    local req = find_uicomponent(slaves_buttonset, "button_request")
                    local stop = find_uicomponent(slaves_buttonset, "button_no_more")
                    local recieve = find_uicomponent(slaves_buttonset, "button_recieve")
                    if req and stop and recieve then
                        local icon_path = effect.get_skinned_image_path("icon_slave_options_request.png")
                        req:SetImagePath(icon_path, 0)
                        icon_path = effect.get_skinned_image_path("icon_slave_options_stop.png")
                        stop:SetImagePath(icon_path, 0)
                        icon_path = effect.get_skinned_image_path("icon_slave_options_receive.png")
                        recieve:SetImagePath(icon_path, 0)
                    end
                end, 0.1)
            end,
            true
        )

    end
end)