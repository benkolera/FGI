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
-- Called By: tSciNumCtrl in xDORBaseTemplates.xml
--

sOldValue = 0;
nNum = 1;
nExp = 0;

function onInit()
	local sDisplayValue = "";
	nNum = 0;
	nExp = 0;
	if default then
		sDisplayValue = default[1];
		nNum,nExp = fpConvertStrToSciNotation(default[1]);
	end
	if nNum == nil then
		nNum = 0;
		nExp = 0;
	end
	if nNum ~= 0 or
			not hideonzero then
		sDisplayValue = MiscFunctions.fpDisplaySciNotationValue(nNum,nExp);
	end
	sOldValue = sDisplayValue;
	setValue(sDisplayValue);
	if isReadOnly() then
		fpUpdate(true);
	end
end

function getNumValue()
	return nNum;
end

function getExpValue()
	return nExp;
end

function getNumExpValue()
	return nNum,nExp
end

function getNumberValue()
	return nNum*10^nExp;
end

function onLoseFocus()
	local sValue = getValue();
	if sValue ~= sOldValue then
		nNum,nExp = fpConvertStrToSciNotation(sValue);
		if nNum == nil then
			nNum = 0;
			nExp = 0;
		end
		local sDisplayValue = "";
		if nNum ~= 0 or
				not hideonzero then
			sDisplayValue = MiscFunctions.fpDisplaySciNotationValue(nNum,nExp);
		end
		setValue(sDisplayValue);
		sOldValue = sDisplayValue;
	end
end

function fpConvertStrToSciNotation(sValue)
	local sLocalNum;
	local sLocalExp = "0";
	if string.match(sValue,"^[%-%+]?%d+%.%d+[eE][%-%+]?%d+$") then
		sLocalNum,sLocalExp = string.match(sValue,"^([%-%+]?%d+%.%d+)[eE]([%-%+]?%d+)$");
	elseif string.match(sValue,"^[%-%+]?%d+[eE][%-%+]?%d+$") then
		sLocalNum,sLocalExp = string.match(sValue,"^([%-%+]?%d+)[eE]([%-%+]?%d+)$");
	elseif string.match(sValue,"^[%-%+]?%d+/%d+$") then
		sLocalNum,sLocalExp = string.match(sValue,"^([%-%+]?%d+)/(%d+)$");
		return MiscFunctions.fpSimplifySciNotation(tonumber(sLocalNum/sLocalExp),0);
	elseif string.match(sValue,"^[%-%+]?%d+%.%d+$") then
		sLocalNum = string.match(sValue,"^([%-%+]?%d+%.%d+)$");
	elseif string.match(sValue,"^[%-%+]?%d+$") then
		sLocalNum = string.match(sValue,"^([%-%+]?%d+)$");
	else
		return nil;
	end
	return MiscFunctions.fpSimplifySciNotation(tonumber(sLocalNum),tonumber(sLocalExp));
end

function fpUpdate(bReadOnly,bForceHide)
	local bLocalShow = false;
	if not bForceHide then
		bLocalShow = true;
		if bReadOnly and
				not nohide and
				isEmpty() then
			bLocalShow = false;
		end
	end
	setVisible(bLocalShow);
	setReadOnly(bReadOnly);
	local sLabel = getName() .. "Label";
	if window[sLabel] then
		window[sLabel].setVisible(bLocalShow);
	end
	if self.onUpdate then
		self.onUpdate(bLocalShow);
	end
	return bLocalShow;
end
