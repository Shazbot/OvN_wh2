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

local function binding_iter(binding)
	local pos = 0
	local num_items = binding:num_items()
	return function()
			if pos < num_items then
					local item = binding:item_at(pos)
					pos = pos + 1
					return item
			end
			return
	end
end

local blood_dragons_faction_name = "wh2_main_vmp_blood_dragons"

local mission_key_to_force_cqi = {}
local mission_key_has_lord_reward_lookup = {}

local num_targets = 5
local blood_kiss_resource_payload = "faction_pooled_resource_transaction{resource vmp_blood_kiss;factor wh2_dlc11_vmp_resource_factor_other;amount 1;}";

local blood_dragon_names = {
	["forename"] = {
		"1406951171",
		"1768171990",
		"1880091843",
		"1966785637",
		"2147345100",
		"2147345109",
		"2147345117",
		"2147345149",
		"2147345161",
		"2147345165",
		"2147345166",
		"2147345180",
		"2147345200",
		"2147345209",
		"2147345217",
		"2147345230",
		"2147345239",
		"2147345257",
		"2147345260",
		"2147345266",
		"2147345279",
		"2147345281",
		"2147345303",
		"2147345862",
		"2147345872",
		"2147357264",
		"2147357272",
		"2147357278",
		"2147357284",
		"2147357289",
		"2147357295",
		"2147357301",
		"2147357304",
		"2147357306",
		"2147357315",
		"2147357322",
		"2147357330",
		"2147357531",
		"2147357577",
		"2147357583",
		"2147357593",
		"2147357595",
		"2147357596",
		"2147357905",
		"2147357909",
		"2147357911",
		"2147357919",
		"2147357925",
		"2147357928",
		"2147357935",
		"2147357949",
		"2147357952",
		"2147357970",
		"2147357974",
		"2147357977",
		"2147357980",
		"2147357990",
		"2147357991",
		"2147357994",
		"2147358006",
		"2147358011",
		"2147358022",
		"2147358030",
		"2147358038",
		"2147358047",
		"2147358057",
		"2147358063",
		"2147358070",
		"2147358072",
		"2147358074",
		"2147358076",
		"2147358083",
		"2147358089",
		"2147358096",
		"2147358103",
		"2147358110",
		"2147358113",
		"2147358121",
		"2147358122",
		"2147358126",
		"2147358136",
		"2147358140",
		"2147358143",
		"2147358144",
		"2147358148",
		"2147358157",
		"2147358165",
		"2147358170",
		"2147358174",
		"2147358184",
		"2147358193",
		"2147358194",
		"2147358199",
		"2147358201",
		"2147358210",
		"2147358220",
		"2147358224",
		"2147358230",
		"2147358234",
		"2147358241",
		"2147358243",
		"2147358244",
		"2147358248",
		"2147358254",
		"2147358259",
		"2147358260",
		"2147358265",
		"2147358275",
		"2147358279",
		"2147358289",
		"2147358298",
		"2147358299",
		"2147358304",
		"2147358305",
		"2147358308",
		"2147358310",
		"2147358319",
		"2147358324",
		"677402052",
		"79061478"
	},
	["surname"] = {
		"1003038241",
		"1041741800",
		"1064541212",
		"1090640497",
		"1139217754",
		"1199231259",
		"1227554475",
		"1238864252",
		"1305581408",
		"1323396643",
		"168545332",
		"1702107794",
		"1777692413",
		"2012155459",
		"2051685651",
		"2147345093",
		"2147345151",
		"2147345172",
		"2147345188",
		"2147345224",
		"2147345237",
		"2147345247",
		"2147345271",
		"2147345290",
		"2147345294",
		"2147352928",
		"2147357525",
		"26926004",
		"378511030",
		"463976820",
		"522579314",
		"680207862",
		"693999515",
		"722999650",
		"817148109",
		"86899705",
		"943406012"
	}
};

local function generate_targets(faction_key, rogues_disallowed)
	local hunting_faction = cm:get_faction(faction_key)
	if not hunting_faction then
		return
	end

	local random_factions = assassination_pick_random_factions(nil, "all", nil);

	local forces = {}
	for i = 1, #random_factions do
		local faction = random_factions[i];
		local force_list = faction:military_force_list();
		local real_forces = {};

		for j = 0, force_list:num_items() - 1 do
			local force = force_list:item_at(j);

			if faction ~= hunting_faction
			and not force:is_armed_citizenry()
			and force:has_general()
			and not faction:is_ally_vassal_or_client_state_of(hunting_faction)
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
				distance = assassination_distance_to_assassin(hunting_faction, pos_x, pos_y),
				cqi = force:command_queue_index(),
				leader = force:general_character():is_faction_leader(),
				rank = force:general_character():rank(),
				at_war = faction:at_war_with(hunting_faction),
				pos = {pos_x, pos_y},
				ally_count = faction:num_allies(),
				force_count = faction:military_force_list():num_items(),
			})
		end
	end

	return forces
end

local function get_n_by_distance(hunting_faction_key, forces, n, dist)
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
	local forces_by = table_clone(forces_by_str)

	for i=#forces_by, 1, -1 do
		local force = forces_by[i]
		if not (force.subculture == "wh_dlc05_sc_wef_wood_elves" and included_subcultures[force.subculture])
			and (cm:random_number(3)==1 or not included_subcultures[force.subculture])
			and force.distance < dist
			and force.faction ~= hunting_faction_key
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

local gave_turn_one_army_as_target = false

local function create_turn_one_army_target()
	local char = cm:get_faction("wh_main_emp_empire_qb1"):faction_leader()
	local force = char:military_force()
	local faction = cm:get_faction("wh_main_emp_empire_qb1")
	local pos_x = force:general_character():logical_position_x();
	local pos_y = force:general_character():logical_position_y();
	local hunting_faction = cm:get_faction(blood_dragons_faction_name)

	local force = {
		subtype = force:general_character():character_subtype_key(),
		faction_name = faction:name(),
		subculture = faction:subculture(),
		force_value = assassination_get_army_cost(force),
		distance = 5,
		cqi = force:command_queue_index(),
		leader = force:general_character():is_faction_leader(),
		rank = force:general_character():rank(),
		at_war = faction:at_war_with(hunting_faction),
		pos = {pos_x, pos_y},
		ally_count = faction:num_allies(),
		force_count = faction:military_force_list():num_items(),
	}

	return force
end

local function give_new_targets(turn_num, rogues_disallowed)
	local faction_name = blood_dragons_faction_name

	local forces = generate_targets(faction_name, rogues_disallowed)
	if not forces then return end

	local forces_by_str = table_clone(forces)
	table.sort(forces_by_str, function(f, s)
		return f.force_value < s.force_value
	 end)

	local max = 10
	local distance = 5000+(turn_num-1)*500
	local chosen = get_n_by_distance(faction_name, forces, max, distance)

	while #chosen ~= max do
		distance = distance + 1000
		chosen = get_n_by_distance(faction_name, forces, max, distance)
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
			out("SCRIPT ERROR pj_blood_dragon_targets")
			return
		end
	end

	for i=1,num_targets do
		local mission_key = "pj_blood_dragon_targets_"..i
		if not mission_key_to_force_cqi[mission_key] and #picked > 0 then
			local pick = table.remove(picked)

			if cm:is_new_game() and not gave_turn_one_army_as_target then
				gave_turn_one_army_as_target = true
				pick = create_turn_one_army_target()
			end

			local grudge_mission = mission_manager:new(
				faction_name,
				mission_key
			);

			grudge_mission:add_new_objective("ENGAGE_FORCE");
			grudge_mission:add_condition("cqi "..pick.cqi);
			grudge_mission:add_condition("requires_victory");
			grudge_mission:add_payload("money "..pick.force_value);
			grudge_mission:add_payload(blood_kiss_resource_payload);
			if cm:random_number(4) == 1 then
				grudge_mission:add_payload("effect_bundle{bundle_key ovn_blood_dragons_gain_blood_dragon;turns 0;}");
				mission_key_has_lord_reward_lookup[mission_key] = true
			end
			grudge_mission:set_should_cancel_before_issuing(true);
			grudge_mission:set_turn_limit(cm:random_number(25, 16));
			grudge_mission:trigger();

			mission_key_to_force_cqi[mission_key] = pick.cqi
		end
	end
end

local function add_new_blood_dragon_lord(faction_key)
	local forenames = blood_dragon_names["forename"]
	local forename = "names_name_"..forenames[cm:random_number(#forenames)]
	local surnames = blood_dragon_names["surname"]
	local surname = "names_name_"..surnames[cm:random_number(#surnames)]
	cm:spawn_character_to_pool(faction_key, forename, surname, "", "", 21, true, "general", "wh2_dlc11_vmp_bloodline_blood_dragon", false, "")
end

cm:add_first_tick_callback_new(
	function()
		cm:callback(
			function()
				local blood_dragons = cm:get_faction("wh2_main_vmp_blood_dragons")
				if not blood_dragons or not blood_dragons:is_human() then
					return
				end

				local turn_num = cm:model():turn_number()
				give_new_targets(turn_num, true)

				add_new_blood_dragon_lord("wh2_main_vmp_blood_dragons")
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

core:remove_listener("pj_blood_dragon_targets_on_MissionFailed")
core:add_listener(
	"pj_blood_dragon_targets_on_MissionFailed",
	"MissionFailed",
	function(context)
		return context:faction():name() == "wh2_main_vmp_blood_dragons"
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

core:remove_listener("pj_blood_dragon_targets_on_MissionCancelled")
core:add_listener(
	"pj_blood_dragon_targets_on_MissionCancelled",
	"MissionCancelled",
	function(context)
		return context:faction():name() == "wh2_main_vmp_blood_dragons"
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		if mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end
	end,
	true
);

core:remove_listener("pj_blood_dragon_targets_on_MissionSucceeded")
core:add_listener(
	"pj_blood_dragon_targets_on_MissionSucceeded",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == "wh2_main_vmp_blood_dragons"
	end,
	function(context)
		local mission_key = context:mission():mission_record_key()
		local faction_key = context:faction():name()

		if mission_key_has_lord_reward_lookup[mission_key] then
			add_new_blood_dragon_lord(faction_key)
			mission_key_has_lord_reward_lookup[mission_key] = false
		end

		if mission_key_to_force_cqi[mission_key] then
			overwrite_mission(mission_key)
		end

		cm:callback(
			function()
				local faction = cm:get_faction(faction_key)
				if not faction then return end
				if faction:has_effect_bundle("ovn_blood_dragons_gain_blood_dragon") then
					cm:remove_effect_bundle("ovn_blood_dragons_gain_blood_dragon", faction:name())
				end
			end,
			1
		)
	end,
	true
);

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("pj_blood_dragon_targets_mission_key_to_force_cqi", mission_key_to_force_cqi, context)
		cm:save_named_value("pj_blood_dragon_targets_mission_key_has_lord_reward_lookup", mission_key_has_lord_reward_lookup, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mission_key_to_force_cqi = cm:load_named_value("pj_blood_dragon_targets_mission_key_to_force_cqi", mission_key_to_force_cqi, context)
		mission_key_has_lord_reward_lookup = cm:load_named_value("pj_blood_dragon_targets_mission_key_has_lord_reward_lookup", mission_key_has_lord_reward_lookup, context)
	end
)

-- mission_key_to_force_cqi = {}
-- give_new_targets(1, true)
