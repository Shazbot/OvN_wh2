local function chorf_victory_conditions()
	if cm:is_new_game() then
		if cm:get_faction("wh2_main_ovn_chaos_dwarfs"):is_human() then
			local mission = {[[
			mission
			{
				victory_type ovn_victory_type_short;
				key wh_main_short_victory;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						type DESTROY_FACTION;
						faction wh_main_grn_greenskins;
						faction wh_main_dwf_dwarfs;
						faction wh_main_dwf_karak_izor;
						faction wh_main_dwf_karak_kadrin;
						confederation_valid;
					}
					objective
					{
						type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
						total 45;
					}
					objective
					{
						type CAPTURE_X_BATTLE_CAPTIVES;
						total 15000;
					}
					payload
					{
						game_victory;
					}
				}
			}
		]],
		[[
			mission
			{
				victory_type ovn_victory_type_long;
				key wh_main_long_victory;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						type DESTROY_FACTION;
						faction wh_main_grn_greenskins;
						faction wh_main_dwf_dwarfs;
						faction wh_main_dwf_karak_izor;
						faction wh_main_dwf_karak_kadrin;
						faction wh2_main_skv_clan_eshin;
						faction wh2_dlc15_hef_imrik;
                        faction wh_main_emp_empire;
                        faction wh2_dlc13_emp_golden_order;
                        faction wh_main_emp_wissenland;
						confederation_valid;
					}
					objective
					{
						type CONTROL_N_PROVINCES_INCLUDING;
							total 6;
							province wh2_main_the_plain_of_bones;
							province wh2_main_the_wolf_lands;
							province wh2_main_the_broken_teeth;
							province wh2_main_gnoblar_country;
							province wh2_main_southern_dark_lands;
							province wh2_main_northern_dark_lands;
					}
					objective
					{
						type CONTROL_N_REGIONS_FROM;
							total 4;
							region wh_main_the_silver_road_karaz_a_karak;
							region wh_main_eastern_badlands_karak_eight_peaks;
							region wh_main_death_pass_karak_drazh;
							region wh_main_peak_pass_karak_kadrin;
					}
                    objective
					{
						type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
						total 75;
					}
					objective
					{
						type CAPTURE_X_BATTLE_CAPTIVES;
						total 25000;
					}
					payload
					{
						game_victory;
					}
				}
			}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_ovn_chaos_dwarfs", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_ovn_chaos_dwarfs", mission[2]);
		end
	end
end

cm:add_first_tick_callback(function() chorf_victory_conditions() end)
