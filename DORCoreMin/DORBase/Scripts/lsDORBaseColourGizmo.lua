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
-- Called By: gcColourGizmo in xDORBaseWindowClasses.xml
--
local N_CLICK_SIZE = 0.35;
local N_RADIAL_DISTANCE = 88
local N_SIZE_BIG = 50;
local N_SIZE_MEDIUM = 40;
local N_SIZE_SMALL = 30;
local N_STEP_BIG = 50;
local N_STEP_MEDIUM = 10;
local N_STEP_SMALL = 1;
local N_STEP_BLACK_WHITE = 10;

local oTxtBtnColour;
local oTxtBtnIcon;

aButtons = {};
aCurrentColour = {nRed = 255,nGreen = 255,nBlue = 255};
bBlackText = true;

function onInit()
	addBitmapWidget("colorgizmo_base");
	oBaseColour = addBitmapWidget("colorgizmo_color");
	addBitmapWidget("colorgizmo_effects");
	ColourDomeManager.fpCreateColourDome(self,"red",N_SIZE_BIG,"ffff0000",true,true,10,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"red",N_SIZE_MEDIUM,"ffff0000",true,true,17,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"red",N_SIZE_SMALL,"ffff0000",true,true,23,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"green",N_SIZE_BIG,"ff00ff00",true,true,64,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"green",N_SIZE_MEDIUM,"ff00ff00",true,true,71,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"green",N_SIZE_SMALL,"ff00ff00",true,true,77,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"blue",N_SIZE_BIG,"ff0000ff",true,true,87,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"blue",N_SIZE_MEDIUM,"ff0000ff",true,true,94,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"blue",N_SIZE_SMALL,"ff0000ff",true,true,0,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"black",N_SIZE_BIG,"ff000000",true,true,44,N_RADIAL_DISTANCE);
	ColourDomeManager.fpCreateColourDome(self,"white",N_SIZE_BIG,"ffffffff",true,true,53,N_RADIAL_DISTANCE);
	_,oTxtBtnColour,_,oTxtBtnIcon = ColourDomeManager.fpCreateColourDome(self,"text",N_SIZE_BIG,"ffffffff",true,true,33,N_RADIAL_DISTANCE,"","colorgizmo_bigbtn_text","ff000000");
	for kKey,vValue in pairs(aButtons) do
		if vValue.nSize == math.floor(N_CLICK_SIZE*N_SIZE_BIG) then
			vValue.nAmount = N_STEP_BIG;
			if vValue.sID == "black" or
					vValue.sID == "white" then
				vValue.nAmount = N_STEP_BLACK_WHITE;
			end
		elseif vValue.nSize == math.floor(N_CLICK_SIZE*N_SIZE_MEDIUM) then
			vValue.nAmount = N_STEP_MEDIUM;
		elseif vValue.nSize == math.floor(N_CLICK_SIZE*N_SIZE_SMALL) then
			vValue.nAmount = N_STEP_SMALL;
		end
	end
	fpGetCurrentColours();
end

function fpGetCurrentColours()
	local sColourHexCode;
	sColourHexCode,bBlackText = User.getCurrentIdentityColors();
	aCurrentColour.nRed = tonumber(string.sub(sColourHexCode,3,4),16);
	aCurrentColour.nGreen = tonumber(string.sub(sColourHexCode,5,6),16);
	aCurrentColour.nBlue = tonumber(string.sub(sColourHexCode,7,8),16);
	fpUpdateColours();
end

function fpUpdateColours()
	local sColourHexCode = string.format("ff%02x%02x%02x",aCurrentColour.nRed,aCurrentColour.nGreen,aCurrentColour.nBlue);
	oBaseColour.setColor(sColourHexCode)
	if bBlackText then
		oTxtBtnColour.setColor("ffffffff");
		oTxtBtnIcon.setColor("ff000000");
	else
		oTxtBtnColour.setColor("ff000000");
		oTxtBtnIcon.setColor("ffffffff");
	end
	User.setCurrentIdentityColors(sColourHexCode,bBlackText);
	local sIdentity = User.getCurrentIdentity();
	if sIdentity then
		CampaignRegistry.colortables = CampaignRegistry.colortables or {};
		CampaignRegistry.colortables[sIdentity] = CampaignRegistry.colortables[sIdentity] or {};
		CampaignRegistry.colortables[sIdentity].color = sColourHexCode;
		CampaignRegistry.colortables[sIdentity].blacktext = bBlackText;
	end
	window.sColourCode.fpSetColour();
end

function onClickDown(nButton,nXPos,nYPos)
	local nWidth,nHeight = getSize();
	local nMidPointX,nMidPointY = nXPos-nWidth/2,nYPos-nHeight/2;
	for nIteration,vValue in ipairs(aButtons) do
		if (nMidPointX-vValue.nXPos)*(nMidPointX-vValue.nXPos)+(nMidPointY-vValue.nYPos)*(nMidPointY-vValue.nYPos) <= vValue.nSize*vValue.nSize then
			local nAdjustmentAmount;
			if vValue.sID == "red" then
				nAdjustmentAmount = 255-aCurrentColour.nRed;
				if nAdjustmentAmount > vValue.nAmount then
					aCurrentColour.nRed = aCurrentColour.nRed+vValue.nAmount;
				else
					aCurrentColour.nRed = 255;
					nAdjustmentAmount = vValue.nAmount-nAdjustmentAmount;
					aCurrentColour.nGreen = aCurrentColour.nGreen-nAdjustmentAmount;
					aCurrentColour.nBlue = aCurrentColour.nBlue-nAdjustmentAmount;
				end
			elseif vValue.sID == "green" then
				nAdjustmentAmount = 255-aCurrentColour.nGreen;
				if nAdjustmentAmount > vValue.nAmount then
					aCurrentColour.nGreen = aCurrentColour.nGreen+vValue.nAmount;
				else
					aCurrentColour.nGreen = 255;
					nAdjustmentAmount = vValue.nAmount-nAdjustmentAmount;
					aCurrentColour.nRed = aCurrentColour.nRed-nAdjustmentAmount;
					aCurrentColour.nBlue = aCurrentColour.nBlue-nAdjustmentAmount;
				end
			elseif vValue.sID == "blue" then
				nAdjustmentAmount = 255-aCurrentColour.nBlue;
				if nAdjustmentAmount > vValue.nAmount then
					aCurrentColour.nBlue = aCurrentColour.nBlue+vValue.nAmount;
				else
					aCurrentColour.nBlue = 255;
					nAdjustmentAmount = vValue.nAmount-nAdjustmentAmount;
					aCurrentColour.nRed = aCurrentColour.nRed-nAdjustmentAmount;
					aCurrentColour.nGreen = aCurrentColour.nGreen-nAdjustmentAmount;
				end
			elseif vValue.sID == "black" then
				aCurrentColour.nRed = aCurrentColour.nRed-vValue.nAmount;
				aCurrentColour.nGreen = aCurrentColour.nGreen-vValue.nAmount;
				aCurrentColour.nBlue = aCurrentColour.nBlue-vValue.nAmount;
			elseif vValue.sID == "white" then
				aCurrentColour.nRed = aCurrentColour.nRed+vValue.nAmount;
				aCurrentColour.nGreen = aCurrentColour.nGreen+vValue.nAmount;
				aCurrentColour.nBlue = aCurrentColour.nBlue+vValue.nAmount;
			elseif vValue.sID == "text" then
				bBlackText = not bBlackText;
			end
			if aCurrentColour.nRed < 0 then
				aCurrentColour.nRed = 0;
			elseif aCurrentColour.nRed > 255 then
				aCurrentColour.nRed = 255;
			end
			if aCurrentColour.nGreen < 0 then
				aCurrentColour.nGreen = 0;
			elseif aCurrentColour.nGreen > 255 then
				aCurrentColour.nGreen = 255;
			end
			if aCurrentColour.nBlue < 0 then
				aCurrentColour.nBlue = 0;
			elseif aCurrentColour.nBlue > 255 then
				aCurrentColour.nBlue = 255;
			end
			fpUpdateColours();
			break;
		end
	end
end

function onWheel(nNotches)
	if not OptionsManager.isMouseWheelEditEnabled() then
		return false;
	end
	local nAmount = 10*nNotches;
	aCurrentColour.nRed = aCurrentColour.nRed+nAmount;
	aCurrentColour.nGreen = aCurrentColour.nGreen+nAmount;
	aCurrentColour.nBlue = aCurrentColour.nBlue+nAmount;
	if aCurrentColour.nRed < 0 then
		aCurrentColour.nRed = 0;
	elseif aCurrentColour.nRed > 255 then
		aCurrentColour.nRed = 255;
	end
	if aCurrentColour.nGreen < 0 then
		aCurrentColour.nGreen = 0;
	elseif aCurrentColour.nGreen > 255 then
		aCurrentColour.nGreen = 255;
	end
	if aCurrentColour.nBlue < 0 then
		aCurrentColour.nBlue = 0;
	elseif aCurrentColour.nBlue > 255 then
		aCurrentColour.nBlue = 255;
	end
	fpUpdateColours();
	return true;
end
