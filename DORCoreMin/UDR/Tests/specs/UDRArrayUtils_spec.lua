describe("lsArrayUtils", function()
	require("testlib.require")
	requireFGModule("ArrayUtils","lsUDRArrayUtils")
	describe("repeatN", function ()
		it("should repeat the item n times", function ()
			assert.are.same(
				{"d6","d6","d6"},
				ArrayUtils.repeatN(3,"d6")
			)
		end)
	end)
	describe("map", function ()
		it("should transform the elements", function ()
			assert.are.same(
				{2,4,6},
				ArrayUtils.map({1,2,3},function (x) return x * 2 end)
			)
		end)
		it("should leave the original list alone", function ()
			local arr = {1,2,3}
			assert.are.same(
				{2,4,6},
				ArrayUtils.map(arr,function (x) return x * 2 end)
			)
			assert.are.same(
				{1,2,3},
				arr
			)
		end)
	end)
	describe("join", function ()
		it("should join the arrays", function ()
			assert.are.same(
				{1,2,3,4,5},
				ArrayUtils.join({1,2,3},{4,5})
			)
		end)
		it("should leave the original list alone", function ()
			local arr1 = {1,2,3}
			local arr2 = {4,5}
			assert.are.same(
				{1,2,3,4,5},
				ArrayUtils.join(arr1,arr2)
			)
			assert.are.same(
				{1,2,3},
				arr1
			)
			assert.are.same(
				{4,5},
				arr2
			)
		end)
	end)
end)