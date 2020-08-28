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

function repeatN(n,x)
	local out = {}
	for i=1, n do
		out[i] = x
	end
	return out
end

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
	local queued = repeatN(num,dieType)
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
		Parser.oneOf({Parser.lit("add"),Parser.lit("sub")}),
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

-------------------------------------------------------------------------------
-- Parser ---------------------------------------------------------------------
-- Generic parser things to not clog up the domain related parser bits.
-- TODO: Figure out whether this can be a separate FG module to declutter?
-------------------------------------------------------------------------------

ParserResult = {}

--- Make a result that is failed and cannot continue
-- @param e:S The error string for explaining what went wrong
function ParserResult.err(e) 
	return {err = e}
end
--- Make a result that has a result and the leftover input
-- @param res: Any type. The result of parsing
-- @param rest: The remaining input that other parsers can continue parsing
function ParserResult.ok(res,rest) 
	return {isOk = true, res = res, rest=rest}
end

--- Transform the result inside the Parser result with a function
-- @param fn: The function to apply to the result that returns a new value
-- @usage 
--   local res = ParserResult.ok(1,"")
--   ParserResult.map(res, function (x) return x + 1 end)
--   -- Returns { isOk = true, res = 2, rest = "" }
function ParserResult.map(pr,fn)
	if pr.isOk then
		return ParserResult.ok(fn(pr.res),pr.rest)
	else
		return pr
	end
end

--- This function is for taking a parser result and then doing some further
-- computation with the result and rest of the string or not bothering because
-- things have already failed. We use this to sequence parsers into a chain.
-- You probably wont call this yourself and it's really just for enabling 
-- andThen on parsers.
--
-- @param fn: A function(res,rest) return <ParserResult> end
-- @see Parser.andThen
-- @usage It's best to look at Parser.andThen insead.
-- > function isEndOfInput(res, rest)
--     if rest == ""
--     then res
--     else ParserResult.err("Input still remaining: " .. rest)
--   end
-- > ParserResult.andThen(ParserResult.ok("Woot",""),isEndOfInput)
-- { isOk = true, res = "Woot", rest = "" }
-- > ParserResult.andThen(ParserResult.ok("Woot"," Oh no!"),isEndOfInput)
-- { isOk = false, err = "Input still remaining:  Oh no!" }
-- > ParseResult.andThen(ParserResult.err("AlreadyBroken"),isEndOfInput)
-- { isOk = false, err = "AlreadyBroken" }
function ParserResult.andThen(pr, fn)
	if pr.isOk then
		return fn(pr.res,pr.rest)
	else
		return pr
	end
end

Parser = {} 
--- A parser is actually pretty simple! All it is is a function!
-- A function from an input string to a ParserResult whose responsibility it is to take a string and
-- either:
-- - Return an error because the conditions it needed weren't met OR
-- - Return a result and the remainder of the string that it did not eat.
--
-- This feels pretty silly at first, but the power comes from how giving these functions a name 
-- allows us to start composing them into bigger parsers. This allows us to build small parsing
-- routines and reuse them a lot easier than if we were coding the parsers imperatively iterating
-- over the characters in place. 
--
-- @param fn: The actual parser function from string -> ParserResult
function Parser.new(fn)
	local o = { parse = fn }
	return o
end

--- If we want to define recursive grammars, at some point we'll want to make a circular reference
-- between parsers. Because lua is a strict language, there is no way we can have parsers that are
-- infinitely recursive without breaking the cycle. Take these parsers:
--
--   function addParser() = Parser.lift5(
--     Parser.lit("add("),
--     expressionParser(),
--     Parser.lit(","),
--     expressionParser(),
--     Parser.lit(")"),
--     function(_,exp1,_,exp2,_) return { expr1, expr2 } end
--	 )
--   function expressionParser() = Parser.oneOf( addParser(), Parser.number() )
--
-- Defined this way, this would stack overflow because to make expressionParser you need to call
-- addParser and to make expressionParser you need addParser.
--
-- So instead you need:
--   function expressionParser() = Parser.oneOf( Parser.lazy(addParser), Parser.number )
--
-- TODO: We could have parsers *always* be lazy if we wanted to and maybe that's less confusing, but
-- we also don't have that much recursion in the grammar so it probably doesn't matter.
function Parser.lazy(fn)
	return Parser.new(function (input)
		return fn().parse(input)
	end)
end

--- A parser that always fails regardless of the output
-- @param err: The error string to fail with
function Parser.fail(err)
	Parser.new(function () return ParserResult.err(err) end)
end

--- Transform a parser to return somethind different when it is run.
-- @param fn: The function to apply to the result that returns a new value
-- @usage 
-- > local doubleNumber = Parser.map(Parser.number(),function (x) return x * 2 end)
-- > doubleNumber.parse("1") 
-- { isOk = true, res = 2, rest = "" }
function Parser.map(p, fn)
	return Parser.new(function (input)
		return ParserResult.map(p.parse(input),fn)
	end)	
end

--- Use this when you need to parse contextually. Say if you are parsing one character then need 
-- to parse the next bit of the string differently depending on what that result was.
-- @param fn: A function from old result to a parser
-- @usage
-- > p = Parser.andThen(Parser.oneChar(), function (c)
--     if c == "k" then return keepParser()
--     else if c == "t" then return targetParser()
--     else if c == "s" then return successParser()
--     else Parser.fail("Unknown pool modifier charcode found: " .. c)
--   end)
-- > p.parse("a")
-- { isOk = false, err = "Unknown pool modifier charcode found: a"}
function Parser.andThen(p, fn)
	return Parser.new(function (input)
		return ParserResult.andThen(p.parse(input), function (res, rest)
			return fn(res).parse(rest)
		end)
	end)
end

--- A parser that matches a char based on a predicate that looks at the char and returns an error
-- or not. If there is no error, this parser returns that character.
-- @param fn: A function from string -> (string or nil)
-- @usage
-- > p = Parser.matchChar(function (c) if c ~= "a" then return "we wanted a, fool" end)
-- > p.parse("a")
-- { isOk = true, res = "a", rest = "" }
-- > p.parse("b")
-- { isOk = false, err = "we wanted a, fool" }
function Parser.matchChar(fn)
	return Parser.new(function (input)
		local c = string.sub(input,1,1)
		local rest = string.sub(input,2)
		if c == "" then c = nil end
		local err = fn(c)
		if err == nil then
			return ParserResult.ok(c, rest)
		else
			return ParserResult.err(err)
		end
	end)
end

--- A parser that returns a character. only errors if we are at the end of input
function Parser.oneChar()
	return Parser.matchChar(function (x) return c ~= nil end)
end

--- A parser that takes a list of parsers and tries them in order
-- @param choices: A list of parsers or a list of { desc = <string>, parser = <Parser> }
-- @usage
-- > p = Parser.oneOf({
--     {desc = "a", parser = Parser.litChar("a") },
--     {desc = "num", parser = Parser.number() }
--   })
-- > p.parse(21)
-- { isOk = true, res = 21, rest = "" }
function Parser.oneOf(choices)
	if #choices == 0 then
		error("Parser.oneOf must have at least one choice")
	end
	return Parser.new(function (input)
		local strChars = ""
		local isFirst = true
		for i=1, #choices do
			local choice = choices[i]
			local desc = choice.desc
			local parser = choice.parser or choice
			local res = parser.parse(input)
			if res.isOk then return res end

			local sep
			if isFirst then
				sep = ""
				isFirst = false
			else 
				sep = "," 
			end
			strChars = strChars .. sep
			if desc ~= nil then	
				strChars = strChars .. choice.desc .. ":"
			end
			strChars = strChars  .. res.err
		end
		return ParserResult.err(
			"Could not parse " .. input .. ". Expecting on of {" .. strChars .. "}."
		)
	end)
end

--- Parses the head of the input and makes sure it is one of the characters given.
-- Note: This is not written in terms of Parser.oneOf and Parser.litChar to get a more concise 
-- error message when this fails.
-- @param chars: A list of chars
-- @usage
-- > Parser.oneOfChars({"a","b","c"}).parse("a dice")
-- { isOk = true, res = "a", rest = " dice" }
function Parser.oneOfChars(chars)
	if #chars == 0 then
		error("Parser.oneOfChars must have at least one character")
	end
	return Parser.matchChar(function (thisChar)
		local strChars = ""
		local isFirst = true
		if (thisChar ~= nil) then
			for _, value in pairs(chars) do
				if string.match(thisChar, value) then return nil end
				local sep
				if isFirst then 
					sep = "" 
					isFirst = false
				else 
					sep = "," 
				end
				strChars = strChars .. sep .. value
			end
			return "Got char '" .. thisChar .. "'. Expected one of {" .. strChars .. "}."
		else
			return "Expected one of {" .. strChars .. "} but hit EOF."
		end
	end)
end

--- A parser that matches a literal string and nothing else
-- @param str: The string to look for at the head of the input
-- @usage
-- > Parser.lit("foo").parse("foobar")
-- { isOk = true, res = "foo", rest = "bar" }
function Parser.lit(str)
	return Parser.new(function (input)
		if string.sub(input,1,#str) == str then
			return ParserResult.ok(str,string.sub(input,#str+1))
		else
			return ParserResult.err("Got '" .. input .. "'. Expected '" .. str .. "'.")
		end
	end)
end

--- A parser that matches a the head char only. This overlaps a lot with Parser.lit 
-- but gives a nicer error message. 
-- @param c: The character to match
function Parser.litChar(c)
	return Parser.matchChar(function (thisChar)
		if thisChar ~= c then
			if thisChar == nil then thisChar = "EOF" end
			return "Got char '" .. thisChar .. "'. Expected '" .. c .. "'."
		end
	end)
end

--- A parser that matches a single digit. Returns a number not a string.
function Parser.digit()
	return Parser.map(
		Parser.oneOfChars({"0","1","2","3","4","5","6","7","8","9"}),
		function (d)
			return tonumber(d)
		end
	)
end

--- This tries a parser and then consumes nothing and returns nil if the parser did not succeed.
-- This is dangerous, because now our parser isn't guaranteed to terminate anymore because there are
-- some parsers now that consume no input and we could be parsing nothing forever if we are not 
-- careful. You have to use this as optional stuff in the middle or end of a parser. Never at the
-- start. In a more complicated grammar with lots more branching you also have to worry about how 
-- big the optional parsers are, because with this kind of backtracking we could end up doing a lot
-- of wasted parsing and backtracking when things fail even if things do terminate.
--
-- Alas, this combinator is necessary for our grammar; just be careful with it.
-- @param parser
-- @usage 
-- > Parser.optional(Parser.lit("foo")).parse("bar")
-- { isOk = true, res = nil, rest = "bar" }
function Parser.optional(parser)
	return Parser.new(function (input)
		local out = parser.parse(input)
		if (out.isOk) then
			return out
		else
			return ParserResult.ok(nil, input)
		end
	end)
end

--- Parses with the parser or returns a default value (parsing no input)
-- This carries all the dangers of Parser.optional!
-- > Parser.orDefault(Parser.lit("foo"),"saved").parse("bar")
-- { isOk = true, res = "saved", rest = "bar" }
function Parser.orDefault(parser,default)
	Parser.map(
		Parser.optional(parser),
		function (r) 
			if r == nil then
				return default
			else
				return r
			end
		end
	)
end

--- parses oneOrMany instances of a parser, with an optional parser to parse separators between the 
-- things. Will error if there are no successful parses at the head (there must be at least 1)
-- @param parser: The Parser to parse each element
-- @param sep: An optional (can be nil) parser to parse a separator between each element. This 
-- separator does not appear in the result
-- @usage
-- > Parser.oneOrMany(Parser.digit()).parse("12345aaa")
-- { isOk = true, res = {1,2,3,4,5}, rest = "aaa" }
-- > Parser.oneOrMany(Parser.number(),Parser.litChar(",")).parse("12,3,4,5,aaa")
-- { isOk = true, res = {12,3,4,5}, rest = ",aaa"}
function Parser.oneOrMany(parser, sep)
	return Parser.new(function (input)
		-- This explicitly uses an iteration rather than recursion because we can
		-- and we want to be friendly to the stack. So it's not as nice looking as 
		-- it usually is.

		local done = false
		local first = true
		local out = {}
		local rest = input
		local err = nil
		local pWithSep
		if sep ~= nil then
			pWithSep = Parser.lift2(sep,parser,function (_,r) return r end)
		end

		repeat
			local newRes
			if first or sep == nil then
				newRes = parser.parse(rest)
				first = false
			else
				newRes = pWithSep.parse(rest)
			end
			if newRes.isOk then
				rest = newRes.rest
				out[#out+1] = newRes.res
				done = rest == ""
			else
				err = newRes.err
				done = true
			end

		until done

		-- We want to error if there was no results, but if we error after one or more
		-- good results we're OK to return the good stuff.
		if next(out) ~= nil then
			return ParserResult.ok( out, rest )
		else
      return ParserResult.err(err)
		end
	end)
end

--- Parses a number
-- @usage
-- > Parser.number().parse("1337aaa")
-- { isOk = true, res = 1337, rest = "aaa" }
function Parser.number()
	return Parser.map(
		Parser.oneOrMany(Parser.digit()),
		function (digits)
			local out = 0
			for i=#digits, 1, -1 do
				out = out + (digits[i]*10^(#digits-i))
			end
			return out
		end
	)
end

--- There are an entire family of lift functions for smooshing together many parser into one.
-- This can often be nicer looking than chaining andThens, which is why we've gone to the effort
-- of making all of these ugly functions here. There are lift2 through to lift8
-- @param parser1: The first parser to parse with
-- @param parser2: The second parser to parse with
-- @param fn: function (parser1Result, parser2Result) return <combined result> end
-- @usage
-- > p = Parser.lift2( Parser.litChar("d"), Parser.number(), function(_,n) return { 'd', n } end)
-- > p.parse("d6")
-- { "d", 6 }
function Parser.lift2(p1, p2, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.map(p2, function (r2)
			return fn(r1,r2)
		end)
	end)
end

function Parser.lift3(p1, p2, p3, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.map(p3, function (r3)
				return fn(r1,r2,r3)
			end)
		end)
	end)
end

function Parser.lift4(p1, p2, p3, p4, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.map(p4, function (r4)
					return fn(r1,r2,r3,r4)
				end)
			end)
		end)
	end)
end

function Parser.lift5(p1, p2, p3, p4, p5, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.andThen(p4, function (r4)
					return Parser.map(p5, function (r5)
						return fn(r1,r2,r3,r4,r5)
					end)
				end)
			end)
		end)
	end)
end

function Parser.lift6(p1, p2, p3, p4, p5, p6, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.andThen(p4, function (r4)
					return Parser.andThen(p5, function (r5)
						return Parser.map(p6, function (r6)
							return fn(r1,r2,r3,r4,r5,r6)
						end)
					end)
				end)
			end)
		end)
	end)
end

function Parser.lift7(p1, p2, p3, p4, p5, p6, p7, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.andThen(p4, function (r4)
					return Parser.andThen(p5, function (r5)
						return Parser.andThen(p6, function (r6)
							return Parser.map(p7, function (r7)
								return fn(r1,r2,r3,r4,r5,r6,r7)
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

function Parser.lift8(p1, p2, p3, p4, p5, p6, p7, p8, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.andThen(p4, function (r4)
					return Parser.andThen(p5, function (r5)
						return Parser.andThen(p6, function (r6)
							return Parser.andThen(p7, function (r7)
								return Parser.map(p8, function (r8)
									return fn(r1,r2,r3,r4,r5,r6,r7,r8)
								end)
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

function Parser.lift9(p1, p2, p3, p4, p5, p6, p7, p8, p9, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.andThen(p4, function (r4)
					return Parser.andThen(p5, function (r5)
						return Parser.andThen(p6, function (r6)
							return Parser.andThen(p7, function (r7)
								return Parser.andThen(p8, function (r8)
									return Parser.map(p9, function (r9)
										return fn(r1,r2,r3,r4,r5,r6,r7,r8,r9)
									end)
								end)
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

function Parser.lift10(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, fn)
	return Parser.andThen(p1, function (r1)
		return Parser.andThen(p2, function (r2)
			return Parser.andThen(p3, function (r3)
				return Parser.andThen(p4, function (r4)
					return Parser.andThen(p5, function (r5)
						return Parser.andThen(p6, function (r6)
							return Parser.andThen(p7, function (r7)
								return Parser.andThen(p8, function (r8)
									return Parser.andThen(p9, function (r9)
										return Parser.map(p10, function (r10)
											return fn(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10)
										end)
									end)
								end)
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end