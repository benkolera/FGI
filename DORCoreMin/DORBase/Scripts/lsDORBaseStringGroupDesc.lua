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
-- Called By: string_groupdesc in xDORBaseTemplates.xml
--
local aLinkedControls = {};

function onInit()
	if target then
		for sWord in string.gmatch(target[1],"(%w+)")do
			table.insert(aLinkedControls,sWord);
		end
	else
		table.insert(aLinkedControls,"list");
	end
end

function onClickDown(nButton,nXPos,nYPos)
	return true;
end

function onClickRelease(nButton,nXPos,nYPos)
	for kKey,vValue in ipairs(aLinkedControls) do
		window[vValue].setVisible(not window[vValue].isVisible());
	end
	if window.status then
		if window.list then
			if window.list.isVisible() then
				window.status.setIcon("button_collapse_w");
			else
				window.status.setIcon("button_expand_w");
			end
		elseif window.wlList then
			if window.wlList.isVisible() then
				window.status.setIcon("button_collapse_w");
			else
				window.status.setIcon("button_expand_w");
			end
		elseif window.wlLevel2 then
			if window.wlLevel2.isVisible() then
				window.status.setIcon("button_collapse_w");
			else
				window.status.setIcon("button_expand_w");
			end
		end
	end
	return true;
end
