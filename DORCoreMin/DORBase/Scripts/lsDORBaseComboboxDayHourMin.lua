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
-- Called By: tComboboxColHalfRight in xDORBaseTemplates.xml
--

function onInit()
	super.onInit();
	addItems({Interface.getString("sTimeDaysStr"),Interface.getString("sTimeHoursStr"),Interface.getString("sTimeMinutesStr")});
end

function onValueChanged()
	if sTarget == nil then
		return;
	end
	local sMeasure = getValue();
	local nValue = window[sTarget].getValue();
	if sOldMeasure == sMeasure then
		return;
	end
	if sOldMeasure == Interface.getString("sTimeHoursStr") then
		nValue = nValue/24;
	elseif sOldMeasure == Interface.getString("sTimeMinutesStr") then
		nValue = nValue/1440;
	end
	if sMeasure == Interface.getString("sTimeHoursStr") then
		nValue = nValue*24;
	elseif sMeasure == Interface.getString("sTimeMinutesStr") then
		nValue = nValue*1440;
	end
	window[sTarget].setValue(nValue);
	sOldMeasure = sMeasure;
end
