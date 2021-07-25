OVN_RUINS_REVEAL = OVN_RUINS_REVEAL or {}
local mod = OVN_RUINS_REVEAL

local function add_on_first_tick()
	core:remove_listener("ovn_cache_char_cqi_for_ruins_reveal")
	core:add_listener(
		"ovn_cache_char_cqi_for_ruins_reveal",
		"CharacterSelected",
		true,
		function(context)
			---@type CA_CHAR
			local char = context:character()

			if char:faction() ~= cm:get_local_faction(true) then return end

			mod.char_cqi_for_ruins_reveal = char:command_queue_index()
		end,
		true
	)

	core:remove_listener("ovn_ruins_reveal_overwrite_popup_cb")
	core:add_listener(
			"ovn_ruins_reveal_overwrite_popup_cb",
			"RealTimeTrigger",
			function(context)
					return context.string == "ovn_ruins_reveal_overwrite_popup"
			end,
			function()
				if not mod.char_cqi_for_ruins_reveal then return end

				local ui_root = core:get_ui_root()
				local reveal = find_uicomponent(ui_root, "skaven_revealed_anim")
				if not reveal then return end

				local char = cm:get_character_by_cqi(mod.char_cqi_for_ruins_reveal)
				if not char or char:is_null_interface() then return end

				if not char:has_region() then return end
				local region = char:region()
				if not region or region:is_null_interface() or region:is_abandoned() then return end

				local region_owner = region:owning_faction()
				if not region_owner or region_owner:is_null_interface() then return end

				-- only change it if not skaven
				if region_owner:subculture() == "wh2_main_sc_skv_skaven" then return end

				local shield = find_uicomponent(reveal, "shield")
				local glow = find_uicomponent(reveal, "glow")

				shield:SetImagePath("ui/skins/default/chaos_revealed_shield.png", 0)
				glow:SetImagePath("ui/skins/default/chaos_revealed_glow.png", 0)
			end,
			true
	)

	real_timer.unregister("ovn_ruins_reveal_overwrite_popup")
	real_timer.register_repeating("ovn_ruins_reveal_overwrite_popup", 0)
end

cm:add_first_tick_callback(add_on_first_tick)
