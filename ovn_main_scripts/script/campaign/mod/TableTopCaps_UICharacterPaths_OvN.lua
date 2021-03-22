local rm = _G.rm

local ovn_subcultures = {
    "wh_main_sc_nor_warp",
    "wh_main_sc_nor_fimir",
    "wh_main_sc_nor_troll",
    "wh_main_sc_lzd_amazon",
    "wh_main_sc_emp_araby",
    "wh_main_sc_nor_albion"
} 
local ship_subtypes = {
    "arb_golden_magus"
}
cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context) 
  if not not rm then
    for i = 1, #default_cultures do
      rm:add_subculture_path_filter(ovn_subcultures [i], "NormalFaction")
    end
    for i = 1, #ship_subtypes do
      rm:add_subtype_path_filter(ship_subtypes[i], "CharBoundHordeWithGlobal")
    end
  end
end

local prefix_to_subculture = {
    wrp = "wh_main_sc_nor_warp",
    fim = "wh_main_sc_nor_fimir",
    trl = "wh_main_sc_nor_troll",
    amz = "wh_main_sc_lzd_amazon",
    arb = "wh_main_sc_emp_araby",
    alb = "wh_main_sc_nor_albion"
}

for prefix, subculture in pairs(prefix_to_subculture) do
    rm:set_group_prefix_for_subculture(subculture, prefix)
end