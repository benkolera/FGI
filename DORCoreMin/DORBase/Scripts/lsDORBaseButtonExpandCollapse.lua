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
-- The target value is a series of consecutive window lists or sub windows
--
--
-- Called By: button_collapse in xDORBaseTemplates.xml
--				button_expand in xDORBaseTemplates.xml
--
local bVisibility = nil;
local nLevel = 1;
local aTargetPath = {};

function onInit()
	for sWord in string.gmatch(target[1],"([%w_]+)") do
		table.insert(aTargetPath,sWord);
	end
	if expand then
		bVisibility = true;
	elseif collapse then
		bVisibility = false;
	end
	if togglelevel then
		nLevel = tonumber(togglelevel[1]) or 0;
		if nLevel < 1 then
			nLevel = 1;
		end
	end
end

function onButtonPress()
	applyTo(window[aTargetPath[1]],1);
end

function applyTo(vTarget,nIndex)
	if nIndex > nLevel then
		vTarget.setVisible(bVisibility);
	end
	nIndex = nIndex + 1;
	if nIndex > #aTargetPath then
		return;
	end
	local sTargetType = type(vTarget);
	if sTargetType == "windowlist" then
		for kKey,vValue in pairs(vTarget.getWindows()) do
			if vValue.status then
				if bVisibility then
					vValue.status.setIcon("button_collapse_w");
				else
					vValue.status.setIcon("button_expand_w");
				end
			end
			applyTo(vValue[aTargetPath[nIndex]], nIndex);
		end
	elseif sTargetType == "subwindow" then
		applyTo(vTarget.subwindow[aTargetPath[nIndex]], nIndex);
	end
end
