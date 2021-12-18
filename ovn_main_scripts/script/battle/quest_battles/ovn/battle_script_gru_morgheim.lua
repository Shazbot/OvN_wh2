-- OvN default quest battle script
load_script_libraries();

m = battle_manager:new(empire_battle:new());

-- local gc = generated_cutscene:new(true, true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	nil,      	-- intro cutscene function
	false                                      	-- debug mode
);

--ga_allied_reinforcements = gb:get_army(gb:get_player_alliance_num(), "allied_reinforcements");
--ga_allied_reinforcements:reinforce_on_message("battle_started", 10);
    
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); -- Reinforcements
ga_ai_01:reinforce_on_message("battle_started", 10);



--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)

   -- gc:add_element(nil,"ovn_qb_gru_zandri","gc_slow_army_pan_front_left_to_front_right_close_medium_01", 16000, false, false, false);



-------GENERALS SPEECH--------


-------ARMY SETUP-------

-------OBJECTIVES-------

-------HINTS-------


-------ORDERS-------

-- Queued attack orders to we can make sure it get's given as early as possible.





