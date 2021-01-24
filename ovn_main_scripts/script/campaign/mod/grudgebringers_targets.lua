local table_clone = nil
table_clone = function(t)
	local clone = {}

	for key, value in pairs(t) do
		if type(value) ~= "table" then
			clone[key] = value
		else
			clone[key] = table_clone(value)
		end
	end

	return clone
end

local mission_key_to_force_cqi = {
}

local num_targets = 5

local disallowed_subcultures = {
	wh_main_sc_ksl_kislev = true,
	wh_main_sc_teb_teb = true,
	wh_main_sc_emp_empire = true,
	wh_main_sc_dwf_dwarfs = true,
	wh_main_sc_brt_bretonnia = true,
	wh_dlc05_sc_wef_wood_elves = true,
	wh2_main_sc_hef_high_elves = true,
}

local function generate_targets(rogues_disallowed)
	local local_faction = cm:get_faction("wh2_main_emp_grudgebringers")
	local random_factions = assassination_pick_random_factions(nil, "all", nil);

	local forces = {}
	for i = 1, #random_factions do
		local faction = random_factions[i];
		local force_list = faction:military_force_list();
		local real_forces = {};

		for j = 0, force_list:num_items() - 1 do
			local force = force_list:item_at(j);

			if faction ~= local_faction
			and not force:is_armed_citizenry()
			and force:has_general()
			and not faction:is_ally_vassal_or_client_state_of(local_faction)
			and not (string.find(faction:name(), "_rogue_") and rogues_disallowed) then
					table.insert(real_forces, force);
			end
		end

		for _, force in ipairs(real_forces) do
			local pos_x = force:general_character():logical_position_x();
			local pos_y = force:general_character():logical_position_y();
			table.insert(forces, {
				subtype = force:general_character():character_subtype_key(),
				faction_name = faction:name(),
				subculture = faction:subculture(),
				force_value = assassination_get_army_cost(force),
				distance = assassination_distance_to_assassin(local_faction, pos_x, pos_y),
				cqi = force:command_queue_index(),
				leader = force:general_character():is_faction_leader(),
				rank = force:general_character():rank(),
				at_war = faction:at_war_with(local_faction),
				pos = {pos_x, pos_y},
				ally_count = faction:num_allies(),
				force_count = faction:military_force_list():num_items(),
			})
		end
	end

	return forces
end

local function get_n_by_distance(forces, n, dist)
	local forces_by_str = table_clone(forces)
		table.sort(forces_by_str, function(f, s)
			return f.force_value < s.force_value
		end)
	local forces_by_dist = table_clone(forces)
	table.sort(forces_by_dist, function(f, s)
		return f.distance > s.distance
	end)

	local chosen = {}
	local included_subcultures = {}
	local forces_by= table_clone(forces_by_str)

	for i=#forces_by, 1, -1 do
		local force = forces_by[i]
		if not disallowed_subcultures[force.subculture]
			and (cm:random_number(3)==1 or not included_subcultures[force.subculture])
			and force.distance < dist
			and force.faction ~= "wh2_main_emp_grudgebringers"
		then
			table.insert(chosen, force)
			included_subcultures[force.subculture] = true
			if #chosen == n then
				break
			end
		end
	end

	return chosen
end

local function give_new_targets(turn_num, rogues_disallowed)
	local faction_name = "wh2_main_emp_grudgebringers"

	local forces = generate_targets(rogues_disallowed)

	local forces_by_str = table_clone(forces)
	table.sort(forces_by_str, function(f, s)
		return f.force_value < s.force_value
	 end)

	local max = 10
	local distance = 5000+(turn_num-1)*500
	local chosen = get_n_by_distance(forces, max, distance)

	while #chosen ~= max do
		distance = distance + 1000
		chosen = get_n_by_distance(forces, max, distance)
		if #chosen == max or distance > 1000000 then
			break
		end
	end

	local num_to_pick = 5
	for _, _ in pairs(mission_key_to_force_cqi) do
		num_to_pick = num_to_pick - 1
	end

	local picked = {}
	local while_index = 0
	while #picked ~= num_to_pick do
		local removed = table.remove(chosen, cm:random_number(#chosen))
		local already_taken = false
		for _, cqi in pairs(mission_key_to_force_cqi) do
			if cqi == removed.cqi then
				already_taken = true
			end
		end
		if not already_taken then
			table.insert(picked, removed)
		end

		while_index = while_index + 1
		if while_index > 1000 then
			out("SCRIPT ERROR pj_grudgebringers_targets")
			return
		end
	end

	for i=1,num_targets do
		local mission_key = "pj_grudgebringers_targets_"..i
		if not mission_key_to_force_cqi[mission_key] and #picked > 0 then
			local pick = table.remove(picked)

			local grudge_mission = mission_manager:new(
				faction_name,
				mission_key
			);

			grudge_mission:add_new_objective("ENGAGE_FORCE");
			grudge_mission:add_condition("cqi "..pick.cqi);
			grudge_mission:add_condition("requires_victory");
			grudge_mission:add_payload("money "..pick.force_value);
			grudge_mission:set_should_cancel_before_issuing(true);
			grudge_mission:set_turn_limit(cm:random_number(25, 16));
			grudge_mission:trigger();

			mission_key_to_force_cqi[mission_key] = pick.cqi
		end
	end
end

cm:add_first_tick_callback_new(
	function()
		cm:callback(
			function()
				local grudgebringers = cm:get_faction("wh2_main_emp_grudgebringers")
				if not grudgebringers or not grudgebringers:is_human() then return end

				local turn_num = cm:model():turn_number()
				give_new_targets(turn_num, true)
			end,
			4
		)
	end
)

local function overwrite_mission(mission_key)
	if mission_key_to_force_cqi[mission_key] then
		mission_key_to_force_cqi[mission_key] = nil
		local turn_num = cm:model():turn_number()
		local rogues_disallowed = turn_num < 20
		give_new_targets(turn_num, rogues_disallowed)
	end
end

core:remove_listener("pj_grudgebringers_targets_on_MissionFailed")
core:add_listener(
	"pj_grudgebringers_targets_on_MissionFailed",
	"MissionFailed",
	function(context)
		return context:faction():name() == "wh2_main_emp_grudgebringers"
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

core:remove_listener("pj_grudgebringers_targets_on_MissionCancelled")
core:add_listener(
	"pj_grudgebringers_targets_on_MissionCancelled",
	"MissionCancelled",
	function(context)
		return context:faction():name() == "wh2_main_emp_grudgebringers"
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

core:remove_listener("pj_grudgebringers_targets_on_MissionSucceeded")
core:add_listener(
	"pj_grudgebringers_targets_on_MissionSucceeded",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == "wh2_main_emp_grudgebringers"
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("pj_grudgebringers_targets_mission_key_to_force_cqi", mission_key_to_force_cqi, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mission_key_to_force_cqi = cm:load_named_value("pj_grudgebringers_targets_mission_key_to_force_cqi", mission_key_to_force_cqi, context)
	end
)

-- mission_key_to_force_cqi = {}
-- give_new_targets(1, true)
