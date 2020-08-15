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
-- Called By: tComboboxClimate in xDORBaseTemplates.xml
--

local N_ARCTIC_LATITUDE = 75;
local N_SUBARCTIC_LATITUDE = 55;
local N_TEMPERATE_LATITUDE = 40;
local N_SUBTROPICAL_LATITUDE = 20;
local N_TROPICAL_LATITUDE = 0;

function onInit()
	super.onInit();
	addItems({Interface.getString("sClimateTemperateStr"),Interface.getString("sClimateSubtropicalStr"),Interface.getString("sClimateTropicalStr"),Interface.getString("sClimateArcticStr"),Interface.getString("sClimateSubarcticStr")});
end

function onValueChanged()
	local sMeasure = getValue();
	if sOldMeasure == sMeasure then
		return;
	end
	if window.nLatitude then
		if sMeasure == Interface.getString("sClimateTropicalStr") then
			window.nLatitude.setValue(N_TROPICAL_LATITUDE);
		elseif sMeasure == Interface.getString("sClimateSubtropicalStr") then
			window.nLatitude.setValue(N_SUBTROPICAL_LATITUDE);
		elseif sMeasure == Interface.getString("sClimateArcticStr") then
			window.nLatitude.setValue(N_ARCTIC_LATITUDE);
		elseif sMeasure == Interface.getString("sClimateSubarcticStr") then
			window.nLatitude.setValue(N_SUBARCTIC_LATITUDE);
		else
			window.nLatitude.setValue(N_TEMPERATE_LATITUDE);
		end
	end
	if window.sTerrain then
		if sOldMeasure == Interface.getString("sClimateArcticStr") then
			window.sTerrain.addItems({Interface.getString("sTerrainForestStr"),Interface.getString("sTerrainForestMarshStr")});
		end
		if sMeasure == Interface.getString("sClimateArcticStr") then
			window.sTerrain.clear();
			window.sTerrain.addItems({Interface.getString("sTerrainPlainsStr"),Interface.getString("sTerrainCoastStr"),Interface.getString("sTerrainDesertStr"),Interface.getString("sTerrainHillsStr"),Interface.getString("sTerrainCoastMarshStr"),Interface.getString("sTerrainPlainsMarshStr"),Interface.getString("sTerrainMountainsStr")});
			if window.sTerrain.getValue() == Interface.getString("sTerrainForestStr") or
					window.sTerrain.getValue() == Interface.getString("sTerrainForestMarshStr") then
				window.sTerrain.setValue(Interface.getString("sTerrainPlainsStr"));
			end
		end
	end
	sOldMeasure = sMeasure;
end
