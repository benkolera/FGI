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

sTabFrame = "frmTabsDORCore";

local aMenubarButtons = {};
local aLibraryRecordButtons = {};

function onInit()
	local sRuleset = Interface.getRuleset();
	Interface.onDesktopInit = fpOnDesktopInit;
	DesktopManager.setDockIconSizeAndSpacing(100,100,0,0);
	DesktopManager.setStackIconSizeAndSpacing(50,50,0,0);
	DesktopManager.setStackOffset(8,2,8,0)
	DesktopManager.setUpperDockOffset(8,5,8,0);
	DesktopManager.setLowerDockOffset(8,5,8,2);
	DesktopManager.setMinDockScaling(1);
	DesktopManager.setDefaultSidebarState("gm","charsheet,note,image,table,story,quest,Locations,Organisations,npc,battle,item,vehicle,treasureparcel,sounds");
	DesktopManager.setDefaultSidebarState("play","charsheet,note,image,story,Locations,npc,item,sounds");
	if not User.isLocal() then
		DesktopManager.registerStackShortcut2(nil,nil,"sSidebarTooltipPortraitStr","portraitselection",nil);
		DesktopManager.registerStackShortcut2(nil,nil,"sSidebarTooltipModulesStr","moduleselection",nil);
	end
	sTabFrame = "frmTabs" .. sRuleset;
	return;
end

function fpOnDesktopInit()
	fpSetMenubarIcons();
	return;
end

function fpRegisterLibraryRecordButton(oButton)
	aLibraryRecordButtons[oButton.sName] = oButton;
	return;
end

function fpRegisterMenubarButton(oButton)
	aMenubarButtons[oButton.getName()] = oButton;
	return;
end

function fpSetMenubarIcons()
	local sStyle = OptionsManager.getOption("MICN");
	for kKey,vValue in pairs(aMenubarButtons) do
		if MenubarIcons.aMenubarIcons[sStyle][kKey] and
				vValue.isEnabled then
			vValue.oBtnIcon.setBitmap(MenubarIcons.aMenubarIcons[sStyle][kKey].icon);
		end
	end
	for kKey,vValue in pairs(aLibraryRecordButtons) do
		if MenubarIcons.aMenubarIcons[sStyle][kKey] and
				vValue.isEnabledthen then
			vValue.oBtnIcon.setBitmap(MenubarIcons.aMenubarIcons[sStyle][kKey].icon);
		end
	end
end
