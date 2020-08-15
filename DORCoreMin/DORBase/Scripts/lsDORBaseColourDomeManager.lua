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
-- Called By: xDORBaseFiles.xml
--

function fpBringToFront(oParent)
	oParent.oDomeBase.bringToFront();
	oParent.oDomeColour.bringToFront();
	if oParent.sButIcon then
		oParent.sButIcon.bringToFront();
	end
	oParent.oDomeEffect.bringToFront();
end

function fpCreateColourDome(oParent,sID,nSize,sColour,bButton,bRadial,nXPosOrAngle,nYPosOrOffset,sAnchor,sButIcon,sIconColour)
	local oDomeBase = nil;
	local oDomeColour = nil;
	local oDomeIcon = nil;
	local oDomeEffect = nil;
	if nSize > 50 then
		oDomeBase = oParent.addBitmapWidget("imgMenubarButtonBase");
		oDomeColour = oParent.addBitmapWidget("imgMenubarButtonColour");
	else
		oDomeBase = oParent.addBitmapWidget("iBtnBase");
		oDomeColour = oParent.addBitmapWidget("iBtnColour");
	end
	if sButIcon and
			sButIcon ~= "" then
		oDomeIcon = oParent.addBitmapWidget(sButIcon);
	end
	if nSize > 50 then
		oDomeEffect = oParent.addBitmapWidget("imgMenubarButtonEffect");
	else
		oDomeEffect = oParent.addBitmapWidget("iBtnEffects");
	end
	oDomeBase.setSize(nSize,nSize);
	oDomeColour.setSize(nSize,nSize);
	oDomeColour.setColor(sColour);
	if oDomeIcon then
		oDomeIcon.setSize(nSize,nSize);
		oDomeIcon.setColor(sIconColour);
	end
	oDomeEffect.setSize(nSize,nSize);
	if bRadial then
		oDomeBase.setRadialPosition(nYPosOrOffset,nXPosOrAngle);
		oDomeColour.setRadialPosition(nYPosOrOffset,nXPosOrAngle);
		oDomeEffect.setRadialPosition(nYPosOrOffset,nXPosOrAngle);
		if oDomeIcon then
			oDomeIcon.setRadialPosition(nYPosOrOffset,nXPosOrAngle);
		end
	else
		oDomeBase.setPosition(sAnchor,nXPosOrAngle,nYPosOrOffset);
		oDomeColour.setPosition(sAnchor,nXPosOrAngle,nYPosOrOffset);
		oDomeEffect.setPosition(sAnchor,nXPosOrAngle,nYPosOrOffset);
		if oDomeIcon then
			oDomeIcon.setPosition(sAnchor,nXPosOrAngle,nYPosOrOffset);
		end
	end
	if bButton then
		fpRegisterButton(oParent,sID,math.floor(nSize*0.35),bRadial,nXPosOrAngle,nYPosOrOffset);
	end
	return oDomeBase,oDomeColour,oDomeEffect,oDomeIcon;
end

function fpDestroyColourDome(oParent)
	fpSetColourDomeVisible(oParent,false);
	oParent.oDomeBase.destroy();
	oParent.oDomeColour.destroy();
	oParent.oDomeEffect.destroy();
	if oParent.sButIcon then
		oParent.sButIcon.destroy();
	end
end

function fpRegisterButton(oParent,sID,nSize,bRadial,nXPosOrAngle,nYPosOrOffset)
	local aButtonDetails = {};
	if bRadial then
		local nAngleInRad = math.pi*nXPosOrAngle/50;
		aButtonDetails.nXPos = math.sin(nAngleInRad)*nYPosOrOffset;
		aButtonDetails.nYPos = -(math.cos(nAngleInRad)*nYPosOrOffset);
	else
		aButtonDetails.nXPos = nXPosOrAngle;
		aButtonDetails.nYPos = nYPosOrOffset;
	end
	aButtonDetails.nSize = nSize;
	aButtonDetails.sID = sID;
	return table.insert(oParent.aButtons,aButtonDetails);
end

function fpSetColourDomeVisible(oParent,bVisible)
	oParent.oDomeBase.setVisible(bVisible);
	oParent.oDomeColour.setVisible(bVisible);
	oParent.oDomeEffect.setVisible(bVisible);
	if oParent.sButIcon then
		oParent.sButIcon.setVisible(bVisible);
	end
end

function fpSendToBack(oParent)
	oParent.oDomeEffect.sendToBack();
	if oParent.sButIcon then
		oParent.sButIcon.sendToBack();
	end
	oParent.oDomeColour.sendToBack();
	oParent.oDomeBase.sendToBack();
end
