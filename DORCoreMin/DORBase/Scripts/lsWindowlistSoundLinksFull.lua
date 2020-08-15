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
-- Called By: tWindowlistSoundLinksFull in xDORBaseTemplates.xml
--

function onDrop(nXPos,nYPos,oDragData)
	local oThisNode = window.getDatabaseNode();
	if MiscFunctions.fpProceedWithLinkDrop(oThisNode,oDragData,{"url"},true,"soundlist",true) then
		local oNewNode = oThisNode.getChild("soundlist").createChild();
		oNewNode.createChild("lSoundLink","windowreference").setValue(oDragData.getShortcutData());
		oNewNode.createChild("name","string").setValue(oDragData.getDescription());
		local aCustomData = oDragData.getCustomData();
		if aCustomData then
			if aCustomData.delay then
				oThisNode.createChild("nDelay","number").setValue(aCustomData.delay);
			end
			if aCustomData.chainsound then
				oThisNode.createChild("sChainSoundNode","string").setValue(aCustomData.chainsound);
			end
		end
	end
	return true;
end

function onFilter(oWindow)
	return true;
end
