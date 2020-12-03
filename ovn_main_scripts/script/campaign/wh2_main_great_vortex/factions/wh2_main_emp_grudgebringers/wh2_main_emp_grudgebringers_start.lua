local cam_start_x = 477;
local cam_start_y = 235;
local cam_start_d = 10;
local cam_start_b = 0;
local cam_start_h = 10;
---------------------------------------------------------------
--	First-Tick callbacks
---------------------------------------------------------------

cm:add_first_tick_callback_sp_new(
	function() 
        -- put faction-specific calls that should only gets triggered in a new singleplayer game here
		core:progress_on_loading_screen_dismissed(
			function()
				cm:set_camera_position(cam_start_x, cam_start_y, cam_start_d, cam_start_b, cam_start_h)	
			end
		)
	end
)


cm:add_first_tick_callback_mp_new(
	function() 
		-- put faction-specific calls that should only gets triggered in a new multiplayer game here
		core:progress_on_loading_screen_dismissed(
			function()			
				cm:set_camera_position(cam_start_x, cam_start_y, cam_start_d, cam_start_b, cam_start_h)
			end
		)
	end
)