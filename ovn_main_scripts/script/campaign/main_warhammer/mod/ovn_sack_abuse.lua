--- Check if the region that is about to be attacked has the sacked bundle.
--- Then cache that value for later use.
core:remove_listener("ovn_sack_abuse_on_garrison_attacked")
core:add_listener(
	"ovn_sack_abuse_on_garrison_attacked",
	"GarrisonAttackedEvent",
	true,
	function(context)
		---@type CA_CHAR
		local attacker_char = context:character()
		if not attacker_char:faction():is_human() then return end

		---@type CA_GARRISON_RESIDENCE
		local gr = context:garrison_residence()

		cm:set_saved_value("ovn_sack_abuse_hide_next", gr:region():has_effect_bundle("ovn_sack_abuse"))
	end,
	true
)

local sack_occupation_ids = {
	["2205198906"] = true,
	["2205198913"] = true,
	["2205198920"] = true,
	["2205198946"] = true,
}

--- Hide the sacking option if the region has the sacked bundle.
core:remove_listener("ovn_sack_abuse_on_panel_opened")
core:add_listener(
	"ovn_sack_abuse_on_panel_opened",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "settlement_captured"
	end,
	function()
		for sack_decision_id, _ in pairs(sack_occupation_ids) do
			local decision = find_uicomponent(core:get_ui_root(), "settlement_captured", "button_parent", sack_decision_id)
			if decision then
				decision:SetVisible(not cm:get_saved_value("ovn_sack_abuse_hide_next"))
			end
		end
	end,
	true
)

local stack_abuse_factions_to_check = {
	wh2_main_ovn_chaos_dwarfs = true,
	wh2_main_nor_rotbloods = true,
	wh2_main_nor_trollz = true,
	wh2_main_nor_servants_of_fimulneid = true,
	wh2_main_nor_harbingers_of_doom = true,
	wh2_main_arb_flaming_scimitar = true,
	wh2_main_arb_aswad_scythans = true,
	wh2_main_arb_caliphate_of_araby = true,
}

--- Apply the sacked bundle to the region after the player sacks it.
core:remove_listener("ovn_sack_abuse_on_occupation_decision")
core:add_listener(
	"ovn_sack_abuse_on_occupation_decision",
	"CharacterPerformsSettlementOccupationDecision",
	function(context)
		local faction = context:character():faction()
		return stack_abuse_factions_to_check[faction:name()]
			and sack_occupation_ids[context:occupation_decision()]
	end,
	function(context)
		---@type CA_GARRISON_RESIDENCE
		local gr = context:garrison_residence()
		local region = gr:region()

		cm:apply_effect_bundle_to_region("ovn_sack_abuse", region:name(), 3)
	end,
	true
)
