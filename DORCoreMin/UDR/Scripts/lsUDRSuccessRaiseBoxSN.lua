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
-- Called By: wcSuccessRaiseBoxManager.nSN in xUDRWindowClasses.xml
--

function onWheel(nNotches)
	if not hasFocus() then
		SuccessRaiseBoxManager.nValue = getValue()+nNotches;
		SuccessRaiseBoxManager.fpUpdateControl();
	end
	return true;
end

function onDrop(nXPos,nYPos,oDragData)
	return window.gcBase.onDrop(nXPos,nYPos,oDragData);
end

function onDragStart(nButton,nXPos,nYPos,oDragData)
	local nValue = getValue();
	oDragData.setType("number");
	oDragData.setNumberData(nValue);
	return true;
end
