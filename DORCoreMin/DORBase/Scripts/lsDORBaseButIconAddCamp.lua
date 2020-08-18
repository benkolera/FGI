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
-- Called By: tButIconAddCamp in xDORBaseTemplates.xml
--

local sRecordType = "";
local oWindowNode;

function onInit()
	if class then
		fpSetRecordType(class[1]);
	end
end

function fpSetNode(aMappings)
	if aMappings[1] then
		oWindowNode = DB.findNode(aMappings[1]);
	end
end

function fpSetRecordType(sNewRecordType)
	sRecordType = sNewRecordType;
end

function onButtonPress()
	if User.isHost() then
		local oNode = oWindowNode.createChild();
		if oNode then
			local oWindow = Interface.openWindow(sRecordType,oNode.getNodeName());
			if oWindow and
					oWindow.name then
				oWindow.name.setFocus();
			end
		end
	elseif oWindowNode then
		Interface.requestNewClientWindow(sRecordType,oWindowNode.getNodeName());
	end
	window.wlListIconEdit.setValue(0);
end
