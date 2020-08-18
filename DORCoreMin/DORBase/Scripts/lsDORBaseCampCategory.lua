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
-- Called By: tCampCategory in xDORBaseTemplates.xml
--

function onHover(bHover)
	setUnderline(bHover,-1);
end

function onClickDown(nButton,nXPos,nYPos)
	return true;
end

function onClickRelease(nButton,nXPos,nYPos)
	local sValue = getValue();
	if sValue ~= "" then
		window.windowlist.window.fpHandleCategorySelect(sValue);
	end
	return true;
end
