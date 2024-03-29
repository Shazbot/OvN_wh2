local grudgebringers = {
	main_warhammer = {
		faction_key = "wh2_main_emp_grudgebringers",
		unit_list = "grudgebringer_infantry,grudgebringer_cannon,grudgebringer_crossbow,eusebio_flagellants,wh2_dlc13_emp_inf_greatswords_ror_0",
		region_key = "wh2_main_great_desert_of_araby_el-kalabad",
		x = 675,
		y = 200,
		type = "general",
		subtype = "morgan_bernhardt",
		name1 = "names_name_3110890001",
		name2 = "",
		name3 = "names_name_3110890002",
		name4 = "",
		make_faction_leader = true,
		callback =
				function(cqi)
						cm:set_character_immortality("character_cqi:" .. cqi, true)
						cm:set_character_unique("character_cqi:"..cqi, true)
				end
	},
	wh2_main_great_vortex = {
		faction_key = "wh2_main_emp_grudgebringers",
		unit_list = "grudgebringer_infantry,grudgebringer_cannon,grudgebringer_crossbow,eusebio_flagellants,wh2_dlc13_emp_inf_greatswords_ror_0",
		region_key = "wh2_main_vor_ash_river_quatar",
		x = 715,
		y = 305,
		type = "general",
		subtype = "morgan_bernhardt",
		name1 = "names_name_3110890001",
		name2 = "",
		name3 = "names_name_3110890002",
		name4 = "",
		make_faction_leader = true,
		callback =
				function(cqi)
						cm:set_character_immortality("character_cqi:" .. cqi, true)
						cm:set_character_unique("character_cqi:"..cqi, true)
				end
	}
}

return grudgebringers
