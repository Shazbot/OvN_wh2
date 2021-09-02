local function blood_dragons_init()

local blood_dragons = cm:get_faction("wh2_main_vmp_blood_dragons")

if blood_dragons:is_human() and cm:model():turn_number() < 3 then
			core:add_listener(
				"blood_dragon_missions",
				"FactionTurnStart",
				function(context)
					return context:faction():is_human() and cm:model():turn_number() == 2
				end,
				function(context)
					cm:trigger_mission("wh2_main_vmp_blood_dragons", "ovn_blood_dragons_me_take_nuln", true)
					cm:trigger_mission("wh2_main_vmp_blood_dragons", "ovn_blood_dragons_me_take_templehof", true)
					cm:trigger_mission("wh2_main_vmp_blood_dragons", "ovn_blood_dragons_me_take_altdorf", true)
				end,
				false
			)
		end

end

cm:add_first_tick_callback(
    function()
        blood_dragons_init()
    end
)
