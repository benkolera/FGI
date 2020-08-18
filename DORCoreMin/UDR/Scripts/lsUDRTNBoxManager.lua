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
-- Called By: xCoreFiles.xml
--

nValue = 0;
sDescription = "";

local oControl = nil;
local fLabelFunction = nil;

function onInit()
	Interface.onHotkeyActivated = fpCheckHotKey;
end

function fpCheckHotKey(oDragData)
	local sDragType = oDragData.getType();
	if sDragType == "number" or
			sDragType == "targetnumber" then
		fpSetTN(oDragData.getNumberData(),oDragData.getDescription());
		return true;
	end
end

function fpGetTN()
	local sDesc = "";
	local nTN = 0;
	if fpIsActive() then
		sDesc = sDescription;
		nTN = nValue;
	end
	return nTN,sDesc;
end

function fpIsActive()
	if oControl then
		return (oControl.bcActivateButton.getValue() == 1);
	end
	return false;
end

function fpRegisterControl(oCtrl)
	oControl = oCtrl;
end

function fpRegisterLabelFunction(fFunction)
	fLabelFunction = fFunction;
end

function fpSetTN(nNumber,sDescription)
	nValue = nNumber;
	sDescription = sDescription;
	fpUpdateControl();
end

function fpUpdateControl()
	if oControl then
		oControl.sLabel.setValue(Interface.getString("sTNBoxLable"));
		if fLabelFunction then
			oControl.sLabel.setValue(fLabelFunction(nValue));
		elseif nValue ~= 0 then
			oControl.sLabel.setValue("(" .. nValue .. ")");
		end
		oControl.nTN.setValue(nValue);
		if math.abs(oControl.nTN.getValue()) > 999 then
			oControl.nTN.setFont("modcollectorlabel");
		else
			oControl.nTN.setFont("modcollector");
		end
	end
end
