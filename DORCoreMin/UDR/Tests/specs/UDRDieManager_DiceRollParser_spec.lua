
describe("DiceRollParser", function ()
	require("testlib.require")
	requireFGModule("Parser","lsUDRParser")
	requireFGModule("ArrayUtils","lsUDRArrayUtils")
	requireFGModule("DieManager","lsUDRDieManager")

	it("should evaluate a dice pool",function ()
		local e = DieManager.DiceRollEvaluator.dicePool(2,4,false,nil,nil,nil)
		assert.are.same(
			{ done = false, newRolls = {"d4","d4"}, diceResultsRemaining = {} },
			DiceRollEvaluator.eval(e,{})
		)
		assert.are.same(
			{ 
				done = true, 
				result = 7, 
				diceHistory = {
					{ type = "d4", result = 4, flags = { exploded = false } },
					{ type = "d4", result = 3, flags = { exploded = false } },
				},
				diceResultsRemaining = { { type = "d6", result = 1 }}
			},
			DieManager.DiceRollEvaluator.eval(e,{
				{ type="d4", result=3 }, 
				{ type="d4", result=4 }, 
				{ type="d6", result=1 } 
			})
		)
	end)
	it("should evaluate an exploding dice pool",function ()
		local e = DiceRollEvaluator.dicePool(2,4,true,nil,nil,nil)
		assert.are.same(
			{ done = false, newRolls = {"d4","d4"}, diceResultsRemaining = {} },
			DiceRollEvaluator.eval(e,{})
		)
		assert.are.same(
			{ 
				done = false, 
				newRolls = { "d4" }, 
				diceResultsRemaining = { { type = "d6", result = 1 }} 
			},
			DiceRollEvaluator.eval(e, {
				{ type="d4", result=3 }, 
				{ type="d4", result=4 }, 
				{ type="d6", result=1 } 
			})
		)
		assert.are.same(
			{ 
				done = false, 
				newRolls = { "d4" }, 
				diceResultsRemaining = { { type = "d6", result = 1 }} 
			},
			DiceRollEvaluator.eval(e, {
				{ type="d4", result=4 }, 
				{ type="d6", result=1 } 
			})
		)
		assert.are.same(
			{ 
				done = true, 
				result = 12, 
				diceHistory = {
					{ type = "d4", result = 9, flags = { exploded = true } },
					{ type = "d4", result = 3, flags = { exploded = false } },
				},
				diceResultsRemaining = {}
			},
			DiceRollEvaluator.eval(e, {
				{ type="d4", result=1 }
			})
		)
	end)
end)

describe("DiceRollParser", function ()
	_G.inspect = require("inspect")
	require('testlib.require')
	requireFGModule("ArrayUtils","lsUDRArrayUtils")
	requireFGModule("Parser","lsUDRParser")
	requireFGModule("DieManager","lsUDRDieManager")

	it("expression should parse 3d6!",function ()
		local res = DieManager.DiceRollParser.expression().parse("3d6!")
		assert.are.same(
			Parser.Result.ok(
				{
					type = "dicePool",
					num = 3,
					sides = 6,
					isExploding = true,
					keepNum = nil,
					targetNum = nil,
					successNum = nil,
					queued = {"d6","d6","d6"},
					pending = {},
					results = {}
				},
				""
			),
			res
		)
		DieManager.DiceRollEvaluator.eval(res.res,{})

		local dice = {
			{type="d6", result=3, flags={ exploded = false }},
			{type="d6", result=3, flags={ exploded = false }},
			{type="d6", result=3, flags={ exploded = false }}
		}
		assert.are.same(
			{ 
				done=true,
				result = 9, 
				diceHistory = dice,
				diceResultsRemaining = {}
			},
			DieManager.DiceRollEvaluator.eval(res.res,dice)
		)
	end)
	it("expression should parse add(3d6!,5d12!k)",function ()
		local res = DieManager.DiceRollParser.expression().parse("add(3d6!,5d12!k)")
		assert.are.same(
			Parser.Result.ok(
				{
					type = "add",
					pendingEvaluators = {
						{
							type = "dicePool",
							num = 3.0,
							sides = 6.0,
							isExploding = true,
							keepNum = nil,
							targetNum = nil,
							successNum = nil,
							queued = ArrayUtils.repeatN(3,"d6"),
							pending = {},
							results = {}
						},
						{
							type = "dicePool",
							num = 5.0,
							sides = 12.0,
							isExploding = true,
							keepNum = 1,
							targetNum = nil,
							successNum = nil,
							queued = ArrayUtils.repeatN(5,"d12"),
							pending = {},
							results = {}
						}
					},
					doneEvaluators = {}
				},
				""
			),
			res
		)
		assert.are.same(
			{ 
				done = false, 
				newRolls = { "d6", "d6", "d6", "d12", "d12", "d12", "d12", "d12" },
				diceResultsRemaining = {}
			},
			DieManager.DiceRollEvaluator.eval(res.res,{})
		)
		assert.are.same(
			{ 
				done = false, 
				newRolls = { "d6", "d12" },
				diceResultsRemaining = { { type = "d8", result = 8 }}
			},
			DieManager.DiceRollEvaluator.eval(res.res,{
				{ type="d6", result = 3 },
				{ type="d6", result = 2 },
				{ type="d6", result = 6 },
				{ type="d12", result = 9 },
				{ type="d12", result = 11 },
				{ type="d12", result = 1 },
				{ type="d12", result = 12 },
				{ type="d12", result = 3 },
				{ type="d8", result = 8 }
			})
		)
		assert.are.same(
			{ 
				done = true,
				result = 32,
				diceHistory = {
					{ type = "d6", result = 10, flags = { exploded = true } },
					{ type = "d6", result = 3, flags = { exploded = false } },
					{ type = "d6", result = 2, flags = { exploded = false } },
					{ type = "d12", result = 17, flags = { exploded = true, kept = true } },
					{ type = "d12", result = 11, flags = { exploded = false, discarded = true } },
					{ type = "d12", result = 9, flags = { exploded = false, discarded = true } },
					{ type = "d12", result = 3, flags = { exploded = false, discarded = true } },
					{ type = "d12", result = 1, flags = { exploded = false, discarded = true } },
				},
				diceResultsRemaining = {}
			},
			DieManager.DiceRollEvaluator.eval(res.res,{
				{ type="d6", result = 4 },
				{ type="d12", result = 5 }
			})
		)
	end)
end)