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
-- Called By: tCampListBaseWindowlist in xDORBaseTemplates.xml
--

function onListChanged()
	window.onListChanged();
	fpUpdate();
end

function onMenuSelection(nSelection)
	if nSelection == 5 then
		window.fpAddEntry();
	end
end

function fpUpdate()
	local bEditMode = (window[getName() .. "IconEdit"].getValue() == 1);
	for kKey,oWindow in pairs(getWindows()) do
		local bOwner = false;
		if oWindow.getDatabaseNode() and
				oWindow.getDatabaseNode().isOwner() then
			bOwner = oWindow.getDatabaseNode().isOwner();
		end
		if oWindow.btIconDelete then
			if bOwner then
				oWindow.btIconDelete.setVisibility(bEditMode);
			else
				oWindow.btIconDelete.setVisibility(false);
			end
		elseif bOwner then
			oWindow.btIconDelete.setVisibility(bEditMode);
		else
			oWindow.btIconDelete.setVisibility(false);
		end
	end
end
