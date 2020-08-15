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
-- Called By: tWindowlistLinks in xDORBaseTemplates.xml
--

function onListChanged()
	fpUpdate();
end

function fpUpdate()
	local sEdit = getName() .. "IconEdit";
	if window[sEdit] then
		local bEdit = (window[sEdit].getValue() == 1);
		for nIteration,oWindow in ipairs(getWindows()) do
			oWindow.btIconDelete.setVisible(bEdit);
		end
	end
end

function onFilter(oWindow)
	if User.isHost() or
			oWindow.bGMVisible.getValue() == 0 or oWindow.bGMVisible.getValue() == false then
		return true;
	else
		return false;
	end
end

function onClickDown(nButton,nXPos,nYPos)
	if not isReadOnly() then
		return true;
	end
end
