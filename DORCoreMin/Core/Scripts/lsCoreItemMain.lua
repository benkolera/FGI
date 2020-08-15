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
-- Called By: item_main in xCoreRecordItem.xml
--

function onInit()
	update();
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
	update();
end

function updateControl(sControl,bReadOnly,bID)
	if not self[sControl] then
		return false;
	end
	if not bID then
		if self[sControl].update then
			return self[sControl].update(bReadOnly,true);
		elseif self[sControl].fpUpdate then
			return self[sControl].fpUpdate(bReadOnly,true);
		end
	end
	if self[sControl].update then
		return self[sControl].update(bReadOnly);
	elseif self[sControl].fpUpdate then
		return self[sControl].fpUpdate(bReadOnly);
	end
	return;
end

function update()
	local oNodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(oNodeRecord);
	local bID,bOptionID = LibraryData.getIDState("item",oNodeRecord);
	local bSection1 = false;
	if bOptionID and
			User.isHost() then
		if updateControl("nonid_name",bReadOnly,true) then
			bSection1 = true;
		end;
	else
		updateControl("nonid_name", false);
	end
	if bOptionID and
			(User.isHost() or
			not bID) then
		if updateControl("nonid_notes",bReadOnly,true) then
			bSection1 = true;
		end;
	else
		updateControl("nonid_notes",false);
	end
	local bSection2 = false;
	if updateControl("type",bReadOnly,bID) then
		bSection2 = true;
	end
	if updateControl("subtype",bReadOnly,bID) then
		bSection2 = true;
	end
	local bSection3 = false;
	if updateControl("cost",bReadOnly,bID) then
		bSection3 = true;
	end
	if updateControl("weight",bReadOnly,bID) then
		bSection3 = true;
	end
	local bSection4 = false;
	if updateControl("notes",bReadOnly,bID) then
		bSection4 = true;
	end
	updateControl("fsGMNotes",bReadOnly,true);
	divider.setVisible(bSection1 and bSection2);
	divider3.setVisible((bSection1 or bSection2) and bSection3);
	divider2.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
end
