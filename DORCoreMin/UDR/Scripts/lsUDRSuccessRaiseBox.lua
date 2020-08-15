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

local oControl = nil;

function onInit()
	Interface.onHotkeyActivated = fpCheckHotKey;
end

function fpCheckHotKey(oDragData)
	local sDragType = oDragData.getType();
	if sDragType == "number" then
		fpSetRaises(oDragData.getNumberData());
		return true;
	end
end

function fpGetRaises()
	local nRaises = 0;
	if fpIsActive() then
		nRaises = nValue;
	end
	return nRaises;
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

function fpSetRaises(nNumber)
	nValue = nNumber;
	fpUpdateControl();
end

function fpUpdateControl()
	if oControl then
		if nValue < 0 then
			nValue = 0;
		end
		oControl.nSN.setValue(nValue);
		if math.abs(oControl.nSN.getValue()) > 999 then
			oControl.nSN.setFont("modcollectorlabel");
		else
			oControl.nSN.setFont("modcollector");
		end
	end
end
