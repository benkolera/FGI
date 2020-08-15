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
S_OOB_MSGTYPE_DICETOWER = "dicetower";

local oControl = nil;

function onInit()
	OOBManager.registerOOBMsgHandler(S_OOB_MSGTYPE_DICETOWER,fpHandleDiceTower);
end

function onDrop(oDragData)
	if oControl then
		if OptionsManager.isOption("TBOX","on") then
			local sDragType = oDragData.getType();
			if GameSystem.actions[sDragType] then
				local aSource = ActionsManager.actionDropHelper(oDragData,false);
				for i = 1,oDragData.getSlotCount() do
					local aMessageOOB = fpEncodeOOBFromDrag(oDragData,i,aSource);
					local aRollCodes = oDragData.getCustomData();
					fpSetRollCodesFromSlash(aMessageOOB,aRollCodes);
					Comm.deliverOOBMessage(aMessageOOB, "");
					if not User.isHost() then
						local aMessage = {font = "chatfont",icon = "dicetower_icon",text = ""};
						if aSource then
							aMessage.sender = ActorManager.getDisplayName(aSource);
						end
						if aMessageOOB.sDesc ~= "" then
							aMessage.text = aMessageOOB.sDesc .. " ";
						end
						aMessage.text = aMessage.text .. "[" .. aMessageOOB.sDice .. "]";
						Comm.addChatMessage(aMessage);
					end
				end
			end
		end
	end
	return true;
end

function registerControl(oCtrl)
	oControl = oCtrl;
	fpActivate();
end

function fpActivate()
	OptionsManager.registerCallback("TBOX",fpUpdate);
	OptionsManager.registerCallback("REVL",fpUpdate);
	fpUpdate();
end

function fpEncodeOOBFromDrag(oDragData,i,aSource)
	local aMessageOOB = ActionsManager.decodeRollFromDrag(oDragData,i);
	aMessageOOB.type = S_OOB_MSGTYPE_DICETOWER;
	aMessageOOB.sender = ActorManager.getCreatureNodeName(aSource);
	aMessageOOB.sUser = User.getUsername();
	aMessageOOB.sDice = DieManager.fpConvertDiceToString(aMessageOOB.aDice,aMessageOOB.nMod);
	aMessageOOB.aDice = nil;
	aMessageOOB.nMod = nil;
	return aMessageOOB;
end

function fpHandleDiceTower(aMessageOOB)
	aMessageOOB.aRollCodes = {};
	aMessageOOB.aRollCodes.nK = tonumber(aMessageOOB.nK);
	aMessageOOB.aRollCodes.nP = tonumber(aMessageOOB.nP);
	aMessageOOB.aRollCodes.nR = tonumber(aMessageOOB.nR);
	aMessageOOB.aRollCodes.nS = tonumber(aMessageOOB.nS);
	aMessageOOB.aRollCodes.nSN = tonumber(aMessageOOB.nSN);
	aMessageOOB.aRollCodes.nT = tonumber(aMessageOOB.nT);
	aMessageOOB.aRollCodes.nTN = tonumber(aMessageOOB.nTN);
	aMessageOOB.aRollCodes.nX1 = tonumber(aMessageOOB.nX1);
	aMessageOOB.aRollCodes.nX2 = tonumber(aMessageOOB.nX2);
	aMessageOOB.aRollCodes.nZ = tonumber(aMessageOOB.nZ);
	aMessageOOB.type = nil;
	local aActor = nil;
	if aMessageOOB.sender and
			aMessageOOB.sender ~= "" then
		aActor = ActorManager.getActor(nil,aMessageOOB.sender);
	end
	aMessageOOB.sender = nil;
	aMessageOOB.sDesc = "[" .. Interface.getString("dicetower_tag") .. "] " .. (aMessageOOB.sDesc or "");
	aMessageOOB.aDice,aMessageOOB.nMod = DieManager.fpConvertStringToDice(aMessageOOB.sDice);
	aMessageOOB.sDice = nil;
	aMessageOOB.bSecret = true;
	aMessageOOB.bTower = true;
	ActionsManager.roll(aActor,nil,aMessageOOB);
end

function fpSetRollCodesFromSlash(aOOBMsg,aRollCodes)
	aOOBMsg.nK = aRollCodes.nK;
	aOOBMsg.nP = aRollCodes.nP;
	aOOBMsg.nR = aRollCodes.nR;
	aOOBMsg.nS = aRollCodes.nS;
	aOOBMsg.nSN = aRollCodes.nSN;
	aOOBMsg.nT = aRollCodes.nT;
	aOOBMsg.nTN = aRollCodes.nTN;
	aOOBMsg.nX1 = aRollCodes.nX1;
	aOOBMsg.nX2 = aRollCodes.nX2;
	aOOBMsg.nZ = aRollCodes.nZ;
	return;
end

function fpUpdate()
	if oControl then
		if OptionsManager.isOption("TBOX","on") then
			if User.isHost() and
					OptionsManager.isOption("REVL","off") then
				oControl.setVisible(false);
			else
				oControl.setVisible(true);
			end
		else
			oControl.setVisible(false);
		end
	end
end
--[[ I don't think we need this at all - MJB - 20181016

function decodeRollFromOOB(aMessageOOB)
	aMessageOOB.aDice, aMessageOOB.nMod = DieManager.fpConvertStringToDice(aMessageOOB.sDice);
	aMessageOOB.sDice = nil;
	aMessageOOB.type = nil;
	aMessageOOB.sender = nil;
	aMessageOOB.bSecret = true;
	return aMessageOOB;
end
--]]
