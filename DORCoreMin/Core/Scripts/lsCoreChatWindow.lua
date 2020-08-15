--
-- Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
-- Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
-- Copyright to other material within this file may be held by other Individuals and/or Entities.
-- Nothing in or from this LUA file in printed,electronic and/or any other form may be used,copied,
--	transmitted or otherwise manipulated in ANY way without the explicit written consent of
--	PEREGRINE I.T. Pty Ltd or,where applicable,any and all other Copyright holders.
-- Please see the accompanying License for full details.
-- All rights reserved.
--
-- Called By: xCoreTemplates.xml

function onInit()
	deliverLaunchMessage();
end

function deliverLaunchMessage()
	local aLaunchMsg = ChatManager.retrieveLaunchMessages();
	for kKey,vValue in ipairs(aLaunchMsg) do
		Comm.addChatMessage(vValue);
	end
end

function onDiceLanded(oDragData)
	return ActionsManager.onDiceLanded(oDragData);
end

function onDragStart(nButton,nXPos,nYPos,oDragData)
	return ActionsManager.onChatDragStart(oDragData);
end

function onDrop(nXPos,nYPos,oDragData)
	local bReturn = ActionsManager.actionDrop(oDragData,nil);
	if bReturn then
		local aDice = oDragData.getDieList();
		if aDice and
				#aDice > 0 and
				not OptionsManager.isOption("MANUALROLL","on") then
			return;
		end
		return true;
	end
	if oDragData.getType() == "language" then
		LanguageManager.setCurrentLanguage(oDragData.getStringData());
		return true;
	end
end

function onDiceTotal(aMessage)
	return DieManager.fpOnDiceTotal(aMessage);
end
