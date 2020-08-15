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
-- Called By: tButCalUseCampCalWithDaysInYear in xDORBaseTemplates.xml
--

function onButtonPress()
	local sCalendarName = DB.getValue("calendar.data.name",Interface.getString("sNoneSetStr"))
	window.sCalendar.setValue(sCalendarName);
	if sCalendarName == Interface.getString("sNoneSetStr") then
		return false;
	else
		local nDays = 0;
		for kKey,oNode in pairs(DB.getChildren("calendar.data.periods")) do
			if oNode.getChild("days") ~= nil then
				nDays = nDays+oNode.getChild("days").getValue();
			end
		end
		window.sYearMeasure.setValue(Interface.getString("sTimeDaysStr"));
		window.nDaysInYear.setValue(nDays);
	end
end
