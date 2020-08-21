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
-- Called By: xDOCEHWFiles.xml
--

function onInit()
	Interface.toggleWindow("wcHelloWorld","");
	MenubarIcons.fpAddMenubarButton(Interface.getString("sMenubarStyleFantasyString"),Interface.getString("sSidebarTooltipHWStr"),"iBarHelloWorld");
	DesktopManager.registerStackShortcut2("","","sSidebarTooltipHWStr","wcHelloWorld","");
	return;
end