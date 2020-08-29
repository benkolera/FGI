-- This should probs be in core

--- Builds an array of n elements which are all x
-- @param n: A number
-- @param x: The element to repeat
-- @usage
-- > repeatN(5,"d6")
-- {"d6","d6","d6","d6","d6"}
function repeatN(n,x)
	local out = {}
	for i=1, n do
		out[i] = x
	end
	return out
end

--- Transforms an array using the function, making a new array in the process
-- @param arr: The array
-- @param fn: Function from old element to new
-- @usage
-- > map({1,2,3},fn(x) return x * 2 end)
-- {2,4,6}
function map(arr,fn)
	local out = {}	
	for _,v in ipairs(arr) do
		table.insert(out,fn(v))
	end
	return out
end

--- shallow copies an array
-- @param arr
function copy(arr)
	local out = {}
	for _,v in ipairs(arr) do
		table.insert(out,v)
	end
	return out
end

--- Joins two arrays together
-- @param arr1
-- @param arr2
-- @usage
-- > join({1,2,3},{4,5})
-- {1,2,3,4,5}
function join(arr1,arr2)
	local out = copy(arr1)
	for _,v in ipairs(arr2) do
		table.insert(out,v)
	end
	return out
end