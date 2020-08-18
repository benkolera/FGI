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
-- Called By: tColourDome in xDORBaseTemplates.xml
--

oDomeBase = nil;
oDomeColour = nil;
oDomeEffect = nil;
oDomeIcon = nil;
nSize = 20;

function onInit()
	local sColour = "ff000000";
	local sButIcon = "";
	local sIconColour = "ff000000";
	local sSize = "20";
	if colour and
			colour[1] then
		sColour = colour[1];
	end
	if buttonicon and
			buttonicon[1] then
		sButIcon = buttonicon[1];
	end
	if iconcolour and
			iconcolour[1] then
		sIconColour = iconcolour[1];
	end
	if size and
			size[1] then
		nSize = tonumber(size[1]);
		sSize = size[1];
	end
	setAnchoredHeight(sSize);
	setAnchoredWidth(sSize);
	oDomeBase,oDomeColour,oDomeEffect,oDomeIcon = ColourDomeManager.fpCreateColourDome(self,"",nSize,sColour,flase,false,0,0,"center",sButIcon,sIconColour);
end

function fpSetSize(sValue)
	if tonumber(sValue) > 0 then
		nSize = tonumber(sValue);
		setAnchoredHeight(sValue);
		setAnchoredWidth(sValue);
		oDomeBase.setSize(sValue,sValue);
		oDomeColour.setSize(sValue,sValue);
		oDomeEffect.setSize(sValue,sValue);
		if oDomeIcon then
			oDomeIcon.setSize(sValue,sValue);
		end
	end
	return;
end
