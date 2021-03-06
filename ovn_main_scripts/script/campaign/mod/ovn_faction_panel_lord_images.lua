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

--- Ties the faction name to the image path in ui/portraits/frontend/
--- For example for wh2_main_nor_trollz the image is in ui/portraits/frontend/chief_ugma
local faction_key_to_img_name = {
	["wh2_main_arb_flaming_scimitar"] = "ovn_arb_flaming_scimitar",
	["wh2_main_emp_grudgebringers"] = "wh2_main_political_party_emp_grudgebringers",
	["wh2_main_emp_the_moot"] = "ovn_emp_the_moot",
	["wh2_dlc09_tmb_the_sentinels"] = "dreadking",
	["wh2_main_hef_citadel_of_dusk"] = "stormrider",
	["wh2_main_nor_trollz"] = "chief_ugma",
	["wh2_main_vmp_blood_dragons"] = "walach",
	["wh2_main_amz_amazons"] = "amazons",
	["wh2_main_ovn_chaos_dwarfs"] = "chorf",
	["wh2_main_nor_rotbloods"] = "wip",
}

--- If a faction has multiple LLs we can use the character subtype.
local leader_subtype_to_img_name = {
	["albion_morrigan"] = "albion_morrigan",
	["bl_elo_dural_durak"] = "bl_elo_dural_durak",
}

local function adjust_clan_panel()
	local lfn = cm:get_local_faction_name(true)
	local file_name = faction_key_to_img_name[lfn]
	if not file_name then
		local leader_subtype = cm:get_local_faction(true):faction_leader():character_subtype_key()
		file_name = leader_subtype_to_img_name[leader_subtype]
	end

	if not file_name then
		return
	end

	local lord_movie_panel = find_ui_component_str("root > clan > main > tab_children_parent > Summary > portrait_frame > lord_movie_panel")
	if not lord_movie_panel then return end
	lord_movie_panel:SetVisible(false)

	local portrait_frame = find_ui_component_str("root > clan > main > tab_children_parent > Summary > portrait_frame")
	if not portrait_frame then return end

	local frame = find_ui_component_str("root > clan > main > tab_children_parent > Summary > portrait_frame > frame")

	local lord_image = find_ui_component_str("root > clan > main > tab_children_parent > Summary > portrait_frame > pj_lord_image")
	if not lord_image then
		lord_image = UIComponent(portrait_frame:CreateComponent("pj_lord_image", "ui/templates/custom_image"))
		lord_image:SetImagePath("ui/portraits/frontend/"..tostring(file_name)..".png", 4)
		lord_image:Resize(frame:Width(), frame:Height())
	end

	local new_frame = find_uicomponent(lord_image, "pj_lord_image_frame")
	if not new_frame then
		new_frame = UIComponent(frame:CopyComponent("pj_lord_image_frame"))
		lord_image:Adopt(new_frame:Address())
		new_frame:MoveTo(frame:Position())
	end
end

core:remove_listener("ovn_on_clan_panel_opened_create_lord_images")
core:add_listener(
	"ovn_on_clan_panel_opened_create_lord_images",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "clan"
	end,
	function()
		adjust_clan_panel()
	end,
	true
)
