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
-- Called By: button_library_sidebar in xCoreTemplates.xml
--
local sRecordType = nil;

function setRecordType(v)
	sRecordType = v;
	setTooltipText(LibraryData.getDisplayText(sRecordType));
end

function onClickDown(nButton,nXPos,nYPos)
	local nMidPointX,nMidPointY = nXPos-nSize/2,nYPos-nSize/2;
	for nIteration,vValue in ipairs(aButtons) do
		if (nMidPointX-vValue.nXPos)*(nMidPointX-vValue.nXPos)+(nMidPointY-vValue.nYPos)*(nMidPointY-vValue.nYPos) <= vValue.nSize*vValue.nSize then
			DesktopManager.toggleIndex(sRecordType);
		end
	end
end
