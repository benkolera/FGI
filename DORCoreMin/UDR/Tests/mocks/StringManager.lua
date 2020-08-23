local function contains(matches, str)
	for key, value in pairs(matches) do
		if string.match(str, key) then return true end
	end
	return false
end

local function isNumberString(str)
	return tonumber(str) ~= nil
end

StringManager = {
	contains = contains,
	isNumberString = isNumberString
}