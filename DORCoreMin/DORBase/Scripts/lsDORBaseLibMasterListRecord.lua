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
-- Called By: wcLibMasterListSmall in xDORBaseWindowClasses.xml
--
local bShared = false;
local bIntact = true;
local oNode = nil;
local sRecordType = "";

function onInit()
	oNode = getDatabaseNode();
	if not oNode then
		return;
	end
	if gIconModified and
			User.isHost() and
			oNode.getModule() and
			not oNode.isReadOnly() then
		oNode.onIntegrityChange = fpOnIntegrityChange;
		fpOnIntegrityChange(oNode);
	end
	oNode.onObserverUpdate = fpOnObserverUpdate;
	fpOnObserverUpdate(oNode);
	if sCategory then
		oNode.onCategoryChange = fpOnCategoryChange;
		fpOnCategoryChange(oNode);
	end
end

function onMenuSelection(nSelection,nSubSelection)
	if nSelection == 7 then
		fpUnshare();
	elseif nSelection == 8 then
		getDatabaseNode().revert();
	elseif nSelection == 6 and
			nSubSelection == 7 then
		if windowlist.window.fpGetRecordType() == "locations" then
			LocationsManager.fpDeleteLocationRecord(oNode);
		elseif windowlist.window.fpGetRecordType() == "organisations" then
			OrganisationsManager.fpDeleteOrganisationRecord(oNode);
		end
	elseif windowlist.window.fpGetRecordType() == "locations" then
		if nSelection == 3 then
			if nSubSelection == 3 then
				LocationsRefIntegrity.fpCopyWithoutLinks();
			elseif nSubSelection == 5 then
				DB.createChild(oNode,"bCtrlFlg2","number").setValue(1);
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.Building");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.Cosmos");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.Location");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.Plane");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.Portal");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.System");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.Town");
				LocationsRefIntegrity.fpResetCtrlFlg("MJB_Locations.World");
			end
		end
	end
end

function fpBuildMenu()
	resetMenuItems();
	if windowlist.window.fpGetRecordType() == "locations" then
		registerMenuItem(Interface.getString("sLocationMenuCopyStr"),"restorewindow",3);
		registerMenuItem(Interface.getString("sLocationMenuCopyWithoutLinksStr"),LocationsManager.sBtnCopyNoLinks,3,3);
		registerMenuItem(Interface.getString("sLocationMenuCopyWithLinksStr"),LocationsManager.sBtnCopyLinks,3,5);
		registerMenuItem(Interface.getString("sLocationMenuDeleteStr"),"delete",6);
		registerMenuItem(Interface.getString("deleteconfirm"),"delete",6,7);
	end
	if windowlist.window.fpGetRecordType() == "organisations" then
		registerMenuItem(Interface.getString("sOrganisationsMenuDeleteStr"),"delete",6);
		registerMenuItem(Interface.getString("deleteconfirm"),"delete",6,7);
	end
	if not bIntact then
		registerMenuItem(Interface.getString("menu_revert"),"shuffle",8);
	end
	if bShared then
		registerMenuItem(Interface.getString("menu_unshare"),"unshare",7);
	end
end

function fpDelete()
	if windowlist.window.fpGetRecordType() == "locations" then
		LocationsManager.fpDeleteLocationRecord(getDatabaseNode());
	elseif windowlist.window.fpGetRecordType() == "organisations" then
		OrganisationsManager.fpDeleteOrganisationRecord(oNode);
	else
		getDatabaseNode().delete();
	end
end

function fpOnCategoryChange()
	local sLocalCategory = oNode.getCategory();
	if type(sLocalCategory) ~= "string" then
		sLocalCategory = sLocalCategory.name;
	end
	sCategory.setValue(sLocalCategory);
	sCategory.setTooltipText(sLocalCategory);
end

function fpOnIntegrityChange()
	bIntact = oNode.isIntact();
	gIconModified.setVisible(bIntact);
	if bIntact then
		gIconModified.setIcon("record_intact");
	else
		gIconModified.setIcon("record_dirty");
	end
	fpBuildMenu();
end

function fpOnObserverUpdate()
	if User.isHost() then
		if oNode.isPublic() then
			bcAccess.setValue(3);
			bShared = true;
		else
			local sOwner = oNode.getOwner();
			local aHolderNames = {};
			for kKey,sHolder in pairs(oNode.getHolders()) do
				if sOwner then
					if sOwner ~= sHolder then
						table.insert(aHolderNames,sHolder);
					end
				else
					table.insert(aHolderNames,sHolder);
				end
			end
			bShared = (#aHolderNames > 0);
			if bShared then
				bcAccess.setValue(2);
				bcAccess.setStateTooltipText(2,Interface.getString("tooltip_shared") .. " " .. table.concat(aHolderNames,", "));
			else
				bcAccess.setValue(0);
			end
		end
		fpBuildMenu();
	elseif oNode.isPublic() then
		bcAccess.setValue(3);
	else
		bcAccess.setValue(0);
	end
end

function fpSetRecordType(sNewRecordType)
	if sRecordType == sNewRecordType then
		return;
	end
	sRecordType = sNewRecordType;
	lcShortcutLinkCtrl.setValue(LibManager.fpGetRecordDisplayClass(sRecordType,oNode),oNode.getPath());
	name.setEmptyText(LibManager.fpGetEmptyNameText(sRecordType));
	return;
end

function fpUnshare()
	if not User.isHost() then
		return;
	end
	oNode = getDatabaseNode();
	if oNode.isPublic() then
		oNode.setPublic(false);
	else
		oNode.removeAllHolders(true);
	end
	windowlist.applyFilter();
end
