-- Heavily based on Vandy's "Queek's Burrow" mod

local faction_key = "wh2_main_emp_the_moot"

local function remove_component(uic_obj)
    if is_uicomponent(uic_obj) then
        uic_obj = {uic_obj}
    end

    if not is_table(uic_obj) then
        -- issue
        script_error("remove_component() called, but the uic obj supplied wasn't a single UIC or a table of UIC's!")
        return false
    end

    if not is_uicomponent(uic_obj[1]) then
        -- issue
        script_error("remove_component() called, but the uic obj supplied wasn't a single UIC or a table of UIC's!")
        return false
    end

    local killer = core:get_or_create_component("script_dummy", "ui/campaign ui/script_dummy")

    for i = 1, #uic_obj do
        local uic = uic_obj[i]
        if is_uicomponent(uic) then
            killer:Adopt(uic:Address())
        end
    end

    killer:DestroyChildren()
end 

local function ui_init()
    local topbar = find_uicomponent("layout", "resources_bar", "topbar_list_parent")
    if is_uicomponent(topbar) then
        local uic = UIComponent(topbar:CreateComponent("hlfng_headtaking", "ui/campaign ui/hlfng_headtaking"))

        find_uicomponent(uic, "grom_goals"):SetVisible(false)
        find_uicomponent(uic, "trait"):SetVisible(false)
    end

    local function close_listener()
        core:add_listener(
            "halfling_close_panel",
            "ComponentLClickUp",
            function(context)
                local uic = find_uicomponent("hlfng_cauldron", "right_colum", "exit_panel_button")
                if is_uicomponent(uic) then
                    return context.component == uic:Address()
                end
                return false
            end,
            function(context)
                local panel = find_uicomponent("hlfng_cauldron")
                local dummy = core:get_or_create_component("script_dummy", "ui/campaign ui/script_dummy")
                dummy:Adopt(panel:Address())
                dummy:DestroyChildren()

                -- reenable the esc key
                cm:steal_escape_key(false)

                core:remove_listener("halfling_close_panel")
            end,
            false
        )

        core:add_listener(
            "halfling_close_panel",
            "ShortcutTriggered",
            function(context) 
                return context.string == "escape_menu"
            end,
            function(context)
                local panel = find_uicomponent("hlfng_cauldron")
                local dummy = core:get_or_create_component("script_dummy", "ui/campaign ui/script_dummy")
                dummy:Adopt(panel:Address())
                dummy:DestroyChildren()

                -- reenable the esc key
                cm:steal_escape_key(false)

                core:remove_listener("halfling_close_panel")
            end,
            false
        )
    end

    local function opened_up()
        -- prevent the esc key being used
        cm:steal_escape_key(true)

        -- move the effect list tt out of the way
        local effect_list = find_uicomponent("hlfng_cauldron", "left_colum", "ingredients_holder", "component_tooltip")
        local x,y = effect_list:GetDockOffset()
        local px, py = core:get_screen_resolution()
        local fx = (px * 0.72) + x

        effect_list:SetDockOffset(fx, y * 1.25)
        
        
        -- double made for no reason --TODO make it for a reason?
        local tt = find_uicomponent("hlfng_cauldron", "left_colum", "ingredients_holder", "component_tooltip2")
        --tt:SetVisible(false)
        remove_component(tt)

        -- scrap UI?
        local scrap_crap = find_uicomponent("hlfng_cauldron", "mid_colum", "cook_button_holder", "scrap_cost")
        --remove_component(scrap_crap)

        -- remove Grom's ugly gob
        local grom = find_uicomponent("hlfng_cauldron", "left_colum", "progress_display_holder", "trait")
        remove_component(grom)

        local slot_holder = find_uicomponent("hlfng_cauldron", "mid_colum", "pot_holder", "ingredients_and_effects")
        local arch = find_uicomponent("hlfng_cauldron", "mid_colum", "pot_holder", "arch")

        -- hide the animated circles around the 3/4 slots
        find_uicomponent(slot_holder, "main_ingredient_slot_1_animated_frame"):SetVisible(false)
        find_uicomponent(slot_holder, "main_ingredient_slot_4_animated_frame"):SetVisible(false)


        -- y offsets (in screen height %) needed for each ingr. slot
        local offsets = {
            [1] = 0.26,
            [2] = 0.3,
            [3] = 0.3,
            [4] = 0.26
        }

        for i,v in ipairs(offsets) do
            local slot = find_uicomponent(slot_holder, "main_ingredient_slot_"..tostring(i))
            
            local px, py = core:get_screen_resolution()

            local slotx, sloty = slot:Position()

            -- move down
            sloty = sloty + (v * py)

            -- move it
            slot:MoveTo(slotx, sloty)
        end
    end

    local function test_open()
        -- check every UI tick if the queek cauldron is open - once it is, make the edits
        -- the following triggers an RealTimeTrigger event with the string "hlfng_cauldron_test_open" every single UI tick
        real_timer.register_repeating("hlfng_cauldron_test_open", 0)

        core:add_listener(
            "test_if_open",
            "RealTimeTrigger",
            function(context)
                --ModLog("test_if_open!")
                return context.string == "hlfng_cauldron_test_open" and is_uicomponent(find_uicomponent("hlfng_cauldron")) and is_uicomponent(find_uicomponent("hlfng_cauldron", "left_colum", "ingredients_holder", "component_tooltip"))
            end,
            function(context)
                -- stop triggering!
                --ModLog("opened!")
                real_timer.unregister("hlfng_cauldron_test_open")
                --ModLog("testing!")
                --local ok, err = pcall(function()
                opened_up() --end) --if not ok then ModLog(err) end
                --ModLog("ended!")
            end,
            false
        )
    end

    core:add_listener(
        "halfling_button_pressed",
        "ComponentLClickUp",
        function(context)
            return context.string == "hlfng_headtaking"
        end,
        function(context)
            local root = core:get_ui_root()
            local test = find_uicomponent("hlfng_cauldron")
            if not is_uicomponent(test) then
                root:CreateComponent("hlfng_cauldron", "ui/campaign ui/hlfng_cauldron_panel")

                test_open()
                
                close_listener()
            end
        end,
        true
    )
end

-- table matching province to their continent (not a science)
local province_continent_lookup = {
    ["wh2_main_dragon_isles"] = "dark_lands",
	["wh2_main_gnoblar_country"] = "dark_lands",
	["wh2_main_the_broken_teeth"] = "dark_lands",
	["wh2_main_the_plain_of_bones"] = "dark_lands",
	["wh2_main_the_wolf_lands"] = "dark_lands",
	["wh_main_death_pass"] = "dark_lands",
	["wh_main_desolation_of_nagash"] = "dark_lands",
	["wh_main_eastern_badlands"] = "dark_lands",
	["wh_main_the_silver_road"] = "dark_lands",
	["wh2_main_headhunters_jungle"] = "lustria",
	["wh2_main_huahuan_desert"] = "lustria",
	["wh2_main_isthmus_of_lustria"] = "lustria",
	["wh2_main_jungles_of_green_mists"] = "lustria",
	["wh2_main_northern_great_jungle"] = "lustria",
	["wh2_main_northern_jungle_of_pahualaxa"] = "lustria",
	["wh2_main_southern_great_jungle"] = "lustria",
	["wh2_main_southern_jungle_of_pahualaxa"] = "lustria",
	["wh2_main_spine_of_sotek"] = "lustria",
	["wh2_main_the_creeping_jungle"] = "lustria",
	["wh2_main_vampire_coast"] = "lustria",
	["wh2_main_volcanic_islands"] = "lustria",
	["wh2_main_aghol_wastelands"] = "naggaroth",
	["wh2_main_blackspine_mountains"] = "naggaroth",
	["wh2_main_deadwood"] = "naggaroth",
	["wh2_main_doom_glades"] = "naggaroth",
	["wh2_main_iron_mountains"] = "naggaroth",
	["wh2_main_ironfrost_glacier"] = "naggaroth",
	["wh2_main_obsidian_peaks"] = "naggaroth",
	["wh2_main_the_black_coast"] = "naggaroth",
	["wh2_main_the_black_flood"] = "naggaroth",
	["wh2_main_the_broken_land"] = "naggaroth",
	["wh2_main_the_chill_road"] = "naggaroth",
	["wh2_main_the_clawed_coast"] = "naggaroth",
	["wh2_main_the_road_of_skulls"] = "naggaroth",
	["wh2_main_titan_peaks"] = "naggaroth",
	["wh2_main_albion"] = "norsca",
	["wh2_main_hell_pit"] = "norsca",
	["wh_main_gianthome_mountains"] = "norsca",
	["wh_main_goromadny_mountains"] = "norsca",
	["wh_main_helspire_mountains"] = "norsca",
	["wh_main_ice_tooth_mountains"] = "norsca",
	["wh_main_mountains_of_hel"] = "norsca",
	["wh_main_mountains_of_naglfari"] = "norsca",
	["wh_main_trollheim_mountains"] = "norsca",
	["wh_main_vanaheim_mountains"] = "norsca",
	["wh2_main_fort_bergbres"] = "old_world",
	["wh2_main_fort_helmgart"] = "old_world",
	["wh2_main_fort_soll"] = "old_world",
	["wh2_main_laurelorn_forest"] = "old_world",
	["wh2_main_misty_hills"] = "old_world",
	["wh2_main_sartosa"] = "old_world",
	["wh2_main_shifting_sands"] = "old_world",
	["wh2_main_skavenblight"] = "old_world",
	["wh2_main_solland"] = "old_world",
	["wh2_main_the_moot"] = "old_world",
	["wh_main_argwylon"] = "old_world",
	["wh_main_averland"] = "old_world",
	["wh_main_bastonne_et_montfort"] = "old_world",
	["wh_main_black_mountains"] = "old_world",
	["wh_main_blood_river_valley"] = "old_world",
	["wh_main_bordeleaux_et_aquitaine"] = "old_world",
	["wh_main_carcassone_et_brionne"] = "old_world",
	["wh_main_couronne_et_languille"] = "old_world",
	["wh_main_eastern_border_princes"] = "old_world",
	["wh_main_eastern_oblast"] = "old_world",
	["wh_main_eastern_sylvania"] = "old_world",
	["wh_main_estalia"] = "old_world",
	["wh_main_forest_of_arden"] = "old_world",
	["wh_main_hochland"] = "old_world",
	["wh_main_lyonesse"] = "old_world",
	["wh_main_massif_orcal"] = "old_world",
	["wh_main_middenland"] = "old_world",
	["wh_main_nordland"] = "old_world",
	["wh_main_northern_grey_mountains"] = "old_world",
	["wh_main_northern_oblast"] = "old_world",
	["wh_main_northern_worlds_edge_mountains"] = "old_world",
	["wh_main_ostermark"] = "old_world",
	["wh_main_ostland"] = "old_world",
	["wh_main_parravon_et_quenelles"] = "old_world",
	["wh_main_peak_pass"] = "old_world",
	["wh_main_reikland"] = "old_world",
	["wh_main_rib_peaks"] = "old_world",
	["wh_main_southern_grey_mountains"] = "old_world",
	["wh_main_southern_oblast"] = "old_world",
	["wh_main_stirland"] = "old_world",
	["wh_main_talabecland"] = "old_world",
	["wh_main_talsyn"] = "old_world",
	["wh_main_the_vaults"] = "old_world",
	["wh_main_the_wasteland"] = "old_world",
	["wh_main_tilea"] = "old_world",
	["wh_main_torgovann"] = "old_world",
	["wh_main_troll_country"] = "old_world",
	["wh_main_western_badlands"] = "old_world",
	["wh_main_western_border_princes"] = "old_world",
	["wh_main_western_sylvania"] = "old_world",
	["wh_main_wissenland"] = "old_world",
	["wh_main_wydrioth"] = "old_world",
	["wh_main_yn_edri_eternos"] = "old_world",
	["wh_main_zhufbar"] = "old_world",
	["wh2_main_ash_river"] = "southlands",
	["wh2_main_atalan_mountains"] = "southlands",
	["wh2_main_charnel_valley"] = "southlands",
	["wh2_main_coast_of_araby"] = "southlands",
	["wh2_main_crater_of_the_walking_dead"] = "southlands",
	["wh2_main_devils_backbone"] = "southlands",
	["wh2_main_great_desert_of_araby"] = "southlands",
	["wh2_main_great_mortis_delta"] = "southlands",
	["wh2_main_heart_of_the_jungle"] = "southlands",
	["wh2_main_kingdom_of_beasts"] = "southlands",
	["wh2_main_land_of_assassins"] = "southlands",
	["wh2_main_land_of_the_dead"] = "southlands",
	["wh2_main_land_of_the_dervishes"] = "southlands",
	["wh2_main_marshes_of_madness"] = "southlands",
	["wh2_main_southlands_jungle"] = "southlands",
	["wh2_main_southlands_worlds_edge_mountains"] = "southlands",
	["wh_main_blightwater"] = "southlands",
	["wh_main_southern_badlands"] = "southlands",
	["wh2_main_avelorn"] = "ulthuan",
	["wh2_main_caledor"] = "ulthuan",
	["wh2_main_chrace"] = "ulthuan",
	["wh2_main_cothique"] = "ulthuan",
	["wh2_main_eagle_gate"] = "ulthuan",
	["wh2_main_eataine"] = "ulthuan",
	["wh2_main_ellyrion"] = "ulthuan",
	["wh2_main_griffon_gate"] = "ulthuan",
	["wh2_main_nagarythe"] = "ulthuan",
	["wh2_main_phoenix_gate"] = "ulthuan",
	["wh2_main_saphery"] = "ulthuan",
	["wh2_main_tiranoc"] = "ulthuan",
	["wh2_main_unicorn_gate"] = "ulthuan",
	["wh2_main_yvresse"] = "ulthuan"
}

local ingredients_by_continent = {
    ["old_world"] = { "ovn_spelt", "ovn_beef", "ovn_fennel", "ovn_lettuce", "ovn_apple" },
    ["norsca"] = { "ovn_rye", "ovn_salmon", "ovn_juniper", "ovn_kale", "ovn_lingonberry" },
    ["southlands"] = { "ovn_teff", "ovn_lamb", "ovn_cumin", "ovn_lentil", "ovn_date" },
    ["ulthuan"] = { "ovn_emmer", "ovn_calamari", "ovn_marjoram", "ovn_olive", "ovn_pomegranate" },
    ["dark_lands"] = { "ovn_rice", "ovn_pork", "ovn_cardamom", "ovn_onion", "ovn_walnut" },
    ["lustria"] = { "ovn_maize", "ovn_iguana", "ovn_vanilla", "ovn_tomatoe", "ovn_pitaya" },
    ["naggaroth"] = { "ovn_barley", "ovn_turkey", "ovn_pepper", "ovn_potatoe", "ovn_cranberry" },
}

local function add_ingredient(region_obj, char_obj)
    local faction_obj = cm:get_faction(faction_key)

    local continent_key = ""
    continent_key = province_continent_lookup[region_obj:province_name()]
    
    local ingredients_list = ingredients_by_continent[continent_key]
    
    local faction_cooking_info = cm:model():world():cooking_system():faction_cooking_info(faction_obj)

    -- 100%, 80%, 60%, 40%, 20%
    -- Expected value of around 12 turns to get all 5 ingredients for a single continent
    -- Starting with 2 in Old World, 9 turns to get the last 3
    -- 81 turns to get all ingredients, pretty decent

    local rand = cm:random_number(5, 1)
    local ingredient_key = ""
    ingredient_key = ingredients_list[rand]

    if ingredient_key == "" then
        return false
    end
    
    -- fail if it selects an ingredient we already have
    if faction_cooking_info:is_ingredient_unlocked(ingredient_key) then
        return false
    end

    cm:unlock_cooking_ingredient(faction_obj, ingredient_key)

    if faction_obj:is_human() then
        local loc_prefix = "event_feed_strings_text_ovn_halfling_cooking_ingredient_unlocked_"
        cm:show_message_event_located(
            faction_key,
            loc_prefix.."title",
            loc_prefix.."primary_detail",
            loc_prefix.."secondary_detail",
            char_obj:logical_position_x(),
            char_obj:logical_position_y(),
            true,
            812
        )
    end;
end


-- initialize the mod stuff!
local function init()
    local faction_obj = cm:get_faction(faction_key)

    if not faction_obj or faction_obj:is_null_interface() then
        return false
    end;

    -- enable using 4 ingredients for a recipe
    cm:set_faction_max_primary_cooking_ingredients(faction_obj, 2)
    cm:set_faction_max_secondary_cooking_ingredients(faction_obj, 2)

    -- start with spelt and beef I guess
    cm:unlock_cooking_ingredient(faction_obj, "ovn_spelt")
    cm:unlock_cooking_ingredient(faction_obj, "ovn_beef")

    -- listener for foraging (encamp) stance, which randomly rewards an ingredient depending on continent
    core:add_listener(
        "halfling_army_goes_foraging",
		"CharacterTurnStart",
        function(context)
            local character = context:character();
            return character:has_military_force() and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP" and character:military_force():faction():name() == faction_key and character:military_force():faction():is_human() == true;
        end,
        function(context)
			local character = context:character();
			
			local region_obj = character:region();

			add_ingredient(region_obj, character);
		end,
		true
    );
end

cm:add_first_tick_callback(function()
    if cm:get_local_faction(true) == faction_key then
        ui_init()
    end

    init()
end)
