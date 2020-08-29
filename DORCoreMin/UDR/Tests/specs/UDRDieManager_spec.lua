describe("lsUDRDieManager", function()
	require('testlib.require')
	requireFGModule("ArrayUtils","lsUDRArrayUtils")
	requireFGModule("Parser","lsUDRParser")
	requireFGModule("DieManager","lsUDRDieManager")
	require("mocks.StringManager")
	require("mocks.Debug")

	describe("processDie", function ()
		require("mocks.User")
		require("mocks.ActionsManager")

		_G.User = newUserMock(false)
		local actionSpy = spy.on(ActionsManager, "actionDirect")

		it("6d6!kt7s5", function ()
			DieManager.fpProcessDie(nil,"6d6!kt7s5")
			assert.are.same(
				{ 
					[2] = "dice", 
					[3] = {{
					sType = "dice",
					sDesc = "",
					aDice = ArrayUtils.repeatN(6,"d6"),
					nMod = 0,
					evaluator = {
						type = "dicePool",
						num = 6.0,
						sides = 6.0,
						isExploding = true,
						keepNum = 1,
						target = { type = "poolTarget", raiseNum = 5.0, targetNum = 7.0 },
						pending = ArrayUtils.repeatN(6, DieManager.DieResult.new("d6")),
						queued = {},
						results = {},
					}
					}},
					n = 3
				},
				actionSpy.calls[1].refs
			)
		end)
	end)
end)