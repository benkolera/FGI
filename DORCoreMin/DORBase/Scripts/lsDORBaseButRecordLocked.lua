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
-- Called By: tButRecordLocked in xDORBaseTemplates.xml
--

local nDefault = 0;

function onInit()
	nodeSrc = window.getDatabaseNode();
	if nodeSrc and
			nodeSrc.getModule() then
		nDefault = 1;
	end
	if not nodeSrc or
			nodeSrc.isReadOnly() then
		nodeSrc = nil;
		setVisible(false);
	else
		DB.addHandler(DB.getPath(nodeSrc,"bLocked"),"onUpdate",onUpdate);
		onUpdate();
	end
	notify();
end

function onClose()
	if nodeSrc then
		DB.removeHandler(DB.getPath(nodeSrc,"bLocked"),"onUpdate",onUpdate);
	end
end

function onUpdate()
	if bUpdating then
		return;
	end
	bUpdating = true;
	local nValue = DB.getValue(nodeSrc,"bLocked",nDefault);
	if nValue == 0 then
		setValue(0);
	else
		setValue(1);
	end
	bUpdating = false;
end

function onValueChanged()
	if not bUpdating then
		bUpdating = true;
		if nodeSrc then
			DB.setValue(nodeSrc,"bLocked","number",getValue());
		end
		bUpdating = false;
	end
	notify();
end
