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
-- Called By: xUDRFFiles.xml
--

--[[ Remove
local DBVERSION = 1;
local EXTENSION = "UDR";
--]]
aExport = {};
sBtnUDRF = "btnUDRFCoreRPG";
sBtnUDRFDown = "btnUDRFDownCoreRPG";

aSubRecords = {
	["udr"] = {
		aDataMap = {"MJB_UDR"},
		sRecordDisplayClass = "wcUDRF",
		aGMListButtons = {"tButLicenseLibrary"},
		aPlayerListButtons = {"tButLicenseLibrary"}
	}
}

function onInit() -- Need to change/fix
--[[
	local oNode = DB.findNode("MJB_Extensions");
	if User.isHost() then
		if oNode == nil or
				DB.getChild(oNode,EXTENSION) == nil then
			DB.setValue(DB.createNode("MJB_Extensions"),EXTENSION,"number",DBVERSION);
			DB.createNode("MJB_UDR");
		elseif DB.getValue(oNode,EXTENSION) < DBVERSION then
			fpDoPatch2();
		end
		if ExportManager.registerExportNode then
			ExportManager.registerExportNode({name="MJB_UDR",class="wcUDRF",label=Interface.getString("sDiceRollFoundryStr")});
		end
	end
--]]
	fpSetRulesetGraphics();
	for kKey,vValue in pairs(aSubRecords) do
		LibManager.fpSetRecordTypeInfo(kKey,vValue);
	end
	if User.isHost() then
		DesktopManager.registerStackShortcut2(sBtnUDRF,sBtnUDRFDown,"sSidebarTooltipUDRFStr","wcLibMasterList","MJB_UDR");
	end
end

function fpSetRulesetGraphics()
--	local sRuleset = Interface.getRuleset();
	return;
end

-- Patch Functions --

function fpDoPatch2()
	DB.backup();
	return;
end

-- End Of Patch Functions --

function fpMain()
	return;
end

