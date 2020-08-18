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
-- Called By: reference_manual in xDORBaseWindowClasses.xml
--

function onInit()
	local oNode = getDatabaseNode();
	local sRecord = oNode.getNodeName();
	if string.sub(sRecord,1,13) == "refmanualdata" then
		local oWin = Interface.openWindow("reference_manual","reference.refmanualindex@" .. oNode.getModule());
		oWin.activateLink("reference_manualtextwide",sRecord);
		Interface.onWindowOpened = fpOnWindowOpened;
	end
	return;
end

function fpOnWindowOpened(oWin)
	oWin.close();
	return;
end
