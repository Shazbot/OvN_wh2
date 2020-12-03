local nomadVariants = {};

function Araby_Champion_Listeners()
	out("OVN | Roy Araby Listeners ");

	------------------------------------------------------------------
	--//Champion
	------------------------------------------------------------------
	----//assign art set on CharacterCreated
	core:add_listener(
		"Roy_Araby_Champion_Created",
		"CharacterCreated",
		function(context)		
			--out("OVN | Roy_Araby_Champion_Created 0");
			return context:character():character_subtype("roy_arb_champion");
		end,
		function(context)
			--out("OVN | Roy_Araby_Champion_Created ");
			local character = context:character();
			cm:add_unit_model_overrides(cm:char_lookup_str(character), "wh2_main_art_set_roy_arb_champion");	
		end,
		true
	);	
	
	----//assign art set on CharacterSkillPointAllocated if one of the 3 skills was chosen
	core:add_listener(
		"Roy_Araby_Champion_Model_Override",
		"CharacterSkillPointAllocated",
		function(context)	
			--out("OVN | Roy_Araby_Champion_Model_Override 0");
			return context:character():character_subtype("roy_arb_champion");
		end,
		function(context)
			--out("OVN | Roy_Araby_Champion_Model_Override ");
			local character = context:character();
			
			if context:skill_point_spent_on() == "roy_skill_champion_arb_guard" then
				cm:add_unit_model_overrides(cm:char_lookup_str(character), "wh2_main_art_set_roy_arb_champion_guard");	
				--out("OVN | Roy_Araby_Champion_Model_Override guard ");				
			elseif context:skill_point_spent_on() == "roy_skill_champion_arb_warrior" then
				cm:add_unit_model_overrides(cm:char_lookup_str(character), "wh2_main_art_set_roy_arb_champion_warrior");
				--out("OVN | Roy_Araby_Champion_Model_Override warrior ");			
			elseif context:skill_point_spent_on() == "roy_skill_champion_arb_sergeant" then
				cm:add_unit_model_overrides(cm:char_lookup_str(character), "wh2_main_art_set_roy_arb_champion_sergeant");	
				--out("OVN | Roy_Araby_Champion_Model_Override sergeant ");				
			end;	
		end,
		true
	);	
	
	------------------------------------------------------------------
	--//Nomad
	------------------------------------------------------------------
	----//assign random (out of 3) art set on CharacterCreated
	core:add_listener(
		"Roy_Araby_Nomad_Created",
		"CharacterCreated",
		function(context)		
			--out("OVN | Roy_Araby_Nomad_Created 0");
			return context:character():character_subtype("roy_arb_nomad");
		end,
		function(context)
			--out("OVN | Roy_Araby_Nomad_Created ");
			local character = context:character();
			local cqi = character:cqi();
			local chance = cm:random_number(3, 1)
			local art_set = ("wh2_main_art_set_roy_arb_nomad_0")
			cm:add_unit_model_overrides("character_cqi:"..cqi, art_set..chance);
			nomadVariants[cqi] = chance
		end,
		true
	);	
	
	----//assign art set on CharacterSkillPointAllocated if one of the 2 skills was chosen
	core:add_listener(
		"Roy_Araby_Nomad_Model_Override",
		"CharacterSkillPointAllocated",
		function(context)	
			--out("OVN | Roy_Araby_Nomad_Model_Override 0");
			return context:character():character_subtype("roy_arb_nomad");
		end,
		function(context)
			out("OVN | Roy_Araby_Nomad_Model_Override ");
			local character = context:character();
			local cqi = character:cqi();
			
			if context:skill_point_spent_on() == "roy_skill_nomad_mount_assassin" then
				cm:add_unit_model_overrides("character_cqi:" .. cqi, "wh2_main_art_set_roy_arb_nomad_assassin_0" .. nomadVariants[cqi])
				--out("OVN | Roy_Araby_Nomad_Model_Override assassin ");							
			end;

			if context:skill_point_spent_on() == "roy_skill_nomad_jezzail" then
				cm:add_unit_model_overrides("character_cqi:" .. cqi, "wh2_main_art_set_roy_arb_nomad_jezzail_0" .. nomadVariants[cqi])
				--out("OVN | Roy_Araby_Nomad_Model_Override jezzail ");							
			end;
		end,
		true
	);
end;

cm:add_first_tick_callback(function() Araby_Champion_Listeners() end)



-- SAVING/LOADING ------------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("nomadVariants", nomadVariants, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			nomadVariants = cm:load_named_value("nomadVariants", nomadVariants, context);		
		end
	end
);