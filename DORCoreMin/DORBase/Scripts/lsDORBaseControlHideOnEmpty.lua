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
-- Called By: tNumFieldCol in xDORBaseTemplates.xml
--				tStrFieldCol in xDORBaseTemplates.xml
--				tTextFieldFullColNoBorder in xDORBaseTemplates.xml
--

function onInit()
	if super and
			super.onInit then
		super.onInit();
	end
	if isReadOnly() then
		self.fpUpdate(true);
	else
		local oNode = getDatabaseNode();
		if not oNode
				or oNode.isReadOnly() then
			self.fpUpdate(true);
		end
	end
end

function fpUpdate(bReadOnly,bForceHide)
	local bLocalShow = false;
	if not bForceHide then
		bLocalShow = true;
		if bReadOnly and
				not nohide and
				((type(self) == "stringcontrol" or
				type(self) == "formattedtextcontrol" or
				type(self) == "diecontrol") and
				isEmpty() or
				type(self) == "numbercontrol" and
				getValue() == 0) then
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
