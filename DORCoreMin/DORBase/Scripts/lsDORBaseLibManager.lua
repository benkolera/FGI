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
-- Called By: xDORBaseFiles.xml
--
-- RECORD TYPE FORMAT
-- 	["recordtype"] = { 
-- 		aDisplayIcon = <table of 2 strings>, 
--		fToggleIndex = <function>
-- 	},
--
-- SUB-RECORD TYPE FORMAT
-- 	["recordtype"] = { 
--		aDataMap = <table of strings>, 
--		aGMListButtons = <table of templates>,
--		aPlayerListButtons = <table of templates>,
--		bNoCategories = <bool>,
--		bAllowClientEdit = <bool>,
--		bRefIntegrity = <bool>,
--		bTabbed = <bool>,
--		fRecordDisplayClass = <function>,
--		sRecordDisplayClass = <string>,
--		sListDisplayClass = <string>
-- 	},
--
-- 		*FIELDS ADDED FROM STRING DATA*
-- 		sDisplayText = Interface.getString(library_recordtype_label_ .. sRecordType)
-- 		sEmptyNameText = Interface.getString(library_recordtype_empty_ .. sRecordType)
--
-- RECORD TYPE LEGEND
--		aDisplayIcon = Required. Table of strings. Provides icon resource names for sidebar/library buttons for this record type (normal and pressed icon resources)
--		fToggleIndex = Optional. Function. This function will be called when the sidebar/library button is pressed for this record type. If not defined, a default master list window will be toggled.
--
-- SUB-RECORD TYPE LEGEND
--		aDataMap = Required. Table of strings. defining the valid data paths for records of this type
--		aGMListButtons = Optional. Table of templates. A list of control templates created and added to the master list window for this record type.
--		aPlayerListButtons = Optional. Table of templates. A list of control templates created and added to the master list window for this record type.
--		bNoCategories = Optional. Disable display and usage of category information.
--		bAllowClientEdit = Optional. Allow clients to add/delete records in the list that they own.
--		bRefIntegrity = Optional. Indicates that thw Location Extension Referential Integrity is to be used.
--		bTabbed = Optional. Indicates if the Windowlist is to be displayed in a Tabbed Masterlist Window.
--		fRecordDisplayClass = Required (or sRecordDisplayClass defined). Function. Function called when requesting to display this record in detail.
--		sRecordDisplayClass = Required (or fRecordDisplayClass defined). String. Class to use when displaying this record in detail.
--		sListDisplayClass = Optional. String. Class to use when displaying this record in a list. If not defined, a default class will be used.
--
--	FIELDS ADDED FROM STRING DATA
--		sDisplayText = Interface.getString(library_recordtype_label_ .. sRecordType)
--		sEmptyNameText = Interface.getString(library_recordtype_empty_ .. sRecordType)
--
--	FIELDS ADDED FROM STRING DATA legend
--		sDisplayText = Required. String Resource. Text displayed in library and tooltips to identify record type textually.
--		sEmptyNameText = Optional. String Resource. Text displayed in name field of record list and detail classes, when name is empty.
--
aRecords = {};

function fpAllowClientEdit(sRecordType)
	if aRecords[sRecordType] then
		if aRecords[sRecordType].bAllowClientEdit then
			return aRecords[sRecordType].bAllowClientEdit;
		end
		if User.isHost() then
			return true;
		end
	end
	return false;
end

function fpAllowCategories(sRecordType)
	if aRecords[sRecordType] then
		if aRecords[sRecordType].bNoCategories then
			return false;
		end
	end
	return true;
end

function fpAllowEdit(sRecordType)
	if aRecords[sRecordType] then
		local vEditMode = aRecords[sRecordType].sEditMode;
		if vEditMode then
			if vEditMode == "play" then
				return not User.isLocal();
			elseif vEditMode == "none" then
				return false;
			end
		end
		if User.isHost() then
			return true;
		end
	end
	return false;
end

function fpGetCustomFilters(sRecordType)
	if aRecords[sRecordType] then
		return (aRecords[sRecordType].aCustomFilters or {});
	end
	return {};
end

function fpGetDisplayText(sRecordType)
	if aRecords[sRecordType] then
		return aRecords[sRecordType].sDisplayText;
	end
	return "";
end

function fpGetEditButtons(sRecordType)
	if aRecords[sRecordType] then
		if User.isHost() then
			return (aRecords[sRecordType].aGMEditButtons or {});
		else
			return (aRecords[sRecordType].aPlayerEditButtons or {});
		end
	end
	return {};
end

function fpGetEmptyNameText(sRecordType)
	if aRecords[sRecordType] then
		return aRecords[sRecordType].sEmptyNameText;
	end
	return "";
end

function fpGetIDOption(sRecordType)
	if aRecords[sRecordType] then
		return aRecords[sRecordType].sIDOption;
	end
	return "";
end

function fpGetIndexButtons(sRecordType)
	if aRecords[sRecordType] then
		if User.isHost() then
			return (aRecords[sRecordType].aGMListButtons or {});
		else
			return (aRecords[sRecordType].aPlayerListButtons or {});
		end
	end
	return {};
end

function fpGetIndexDisplayClass(sRecordType)
	if aRecords[sRecordType] then
		return (aRecords[sRecordType].sListDisplayClass or "");
	end
	return "";
end

function fpGetMappings(sRecordType)
	if aRecords[sRecordType] then
		return aRecords[sRecordType].aDataMap;
	end
	return {};
end

function fpGetRecordDisplayClass(sRecordType,sPath)
	if aRecords[sRecordType] then
		if aRecords[sRecordType].fRecordDisplayClass then
			return aRecords[sRecordType].fRecordDisplayClass(sPath);
		elseif aRecords[sRecordType].sRecordDisplayClass then
			return aRecords[sRecordType].sRecordDisplayClass;
		end
	end
	return "";
end

function fpGetRecordType(sNodeName)
	for kKey1,vValue1 in pairs(aRecords) do
		for kKey2,vValue2 in pairs(vValue1.aDataMap) do
			if vValue2 == sNodeName then
				return kKey1;
			end
		end
	end
	return "";
end

function fpGetRefIntegrity(sRecordType)
	if aRecords[sRecordType] then
		return aRecords[sRecordType].bRefIntegrity;
	end
	return false;
end

function fpGetRootMapping(sRecordType)
	if aRecords[sRecordType] then
		local sType = type(aRecords[sRecordType].aDataMap);
		if sType == "table" then
			return aRecords[sRecordType].aDataMap[1];
		elseif sType == "string" then
			return aRecords[sRecordType].aDataMap;
		end
	end
end

function fpInit()
	sFilterValueYes = Interface.getString("library_recordtype_filter_yes");
	sFilterValueNo = Interface.getString("library_recordtype_filter_no");
	sFilterValueEmpty = Interface.getString("library_recordtype_filter_empty");
	for kKey,vValue in pairs(aRecords) do
		vValue.sDisplayText = Interface.getString("library_recordtype_label_" .. kKey);
		vValue.sEmptyNameText = Interface.getString("library_recordtype_empty_" .. kKey);
		if vValue.bID then
			vValue.sEmptyUnidentifiedNameText = Interface.getString("library_recordtype_empty_nonid_" .. kKey);
		end
		if vValue.bExport then
			local sRootMapping = fpGetRootMapping(kKey);
			local sDisplayClass = fpGetRecordDisplayClass(kKey);
			if ((sRootMapping or "") ~= "") then
				ExportManager.registerExportNode({name = sRootMapping,class = sDisplayClass,label = vValue.sDisplayText});
			end
		end
	end
end

function fpIsIdentifiable(sRecordType,vNode)
	if aRecords[sRecordType] then
		if aRecords[sRecordType].bID then
			if aRecords[sRecordType].fIsIdentifiable then
				return aRecords[sRecordType].fIsIdentifiable(vNode);
			else
				return true;
			end
		end
	end
	return false;
end

function fpSetRecordTypeInfo(sRecordType,aRecordType)
	aRecords[sRecordType] = aRecordType;
	aRecords[sRecordType].sDisplayText = Interface.getString("library_recordtype_label_" .. sRecordType);
	aRecords[sRecordType].sEmptyNameText = Interface.getString("library_recordtype_empty_" .. sRecordType);
end
