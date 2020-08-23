describe("lsUDRDieManager", function()
	require("lsUDRDieManager")
	require("mocks.StringManager")

	function expectedRollCodes(eRollCodes)
		local out = {nK = 0,nP = 0,nR = 0,nS = 0,nSN = 0,nT = 0,nTN = 0,nX1 = 0,nX2 = 0,nZ = 0};
		for k, _ in pairs(eRollCodes) do
			out[k] = eRollCodes[k]
		end
		return out
	end


	describe("fpDieCodeLex", function ()
		function lexPair(sType, sValue)
			return { sType = sType, sValue = sValue }
		end

		it("Single Die: d6", function ()
			local rollCodes, aTokens = fpDieCodeLex("d6")
			assert.are.same(expectedRollCodes({}), rollCodes)
			assert.are.same(
				{
					lexPair('n','1'),
					lexPair('d','d6')
				},
				aTokens
			)
		end)
		it("Standard Attribute Roll: 6d6!kt7s5", function ()
			local rollCodes, aTokens = fpDieCodeLex("6d6!kt7s5")
			assert.are.same(expectedRollCodes({ nX1 = 6, nX2 = 6 }), rollCodes)
			assert.are.same(
				{
					lexPair('n','6'),
					lexPair('d','d6'),
					lexPair('d','d6'), --wat?
					lexPair('t','+t'),
					lexPair('n','7'),
					lexPair('s','s'),
					lexPair('n','5'),
				},
				aTokens
			)
		end)
		-- TODO: This currently doesn't do what we want it to do, 
		-- but it would definitely be nice to have.
		it("Sabre attack dmg: (3d6!)+(4d12!k)", function ()
			-- Tried putting parens around the sets and it crashes
			local rollCodes, aTokens = fpDieCodeLex("(3d6!)+(4d12!k)")
			assert.are.same(rollCodes, false)
			assert.are.same(aTokens, nil)
			rollCodes, aTokens = fpDieCodeLex("3d6!+4d12!k")
			-- This test highlights the fact that it's wrong that we try to calculate the rollCodes
			-- in the lexer. Especially so because we aren't even calculating it all here anyway made
			-- clear by the fact that the keep and targets don't get calculated till the parsing step.
			-- This structure means that we can only ever explode one set and that's bad because our
			-- grammar lets things through. 
			-- We should either tighten up the grammar to make confusing things not slip through or 
			-- make this better.
			assert.are.same(expectedRollCodes({ nX1 = 12, nX2 = 12 }) , rollCodes)
			assert.are.same(
				{
					lexPair('n','3'),
					lexPair('d','d6'),
					lexPair('a','+'),
					lexPair('n','4'),
					lexPair('d','d12'),
					lexPair('d','d12')
				}, 
				aTokens
			)
		end)
		it("Shadowrun Roll")
	end)
	describe("fpDieCodeParse & fpDieCodeLex integration", function ()
    it("6d6!kt7s5", function ()
			local rollCodes, aRPN = fpDieCodeParse(fpDieCodeLex("6d6!kt7s5"))
			assert.are.same(
				expectedRollCodes(
					{ nX1 = 6, nX2 = 6, nT = 1, nTN = 7, nS = 1, nSN = 5 }
				), 
				rollCodes
			)
			assert.are.same(
				{
					{ sType = 'd', sValue = '6d6' },
					{ sValue = 'd6', sType = 'd' }
				}, 
				aRPN
			)
		end)
	end)
	local function expectedRoll()
		return {
			aDice = {
				'd6','d6','d6','d6','d6','d6','d6' --Why 7?
			},
			aNSD = {},
			aRPN = {
				{sType = 'd', sValue = '6d6'},
				{sType = 'd', sValue = 'd6'}
			},
			aRollCodes = expectedRollCodes(
				{ nX1 = 6, nX2 = 6, nT = 1, nTN = 7, nS = 1, nSN = 5 }
			),
			bDiceCodeString = true,
			bSecret = false,
			nMod = 0,
			sType = 'dice'
		}
	end

	describe("fpDieAndTowerHelper & fpDieCodeParse & fpDieCodeLex integration", function ()
		require("mocks.Interface")
    it("6d6!kt7s5", function ()
			local aRollCodes, aRPN = fpDieCodeParse(fpDieCodeLex("6d6!kt7s5"))
			local res = fpDieAndTowerHelper(aRollCodes,aRPN,"",0,true,false,"")
			assert.are.same(expectedRoll(),res)
		end)
	end)

	describe("processDie", function ()
		require("mocks.User")
		require("mocks.ActionsManager")
		require("mocks.Interface")

		_G.User = newUserMock(false)
		spy.on(ActionsManager, "actionDirect")

		it("6d6!kt7s5", function ()
			fpProcessDie("wat","6d6!kt7s5")
			assert.spy(ActionsManager.actionDirect).was.called_with(nil, "dice", {expectedRoll()})
		end)
	end)
end)