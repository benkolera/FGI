--- Requires a module into a globally accessible table to mimic the 
-- behaviour of loading scripts in FG.
-- @param name: The name of the entry in the global table
-- @param module: A lua module name that will be searched on the search path
function requireFGModule(name, module)
	-- Lets make a new table
	local e = { _name = name }
	-- Install it into the global context
	_G[name] = e
	-- Set the metatable of our table to inherit from the global scope so that
	-- other globals required by this function are accessible to each other.
	setmetatable(e, {__index = _G })
	-- the second loader is the one that looks on the search path
	-- We're stuck lua 5.1 cos of fantasy grounds, so we don't have package.searchpath
	local loader = package.loaders[2](module)
	if (type(loader) == "function") then
		setfenv(loader, e)
		loader()
	else 
		error(loader)
	end
	-- This means that if for instance we call this function with 
	-- requireFGModule("Parser","lsUDRParser.lua")
	-- Then we get a global much like how we would with
	-- <script name="Parser" src="lsUDRParser.lua" />
end