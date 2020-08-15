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
-- Called By: tRadioButCtrl in xDORBaseTemplates.xml
--

local aGroupList = {};

function onInit()
	setValue(0);
	if firstingroup then
		setValue(1);
	end
	if group then
		aGroupList = StringManager.split(group[1],"|");
	end
end

function onButtonPress()
	for kKey,sRadioButName in pairs(aGroupList) do
		window[sRadioButName].setValue(0);
	end
	setValue(1);
end
