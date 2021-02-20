-- number is the startpos ID from start_pos_character tables, name can be whatever you want as long it's the same in both here and in local starting units
local your_cool_lords_me = {
	["440104156"] = "citadel_of_dusk",
	["2052227504"] = "amazons",
	["1041928997"] = "dread_king",
	["40619453"] = "halflings",
	["642513778"] = "grudgebingers",
	["250682859"] = "jaffar",
	["1721501317"] = "hassan_hame",
	["1624764695"] = "golden_magus",
	["882030"] = "chorfs",
	-- ["2140783503"] = "blood_dragons",
	["549163715"] = "blood_dragons",
	-- ["937413525"] = "albion",
	["32930744"] = "ugma",
	-- ["1409023687"] = "fimir_servants",
	["1267543494"] = "fimir_servants",
	-- ["209967969"] = "fimir_killing_eye",
	["924962720"] = "fimir_killing_eye",
	-- ["1397230572"] = "rotblood",
	["1668499673"] = "rotblood",
}

local your_cool_lords_vortex = {
	["2140784771"] = "citadel_of_dusk",
	["1407394331"] = "amazons",
	["848881665"] = "dread_king",
	["572093174"] = "grudgebingers",
	["2119533354"] = "jaffar",
	["365146035"] = "hassan_hame",
	["1242187756"] = "golden_magus",
	-- ["794782611"] = "albion",
}

-- unit name should be the land units key (not main units!), it's used to get the unit's name and nothing else
-- unit card name should be the unit card name, duh, can be checked from unit_variants tables
local starting_units = {
	["citadel_of_dusk"] = {
		starting_unit_1 = "wh2_dlc10_hef_inf_the_storm_riders_ror_0", unit_card_1 = "wh2_dlc10_hef_lothern_sea_guard_ror",
		starting_unit_2 = "wh2_main_hef_inf_swordmasters_of_hoeth_0", unit_card_2 = "wh2_main_hef_swordmasters_of_hoeth",
		starting_unit_3 = "wh2_main_hef_art_eagle_claw_bolt_thrower", unit_card_3 = "wh2_main_hef_art_eagle_claw_bolt_thrower"
	},
	["amazons"] = {
		starting_unit_1 = "roy_amz_cav_culchan_riders_ranged", unit_card_1 = "roy_amz_cav_culchan_riders_ranged",
		starting_unit_2 = "roy_amz_inf_eagle_warriors", unit_card_2 = "roy_amz_inf_eagle_warriors",
		starting_unit_3 = "roy_amz_mon_wildcats", unit_card_3 = "roy_amz_mon_wildcats"
	},
	["dread_king"] = {
		starting_unit_1 = "elo_tomb_guardian_2h_waepons", unit_card_1 = "elo_tomb_guardian_2h_waepons",
		starting_unit_2 = "wh2_dlc09_tmb_cav_hexwraiths", unit_card_2 = "wh2_dlc09_tmb_cav_hexwraiths",
		starting_unit_3 = "wh2_dlc09_tmb_inf_tomb_guard_1", unit_card_3 = "wh2_dlc09_tmb_tomb_guard_halberd"
	},
	["halflings"] = {
		starting_unit_1 = "ovn_mtl_cav_poultry_riders_0", unit_card_1 = "ovn_mtl_poultry",
		starting_unit_2 = "sr_ogre", unit_card_2 = "sr_ogre",
		starting_unit_3 = "halfling_cook", unit_card_3 = "halfling_cook"
	},
	["grudgebingers"] = {
		starting_unit_1 = "grudgebringer_infantry", unit_card_1 = "emp_grudge_comp",
		starting_unit_2 = "grudgebringer_cannon", unit_card_2 = "emp_grudge_can",
		starting_unit_3 = "grudgebringer_crossbow", unit_card_3 = "willem_fletcher"
	},
	["jaffar"] = {
		starting_unit_1 = "ovn_jez", unit_card_1 = "ovn_arb_jezzail",
		starting_unit_2 = "wh_main_arb_cav_magic_carpet_0", unit_card_2 = "wh_main_arb_magic_carpet",
		starting_unit_3 = "ovn_arb_art_grand_bombard", unit_card_3 = "ovn_arb_grand_bombard"
	},
	["hassan_hame"] = {
		starting_unit_1 = "ovn_arb_cav_archer_camel", unit_card_1 = "ovn_arb_camel_arc",
		starting_unit_2 = "wh_main_arb_mon_war_elephant", unit_card_2 = "ovn_arb_war_elephant",
		starting_unit_3 = "ovn_scor", unit_card_3 = "ovn_scor"
	},
	["golden_magus"] = {
		starting_unit_1 = "ovn_prometheans", unit_card_1 = "wh2_dlc11_cst_rotting_prometheans",
		starting_unit_2 = "ovn_ifreet", unit_card_2 = "ovn_arb_khimar",
		starting_unit_3 = "wh_main_arb_cav_magic_carpet_0", unit_card_3 = "wh_main_arb_magic_carpet"
	},
	["chorfs"] = {
		starting_unit_1 = "chaos_dwarf_warriors_rifles", unit_card_1 = "chaos_dwarf_warriors_rifles",
		starting_unit_2 = "chaos_dwarf_warriors", unit_card_2 = "chaos_dwarf_warriors",
		starting_unit_3 = "hobgoblin_wolf_bow_raider", unit_card_3 = "hobgoblin_wolf_bow_raider"
	},
	["blood_dragons"] = {
		starting_unit_1 = "wh_dlc02_vmp_cav_blood_knights_0", unit_card_1 = "wh_dlc02_vmp_blood_knights",
		starting_unit_2 = "dismounted_blood_knights_shield", unit_card_2 = "dismounted_blood_knights_shield",
		starting_unit_3 = "wh_main_vmp_inf_skeleton_warriors_1", unit_card_3 = "wh_main_vmp_skeleton_warrior_spear"
	},
	["albion"] = {
		starting_unit_1 = "albion_giant", unit_card_1 = "albion_giant",
		starting_unit_2 = "albion_hearthguard", unit_card_2 = "albion_hearthguard",
		starting_unit_3 = "elo_youngbloods", unit_card_3 = "elo_youngbloods"
	},
	["ugma"] = {
		starting_unit_1 = "elo_mountain_trolls", unit_card_1 = "elo_mountain_trolls",
		starting_unit_2 = "elo_river_trolls", unit_card_2 = "elo_river_trolls",
		starting_unit_3 = "elo_bile_trolls", unit_card_3 = "elo_bile_trolls"
	},
	["fimir_servants"] = {
		starting_unit_1 = "wh2_dlc15_grn_mon_river_trolls_0", unit_card_1 = "wh2_dlc15_grn_mon_river_trolls",
		starting_unit_2 = "elo_fenbeast", unit_card_2 = "elo_fenbeast",
		starting_unit_3 = "wh_dlc08_nor_mon_fimir_1", unit_card_3 = "wh_dlc08_nor_fimir_warriors_great_weapons"
	},
	["fimir_killing_eye"] = {
		starting_unit_1 = "ovn_fimm", unit_card_1 = "ovn_fimm",
		starting_unit_2 = "elo_fenbeast", unit_card_2 = "elo_fenbeast",
		starting_unit_3 = "kho_bloodletter", unit_card_3 = "kho_bloodletter"
	},
	["rotblood"] = {
		starting_unit_1 = "wh_main_chs_mon_chaos_spawn", unit_card_1 = "wh_main_chs_spawn",
		starting_unit_2 = "wh_dlc01_chs_inf_forsaken_0", unit_card_2 = "wh_dlc01_chs_forsaken",
		starting_unit_3 = "wh_main_chs_inf_chaos_warriors_0", unit_card_3 = "wh_main_chs_warriors"
	},
}

local function startpos_id_check(startpos_id)
	if your_cool_lords_me[startpos_id] then
		return your_cool_lords_me[startpos_id]
	end
	if your_cool_lords_vortex[startpos_id] then
		return your_cool_lords_vortex[startpos_id]
	end
end

-----------------------------------------------
---	Create the frontend unit card
-----------------------------------------------
local function create_unit_card_for_frontend(unit_key, unit_card, id)
	local parent = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "lord_details_panel", "units", "start_units", "card_holder")
    if not is_uicomponent(parent) then script_error("[parent] expected to be a UIComponent, wrong type!") return end

    -- create the UI Component
    local uic = core:get_or_create_component("ovn_unit_card_"..id, "ui/templates/custom_image", parent)

    -- check that it worked
    if not uic then
        script_error("UIC was not able to be made or found!")
        return
    end

	local unit_name = effect.get_localised_string("land_units_onscreen_name_"..unit_key)

	uic:SetVisible(true)
    uic:SetImagePath("ui/units/icons/"..unit_card..".png", 4)
    uic:Resize(50, 110)
    uic:SetOpacity(255)
	uic:SetTooltipText(unit_name, true)

	parent:Adopt(uic:Address())
end

local function add_unit_card_listener()

core:add_listener(
	"pj_ovn_frontend_CampaignTransitionListener",
	"FrontendScreenTransition",
	function(context) return context.string == "sp_grand_campaign" end,
	function(context)
		local uic_grand_campaign = find_uicomponent("sp_grand_campaign")

		if not uic_grand_campaign then
			script_error("ERROR: add_unit_card_listener() couldn't find uic_grand_campaign, how can this be?");
			return false;
		end;

		local faction_list = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "top_docker", "lord_select_list", "list", "list_clip", "list_box")
		if not faction_list then
			return
		end

		for i = 0, faction_list:ChildCount() - 1 do
			local child = UIComponent(faction_list:Find(i))
			core:add_listener(
				"pj_ovn_frontend_on_lord_click",
				"ComponentLClickUp",
				function(context)
					return child == UIComponent(context.component);
				end,
				function(context)
					local startpos_id = child:GetProperty("lord_key")

					local is_this_your_frontend_dude = startpos_id_check(startpos_id)
					if is_this_your_frontend_dude then
						core:add_listener("pj_ovn_frontend_on_lord_clicked_cb", "RealTimeTrigger", function(context) return context.string == "pj_ovn_frontend_clicked_ovn_lord_cb" end,
						function(context)
							local units = starting_units[is_this_your_frontend_dude]
							if units ~= nil then
								create_unit_card_for_frontend(units.starting_unit_1, units.unit_card_1, 1)
								create_unit_card_for_frontend(units.starting_unit_2, units.unit_card_2, 2)
								create_unit_card_for_frontend(units.starting_unit_3, units.unit_card_3, 3)
							end
						end,
						false)

						real_timer.register_singleshot("pj_ovn_frontend_clicked_ovn_lord_cb", 0)
					end
				end,
				true
			)
		end
	end,
	true
)
end


core:add_ui_created_callback(
	function(context)
		add_unit_card_listener()
	end
)
