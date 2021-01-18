
local ovn_info = {
	["1624764695"] = "ovn_arb_flaming_scimitar", --"ovn_arb_scimitar"
	["1721501317"] = "ovn_arb_scythan",--"ovn_arb_scythans"
	["365146035"] = "ovn_arb_scythan",--"ovn_vor_arb_scythans"
	["1242187756"] = "ovn_arb_flaming_scimitar",--"ovn_vor_arb_scimitar"
	["642513778"] = "wh2_main_political_party_emp_grudgebringers",
	["572093174"] = "wh2_main_political_party_vor_emp_grudgebringers",
	["40619453"] = "ovn_emp_the_moot",
	--["250682859"] = "ovn_arb_araby", THESE HAVE THERE OWN VIDEOS NOW
	--["2119533354"] = "ovn_vor_arb_araby", THESE HAVE THERE OWN VIDEOS NOW
	["848881665"] = "dreadking", -- vortex
	["1041928997"] = "dreadking", -- me
--	["1409023687"] = "wip", -- other fimir faction fimelend
	["440104156"] = "stormrider", --me
	["2140784771"] = "stormrider", --vor
	["937413525"] = "morrigan", --me
	["794782611"] = "morrigan", --vor
	["32930744"] = "chief_ugma",
	["2140783503"] = "walach",
	["549163715"] = "walach",
--	["209967969"] = "fimir", -- Formerly Treeblood
	["2052227504"] = "amazons", -- vortex
	["1407394331"] = "amazons", -- ME
	["882030"] = "chorf", -- ME
	["1397230572"] = "wip", -- ME -- Rotblood Tribe
	["1668499673"] = "wip", -- ME -- Rotblood Tribe


};

local vanilla_ovn_faction_to_hide_ids = {
	["1397230572"] = "wip", -- ME -- Rotblood Tribe
	["209967969"] = "fimir", -- Formerly Treeblood
	["1409023687"] = "wip", -- other fimir faction fimelend
	["2140783503"] = "walach",
}

--- Hide the amazons if the Expanded Roster Amazons submod isn't present.
local function hide_vanilla_ovn_factions()
	if effect.get_localised_string("land_units_onscreen_name_roy_amz_inf_eagle_warriors") == "" then
		local list_box = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "top_docker", "lord_select_list", "list", "list_clip", "list_box")
		for i=0, list_box:ChildCount()-1 do
			local comp = UIComponent(list_box:Find(i))
			local startpos_id = comp:GetProperty("lord_key");
			if vanilla_ovn_faction_to_hide_ids[startpos_id] then
				comp:SetVisible(false)

				-- also hide the divider that is the next component after the amazons
				local comp_next = UIComponent(list_box:Find(i+1))
				-- comp_next:SetVisible(false)
			end
		end
	end
end

--- Hide the amazons if the Expanded Roster Amazons submod isn't present.
local function hide_amazons()
	if effect.get_localised_string("land_units_onscreen_name_roy_amz_inf_eagle_warriors") == "" then
		local list_box = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "top_docker", "lord_select_list", "list", "list_clip", "list_box")
		for i=0, list_box:ChildCount()-1 do
			local comp = UIComponent(list_box:Find(i))
			if comp:Id() == "Penthesilea" then
				comp:SetVisible(false)

				-- also hide the divider that is the next component after the amazons
				local comp_next = UIComponent(list_box:Find(i+1))
				comp_next:SetVisible(false)
				break
			end
		end
	end
end

function ovn_movie_replacer()
	local portrait_frame = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame");
	local custom_image = portrait_frame:Find("ovn_custom_image");
	if custom_image then
		return UIComponent(custom_image);
	end
	portrait_frame:CreateComponent("ovn_custom_image", "ui/campaign ui/region_info_pip");
	return UIComponent(portrait_frame:Find("ovn_custom_image"));
end


function ovn_startpos_id_check(start_pos_id)
	if not not ovn_info[start_pos_id] then
		return ovn_info[start_pos_id]
	end
end

function ovn_frontend()

core:add_listener(
	"ovn_frontend_CampaignTransitionListener",
	"FrontendScreenTransition",
	function(context) return context.string == "sp_grand_campaign" end,
	function(context)
		local faction_list = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "top_docker", "lord_select_list", "list", "list_clip", "list_box");
		if not faction_list then
			return
		end

		hide_amazons()
		hide_vanilla_ovn_factions()

		for i = 0, faction_list:ChildCount() - 1 do
			local child = UIComponent(faction_list:Find(i));

			core:add_listener(
				"ovn_frontend_lord_button_clicked",
				"ComponentLClickUp",
				function(context)
					return child == UIComponent(context.component);
				end,
				function(context)
					local startpos_id = child:GetProperty("lord_key");

					local custom_image = ovn_movie_replacer();
					local is_custom_ll = ovn_startpos_id_check(startpos_id)



					if not is_custom_ll then
						custom_image:SetOpacity(0);
					else
						custom_image:SetImagePath("ui/portraits/frontend/"..is_custom_ll..".png", 0);
						custom_image:SetOpacity(255);
					end

					local movie_frame = find_uicomponent(core:get_ui_root(), "sp_grand_campaign", "dockers", "centre_docker", "portrait_frame", "movie_frame");

					local x, y = movie_frame:Position();

					custom_image:MoveTo(x, y);

					custom_image:PropagatePriority(movie_frame:Priority());

					custom_image:SetCanResizeHeight(true)
					custom_image:SetCanResizeWidth(true)
					custom_image:Resize(464, 624)
					custom_image:SetCanResizeHeight(false)
					custom_image:SetCanResizeWidth(false)

				end,
				true
			);
		end
	end,
	true
);
end

core:add_ui_created_callback(
	function(context)
		ovn_frontend()
	end
)
