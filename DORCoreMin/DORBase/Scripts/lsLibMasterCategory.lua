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
-- Called By: wcLibMasterCategory in xDORBaseWindowClasses.xml
--

function handleDrop(oDragData)
	if oDragData.isType("shortcut") then
		local sCategory = hsCategory.getValue();
		if sCategory ~= "*" then
			local kKey,vValue = oDragData.getShortcutData();
			if kKey == "url" then
				vValue = oDragData.getDatabaseNode().getNodeName();
			end
			DB.setCategory(vValue,sCategory);
		end
		return true;
	end
end

function handleSelect()
	windowlist.window.fpHandleCategorySelect(hsCategory.getValue());
end

function fpDelete()
	windowlist.window.fpHandleCategoryDelete(hsCategory.getValue());
end

function fpHandleCategoryNameChange(sName,sNewName)
	windowlist.window.fpHandleCategoryNameChange(sName,sNewName);
end
