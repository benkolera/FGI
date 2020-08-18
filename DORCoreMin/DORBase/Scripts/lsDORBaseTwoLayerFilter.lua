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
-- Called By: tTwoLayerFilter in xDORBaseTemplates.xml
--

local aTargetPath = {};

function onInit()
	for sWord in string.gmatch(target[1],"([^,]+)") do
		table.insert(aTargetPath,sWord);
	end
end

function applyTo(oTarget,nIndex)
	if not oTarget then
		return;
	end
	nIndex = nIndex+1;
	if not oTarget.isVisible() then
		oTarget.setVisible(true);
	end
	if nIndex > #aTargetPath then
		oTarget.applyFilter();
		return;
	end
	for kKey,vValue in pairs(oTarget.getWindows()) do
		applyTo(vValue[aTargetPath[nIndex]],nIndex);
	end
end

function onValueChanged(oTarget)
	if super.onValueChanged then
		super.onValueChanged();
	end
	applyTo(window[aTargetPath[1]],1);
end
