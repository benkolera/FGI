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
-- Called By: tSoundFieldShortcutLink in xDORBaseTemplates.xml
--

function onClickRelease(nButton,nXPos,nYPos)
	local oNode = getDatabaseNode().getParent();
	local _,sURLString = getValue();
	local nModuleNameStart = string.find(sURLString,"@");
	if nModuleNameStart ~= nil then
		sURLString = string.sub(sURLString,1,nModuleNameStart-1);
	end
	local nDelay = 0;
	if oNode.getChild("nDelay") then
		nDelay = oNode.getChild("nDelay").getValue();
	end
	local sChainSoundNode = "";
	if oNode.getChild("sChainSoundNode") then
		sChainSoundNode = oNode.getChild("sChainSoundNode").getValue();
	end
	SoundManager.fpCreateOOBSoundMsg("",sURLString,nDelay,sChainSoundNode);
	return false;
end

function onDragStart(nButton,nXPos,nYPos,oDragData)
	local oNode = getDatabaseNode();
	local oNodeParent = oNode.getParent();
	local sClassString,sURLString = getValue();
	local nModuleNameStart = string.find(sURLString,"@");
	local sNodeParentName = oNodeParent.getParent().getName();
	oDragData.setType("shortcut");
	oDragData.setIcon("iBtnSoundLink");
	if oNode ~= nil then
		oDragData.setDescription(oNode.getChild("..name").getValue());
		oDragData.setDatabaseNode(oNodeParent);
	end
	if nModuleNameStart ~= nil then
		sURLString = string.sub(sURLString,1,nModuleNameStart-1);
	end
	oDragData.setShortcutData(sClassString,sURLString);
	if sNodeParentName ~= "soundlist" and
			sNodeParentName ~= "SoundBoard" then
		if oNodeParent.getChild("fsNotes") then
			local aCustomData = {};
			aCustomData.notes = oNodeParent.getChild("fsNotes").getValue();
			oDragData.setCustomData(aCustomData);
		end
		if sNodeParentName == "ChatSound" then
			if oNodeParent.getChild("sChatString") then
				oDragData.setStringData(oNodeParent.getChild("sChatString").getValue());
			end
		elseif sNodeParentName == "AutoSound" then
			if oNodeParent.getChild("sType") then
				oDragData.setStringData(oNodeParent.getChild("sType").getValue());
			end
		end
	else
		local aCustomData = {};
		if oNodeParent.getChild("nDelay") then
			aCustomData.delay = oNodeParent.getChild("nDelay").getValue();
		end
		if oNodeParent.getChild("sChainSoundNode") then
			aCustomData.chainsound = oNodeParent.getChild("sChainSoundNode").getValue();
		end
		oDragData.setCustomData(aCustomData);
	end
	return true;
end
