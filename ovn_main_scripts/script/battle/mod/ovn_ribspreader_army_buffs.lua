local ribspreader_type_key = "ribspreader"
local ribspreader_mammoth_type_key = "ribspreader_mammoth"
local change_one_in_x = 4

local function init()
	if not core:svr_load_bool("ovn_ribspreader_unlocked_nurgle_army_blessings") then
		return
	end

	local alliances = bm:alliances()
	for i=1, alliances:count() do
		local alliance_armies = alliances:item(i):armies()
		for j=1, alliance_armies:count() do
			local army = alliance_armies:item(j)

			local army_units = army:units();
			if army_units:item(1):type() == ribspreader_type_key or army_units:item(1):type() == ribspreader_mammoth_type_key then
				for k = 2, army_units:count() do
					local current_unit = army_units:item(k);
					if current_unit then
						if bm:random_number(change_one_in_x) == 1 then
							current_unit:set_stat_attributes("causes_fear", true)
							current_unit:set_stat_attributes("immune_to_psychology", true)
							current_unit:set_stat_attributes("encourages", true)
							current_unit:set_stat_attributes("fatigue_immune", true)
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
