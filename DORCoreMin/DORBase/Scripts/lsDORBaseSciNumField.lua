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
-- Called By: tSciNumField in xDORBaseTemplates.xml
--

local oNumNode;
local oExpNode;

function onInit()
	oNumNode = window.getDatabaseNode().getChild(getName() .. "Num","number");
	oExpNode = window.getDatabaseNode().createChild(getName() .. "Exp","number");
	if oNumNode then
		super.nNum = oNumNode.getValue();
		super.nExp = oExpNode.getValue();
	else
		super.onInit();
		oNumNode = window.getDatabaseNode().createChild(getName() .. "Num","number");
		oNumNode.setValue(super.nNum);
		oExpNode.setValue(super.nExp);
	end
	local sDisplayValue = "";
	if super.nNum ~= 0 or
			not hideonzero then
		sDisplayValue = MiscFunctions.fpDisplaySciNotationValue(nNum,nExp);
	end
	super.sOldValue = sDisplayValue;
	setValue(sDisplayValue);
	if isReadOnly() then
		fpUpdate(true);
	else
		local oNode = getDatabaseNode();
		if not oNode
				or oNode.isReadOnly() then
			fpUpdate(true);
		end
	end
end

function onLoseFocus()
	local sValue = getValue();
	if sValue ~= super.sOldValue then
		super.onLoseFocus();
		fpSaveValue(super.nNum,super.nExp)
	end
end

function fpSaveValue(nNum,nExp)
	oNumNode.setValue(nNum);
	oExpNode.setValue(nExp);
end
