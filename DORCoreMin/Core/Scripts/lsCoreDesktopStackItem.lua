--
-- Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
-- Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
-- Copyright to other material within this file may be held by other Individuals and/or Entities.
-- Nothing in or from this LUA file in printed,electronic and/or any other form may be used,copied,
--	transmitted or otherwise manipulated in ANY way without the explicit written consent of
--	PEREGRINE I.T. Pty Ltd or,where applicable,any and all other Copyright holders.
-- Please see the accompanying License for full details.
-- All rights reserved.
--
-- Called By: desktop_stackitem in xCoreTemplates.xml
--
aButtons = {};
nSize = 0;
oBtnColour = nil;
oBtnIcon = nil;

local sLocalClassName = nil;
local sLocalRecordName = nil;

function onInit()
	local sStyle = OptionsManager.getOption("MICN");
	local sName = getName();
--[[
Set defaults???
--]]
	local sColour = MenubarIcons.aMenubarIcons[sStyle][sName].colour;
	local sButIcon = MenubarIcons.aMenubarIcons[sStyle][sName].icon;
	local sIconColour = MenubarIcons.aMenubarIcons[sStyle][sName].iconcolour;
	nSize = tonumber(size[1]);
	DesktopManager2.fpRegisterMenubarButton(self);
	_,oBtnColour,_,oBtnIcon = ColourDomeManager.fpCreateColourDome(self,sName,nSize,sColour,true,true,0,0,nil,sButIcon,sIconColour);
--	oBtnIcon.setBitmap(MenubarIcons.aMenubarIcons[sStyle][kKey].icon);  -- NEW
--	DesktopManager2.fpSetMenubarIconSidebar(oBtnIcon,sBitmapString,sName,sStyle); -- OLD
	return;
end

function setValue(sClassName,sRecordName)
	sLocalClassName = sClassName;
	sLocalRecordName = sRecordName;
	return;
end

function setIcons()
	return;
end

function onClickDown(nButton,nXPos,nYPos)
	local nMidPointX,nMidPointY = nXPos-nSize/2,nYPos-nSize/2;
	for nIteration,vValue in ipairs(aButtons) do
		if (nMidPointX-vValue.nXPos)*(nMidPointX-vValue.nXPos)+(nMidPointY-vValue.nYPos)*(nMidPointY-vValue.nYPos) <= vValue.nSize*vValue.nSize then
			Interface.toggleWindow(sLocalClassName,sLocalRecordName);
		end
	end
end
