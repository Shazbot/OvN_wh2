local blightstormer_type_key = "ovn_rbt_ch_blightstormer"
local fanatics_type_key = "elo_rot_fanatics"
local change_one_in_x = 10

local function init()
	local alliances = bm:alliances()
	for i=1, alliances:count() do
		local alliance_armies = alliances:item(i):armies()
		for j=1, alliance_armies:count() do
			local army = alliance_armies:item(j)

			local army_units = army:units()
			local army_has_blightstormer = false
			for k = 1, army_units:count() do
				local current_unit = army_units:item(k);
				if current_unit and current_unit:type() == blightstormer_type_key then
					army_has_blightstormer = true
					break
				end
			end

			if army_has_blightstormer then
				for k = 1, army_units:count() do
					local current_unit = army_units:item(k);
					if current_unit and current_unit:type() == fanatics_type_key then
						if bm:random_number(change_one_in_x) == 1 then
							current_unit:set_stat_attributes("unbreakable", true)
						end
					end
				end
			end
		end
	end
end

bm:callback(function()
	init()
end, 1000)
