local hlf_glib_defeated_trait = {
	["ovn_hlf_glibfoot"] = {trait = "hlf_glibfoot_defeated_trait", special_subtype = nil, trait_prefix = nil}
}


local function glibfoot_get_enemy_legendary_lords_in_last_battle(character)
	local pb = cm:model():pending_battle()
	local LL_attackers = {}
	local LL_defenders = {}
	local was_attacker = false

	local num_attackers = cm:pending_battle_cache_num_attackers()
	local num_defenders = cm:pending_battle_cache_num_defenders()

	if pb:night_battle() == true or pb:ambush_battle() == true then
		num_attackers = 1
		num_defenders = 1
	end
	
	for i = 1, num_attackers do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
		local char_obj = cm:model():character_for_command_queue_index(this_char_cqi)
		
		if this_char_cqi == character:cqi() then
			was_attacker = true
			break
		end
		
		if char_obj:is_null_interface() == false then
			local char_subtype = char_obj:character_subtype_key()
			
			if hlf_glib_defeated_trait[char_subtype] ~= nil then
				table.insert(LL_attackers, char_subtype)
			end
		end
	end
	
	if was_attacker == false then
		return LL_attackers
	end
	
	for i = 1, num_defenders do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
		local char_obj = cm:model():character_for_command_queue_index(this_char_cqi)
		
		if char_obj:is_null_interface() == false then
			local char_subtype = char_obj:character_subtype_key()
			
			if hlf_glib_defeated_trait[char_subtype] ~= nil then
				table.insert(LL_defenders, char_subtype)
			end
		end
	end
	return LL_defenders
end

local function add_defeated_trait_listeners()
core:add_listener(
	"hlf_glib_defeated_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		local character = context:character()
		if cm:char_is_general_with_army(character) and character:won_battle() then
			local enemy_LL = glibfoot_get_enemy_legendary_lords_in_last_battle(character)
			
			for i = 1, #enemy_LL do
				local LL_details = hlf_glib_defeated_trait[enemy_LL[i]]
				
				if LL_details ~= nil then
					local trait = LL_details.trait
					local special_subtype = LL_details.special_subtype
					local trait_prefix = LL_details.trait_prefix
					
					if special_subtype ~= nil then
						if character:character_subtype(special_subtype) then
							trait = trait..trait_prefix
						end
					end					
							
					Give_Trait(character, trait)
				end
			end
		end
	end,
	true
)
end

cm:add_first_tick_callback(function() add_defeated_trait_listeners() end)