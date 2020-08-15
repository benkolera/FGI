--
-- Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
-- Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
-- Copyright to other material within this file may be held by other Individuals and/or Entities.
-- Nothing in or from this LUA file in printed, electronic and/or any other form may be used, copied,
--	transmitted or otherwise manipulated in ANY way without the explicit written consent of
--	PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
-- Please see the accompanying License for full details.
-- All rights reserved.
--
-- Called By: xCoreFiles.xml
--
function onInit()
--[[ Maybe For Child Rulesets
	OptionsManager.registerOption2("ANPC",false,"option_header_combat","option_label_ANPC","option_entry_cycler",
			{labels = "option_val_on",values = "on",baselabel = "option_val_off",baseval = "off",default = "on"});
	<string name="option_label_ANPC">Chat: Anonymise NPC attacks</string>
	OptionsManager.registerOption2("HRFC",false,"option_header_combat","option_label_HRFC","option_entry_cycler",
			{labels = "option_val_fumbleandcrit|option_val_fumble|option_val_crit",values = "both|fumble|criticalhit",baselabel = "option_val_off",baseval = "",default = ""});
	<string name="option_label_HRFC">Attack: Fumble/Crit Tables</string>
	<string name="option_val_crit">Crit</string>
	<string name="option_val_fumble">Fumble</string>
	<string name="option_val_fumbleandcrit">Fumble and Crit</string>
	OptionsManager.registerOption2("HRST", false, "option_header_houserule", "option_label_HRST", "option_entry_cycler", 
			{ labels = "option_val_all|option_val_friendly", values = "all|on", baselabel = "option_val_off", baseval = "off", default = "on" });
	<string name="option_label_HRST">CT: Auto stabilization rolls</string>
	OptionsManager.registerOption2("HRCC", false, "option_header_houserule", "option_label_HRCC", "option_entry_cycler", 
			{ labels = "option_val_on|option_val_npc", values = "on|npc", baselabel = "option_val_off", baseval = "off", default = "on" });
	<string name="option_label_HRCC">Attack: Critical confirm</string>
--]]
	OptionsManager.registerOption2("DDCL",false,"option_header_game","option_label_DDCL","option_entry_cycler", 
			{labels = "Off",values = "option_val_off",baselabel = "sOptionValueDORCoreString",baseval = "iBaseRulesetDecal",default = "iBaseRulesetDecal" });
	OptionsManager.registerOption2("RMMT",true,"option_header_client","option_label_RMMT","option_entry_cycler",
			{labels = "option_val_on|option_val_multi",values = "on|multi",baselabel = "option_val_off",baseval = "off",default = "multi"});
	OptionsManager.registerOption2("SHRR",false,"option_header_game","option_label_SHRR","option_entry_cycler",
			{labels = "option_val_on|option_val_pc",values = "on|pc",baselabel = "option_val_off",baseval = "off",default = "on"});
	OptionsManager.registerOption2("PSMN",false,"option_header_game","option_label_PSMN","option_entry_cycler",
			{labels = "option_val_off",values = "off",baselabel = "option_val_on",baseval = "on",default = "on" });
	OptionsManager.registerOption2("INIT",false,"option_header_combat","option_label_INIT","option_entry_cycler",
			{labels = "option_val_on|option_val_off",values = "on|off",baselabel = "option_val_group",baseval = "group",default = "on"});
	OptionsManager.registerOption2("WNDC",false,"option_header_combat","option_label_WNDC","option_entry_cycler",
			{labels = "option_val_simple",values = "off",baselabel = "option_val_detailed",baseval = "detailed",default = "detailed"});
	OptionsManager.registerOption2("ANPC", false, "option_header_combat", "option_label_ANPC", "option_entry_cycler", 
			{ labels = "option_val_on", values = "on", baselabel = "option_val_off", baseval = "off", default = "off" });
	OptionsManager.registerOption2("BARC",false,"option_header_combat","option_label_BARC","option_entry_cycler", 
			{labels = "option_val_tiered",values = "tiered",baselabel = "option_val_standard",baseval = "",default = "tiered"});
	OptionsManager.registerOption2("TPCE",false,"option_header_token","option_label_TPCE","option_entry_cycler",
			{labels = "option_val_tooltip|option_val_off|option_val_iconshover|option_val_mark|option_val_markhover",values = "tooltip|off|hover|mark|markhover",baselabel = "option_val_icons",baseval = "on",default = "on"});
	OptionsManager.registerOption2("TPCH",false,"option_header_token","option_label_TPCH","option_entry_cycler",
			{labels = "option_val_tooltip|option_val_bar|option_val_barhover|option_val_off|option_val_dothover",values = "tooltip|bar|barhover|dot|dothover",baselabel = "option_val_dot",baseval = "dot",default = "dot"});
	OptionsManager.registerOption2("TNPCE",false,"option_header_token","option_label_TNPCE","option_entry_cycler",
			{labels = "option_val_tooltip|option_val_off|option_val_icons|option_val_mark|option_val_markhover",values = "tooltip|off|on|mark|markhover",baselabel = "option_val_iconshover",baseval = "hover",default = "hover"});
	OptionsManager.registerOption2("TNPCH",false,"option_header_token","option_label_TNPCH","option_entry_cycler",
			{labels = "option_val_tooltip|option_val_off|option_val_barhover|option_val_dot|option_val_dothover",values = "tooltip|bar|barhover|dot|dothover",baselabel = "option_val_bar",baseval = "bar",default = "bar"});
	OptionsManager.registerOption2("HRNH",false,"option_header_combat","option_label_HRNH","option_entry_cycler",
			{labels = "option_val_max|option_val_standard",values = "max|off",baselabel = "option_val_random",baseval = "random",default = "random"});
	OptionsManager.registerOption2("SHPC", false, "option_header_combat", "option_label_SHPC", "option_entry_cycler", 
			{ labels = "option_val_detailed|option_val_status", values = "detailed|status", baselabel = "option_val_off", baseval = "off", default = "status" });
	OptionsManager.registerOption2("SHNPC", false, "option_header_combat", "option_label_SHNPC", "option_entry_cycler", 
			{ labels = "option_val_detailed|option_val_status", values = "detailed|status", baselabel = "option_val_off", baseval = "off", default = "status" });
	OptionsManager.registerOption2("ESAV", false, "option_header_combat", "option_label_ESAV", "option_entry_cycler", 
			{ labels = "option_val_on|option_val_npc", values = "on|npc", baselabel = "option_val_off", baseval = "off", default = "npc" });
	OptionsManager.registerOption2("HRIR", false, "option_header_combat", "option_label_HRIR", "option_entry_cycler", 
			{ labels = "option_val_off", values = "off", baselabel = "option_val_on", baseval = "on", default = "on" });
	OptionsManager.registerOption("MICN",false,Interface.getString("option_header_game"),Interface.getString("option_label_MICN"),"option_entry_cycler", 
			{labels = "",values = "",baselabel = Interface.getString("sMenubarStyleFantasyString"),baseval = Interface.getString("sMenubarStyleFantasyString"),default = Interface.getString("sMenubarStyleFantasyString") });
	OptionsManager.registerCallback("MICN",DesktopManager2.fpSetMenubarIcons);
end
