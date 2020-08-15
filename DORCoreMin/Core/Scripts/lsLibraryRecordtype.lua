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
-- Called By: library_recordtype in xCoreUtilityLibraryWindowClasses.xml
--

oBtnColour = nil;
oBtnIcon = nil;
sName = nil;

function onInit()
	_,oBtnColour,_,oBtnIcon = ColourDomeManager.fpCreateColourDome(self,"icon",30,"ff000000",false,true,0,0,nil,"iBarNotes","ff000000");
	return;
end

function fpSetIcon(aIcons)
	local sStyle = OptionsManager.getOption("MICN");
	sName = window.name.getValue();
	DesktopManager2.fpRegisterLibraryRecordButton(self);
	for kKey,vValue in pairs(LibraryData.aRecords) do
		if LibraryData.getDisplayText(kKey) == sName then
			if MenubarIcons.aMenubarIcons[sStyle][kKey] then
				oBtnColour.setColor(MenubarIcons.aMenubarIcons[sStyle][kKey].colour);
				oBtnIcon.setBitmap(MenubarIcons.aMenubarIcons[sStyle][kKey].icon);
				oBtnIcon.setColor(MenubarIcons.aMenubarIcons[sStyle][kKey].iconcolour);
--[[
				oBtnIcon.setBitmap(MenubarIcons.aMenubarIcons[sStyle][kKey].icon); -- MEW
				DesktopManager2.fpSetMenubarIconLibrary(oBtnIcon,sBitmapString,sName,sOption) -- OLD
--]]
				break;
			end
		end
	end
	return;
end
