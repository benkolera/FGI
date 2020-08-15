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
-- Called By: wcUDRFMain in xUDRWindowClasses.xml
--

function onInit()
	fpUpdate();
end

function fpUpdate()
	local bReadOnly = MiscFunctions.fpGetReadOnlyState(getDatabaseNode());
--[[
	local bSection1 = false;
	local bSection2 = false;
	local bSection3 = false;
	local bSection4 = false;
	MiscFunctions.fpUpdateCtrl(self,"lOrganisationsParentLink",bReadOnly);
	if MiscFunctions.fpUpdateCtrl(self,"sOrganisationsParentName",bReadOnly) then
		bSection1 = true;
	end
	bcDelLinkOrganisationsParent.setVisible(not bReadOnly);
	if MiscFunctions.fpUpdateCtrl(self,"sType",bReadOnly) then
		bSection2 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sPurpose",bReadOnly) then
		bSection2 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sAlignment",bReadOnly) then
		bSection2 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sReach",bReadOnly) then
		bSection2 = true;
	end
	MiscFunctions.fpUpdateCtrl(self,"lHQLink",bReadOnly);
	if MiscFunctions.fpUpdateCtrl(self,"sHQName",bReadOnly) then
		bSection2 = true;
	end
	bcDelLinkHQ.setVisible(not bReadOnly);
	MiscFunctions.fpUpdateCtrl(self,"lLeaderLink",bReadOnly);
	if MiscFunctions.fpUpdateCtrl(self,"sLeaderName",bReadOnly) then
		bSection3 = true;
	end
	bcDelLinkLeader.setVisible(not bReadOnly);
	if MiscFunctions.fpUpdateCtrl(self,"sLeaderStyle",bReadOnly) then
		bSection3 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sStructure",bReadOnly) then
		bSection3 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sSize",bReadOnly) then
		bSection4 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sResources",bReadOnly) then
		bSection4 = true;
	end
	if MiscFunctions.fpUpdateCtrl(self,"sDemographics",bReadOnly) then
		bSection4 = true;
	end
	MiscFunctions.fpUpdateCtrl(self,"fsBenefits",bReadOnly);
	MiscFunctions.fpUpdateCtrl(self,"fsHistory",bReadOnly);
	MiscFunctions.fpUpdateCtrl(self,"fsGMNotes",bReadOnly);
	divider1.setVisible(bSection1 and (bSection2 or bSection3 or bSection4));
	divider2.setVisible(bSection2 and (bSection3 or bSection4));
	divider3.setVisible(bSection3 and bSection4);
--]]
end
