--- In this file are bugfixes that are achieved through scripts.

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

--- Belakors faction has a chaos tech tree that overflows if mods add new chaos techs.
--- So we hide techs that are below on the y axis of our first tech.
local function hide_belakors_tech_overflow()
	local tree_parent = find_ui_component_str("root > technology_panel > listview > list_clip > list_box > chs_mil > tree_parent")

	local a = find_ui_component_str(tree_parent, "slot_parent > elo_fimir_culture_1_belakor")
	local _, first_fimir_tech_y = a:Position()

	local slot_parent = find_uicomponent(tree_parent, "slot_parent")
	local childCount = slot_parent:ChildCount()
	for i=0, childCount-1  do
		local child = UIComponent(slot_parent:Find(i))
		local x,y = child:Position()
		if y < first_fimir_tech_y then
			child:SetVisible(false)
		end
	end

	local branch_parent = find_ui_component_str(tree_parent, "branch_parent")
	local childCount = branch_parent:ChildCount()
	for i=0, childCount-1  do
		local child = UIComponent(branch_parent:Find(i))
		local x,y = child:Position()
		if y < first_fimir_tech_y then
			child:SetVisible(false)
		end
	end
end

core:remove_listener("ovn_hide_belakors_tech_overflow")
core:add_listener(
	"ovn_hide_belakors_tech_overflow",
	"PanelOpenedCampaign",
	function(context)
		return context.string == "technology_panel" and cm:get_local_faction_name() == "wh2_main_wef_treeblood"
	end,
	function()
		hide_belakors_tech_overflow()
	end,
	true
)
