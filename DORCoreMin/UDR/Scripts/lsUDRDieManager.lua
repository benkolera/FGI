--
-- Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
-- Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
-- Copyright to other material within this file may be held by other Individuals and/or Entities.
-- Nothing in or from this LUA file in printed,electronic and/or any other form may be used,copied,
--	transmitted or otherwise manipulated in ANY way without the explicit written consent of
--	PEREGRINE I.T. Pty Ltd or,where applicable,any and all other Copyright holders.
-- Please see the accompanying License for full details.
-- All rights reserved.
--
-- Called By: xCoreFiles.xml

local aKeepCodes = {"k","l","h"};
local aMultOps = {"*","x","/"};
local aTokens = {};

function onInit()
	Comm.registerSlashHandler("die",fpProcessDie);
	Comm.registerSlashHandler("roll",fpProcessDie);
	ActionsManager.applyModifiersToDragSlot = fpApplyModifiersToDragSlot;
	ActionsManager.buildThrow = fpBuildThrow;
	ActionsManager.createActionMessage = fpCreateActionMessage;
	ActionsManager.onDiceLanded = fpOnDiceLanded;
	ActionsManager.registerModHandler("dice",fpSetRollCodesFromDesktop);
	ActionsManager.registerPostRollHandler("dice",fpPostRoll);
	ActionsManager.registerResultHandler("dice",fpDieRollResult);
	ChatManager.processDie = fpProcessDie;
	StringManager.convertStringToDice = fpConvertStringToDice;
	StringManager.convertDiceToString = fpConvertDiceToString;
end

function onClose()
	ActionsManager.unregisterModHandler("dice");
	ActionsManager.unregisterPostRollHandler("dice");
	ActionsManager.unregisterResultHandler("dice")
end

function fpApplyModifiersToDragSlot(oDragData,i,aSource,bResolveIfNoDice)
	local aRoll = ActionsManager.decodeRollFromDrag(oDragData, i);
	local nDice = #(aRoll.aDice);
	local bModStackUsed = ActionsManager.applyModifiers(aSource,nil,aRoll);
	if bResolveIfNoDice and #(aRoll.aDice) == 0 then
		ActionsManager.resolveAction(aSource,nil,aRoll);
	else
		for kKey,vValue in pairs(aRoll) do
			if kKey == "sType" then
				oDragData.setSlotType(vValue);
			elseif kKey == "sDesc" then
				oDragData.setStringData(vValue);
			elseif kKey == "aDice" then
				local nNewDice = #(aRoll.aDice);
				for i = nDice+1,nNewDice do
					oDragData.addDie(aRoll.aDice[i]);
				end
			elseif kKey == "nMod" then
				oDragData.setNumberData(vValue);
			elseif kKey == "aRollCodes" then
				oDragData.setCustomData(vValue);
			else
				local sKey = tostring(kKey) or "";
				if sKey ~= "" then
					oDragData.setMetaData(sKey,tostring(vValue) or "");
				end
			end
		end
	end
	return bModStackUsed;
end

function fpBuildThrow(aSource,vTargets,aRoll,bMultiTarget)
	local aThrow = {};
	aThrow.type = aRoll.sType;
	aThrow.description = aRoll.sDesc;
	aThrow.secret = aRoll.bSecret;
	aThrow.shortcuts = {};
	if aSource then
		local sActorType,sActorNode = ActorManager.getTypeAndNodeName(aSource);
		table.insert(aThrow.shortcuts,{class = sActorType,recordname = sActorNode});
	else
		table.insert(aThrow.shortcuts,{});
	end
	if vTargets then
		if bMultiTarget then
			for nIteration,vValue in ipairs(vTargets) do
				local sActorType,sActorNode = ActorManager.getTypeAndNodeName(vValue);
				table.insert(aThrow.shortcuts,{class = sActorType,recordname = sActorNode});
			end
		else
			local sActorType,sActorNode = ActorManager.getTypeAndNodeName(vTargets);
			table.insert(aThrow.shortcuts,{class = sActorType,recordname = sActorNode});
		end
	end
	local aSlot = {};
	aSlot.number = aRoll.nMod;
	aSlot.dice = aRoll.aDice;
	aSlot.metadata = aRoll;
	if not aRoll.bDiceCodeString then
		aRoll.aRPN = {};
		table.insert(aRoll.aRPN,{sType = "d",sValue = tostring(#aRoll.aDice) .. aRoll.aDice[1]});
		if aRoll.aRollCodes.nX1 == 1 then
			aRoll.aRollCodes.nX1 = tonumber(aRoll.aDice[1]:sub(2));
			aRoll.aRollCodes.nX2 = aRoll.aRollCodes.nX1;
		end
	end
	aSlot.custom = {aRollCodes = aRoll.aRollCodes,aRPN = aRoll.aRPN,aNSD = aRoll.aNSD,aOldResults = aRoll.aOldResults};
	aThrow.slots = {aSlot};
	return aThrow;
end

function fpConvertDiceToString(aDice,nMod,bSign)
	local sTmp = "";
	if aDice then
		local aDieCount = {};
		for kKey,vValue in pairs(aDice) do
			if type(vValue) == "table" then
				aDieCount[vValue.type] = (aDieCount[vValue.type] or 0)+1;
			else
				aDieCount[vValue] = (aDieCount[vValue] or 0)+1;
			end
		end
		if (aDieCount["d100"] and
				aDieCount["d10"]) then
			aDieCount["d10"] = aDieCount["d10"]-aDieCount["d100"];
			if aDieCount["d10"] <= 0 then
				aDieCount["d10"] = nil;
			end
		end
		if (aDieCount["-d100"] and
				aDieCount["d10"]) then
			aDieCount["d10"] = aDieCount["d10"]-aDieCount["-d100"];
			if aDieCount["d10"] <= 0 then
				aDieCount["d10"] = nil;
			end
		end
		for kKey,vValue in pairs(aDieCount) do
			if kKey:sub(1,1) == "-" then
				sTmp = sTmp .. "-" .. vValue .. kKey:sub(2);
			else
				if sTmp ~= "" then
					sTmp = sTmp .. "+";
				end
				sTmp = sTmp .. vValue .. kKey;
			end
		end
	end
	if nMod then
		if nMod > 0 then
			if sTmp == "" and
					not bSign then
				sTmp = sTmp .. nMod
			else
				sTmp = sTmp .. "+" .. nMod;
			end
		elseif nMod < 0 then
			sTmp = sTmp .. nMod;
		end
	end
	return sTmp;
end

function fpConvertStringToDice(sString)
	local aDice = {};
	local nMod = 0;
	if sString then
		local aRulesetDice = Interface.getDice();
		for sSign,vValue in sString:gmatch("([+-]?)([%da-zA-Z]+)") do
			local nSignMult = 1;
			if sSign == "-" then
				nSignMult = -1;
			end
			if StringManager.isNumberString(vValue) then
				local n = tonumber(vValue) or 0;
				nMod = nMod+(nSignMult*n);
			else
				local sDieCount,sDieNotation,sDieType = vValue:match("^(%d*)([a-zA-Z])([%dFG]+)");
				if sDieType then
					sDieNotation = sDieNotation:lower();
					sDieType = sDieNotation .. sDieType;
					if StringManager.contains(aRulesetDice,sDieType) or (sDieNotation == "d") then
						local nDieCount = tonumber(sDieCount) or 1;
						local sDie = sDieType;
						if sSign == "-" then
							sDie = sSign .. sDieType;
						end
						for i = 1,nDieCount do
							table.insert(aDice,sDie);
							if sDieType == "d100" then
								table.insert(aDice,"d10");
							end
						end
					end
				end
			end
		end
	end
	return aDice,nMod;
end

function fpCreateActionMessage(aSource,aRoll)
	local aMessage = ChatManager.createBaseMessage(aSource,aRoll.sUser);
	aMessage.text = aMessage.text .. aRoll.sDesc;
	aMessage.dice = aRoll.aDice;
	aMessage.diemodifier = aRoll.nMod;
	if aRoll.nTotal then
		aMessage.type = "normal|" .. aRoll.nTotal;
	else
		aMessage.type = aRoll.type;
	end
	if aRoll.bSecret then
		aMessage.secret = true;
		if aRoll.bTower then
			aMessage.icon = "dicetower_icon";
		end
	elseif User.isHost() and
			OptionsManager.isOption("REVL","off") then
		aMessage.secret = true;
	end
	if OptionsManager.isOption("TOTL","on") and
			aRoll.aDice and
			#(aRoll.aDice) > 0 then
		aMessage.dicedisplay = 1;
	end
	if aRoll.aRollCodes and
			aRoll.aRollCodes.nP == 1 and
			aRoll.aRollCodes.nT == 0 then
		aMessage.dicedisplay = 0;
	end
	return aMessage;
end

function fpDieCodeLex(sDiceString)
	if not sDiceString then
		return false;
	end
	local bSkip = false;
	local sChar = "";
	local sNextChar = "";
	local sTokenValue = "";
	local sTokenType = "";
	local bPrevDie = false;
	local bPool = false;
	aTokens = {};
	local aRollCodes = {nK = 0,nP = 0,nR = 0,nS = 0,nSN = 0,nT = 0,nTN = 0,nX1 = 0,nX2 = 0,nZ = 0};
	i=1;
	while i < #sDiceString+1 do
		sChar = sDiceString:sub(i,i):lower();
		sNextChar = nil;
		if i ~= #sDiceString then
			sNextChar = sDiceString:sub(i+1,i+1):lower();
		end
		if sChar == "r" then
			aRollCodes.nR = 1;
			i=i+1;
		elseif sChar == "=" then
			if sNextChar == "r" then
				i=i+1;
			else
				i = 9998;
				bSkip = true;
			end
		elseif sChar == "!" then
			local sSides = aTokens[#aTokens].sValue:sub(2);
			local nSides = tonumber(sSides) or 0;
			aRollCodes.nX1,aRollCodes.nX2,i = fpLexExplode(sDiceString,sNextChar,i,nSides);
		else
			if fpIsNDigit(sChar) then
				sTokenValue,sTokenType,i = fpLexDigit(sDiceString,sChar,sNextChar,i);
			elseif sChar == "d" then
				if bPool and bPrevDie then
					i = 9998;
					bSkip = true;
				else
					sTokenValue,sTokenType,i = fpLexDCode(sDiceString,sNextChar,i);
					bPrevDie = true;
				end
			elseif sChar == "+" then
				if sNextChar == "r" then
					aRollCodes.nR = 1;
					i=i+1;
					bSkip = true;
				else
					sTokenValue,sTokenType,i,bPrevDie = fpLexAddOp(sDiceString,sChar,sNextChar,i,bPool,bPrevDie);
					bSkip = (sTokenValue == "0");
				end
			elseif sChar == "-" then
				if sNextChar == "r" then
					aRollCodes.nR = -1;
					i=i+1;
					bSkip = true;
				else
					sTokenValue,sTokenType,i,bPrevDie = fpLexAddOp(sDiceString,sChar,sNextChar,i,bPool,bPrevDie);
					bSkip = (sTokenValue == "0");
				end
			elseif StringManager.contains(aMultOps,sChar) then
				sTokenValue,sTokenType,i = fpLexMultOp(sChar,sNextChar,i);
			elseif StringManager.contains(aKeepCodes,sChar) then
				sTokenValue,sTokenType,i = fpLexKeepCode(sChar,sNextChar,"+",i)
			elseif sChar == "t" then
				sTokenValue,sTokenType,i = fpLexTNCode(sChar,sNextChar,"+",i);
			elseif sChar == "s" then
				sTokenValue,sTokenType,i = fpLexSuccessCode(sNextChar,i);
			elseif sChar == "(" then
				sTokenValue,sTokenType,i = fpLexLParan(sNextChar,i);
			elseif sChar == ")" then
				sTokenValue,sTokenType,i = fpLexRParan(sNextChar,i);
			elseif sChar == "p" then
				if fpIsNDigit(sNextChar) then
					aRollCodes.nP = 1;
				elseif sNextChar == "d" then
					aRollCodes.nP = 1;
					sTokenValue = "1";
					sTokenType = "n";
				else
					i = 9998;
					bSkip = true;
				end
			end
			if sTokenValue == nil then
				i = 9998;
				bSkip = true;
			end
			if not bSkip then
				table.insert(aTokens,{sValue = sTokenValue,sType = sTokenType});
			end
			bSkip = false;
		end
		i=i+1;
	end
	if i == 9999 then
		return false;
	end
	return aRollCodes;
end

function fpDieCodeParse(aRollCodes)
	if not aRollCodes then
		return false,false;
	end
	local aRPN = {};
	local aStack = {};
	local bDiv = false;
	local nDice = 0;
	i=1;
	while i < #aTokens+1 do
		if aTokens[i].sType == "n" then
			if i ~= #aTokens and
					aTokens[i+1].sType == "d" then
				aTokens[i+1].sValue = aTokens[i].sValue .. aTokens[i+1].sValue;
				nDice = nDice+tonumber(aTokens[i].sValue);
			else
				table.insert(aRPN,{sValue = tonumber(aTokens[i].sValue),sType = "n"});
			end
		elseif aTokens[i].sType == "d" then
			table.insert(aRPN,{sValue = aTokens[i].sValue,sType = "d"});
		elseif aTokens[i].sType == "m" then
			bDiv = (bDiv or aTokens[i].sValue == "/");
			if aStack[#aStack] then
				local sType = aStack[#aStack].sType;
				local sValue = aStack[#aStack].sValue;
				while sType == "m" do
					table.insert(aRPN,{sValue = sValue,sType = "m"});
					table.remove(aStack,#aStack);
					if aStack[#aStack] then
						sType = aStack[#aStack].sType;
						sValue = aStack[#aStack].sValue;
					else
						sType = "";
					end
				end
			end
			table.insert(aStack,{sValue = aTokens[i].sValue,sType = "m"});
		elseif aTokens[i].sType == "a" then
			if aStack[#aStack] then
				local sType = aStack[#aStack].sType;
				local sValue = aStack[#aStack].sValue;
				while sType =="m" or sType == "a" do
					table.insert(aRPN,{sValue = sValue,sType = sType});
					table.remove(aStack,#aStack);
					if aStack[#aStack] then
						sType = aStack[#aStack].sType;
						sValue = aStack[#aStack].sValue;
					else
						sType = "";
					end
				end
			end
			table.insert(aStack,{sValue = aTokens[i].sValue,sType = "a"});
		elseif aTokens[i].sType == "(" then
			table.insert(aStack,{sValue = "(",sType = "("});
		elseif aTokens[i].sType == ")" then
			if aStack[#aStack] then
				local sType = aStack[#aStack].sType;
				local sValue = aStack[#aStack].sValue;
				while sType ~= "(" do
					table.insert(aRPN,{sValue = sValue,sType = sType});
					table.remove(aStack,#aStack);
					if #aStack == 0 then
						return false,false;
					end
					if aStack[#aStack] then
						sType = aStack[#aStack].sType;
						sValue = aStack[#aStack].sValue;
					else
						sType = "";
					end
				end
				table.remove(aStack,#aStack);
			else
				return false,false;
			end
		elseif aTokens[i].sType == "k" then
			if i ~= #aTokens and
					aTokens[i+1].sType == "n" then
				local nKDice = tonumber(aTokens[i+1].sValue);
				if nKDice < nDice then
					if aTokens[i].sValue == "+k" or
							aTokens[i].sValue == "+h" then
						aRollCodes.nK = nKDice;
					elseif aTokens[i].sValue == "-k" or
							aTokens[i].sValue == "+l" then
						aRollCodes.nK = 0-nKDice;
					elseif aTokens[i].sValue == "-h" then
						aRollCodes.nK = nKDice-nDice;
					elseif aTokens[i].sValue == "-l" then
						aRollCodes.nK = nDice-nKDice;
					end
				end
				i=i+1;
			else
				return false,false;
			end
		elseif aTokens[i].sType == "t" then
			if i ~= #aTokens and
					aTokens[i+1].sType == "n" then
				aRollCodes.nTN = tonumber(aTokens[i+1].sValue);
				aRollCodes.nT = 1;
				if aTokens[i].sValue == "-t" then
					aRollCodes.nT = -1;
				end
				i=i+1;
			end
		elseif aTokens[i].sType == "s" then
			if aRollCodes.nT ~= 0 and
					i ~= #aTokens and
					aTokens[i+1].sType == "n" then
				aRollCodes.nS = 1;
				aRollCodes.nSN = tonumber(aTokens[i+1].sValue);
			end
			i=i+1;
		end
		i=i+1;
	end
	i=#aStack;
	while i > 0 do
		local sType = aStack[#aStack].sType;
		if sType == "(" then
			return false,false;
		end
		table.insert(aRPN,{sValue = aStack[#aStack].sValue,sType = aStack[#aStack].sType});
		table.remove(aStack,#aStack);
		i=i-1;
	end
	if not bDiv then
		aRollCodes.nR = 0;
	end
	return aRollCodes,aRPN;
end

function fpDieRollResult(aSource,aTarget,aRoll)
	if not aRoll.aRollCodes or
			aRoll.aRollCodes.nX1 == 0 then
		Comm.deliverChatMessage(fpCreateActionMessage(aSource,aRoll));
	end
	return;
end

function fpHandleExplodingDice(aSource,aRoll)
	local aNewRollDice = {};
	local aRollCodes = aRoll.aRollCodes;
	local bX1 = false;
	local bZ = false;
	local aDice = aRoll.aDice;
	if aRoll.aRollCodes.nZ == 1 then
		bZ = true;
		aDice = aRoll.aNSD;
	end
	if aRollCodes.nX and
			aRollCodes.nX1 == -1 then
		if aRoll.aOldResults then
			local i=1;
			for nIteration,vValue in ipairs(aRoll.aOldResults) do
				vValue.result = vValue.result+aDice[i].result;
				if not bZ then
					vValue.type = "p" .. vValue.type:sub(2);
				end
				i=i+1;
			end
		else
			aRoll.aOldResults = aDice;
		end
		if fpTotalDice(aDice) == fpTotalDiceMax(aDice) then
			for nIteration,vValue in ipairs(aDice) do
				table.insert(aNewRollDice,vValue.type);
			end
			bX1 = true;
		end
	elseif aRollCodes.nX1 < -1 then
		local aOldResults = aRoll.aOldResults;
		if aOldResults then
			local i=1;
			for nIteration,vValue in ipairs(aOldResults) do
				if vValue.check == 1 then
					vValue.result = vValue.result+aDice[i].result;
					if not bZ then
						vValue.type = "p" .. vValue.type:sub(2);
					end
					aDice[i].position = vValue.position;
					vValue.check = 0;
					i=i+1;
				end
			end
		else
			table.sort(aDice,function(a,b) return a.result > b.result end);
			for nIteration,vValue in ipairs(aDice) do
				vValue.check = 0;
				vValue.position = nIteration;
			end
			aOldResults = aDice;
		end
		for kKey,vValue in pairs(aDice) do
			if not vValue.position then
				vValue.position = 0;
			end
		end
		table.sort(aDice,function(a,b) return a.result > b.result end);
		local i=1;
		while i < #aDice+aRollCodes.nX1+2 do
			local j=i;
			while aDice[j].result == aDice[j+1].result do
				j=j+1;
				if i-j-1 == aRollCodes.nX1 then
					for k=i,j do
						table.insert(aNewRollDice,aDice[k].type);
						for kKey,vValue in pairs(aOldResults) do
							if vValue.position == aDice[k].position then
								vValue.check = 1;
								break;
							end
						end
					end
					bX1 = true;
					break;
				end
			end
			i=j+1;
		end
		aRoll.aOldResults = aOldResults;
	else
		if aRoll.aOldResults then
			local i=1;
			for nIteration,vValue in ipairs(aRoll.aOldResults) do
				if vValue.check == 1 then
					if aDice[i].result < aRollCodes.nX1 or
							aDice[i].result > aRollCodes.nX2 then
						vValue.check = 0;
					end
					vValue.result = vValue.result+aDice[i].result;
					if not bZ then
						vValue.type = "p" .. vValue.type:sub(2);
					end
					i=i+1;
				end
			end
		else
			aRoll.aOldResults = aDice;
			for kKey,vValue in pairs(aRoll.aOldResults) do
				vValue.check = 0;
				if vValue.result >= aRollCodes.nX1 and
						vValue.result <= aRollCodes.nX2 then
					vValue.check = 1;
				end
			end
		end
		for nIteration,vValue in ipairs(aDice) do
			if vValue.result >= aRollCodes.nX1 and
					vValue.result <= aRollCodes.nX2 then
				table.insert(aNewRollDice,vValue.type);
				bX1 = true;
			end
		end
	end
	if bX1 then
		local aNewRoll = aRoll;
		aNewRoll.aDice = aNewRollDice;
-- NEED TO CHECK THIS NEXT LINE (& FUNCTION)
		Comm.throwDice(fpBuildThrow(aSource,nil,aNewRoll,false));
		return;
	end
	if bZ then
		aRoll.aNSD = aRoll.aOldResults;
	else
		aRoll.aDice = aRoll.aOldResults;
	end
	aRoll.aOldResults = nil;
	aRoll.aRollCodes.nX1 = 0;
	return aRoll.aSource,aRoll;
end

function fpHandleKeepDice(aRoll)
	local nKeep = math.abs(aRoll.aRollCodes.nK);
	if aRoll.aRollCodes.nK < 0 then
		table.sort(aRoll.aDice,function(a,b) return a.result < b.result end);
	elseif aRoll.aRollCodes.nK > 0 then
		table.sort(aRoll.aDice,function(a,b) return a.result > b.result end);
	end
	for nIteration,vValue in ipairs(aRoll.aDice) do
		if nIteration > nKeep then
			vValue.type = "r" .. vValue.type:sub(2);
		elseif vValue.type:sub(1,1) ~= "p" then
			vValue.type = "g" .. vValue.type:sub(2);
		end
	end
	return aRoll;
end

function fpHandleModStack(aRoll)
	table.insert(aRoll.aRPN,{sValue = tostring(math.abs(aRoll.nMod)),sType = "n"});
	if aRoll.nMod > 0 then
		table.insert(aRoll.aRPN,{sValue = "+",sType = "a"});
	else
		table.insert(aRoll.aRPN,{sValue = "-",sType = "a"});
	end
	return aRoll;
end

function fpHandleSuccessCount(sDesc,nT,nTN,nSN,nTotal)
	if nSN == 0 then
		if nT == -1 then
			if nTotal > nTN then
				return sDesc .. " - Failed By " .. nTotal-nTN;
			else
				return sDesc .. " - Succeeded By " .. nTN-nTotal;
			end
		elseif nTotal < nTN then
			return sDesc .. " - Failed By " .. nTN-nTotal;
		else
			return sDesc .. " - Succeeded By " .. nTotal-nTN;
		end
	elseif nT == -1 then
		if nTotal > nTN then
			if math.floor((nTotal-nTN)/nSN) == 1 then
				return sDesc .. " - Failed By 1 Lower";
			else
				return sDesc .. " - Failed By " .. math.floor((nTotal-nTN)/nSN) .." Lowers";
			end
		elseif math.floor((nTN-nTotal)/nSN) == 1 then
			return sDesc .. " - Succeeded By 1 Raise";
		else
			return sDesc .. " - Succeeded By " .. math.floor((nTN-nTotal)/nSN) .." Raises";
		end
	elseif nTotal < nTN then
		if math.floor((nTN-nTotal)/nSN) == 1 then
			return sDesc .. " - Failed By 1 Lower";
		else
			return sDesc .. " - Failed By " .. math.floor((nTN-nTotal)/nSN) .." Lowers";
		end
	elseif math.floor((nTotal-nTN)/nSN) == 1 then
		return sDesc .. " - Succeeded By 1 Raise";
	else
		return sDesc .. " - Succeeded By " .. math.floor((nTotal-nTN)/nSN) .." Raises";
	end
	return sDesc;
end

function fpHandleTargetNumber(aRoll)
	local aRollCodes = aRoll.aRollCodes;
	local nK = math.abs(aRollCodes.nK);
	if aRollCodes.nP == 1 then
		aRoll.nTotal = 0;
		if nK == 0 then
			nK = #aRoll.aDice;
		end
		for nIteration,vValue in ipairs(aRoll.aDice) do
			if nIteration <= nK then
				if aRollCodes.nT == -1 then
					if vValue.result > aRollCodes.nTN then
						vValue.type = "r" .. vValue.type:sub(2);
					else
						aRoll.nTotal = aRoll.nTotal+1;
						if vValue.type:sub(1,1) ~= "p" then
							vValue.type = "g" .. vValue.type:sub(2);
						end
					end
				elseif vValue.result < aRollCodes.nTN then
					vValue.type = "r" .. vValue.type:sub(2);
				else
					aRoll.nTotal = aRoll.nTotal+1;
					if vValue.type:sub(1,1) ~= "p" then
						vValue.type = "g" .. vValue.type:sub(2);
					end
				end
			end
		end
	else
		if aRollCodes.nS and
				aRollCodes.nS == 1 then
			local nSN = 0;
			if aRollCodes.nSN and
					aRollCodes.nSN ~= 0 then
				nSN = aRollCodes.nSN;
			end
			aRoll.sDesc = fpHandleSuccessCount(aRoll.sDesc,aRollCodes.nT,aRollCodes.nTN,nSN,aRoll.nTotal);
		end
		if aRollCodes.nT == -1 then
			if aRoll.nTotal > aRollCodes.nTN then
				aRoll.sDesc = aRoll.sDesc .. " - Fail!";
				for nIteration,vValue in ipairs(aRoll.aDice) do
					vValue.type = "r" .. vValue.type:sub(2);
				end
			else
				aRoll.sDesc = aRoll.sDesc .. " - Success!";
				for nIteration,vValue in ipairs(aRoll.aDice) do
					if vValue.type:sub(1,1) ~= "p" and
							vValue.type:sub(1,1) ~= "r" then
						vValue.type = "g" .. vValue.type:sub(2);
					end
				end
			end
		elseif aRoll.nTotal < aRollCodes.nTN then
			aRoll.sDesc = aRoll.sDesc .. " - Fail!";
			for nIteration,vValue in ipairs(aRoll.aDice) do
				vValue.type = "r" .. vValue.type:sub(2);
			end
		else
			aRoll.sDesc = aRoll.sDesc .. " - Success!";
			for nIteration,vValue in ipairs(aRoll.aDice) do
				if vValue.type:sub(1,1) ~= "p" and
						vValue.type:sub(1,1) ~= "r" then
					vValue.type = "g" .. vValue.type:sub(2);
				end
			end
		end
	end
	return aRoll;
end

function fpIsDigit(sChar)
	if fpIsNDigit(sChar) or
			sChar == "0" then
		return true;
	end
	return false;
end

function fpIsNDigit(sChar)
	local aDigits = {
		["1"] = true,
		["2"] = true,
		["3"] = true,
		["4"] = true,
		["5"] = true,
		["6"] = true,
		["7"] = true,
		["8"] = true,
		["9"] = true,
		};
	if aDigits[sChar] then
		return true;
	end
	return false;
end

function fpLexAddOp(sTmp,sChar,sNextChar,i,bPool,bPrevDie)
	if sNextChar == "0" then
		return "0",nil,i+1,bPrevDie;
	elseif fpIsNDigit(sNextChar) then
		return sChar,"a",i,bPrevDie;
	elseif StringManager.contains(aKeepCodes,sNextChar) then
		local sNextNextChar = nil;
		if i < #sTmp-1 then
			sNextNextChar = sTmp:sub(i+2,i+2):lower();
		end
		local sTokenValue,sTokenType,k = fpLexKeepCode(sNextChar,sNextNextChar,sChar,i+1)
		return sTokenValue,sTokenType,k,bPrevDie;
	elseif sNextChar == "d" then
		local sNextNextChar = nil;
		if i < #sTmp-1 then
			sNextNextChar = sTmp:sub(i+2,i+2):lower();
		end
		table.insert(aTokens,{sValue = sChar,sType = "a"});
		table.insert(aTokens,{sValue = "1",sType = "n"});
		if bPool and bPrevDie then
			return "0",nil,9998,true;
		end
		return fpLexDCode(sTmp,sNextNextChar,i+1),true;
	elseif sNextChar == "p" or
			sNextChar == "(" then
		return sChar,"a",i,bPrevDie;
	elseif sNextChar == "t" then
		local sNextNextChar = nil;
		if i < #sTmp-1 then
			sNextNextChar = sTmp:sub(i+2,i+2):lower();
		end
		local sTokenValue,sTokenType,k = fpLexTNCode(sNextChar,sNextNextChar,sChar,i+1);
		return sTokenValue,sTokenType,k,bPrevDie;
	elseif sNextChar == "-" then
		if sChar == "-" then
			return "+","a",i+1,bPrevDie;
		end
		return "-","a",i+1,bPrevDie;
	end
	return nil,nil,i,bPrevDie;
end

function fpLexDCode(sTmp,sNextChar,i)
	local sTokenValue;
	if i == 1 then
		table.insert(aTokens,{sValue = "1",sType = "n"});
	end
	if sNextChar == nil then
		return nil,nil,i;
	end
	if sNextChar == "%" then
		sTokenValue = "d100";
		i=i+1;
	elseif sNextChar == "f" or
			sNextChar == "g" then
		sTokenValue = "d" .. sNextChar:upper();
		i=i+1;
	else
		local sTmpValue;
		sTmpValue,i = fpLexNextDigit(sTmp,sNextChar,i+1);
		sTokenValue = "d" .. sTmpValue;
	end
	return sTokenValue,"d",i;
end

function fpLexDigit(sTmp,sChar,sNextChar,i)
	local sTokenValue;
	sTokenValue,i = fpLexNextDigit(sTmp,sNextChar,i+1)
	return sChar .. sTokenValue,"n",i;
end

function fpLexExplode(sDiceString,sNextChar,i,nSides)
	if sNextChar == "=" then
		return -1,0,i+1;
	elseif sNextChar == "!" then
		local nCount = -2;
		local j=i+1;
		while j < #sDiceString+1 and
				sDiceString:sub(j+1,j+1) == "!" do
			j=j+1;
			nCount = nCount-1;
		end
		return nCount,0,j;
	elseif fpIsDigit(sNextChar) then
		local sTmpValue1;
		local sTmpValue2 = "0";
		sTmpValue1,i = fpLexNextDigit(sDiceString,sNextChar,i+1);
		if i < #sDiceString-1 and
				sDiceString:sub(i+1,i+1) == "!" then
			sTmpValue2,i = fpLexNextDigit(sDiceString,sDiceString:sub(i+2,i+2),i+2);
		end
		if sTmpValue2 == "0" then
			sTmpValue2 = sTmpValue1;
		end
		local nTmpValue1 = tonumber(sTmpValue1);
		local nTmpValue2 = tonumber(sTmpValue2);
		if nTmpValue1 == 1 and
				nTmpValue2 == nSides then
			return 0,0,9998
		end
		return tonumber(sTmpValue1),tonumber(sTmpValue2),i;
	end
	return nSides,nSides,i;
end

function fpLexKeepCode(sChar,sNextChar,sPrevChar,i)
	local aKeepCodeLookupTable = {
		r = true,
		t = true,
		["+"] = true,
		["-"] = true,
		["="] = true
		};
	if sNextChar == nil or
			aKeepCodeLookupTable[sNextChar] then
		table.insert(aTokens,{sValue = sPrevChar .. sChar,sType = "k"});
		return "1","n",i;
	elseif fpIsNDigit(sNextChar) then
		return sPrevChar .. sChar,"k",i;
	end
	return nil,nil,i;
end

function fpLexLParan(sNextChar,i)
	if StringManager.contains(aMultOps,sNextChar) then
		return nil,nil,i;
	elseif sNextChar == "d" then
		table.insert(aTokens,{sValue = "(",sType = "("});
		return "1","n",i;
	end
	return "(","(",i;
end

function fpLexMultOp(sChar,sNextChar,i)
	local sTokenValue = sChar;
	if sTokenValue == "x" then
		sTokenValue = "*";
	end
	if i > 1 then
		if fpIsNDigit(sNextChar) or
				sNextChar == "p" or
				sNextChar == "-" or
				sNextChar == "(" then
			return sTokenValue,"m",i;
		elseif sNextChar == "d" then
			table.insert(aTokens,{sValue = sTokenValue,sType = "m"});
			return "1","n",i;
		end
	end
	return nil,nil,i;
end

function fpLexNextDigit(sTmp,sNextChar,i)
	local sTmpValue;
	if fpIsDigit(sNextChar) then
		if i ~= #sTmp then
			sTmpValue,_,i = fpLexDigit(sTmp,sNextChar,sTmp:sub(i+1,i+1):lower(),i);
			return sTmpValue,i;
		else
			return sNextChar,i;
		end
	end
	return "",i-1;
end

function fpLexRParan(sNextChar,i)
	local aRParanLookupTable = {
		h = true,
		k = true,
		l = true,
		r = true,
		t = true,
		x = true,
		["+"] = true,
		["-"] = true,
		["*"] = true,
		["/"] = true,
		["="] = true
		};
	if sNextChar == nil then
		return ")",")",i;
	elseif aRParanLookupTable[sNextChar] then
		return ")",")",i;
	end
	return nil,nil,i;
end

function fpLexSuccessCode(sNextChar,i)
	if sNextChar == nil then
		table.insert(aTokens,{sValue = "s",sType = "s"});
		return "0","n",i;
	end
	return "s","s",i;
end

function fpLexTNCode(sChar,sNextChar,sPrevChar,i)
	if fpIsNDigit(sNextChar) then
		return sPrevChar .. sChar,"t",i;
	end
	return nil,nil,i;
end

function fpOnDiceLanded(oDragData)
	local sDragType = oDragData.getType();
	local aCustom = oDragData.getCustomData();
	if GameSystem.actions[sDragType] then
		local aSource,aRolls,aTargets = ActionsManager.decodeActionFromDrag(oDragData,true);
		for nIteration,vValue in ipairs(aRolls) do
			if #(vValue.aDice) > 0 then
				vValue.aRollCodes = aCustom.aRollCodes;
				vValue.aRPN = aCustom.aRPN;
				vValue.aNSD = aCustom.aNSD;
				vValue.aOldResults = aCustom.aOldResults;
				ActionsManager.handleResolution(vValue,aSource,aTargets);
			end
		end
		return true;
	end
end

function fpOnDiceTotal(aMessage)
	local aStrings,_ = StringManager.split(aMessage.type,"|");
	if aStrings[1] == "normal" then
		return true,tonumber(aStrings[2]);
	end
	return false,0;
end

function fpProcessDie(sCommand,sDieCode)
	if User.isHost() then
		if sDieCode == "reveal" then
			OptionsManager.setOption("REVL","on");
			ChatManager.SystemMessage(Interface.getString("message_slashREVLon"));
			return;
		end
		if sDieCode == "hide" then
			OptionsManager.setOption("REVL","off");
			ChatManager.SystemMessage(Interface.getString("message_slashREVLoff"));
			return;
		end
	end
	local sDice,_ = string.match(sDieCode,"%s*(%S+)%s*(.*)");
	local aRollCodes,_ = fpDieCodeParse(fpDieCodeLex(sDice));
	if not aRollCodes then
		ChatManager.SystemMessage("Usage: /die [DieCode] [description]");
		return;
	end
	ActionsManager.actionDirect(nil,"dice",{fpDieAndTowerHelper(sDieCode,0,true,false,"")});
end

function fpPostRoll(aSource,aRoll)
	if aRoll.aRollCodes then
		local aRollCodes = aRoll.aRollCodes;
		if aRollCodes.nZ and
				aRollCodes.nZ == 2 then
			aRoll.aDice[1].result = aRoll.aDice[1].result*10;
		end
		if aRollCodes.nX1 and
				aRollCodes.nX1 ~= 0 then
			aSource,aRoll = fpHandleExplodingDice(aSource,aRoll);
		end
		if aRollCodes.nZ and
				aRollCodes.nZ == 1 then
			aRoll.aDice = aRoll.aNSD;
		end
		if aRoll then
			local nK = 0;
			local nR = 0;
			if aRollCodes.nK and
					aRollCodes.nK ~= 0 then
				nK = math.abs(aRollCodes.nK);
				aRoll = fpHandleKeepDice(aRoll);
			end
			if aRollCodes.nR then
				if aRollCodes.nR < 0 then
					nR = -1;
				elseif aRollCodes.nR > 0 then
					nR = 1;
				end
			end
			aRoll = fpTotalRPNStack(fpHandleModStack(aRoll),nK,nR);
			if aRollCodes.nT and
					aRollCodes.nTN and
					aRollCodes.nT ~= 0 then
				aRoll = fpHandleTargetNumber(aRoll);
			end
		end
		if aRollCodes.nZ and
				aRollCodes.nZ == 1 then
			aRoll.aDice = {};
		end
	end
	return aRoll;
end

function fpSetKCode()
	local oKeepDiceBoxWindow = Interface.findWindow("wcKeepDiceBox","");
	local nK = 0;
	if oKeepDiceBoxWindow then
		nK,_ = KeepDiceBoxManager.fpGetKeepDice();
		if oKeepDiceBoxWindow.bcKeepHighButton and
				oKeepDiceBoxWindow.bcKeepHighButton.getValue() == 1 then
			nK = 0-nK;
		end
	end
	return nK;
end

function fpSetPCode()
	local oKeepDiceBoxWindow = Interface.findWindow("wcKeepDiceBox","");
	local nP = 0;
	if oKeepDiceBoxWindow then
		if oKeepDiceBoxWindow.bcPoolButton then
			nP = oKeepDiceBoxWindow.bcPoolButton.getValue();
		end
	end
	return nP;
end

function fpSetRollCodesFromDesktop(aSource,aTarget,aRoll)
	if aRoll.aRollCodes == nil then
		aRoll.aRollCodes = {};
	end
	if aRoll.aRollCodes.nK == nil then
		aRoll.aRollCodes.nK = fpSetKCode();
	end
	if aRoll.aRollCodes.nP == nil then
		aRoll.aRollCodes.nP = fpSetPCode();
	end
	if aRoll.aRollCodes.nR == nil then
		aRoll.aRollCodes.nR = 0;
	end
	if aRoll.aRollCodes.nS == nil then
		aRoll.aRollCodes.nS,aRoll.aRollCodes.nSN = fpSetSCode();
	end
	if aRoll.aRollCodes.nT == nil then
		aRoll.aRollCodes.nT,aRoll.aRollCodes.nTN = fpSetTCode();
	end
	if aRoll.aRollCodes.nX1 == nil then
		aRoll.aRollCodes.nX1 = fpSetX1Code();
	end
	if aRoll.aRollCodes.nX2 == nil then
		aRoll.aRollCodes.nX2 = 0;
	end
	if aRoll.aRollCodes.nZ == nil then
		aRoll.aRollCodes.nZ = 0;
	end
	return;
end

function fpSetSCode()
	local oSuccessRaiseBoxWindow = Interface.findWindow("wcSuccessRaiseBox","");
	local nS = 0;
	local nSN = 0;
	if oSuccessRaiseBoxWindow and
			SuccessRaiseBoxManager.fpIsActive() then
		nS = 1;
		nSN = SuccessRaiseBoxManager.fpGetRaises();
	end
	return nS,nSN;
end

function fpSetTCode()
	local oTNBoxWindow = Interface.findWindow("wcTNBox","");
	local nT = 0;
	local nTN = 0;
	if oTNBoxWindow and
			TNBoxManager.fpIsActive() then
		nT = 1;
		if oTNBoxWindow.bcAboveBelowButton and
				oTNBoxWindow.bcAboveBelowButton.getValue() == 1 then
			nT = -1;
		end
		nTN,_ = TNBoxManager.fpGetTN();
	end
	return nT,nTN;
end

function fpSetX1Code()
	local oModWindow = Interface.findWindow("modifierstack","");
	local nX1 = 0;
	if oModWindow then
		if oModWindow.bcExplodeButton then
			nX1 = oModWindow.bcExplodeButton.getValue();
		end
	end
	return nX1;
end

function fpTotalDice(aDice)
	local nTotal = 0;
	for nIteration,vValue in ipairs(aDice) do
		nTotal = nTotal+vValue.result;
	end
	return nTotal;
end

function fpTotalDiceMax(aDice)
	local nTotal = 0;
	for nIteration,vValue in ipairs(aDice) do
		nTotal = nTotal+tonumber(vValue.type:sub(2));
	end
	return nTotal;
end

function fpTotalRPNStack(aRoll,nK,nR)
	local aStack = {};
	local bPool = false;
	local nMod = 0;
	local nPrevDice = 0;
	if aRoll.aRollCodes and
			aRoll.aRollCodes.nP and
			aRoll.aRollCodes.nP == 1 then
		bPool = true;
	end
	for i=1,#aRoll.aRPN do
		if aRoll.aRPN[i].sType == "a" or
					aRoll.aRPN[i].sType == "m" then
			local sOperator = aRoll.aRPN[i].sValue;
			local nOp2Value = aStack[#aStack].nValue;
			local sOp2Type = aStack[#aStack].sType;
			table.remove(aStack,#aStack);
			local nOp1Value = aStack[#aStack].nValue;
			local sOp1Type = aStack[#aStack].sType;
			table.remove(aStack,#aStack);
			local nTotal = 0;
			if sOp1Type ~= "p" then
				if sOp2Type ~= "p" then
					if sOperator == "+" then
						nTotal = nOp1Value + nOp2Value;
					elseif sOperator == "-" then
						nTotal = nOp1Value - nOp2Value;
					elseif sOperator == "*" then
						nTotal = nOp1Value * nOp2Value;
					elseif nR == 0 then
						nTotal = math.floor((nOp1Value / nOp2Value)+0.5);
					elseif nR == -1 then
						nTotal = math.floor(nOp1Value / nOp2Value);
					else
						nTotal = math.ceil(nOp1Value / nOp2Value);
					end
					table.insert(aStack,{nValue = nTotal,sType = "n"});
				else
					if sOperator == "+" then
						for j=1,#aRoll.aDice do
							aRoll.aDice[j].result = nOp1Value + aRoll.aDice[j].result;
						end
					elseif sOperator == "-" then
						for j=1,#aRoll.aDice do
							aRoll.aDice[j].result = nOp1Value - aRoll.aDice[j].result;
						end
					elseif sOperator == "*" then
						for j=1,#aRoll.aDice do
							aRoll.aDice[j].result = nOp1Value * aRoll.aDice[j].result;
						end
					elseif nR == 0 then
						for j=1,#aRoll.aDice do
							aRoll.aDice[j].result = math.floor((nOp1Value / aRoll.aDice[j].result)+0.5);
						end
					elseif nR == -1 then
						for j=1,#aRoll.aDice do
							aRoll.aDice[j].result = math.floor(nOp1Value / aRoll.aDice[j].result);
						end
					else
						for j=1,#aRoll.aDice do
							aRoll.aDice[j].result = math.ceil(nOp1Value / aRoll.aDice[j].result);
						end
					end
					table.insert(aStack,{nValue = 0,sType = "p"});
				end
			else
				if sOperator == "+" then
					for j=1,#aRoll.aDice do
						aRoll.aDice[j].result = aRoll.aDice[j].result + nOp2Value;
					end
				elseif sOperator == "-" then
					for j=1,#aRoll.aDice do
						aRoll.aDice[j].result = aRoll.aDice[j].result - nOp2Value;
					end
				elseif sOperator == "*" then
					for j=1,#aRoll.aDice do
						aRoll.aDice[j].result = aRoll.aDice[j].result * nOp2Value;
					end
				elseif nR == 0 then
					for j=1,#aRoll.aDice do
						aRoll.aDice[j].result = math.floor((aRoll.aDice.result / nOp2Value)+0.5);
					end
				elseif nR == -1 then
					for j=1,#aRoll.aDice do
						aRoll.aDice[j].result = math.floor(aRoll.aDice[j].result / nOp2Value);
					end
				else
					for j=1,#aRoll.aDice do
						aRoll.aDice[j].result = math.ceil(aRoll.aDice[j].result / nOp2Value);
					end
				end
				table.insert(aStack,{nValue = 0,sType = "p"});
			end
		elseif aRoll.aRPN[i].sType == "n" then
			local nValue = tonumber(aRoll.aRPN[i].sValue)
			if aRoll.aRPN[i+1].sType == "a" then
				if aRoll.aRPN[i+1].sValue == "+" then
					nMod = nMod + nValue;
				else
					nMod = nMod - nValue;
				end
			elseif aRoll.aRPN[i+1].sType == "n" or
					aRoll.aRPN[i+1].sType == "d" then
				if aRoll.aRPN[i+2].sType == "a" then
					nMod = nMod + nValue;
				end
			end
			table.insert(aStack,{nValue = nValue,sType = "n"});
		elseif aRoll.aRPN[i].sType == "d" then
			if bPool then
				table.insert(aStack,{nValue = 0,sType = "p"});
			else
				local nTotal = 0;
				local nTheseDice = aRoll.aRPN[i].sValue:match("^(%d*)");
				if nK == 0 then
					nK = nTheseDice;
				end
				for j=nPrevDice+1,nPrevDice+nK do
					if aRoll.aDice[j] then
						nTotal = nTotal + aRoll.aDice[j].result;
					end
				end
				table.insert(aStack,{nValue = nTotal,sType = "d"});
				nPrevDice = nPrevDice + nTheseDice;
			end
		end
	end
	if not bPool then
		aRoll.nMod = nMod;
		aRoll.nTotal = aStack[1].nValue;
	end
	return aRoll;
end







function fpDieAndTowerHelper(sDieCode,nMod,bDiceCodeString,bTower,sTowerDesc)
	local sDice,sDesc = string.match(sDieCode,"%s*(%S+)%s*(.*)");
	local aRollCodes,aRPN = fpDieCodeParse(fpDieCodeLex(sDice));
	local aRulesetDice = Interface.getDice();
	local aFinalDice = {};
	local aNonStandardResults = {};
	for i=1,#aRPN do
		if aRPN[i].sType == "d" then
			local aDice,_ = fpConvertStringToDice(aRPN[i].sValue);
			for kKey,vValue in ipairs(aDice) do
				if StringManager.contains(aRulesetDice,vValue) then
					table.insert(aFinalDice,vValue);
				elseif vValue:sub(1,1) == "-" and
						StringManager.contains(aRulesetDice,vValue:sub(2)) then
					table.insert(aFinalDice,vValue);
				else
					local sSign,sDieSides = vValue:match("^([%-%+]?)d([%dG]+)");
					if sDieSides then
						local nResult = 0;
						if sDieSides == "G" then
							table.insert(aFinalDice,"d6");
							table.insert(aFinalDice,"d6");
							aRollCodes.nK = 0;
							aRollCodes.nP = 0;
							aRollCodes.nX1 = 0;
							aRollCodes.nZ = 2;
						else
							local nDieSides = tonumber(sDieSides) or 0;
							nResult = math.random(nDieSides);
							if sSign == "-" then
								nResult = 0-nResult;
							end
							table.insert(aNonStandardResults,{type = vValue, result = nResult});
--							table.insert(aNonStandardResults,string.format(" [%s=%d]",vValue,nResult));
--							table.insert aFinalDice()
							aRollCodes.nZ = 1;
						end
					end
				end
			end
		end
	end
	if bTower then
		sDesc = "[" .. Interface.getString("dicetower_tag") .. "] " .. sTowerDesc;
	elseif sDesc ~= "" then
		sDesc = string.format("%s (%s)",sDesc,sDice);
	else
		sDesc = sDice;
	end
--[[
	if #aNonStandardResults > 0 then
		sDesc = sDesc .. table.concat(aNonStandardResults,"");
	end
--]]
	return {sType = "dice",sDesc = sDesc,aDice = aFinalDice,nMod = nMod,bSecret = bTower,aRollCodes = aRollCodes,aRPN = aRPN,aNSD = aNonStandardResults,bDiceCodeString = bDiceCodeString};
end
