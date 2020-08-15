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
-- Called By: tComboboxTerrain in xDORBaseTemplates.xml
--

local N_COAST_ALTITUDE = 0;
local N_HILLS_ALTITUDE = 2000;
local N_MOUNTAINS_ALTITUDE = 4000;
local N_PLAINS_ALTITUDE = 500;

function onInit()
	super.onInit();
	addItems({Interface.getString("sTerrainPlainsStr"),Interface.getString("sTerrainCoastStr"),Interface.getString("sTerrainDesertStr"),Interface.getString("sTerrainHillsStr"),Interface.getString("sTerrainCoastMarshStr"),Interface.getString("sTerrainPlainsMarshStr"),Interface.getString("sTerrainMountainsStr")});
	if window.sClimate and
			window.sClimate.getValue() ~= Interface.getString("sClimateArcticStr") then
		addItems({Interface.getString("sTerrainForestStr"),Interface.getString("sTerrainForestMarshStr")});
	end
end

function onValueChanged()
	local sMeasure = getValue();
	if sOldMeasure == sMeasure then
		return;
	end
	if window.snAltitude then
		if sMeasure == Interface.getString("sTerrainCoastStr") or
				sMeasure == Interface.getString("sTerrainCoastMarshStr") or
				sMeasure == Interface.getString("sTerrainDesertStr") then
			window.snAltitude.setValue(N_COAST_ALTITUDE,0);
		elseif sMeasure == Interface.getString("sTerrainHillsStr") then
			window.snAltitude.setValue(N_HILLS_ALTITUDE,0);
		elseif sMeasure == Interface.getString("sTerrainMountainsStr") then
			window.snAltitude.setValue(N_MOUNTAINS_ALTITUDE,0);
		else
			window.snAltitude.setValue(N_PLAINS_ALTITUDE,0);
		end
	end
	sOldMeasure = sMeasure;
end
