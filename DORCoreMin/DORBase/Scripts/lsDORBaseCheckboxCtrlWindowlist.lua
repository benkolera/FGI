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
-- Called By: tCheckboxCtrlWindowlist in xDORBaseTemplates.xml
--

function onButtonPress()
	local sValue = window.sWindowlistSelectedItem.getValue();
	window.windowlist.window[target[1]].setValue("");
	if getValue() == 1 or getValue() == true then
		for kKey,vValue in pairs(window.windowlist.getWindows()) do
			if vValue.sWindowlistSelectedItem.getValue() ~= sValue then
				vValue.CheckboxCtrlWindowlistSelected.setValue(0);
			end
		end
		window.windowlist.window[target[1]].setValue(sValue);
	end
	return true;
end
