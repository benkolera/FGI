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
-- Called By: reference_colindexgroup in xDORBaseWindowClasses.xml
--

function showFullHeaders(bShowFlg)
	if descframe then
		descframe.setVisible(bShowFlg);
	end
	description.setVisible(bShowFlg);
	if subdescription then
		subdescription.setVisible(bShowFlg and
			subdescription.getValue ~= "");
	end
	if status then
		status.setVisible(bShowFlg);
	end
end

function toggle()
	list.setVisible(not list.isVisible());
	if list.isVisible() then
		status.setIcon("button_collapse_w");
	else
		status.setIcon("button_expand_w");
	end
end
