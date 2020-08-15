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
-- Called By: wcLibMasterList in xDORBaseWindowClasses.xml
--				wcTabbedLibMasterList in xDORBaseWindowClasses.xml
--
local N_MAX_DISPLAY_RECORDS = 100;

local aButtonControls = {};
local aCustomFilters = {};
local aCustomFilterControls = {};
local aCustomFilterValues = {};
local aCustomFilterValueControls = {};
local aEditControls = {};
local aFilteredRecords = {};
local aRecords = {};
local bAllowCategories = true;
local bDelayedChildrenChanged = false;
local bDelayedRebuild = false;
local bProcessListChanged = false;
local bSetCategoryOnAdd = false;
local bSharedOnly = false;
local fCategory = "";
local fName = "";
local nCustomFilters = 0;
local nDisplayOffset = 0;
local oButtonAnchor = nil;
local sInternalRecordType = "";

function onInit()
	if parentcontrol and
			parentcontrol.gcRecordString then
		fpSetRecordType(parentcontrol.gcRecordString[1]);
	else
		fpSetRecordType(LibManager.fpGetRecordType(getDatabaseNode().getNodeName()));
	end
	Module.onModuleLoad = fpOnModuleLoad;
	Module.onModuleUnload = fpOnModuleUnload;
end

function onClose()
	local sInternalIDOption = LibManager.fpGetIDOption(sInternalRecordType);
	if sInternalIDOption ~= "" then
		OptionsManager.unregisterCallback(sInternalIDOption,fpOnIDChanged);
	end
	fpRemoveHandlers(wlList.getDatabaseNode());
end

function onListChanged()
	if bDelayedChildrenChanged then
		fpOnListRecordsChanged(false);
	else
		wlList.fpUpdate();
	end
end

function fpAddCustomFilter(sCustomType)
	local oControl = createControl("masterindex_filter_custom","filter_custom_" .. sCustomType);
	oControl.setValue(sCustomType);
	aCustomFilterControls[sCustomType] = oControl;
	oControl = createControl("masterindex_filter_custom_value","filter_custom_value_" .. sCustomType);
	oControl.setFilterType(sCustomType);
	aCustomFilterValueControls[sCustomType] = oControl;
	aCustomFilterValues[sCustomType] = "";
end

function fpAddEntry()
	wlListIconAdd.onButtonPress();
end

function fpAddHandlers()
	local aNodes = LibManager.fpGetMappings(sInternalRecordType);
	for i = 1,#aNodes do
		fpAddHandlerHelper(aNodes[i]);
	end
end

function fpAddHandlerHelper(oNode)
	local sPath = DB.getPath(oNode);
	local sChildPath = sPath .. ".*";
	DB.addHandler(sChildPath,"onAdd",fpOnChildAdded);
	DB.addHandler(sChildPath,"onDelete",fpOnChildDeleted);
	DB.addHandler(sChildPath,"onCategoryChange",fpOnChildCategoryChange);
	DB.addHandler(sChildPath,"onObserverUpdate",fpOnChildObserverUpdate);
	DB.addHandler(sChildPath .. ".name","onUpdate",fpOnChildNameChange);
	DB.addHandler(sChildPath .. ".nonid_name","onUpdate",fpOnChildUnidentifiedNameChange);
	DB.addHandler(sChildPath .. ".isidentified","onUpdate",fpOnChildIdentifiedChange);
	for kKey,vValue in pairs(aCustomFilters) do
		DB.addHandler(sChildPath .. "." .. vValue.sField,"onUpdate",fpOnChildCustomFilterValueChange);
	end
	DB.addHandler(sPath,"onChildCategoriesChange",fpOnChildCategoriesChanged);
end

function fpAddListRecord(vNode)
	local aRecord = {};
	aRecord.vNode = vNode;
	aRecord.sName = DB.getValue(vNode,"name","");
	aRecord.sNameLower = aRecord.sName:lower();
	local vCategory = vNode.getCategory();
	if type(vCategory) == "table" then
		aRecord.sCategory = vCategory.name;
	else
		aRecord.sCategory = vCategory;
	end
	aRecord.nAccess = UtilityManager.getNodeAccessLevel(vNode);
	aRecord.bIdentifiable = LibManager.fpIsIdentifiable(sInternalRecordType,vNode);
	if aRecord.bIdentifiable then
		aRecord.sUnidentifiedName = DB.getValue(vNode,"nonid_name","");
		aRecord.sUnidentifiedNameLower = aRecord.sUnidentifiedName:lower();
	end
	aRecord.aCustomValues = {};
	for kKey,vValue in pairs(aCustomFilters) do
		aRecord.aCustomValues[kKey] = DB.getValue(vNode,vValue.sField,"");
	end
	aRecords[vNode] = aRecord;
end

function fpApplyListFilter()
	aFilteredRecords = {};
	for _,vValue in pairs(aRecords) do
		if fpApplyRecordFilter(vValue) then
			table.insert(aFilteredRecords,vValue);
		end
	end
	table.sort(aFilteredRecords,fpApplyRecordSort);
	if nDisplayOffset < 0 or
			nDisplayOffset >= #aFilteredRecords then
		nDisplayOffset = 0;
	end
	wlList.closeAll();
	local nDisplayOffsetMax = nDisplayOffset + N_MAX_DISPLAY_RECORDS;
	for kKey,vValue in ipairs(aFilteredRecords) do
		if kKey > nDisplayOffset and
				kKey <= nDisplayOffsetMax then
			local oWindow = wlList.createWindow(vValue.vNode);
			if oWindow.category and
					fCategory ~= "*" then
				oWindow.category.setVisible(false);
			end
			if oWindow.fpSetRecordType then
				oWindow.fpSetRecordType(sInternalRecordType);
			end
		end
	end
	local nPages = fpGetFilteredResultsPages();
	if nPages > 1 then
		local nCurrentPage = math.max(math.floor(nDisplayOffset / N_MAX_DISPLAY_RECORDS)+1,1);
		local sPageText = string.format(Interface.getString("masterindex_label_page_info"),nCurrentPage,nPages)
		LibMasListPgeInfoString.setValue(sPageText);
		LibMasListPgeInfoString.setVisible(true);
		if nCurrentPage == 1 then
			ButLibMasListPgeStart.setVisible(false);
			ButLibMasListPgePrev.setVisible(false);
		else
			ButLibMasListPgeStart.setVisible(true);
			ButLibMasListPgePrev.setVisible(true);
		end
		if nCurrentPage >= nPages then
			ButLibMasListPgeNext.setVisible(false);
			ButLibMasListPgeEnd.setVisible(false);
		else
			ButLibMasListPgeNext.setVisible(true);
			ButLibMasListPgeEnd.setVisible(true);
		end
	else
		ButLibMasListPgeStart.setVisible(false);
		ButLibMasListPgePrev.setVisible(false);
		ButLibMasListPgeNext.setVisible(false);
		ButLibMasListPgeEnd.setVisible(false);
		LibMasListPgeInfoString.setVisible(false);
	end
	local nListOffset = 40;
	if nPages > 1 then
		nListOffset = nListOffset+24;
	end
	if nCustomFilters > 0 then
		nListOffset = nListOffset+(25*nCustomFilters);
	end
	wlList.setAnchor("bottom","gAnchorLibMasterBottom","top","relative",-nListOffset);
end

function fpApplyRecordFilter(vRecord)
	if bAllowCategories and
			fCategory ~= "*" and
			vRecord.sCategory ~= fCategory then
		return false;
	end
	if fSharedOnly and
			vRecord.nAccess == 0 then
		return false;
	end
	for kKey1,vValue1 in pairs(aCustomFilterValues) do
		if vValue1 ~= "" then
			local vValues = fpGetFilterValues(kKey1,vRecord.vNode);
			local bMatch = false;
			for _,vValue2 in ipairs(vValues) do
				if vValue2:lower() == vValue1 then
					bMatch = true;
					break;
				end
			end
			if not bMatch then
				return false;
			end
		end
	end
	if fName ~= "" then
		if fpGetRecordIDState(vRecord) then
			if not string.find(vRecord.sNameLower,fName,0,true) then
				return false;
			end
		else
			if not string.find(vRecord.sUnidentifiedNameLower,fName,0,true) then
				return false;
			end
		end
	end
	return true;
end

function fpApplyRecordSort(vRecordA,vRecordB)
	local sNameA,sNameB;
	if fpGetRecordIDState(vRecordA) then
		sNameA = vRecordA.sName;
	else
		sNameA = vRecordA.sUnidentifiedName;
	end
	if fpGetRecordIDState(vRecordB) then
		sNameB = vRecordB.sName;
	else
		sNameB = vRecordB.sUnidentifiedName;
	end
	if sNameA ~= sNameB then
		return sNameA < sNameB;
	end
	return vRecordA.vNode.getPath() < vRecordB.vNode.getPath();
end

function fpClearButtons()
	for kKey,vValue in ipairs(aButtonControls) do
		vValue.destroy();
	end
	if oButtonAnchor then
		oButtonAnchor.destroy();
		oButtonAnchor = nil;
	end
	aButtonControls = {};
	for kKey,vValue in ipairs(aEditControls) do
		vValue.destroy();
	end
	aEditControls = {};
end

function fpClearCustomFilters()
	for kKey,vValue in pairs(aCustomFilterValueControls) do
		vValue.onDestroy();
		vValue.destroy();
	end
	aCustomFilterValueControls = {};
	for kKey,vValue in pairs(aCustomFilterControls) do
		vValue.destroy();
	end
	aCustomFilterControls = {};
	aCustomFilters = {};
	nCustomFilters = 0;
end

function fpClearFilterValues()
	if bSharedOnly then
		btSharedOnlyFilter.setValue(0);
	end
	if fName ~= "" then
		sCampFilter.setValue();
	end
	for kKey,_ in pairs(aCustomFilters) do
		aCustomFilterValueControls[kKey].setValue("");
	end
end

function fpClearIDOption()
	local sInternalIDOption = LibManager.fpGetIDOption(sInternalRecordType);
	if sInternalIDOption ~= "" then
		OptionsManager.unregisterCallback(sInternalIDOption,fpOnIDChanged);
	end
end

function fpGetFilteredResultsPages()
	local nPages = math.floor((#aFilteredRecords-1)/N_MAX_DISPLAY_RECORDS);
	if ((#aFilteredRecords-1)%N_MAX_DISPLAY_RECORDS) > 0 then
		nPages = nPages+1;
	end
	return nPages;
end

function fpGetFilterValues(kCustomFilter,vNode)
	local vValues = {};
	local vCustomFilter = aCustomFilters[kCustomFilter];
	if vCustomFilter then
		if vCustomFilter.fGetValue then
			vValues = vCustomFilter.fGetValue(vNode);
			if type(vValues) ~= "table" then
				vValues = { vValues };
			end
		elseif vCustomFilter.sType == "boolean" then
			if DB.getValue(vNode,vCustomFilter.sField,0) ~= 0 then
				vValues = {LibManager.sFilterValueYes};
			else
				vValues = {LibManager.sFilterValueNo};
			end
		else
			local vValue = DB.getValue(vNode,vCustomFilter.sField);
			if vCustomFilter.sType == "number" then
				vValues = {tostring(vValue or 0)};
			else
				local sValue;
				if vValue then
					sValue = tostring(vValue) or "";
				else
					sValue = "";
				end
				if sValue == "" then
					vValues = {LibManager.sFilterValueEmpty};
				else
					vValues = {sValue};
				end
			end
		end
	end
	
	return vValues;
end

function fpGetRecordIDState(vRecord)
	local bID = true;
	if vRecord.bIdentifiable then
		if sInternalRecordType == "item" then
			bID = ItemManager.getIDState(vRecord.vNode);
		elseif not User.isHost() then
			bID = (DB.getValue(vRecord.vNode,"isidentified",0) == 1);
		end
	end
	return bID;
end

function fpGetRecordType()
	return sInternalRecordType;
end

function fpHandleCategoryAdd()
	local aMappings = LibManager.fpGetMappings(sInternalRecordType);
	local sNew = DB.addChildCategory(aMappings[1]);
	wlListCategory.applySort(true);
	for kKey,vValue in ipairs(wlListCategory.getWindows()) do
		if vValue.hsCategory.getValue() == sNew then
			vValue.sCategoryLabel.setFocus();
			break;
		end
	end
end

function fpHandleCategoryDelete(sName)
	for kKey,vValue in ipairs(LibManager.fpGetMappings(sInternalRecordType)) do
		DB.removeChildCategory(vValue,sName,true);
	end
end

function fpHandleCategoryNameChange(sOriginalName,sNewName)
	if sOriginalName == sNewName then
		return;
	end
	for kKey,vValue in ipairs(LibManager.fpGetMappings(sInternalRecordType)) do
		DB.updateChildCategory(vValue,sOriginalName,sNewName,true);
	end
end

function fpHandleCategorySelect(sCategory)
	if not bAllowCategories then
		return;
	end
	hsCategoryFilter.setValue(sCategory);
	fCategory = sCategory;
	if fCategory == "*" then
		sLibMasterCategoryFilterLabel.setValue(Interface.getString("masterindex_label_category_all"));
	elseif fCategory == "" then
		sLibMasterCategoryFilterLabel.setValue(Interface.getString("masterindex_label_category_empty"));
	else
		sLibMasterCategoryFilterLabel.setValue(fCategory);
	end
	for kKey,vValue in ipairs(wlListCategory.getWindows()) do
		if vValue.hsCategory.getValue() == fCategory then
			vValue.setFrame("rowshade");
		else
			vValue.setFrame(nil);
		end
	end
	btCategoryCombobox.setValue(0);
	fpApplyListFilter();
end

function fpHandlePageEnd()
	local nPages = fpGetFilteredResultsPages();
	if nPages > 1 then
		nDisplayOffset = (nPages-1) * N_MAX_DISPLAY_RECORDS;
	else
		nDisplayOffset = 0;
	end
	fpApplyListFilter();
end

function fpHandlePageNext()
	nDisplayOffset = nDisplayOffset + N_MAX_DISPLAY_RECORDS;
	fpApplyListFilter();
end

function fpHandlePagePrev()
	nDisplayOffset = nDisplayOffset - N_MAX_DISPLAY_RECORDS;
	fpApplyListFilter();
end

function fpHandlePageStart()
	nDisplayOffset = 0;
	fpApplyListFilter();
end

function fpOnCampaignEntryAdded()
	if bSharedOnly then
		btSharedOnlyFilter.setValue(0);
	end
	if fName ~= "" then
		sCampFilter.setValue();
	end
end

function fpOnChildAdded(vNode)
	fpAddListRecord(vNode);
	if bSetCategoryOnAdd and
			bAllowCategories and
			fCategory ~= "*" and
			(vNode.getModule() or "") == "" then
		local vCategory = vNode.getCategory();
		local sCategory;
		if type(vCategory) == "table" then
			sCategory = vCategory.name;
		else
			sCategory = vCategory;
		end
		if sCategory == "" then
			vNode.setCategory(fCategory);
		end
	end
	fpClearFilterValues();
	fpOnListRecordsChanged(true);
end

function fpOnChildCategoryChange(vNode)
	if aRecords[vNode] then
		local vCategory = vNode.getCategory();
		if type(vCategory) == "table" then
			aRecords[vNode].sCategory = vCategory.name;
		else
			aRecords[vNode].sCategory = vCategory;
		end
		if fCategory ~= "*" then
			fpApplyListFilter();
		end
	end
end

function fpOnChildCategoriesChanged()
	fpOnListRecordsChanged(true);
end

function fpOnChildCustomFilterValueChange(vNode)
	local sNodeName = vNode.getName();
	for kKey,vValue in pairs(aCustomFilters) do
		if vValue.sField == sNodeName then
			if aCustomFilterValues[kKey] ~= "" then
				fpApplyListFilter();
			end
			break;
		end
	end
end

function fpOnChildDeleted(vNode)
	if aRecords[vNode] then
		aRecords[vNode] = nil;
		fpOnListRecordsChanged(true);
	end
end

function fpOnChildIdentifiedChange(vIDNode)
	local vNode = vIDNode.getParent();
	if aRecords[vNode].bIdentifiable and
			not User.isHost() then
		fpApplyListFilter();
	end
end

function fpOnChildNameChange(vNameNode)
	local vNode = vNameNode.getParent();
	aRecords[vNode].sName = DB.getValue(vNode,"name","");
	aRecords[vNode].sNameLower = aRecords[vNode].sName:lower();
	if fpGetRecordIDState(aRecords[vNode]) then
		fpApplyListFilter();
	end
end

function fpOnChildObserverUpdate(vNode)
	aRecords[vNode].nAccess = UtilityManager.getNodeAccessLevel(vNode);
	if fSharedOnly then
		fpApplyListFilter();
	end
end

function fpOnChildUnidentifiedNameChange(vNameNode)
	local vNode = vNameNode.getParent();
	aRecords[vNode].sUnidentifiedName = DB.getValue(vNode,"nonid_name","");
	aRecords[vNode].sUnidentifiedNameLower = aRecords[vNode].sUnidentifiedName:lower();
	if not fpGetRecordIDState(aRecords[vNode]) then
		fpApplyListFilter();
	end
end

function fpOnCustomFilterValueChanged(sFilterType,sFilterValue)
	aCustomFilterValues[sFilterType] = sFilterValue.getValue():lower();
	fpApplyListFilter();
end

function fpOnEditModeChanged(bEditMode)
	for _,vValue in ipairs(aEditControls) do
		vValue.setVisible(bEditMode);
	end
end

function fpOnIDChanged()
	for _,vValue in ipairs(list.getWindows()) do
		vValue.onIDChanged();
	end
	fpApplyListFilter();
end

function fpOnListRecordsChanged(bAllowDelay)
	if bAllowDelay then
		bDelayedChildrenChanged = true;
		wlList.setDatabaseNode(nil);
	else
		bDelayedChildrenChanged = false;
		if bDelayedRebuild then
			bDelayedRebuild = false;
			fpRebuildList();
		end
		fpRebuildCategories();
		fpRebuildCustomFilterValues();
		fpApplyListFilter();
	end
end

function fpOnModuleLoad(sModule)
	local oNodeRoot = DB.getRoot(sModule);
	if oNodeRoot then
		local aNodes = LibManager.fpGetMappings(sInternalRecordType);
		for i = 1,#aNodes do
			if oNodeRoot.getChild(aNodes[i]) then
				bDelayedRebuild = true;
				fpOnListRecordsChanged(true);
				break;
			end
		end
	end
end

function fpOnModuleUnload(sModule)
	local oNodeRoot = DB.getRoot(sModule);
	if oNodeRoot then
		local aNodes = LibManager.fpGetMappings(sInternalRecordType);
		for i = 1,#aNodes do
			if oNodeRoot.getChild(aNodes[i]) then
				bDelayedRebuild = true;
				fpOnListRecordsChanged(true);
				break;
			end
		end
	end
end

function fpOnNameFilterChanged()
	fName = sCampFilter.getValue():lower();
	fpApplyListFilter();
end

function fpOnSharedOnlyFilterChanged()
	bSharedOnly = (btSharedOnlyFilter.getValue() == 1);
	fpApplyListFilter();
end

function fpOnUserCreateActionEnd()
	bSetCategoryOnAdd = false;
end

function fpOnUserCreateActionStart()
	bSetCategoryOnAdd = true;
end

function fpRebuildCategories()
	if not bAllowCategories then
		return;
	end
	local aCategories = {};
	for kKey1,vValue1 in ipairs(LibManager.fpGetMappings(sInternalRecordType)) do
		for kKey2,vValue2 in ipairs(DB.getChildCategories(vValue1,true)) do
			if type(vValue2) == "string" then
				aCategories[vValue2] = vValue2;
			else
				aCategories[vValue2.name] = vValue2.name;
			end
		end
	end
	aCategories["*"] = Interface.getString("masterindex_label_category_all");
	aCategories[""] = Interface.getString("masterindex_label_category_empty");
	wlListCategory.closeAll();
	for kKey,vValue in pairs(aCategories) do
		local oWindow = wlListCategory.createWindow();
		oWindow.hsCategory.setValue(kKey);
		oWindow.sCategoryLabel.fpInit(vValue);
		if kKey ~= "*" then
			oWindow.sCategoryLabel.setStateFrame("drophover","fieldfocusplus",7,3,7,3);
			oWindow.sCategoryLabel.setStateFrame("drophilight","fieldfocus",7,3,7,3);
		end
		if fCategory == kKey then
			oWindow.setFrame("rowshade");
		end
	end
	wlListCategory.applySort();
	if not aCategories[fCategory] then
		fpHandleCategorySelect("*");
	end
	if btCategoryEdit.getValue() == 1 then
		btCategoryEdit.setValue(0);
		btCategoryEdit.setValue(1);
	end
end

function fpRebuildCustomFilterValues()
	local nCustomFilters = 0;
	local aRecordFilterValues = {};
	for kKey,_ in pairs(aCustomFilters) do
		if aCustomFilterValueControls[kKey] then
			aRecordFilterValues[kKey] = {};
			nCustomFilters = nCustomFilters+1;
		end
	end
	if nCustomFilters == 0 then
		return;
	end
	for _,vValue1 in pairs(aRecords) do
		for kKey2,vValue2 in pairs(aCustomFilters) do
			if aCustomFilterValueControls[kKey2] then
				local vValues = fpGetFilterValues(kKey2,vValue1.vNode);
				for _,vValue3 in ipairs(vValues) do
					if (vValue3 or "") ~= "" then
						aRecordFilterValues[kKey2][vValue3] = true;
					end
				end
			end
		end
	end
	for kKey1,vValue1 in pairs(aRecordFilterValues) do
		aCustomFilterValueControls[kKey1].clear();
		if not vValue1[aCustomFilterValueControls[kKey1].getValue()] then
			aCustomFilterValueControls[kKey1].setValue("");
		end
		local aFilterValues = {};
		for kKey2,_ in pairs(vValue1) do
			table.insert(aFilterValues,kKey2);
		end
		if aCustomFilters[kKey1].fSort then
			aFilterValues = aCustomFilters[kKey1].fSort(aFilterValues);
		elseif aCustomFilters[kKey1].sType == "number" then
			table.sort(aFilterValues,function(a,b) return (tonumber(a) or 0) < (tonumber(b) or 0); end);
		else
			table.sort(aFilterValues);
		end
		table.insert(aFilterValues,1,"");
		aCustomFilterValueControls[kKey1].addItems(aFilterValues);
	end
end

function fpRebuildList()
	bProcessListChanged = false;
	local sListDisplayClass = LibManager.fpGetIndexDisplayClass(sInternalRecordType);
	if sListDisplayClass ~= "" then
		wlList.setChildClass(sListDisplayClass);
	end
	aRecords = {};
	local aMappings = LibManager.fpGetMappings(sInternalRecordType);
	for _,vValue1 in ipairs(aMappings) do
		for _,vValue2 in pairs(DB.getChildrenGlobal(vValue1)) do
			fpAddListRecord(vValue2);
		end
	end
	nDisplayOffset = 0;
	fpOnListRecordsChanged();
	bProcessListChanged = true;
end

function fpRemoveHandlers()
	local aNodes = LibManager.fpGetMappings(sInternalRecordType);
	for i = 1,#aNodes do
		fpRemoveHandlerHelper(aNodes[i]);
	end
end

function fpRemoveHandlerHelper(oNode)
	local sPath = DB.getPath(oNode);
	local sChildPath = sPath .. ".*";
	DB.removeHandler(sChildPath,"onAdd",fpOnChildAdded);
	DB.removeHandler(sChildPath,"onDelete",fpOnChildDeleted);
	DB.removeHandler(sChildPath,"onCategoryChange",fpOnChildCategoryChange);
	DB.removeHandler(sChildPath,"onObserverUpdate",fpOnChildObserverUpdate);
	DB.removeHandler(sChildPath .. ".name","onUpdate",fpOnChildNameChange);
	DB.removeHandler(sChildPath .. ".nonid_name","onUpdate",fpOnChildUnidentifiedNameChange);
	DB.removeHandler(sChildPath .. ".isidentified","onUpdate",fpOnChildIdentifiedChange);
	for kKey,vValue in pairs(aCustomFilters) do
		DB.removeHandler(sChildPath .. "." .. vValue.sField,"onUpdate",fpOnChildCustomFilterValueChange);
	end
	DB.removeHandler(sPath,"onChildCategoriesChange",fpOnChildCategoriesChanged);
end

function fpSetRecordType(sRecordType)
	if sRecordType == sInternalRecordType then
		return;
	end
	fpRemoveHandlers();
	fpClearButtons();
	fpClearCustomFilters();
	fpClearIDOption();
	sInternalRecordType = sRecordType;
	LibMasterTitle.setValue(LibManager.fpGetDisplayText(sRecordType));
	fpSetupEditTools(sRecordType);
	fpSetupCategories();
	fpSetupButtons();
	fpSetupCustomFilters();
	fpSetupIDOption();
	fpRebuildList();
	fpAddHandlers();
end

function fpSetupButtons()
	local aIndexButtons = LibManager.fpGetIndexButtons(sInternalRecordType);
	if #aIndexButtons > 0 then
		oButtonAnchor = createControl("tAnchorLibMasterButton","gAnchorButton");
		for kKey,vValue in ipairs(aIndexButtons) do
			local oControl = createControl(vValue,"button" .. kKey);
			if oControl then
				table.insert(aButtonControls,oControl);
			end
		end
	end
	local aEditButtons = LibManager.fpGetEditButtons(sInternalRecordType);
	if #aEditButtons > 0 then
		for kKey,vValue in ipairs(aEditButtons) do
			local oControl = createControl(vValue,"button_edit" .. kKey);
			if oControl then
				table.insert(aEditControls,oControl);
			end
		end
	end
end

function fpSetupCategories()
	bAllowCategories = LibManager.fpAllowCategories(sInternalRecordType);
	sLibMasterCategoryLabel.setVisible(bAllowCategories);
	sLibMasterCategoryFilterLabel.setVisible(bAllowCategories);
	btCategoryCombobox.setVisible(bAllowCategories);
	fpHandleCategorySelect("*");
end

function fpSetupCustomFilters()
	aCustomFilters = LibManager.fpGetCustomFilters(sInternalRecordType);
	local aSortedFilters = {};
	for kKey,vValue in pairs(aCustomFilters) do
		table.insert(aSortedFilters,kKey);
	end
	table.sort(aSortedFilters);
	for kKey,vValue in ipairs(aSortedFilters) do
		fpAddCustomFilter(vValue);
	end
	nCustomFilters = #aSortedFilters;
end

function fpSetupEditTools(sRecordType)
	if wlListIconAdd then
		wlListIconAdd.fpSetRecordType(LibManager.fpGetRecordDisplayClass(sRecordType));
		wlListIconAdd.fpSetNode(LibManager.fpGetMappings(sRecordType));
	end
	local bAllowEdit = LibManager.fpAllowEdit(sInternalRecordType);
	wlListIconEdit.setVisible(bAllowEdit);
	wlList.setReadOnly(not bAllowEdit);
	wlList.resetMenuItems();
	if not wlList.isReadOnly() and
			bAllowEdit and
			getClass() ~= "wcTabbedLibMasterListNoAdd" then
		wlList.registerMenuItem(Interface.getString("list_menu_createitem"),"insert",5);
	end
end

function fpSetupIDOption()
	local sInternalIDOption = LibManager.fpGetIDOption(sInternalRecordType);
	if sInternalIDOption ~= "" then
		OptionsManager.unregisterCallback(sInternalIDOption,fpOnIDChanged);
	end
end
