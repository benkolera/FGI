--
-- Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
-- Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
-- Copyright to other material within this file may be held by other Individuals and/or Entities.
-- Nothing in or from this LUA file in printed,electronic and/or any other form may be used,copied,
--	transmitted or otherwise manipulated in ANY way without the explicit written consent of
--	PEREGRINE I.T. Pty Ltd or,where applicable,any and all other Copyright holders.
-- Please see the accompanying License for full details.
-- All rights reserved.
--
	-- Called By: xCoreFiles.xml

--[[  
	Todo List
- [ ] targets and successes
- [ ] make the negative lookahead combinator so that we can do `3d6!+5d8!k` . Do + at first only
- [ ] Handle the modifiers
- [ ] Test that dragging of sheet with a modifier works (in star frontiers we do rolls like `5d10` with a 3 modifier)
- [ ] handle percentage dice and d100 (no number)
- [ ] Making sure the output in the chatbox is nice and what we are used to

Next Priority (Nice additions to our current games)
- [ ] Crits
- [ ] Crit Fails
- [ ] Come up with a syntax for doing busting for a majority of crits in a pool
- [ ] full blown keep highest / lowest
- [ ] Targets that are < or > 
- [ ] Numeric literals as expression elements for "modifiers" `(e.g 4d8!-2kt8s5)` and the actual sensible places they can appear

Next Priority (down the recursive rabbit hole we go)
- [ ] dice groups
- [ ] computed dice
- [ ] full list of functions and operators

Last Priority (polishing off the last features that we want but don't need for our current games)
- [ ] the bazillion different explosions
- [ ] Games workshop roll
- [ ] Matched Dice
- [ ] Rerolls
- [ ] Configurable sorting
]]

-------------------------------------------------------------------------------
-- Initialisation and TearDown ------------------------------------------------
-------------------------------------------------------------------------------

function onInit()
	Comm.registerSlashHandler("die",fpProcessDie);
	Comm.registerSlashHandler("roll",fpProcessDie);
	ActionsManager.applyModifiersToDragSlot = fpApplyModifiersToDragSlot;
	ActionsManager.buildThrow = fpBuildThrow;
	ActionsManager.createActionMessage = fpCreateActionMessage;
	ActionsManager.onDiceLanded = fpOnDiceLanded;
	ActionsManager.registerModHandler("dice",fpSetRollCodesFromDesktop);
	ActionsManager.registerPostRollHandler("dice",fpPostRoll);
	ActionsManager.registerResultHandler("dice",fpDieRollResult);
	ChatManager.processDie = fpProcessDie;
	StringManager.convertStringToDice = fpConvertStringToDice;
	StringManager.convertDiceToString = fpConvertDiceToString;
end

function onClose()
	ActionsManager.unregisterModHandler("dice");
	ActionsManager.unregisterPostRollHandler("dice");
	ActionsManager.unregisterResultHandler("dice");
end

-------------------------------------------------------------------------------
-- Implementation of FG Hooks  ------------------------------------------------
-------------------------------------------------------------------------------

function fpProcessDie(sCommand,sDieCode)
	if User.isHost() then
		if sDieCode == "reveal" then
			OptionsManager.setOption("REVL","on");
			ChatManager.SystemMessage(Interface.getString("message_slashREVLon"));
			return;
		end
		if sDieCode == "hide" then
			OptionsManager.setOption("REVL","off");
			ChatManager.SystemMessage(Interface.getString("message_slashREVLoff"));
			return;
		end
	end

	local res = DiceRollParser.expression().parse(sDieCode)
	if res.isOk then
		local evalRes = DiceRollEvaluator.eval(res.res)

		if not evalRes.done then
			ActionsManager.actionDirect(nil,"dice",{{
				sType = "dice",
				sDesc = "",
				aDice = evalRes.newRolls,
				nMod = 0,
				evaluator = res.res
			}});
			return
		end
	end

	ChatManager.SystemMessage("Usage: /die [DieCode] [description]");
end

function fpBuildThrow(aSource,vTargets,aRoll,bMultiTarget)
	local aThrow = {};
	aThrow.type = aRoll.sType;
	aThrow.description = aRoll.sDesc;
	aThrow.secret = aRoll.bSecret;
	aThrow.shortcuts = {};
  local aSlot = {};
	aSlot.number = 0;
	aSlot.dice = aRoll.aDice;
	aSlot.metadata = aRoll;
	aSlot.custom = { evaluator = aRoll.evaluator }
	aThrow.slots = {aSlot};
	return aThrow;
end

function fpOnDiceLanded(oDragData)
	local sDragType = oDragData.getType();
	local aCustom = oDragData.getCustomData();
	if GameSystem.actions[sDragType] then
		local aSource,aRolls,aTargets = ActionsManager.decodeActionFromDrag(oDragData,true);
		for nIteration,vValue in ipairs(aRolls) do
			if #(vValue.aDice) > 0 then
				vValue.evaluator = aCustom.evaluator
				ActionsManager.handleResolution(vValue,aSource,aTargets);
			end
		end
		return true;
	end
end

function fpApplyModifiersToDragSlot(oDragData,i,aSource,bResolveIfNoDice)
	local aRoll = ActionsManager.decodeRollFromDrag(oDragData, i);
	local nDice = #(aRoll.aDice);
	local bModStackUsed = ActionsManager.applyModifiers(aSource,nil,aRoll);
	if bResolveIfNoDice and #(aRoll.aDice) == 0 then
		ActionsManager.resolveAction(aSource,nil,aRoll);
	else
		for kKey,vValue in pairs(aRoll) do
			if kKey == "sType" then
				oDragData.setSlotType(vValue);
			elseif kKey == "sDesc" then
				oDragData.setStringData(vValue);
			elseif kKey == "aDice" then
				local nNewDice = #(aRoll.aDice);
				for i = nDice+1,nNewDice do
					oDragData.addDie(aRoll.aDice[i]);
				end
			elseif kKey == "nMod" then
				oDragData.setNumberData(vValue);
			elseif kKey == "aRollCodes" then
				oDragData.setCustomData(vValue);
			else
				local sKey = tostring(kKey) or "";
				if sKey ~= "" then
					oDragData.setMetaData(sKey,tostring(vValue) or "");
				end
			end
		end
	end
	return bModStackUsed;
end

function fpSetRollCodesFromDesktop(aSource,aTarget,aRoll)
	return;
end

function fpDieRollResult(aSource,aTarget,aRoll)
	if aRoll.evalRes.done then
		Comm.deliverChatMessage(fpCreateActionMessage(aSource,aRoll));
	end
	return;
end

function fpOnDiceTotal(aMessage)
	local aStrings,_ = StringManager.split(aMessage.type,"|");
	if aStrings[1] == "normal" then
		return true,tonumber(aStrings[2]);
	end
	return false,0;
end


function fpPostRoll(aSource,aRoll)
	local evalRes = DiceRollEvaluator.eval(aRoll.evaluator, aRoll.aDice)
	if not evalRes.done then
		-- This is overwriting the old obj which we return. Should clone it
		local newRoll = aRoll
		newRoll.aDice = evalRes.newRolls
		Comm.throwDice(fpBuildThrow(aSource,nil,newRoll,false))
	end
	aRoll.evalRes = evalRes
	return aRoll;
end

function fpCreateActionMessage(aSource,aRoll)
	local aMessage = ChatManager.createBaseMessage(aSource,aRoll.sUser);
	aMessage.text = aMessage.text .. aRoll.sDesc;
	aMessage.dice = {}
	aMessage.type = "normal|" .. aRoll.evalRes.result
	for i,d in ipairs(aRoll.evalRes.diceHistory) do
		local sides = d.type:sub(2)
		local x = { result = d.result, type = d.type }

		if (d.flags.discarded) then
			x.type = "r" .. sides
		elseif (d.flags.exploded) then
			x.type = "p" .. sides
		end

		table.insert(aMessage.dice, x)
	end
	aMessage.diemodifier = aRoll.nMod;
	aMessage.dicedisplay = 1
	return aMessage;
end

-- DiceRollParser -------------------------------------------------------------
-- This models the actual AST and the parser that parses that AST. Generic 
-- parser combinators to be kept out of this section.
-------------------------------------------------------------------------------

DiceRollEvaluator = {}
function DiceRollEvaluator.eval(self,newResults)
	-- because we can't call setmetatable and use inheritance in FG, lets just do 
	-- a dumb dispatch to the sub evaluator based on the type.
	-- We don't want to just stash the function in our table at construction, because
	-- that messes up our tests because those functions are now part of the equality
	-- checks that we want to do. This is a necessary ugliness to make the tests nice.
	local t = string.upper(self.type:sub(1,1)) .. self.type:sub(2)
	local evaluator = DiceRollEvaluator["_eval" .. t]
	assert(
		type(evaluator) == "function",
		"Invalid Evaluator type. DiceRollEvaluator." .. t .. " is not a function."
	)
	return evaluator(self,newResults)
end

function DiceRollEvaluator.add(evaluators)
	return {
		type = "add",
		pendingEvaluators = evaluators,
		doneEvaluators = {}
	}
end

function DiceRollEvaluator._evalAdd(self, newResults)
	local newRolls = {}
	local remainingDice = newResults
	local pendingI = 1
	while pendingI <= #self.pendingEvaluators do
		local e = self.pendingEvaluators[pendingI]
		local thisRes = DiceRollEvaluator.eval(e, remainingDice)
		remainingDice = thisRes.diceResultsRemaining

		if (thisRes.done) then
			table.insert(self.doneEvaluators, { evaluator = e, result = thisRes })
			table.remove(self.pendingEvaluators,pendingI)
		else
			pendingI = pendingI + 1
			for _,v in ipairs(thisRes.newRolls) do
				table.insert(newRolls, v)
			end
		end
	end

	if #self.pendingEvaluators > 0 then
		return { done = false, newRolls = newRolls, diceResultsRemaining = remainingDice }
	else
		local result = 0
		local diceHistory = {}
		for _,ev in ipairs(self.doneEvaluators) do
			result = result + ev.result.result
			for _,dh in ipairs(ev.result.diceHistory) do
				table.insert(diceHistory, dh)
			end
		end
		return { done = true, result = result, diceHistory = diceHistory, diceResultsRemaining = remainingDice }
	end
end

-- TODO: The exploding in the O.G UDR is more featured than this, but it will
-- be easy enough to tweak later
-- TODO: We need to limit the possible dice to the ruleset dice instead of the YOLO approach here
-- TODO: We will also need to split this concept up once we support {4d4!,6d6!}kt7s5
function DiceRollEvaluator.dicePool(num,sides,isExploding,kN,tN,sN)
	local dieType = "d" .. string.format("%.0f",sides)
	local queued = ArrayUtils.repeatN(num,dieType)
	local o = {
		type = "dicePool",
		num = num,
		sides = sides,
		isExploding = isExploding,
		keepNum = kN,
		targetNum = tN,
		successNum = sN,
		queued = queued,
		pending = {},
		results = {}
	}
	return o
end

function DiceRollEvaluator._evalDicePool(self,newResults)
	-- If this the first evaluation, then we better send off the queued dice for rolling
	if #self.queued > 0 then
		local toQueue = self.queued
		for i=1, #self.queued do
			self.pending[i] = DieResult.new(self.queued[i])
		end
		self.queued = {}
		return { done = false, newRolls = toQueue, diceResultsRemaining = {} }
	else
		if #self.pending > #newResults then
			error(
				"Likely evaluator bug. Expected " .. 
				#self.pending .. 
				" die results but only got " .. 
				#newResults 
			)
		end
		local newQueue = {}

		local newResultsI=1
		local pendingI=1
		while pendingI <= #self.pending do
			local result = newResults[newResultsI]
			local thisPending = self.pending[pendingI]

			if result.type ~= thisPending.type then
				error(
					"Evaluator bug: got die type " ..
					result.type .. 
					" but was expecting " ..
					thisPending.type
				)
			end

			newResultsI = newResultsI + 1
			thisPending.result = thisPending.result + result.result

			if self.isExploding and result.result == self.sides then
				table.insert(newQueue,thisPending.type)
				thisPending.flags.exploded = true
				pendingI = pendingI + 1
			else
				table.insert(self.results,thisPending)
        table.remove(self.pending,pendingI)
			end
		end

		local remainingDice = {}
		for i=newResultsI, #newResults do
			table.insert(remainingDice,newResults[i])
		end

		if #self.pending > 0 then
			return { done = false, newRolls = newQueue, diceResultsRemaining = remainingDice }
		else
			table.sort(self.results, function (r1,r2) return r1.result > r2.result  end)
			local keep = self.keepNum or #self.results
			local sum = 0
			for i=1,keep do
				sum = sum + self.results[i].result
				if self.keepNum ~= nil then
					self.results[i].flags.kept = true
				end
			end
			for i=keep+1, #self.results do
				self.results[i].flags.discarded = true
			end

			-- TODO: Targets and Successes
			return { 
				done = true,
				result = sum,
				diceHistory = self.results,
				diceResultsRemaining = remainingDice
			}
		end
	end
end

DieResult = {}
function DieResult.new(type)
	local o = { type = type, result = 0, flags = { exploded = false }}
	return o
end

DiceRollParser = {}

-- TODO: Where should modifiers go?
-- TODO: What about our other arithmetic?

function DiceRollParser.die()
	return Parser.lift3(
		Parser.litChar('d'),
		Parser.number(), -- TODO: Allow expressions?
		Parser.map(Parser.optional(Parser.litChar("!")), function (e) return e ~= nil end ),
		function (_,side,exploding) 
			return { type = "die", side = side, exploding = exploding }
		end
	) 
end

function DiceRollParser.keep()
	-- TODO: Allow keep lowest and keep highest
	return Parser.andThen(Parser.litChar("k"), function (_)
		-- TODO: Allow expressions for the kn val?
		return Parser.map(Parser.optional(Parser.number()), function (n)
			if n == nil then
				return 1
			else
				return n
			end
		end)
	end)
end

function DiceRollParser.target()
	return Parser.andThen(Parser.litChar("t"), function (_)
		return Parser.number() -- TODO: Allow expressions for the kn val?
	end)
end

function DiceRollParser.success()
	return Parser.andThen(Parser.litChar("s"), function (_)
		return Parser.number() -- TODO: Allow expressions for the kn val?
	end)
end

function DiceRollParser.dicePool()
	return Parser.lift5(
		Parser.number(),
		DiceRollParser.die(),
		Parser.optional(DiceRollParser.keep()),
		Parser.optional(DiceRollParser.target()),
		Parser.optional(DiceRollParser.success()),
		function (n,d,k,t,s)
			return DiceRollEvaluator.dicePool(n,d.side,d.exploding,k,t,s)
		end
	)
end

-- This is just a very simplistic add function that doesn't match our arithmetic
-- grammar but lets us test some degree of nesting of evaluators with a syntax
-- that doesn't force us to add a negative lookahead combinator like a + b does.
function DiceRollParser.add()
	return Parser.lift4(
		Parser.lit("add"),
		Parser.litChar("("),
		Parser.oneOrMany(DiceRollParser.dicePool(),Parser.litChar(",")),
		Parser.litChar(")"),
		function (_,_,exprs,_)
			return DiceRollEvaluator.add(exprs)
		end
	)
end

function DiceRollParser.expression()
	return Parser.oneOf(
		-- We use the lazy combinator to tie the knot of our recursive parser
		-- Without the laziness we'd stack overflow just constructing the parser

		-- We go out of our way here to make this right-recursive by making sure 
		-- none of these top level constructs start with the same character. 
		-- This means that we wont match roll20, but it'll be much easier on us
		-- and should still meet our needs
		{ 
			{ desc = "dicePool", parser = Parser.lazy(DiceRollParser.dicePool) },
			{ desc = "add", parser = Parser.lazy(DiceRollParser.add) },
		}
	)
end
