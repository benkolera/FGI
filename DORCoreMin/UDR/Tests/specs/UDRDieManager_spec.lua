describe("lsUDRDieManager", function()
	require("lsUDRDieManager")
	require("mocks.StringManager")
	require("mocks.Debug")

	describe("processDie", function ()
		require("mocks.User")
		require("mocks.ActionsManager")

		_G.User = newUserMock(false)
		local actionSpy = spy.on(ActionsManager, "actionDirect")

		it("6d6!kt7s5", function ()
			fpProcessDie(nil,"6d6!kt7s5")
			assert.are.same(
				{ 
					[2] = "dice", 
					[3] = {{
					sType = "dice",
					sDesc = "",
					aDice = repeatN(6,"d6"),
					nMod = 0,
					evaluator = {
						num = 6.0,
						sides = 6.0,
						isExploding = true,
						keepNum = 1,
						successNum = 5.0,
						targetNum = 7.0,
						pending = repeatN(6, DieResult.new("d6")),
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