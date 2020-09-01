function new(msg, fn)
	return function (x)
		if (not fn(x)) then
			if x == nil then x = "nil" end
			error(msg .. ". Got: " .. x)
		end
		return true
	end
end

function run(name,v)
	return function(x)
		local ok,err = pcall(function () v(x) end)
		if not ok then
			error("Error validating " .. name .. ": " .. err)
		end
	end
end

function andValidate(v1,v2)
	return function (x)
		v1(x)
		v2(x)
	end
end

function orValidate(v1,v2)
	return function (x)
		local ok1, err1 = pcall(function () v1(x) end)
		if ok1 then return end
		local ok2, err2 = pcall(function () v2(x) end)
		if not ok2 then
			error("Validation errors: " .. err1 .. " and " .. err2)
		end
	end
end

isNatural = new(
	"is not a natural number",
	function (x)
		return type(x) == "number" and x > 0
	end
)

isNil = new(
	"is not nil",
	function (x) return x == nil end
)

isOptNatural = orValidate(isNil, isNatural)