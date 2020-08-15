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
aMenubarIcons = {
	["Fantasy"] = {}
	};

function onInit()
	local sStyle = Interface.getString("sMenubarStyleFantasyString");
--	fpAddMenubarButton(sStyle,"Alignment Graph","iBarAlignment");
	fpAddMenubarButton(sStyle,"battle","iBarBattle","ffA65E5E");
	fpAddMenubarButton(sStyle,"Calendar","iBarCalendar");
	fpAddMenubarButton(sStyle,"charsheet","iBarCharacters","ff7ec0ee");
--	fpAddMenubarButton(sStyle,"Campaign Style","iBarCSG");
	fpAddMenubarButton(sStyle,"Colors","iBarColour");
	fpAddMenubarButton(sStyle,"Combat Tracker","iBarCT");
	fpAddMenubarButton(sStyle,"Dice Roll Foundry","iBarUDRF");
	fpAddMenubarButton(sStyle,"Effects","iBarEffects");
	fpAddMenubarButton(sStyle,"item","iBarItems","ffFFA500");
	fpAddMenubarButton(sStyle,"Library","iBarLibrary","ffff0000","ffffffff");
	fpAddMenubarButton(sStyle,"Lighting","iBarLighting");
--	fpAddMenubarButton(sStyle,"locations","iBarLocations","ffC1CA00");
	fpAddMenubarButton(sStyle,"image","iBarImages","ff174618","ffffffff");
	fpAddMenubarButton(sStyle,"Modifiers","iBarModifiers");
	fpAddMenubarButton(sStyle,"Modules","iBarModules");
	fpAddMenubarButton(sStyle,"note","iBarNotes","ff008080","ffffffff");
	fpAddMenubarButton(sStyle,"npc","iBarNPCs","ff5F1313","ffffffff");
	fpAddMenubarButton(sStyle,"Options","iBarOptions");
	fpAddMenubarButton(sStyle,"OLE","iBarOLE");
--	fpAddMenubarButton(sStyle,"organisations","iBarOrganisations","ff0040FF","ffffffff");
	fpAddMenubarButton(sStyle,"Portraits","iBarPortraits");
	fpAddMenubarButton(sStyle,"Party Sheet","iBarParty");
	fpAddMenubarButton(sStyle,"quest","iBarQuest","ffffffff");
--	fpAddMenubarButton(sStyle,"sounds","iBarSound","ff8329CA","ffffffff");
	fpAddMenubarButton(sStyle,"story","iBarStory","ff3F2E69","ffffffff");
	fpAddMenubarButton(sStyle,"table","iBarTables","ffDF7401");
	fpAddMenubarButton(sStyle,"Tokens","iBarToken","ff000000","ffffffff");
	fpAddMenubarButton(sStyle,"treasureparcel","iBarParcel","ff8C7853","ffffffff");
	fpAddMenubarButton(sStyle,"vehicle","iBarVehicle","ff6b8e23","ffffffff");
--	fpAddMenubarButton(sStyle,"Weather","iBarWeather");
	sStyle = Interface.getString("sMenubarStyleOrientalString");
	fpRegisterStyle(sStyle);
	fpSetMenubarButtonIcon(sStyle,"battle","iBarOBattle");
	fpSetMenubarButtonIcon(sStyle,"charsheet","iBarOCharacters");
	fpSetMenubarButtonIcon(sStyle,"Combat Tracker","iBarOCT");
	fpSetMenubarButtonIcon(sStyle,"item","iBarOItems");
	fpSetMenubarButtonIcon(sStyle,"npc","iBarONPCs");
	fpSetMenubarButtonIcon(sStyle,"story","iBarOStory");
	fpSetMenubarButtonIcon(sStyle,"vehicle","iBarOVehicle");
	sStyle = Interface.getString("sMenubarStyleSciFiString");
	fpRegisterStyle(sStyle);
	fpSetMenubarButtonIcon(sStyle,"battle","iBarSFBattle");
	fpSetMenubarButtonIcon(sStyle,"charsheet","iBarSFCharacters");
	fpSetMenubarButtonIcon(sStyle,"Combat Tracker","iBarSFCT");
	fpSetMenubarButtonIcon(sStyle,"item","iBarSFItems");
	fpSetMenubarButtonIcon(sStyle,"npc","iBarSFNPCs");
	fpSetMenubarButtonIcon(sStyle,"vehicle","iBarSFVehicle");
	sStyle = Interface.getString("sMenubarStyleWesternString");
	fpRegisterStyle(sStyle);
	fpSetMenubarButtonIcon(sStyle,"battle","iBarWBattle");
	fpSetMenubarButtonIcon(sStyle,"charsheet","iBarWCharacters");
	fpSetMenubarButtonIcon(sStyle,"Combat Tracker","iBarWCT");
	fpSetMenubarButtonIcon(sStyle,"item","iBarWItems");
	fpSetMenubarButtonIcon(sStyle,"npc","iBarWNPCs");
	fpSetMenubarButtonIcon(sStyle,"vehicle","iBarWVehicle");
	sStyle = Interface.getString("sMenubarStyleGumshoeString");
	fpRegisterStyle(sStyle);
	fpSetMenubarButtonIcon(sStyle,"battle","iBarGBattle");
	fpSetMenubarButtonIcon(sStyle,"charsheet","iBarGCharacters");
	fpSetMenubarButtonIcon(sStyle,"Combat Tracker","iBarGCT");
	fpSetMenubarButtonIcon(sStyle,"item","iBarGItems");
	fpSetMenubarButtonIcon(sStyle,"npc","iBarGNPCs");
	fpSetMenubarButtonIcon(sStyle,"vehicle","iBarGVehicle");
	return;
end

function fpRegisterStyle(sStyle)
	local sFirstStyle = Interface.getString("sMenubarStyleFantasyString");
	aMenubarIcons[sStyle] = {};
	for kKey,vValue in pairs(aMenubarIcons[sFirstStyle]) do
		aMenubarIcons[sStyle][kKey] = {};
		aMenubarIcons[sStyle][kKey].colour = aMenubarIcons[sFirstStyle][kKey].colour;
		aMenubarIcons[sStyle][kKey].icon = aMenubarIcons[sFirstStyle][kKey].icon;
		aMenubarIcons[sStyle][kKey].iconcolour = aMenubarIcons[sFirstStyle][kKey].iconcolour;
	end
	OptionsManager.addOptionValue("MICN",sStyle,sStyle,false);
end

function fpAddMenubarButton(sStyle,sButtonName,sIcon,sColour,sIconColour)
	if aMenubarIcons[sStyle] and
			aMenubarIcons[sStyle][sButtonName] == nil then
		aMenubarIcons[sStyle][sButtonName] = {};
		fpSetMenubarButtonColour(sStyle,sButtonName,sColour);
		fpSetMenubarButtonIcon(sStyle,sButtonName,sIcon);
		fpSetMenubarButtonIconColour(sStyle,sButtonName,sIconColour);
	end
	return;
end

function fpSetMenubarButtonColour(sStyle,sButtonName,sColour)
	if aMenubarIcons[sStyle] and
			aMenubarIcons[sStyle][sButtonName] then
		if sColour == nil then
			aMenubarIcons[sStyle][sButtonName].colour = "ffC0C0C0";
		else
			aMenubarIcons[sStyle][sButtonName].colour = sColour;
		end
	end
	return;
end

function fpSetMenubarButtonIcon(sStyle,sButtonName,sIcon)
	if aMenubarIcons[sStyle] and
			aMenubarIcons[sStyle][sButtonName] then
		aMenubarIcons[sStyle][sButtonName].icon = sIcon;
	end
	return;
end

function fpSetMenubarButtonIconColour(sStyle,sButtonName,sIconColour)
	if aMenubarIcons[sStyle] and
			aMenubarIcons[sStyle][sButtonName] then
		if sIconColour == nil then
			aMenubarIcons[sStyle][sButtonName].iconcolour = "ff000000";
		else
			aMenubarIcons[sStyle][sButtonName].iconcolour = sIconColour;
		end
	end
	return;
end
