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
-- Called By: <Entity>.<sub-Entity> in <File.xml>
--

function fpAddNodeToChildList(oParentNode,oDragData)
	local oNewNode = oParentNode.createChild();
	oNewNode.createChild("lShortcutLink","windowreference").setValue(oDragData.getShortcutData());
	oNewNode.createChild("name","string").setValue(oDragData.getDescription());
end

function fpAddNodeToParentList(oParentNode,oChildNode,sListName,sClassName)
	local oNewNode = oParentNode.createChild(sListName).createChild();
	oNewNode.createChild("lShortcutLink","windowreference").setValue(sClassName,oChildNode.getNodeName());
	oNewNode.createChild("name","string").setValue(oChildNode.getChild("name").getValue());
	return oNewNode;
end

function fpDecToBase(nAmount,nBase)
	local bNegative = false;
	local nIndex;
	local sValues = "0123456789abcdefghijklmnopqrstuvwxyz";
	local sValue = "";
	if nAmount == nil or
			nBase == nil then
		return nil;
	elseif nBase < 2 then
		return nil;
	elseif nAmount == 0 then
		return "0";
	else
		if nAmount < 0 then
			nAmount = math.abs(nAmount);
			bNegative = false;
		end
		while nAmount > 0 do
			nIndex = math.mod(nAmount,nBase)+1;
			nAmount = math.floor(nAmount/nBase);
			sValue = string.sub(sValues,nIndex,nIndex) .. sValue;
		end
	end
	if bNegative then
		sValue = "-" .. sValue;
	end
	return sValue;
end

function fpDeleteListNode(oThisNode,sRecordType)
	local _,sTargetNodeName = oThisNode.getChild("lShortcutLink").getValue();
	local oTargetNode = DB.findNode(sTargetNodeName);
	local oGrandparentNode = oThisNode.getParent().getParent();
	if oGrandparentNode.getParent().getName() == "MJB_Organisations" then
		fpDeleteNodeFromList(oTargetNode,"orglist",oGrandparentNode);
	else
		fpSetNodeParentDetails(oTargetNode,false,sRecordType);
	end
	oThisNode.delete();
	return;
end

function fpDeleteNodeFromList(oListNode,sTargetList,oTargetNode)
	local bFound = false;
	for kKey,oNode in pairs(DB.getChildren(oListNode,sTargetList)) do
		if oNode.getChild("lShortcutLink") then
			local _,sTargetNodeName = oNode.getChild("lShortcutLink").getValue();
			if DB.findNode(sTargetNodeName) == oTargetNode then
				oNode.delete()
				bFound = true;
				break;
			end
		end
	end
	return bFound;
end

function fpDeleteNodeFromParentList(sParent,oTargetNode,sListName)
	for kKey,oNode in pairs(DB.getChildren(sParent)) do
		fpDeleteNodeFromList(oNode,sListName,oTargetNode);
	end
end

function fpDeleteParentLink(sRootNodeName,sPartParentNodeName,oChildNode)
	local sParentLink = "l" .. sPartParentNodeName .. "Link";
	for kKey,oNode in pairs(DB.getChildren(sRootNodeName)) do
		if oNode.getChild(sParentLink) then
			local _,sTargetNodeName = oNode.getChild(sParentLink).getValue();
			if DB.findNode(sTargetNodeName) == oChildNode then
				oNode.getChild("s" .. sPartParentNodeName .. "Name").setValue("");
				oNode.getChild(sParentLink).setValue();
				break;
			end
		end
	end
end

function fpDisplaySciNotationValue(nValue,nExp)
	return string.format("%g",nValue*10^nExp);
end

function fpExistInList(sStringToFind,sTargetList)
	local bFound = false;
	for kKey,vValue in pairs(sTargetList.getWindows()) do
		if vValue.sWindowlistSelectedItem.getValue() ==  sStringToFind then
			bFound = true;
			break;
		end
	end
	return bFound;
end

function fpExistInNodeList(oListNode,sTargetList,oTargetNode)
	local bFound = false;
	local sTargetNodeName;
	for kKey,oNode in pairs(oListNode.getChild(sTargetList).getChildren()) do
		if oNode.getChild("lShortcutLink") then
			_,sTargetNodeName = oNode.getChild("lShortcutLink").getValue();
		elseif oNode.getChild("lSoundLink") then
			_,sTargetNodeName = oNode.getChild("lSoundLink").getValue();
		elseif oNode.getChild("lOLELink") then
			_,sTargetNodeName = oNode.getChild("lOLELink").getValue();
		end
		if DB.findNode(sTargetNodeName) == oTargetNode then
			bFound = true;
			break;
		end
	end
	return bFound;
end

function fpFindNodeType(aNodeTypes,sNodeType)
	local bFound = false;
	for kKey,vValue in pairs(aNodeTypes) do
		if vValue == sNodeType then
			bFound = true;
			break;
		end
	end
	return bFound;
end

function fpGetDayOfYear(nMonth,nDay)
	local sCalendarName = DB.getValue("calendar.data.name",Interface.getString("sNoneSetStr"))
	local nDaysInYear = 0;
	local aPeriodNodes = {};
	if sCalendarName == Interface.getString("sNoneSetStr") then
		return 0;
	else
		for sPeriod,oNode in pairs(DB.getChildren("calendar.data.periods")) do
			aPeriodNodes[tonumber(string.match(sPeriod,"%d"))] = oNode;
		end
		for nPeriod,oNode in ipairs(aPeriodNodes) do
			if nPeriod < nMonth then
				if oNode.getChild("days") ~= nil then
					nDaysInYear = nDaysInYear+oNode.getChild("days").getValue();
				end
			else
				break;
			end
		end
	end
	return(nDaysInYear+nDay);
end

function fpGetIDFromName(sName)
	if sName ~= nil then
		local oCharsNode = DB.findNode("charsheet");
		for kKey,vValue in pairs(oCharsNode) do
			if vValue.getChild("name").getValue() == sName then
				return kKey;
			end
		end
	end
	return nil;
end

function fpGetNameFromID(sID)
	if sID ~= nil then
		local oCharNode = DB.getChild("charsheet",sID);
		if oCharNode then
			return oCharNode.getChild("name").getValue();
		end
	end
	return nil;
end

function fpGetReadOnlyState(oNode)
	local bLocked = (DB.getValue(oNode,"bLocked",0) ~= 0);
	local bReadOnly = true;
	if oNode.isOwner() and
			not oNode.isReadOnly() and
			not bLocked then
		bReadOnly = false;
	end
	return bReadOnly;
end

function fpHandleRulerLinking(oThisNode,oDragData,aAllowsRecordTypes,sPartRuler)
	local sThisDraggedWindowClass,_ = oDragData.getShortcutData();
	local sNodeList = "npclist";
	if fpProceedWithLinkDrop(oThisNode,oDragData,aAllowsRecordTypes) then
		local oDraggedNode = oDragData.getDatabaseNode();
		if sThisDraggedWindowClass == "battle" then
			sNodeList = "encounterlist";
		end
		if sThisDraggedWindowClass == "wcOrganisations" then
			sNodeList = "orglist";
			local sChildList = "locationlist";
			local sChildName = oThisNode.getParent().getName();
			if sChildName == "Town" then
				sChildList = "townlist";
			elseif sChildName == "Building" then
				sChildList = "buildinglist";
			end
			MiscFunctions.fpAddNodeToParentList(oDraggedNode,oThisNode,sChildList,"wc" .. oThisNode.getParent().getName());
			local _,sTargetNode = oDraggedNode.getChild("lHQLink").getValue();
			if sTargetNode ~= "" and
					DB.findNode(sTargetNode) == oThisNode then
				fpSetNodeParentDetails(oDraggedNode,false,"HQ");
			end
		end
		MiscFunctions.fpAddNodeToParentList(oThisNode,oDraggedNode,sNodeList,sThisDraggedWindowClass);
		if oThisNode.getChild("l" .. sPartRuler .. "Link") then
			local _,sTargetNodeName = oThisNode.getChild("l" .. sPartRuler .. "Link").getValue();
			if sTargetNodeName ~= "" then
				if DB.findNode(sTargetNodeName) == oDraggedNode then
					MiscFunctions.fpSetNodeParentDetails(oThisNode,false,sPartRuler);
				end
			end
		end
	end
	return true;
end

function fpIsExtensionLoaded(sExtensionName)
	for nIndex,sName in pairs(Extension.getExtensions()) do
		if string.find(sName,sExtensionName) then
			return true;
		end
	end
	return false
end

function fpIsInArray(aArray,xValue)
	for i=1,#aArray do
		if aArray[i] == xValue then
			return true;
		end
	end
	return false;
end

function fpIsThemeExtensionLoaded()
	for nIndex,sName in pairs(Extension.getExtensions()) do
		if string.find(sName,"Theme") then
			return true;
		end
	end
	return false;
end

function fpMsgbox(sMessage,sTitle,nType,nIcon,sFunction1,sFunction2,sFunction3)
	local oMsgbox = Interface.findWindow("wcMsgbox","");
	if oMsgbox then
		oMsgbox.close();
	end
	oMsgbox = Interface.openWindow("wcMsgbox","",true);
	oMsgbox.bringToFront();
	oMsgbox.title.setValue(sTitle);
	oMsgbox.sMessage.setValue(sMessage);
	if nIcon == 1 then
		oMsgbox.gcIcon.setIcon("iMsgboxError");
	elseif nIcon == 2 then
		oMsgbox.gcIcon.setIcon("iMsgboxHelp");
	elseif nIcon == 3 then
		oMsgbox.gcIcon.setIcon("iMsgboxInfo");
	elseif nIcon == 4 then
		oMsgbox.gcIcon.setIcon("iMsgboxWarning");
	else
		oMsgbox.gcIcon.setVisible(false);
	end
	if nType == 1 then
		oMsgbox.btButMsgboxOK.setVisible(true);
		oMsgbox.btButMsgboxCancel.setVisible(true);
		oMsgbox.btButMsgboxOK.setAnchor("right","btButMsgboxCancel","left","","-100") ;
		if sFunction1 then
			oMsgbox.btButMsgboxOK.fpRegisterCallback(sFunction1)
		end
		if sFunction2 then
			oMsgbox.btButMsgboxCancel.fpRegisterCallback(sFunction2)
		end
	elseif nType == 2 then
		oMsgbox.btButMsgboxAbort.setVisible(true);
		oMsgbox.btButMsgboxRetry.setVisible(true);
		oMsgbox.btButMsgboxIgnore.setVisible(true);
		if sFunction1 then
			oMsgbox.btButMsgboxAbort.fpRegisterCallback(sFunction1)
		end
		if sFunction2 then
			oMsgbox.btButMsgboxRetry.fpRegisterCallback(sFunction2)
		end
		if sFunction3 then
			oMsgbox.btButMsgboxIgnore.fpRegisterCallback(sFunction3)
		end
	elseif nType == 3 then
		oMsgbox.btButMsgboxYes.setVisible(true);
		oMsgbox.btButMsgboxNo.setVisible(true);
		oMsgbox.btButMsgboxCancel.setVisible(true);
		if sFunction1 then
			oMsgbox.btButMsgboxYes.fpRegisterCallback(sFunction1)
		end
		if sFunction2 then
			oMsgbox.btButMsgboxNo.fpRegisterCallback(sFunction2)
		end
		if sFunction3 then
			oMsgbox.btButMsgboxCancel.fpRegisterCallback(sFunction3)
		end
	elseif nType == 4 then
		oMsgbox.btButMsgboxYes.setVisible(true);
		oMsgbox.btButMsgboxNo.setVisible(true);
		oMsgbox.btButMsgboxNo.setAnchor("left","btButMsgboxYes","right","","100") ;
		if sFunction1 then
			oMsgbox.btButMsgboxYes.fpRegisterCallback(sFunction1)
		end
		if sFunction2 then
			oMsgbox.btButMsgboxNo.fpRegisterCallback(sFunction2)
		end
	elseif nType == 5 then
		oMsgbox.btButMsgboxRetry.setVisible(true);
		oMsgbox.btButMsgboxCancel.setVisible(true);
		oMsgbox.btButMsgboxRetry.setAnchor("right","btButMsgboxCancel","left","","-100") ;
		if sFunction1 then
			oMsgbox.btButMsgboxRetry.fpRegisterCallback(sFunction1)
		end
		if sFunction2 then
			oMsgbox.btButMsgboxCancel.fpRegisterCallback(sFunction2)
		end
	else
		oMsgbox.btButMsgboxOK.setVisible(true);
		if sFunction1 then
			oMsgbox.btButMsgboxOK.fpRegisterCallback(sFunction1)
		end
	end
end

function fpNameChangeChildNameChange(sChildList,oThisNode)
	local sChildParentNameFieldName = "sPortalParentName";
	local sChildParentLinkFieldName = "lPortalParentLink";
	if sChildList == "buildinglist" then
		sChildParentLinkFieldName = "lBuildingParentLink";
		sChildParentNameFieldName = "sBuildingParentName";
	elseif sChildList == "townlist" then
		sChildParentLinkFieldName = "lTownParentLink";
		sChildParentNameFieldName = "sTownParentName";
	elseif sChildList == "locationlist" then
		sChildParentLinkFieldName = "lLocationParentLink";
		sChildParentNameFieldName = "sLocationParentName";
	elseif sChildList == "worldlist" then
		sChildParentLinkFieldName = "lWorldParentLink";
		sChildParentNameFieldName = "sWorldParentName";
	elseif sChildList == "systemlist" then
		sChildParentLinkFieldName = "lSystemParentLink";
		sChildParentNameFieldName = "sSystemParentName";
	elseif sChildList == "planelist" then
		sChildParentLinkFieldName = "lPlaneParentLink";
		sChildParentNameFieldName = "sPlaneParentName";
	elseif sChildList == "orglist" then
		sChildParentLinkFieldName = "lOrganisationsParentLink";
		sChildParentNameFieldName = "sOrganisationsParentName";
	end
	for kKey,oNode in pairs(oThisNode.getChild(sChildList).getChildren()) do
		local _,sTargetNodeName = oNode.getChild("lShortcutLink").getValue();
		local oChildNode = DB.findNode(sTargetNodeName);
		local _,sTargetChildNodeName = oChildNode.getChild(sChildParentLinkFieldName).getValue();
		if DB.findNode(sTargetChildNodeName) == oThisNode then
			oChildNode.createChild(sChildParentNameFieldName,"string").setValue(oThisNode.getChild("name").getValue());
		end
	end
end

function fpNameChangeParentNameChange(sParentRootNode,sListName,oThisNode)
	local sName = "Unknown"
	if oThisNode.getChild("name") then
		sName = oThisNode.getChild("name").getValue();
	end
	for kKey1,oNode1 in pairs(DB.getChildren(sParentRootNode)) do
		if oNode1.getChild(sListName) then
			for kKey2,oNode2 in pairs(oNode1.getChild(sListName).getChildren()) do
				if oNode2.getChild("lShortcutLink") then
					local _,sTargetNodeName = oNode2.getChild("lShortcutLink").getValue();
					if DB.findNode(sTargetNodeName) == oThisNode then
						oNode2.createChild("name","string").setValue(sName);
					end
				end
			end
		end
	end
end

function fpProceedWithLinkDrop(oThisNode,oDragData,aNodeTypes,bSingle,sList,bSame)
	local bProceed = false;
	if oDragData.isType("shortcut") and
			not fpGetReadOnlyState(oThisNode) and
			fpFindNodeType(aNodeTypes,oDragData.getShortcutData()) then
		local oDraggedNode = oDragData.getDatabaseNode();
		bProceed = true;
		if bSingle and
				fpExistInNodeList(oThisNode,sList,oDraggedNode) then
			bProceed = false;
		end
		if bSame and
				oThisNode == oDraggedNode then
			bProceed = false;
		end
	end
	return bProceed;
end

function fpRemoveChildListLink(oNode,sChildName)
	for kKey,vValue in pairs(oNode.getChild(string.lower(sChildName) .. "list").getChildren()) do
		local _,sTargetNodeName = vValue.getChild("lShortcutLink").getValue();
		fpSetNodeParentDetails(DB.findNode(sTargetNodeName),false,sChildName .. "Parent");
	end
end

function fpRemoveSiblingListLink(oNode,sList1,sList2)
	for kKey1,vValue1 in pairs(DB.getChildren(oNode,sList1)) do
		local _,sTargetNodeName1 = vValue1.getChild("lShortcutLink").getValue();
		for kKey2,vValue2 in pairs(DB.findNode(sTargetNodeName1).getChild(sList2).getChildren()) do
			local _,sTargetNodeName2 = vValue2.getChild("lShortcutLink").getValue();
			if DB.findNode(sTargetNodeName2) == oNode then
				vValue2.delete();
			end
		end
	end
end

function fpSciNumAdd(nNum1,nExp1,nNum2,nExp2)
	local nExp = math.max(nExp1,nExp2);
	local nNum = nNum1*10^(nExp1-nExp)+nNum2*10^(nExp2-nExp);
	return fpSimplifySciNotation(nNum,nExp);
end

function fpSciNumDiv(nNum1,nExp1,nNum2,nExp2)
	local nExp = nExp1-nExp2;
	local nNum = nNum1/nNum2;
	return fpSimplifySciNotation(nNum,nExp);
end

function fpSciNumMult(nNum1,nExp1,nNum2,nExp2)
	local nExp = nExp1+nExp2;
	local nNum = nNum1*nNum2;
	return fpSimplifySciNotation(nNum,nExp);
end

function fpSciNumSub(nNum1,nExp1,nNum2,nExp2)
	local nExp = math.max(nExp1,nExp2);
	local nNum = nNum1*10^(nExp1-nExp)-nNum2*10^(nExp2-nExp);
	return fpSimplifySciNotation(nNum,nExp);
end

function fpSetNodeParentDetails(oChildNode,bAddDetails,sRecordType,sName,sClass,sNodeName)
	if bAddDetails then
		oChildNode.createChild("l" .. sRecordType .. "Link","windowreference").setValue(sClass,sNodeName);
		oChildNode.createChild("s" .. sRecordType .. "Name","string").setValue(sName);
	else
		oChildNode.createChild("l" .. sRecordType .. "Link","windowreference").setValue();
		oChildNode.createChild("s" .. sRecordType .. "Name","string").setValue("");
	end
end

function fpSimplifySciNotation(nValue,nExp)
	local nLocalValue = nValue;
	local nLocalExp = nExp;
	if nLocalValue ~= 0 then
		if nLocalValue < 0 then
			while nLocalValue > -1 do
				nLocalValue = nLocalValue*10;
				nLocalExp = nLocalExp-1;
			end
			while nLocalValue < -9.99999999 do
				nLocalValue = nLocalValue/10;
				nLocalExp = nLocalExp+1;
			end
		else
			while nLocalValue < 1 do
				nLocalValue = nLocalValue*10;
				nLocalExp = nLocalExp-1;
			end
			while nLocalValue > 9.99999999 do
				nLocalValue = nLocalValue/10;
				nLocalExp = nLocalExp+1;
			end
		end
	end
	return nLocalValue,nLocalExp;
end

function fpSleep(nSeconds)
	local nTime = os.time() + nSeconds;
	repeat until os.time() > nTime;
end

function fpUpdateCtrl(oWindow,sCtrl,bReadOnly,bForceHide)
	if oWindow and
			oWindow[sCtrl] then
		return oWindow[sCtrl].fpUpdate(bReadOnly,bForceHide);
	end
	return false;
end
