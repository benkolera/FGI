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
-- Called By: tButWLChangeColour in xDORBaseTemplates.xml
--

local oSourceNode;
local sSourceNodeName;

function onInit()
	local oNode = window.getDatabaseNode();
	if oNode then
		oSourceNode = oNode.createChild(source[1],"number");
		fpSetColour(oSourceNode.getValue());
	end
	return;
end

function onClickDown(nButton,nXPos,nYPos)
	return true;
end

function onClickRelease(nButton,nXPos,nYPos)
	if not isReadOnly() then
		fpChangeColour(oSourceNode.getValue());
	end
	return true;
end

function fpSetColour(nValue)
	local sColour = "";
	if nValue == 1 then
		sColour = "Red";
	elseif nValue == 2 then
		sColour = "Orange";
	elseif nValue == 3 then
		sColour = "Yellow";
	elseif nValue == 4 then
		sColour = "Green";
	elseif nValue == 5 then
		sColour = "Blue";
	elseif nValue == 6 then
		sColour = "Purple";
	elseif nValue == 7 then
		sColour = "Brown";
	else
		sColour = "";
	end
	if nValue == 0 then
		window.setFrame("");
	else
		window.setFrame("frmWL" .. sColour);
	end
	return;
end

function fpChangeColour(nValue)
	local nNewValue;
	if nValue == 7 then
		nNewValue = 0;
	else
		nNewValue = nValue+1;
	end
	fpSetColour(nNewValue);
	oSourceNode.setValue(nNewValue);
	return;
end
