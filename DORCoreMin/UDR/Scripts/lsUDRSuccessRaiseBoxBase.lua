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
-- Called By: wcSuccessRaiseBoxManager.gcBase in xUDRWindowClasses.xml
--

function onHover(bOnControl)
	if not bOnControl then
		TNBoxManager.fpUpdateControl();
	end
end

function onDrop(nXPos,nYPos,oDragData)
	local sDragType = oDragData.getType();
	if sDragType == "number" or
			sDragType == "targetnumber" then
		TNBoxManager.fpSetTN(oDragData.getNumberData(),oDragData.getDescription());
		return true;
	end
	return false;
end
