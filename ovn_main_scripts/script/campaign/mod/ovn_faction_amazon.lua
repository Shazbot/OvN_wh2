local function setup_diplo()
    cm:force_diplomacy("faction:wh2_main_amz_amazons", "subculture:wh_main_sc_nor_norsca", "all", false, false, true)
    cm:force_diplomacy("faction:wh2_main_amz_amazons", "subculture:wh_main_sc_nor_norsca", "war", true, true, true)
end

local function amazon_init()
    setup_diplo()
end

cm:add_first_tick_callback(
    function()
        amazon_init()
    end
)