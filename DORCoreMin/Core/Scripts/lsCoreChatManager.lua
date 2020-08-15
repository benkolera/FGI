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
--
sLastWhisperer = nil;

function onInit()
	ChatManager.onSlashCommand = fpOnSlashCommand;
	Comm.registerSlashHandler("tower",fpProcessTowerDie);
	Comm.registerSlashHandler("whisper",fpProcessWhisper);
	Comm.registerSlashHandler("w",fpProcessWhisper);
	Comm.registerSlashHandler("reply",fpProcessReply);
	Comm.registerSlashHandler("r",fpProcessReply);
	Comm.registerSlashHandler("diecode-help",fpProcessDieCodeHelp);
	Comm.registerSlashHandler("rollcode-help",fpProcessDieCodeHelp);
	OOBManager.registerOOBMsgHandler(ChatManager.OOB_MSGTYPE_WHISPER,fpHandleWhisper);
	OOBManager.registerOOBMsgHandler(ChatManager.OOB_MSGTYPE_WHISPER,fpHandleWhisper);
end

function fpHandleWhisper(aMessageOOB)
	if not aMessageOOB.sender or
			not aMessageOOB.receiver or
			not aMessageOOB.text then
		return;
	end
	if User.isHost() then
		if aMessageOOB.sender == "" then
			return;
		end
		if aMessageOOB.receiver ~= "" and
				OptionsManager.isOption("SHPW","off") then
			return;
		end
	else
		if aMessageOOB.receiver == "" then
			return;
		end
		if not User.isOwnedIdentity(aMessageOOB.receiver) then
			return;
		end
	end
	local sSender,sReceiver;
	if aMessageOOB.sender == "" then
		sSender = RulesetOptions.NAME_OF_REFEREE;
	else
		sSender = User.getIdentityLabel(aMessageOOB.sender) or "<" .. Interface.getString("chat_unknown_string") .. ">";
	end
	if aMessageOOB.receiver == "" then
		sReceiver = RulesetOptions.NAME_OF_REFEREE;
	else
		sReceiver = User.getIdentityLabel(aMessageOOB.receiver) or "<" .. Interface.getString("chat_unknown_string") .. ">";
	end
	sLastWhisperer = sSender;
	local aMessage = {font = "whisperfont",text = "",sender="[w]"};
	if OptionsManager.isOption("PCHT","on") then
		if aMessageOOB.sender == "" then
			aMessage.icon = "portrait_gm_token";
		else
			aMessage.icon = "portrait_" .. aMessageOOB.sender .. "_chat";
		end
	else
		aMessage.sender = "[w] " .. sSender;
	end
	if User.isHost() then
		if aMessageOOB.receiver ~= "" then
			aMessage.sender = aMessage.sender .. " -> " .. sReceiver;
		end
	elseif #(User.getOwnedIdentities()) > 1 then
		aMessage.sender = aMessage.sender .. " -> " .. sReceiver;
	end
	aMessage.text = aMessage.text .. aMessageOOB.text;
	Comm.addChatMessage(aMessage);
end

function fpProcessDieCodeHelp()
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage(Interface.getString("sMessageSlashDieCodeHelp"));
	ChatManager.SystemMessage("===========");
	ChatManager.SystemMessage("Special Dice");
	ChatManager.SystemMessage("----------------------");
	ChatManager.SystemMessage("Ad% - Roll A lots of Percentile Dice");
	ChatManager.SystemMessage("Adf - Roll A lots of Fudge Dice");
	ChatManager.SystemMessage("dg - Roll d66 (Games Workshop-Style)");
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage("General Die Math");
	ChatManager.SystemMessage("---------------------------------");
	ChatManager.SystemMessage("AdN*B+C - Roll A lots of N-sided dice, multiply by B and add C");
	ChatManager.SystemMessage("AdN/B-C - Roll A lots of N-sided dice, divide by B (round off) and subtract C");
	ChatManager.SystemMessage("(AdN+B)*C - Roll A lots of N-sided dice, add B, then multiply the total by C");
	ChatManager.SystemMessage("AdM*BdN - Roll A lots of M-sided dice and multiply by B lots of N-sided dice");
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage("Pool Dice");
	ChatManager.SystemMessage("-----------------");
	ChatManager.SystemMessage("pAdN+B - Roll A lots of N-sided Pool Dice, adding B to each");
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage("Rounding");
	ChatManager.SystemMessage("-----------------");
	ChatManager.SystemMessage("AdN/B - Roll A lots of N-sided dice and divide by B, rounding off");
	ChatManager.SystemMessage("AdN/B=r - Roll A lots of N-sided dice and divide by B, rounding off");
	ChatManager.SystemMessage("AdN/Br - Roll A lots of N-sided dice and divide by B, rounding up");
	ChatManager.SystemMessage("AdN/B+r - Roll A lots of N-sided dice and divide by B, rounding up");
	ChatManager.SystemMessage("AdN/B-r - Roll A lots of N-sided dice and divide by B, rounding down");
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage("Keeping");
	ChatManager.SystemMessage("---------------");
	ChatManager.SystemMessage("AdNk - Roll A lots of N-sided dice and keep the highest die");
	ChatManager.SystemMessage("AdN+k - Roll A lots of N-sided dice and keep the highest die");
	ChatManager.SystemMessage("AdNkB - Roll A lots of N-sided dice and keep the highest B number of dice");
	ChatManager.SystemMessage("AdN+kB - Roll A lots of N-sided dice and keep the highest B number of dice");
	ChatManager.SystemMessage("AdN-k - Roll A lots of N-sided dice and keep the lowest die");
	ChatManager.SystemMessage("AdN-kB - Roll A lots of N-sided dice and keep the lowest B number of dice");
	ChatManager.SystemMessage("AdNh - Roll A lots of N-sided dice and keep the highest die");
	ChatManager.SystemMessage("AdN+h - Roll A lots of N-sided dice and keep the highest die");
	ChatManager.SystemMessage("AdNhB - Roll A lots of N-sided dice and keep the highest B number of dice");
	ChatManager.SystemMessage("AdN+hB - Roll A lots of N-sided dice and keep the highest B number of dice");
	ChatManager.SystemMessage("AdN-h - Roll A lots of N-sided dice and discard the highest die");
	ChatManager.SystemMessage("AdN-hB - Roll A lots of N-sided dice and discard the highest B number of dice");
	ChatManager.SystemMessage("AdNl - Roll A lots of N-sided dice and keep the lowest die");
	ChatManager.SystemMessage("AdN+l - Roll A lots of N-sided dice and keep the lowest die");
	ChatManager.SystemMessage("AdNlB - Roll A lots of N-sided dice and keep the lowest B number of dice");
	ChatManager.SystemMessage("AdN+lB - Roll A lots of N-sided dice and keep the lowest B number of dice");
	ChatManager.SystemMessage("AdN-l - Roll A lots of N-sided dice and discard the lowest die");
	ChatManager.SystemMessage("AdN-lB - Roll A lots of N-sided dice and discard the lowest B number of dice");
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage("Exploding");
	ChatManager.SystemMessage("------------------");
	ChatManager.SystemMessage("AdN! - Roll A lots of N-sided dice and explode each die on the highest possible result");
	ChatManager.SystemMessage("AdN!B - Roll A lots of N-sided dice and explode each die on a result of B");
	ChatManager.SystemMessage("AdN!B!C - Roll A lots of N-sided dice and explode each die on a result of B through C");
	ChatManager.SystemMessage("(AdN!)>B - Roll A lots of N-sided dice and explode each die on a result of B through to the Maximum"); -- NEW
	ChatManager.SystemMessage("(AdN!)<B - Roll A lots of N-sided dice and explode each die on a result of B through to the Minimum"); -- NEW
	ChatManager.SystemMessage("AdN!= - Roll A lots of N-sided dice and explode the total on the highest possible result");
	ChatManager.SystemMessage("AdN!! - Roll A lots of N-sided dice and explode on doubles");
	ChatManager.SystemMessage("AdN!!! - Roll A lots of N-sided dice and explode on triples, etc");
	ChatManager.SystemMessage("AdN!p - Roll A lots of N-sided dice and explode each die on the highest possible result, reducing by 1 each exploded Die (Hackmaster-Style)") -- NEW;
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage("Target Number");
	ChatManager.SystemMessage("----------------------------");
	ChatManager.SystemMessage("AdN>B - Roll A lots of N-sided dice and report a Success if the total >= B"); -- Removed "t" replaced by ">"
	ChatManager.SystemMessage("AdN+tB - Roll A lots of N-sided dice and report a Success if the total >= B"); -- REMOVE
	ChatManager.SystemMessage("AdN-tB - Roll A lots of N-sided dice and report a Success if the total <= B"); -- Removed "-t" replaced by "<"
	ChatManager.SystemMessage("AdNtBs - Roll A lots of N-sided dice and report the Degree of Success if the total >= B");
	ChatManager.SystemMessage("AdN+tBs - Roll A lots of N-sided dice and report the Degree of Success if the total >= B");
	ChatManager.SystemMessage("AdN-tBs - Roll A lots of N-sided dice and report the Degree of Success if the total <= B");
	ChatManager.SystemMessage("AdNtBsC - Roll A lots of N-sided dice and report the number of Successes & Raises (of C) if the total >= B");
	ChatManager.SystemMessage("AdN+tBsC - Roll A lots of N-sided dice and report the number of Successes & Raises (of C) if the total >= B");
	ChatManager.SystemMessage("AdN-tBsC - Roll A lots of N-sided dice and report the number of Successes & Raises (of C) if the total <= B");
--https://wiki.roll20.net/Dice_Reference
end

function fpOnSlashCommand(sCommand,vParameters)
	ChatManager.SystemMessage("");
	ChatManager.SystemMessage(Interface.getString("message_slashcommands"));
	ChatManager.SystemMessage("=================================");
	if User.isHost() then
		ChatManager.SystemMessage("/clear");
		ChatManager.SystemMessage("/console");
		ChatManager.SystemMessage("/day");
		ChatManager.SystemMessage("/die [DieCode] <message>");
		ChatManager.SystemMessage("/die hide");
		ChatManager.SystemMessage("/die reveal");
		ChatManager.SystemMessage("/diecode-help");
		ChatManager.SystemMessage("/emote [message]");
		ChatManager.SystemMessage("/export");
		ChatManager.SystemMessage("/exportchar");
		ChatManager.SystemMessage("/exportchar [name]");
		ChatManager.SystemMessage("/flushdb");
		ChatManager.SystemMessage("/gmid [name]");
		ChatManager.SystemMessage("/identity [name]");
		ChatManager.SystemMessage("/importchar");
		ChatManager.SystemMessage("/importnpc");
		ChatManager.SystemMessage("/lighting [RGB hex value]");
		ChatManager.SystemMessage("/mod [N] <message>");
		ChatManager.SystemMessage("/mood [mood] <message>");
		ChatManager.SystemMessage("/mood ([multiword mood]) <message>");
		ChatManager.SystemMessage("/ooc [message]");
		ChatManager.SystemMessage("/night");
		ChatManager.SystemMessage("/reload");
		ChatManager.SystemMessage("/reply [message]");
		ChatManager.SystemMessage("/roll [DieCode/RollCode] <message> - Alias for '/die'");
		ChatManager.SystemMessage("/roll hide - Alias for '/die hide'");
		ChatManager.SystemMessage("/roll reveal - Alias for '/die revel'");
		ChatManager.SystemMessage("/rollcode-help - Alias for '/diecode-help'");
		ChatManager.SystemMessage("/rollon [table name] <-c [column name]> <-d [DieCode/RollCode]> <-hide>");
		ChatManager.SystemMessage("/save");
		ChatManager.SystemMessage("/scaleui [50-200]");
		ChatManager.SystemMessage("/story [message]");
		ChatManager.SystemMessage("/tower [DieCode/RollCode] <message>");
		ChatManager.SystemMessage("/vote <message>");
		ChatManager.SystemMessage("/whisper [" .. RulesetOptions.NAME_OF_PLAYER .. "] [message]");
	else
		ChatManager.SystemMessage("/action [message]");
		ChatManager.SystemMessage("/afk");
		ChatManager.SystemMessage("/console");
		ChatManager.SystemMessage("/die [DieCode/RollCode] <message>");
		ChatManager.SystemMessage("/diecode-help");
		ChatManager.SystemMessage("/emote [message]");
		ChatManager.SystemMessage("/mod [N] <message>");
		ChatManager.SystemMessage("/mood [mood] <message>");
		ChatManager.SystemMessage("/mood ([multiword mood]) <message>");
		ChatManager.SystemMessage("/ooc [message]");
		ChatManager.SystemMessage("/reply [message]");
		ChatManager.SystemMessage("/roll [DieCode/RollCode] <message> - Alias for '/die'");
		ChatManager.SystemMessage("/roll hide - Alias for '/die hide'");
		ChatManager.SystemMessage("/roll reveal - Alias for '/die revel'");
		ChatManager.SystemMessage("/rollcode-help - Alias for '/diecode-help'");
		ChatManager.SystemMessage("/rollon [table name] <-c [column name]> <-d [DieCode/RollCode]> <-hide>");
		ChatManager.SystemMessage("/save");
		ChatManager.SystemMessage("/scaleui [50-200]");
		ChatManager.SystemMessage("/tower [DieCode/RollCode] <message>");
		ChatManager.SystemMessage("/vote <message>");
		ChatManager.SystemMessage("/whisper " .. RulesetOptions.NAME_OF_REFEREE .. " [message]");
		ChatManager.SystemMessage("/whisper [" .. RulesetOptions.NAME_OF_PLAYER .. "] [message]");
	end
end

function fpProcessReply(sCommand,sParams)
	if not sLastWhisperer then
		ChatManager.SystemMessage(Interface.getString("error_slashreplytargetmissing"));
		return;
	end
	fpProcessWhisperHelper(sLastWhisperer,sParams);
end

function fpProcessTowerDie(sCommand,sDieCode)
	local sDice,sDesc = string.match(sDieCode,"%s*(%S+)%s*(.*)");
	local aRollCodes,_ = DieManager.fpDieCodeParse(DieManager.fpDieCodeLex(sDice));
	if not aRollCodes then
		ChatManager.SystemMessage("Usage: /tower [DieCode] [description]");
		return;
	end
	local aRoll = {DieManager.fpDieAndTowerHelper(sDieCode,0,true,true,sDesc)};
	if OptionsManager.isOption("TBOX","on") then
		local aMessageOOB = {};
		aMessageOOB.type = DiceTowerManager2.OOB_MSGTYPE_DICETOWER;
		aMessageOOB.sType = "dice";
		aMessageOOB.sDesc = aRoll.sDesc;
		aMessageOOB.sDice = sDice;
		aMessageOOB.nMod = aRoll.nMod;
		aMessageOOB.sender = User.getIdentityLabel();
		DiceTowerManager2.fpSetRollCodesFromSlash(aMessageOOB,aRollCodes);
		Comm.deliverOOBMessage(aMessageOOB, "");
		if not User.isHost() then
			local aMessage = {font = "chatfont",icon = "dicetower_icon",text = ""};
			aMessage.sender = "[" .. Interface.getString("dicetower_tag") .. "]"
			aMessage.text = "";
			if aMessageOOB.sDesc ~= "" and
					aMessageOOB.sDesc ~= nil then
				aMessage.text = aMessageOOB.sDesc .. " ";
			end
			aMessage.text = aMessage.text .. "[" .. aMessageOOB.sDice .. "]";
			Comm.addChatMessage(aMessage);
		end
	else
		ChatManager.SystemMessage(Interface.getString("dice_tower_off_string"));
	end
end

function fpProcessWhisper(sCommand,sParams)
	local sLowerParams = string.lower(sParams);
	local sGMIdentity = "gm ";
	local sRecipient = nil;
	if string.sub(sLowerParams,1,string.len(sGMIdentity)) == sGMIdentity then
		sRecipient = RulesetOptions.NAME_OF_REFEREE;
	else
		for nKey,vID in ipairs(User.getAllActiveIdentities()) do
			local sIdentity = User.getIdentityLabel(vID);
			local sIdentityMatch = string.lower(sIdentity) .. " ";
			if string.sub(sLowerParams,1,string.len(sIdentityMatch)) == sIdentityMatch then
				if sRecipient then
					if #sRecipient < #sIdentity then
						sRecipient = sIdentity;
					end
				else
					sRecipient = sIdentity;
				end
			end
		end
	end
	local sMessage;
	if sRecipient then
		sMessage = string.sub(sParams,#sRecipient+2)
	else
		sMessage = sParams;
	end
	fpProcessWhisperHelper(sRecipient,sMessage);
end

function fpProcessWhisperHelper(sRecipient,sMessage)
	local sUser = nil;
	local sRecipientID = nil;
	if sRecipient then
		if sRecipient == RulesetOptions.NAME_OF_REFEREE then
			sRecipientID = "";
			sUser = "";
		else
			for nKey,vID in ipairs(User.getAllActiveIdentities()) do
				local sIdentity = User.getIdentityLabel(vID);
				if sIdentity == sRecipient then
					sRecipientID = vID;
					sUser = User.getIdentityOwner(vID);
				end
			end
		end
	end
	if not sRecipientID or
			not sUser then
		ChatManager.SystemMessage(Interface.getString("error_slashwhispertargetmissing"));
		ChatManager.SystemMessage("Usage: /w ".. RulesetOptions.NAME_OF_REFEREE .. " [message]\rUsage: /w [recipient] [message]");
		return;
	end
	if sMessage == "" then
		ChatManager.SystemMessage(Interface.getString("error_slashwhisperaMessagemissing"));
		ChatManager.SystemMessage("Usage: /w ".. RulesetOptions.NAME_OF_REFEREE .. " [message]\rUsage: /w [recipient] [message]");
		return;
	end
	local sSender;
	if User.isHost() then
		sSender = "";
	else
		sSender = User.getCurrentIdentity();
		if not sSender then
			ChatManager.SystemMessage(Interface.getString("error_slashwhispersourcemissing"));
			return;
		end
	end
	local aMessageOOB = {};
	aMessageOOB.type = ChatManager.OOB_MSGTYPE_WHISPER;
	aMessageOOB.sender = sSender;
	aMessageOOB.receiver = sRecipientID;
	aMessageOOB.text = sMessage;
	if User.isHost() then
		Comm.deliverOOBMessage(aMessageOOB,{sUser,""});
	else
		Comm.deliverOOBMessage(aMessageOOB);
	end
	local aMessage = {font = "whisperfont",sender="[w]"};
	if OptionsManager.isOption("PCHT","on") then
		if User.isHost() then
			aMessage.icon = "portrait_gm_token";
		else
			aMessage.icon = "portrait_" .. aMessageOOB.sender .. "_chat";
		end
	else
		if #(User.getOwnedIdentities()) > 1 then
			aMessage.sender = "[w] " .. User.getIdentityLabel(sSender);
		end
		if OptionsManager.isOption("PCHT","on") then
			aMessage.icon = "portrait_" .. aMessageOOB.sender .. "_chat";
		end
	end
	aMessage.sender = aMessage.sender .. " -> " .. sRecipient;
	aMessage.text = sMessage;
	Comm.addChatMessage(aMessage);
end
