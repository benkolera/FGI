describe("DiceRollParser", function ()
	require("lsUDRDieManager")
	it("should evaluate a dice pool",function ()
		local e = DicePoolEvaluator.new(2,4,false,1,7,5)
		assert.are.same(
			{ done = false, newRolls = {"d4","d4"} },
			DicePoolEvaluator.eval(e,{})
		)
		assert.are.same(
			{ 
				done = true, 
				result = 7, 
				diceHistory = {
					{ type = "d4", result = 3, flags = { exploded = false } },
					{ type = "d4", result = 4, flags = { exploded = false } }
				} 
			},
			DicePoolEvaluator.eval(e,{
				{ type="d4", result=3 }, 
				{ type="d4", result=4 }, 
				{ type="d6", result=1 } 
			})
		)
		-- idempotent!!
		assert.are.same(
			{ 
				done = true, 
				result = 7, 
				diceHistory = {
					{ type = "d4", result = 3, flags = { exploded = false } },
					{ type = "d4", result = 4, flags = { exploded = false } }
				} 
			},
			DicePoolEvaluator.eval(e, {
				{ type="d4", result=1}
			})
		)
	end)
	it("should evaluate an exploding dice pool",function ()
		local e = DicePoolEvaluator.new(2,4,true,1,7,5)
		assert.are.same(
			{ done = false, newRolls = {"d4","d4"} },
			DicePoolEvaluator.eval(e,{})
		)
		assert.are.same(
			{ done = false, newRolls = { "d4" } },
			DicePoolEvaluator.eval(e, {
				{ type="d4", result=3 }, 
				{ type="d4", result=4 }, 
				{ type="d6", result=1 } 
			})
		)
		assert.are.same(
			{ done = false, newRolls = { "d4" } },
			DicePoolEvaluator.eval(e, {
				{ type="d4", result=4 }, 
				{ type="d6", result=1 } 
			})
		)
		assert.are.same(
			{ done = true, result = 12, diceHistory = {
				{ type = "d4", result = 3, flags = { exploded = false } },
				{ type = "d4", result = 9, flags = { exploded = true } }
			} },
			DicePoolEvaluator.eval(e, {
				{ type="d4", result=1 }
			})
		)
	end)
end)

describe("DiceRollParser", function ()
	require("lsUDRDieManager")
	it("expression should parse 3d6!",function ()
		local res = DiceRollParser.expression().parse("3d6!")
		assert.are.same(
			ParserResult.ok(
				{
					num = 3,
					sides = 6,
					isExploding = true,
					keep = nil,
					target = nil,
					success = nil,
					queued = {"d6","d6","d6"},
					pending = {},
					results = {}
				},
				""
			),
			res
		)
		DicePoolEvaluator.eval(res.res,{})

		local dice = {
			{type="d6", result=3, flags={ exploded = false }},
			{type="d6", result=3, flags={ exploded = false }},
			{type="d6", result=3, flags={ exploded = false }}
		}
		assert.are.same(
			{ done=true, result = 9, diceHistory = dice },
			DicePoolEvaluator.eval(res.res,dice)
		)
	end)
	-- it("expression should parse add(3d6!,5d12!k)",function ()
	-- 	assert.are.same(
	-- 		ParserResult.ok(
	-- 			{
	-- 				type = "poolFn",
	-- 				name = "add",
	-- 				expressions = {
	-- 					{
	-- 						type = "pool", 
	-- 						num = 3,
	-- 						die = { type = "die", side = 6, exploding = true },
	-- 						keep = nil,
	-- 						target = nil,
	-- 						success = nil 
	-- 					},
	-- 					{
	-- 						type = "pool", 
	-- 						num = 5,
	-- 						die = { type = "die", side = 12, exploding = true },
	-- 						keep = 1,
	-- 						target = nil,
	-- 						success = nil 
	-- 					}
	-- 				}
	-- 			},
	-- 			""
	-- 		),
	-- 		DiceRollParser.expression().parse("add(3d6!,5d12!k)")
	-- 	)
	-- end)
end)