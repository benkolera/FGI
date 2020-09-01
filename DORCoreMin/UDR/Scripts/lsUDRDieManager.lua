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
- [x] targets and successes
- [x] make it so we can do `3d6!+5d8!k` instead of add(x,y)
- [x] Handle the modifiers
- [x] Test that dragging of sheet with a modifier works (in star frontiers we do rolls like `5d10` with a 3 modifier)
- [ ] handle percentage dice and d100 (no number)
- [ ] Making sure the output in the chatbox is nice and what we are used to
- [ ] Tests for all of the above

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
	Debug.console("fpProcessDie",sCommand,sDieCode)
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
	Debug.console("fpBuildThrow",aSource,vTargets,aRoll,bMultiTarget)
	local aThrow = {};
	aThrow.type = aRoll.sType;
	aThrow.description = aRoll.sDesc;
	aThrow.secret = aRoll.bSecret;
	aThrow.shortcuts = {};
  local aSlot = {};
	aSlot.number = aRoll.nMod;
	aSlot.dice = aRoll.aDice;
	aSlot.metadata = aRoll;
	aSlot.custom = { evaluator = aRoll.evaluator }
	aThrow.slots = {aSlot};
	return aThrow;
end

function fpOnDiceLanded(oDragData)
	local sDragType = oDragData.getType();
	local aCustom = oDragData.getCustomData();
	Debug.console("onDiceLanded",oDragData,sDragType, aCustom)
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
	Debug.console("fpApplyModifiersToDragSlot",oDragData,i,aSource,bResolveIfNoDice)
	local nDice = #(aRoll.aDice);
	local bModStackUsed = ActionsManager.applyModifiers(aSource,nil,aRoll);
	Debug.chat("DragSlot",oDragData,i, aSource, bResolveIfNoDice,bModStackUsed)
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
	Debug.console("FromDesktop",aSource, aTarget, aRoll)
	if aRoll.evaluator == nil then
		aRoll.evaluator = DiceRollEvaluator.fromDesktop(
			aRoll.aDice,
			fpSetX1Code(),
			fpSetKCode(),
			fpSetTCode(),
			fpSetSCode()
		)
	end
	return;
end

function fpDieRollResult(aSource,aTarget,aRoll)
	Debug.console("fpDieRollResult",aSource,aTarget,aRoll)
	if aRoll.evalRes.done then
		Comm.deliverChatMessage(fpCreateActionMessage(aSource,aRoll));
	end
	return;
end

function fpOnDiceTotal(aMessage)
	Debug.console("fpOnDiceTotal",aMessage)
	local aStrings,_ = StringManager.split(aMessage.type,"|");
	if aStrings[1] == "normal" then
		return true,tonumber(aStrings[2]);
	end
	return false,0;
end


function fpPostRoll(aSource,aRoll)
	Debug.console("fpPostRoll",aSource,aRoll)
	local evalRes = DiceRollEvaluator.eval(aRoll.evaluator, aRoll.aDice,aRoll.nMod)
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
	Debug.console("fpCreateActionMessage",aSource,aRoll)
	local aMessage = ChatManager.createBaseMessage(aSource,aRoll.sUser);
	aMessage.text = aMessage.text .. aRoll.sDesc;
	aMessage.dice = {}
	aMessage.type = "normal|" .. aRoll.evalRes.result.poolTotal
	for _,d in ipairs(aRoll.evalRes.diceHistory) do
		local sides = d.type:sub(2)
		local x = { result = d.result, type = d.type }

		if (d.flags.discarded) then
			x.type = "r" .. sides
		elseif (d.flags.success) then
			x.type = "g" .. sides
		elseif (d.flags.exploded) then
			x.type = "p" .. sides
		end

		table.insert(aMessage.dice, x)
	end
	aMessage.diemodifier = aRoll.nMod
	aMessage.dicedisplay = 1
	return aMessage;
end

-- TODO Disable with P
function fpSetKCode()
	local oKeepDiceBoxWindow = Interface.findWindow("wcKeepDiceBox","");
	local code = nil;
	Debug.console("fpSetCode", KeepDiceBoxManager.fpGetKeepDice(), oKeepDiceBoxWindow.bcKeepHighButton.getValue())
	if oKeepDiceBoxWindow and KeepDiceBoxManager.fpGetKeepDice() ~= 0 then
		local nK,_ = KeepDiceBoxManager.fpGetKeepDice();
		code = { keepNum = nK }

		if oKeepDiceBoxWindow.bcKeepHighButton then
			code.highest = oKeepDiceBoxWindow.bcKeepHighButton.getValue() == 0
		end
	end

	return code;
end

function fpSetSCode()
	local oSuccessRaiseBoxWindow = Interface.findWindow("wcSuccessRaiseBox","");
	if oSuccessRaiseBoxWindow and SuccessRaiseBoxManager.fpIsActive() then
		return SuccessRaiseBoxManager.fpGetRaises();
	end
	return nil
end

function fpSetTCode()
	local oTNBoxWindow = Interface.findWindow("wcTNBox","");
	local code = nil
	if oTNBoxWindow and TNBoxManager.fpIsActive() then
		local nTN,_ = TNBoxManager.fpGetTN();
		code = { targetNum = nTN }

		if oTNBoxWindow.bcAboveBelowButton and oTNBoxWindow.bcAboveBelowButton.getValue() == 1 then
			code.above = false
		else
			code.above = true
		end
	end
	return code;
end

function fpSetX1Code()
	local oModWindow = Interface.findWindow("modifierstack","");
	local explodes = false;
	if oModWindow then
		Debug.console("fpSetX1Code",oModWindow.bcExplodeButton.getValue())
		if oModWindow.bcExplodeButton then
			explodes = oModWindow.bcExplodeButton.getValue() == 1;
		end
	end
	return explodes;
end

-- DiceRollParser -------------------------------------------------------------
-- This models the actual AST and the parser that parses that AST. Generic 
-- parser combinators to be kept out of this section.
-------------------------------------------------------------------------------

-- TODO: This structure is going to need some work as we do and decide on the 
-- output of the chatbox when raises happen. What do we want to print if we're
-- adding two pools that have raises? Does this even make sense?
PoolResult = {}
function PoolResult.new(r1)
	r1.__index = PoolResult
	return r1
end

function PoolResult.add(r1,r2)
	if r1.__index ~= PoolResult or r2.__index ~= PoolResult then
		error("Trying to PoolResult.add() things that aren't a PoolResult: " .. type(r1) .. " " .. type(r2))
	end

	if (r1.type == "zero") then
		return r2
	elseif (r1.type == "sum" and r2.type == "sum") then
		return PoolResult.sum(r1.poolTotal + r2.poolTotal, r1.success and r2.success)
	elseif (r1.type == "successes" and r2.type == "successes") then
		-- TODO: Does this even make sense? Dunno, current grammar spec allows it
		return PoolResult.successes(
			r1.poolTotal + r2.poolTotal,
			r1.success and r2.success,
			r1.successes + r2.successes
		)
	else
		error(
			"You have made a dice code that adds pools that return different types of things! " .. 
			"This isn't your fault, we should exclude this from the parser or figure out what it " ..
			"means and implement it. :)"
		)
	end
end

function PoolResult.zero()
	return PoolResult.new({ type = "zero", poolTotal = 0 })
end
function PoolResult.sum(poolTotal, successNilable)
	local success = true	
	if (successNilable ~= nil) then success = successNilable end
	return PoolResult.new({ type = "sum", poolTotal = poolTotal, success = success })
end
function PoolResult.successes(poolTotal,success,successes)
	return PoolResult.new({ type = "successes", poolTotal = poolTotal, success = success, successes = successes })
end


DiceRollEvaluator = {}
function DiceRollEvaluator.eval(self,newResults, nMod)
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
	return evaluator(self,newResults,nMod)
end

function DiceRollEvaluator.add(eval1,eval2)
	return {
		type = "add",
		pendingEvaluators = {eval1,eval2},
		doneEvaluators = {}
	}
end

function DiceRollEvaluator._evalAdd(self, newResults,nMod)
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
		local result = PoolResult.zero()
		local diceHistory = {}
		for _,ev in ipairs(self.doneEvaluators) do
			result = PoolResult.add(result,ev.result.result)
			for _,dh in ipairs(ev.result.diceHistory) do
				table.insert(diceHistory, dh)
			end
		end
		if (nMod ~= nil and nMod ~= 0) then
			-- TODO: This is a gross hack. Find a better way
			-- This really highlights that Targets and Raises should only be allowed at the top level and
			-- never in a place where we can do addition. Tidy this up because it's important that our 
			-- grammar only lets through addition that makes sense
			if result.type == "sum" then
				result = PoolResult.sum(result.poolTotal + nMod, result.success)
			else
				-- TODO: We shouldn't be able to get this error. Revisit it if we decide whether addition
				-- on pools with raises makes sense.
				error("Can't really apply a modifier to this sum. PoolResult type: " .. result.type)
			end
		end
		return { done = true, result = result, diceHistory = diceHistory, diceResultsRemaining = remainingDice }
	end
end

-- TODO: The exploding in the O.G UDR is more featured than this, but it will
-- be easy enough to tweak later
-- TODO: We need to limit the possible dice to the ruleset dice instead of the YOLO approach here
-- TODO: We will also need to split this concept up once we support {4d4!,6d6!}kt7s5
function DiceRollEvaluator.dicePool(num,sides,isExploding,kN,target,alreadyQueued)
	Validation.run("num",Validation.isNatural)(num)
	Validation.run("sides", Validation.isNatural)(sides)
	Validation.run("keepNum", Validation.isOptNatural)(kN)

	local dieType = "d" .. string.format("%.0f",sides)
	local queued = {}
	local pending = {}
	if (alreadyQueued) then
		pending = ArrayUtils.repeatNLazy(num, function () return DieResult.new(dieType) end)
	else 
		queued = ArrayUtils.repeatN(num,dieType)
	end
	local o = {
		type = "dicePool",
		num = num,
		sides = sides,
		isExploding = isExploding,
		keepNum = kN,
		target = target,
		queued = queued,
		pending = pending,
		results = {}
	}
	return o
end

function DiceRollEvaluator._evalDicePool(self,newResults,nMod)
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
			local sum = nMod or 0

			for i=1,keep do
				sum = sum + self.results[i].result
				if self.keepNum ~= nil then
					self.results[i].flags.kept = true
				end
			end
			for i=keep+1, #self.results do
				self.results[i].flags.discarded = true
			end

			local poolResult

			if (self.target) then
				-- TODO: This assumes it can never have rolls. This is ugly. We need to make 
				-- recursive evaluators more automatic.
				poolResult = DiceRollEvaluator.eval(self.target,{}).res(sum)
				-- If we have a success, then mark the kept dice as successes
				if poolResult.success then
					for _,x in ipairs(self.results) do
						if (x.flags.kept) then
							x.flags.success = true
						end
					end
				end
			else
				poolResult = PoolResult.sum(sum)
			end

			return { 
				done = true,
				result = poolResult,
				diceHistory = self.results,
				diceResultsRemaining = remainingDice
			}
		end
	end
end

function DiceRollEvaluator.poolTarget(targetNum,raiseNum,alreadyQueued)
	local o = {
		type = "poolTarget",
		targetNum = targetNum,
		raiseNum = raiseNum
	}
	return o
end

function DiceRollEvaluator._evalPoolTarget(self,newResults)
	-- We don't allow any recursive things in poolTargets yet (if ever), so always return
	-- the function
	return {
		done = true,
		remainingDice = newResults,
		res = function(poolRes)
			local targetRes = poolRes - self.targetNum
			local success = false

			if (targetRes >= 0) then
				success = true
			else
				targetRes = 0
			end

			if (self.raiseNum == nil) then
				return PoolResult.sum(poolRes, success)
			elseif (self.raiseNum) then
				local successes = 0
				if success then
					successes = 1 + math.floor(targetRes/self.raiseNum)
				end
				return PoolResult.successes( poolRes, success, successes )
			end
		end
	}
end

function DiceRollEvaluator.fromDesktop(aDice,explodes,keepCode,targetCode,sCode)
	Debug.console(aDice,explodes,keepCode,targetCode,sCode)
	if #aDice == 0 then
		error("DiceRollEvaluator.fromDesktop called with no dice")
	end

	-- group the dice codes that we are given into contiguous dice sets
	local dicePoolEvaluator = nil
	local current = aDice[1]
	local currentCount = 1

	local function appendEval()
		local target = nil
		-- TODO: Ignoring below target for now
		if (targetCode ~= nil) then 
			target = DiceRollEvaluator.poolTarget( targetCode.targetNum, sCode, true )
		end
		local keepNum = nil
		-- TODO: Ignoring keep lowest for now
		if (keepCode ~= nil) then
			keepNum = keepCode.keepNum
		end

		local thisEval = DiceRollEvaluator.dicePool(
			currentCount,
			tonumber(current:sub(2)),
			explodes,
			keepNum,
			target,
			true
		)
		
		if (dicePoolEvaluator == nil) then
			dicePoolEvaluator = thisEval
		else
			dicePoolEvaluator = DiceRollEvaluator.add(dicePoolEvaluator,thisEval)
		end
	end

	for i=2, #aDice do
		local v = aDice[i]
		if (current ~= v) then
			appendEval()
			currentCount = 1
			current = v
		else
			currentCount = currentCount + 1
		end
	end

	appendEval()

	if (dicePoolEvaluator == nil) then
		Debug.console("DicePoolEvaluator.fromDesktop",aDice,keepCode,targetCode,sCode)
		error("DicePoolEvaluator.fromDesktop did not return an evaluator. Weird.")
	end

	return dicePoolEvaluator
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
	-- TODO: Less than and greater than targets
	-- TODO: Raises don't make sense with less than targets!
	return Parser.lift3(
		Parser.litChar("t"),
		Parser.number(),
		Parser.optional(DiceRollParser.raises()),
		function (_,t,r)
			return DiceRollEvaluator.poolTarget(t,r)
		end
	)
end

function DiceRollParser.raises()
	return Parser.andThen(Parser.litChar("s"), function (_)
		return Parser.number() -- TODO: Allow expressions for the kn val?
	end)
end

function DiceRollParser.dicePool()
	return Parser.lift4(
		Parser.number(),
		DiceRollParser.die(),
		Parser.optional(DiceRollParser.keep()),
		Parser.optional(DiceRollParser.target()),
		function (n,d,k,t)
			return DiceRollEvaluator.dicePool(n,d.side,d.exploding,k,t)
		end
	)
end

-- TODO: Add more operators!
function DiceRollParser.add()
	return Parser.chainOperandsl(
		DiceRollParser.dicePool(),
		Parser.map(Parser.litChar("+"),function (_) return DiceRollEvaluator.add end)
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
			{ desc = "add", parser = Parser.lazy(DiceRollParser.add) },
			{ desc = "dicePool", parser = Parser.lazy(DiceRollParser.dicePool)
			},
		}
	)
end
