local function add_units_to_army(chaos_army_key)
	local ram = random_army_manager

    ram:add_unit(chaos_army_key, "rbt_nurgle_daemon", 2)
    ram:add_unit(chaos_army_key, "kho_bloodletter", 2)
    ram:add_unit(chaos_army_key, "Great_Deamon1_unit", 1)
    ram:add_unit(chaos_army_key, "ovn_nurgle_chs_cav_chaos_knights_1", 1)
    ram:add_unit(chaos_army_key, "ovn_nurgle_chs_cav_chaos_knights_0", 1)
end

local chaos_army_keys = {
	chaos_1 = true,
	chaos_2 = true,
	chaos_3 = true,
	chaos_4 = true,
	chaos_5 = true,
	CI_chaos = true,
}

local function add_units_to_chaos_invasion_armies()
	for i = 1, #random_army_manager.force_list do
		local chaos_army_key = random_army_manager.force_list[i].key
		if chaos_army_keys[chaos_army_key] then
			add_units_to_army(chaos_army_key)
		end
	end

	out("add_units_to_chaos_invasion_armies FINISHED IN ovn_chaos_invasion_additions.lua")
end

cm:add_first_tick_callback(function()
	cm:callback(function()
		add_units_to_chaos_invasion_armies()
	end, 6)
end)
