OVN_ARABY_SLAVE_FOLLOWERS = OVN_ARABY_SLAVE_FOLLOWERS or {}
local mod = OVN_ARABY_SLAVE_FOLLOWERS

---@return CA_UIC
local function find_ui_component_str(starting_comp, str)
	local has_starting_comp = str ~= nil
	if not has_starting_comp then
		str = starting_comp
	end
	local fields = {}
	local pattern = string.format("([^%s]+)", " > ")
	string.gsub(str, pattern, function(c)
		if c ~= "root" then
			fields[#fields+1] = c
		end
	end)
	return find_uicomponent(has_starting_comp and starting_comp or core:get_ui_root(), unpack(fields))
end

local json = require("ovn/json")

local araby_factions = {
	"wh2_main_arb_caliphate_of_araby",
	"wh2_main_arb_aswad_scythans",
	"wh2_main_arb_flaming_scimitar",
}

local cats = {
	"ovn_arb_crafting_lzd",
	"ovn_arb_crafting_dwarfs",
	"ovn_arb_crafting_def",
	"ovn_arb_crafting_hef",
	"ovn_arb_crafting_men",
	"ovn_arb_crafting_undead",
	"ovn_arb_crafting_chaos",
	"ovn_arb_crafting_skv",
	"ovn_arb_crafting_nor",
	"ovn_arb_crafting_we",
	"ovn_arb_crafting_grn",
	"ovn_arb_crafting_bst",
	"ovn_arb_crafting_tmb",
}

local all_cats = {
	"ovn_arb_crafting_lzd",
	"ovn_arb_crafting_dwarfs",
	"ovn_arb_crafting_def",
	"ovn_arb_crafting_hef",
	"ovn_arb_crafting_men",
	"ovn_arb_crafting_undead",
	"ovn_arb_crafting_chaos",
	"ovn_arb_crafting_skv",
	"ovn_arb_crafting_nor",
	"ovn_arb_crafting_we",
	"ovn_arb_crafting_grn",
	"ovn_arb_crafting_bst",
	"ovn_arb_crafting_tmb",
	"ovn_arb_crafting_weapons",
	"ovn_arb_crafting_armor",
	"ovn_arb_crafting_enchanted_items",
	"ovn_arb_crafting_talismans",
	"ovn_arb_crafting_arcane_items",
	}

local ritual_key_to_anci = {
ovn_arb_crafting_followers_1 = "wh2_main_anc_follower_skv_trainee_assassin",
ovn_arb_crafting_followers_2 = "wh2_main_anc_follower_skv_slave_skv",
ovn_arb_crafting_followers_3 = "wh2_main_anc_follower_skv_slave_human",
ovn_arb_crafting_followers_4 = "wh2_main_anc_follower_skv_scribe",
ovn_arb_crafting_followers_5 = "wh2_main_anc_follower_skv_scavenger_1",
ovn_arb_crafting_followers_6 = "wh2_main_anc_follower_skv_sacrificial_victim_lizardman",
ovn_arb_crafting_followers_7 = "wh2_main_anc_follower_skv_sacrificial_victim_dwarf",
ovn_arb_crafting_followers_8 = "wh2_main_anc_follower_skv_saboteur",
ovn_arb_crafting_followers_9 = "wh2_main_anc_follower_skv_pet_wolf_rat",
ovn_arb_crafting_followers_10 = "wh2_main_anc_follower_skv_messenger",
ovn_arb_crafting_followers_11 = "wh2_main_anc_follower_skv_mechanic",
ovn_arb_crafting_followers_12 = "wh2_main_anc_follower_skv_hell_pit_attendant",
ovn_arb_crafting_followers_13 = "wh2_main_anc_follower_skv_female",
ovn_arb_crafting_followers_14 = "wh2_main_anc_follower_skv_clerk",
ovn_arb_crafting_followers_15 = "wh2_main_anc_follower_skv_chemist",
ovn_arb_crafting_followers_16 = "wh2_main_anc_follower_skv_bodyguard",
ovn_arb_crafting_followers_17 = "wh2_main_anc_follower_skv_artefact_hunter",
ovn_arb_crafting_followers_18 = "wh2_main_anc_follower_lzd_zoat",
ovn_arb_crafting_followers_19 = "wh2_main_anc_follower_lzd_veteran_warrior",
ovn_arb_crafting_followers_20 = "wh2_main_anc_follower_lzd_temple_cleaner",
ovn_arb_crafting_followers_21 = "wh2_main_anc_follower_lzd_sacrificial_victim_skv",
ovn_arb_crafting_followers_22 = "wh2_main_anc_follower_lzd_sacrificial_victim_human",
ovn_arb_crafting_followers_23 = "wh2_main_anc_follower_lzd_librarian",
ovn_arb_crafting_followers_24 = "wh2_main_anc_follower_lzd_gardener",
ovn_arb_crafting_followers_25 = "wh2_main_anc_follower_lzd_fan_waver",
ovn_arb_crafting_followers_26 = "wh2_main_anc_follower_lzd_defence_expert",
ovn_arb_crafting_followers_27 = "wh2_main_anc_follower_lzd_clerk",
ovn_arb_crafting_followers_28 = "wh2_main_anc_follower_lzd_attendant",
ovn_arb_crafting_followers_29 = "wh2_main_anc_follower_lzd_astronomer",
ovn_arb_crafting_followers_30 = "wh2_main_anc_follower_lzd_artefact_hunter",
ovn_arb_crafting_followers_31 = "wh2_main_anc_follower_lzd_archivist",
ovn_arb_crafting_followers_32 = "wh2_main_anc_follower_lzd_acolyte_priest",
ovn_arb_crafting_followers_33 = "wh2_dlc12_lzd_anc_follower_swamp_trawler_skink",
ovn_arb_crafting_followers_34 = "wh2_dlc12_lzd_anc_follower_prophets_spawn_brother",
ovn_arb_crafting_followers_35 = "wh2_dlc12_lzd_anc_follower_priest_of_the_star_chambers",
ovn_arb_crafting_followers_36 = "wh2_dlc12_lzd_anc_follower_piqipoqi_qupacoco",
ovn_arb_crafting_followers_37 = "wh2_dlc12_lzd_anc_follower_obsinite_miner_skink",
ovn_arb_crafting_followers_38 = "wh2_dlc12_lzd_anc_follower_lotl_botls_spawn_brother",
ovn_arb_crafting_followers_39 = "wh2_dlc12_lzd_anc_follower_consul_of_calith",
ovn_arb_crafting_followers_40 = "wh2_dlc12_lzd_anc_follower_chameleon_spotter",
ovn_arb_crafting_followers_41 = "wh2_main_anc_follower_hef_wine_merchant",
ovn_arb_crafting_followers_42 = "wh2_main_anc_follower_hef_trappist",
ovn_arb_crafting_followers_43 = "wh2_main_anc_follower_hef_shrine_keeper",
ovn_arb_crafting_followers_44 = "wh2_main_anc_follower_hef_scout",
ovn_arb_crafting_followers_45 = "wh2_main_anc_follower_hef_raven_keeper",
ovn_arb_crafting_followers_46 = "wh2_main_anc_follower_hef_priestess_isha",
ovn_arb_crafting_followers_47 = "wh2_main_anc_follower_hef_priest_vaul",
ovn_arb_crafting_followers_48 = "wh2_main_anc_follower_hef_poisoner",
ovn_arb_crafting_followers_49 = "wh2_main_anc_follower_hef_minstrel",
ovn_arb_crafting_followers_50 = "wh2_main_anc_follower_hef_librarian",
ovn_arb_crafting_followers_51 = "wh2_main_anc_follower_hef_food_taster",
ovn_arb_crafting_followers_52 = "wh2_main_anc_follower_hef_dragon_armourer",
ovn_arb_crafting_followers_53 = "wh2_main_anc_follower_hef_counterspy",
ovn_arb_crafting_followers_54 = "wh2_main_anc_follower_hef_counsellor",
ovn_arb_crafting_followers_55 = "wh2_main_anc_follower_hef_beard_weaver",
ovn_arb_crafting_followers_56 = "wh2_main_anc_follower_hef_bard",
ovn_arb_crafting_followers_57 = "wh2_main_anc_follower_hef_assassin",
ovn_arb_crafting_followers_58 = "wh2_main_anc_follower_hef_admiral",
ovn_arb_crafting_followers_59 = "wh2_main_anc_follower_def_slave_trader",
ovn_arb_crafting_followers_60 = "wh2_main_anc_follower_def_slave",
ovn_arb_crafting_followers_61 = "wh2_main_anc_follower_def_propagandist",
ovn_arb_crafting_followers_62 = "wh2_main_anc_follower_def_overseer",
ovn_arb_crafting_followers_63 = "wh2_main_anc_follower_def_organ_merchant",
ovn_arb_crafting_followers_64 = "wh2_main_anc_follower_def_musician_flute",
ovn_arb_crafting_followers_65 = "wh2_main_anc_follower_def_musician_drum",
ovn_arb_crafting_followers_66 = "wh2_main_anc_follower_def_musician_choirmaster",
ovn_arb_crafting_followers_67 = "wh2_main_anc_follower_def_merchant",
ovn_arb_crafting_followers_68 = "wh2_main_anc_follower_def_harem_keeper",
ovn_arb_crafting_followers_69 = "wh2_main_anc_follower_def_gravedigger",
ovn_arb_crafting_followers_70 = "wh2_main_anc_follower_def_fanatic",
ovn_arb_crafting_followers_71 = "wh2_main_anc_follower_def_diplomat_slaanesh",
ovn_arb_crafting_followers_72 = "wh2_main_anc_follower_def_diplomat",
ovn_arb_crafting_followers_73 = "wh2_main_anc_follower_def_cultist",
ovn_arb_crafting_followers_74 = "wh2_main_anc_follower_def_bodyguard",
ovn_arb_crafting_followers_75 = "wh2_main_anc_follower_def_beastmaster",
ovn_arb_crafting_followers_76 = "wh2_main_anc_follower_def_apprentice_assassin",
ovn_arb_crafting_followers_77 = "wh2_dlc15_anc_follower_mandelour",
ovn_arb_crafting_followers_78 = "wh2_dlc14_anc_follower_malus_urial",
ovn_arb_crafting_followers_79 = "wh2_dlc14_anc_follower_malus_nagaira",
ovn_arb_crafting_followers_80 = "wh2_dlc14_anc_follower_malus_lurhan",
ovn_arb_crafting_followers_81 = "wh2_dlc14_anc_follower_malus_isilvar",
ovn_arb_crafting_followers_82 = "wh2_dlc14_anc_follower_malus_hauclir",
ovn_arb_crafting_followers_83 = "wh2_dlc14_anc_follower_malus_engvin",
ovn_arb_crafting_followers_84 = "wh2_dlc14_anc_follower_malus_edlire",
ovn_arb_crafting_followers_85 = "wh2_dlc14_anc_follower_malus_balneth_bale",
ovn_arb_crafting_followers_86 = "wh2_dlc14_anc_follower_malus_arleth_vann",
ovn_arb_crafting_followers_87 = "wh2_dlc09_anc_follower_tmb_ushabti_bodyguard",
ovn_arb_crafting_followers_88 = "wh2_dlc09_anc_follower_tmb_tombfleet_taskmaster",
ovn_arb_crafting_followers_89 = "wh2_dlc09_anc_follower_tmb_skeletal_labourer",
ovn_arb_crafting_followers_90 = "wh2_dlc09_anc_follower_tmb_priest_of_ptra",
ovn_arb_crafting_followers_91 = "wh2_dlc09_anc_follower_tmb_legionnaire_of_asaph",
ovn_arb_crafting_followers_92 = "wh2_dlc09_anc_follower_tmb_high_born_of_khemri",
ovn_arb_crafting_followers_93 = "wh2_dlc09_anc_follower_tmb_cultist_of_usirian",
ovn_arb_crafting_followers_94 = "wh2_dlc09_anc_follower_tmb_charnel_valley_necrotect",
ovn_arb_crafting_followers_95 = "wh2_dlc09_anc_follower_tmb_acolyte_of_sokth",
ovn_arb_crafting_followers_96 = "wh_main_anc_follower_undead_warp_stone_hunter",
ovn_arb_crafting_followers_97 = "wh_main_anc_follower_undead_warlock",
ovn_arb_crafting_followers_98 = "wh_main_anc_follower_undead_possessed_mirror",
ovn_arb_crafting_followers_99 = "wh_main_anc_follower_undead_poltergeist",
ovn_arb_crafting_followers_100 = "wh_main_anc_follower_undead_mortal_informer",
ovn_arb_crafting_followers_101 = "wh_main_anc_follower_undead_manservant",
ovn_arb_crafting_followers_102 = "wh_main_anc_follower_undead_corpse_thief",
ovn_arb_crafting_followers_103 = "wh_main_anc_follower_undead_carrion",
ovn_arb_crafting_followers_104 = "wh_main_anc_follower_undead_black_cat",
ovn_arb_crafting_followers_106 = "wh_main_anc_follower_halfling_fieldwarden",
ovn_arb_crafting_followers_107 = "wh_main_anc_follower_empire_woodsman",
ovn_arb_crafting_followers_108 = "wh_main_anc_follower_empire_watchman",
ovn_arb_crafting_followers_109 = "wh_main_anc_follower_empire_tradesman",
ovn_arb_crafting_followers_110 = "wh_main_anc_follower_empire_thief",
ovn_arb_crafting_followers_111 = "wh_main_anc_follower_empire_seaman",
ovn_arb_crafting_followers_112 = "wh_main_anc_follower_empire_scribe",
ovn_arb_crafting_followers_113 = "wh_main_anc_follower_empire_road_warden",
ovn_arb_crafting_followers_114 = "wh_main_anc_follower_empire_rat_catcher",
ovn_arb_crafting_followers_115 = "wh_main_anc_follower_empire_peasant",
ovn_arb_crafting_followers_116 = "wh_main_anc_follower_empire_noble",
ovn_arb_crafting_followers_117 = "wh_main_anc_follower_empire_messenger",
ovn_arb_crafting_followers_118 = "wh_main_anc_follower_empire_marine",
ovn_arb_crafting_followers_119 = "wh_main_anc_follower_empire_light_college_acolyte",
ovn_arb_crafting_followers_120 = "wh_main_anc_follower_empire_jailer",
ovn_arb_crafting_followers_121 = "wh_main_anc_follower_empire_hunter",
ovn_arb_crafting_followers_122 = "wh_main_anc_follower_empire_ferryman",
ovn_arb_crafting_followers_123 = "wh_main_anc_follower_empire_entertainer",
ovn_arb_crafting_followers_124 = "wh_main_anc_follower_empire_coachman",
ovn_arb_crafting_followers_125 = "wh_main_anc_follower_empire_charcoal_burner",
ovn_arb_crafting_followers_126 = "wh_main_anc_follower_empire_camp_follower",
ovn_arb_crafting_followers_127 = "wh_main_anc_follower_empire_burgher",
ovn_arb_crafting_followers_128 = "wh_main_anc_follower_empire_bone_picker",
ovn_arb_crafting_followers_129 = "wh_main_anc_follower_empire_barber_surgeon",
ovn_arb_crafting_followers_130 = "wh_main_anc_follower_empire_apprentice_wizard",
ovn_arb_crafting_followers_131 = "wh_main_anc_follower_empire_agitator",
ovn_arb_crafting_followers_132 = "wh_main_anc_follower_bretonnia_squire",
ovn_arb_crafting_followers_133 = "wh_main_anc_follower_bretonnia_court_jester",
ovn_arb_crafting_followers_134 = "wh_main_anc_follower_all_student",
ovn_arb_crafting_followers_135 = "wh_main_anc_follower_all_men_zealot",
ovn_arb_crafting_followers_136 = "wh_main_anc_follower_all_men_valet",
ovn_arb_crafting_followers_137 = "wh_main_anc_follower_all_men_vagabond",
ovn_arb_crafting_followers_138 = "wh_main_anc_follower_all_men_tomb_robber",
ovn_arb_crafting_followers_139 = "wh_main_anc_follower_all_men_tollkeeper",
ovn_arb_crafting_followers_140 = "wh_main_anc_follower_all_men_thug",
ovn_arb_crafting_followers_141 = "wh_main_anc_follower_all_men_soldier",
ovn_arb_crafting_followers_142 = "wh_main_anc_follower_all_men_smuggler",
ovn_arb_crafting_followers_143 = "wh_main_anc_follower_all_men_servant",
ovn_arb_crafting_followers_144 = "wh_main_anc_follower_all_men_rogue",
ovn_arb_crafting_followers_145 = "wh_main_anc_follower_all_men_protagonist",
ovn_arb_crafting_followers_146 = "wh_main_anc_follower_all_men_outrider",
ovn_arb_crafting_followers_147 = "wh_main_anc_follower_all_men_outlaw",
ovn_arb_crafting_followers_148 = "wh_main_anc_follower_all_men_ogres_pit_fighter",
ovn_arb_crafting_followers_149 = "wh_main_anc_follower_all_men_militiaman",
ovn_arb_crafting_followers_150 = "wh_main_anc_follower_all_men_mercenary",
ovn_arb_crafting_followers_151 = "wh_main_anc_follower_all_men_kislevite_kossar",
ovn_arb_crafting_followers_152 = "wh_main_anc_follower_all_men_initiate",
ovn_arb_crafting_followers_153 = "wh_main_anc_follower_all_men_grave_robber",
ovn_arb_crafting_followers_154 = "wh_main_anc_follower_all_men_fisherman",
ovn_arb_crafting_followers_155 = "wh_main_anc_follower_all_men_bounty_hunter",
ovn_arb_crafting_followers_156 = "wh_main_anc_follower_all_men_bodyguard",
ovn_arb_crafting_followers_157 = "wh_main_anc_follower_all_men_boatman",
ovn_arb_crafting_followers_158 = "wh_main_anc_follower_all_men_bailiff",
ovn_arb_crafting_followers_159 = "wh_main_anc_follower_all_hedge_wizard",
ovn_arb_crafting_followers_160 = "wh_dlc08_anc_follower_whalers",
ovn_arb_crafting_followers_161 = "wh_dlc08_anc_follower_slave_worker",
ovn_arb_crafting_followers_162 = "wh_dlc08_anc_follower_skaeling_trader",
ovn_arb_crafting_followers_163 = "wh_dlc08_anc_follower_seer",
ovn_arb_crafting_followers_164 = "wh_dlc08_anc_follower_mountain_scout",
ovn_arb_crafting_followers_165 = "wh_dlc08_anc_follower_mammoth",
ovn_arb_crafting_followers_166 = "wh_dlc08_anc_follower_kurgan_slave_merchant",
ovn_arb_crafting_followers_167 = "wh_dlc08_anc_follower_dragonbone_raiders",
ovn_arb_crafting_followers_168 = "wh_dlc08_anc_follower_cathy_slave_dancers",
ovn_arb_crafting_followers_169 = "wh_dlc08_anc_follower_beserker",
ovn_arb_crafting_followers_170 = "wh_main_anc_follower_dwarfs_troll_slayer",
ovn_arb_crafting_followers_171 = "wh_main_anc_follower_dwarfs_treasure_hunter",
ovn_arb_crafting_followers_172 = "wh_main_anc_follower_dwarfs_teller_of_tales",
ovn_arb_crafting_followers_173 = "wh_main_anc_follower_dwarfs_stonemason",
ovn_arb_crafting_followers_174 = "wh_main_anc_follower_dwarfs_shipwright",
ovn_arb_crafting_followers_175 = "wh_main_anc_follower_dwarfs_sapper",
ovn_arb_crafting_followers_176 = "wh_main_anc_follower_dwarfs_runebearer",
ovn_arb_crafting_followers_177 = "wh_main_anc_follower_dwarfs_reckoner",
ovn_arb_crafting_followers_178 = "wh_main_anc_follower_dwarfs_prospector",
ovn_arb_crafting_followers_179 = "wh_main_anc_follower_dwarfs_powder_mixer",
ovn_arb_crafting_followers_180 = "wh_main_anc_follower_dwarfs_miner",
ovn_arb_crafting_followers_181 = "wh_main_anc_follower_dwarfs_jewelsmith",
ovn_arb_crafting_followers_182 = "wh_main_anc_follower_dwarfs_guildmaster",
ovn_arb_crafting_followers_183 = "wh_main_anc_follower_dwarfs_grudgekeeper",
ovn_arb_crafting_followers_184 = "wh_main_anc_follower_dwarfs_goldsmith",
ovn_arb_crafting_followers_185 = "wh_main_anc_follower_dwarfs_dwarfen_tattooist",
ovn_arb_crafting_followers_186 = "wh_main_anc_follower_dwarfs_dwarf_bride",
ovn_arb_crafting_followers_187 = "wh_main_anc_follower_dwarfs_daughter_of_valaya",
ovn_arb_crafting_followers_188 = "wh_main_anc_follower_dwarfs_cooper",
ovn_arb_crafting_followers_189 = "wh_main_anc_follower_dwarfs_choir_master",
ovn_arb_crafting_followers_190 = "wh_main_anc_follower_dwarfs_candle_maker",
ovn_arb_crafting_followers_191 = "wh_main_anc_follower_dwarfs_brewmaster",
ovn_arb_crafting_followers_192 = "wh_main_anc_follower_dwarfs_archivist",
ovn_arb_crafting_followers_193 = "wh_dlc03_anc_follower_beastmen_spawn_wrangler",
ovn_arb_crafting_followers_194 = "wh_dlc03_anc_follower_beastmen_pox_carrier",
ovn_arb_crafting_followers_195 = "wh_dlc03_anc_follower_beastmen_mannish_thrall",
ovn_arb_crafting_followers_196 = "wh_dlc03_anc_follower_beastmen_flying_spy",
ovn_arb_crafting_followers_197 = "wh_dlc03_anc_follower_beastmen_flayer",
ovn_arb_crafting_followers_198 = "wh_dlc03_anc_follower_beastmen_chieftains_pet",
ovn_arb_crafting_followers_199 = "wh_dlc03_anc_follower_beastmen_bray_shamans_familiar",
ovn_arb_crafting_followers_200 = "wh_dlc01_anc_follower_chaos_slave_master",
ovn_arb_crafting_followers_201 = "wh_dlc01_anc_follower_chaos_possessed",
ovn_arb_crafting_followers_202 = "wh_dlc01_anc_follower_chaos_oar_slave",
ovn_arb_crafting_followers_203 = "wh_dlc01_anc_follower_chaos_mutant",
ovn_arb_crafting_followers_204 = "wh_dlc01_anc_follower_chaos_kurgan_chieftain",
ovn_arb_crafting_followers_205 = "wh_dlc01_anc_follower_chaos_huscarl",
ovn_arb_crafting_followers_207 = "wh_dlc01_anc_follower_chaos_collector",
ovn_arb_crafting_followers_208 = "wh_dlc01_anc_follower_chaos_beast_tamer",
ovn_arb_crafting_followers_209 = "wh_dlc01_anc_follower_chaos_barbarian",
ovn_arb_crafting_followers_210 = "wh_main_anc_follower_greenskins_swindla",
ovn_arb_crafting_followers_212 = "wh_main_anc_follower_greenskins_snotling_scavengers",
ovn_arb_crafting_followers_213 = "wh_main_anc_follower_greenskins_serial_loota",
ovn_arb_crafting_followers_214 = "wh_main_anc_follower_greenskins_pit_boss",
ovn_arb_crafting_followers_215 = "wh_main_anc_follower_greenskins_idol_carva",
ovn_arb_crafting_followers_216 = "wh_main_anc_follower_greenskins_gobbo_ranta",
ovn_arb_crafting_followers_217 = "wh_main_anc_follower_greenskins_dung_collector",
ovn_arb_crafting_followers_218 = "wh_main_anc_follower_greenskins_dog_boy_scout",
ovn_arb_crafting_followers_219 = "wh_main_anc_follower_greenskins_bully",
ovn_arb_crafting_followers_220 = "wh_main_anc_follower_greenskins_bat-winged_loony",
ovn_arb_crafting_followers_221 = "wh_main_anc_follower_greenskins_backstabba",
ovn_arb_crafting_followers_222 = "wh_dlc05_anc_follower_young_stag",
ovn_arb_crafting_followers_223 = "wh_dlc05_anc_follower_vauls_anvil_smith",
ovn_arb_crafting_followers_224 = "wh_dlc05_anc_follower_royal_standard_bearer",
ovn_arb_crafting_followers_225 = "wh_dlc05_anc_follower_hunting_hound",
ovn_arb_crafting_followers_226 = "wh_dlc05_anc_follower_hawk_companion",
ovn_arb_crafting_followers_227 = "wh_dlc05_anc_follower_forest_spirit",
ovn_arb_crafting_followers_228 = "wh_dlc05_anc_follower_elder_scout",
ovn_arb_crafting_followers_229 = "wh_dlc05_anc_follower_dryad_spy",
ovn_arb_crafting_followers_230 = "wh2_main_anc_follower_sea_cucumber",
ovn_arb_crafting_followers_231 = "wh2_dlc11_anc_follower_cst_travelling_necromancer",
ovn_arb_crafting_followers_232 = "wh2_dlc11_anc_follower_cst_sartosa_navigator",
}

local function add_custom_panel()
	local mort = find_ui_component_str("root > mortuary_cult")
	if not mort then return end

	mort:SetDockOffset(-120, 0)

	local ski = core:get_or_create_component("ovn_crafting_araby_slaves_back_frame", "ui/templates/custom_image", mort)
	ski:SetImagePath("ui/ovn/ovn_crafting_araby_slaves_back_frame.png", 4)
	ski:SetDockingPoint(3)
	ski:SetDockOffset(281+18, 0)
	ski:SetCanResizeHeight(true)
	ski:SetCanResizeWidth(true)
	ski:Resize(300+18-18,955-20)

	local new_title = find_ui_component_str(mort, "ovn_crafting_araby_slaves_title")
	if not new_title then
		local title = find_ui_component_str(mort, "panel_title")
		new_title = UIComponent(title:CopyComponent("ovn_crafting_araby_slaves_title"))
		ski:Adopt(new_title:Address())
	end
	new_title:SetDockingPoint(2)
	new_title:SetDockOffset(0, -5)
	new_title:SetImagePath("ui/ovn/transparent.png")
	local title_text = find_ui_component_str(new_title, "tx")
	title_text:SetStateText("Slave Market")

	local skil = core:get_or_create_component("ovn_crafting_araby_slaves_top_left", "ui/templates/custom_image", ski)
	local skir = core:get_or_create_component("ovn_crafting_araby_slaves_top_right", "ui/templates/custom_image", ski)
	skil:SetImagePath("ui/skins/default/empire_event_ornament_top_left.png", 4)
	skir:SetImagePath("ui/skins/default/empire_event_ornament_top_right.png", 4)
	skil:SetDockingPoint(1)
	skil:SetDockOffset(-10, 0)
	skir:SetDockingPoint(3)
	skir:SetDockOffset(5, 0)
end

core:remove_listener("ovn_arb_crafting_adjust_panel_opened")
core:add_listener(
	"ovn_arb_crafting_adjust_panel_opened",
	"PanelOpenedCampaign",
	function(context)	return context.string == "mortuary_cult"
	end,
	function()
		if table_contains(araby_factions, cm:get_local_faction_name(true)) then
			real_timer.register_repeating("ovn_arb_crafting_adjust_panel", 0)
		end
	end,
	true
)

mod.rearrange_category_buttons = function()
	local mort = find_ui_component_str("root > mortuary_cult")
	if not mort then return end

	local mort2 = find_ui_component_str(mort, "ovn_crafting_araby_slaves_back_frame")
	if not mort2 then
		add_custom_panel()
		return
	end

	local buy_slaves_button = core:get_or_create_component("ovn_crafting_araby_slaves_buy_slaves", "ui/templates/square_large_text_button", mort2)
	buy_slaves_button:SetDockingPoint(2)
	buy_slaves_button:SetDockOffset(0, 85)
	buy_slaves_button:SetCanResizeWidth(true)
	buy_slaves_button:SetCanResizeHeight(true)
	buy_slaves_button:Resize(339-70, 51)
	local button_txt = find_uicomponent(buy_slaves_button, "button_txt")
	button_txt:SetStateText("Buy Sharkas Slaves")
	local tooltip = "The last selected Arabyan army will receive a unit of Sharkas Slaves. The army must be in player-owned territory. Costs 300[[img:icon_money]][[/img]]."

	local char = mod.last_araby_char_cqi and cm:get_character_by_cqi(mod.last_araby_char_cqi)
	if not char or char:is_null_interface() then
		tooltip = tooltip.."\n\n[[col:red]]No valid army was selected![[/col]]"
		buy_slaves_button:SetState("inactive")
	else
		local forename = effect.get_localised_string(char:get_forename())
		local surname = effect.get_localised_string(char:get_surname())
		local localized_name = surname
		if forename ~= "" then
			localized_name = forename.." "..surname
		end
		tooltip = tooltip.."\n\n[[col:yellow]]Army of "..localized_name.." was selected for this![[/col]]"

		local num_items = char:military_force():unit_list():num_items()
		if num_items > 19 then
			tooltip = tooltip.."\n\n[[col:red]]Army is full![[/col]]"
			buy_slaves_button:SetState("inactive")
		end

		if char:region():owning_faction():name() ~= char:faction():name() then
			tooltip = tooltip.."\n\n[[col:red]]Army is outside its owned territory![[/col]]"
			buy_slaves_button:SetState("inactive")
		end
	end

	if cm:get_local_faction(true):treasury() < 300 then
		tooltip = tooltip.."\n\n[[col:red]]Not enough [[img:icon_money]][[/img]]![[/col]]"
		buy_slaves_button:SetState("inactive")
	end

	if buy_slaves_button:GetTooltipText() ~= tooltip then
		buy_slaves_button:SetTooltipText(tooltip, true)
	end

	local header = find_uicomponent(mort, "header_list")
	for i, cat_name in ipairs(cats) do
		local cat = find_uicomponent(header, cat_name)
		if cat then
			if find_uicomponent(mort2, cat_name) then
				local dummy = core:get_or_create_component("pj_dummy", "UI/campaign ui/script_dummy", mort)
				dummy:Adopt(cat:Address())
				dummy:SetVisible(false)
			else
				mort2:Adopt(cat:Address())
				cat:SetDockingPoint(3)
				cat:SetDockOffset(0,i*30)
			end
		end
	end
	header:Layout()

	for i, cat_name in ipairs(cats) do
		local cat = find_uicomponent(mort2, cat_name)
		if cat then
			cat:SetDockingPoint(2)
			cat:SetDockOffset(0,i*60+85)
		end
	end
end

local function adjust_araby_crafting_panel()
	local mortuary_cult = find_ui_component_str("root > mortuary_cult")
	if not mortuary_cult then
		real_timer.unregister("ovn_arb_crafting_adjust_panel")
	end

	mod.rearrange_category_buttons()

	local lb = find_ui_component_str(mortuary_cult, "listview > list_clip > list_box")
	if not lb then return end

	if not mod.current_category or not table_contains(cats, mod.current_category) then return end
	local pooled_res_id = mod.category_to_id[mod.current_category]
	if not pooled_res_id then return end

	local lfk = cm:get_local_faction_name(true)

	for i=0, lb:ChildCount()-1 do
		local follower = UIComponent(lb:Find(i))
		local name = find_uicomponent(follower, "dy_name")

		local victories = find_ui_component_str(follower, "requirement_list > "..pooled_res_id.." > dy_value")
		if victories then
			victories:SetStateText(mod.get_cost(lfk, pooled_res_id))
		end

		local anci = ritual_key_to_anci[follower:Id()]
		if anci then
			name:SetStateText(effect.get_localised_string("ancillaries_onscreen_name_"..anci))
		end
	end
end

core:remove_listener("ovn_arb_crafting_adjust_panel_cb")
core:add_listener(
	"ovn_arb_crafting_adjust_panel_cb",
	"RealTimeTrigger",
	function(context)
		return context.string == "ovn_arb_crafting_adjust_panel"
	end,
	function()
		adjust_araby_crafting_panel()
	end,
	true
)

core:remove_listener("ovn_crafting_araby_slaves_buy_slaves_on_char_selected")
core:add_listener(
	"ovn_crafting_araby_slaves_buy_slaves_on_char_selected",
	"CharacterSelected",
	true,
	function(context)
		---@type CA_CHAR
		local char = context:character()

		local char_faction_key = char:faction():name()
		if not table_contains(araby_factions, char_faction_key) then return end

		if not char:has_military_force() then return end

		mod.last_araby_char_cqi = char:command_queue_index()
	end,
	true
)

mod.give_sharkas_slaves = function()
	local data_to_send = {
		cqi = mod.last_araby_char_cqi,
	}
	CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(), "ovn_crafting_araby_slaves_sharkas|"..json.encode(data_to_send))
end

core:remove_listener('ovn_arb_crafting_clicked_category_button')
core:add_listener(
	'ovn_arb_crafting_clicked_category_button',
	'ComponentLClickUp',
	true,
	function(context)
		if not table_contains(araby_factions, cm:get_local_faction_name(true)) then
			return
		end

		if context.string == "ovn_crafting_araby_slaves_buy_slaves" then
			mod.give_sharkas_slaves()
			-- find_ui_component_str("root > mortuary_cult > button_ok_frame > button_ok"):SimulateLClick()
		end

		if context.string ~= "button" then return end
		local id = UIComponent(UIComponent(context.component):Parent()):Id()
		if not table_contains(all_cats, id) then return end
		mod.current_category = id

		local mort = find_ui_component_str("root > mortuary_cult")
		if not mort then return end

		for i, cat_name in ipairs(cats) do
			local cat = find_uicomponent(mort, cat_name)
			if cat and id ~= cat_name then
				local button = find_uicomponent(cat, "button")
				if button then
					button:SetState("active")
				end
			end
		end
	end,
	true
)

core:remove_listener('ovn_arb_crafting_clicked_buy_button')
core:add_listener(
	'ovn_arb_crafting_clicked_buy_button',
	'ComponentLClickUp',
	true,
	function(context)
		if not table_contains(araby_factions, cm:get_local_faction_name(true)) then
			return
		end

		if context.string ~= "button_craft" then return end
		local parent_id = UIComponent(UIComponent(context.component):Parent()):Id()
		if not string.match(parent_id, "^ovn_arb_crafting_followers_%d+$") then return end

		local pooled_res_id = mod.category_to_id[mod.current_category]
		-- dout("pooled res id: "..pooled_res_id)
		if not pooled_res_id then return end

		local faction_key = cm:get_local_faction_name(true)
		if not mod.current_victories[faction_key] or not mod.current_victories[faction_key][pooled_res_id] then
			-- dout("NO POOLED RES FOUND")
			return
		end

		if mod.get_cost(faction_key, pooled_res_id) > mod.current_victories[faction_key][pooled_res_id] then
			-- dout("COST TOO HIGH")
			return
		end

		local data_to_send = {
			fk = faction_key,
			pr = pooled_res_id,
			c = mod.get_cost(faction_key, pooled_res_id),
		}
		CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(), "ovn_crafting_araby_slaves_purchased|"..json.encode(data_to_send))
	end,
	true
)

local subculture_to_res = {
	wh2_main_sc_lzd_lizardmen = "ovn_araby_victories_lzd",
	wh_main_sc_dwf_dwarfs = "ovn_araby_victories_dwarfs",
	wh2_main_sc_def_dark_elves = "ovn_araby_victories_def",
	wh2_main_sc_hef_high_elves = "ovn_araby_victories_hef",
	wh2_dlc11_sc_cst_vampire_coast = "ovn_araby_victories_undead",
	wh_main_sc_chs_chaos = "ovn_araby_victories_chaos",
	wh2_main_sc_skv_skaven = "ovn_araby_victories_skv",
	wh_main_sc_nor_norsca = "ovn_araby_victories_nor",
	wh_dlc05_sc_wef_wood_elves = "ovn_araby_victories_we",
	wh_dlc03_sc_bst_beastmen = "ovn_araby_victories_bst",
	wh2_dlc09_sc_tmb_tomb_kings = "ovn_araby_victories_tmb",
}

local culture_to_res = {
	wh_main_emp_empire = "ovn_araby_victories_men",
	wh2_main_rogue = "ovn_araby_victories_men",
	wh_main_brt_bretonnia = "ovn_araby_victories_men",
	wh_main_grn_greenskins = "ovn_araby_victories_grn",
}

mod.category_to_id = {
	ovn_arb_crafting_lzd = "ovn_araby_victories_lzd",
	ovn_arb_crafting_dwarfs = "ovn_araby_victories_dwarfs",
	ovn_arb_crafting_def = "ovn_araby_victories_def",
	ovn_arb_crafting_hef = "ovn_araby_victories_hef",
	ovn_arb_crafting_men = "ovn_araby_victories_men",
	ovn_arb_crafting_undead = "ovn_araby_victories_undead",
	ovn_arb_crafting_chaos = "ovn_araby_victories_chaos",
	ovn_arb_crafting_skv = "ovn_araby_victories_skv",
	ovn_arb_crafting_nor = "ovn_araby_victories_nor",
	ovn_arb_crafting_we = "ovn_araby_victories_we",
	ovn_arb_crafting_grn = "ovn_araby_victories_grn",
	ovn_arb_crafting_bst = "ovn_araby_victories_bst",
	ovn_arb_crafting_tmb = "ovn_araby_victories_tmb",
}

mod.default_victories_state = {
	ovn_araby_victories_lzd = 0,
	ovn_araby_victories_dwarfs = 0,
	ovn_araby_victories_def = 0,
	ovn_araby_victories_hef = 0,
	ovn_araby_victories_men = 0,
	ovn_araby_victories_undead = 0,
	ovn_araby_victories_chaos = 0,
	ovn_araby_victories_skv = 0,
	ovn_araby_victories_nor = 0,
	ovn_araby_victories_we = 0,
	ovn_araby_victories_grn = 0,
	ovn_araby_victories_bst = 0,
	ovn_araby_victories_tmb = 0,
}

mod.current_victories = mod.current_victories or {}

local victory_effects = {
	"ovn_araby_victories_lzd",
	"ovn_araby_victories_dwarfs",
	"ovn_araby_victories_def",
	"ovn_araby_victories_hef",
	"ovn_araby_victories_men",
	"ovn_araby_victories_undead",
	"ovn_araby_victories_chaos",
	"ovn_araby_victories_skv",
	"ovn_araby_victories_nor",
	"ovn_araby_victories_we",
	"ovn_araby_victories_grn",
	"ovn_araby_victories_bst",
	"ovn_araby_victories_tmb",
}

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

for _, araby_faction_key in ipairs(araby_factions) do
	mod.current_victories[araby_faction_key] = mod.current_victories[araby_faction_key]
		or table_clone(mod.default_victories_state)
end

mod.refresh_victories_bundle = function()
	local local_faction_key = cm:get_local_faction_name(true)
	local upkeep_bundle = cm:create_new_custom_effect_bundle("ovn_crafting_araby_slaves")

	if not mod.current_victories[local_faction_key] then
		mod.current_victories[local_faction_key] = table_clone(mod.default_victories_state)
	end

	for _, effect_key in ipairs(victory_effects) do
		upkeep_bundle:add_effect(effect_key, "faction_to_faction_own_unseen", mod.current_victories[local_faction_key][effect_key])
	end
	cm:apply_custom_effect_bundle_to_faction(upkeep_bundle, cm:get_faction(local_faction_key))
end

mod.num_times_purchased = mod.num_times_purchased or {}

for _, araby_faction_key in ipairs(araby_factions) do
	mod.num_times_purchased[araby_faction_key] = mod.num_times_purchased[araby_faction_key]
		or table_clone(mod.default_victories_state)
end

mod.get_cost = function(faction_key, id)
	if not mod.num_times_purchased[faction_key] then
		mod.num_times_purchased[faction_key] = table_clone(mod.default_victories_state)
	end
	if not mod.num_times_purchased[faction_key][id] then
		mod.num_times_purchased[faction_key][id] = 0
	end
	return mod.num_times_purchased[faction_key][id] + 1
end

mod.calculate_post_victories_changes = function(faction_key, id)
	if mod.get_cost(faction_key, id) <= mod.current_victories[faction_key][id] then
		local pooled_res = cm:get_faction(faction_key):pooled_resource(id)
		if pooled_res and not pooled_res:is_null_interface() and pooled_res:value() ~= 100 then
			cm:faction_add_pooled_resource(faction_key, id, "wh2_main_resource_factor_other", 100)
		end
	end
end

mod.handle_battle_rewards = function(context)
	if cm:model():pending_battle():has_been_fought() == true then
		local attacker_result = cm:model():pending_battle():attacker_battle_result()
		local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory")

		local attacker_keys = {}
		local defender_keys = {}

		for i = 1, cm:pending_battle_cache_num_attackers() do
			local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)
			attacker_keys[attacker_name] = true
		end

		for i = 1, cm:pending_battle_cache_num_defenders() do
			local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i)
			defender_keys[defender_name] = true
		end

		local winners = attacker_won and attacker_keys or defender_keys
		local losers = attacker_won and defender_keys or attacker_keys

		local is_araby_present = false
		for _, araby_faction in ipairs(araby_factions) do
			if winners[araby_faction] then
				is_araby_present = true
				break
			end
		end

		if not is_araby_present then return end

		local pooled_resources = {}
		for loser_key in pairs(losers) do
			local f = cm:get_faction(loser_key)
			if f and not f:is_null_interface() then
				local pooled_res = culture_to_res[f:culture()]
				if not pooled_res then
					pooled_res = subculture_to_res[f:subculture()]
				end
				if pooled_res then
					pooled_resources[pooled_res] = true
				end
			end
		end

		for winner_key in pairs(winners) do
			if table_contains(araby_factions, winner_key) then
				local f = cm:get_faction(winner_key)
				if f and not f:is_null_interface() then
					for pooled_res_name in pairs(pooled_resources) do
						local pooled_res = f:pooled_resource(pooled_res_name)
						if pooled_res and not pooled_res:is_null_interface() then
							if not mod.current_victories[winner_key] then
								mod.current_victories[winner_key] = table_clone(mod.default_victories_state)
							end
							if mod.current_victories[winner_key][pooled_res_name] then
								mod.current_victories[winner_key][pooled_res_name] = mod.current_victories[winner_key][pooled_res_name] + 1
								mod.calculate_post_victories_changes(winner_key, pooled_res_name)
							end
						end
					end
				end
			end
		end
	end

	mod.refresh_victories_bundle()
end

core:remove_listener("ovn_crafting_araby_slaves_BattleCompleted")
core:add_listener(
	"ovn_crafting_araby_slaves_BattleCompleted",
	"BattleCompleted",
	true,
	function(context)
		mod.handle_battle_rewards(context);
	end,
	true
)

core:remove_listener("ovn_crafting_araby_slaves_sharkas_on_UITrigger")
core:add_listener(
	"ovn_crafting_araby_slaves_sharkas_on_UITrigger",
	"UITrigger",
	function(context)
			return context:trigger():starts_with("ovn_crafting_araby_slaves_sharkas")
	end,
	function(context)
		local faction_cqi = context:faction_cqi()

		local stringified_data = context:trigger():gsub("ovn_crafting_araby_slaves_sharkas|", "")

		local data = json.decode(stringified_data)

		local char_cqi = data.cqi

		local char = cm:get_character_by_cqi(char_cqi)
		if not char or char:is_null_interface() then return end

		cm:grant_unit_to_character(cm:char_lookup_str(char_cqi), "ovn_slave")
		cm:treasury_mod(char:faction():name(), -300)
	end,
	true
)

core:remove_listener("ovn_crafting_araby_slaves_purchased_on_UITrigger")
core:add_listener(
	"ovn_crafting_araby_slaves_purchased_on_UITrigger",
	"UITrigger",
	function(context)
			return context:trigger():starts_with("ovn_crafting_araby_slaves_purchased")
	end,
	function(context)
		local faction_cqi = context:faction_cqi()

		local stringified_data = context:trigger():gsub("ovn_crafting_araby_slaves_purchased|", "")

		local data = json.decode(stringified_data)

		local faction_key = data.fk
		local pooled_res_id = data.pr
		local cost = data.c

		mod.current_victories[faction_key][pooled_res_id] = mod.current_victories[faction_key][pooled_res_id] - cost

		if not mod.num_times_purchased[faction_key][pooled_res_id] then
			mod.num_times_purchased[faction_key][pooled_res_id] = 0
		end
		mod.num_times_purchased[faction_key][pooled_res_id] = mod.num_times_purchased[faction_key][pooled_res_id] + 1

		if table_contains(araby_factions, cm:get_local_faction_name(true)) then
			mod.refresh_victories_bundle()
		end
	end,
	true
)

cm:add_first_tick_callback(function()
	if table_contains(araby_factions, cm:get_local_faction_name(true)) then
		mod.refresh_victories_bundle()
	end
end)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ovn_crafting_araby_slaves_purchases", mod.num_times_purchased, context)
		cm:save_named_value("ovn_crafting_araby_slaves_victories", mod.current_victories, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mod.num_times_purchased = cm:load_named_value("ovn_crafting_araby_slaves_purchases", mod.num_times_purchased, context)
		mod.current_victories = cm:load_named_value("ovn_crafting_araby_slaves_victories", mod.current_victories, context)
	end
)


--- Debug stuff:
-- mod.refresh_victories_bundle()
-- cm:trigger_custom_incident(cm:get_local_faction_name(), "pj_rot_warpstone_incident", true, "payload{faction_pooled_resource_transaction{resource ovn_araby_victories_men;factor wh2_main_resource_factor_other;amount "..tostring(100)..";};}");
-- dout(mod.current_victories)
-- dout(mod.current_category)
-- real_timer.unregister("ovn_arb_crafting_adjust_panel")
-- real_timer.register_repeating("ovn_arb_crafting_adjust_panel", 0)


--- Used to get localized names of all the followers:
-- local ancies_in_order = {
-- 	"ovn_arb_crafting_followers_1",
-- 	"ovn_arb_crafting_followers_2",
-- 	"ovn_arb_crafting_followers_3",
-- 	"ovn_arb_crafting_followers_4",
-- 	"ovn_arb_crafting_followers_5",
-- 	"ovn_arb_crafting_followers_6",
-- 	"ovn_arb_crafting_followers_7",
-- 	"ovn_arb_crafting_followers_8",
-- 	"ovn_arb_crafting_followers_9",
-- 	"ovn_arb_crafting_followers_10",
-- 	"ovn_arb_crafting_followers_11",
-- 	"ovn_arb_crafting_followers_12",
-- 	"ovn_arb_crafting_followers_13",
-- 	"ovn_arb_crafting_followers_14",
-- 	"ovn_arb_crafting_followers_15",
-- 	"ovn_arb_crafting_followers_16",
-- 	"ovn_arb_crafting_followers_17",
-- 	"ovn_arb_crafting_followers_18",
-- 	"ovn_arb_crafting_followers_19",
-- 	"ovn_arb_crafting_followers_20",
-- 	"ovn_arb_crafting_followers_21",
-- 	"ovn_arb_crafting_followers_22",
-- 	"ovn_arb_crafting_followers_23",
-- 	"ovn_arb_crafting_followers_24",
-- 	"ovn_arb_crafting_followers_25",
-- 	"ovn_arb_crafting_followers_26",
-- 	"ovn_arb_crafting_followers_27",
-- 	"ovn_arb_crafting_followers_28",
-- 	"ovn_arb_crafting_followers_29",
-- 	"ovn_arb_crafting_followers_30",
-- 	"ovn_arb_crafting_followers_31",
-- 	"ovn_arb_crafting_followers_32",
-- 	"ovn_arb_crafting_followers_33",
-- 	"ovn_arb_crafting_followers_34",
-- 	"ovn_arb_crafting_followers_35",
-- 	"ovn_arb_crafting_followers_36",
-- 	"ovn_arb_crafting_followers_37",
-- 	"ovn_arb_crafting_followers_38",
-- 	"ovn_arb_crafting_followers_39",
-- 	"ovn_arb_crafting_followers_40",
-- 	"ovn_arb_crafting_followers_41",
-- 	"ovn_arb_crafting_followers_42",
-- 	"ovn_arb_crafting_followers_43",
-- 	"ovn_arb_crafting_followers_44",
-- 	"ovn_arb_crafting_followers_45",
-- 	"ovn_arb_crafting_followers_46",
-- 	"ovn_arb_crafting_followers_47",
-- 	"ovn_arb_crafting_followers_48",
-- 	"ovn_arb_crafting_followers_49",
-- 	"ovn_arb_crafting_followers_50",
-- 	"ovn_arb_crafting_followers_51",
-- 	"ovn_arb_crafting_followers_52",
-- 	"ovn_arb_crafting_followers_53",
-- 	"ovn_arb_crafting_followers_54",
-- 	"ovn_arb_crafting_followers_55",
-- 	"ovn_arb_crafting_followers_56",
-- 	"ovn_arb_crafting_followers_57",
-- 	"ovn_arb_crafting_followers_58",
-- 	"ovn_arb_crafting_followers_59",
-- 	"ovn_arb_crafting_followers_60",
-- 	"ovn_arb_crafting_followers_61",
-- 	"ovn_arb_crafting_followers_62",
-- 	"ovn_arb_crafting_followers_63",
-- 	"ovn_arb_crafting_followers_64",
-- 	"ovn_arb_crafting_followers_65",
-- 	"ovn_arb_crafting_followers_66",
-- 	"ovn_arb_crafting_followers_67",
-- 	"ovn_arb_crafting_followers_68",
-- 	"ovn_arb_crafting_followers_69",
-- 	"ovn_arb_crafting_followers_70",
-- 	"ovn_arb_crafting_followers_71",
-- 	"ovn_arb_crafting_followers_72",
-- 	"ovn_arb_crafting_followers_73",
-- 	"ovn_arb_crafting_followers_74",
-- 	"ovn_arb_crafting_followers_75",
-- 	"ovn_arb_crafting_followers_76",
-- 	"ovn_arb_crafting_followers_77",
-- 	"ovn_arb_crafting_followers_78",
-- 	"ovn_arb_crafting_followers_79",
-- 	"ovn_arb_crafting_followers_80",
-- 	"ovn_arb_crafting_followers_81",
-- 	"ovn_arb_crafting_followers_82",
-- 	"ovn_arb_crafting_followers_83",
-- 	"ovn_arb_crafting_followers_84",
-- 	"ovn_arb_crafting_followers_85",
-- 	"ovn_arb_crafting_followers_86",
-- 	"ovn_arb_crafting_followers_87",
-- 	"ovn_arb_crafting_followers_88",
-- 	"ovn_arb_crafting_followers_89",
-- 	"ovn_arb_crafting_followers_90",
-- 	"ovn_arb_crafting_followers_91",
-- 	"ovn_arb_crafting_followers_92",
-- 	"ovn_arb_crafting_followers_93",
-- 	"ovn_arb_crafting_followers_94",
-- 	"ovn_arb_crafting_followers_95",
-- 	"ovn_arb_crafting_followers_96",
-- 	"ovn_arb_crafting_followers_97",
-- 	"ovn_arb_crafting_followers_98",
-- 	"ovn_arb_crafting_followers_99",
-- 	"ovn_arb_crafting_followers_100",
-- 	"ovn_arb_crafting_followers_101",
-- 	"ovn_arb_crafting_followers_102",
-- 	"ovn_arb_crafting_followers_103",
-- 	"ovn_arb_crafting_followers_104",
-- 	"ovn_arb_crafting_followers_106",
-- 	"ovn_arb_crafting_followers_107",
-- 	"ovn_arb_crafting_followers_108",
-- 	"ovn_arb_crafting_followers_109",
-- 	"ovn_arb_crafting_followers_110",
-- 	"ovn_arb_crafting_followers_111",
-- 	"ovn_arb_crafting_followers_112",
-- 	"ovn_arb_crafting_followers_113",
-- 	"ovn_arb_crafting_followers_114",
-- 	"ovn_arb_crafting_followers_115",
-- 	"ovn_arb_crafting_followers_116",
-- 	"ovn_arb_crafting_followers_117",
-- 	"ovn_arb_crafting_followers_118",
-- 	"ovn_arb_crafting_followers_119",
-- 	"ovn_arb_crafting_followers_120",
-- 	"ovn_arb_crafting_followers_121",
-- 	"ovn_arb_crafting_followers_122",
-- 	"ovn_arb_crafting_followers_123",
-- 	"ovn_arb_crafting_followers_124",
-- 	"ovn_arb_crafting_followers_125",
-- 	"ovn_arb_crafting_followers_126",
-- 	"ovn_arb_crafting_followers_127",
-- 	"ovn_arb_crafting_followers_128",
-- 	"ovn_arb_crafting_followers_129",
-- 	"ovn_arb_crafting_followers_130",
-- 	"ovn_arb_crafting_followers_131",
-- 	"ovn_arb_crafting_followers_132",
-- 	"ovn_arb_crafting_followers_133",
-- 	"ovn_arb_crafting_followers_134",
-- 	"ovn_arb_crafting_followers_135",
-- 	"ovn_arb_crafting_followers_136",
-- 	"ovn_arb_crafting_followers_137",
-- 	"ovn_arb_crafting_followers_138",
-- 	"ovn_arb_crafting_followers_139",
-- 	"ovn_arb_crafting_followers_140",
-- 	"ovn_arb_crafting_followers_141",
-- 	"ovn_arb_crafting_followers_142",
-- 	"ovn_arb_crafting_followers_143",
-- 	"ovn_arb_crafting_followers_144",
-- 	"ovn_arb_crafting_followers_145",
-- 	"ovn_arb_crafting_followers_146",
-- 	"ovn_arb_crafting_followers_147",
-- 	"ovn_arb_crafting_followers_148",
-- 	"ovn_arb_crafting_followers_149",
-- 	"ovn_arb_crafting_followers_150",
-- 	"ovn_arb_crafting_followers_151",
-- 	"ovn_arb_crafting_followers_152",
-- 	"ovn_arb_crafting_followers_153",
-- 	"ovn_arb_crafting_followers_154",
-- 	"ovn_arb_crafting_followers_155",
-- 	"ovn_arb_crafting_followers_156",
-- 	"ovn_arb_crafting_followers_157",
-- 	"ovn_arb_crafting_followers_158",
-- 	"ovn_arb_crafting_followers_159",
-- 	"ovn_arb_crafting_followers_160",
-- 	"ovn_arb_crafting_followers_161",
-- 	"ovn_arb_crafting_followers_162",
-- 	"ovn_arb_crafting_followers_163",
-- 	"ovn_arb_crafting_followers_164",
-- 	"ovn_arb_crafting_followers_165",
-- 	"ovn_arb_crafting_followers_166",
-- 	"ovn_arb_crafting_followers_167",
-- 	"ovn_arb_crafting_followers_168",
-- 	"ovn_arb_crafting_followers_169",
-- 	"ovn_arb_crafting_followers_170",
-- 	"ovn_arb_crafting_followers_171",
-- 	"ovn_arb_crafting_followers_172",
-- 	"ovn_arb_crafting_followers_173",
-- 	"ovn_arb_crafting_followers_174",
-- 	"ovn_arb_crafting_followers_175",
-- 	"ovn_arb_crafting_followers_176",
-- 	"ovn_arb_crafting_followers_177",
-- 	"ovn_arb_crafting_followers_178",
-- 	"ovn_arb_crafting_followers_179",
-- 	"ovn_arb_crafting_followers_180",
-- 	"ovn_arb_crafting_followers_181",
-- 	"ovn_arb_crafting_followers_182",
-- 	"ovn_arb_crafting_followers_183",
-- 	"ovn_arb_crafting_followers_184",
-- 	"ovn_arb_crafting_followers_185",
-- 	"ovn_arb_crafting_followers_186",
-- 	"ovn_arb_crafting_followers_187",
-- 	"ovn_arb_crafting_followers_188",
-- 	"ovn_arb_crafting_followers_189",
-- 	"ovn_arb_crafting_followers_190",
-- 	"ovn_arb_crafting_followers_191",
-- 	"ovn_arb_crafting_followers_192",
-- 	"ovn_arb_crafting_followers_193",
-- 	"ovn_arb_crafting_followers_194",
-- 	"ovn_arb_crafting_followers_195",
-- 	"ovn_arb_crafting_followers_196",
-- 	"ovn_arb_crafting_followers_197",
-- 	"ovn_arb_crafting_followers_198",
-- 	"ovn_arb_crafting_followers_199",
-- 	"ovn_arb_crafting_followers_200",
-- 	"ovn_arb_crafting_followers_201",
-- 	"ovn_arb_crafting_followers_202",
-- 	"ovn_arb_crafting_followers_203",
-- 	"ovn_arb_crafting_followers_204",
-- 	"ovn_arb_crafting_followers_205",
-- 	"ovn_arb_crafting_followers_207",
-- 	"ovn_arb_crafting_followers_208",
-- 	"ovn_arb_crafting_followers_209",
-- 	"ovn_arb_crafting_followers_210",
-- 	"ovn_arb_crafting_followers_212",
-- 	"ovn_arb_crafting_followers_213",
-- 	"ovn_arb_crafting_followers_214",
-- 	"ovn_arb_crafting_followers_215",
-- 	"ovn_arb_crafting_followers_216",
-- 	"ovn_arb_crafting_followers_217",
-- 	"ovn_arb_crafting_followers_218",
-- 	"ovn_arb_crafting_followers_219",
-- 	"ovn_arb_crafting_followers_220",
-- 	"ovn_arb_crafting_followers_221",
-- 	"ovn_arb_crafting_followers_222",
-- 	"ovn_arb_crafting_followers_223",
-- 	"ovn_arb_crafting_followers_224",
-- 	"ovn_arb_crafting_followers_225",
-- 	"ovn_arb_crafting_followers_226",
-- 	"ovn_arb_crafting_followers_227",
-- 	"ovn_arb_crafting_followers_228",
-- 	"ovn_arb_crafting_followers_229",
-- 	"ovn_arb_crafting_followers_230",
-- 	"ovn_arb_crafting_followers_231",
-- 	"ovn_arb_crafting_followers_232",
-- }
-- for _, rk in ipairs(ancies_in_order) do
-- 	local anci = ritual_key_to_anci[rk]
-- 	ddump(effect.get_localised_string("ancillaries_onscreen_name_"..anci))
-- end

local ancies_lookup = {
	["wh2_main_anc_follower_skv_trainee_assassin"] = true,
	["wh2_main_anc_follower_skv_slave_skv"] = true,
	["wh2_main_anc_follower_skv_slave_human"] = true,
	["wh2_main_anc_follower_skv_scribe"] = true,
	["wh2_main_anc_follower_skv_scavenger_1"] = true,
	["wh2_main_anc_follower_skv_sacrificial_victim_lizardman"] = true,
	["wh2_main_anc_follower_skv_sacrificial_victim_dwarf"] = true,
	["wh2_main_anc_follower_skv_saboteur"] = true,
	["wh2_main_anc_follower_skv_pet_wolf_rat"] = true,
	["wh2_main_anc_follower_skv_messenger"] = true,
	["wh2_main_anc_follower_skv_mechanic"] = true,
	["wh2_main_anc_follower_skv_hell_pit_attendant"] = true,
	["wh2_main_anc_follower_skv_female"] = true,
	["wh2_main_anc_follower_skv_clerk"] = true,
	["wh2_main_anc_follower_skv_chemist"] = true,
	["wh2_main_anc_follower_skv_bodyguard"] = true,
	["wh2_main_anc_follower_skv_artefact_hunter"] = true,
	["wh2_main_anc_follower_lzd_zoat"] = true,
	["wh2_main_anc_follower_lzd_veteran_warrior"] = true,
	["wh2_main_anc_follower_lzd_temple_cleaner"] = true,
	["wh2_main_anc_follower_lzd_sacrificial_victim_skv"] = true,
	["wh2_main_anc_follower_lzd_sacrificial_victim_human"] = true,
	["wh2_main_anc_follower_lzd_librarian"] = true,
	["wh2_main_anc_follower_lzd_gardener"] = true,
	["wh2_main_anc_follower_lzd_fan_waver"] = true,
	["wh2_main_anc_follower_lzd_defence_expert"] = true,
	["wh2_main_anc_follower_lzd_clerk"] = true,
	["wh2_main_anc_follower_lzd_attendant"] = true,
	["wh2_main_anc_follower_lzd_astronomer"] = true,
	["wh2_main_anc_follower_lzd_artefact_hunter"] = true,
	["wh2_main_anc_follower_lzd_archivist"] = true,
	["wh2_main_anc_follower_lzd_acolyte_priest"] = true,
	["wh2_dlc12_lzd_anc_follower_swamp_trawler_skink"] = true,
	["wh2_dlc12_lzd_anc_follower_prophets_spawn_brother"] = true,
	["wh2_dlc12_lzd_anc_follower_priest_of_the_star_chambers"] = true,
	["wh2_dlc12_lzd_anc_follower_piqipoqi_qupacoco"] = true,
	["wh2_dlc12_lzd_anc_follower_obsinite_miner_skink"] = true,
	["wh2_dlc12_lzd_anc_follower_lotl_botls_spawn_brother"] = true,
	["wh2_dlc12_lzd_anc_follower_consul_of_calith"] = true,
	["wh2_dlc12_lzd_anc_follower_chameleon_spotter"] = true,
	["wh2_main_anc_follower_hef_wine_merchant"] = true,
	["wh2_main_anc_follower_hef_trappist"] = true,
	["wh2_main_anc_follower_hef_shrine_keeper"] = true,
	["wh2_main_anc_follower_hef_scout"] = true,
	["wh2_main_anc_follower_hef_raven_keeper"] = true,
	["wh2_main_anc_follower_hef_priestess_isha"] = true,
	["wh2_main_anc_follower_hef_priest_vaul"] = true,
	["wh2_main_anc_follower_hef_poisoner"] = true,
	["wh2_main_anc_follower_hef_minstrel"] = true,
	["wh2_main_anc_follower_hef_librarian"] = true,
	["wh2_main_anc_follower_hef_food_taster"] = true,
	["wh2_main_anc_follower_hef_dragon_armourer"] = true,
	["wh2_main_anc_follower_hef_counterspy"] = true,
	["wh2_main_anc_follower_hef_counsellor"] = true,
	["wh2_main_anc_follower_hef_beard_weaver"] = true,
	["wh2_main_anc_follower_hef_bard"] = true,
	["wh2_main_anc_follower_hef_assassin"] = true,
	["wh2_main_anc_follower_hef_admiral"] = true,
	["wh2_main_anc_follower_def_slave_trader"] = true,
	["wh2_main_anc_follower_def_slave"] = true,
	["wh2_main_anc_follower_def_propagandist"] = true,
	["wh2_main_anc_follower_def_overseer"] = true,
	["wh2_main_anc_follower_def_organ_merchant"] = true,
	["wh2_main_anc_follower_def_musician_flute"] = true,
	["wh2_main_anc_follower_def_musician_drum"] = true,
	["wh2_main_anc_follower_def_musician_choirmaster"] = true,
	["wh2_main_anc_follower_def_merchant"] = true,
	["wh2_main_anc_follower_def_harem_keeper"] = true,
	["wh2_main_anc_follower_def_gravedigger"] = true,
	["wh2_main_anc_follower_def_fanatic"] = true,
	["wh2_main_anc_follower_def_diplomat_slaanesh"] = true,
	["wh2_main_anc_follower_def_diplomat"] = true,
	["wh2_main_anc_follower_def_cultist"] = true,
	["wh2_main_anc_follower_def_bodyguard"] = true,
	["wh2_main_anc_follower_def_beastmaster"] = true,
	["wh2_main_anc_follower_def_apprentice_assassin"] = true,
	["wh2_dlc15_anc_follower_mandelour"] = true,
	["wh2_dlc14_anc_follower_malus_urial"] = true,
	["wh2_dlc14_anc_follower_malus_nagaira"] = true,
	["wh2_dlc14_anc_follower_malus_lurhan"] = true,
	["wh2_dlc14_anc_follower_malus_isilvar"] = true,
	["wh2_dlc14_anc_follower_malus_hauclir"] = true,
	["wh2_dlc14_anc_follower_malus_engvin"] = true,
	["wh2_dlc14_anc_follower_malus_edlire"] = true,
	["wh2_dlc14_anc_follower_malus_balneth_bale"] = true,
	["wh2_dlc14_anc_follower_malus_arleth_vann"] = true,
	["wh2_dlc09_anc_follower_tmb_ushabti_bodyguard"] = true,
	["wh2_dlc09_anc_follower_tmb_tombfleet_taskmaster"] = true,
	["wh2_dlc09_anc_follower_tmb_skeletal_labourer"] = true,
	["wh2_dlc09_anc_follower_tmb_priest_of_ptra"] = true,
	["wh2_dlc09_anc_follower_tmb_legionnaire_of_asaph"] = true,
	["wh2_dlc09_anc_follower_tmb_high_born_of_khemri"] = true,
	["wh2_dlc09_anc_follower_tmb_cultist_of_usirian"] = true,
	["wh2_dlc09_anc_follower_tmb_charnel_valley_necrotect"] = true,
	["wh2_dlc09_anc_follower_tmb_acolyte_of_sokth"] = true,
	["wh_main_anc_follower_undead_warp_stone_hunter"] = true,
	["wh_main_anc_follower_undead_warlock"] = true,
	["wh_main_anc_follower_undead_possessed_mirror"] = true,
	["wh_main_anc_follower_undead_poltergeist"] = true,
	["wh_main_anc_follower_undead_mortal_informer"] = true,
	["wh_main_anc_follower_undead_manservant"] = true,
	["wh_main_anc_follower_undead_corpse_thief"] = true,
	["wh_main_anc_follower_undead_carrion"] = true,
	["wh_main_anc_follower_undead_black_cat"] = true,
	["wh_main_anc_follower_halfling_fieldwarden"] = true,
	["wh_main_anc_follower_empire_woodsman"] = true,
	["wh_main_anc_follower_empire_watchman"] = true,
	["wh_main_anc_follower_empire_tradesman"] = true,
	["wh_main_anc_follower_empire_thief"] = true,
	["wh_main_anc_follower_empire_seaman"] = true,
	["wh_main_anc_follower_empire_scribe"] = true,
	["wh_main_anc_follower_empire_road_warden"] = true,
	["wh_main_anc_follower_empire_rat_catcher"] = true,
	["wh_main_anc_follower_empire_peasant"] = true,
	["wh_main_anc_follower_empire_noble"] = true,
	["wh_main_anc_follower_empire_messenger"] = true,
	["wh_main_anc_follower_empire_marine"] = true,
	["wh_main_anc_follower_empire_light_college_acolyte"] = true,
	["wh_main_anc_follower_empire_jailer"] = true,
	["wh_main_anc_follower_empire_hunter"] = true,
	["wh_main_anc_follower_empire_ferryman"] = true,
	["wh_main_anc_follower_empire_entertainer"] = true,
	["wh_main_anc_follower_empire_coachman"] = true,
	["wh_main_anc_follower_empire_charcoal_burner"] = true,
	["wh_main_anc_follower_empire_camp_follower"] = true,
	["wh_main_anc_follower_empire_burgher"] = true,
	["wh_main_anc_follower_empire_bone_picker"] = true,
	["wh_main_anc_follower_empire_barber_surgeon"] = true,
	["wh_main_anc_follower_empire_apprentice_wizard"] = true,
	["wh_main_anc_follower_empire_agitator"] = true,
	["wh_main_anc_follower_bretonnia_squire"] = true,
	["wh_main_anc_follower_bretonnia_court_jester"] = true,
	["wh_main_anc_follower_all_student"] = true,
	["wh_main_anc_follower_all_men_zealot"] = true,
	["wh_main_anc_follower_all_men_valet"] = true,
	["wh_main_anc_follower_all_men_vagabond"] = true,
	["wh_main_anc_follower_all_men_tomb_robber"] = true,
	["wh_main_anc_follower_all_men_tollkeeper"] = true,
	["wh_main_anc_follower_all_men_thug"] = true,
	["wh_main_anc_follower_all_men_soldier"] = true,
	["wh_main_anc_follower_all_men_smuggler"] = true,
	["wh_main_anc_follower_all_men_servant"] = true,
	["wh_main_anc_follower_all_men_rogue"] = true,
	["wh_main_anc_follower_all_men_protagonist"] = true,
	["wh_main_anc_follower_all_men_outrider"] = true,
	["wh_main_anc_follower_all_men_outlaw"] = true,
	["wh_main_anc_follower_all_men_ogres_pit_fighter"] = true,
	["wh_main_anc_follower_all_men_militiaman"] = true,
	["wh_main_anc_follower_all_men_mercenary"] = true,
	["wh_main_anc_follower_all_men_kislevite_kossar"] = true,
	["wh_main_anc_follower_all_men_initiate"] = true,
	["wh_main_anc_follower_all_men_grave_robber"] = true,
	["wh_main_anc_follower_all_men_fisherman"] = true,
	["wh_main_anc_follower_all_men_bounty_hunter"] = true,
	["wh_main_anc_follower_all_men_bodyguard"] = true,
	["wh_main_anc_follower_all_men_boatman"] = true,
	["wh_main_anc_follower_all_men_bailiff"] = true,
	["wh_main_anc_follower_all_hedge_wizard"] = true,
	["wh_dlc08_anc_follower_whalers"] = true,
	["wh_dlc08_anc_follower_slave_worker"] = true,
	["wh_dlc08_anc_follower_skaeling_trader"] = true,
	["wh_dlc08_anc_follower_seer"] = true,
	["wh_dlc08_anc_follower_mountain_scout"] = true,
	["wh_dlc08_anc_follower_mammoth"] = true,
	["wh_dlc08_anc_follower_kurgan_slave_merchant"] = true,
	["wh_dlc08_anc_follower_dragonbone_raiders"] = true,
	["wh_dlc08_anc_follower_cathy_slave_dancers"] = true,
	["wh_dlc08_anc_follower_beserker"] = true,
	["wh_main_anc_follower_dwarfs_troll_slayer"] = true,
	["wh_main_anc_follower_dwarfs_treasure_hunter"] = true,
	["wh_main_anc_follower_dwarfs_teller_of_tales"] = true,
	["wh_main_anc_follower_dwarfs_stonemason"] = true,
	["wh_main_anc_follower_dwarfs_shipwright"] = true,
	["wh_main_anc_follower_dwarfs_sapper"] = true,
	["wh_main_anc_follower_dwarfs_runebearer"] = true,
	["wh_main_anc_follower_dwarfs_reckoner"] = true,
	["wh_main_anc_follower_dwarfs_prospector"] = true,
	["wh_main_anc_follower_dwarfs_powder_mixer"] = true,
	["wh_main_anc_follower_dwarfs_miner"] = true,
	["wh_main_anc_follower_dwarfs_jewelsmith"] = true,
	["wh_main_anc_follower_dwarfs_guildmaster"] = true,
	["wh_main_anc_follower_dwarfs_grudgekeeper"] = true,
	["wh_main_anc_follower_dwarfs_goldsmith"] = true,
	["wh_main_anc_follower_dwarfs_dwarfen_tattooist"] = true,
	["wh_main_anc_follower_dwarfs_dwarf_bride"] = true,
	["wh_main_anc_follower_dwarfs_daughter_of_valaya"] = true,
	["wh_main_anc_follower_dwarfs_cooper"] = true,
	["wh_main_anc_follower_dwarfs_choir_master"] = true,
	["wh_main_anc_follower_dwarfs_candle_maker"] = true,
	["wh_main_anc_follower_dwarfs_brewmaster"] = true,
	["wh_main_anc_follower_dwarfs_archivist"] = true,
	["wh_dlc03_anc_follower_beastmen_spawn_wrangler"] = true,
	["wh_dlc03_anc_follower_beastmen_pox_carrier"] = true,
	["wh_dlc03_anc_follower_beastmen_mannish_thrall"] = true,
	["wh_dlc03_anc_follower_beastmen_flying_spy"] = true,
	["wh_dlc03_anc_follower_beastmen_flayer"] = true,
	["wh_dlc03_anc_follower_beastmen_chieftains_pet"] = true,
	["wh_dlc03_anc_follower_beastmen_bray_shamans_familiar"] = true,
	["wh_dlc01_anc_follower_chaos_slave_master"] = true,
	["wh_dlc01_anc_follower_chaos_possessed"] = true,
	["wh_dlc01_anc_follower_chaos_oar_slave"] = true,
	["wh_dlc01_anc_follower_chaos_mutant"] = true,
	["wh_dlc01_anc_follower_chaos_kurgan_chieftain"] = true,
	["wh_dlc01_anc_follower_chaos_huscarl"] = true,
	["wh_dlc01_anc_follower_chaos_collector"] = true,
	["wh_dlc01_anc_follower_chaos_beast_tamer"] = true,
	["wh_dlc01_anc_follower_chaos_barbarian"] = true,
	["wh_main_anc_follower_greenskins_swindla"] = true,
	["wh_main_anc_follower_greenskins_snotling_scavengers"] = true,
	["wh_main_anc_follower_greenskins_serial_loota"] = true,
	["wh_main_anc_follower_greenskins_pit_boss"] = true,
	["wh_main_anc_follower_greenskins_idol_carva"] = true,
	["wh_main_anc_follower_greenskins_gobbo_ranta"] = true,
	["wh_main_anc_follower_greenskins_dung_collector"] = true,
	["wh_main_anc_follower_greenskins_dog_boy_scout"] = true,
	["wh_main_anc_follower_greenskins_bully"] = true,
	["wh_main_anc_follower_greenskins_bat-winged_loony"] = true,
	["wh_main_anc_follower_greenskins_backstabba"] = true,
	["wh_dlc05_anc_follower_young_stag"] = true,
	["wh_dlc05_anc_follower_vauls_anvil_smith"] = true,
	["wh_dlc05_anc_follower_royal_standard_bearer"] = true,
	["wh_dlc05_anc_follower_hunting_hound"] = true,
	["wh_dlc05_anc_follower_hawk_companion"] = true,
	["wh_dlc05_anc_follower_forest_spirit"] = true,
	["wh_dlc05_anc_follower_elder_scout"] = true,
	["wh_dlc05_anc_follower_dryad_spy"] = true,
	["wh2_main_anc_follower_sea_cucumber"] = true,
	["wh2_dlc11_anc_follower_cst_travelling_necromancer"] = true,
	["wh2_dlc11_anc_follower_cst_sartosa_navigator"] = true,
}

local original_effect_ancillary = effect.ancillary
effect.ancillary = function(ancillary, chance, context, ...)
	local should_just_return = false

	local success, result = pcall(
		function()
			local char = context:character()
			local faction = char:faction()
			local faction_key = faction:name()

			if ancies_lookup[ancillary] and table_contains(araby_factions, faction_key) then
				should_just_return = true
			end
		end
	)

	if not success then
		out("BIG FAT SCRIPT ERROR")
		out(tostring(result))
		out(tostring(debug.traceback()))
	end

	if should_just_return then return end

	return original_effect_ancillary(ancillary, chance, context, ...)
end
