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
-- Called By: tButIconEditBase in xDORBaseTemplates.xml
--

function onInit()
	local oNode = window.getDatabaseNode();
	if datasource then
		oNode = DB.findNode(datasource[1]);
	end
	if not oNode or
			oNode.isReadOnly() then
		setVisible(false);
	end
end

function onValueChanged()
	local sAdd = target[1] .. "IconAdd";
	if window[sAdd] then
		window[sAdd].setVisible(getValue() == 1);
	end
	window[target[1]].fpUpdate();
end
