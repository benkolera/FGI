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
-- Called By: tComboboxFeetMetreAltitude in xDORBaseTemplates.xml
--

local nFeetInMetre = 3.2808399

function onInit()
	super.onInit();
	if MiscFunctions.fpIsExtensionLoaded("DOEWMC") then
		local aValues = {};
		for kKey,vValue in pairs(DB.getChildren("MJB_WMC.LengthSys.Level2")) do
			table.insert(aValues,vValue.getChild("name").getValue())
		end
		addItems(aValues);
		if getValue() == Interface.getString("sLengthFeetStr") then
			setValue(Interface.getString("sLengthFootStr"));
		end
	else
		addItems({Interface.getString("sLengthFeetStr"),Interface.getString("sLengthMetreStr")});
	end
end

function onValueChanged()
	local sMeasure = getValue();
	local nNumValue,nExpValue = MiscFunctions.fpSimplifySciNotation(window[sTarget].getNumExpValue());
	if sOldMeasure == sMeasure then
		return;
	end
	if sOldMeasure == nil or
			sMeasure == nil then
		return;
	end
	if MiscFunctions.fpIsExtensionLoaded("DOEWMC") then
		nNumValue,nExpValue = WMCManager.fpConvertUnits(WMCManager.LENGTHSYSTEM,sOldMeasure,sMeasure,nNumValue,nExpValue);
	elseif sOldMeasure == Interface.getString("sLengthMetreStr") then
		nNumValue = nNumValue*nFeetInMetre;
	else
		nNumValue = nNumValue/nFeetInMetre;
	end
	window[sTarget].setValue(MiscFunctions.fpDisplaySciNotationValue(MiscFunctions.fpSimplifySciNotation(nNumValue,nExpValue)));
	window[sTarget].onLoseFocus();
	sOldMeasure = sMeasure;
end
