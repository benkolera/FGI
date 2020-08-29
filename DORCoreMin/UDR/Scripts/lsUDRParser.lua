Result = {}

--- Make a result that is failed and cannot continue
-- @param e:S The error string for explaining what went wrong
function Result.err(e) 
	return {err = e}
end
--- Make a result that has a result and the leftover input
-- @param res: Any type. The result of parsing
-- @param rest: The remaining input that other parsers can continue parsing
function Result.ok(res,rest) 
	return {isOk = true, res = res, rest=rest}
end

--- Transform the result inside the Parser result with a function
-- @param fn: The function to apply to the result that returns a new value
-- @usage 
--   local res = Result.ok(1,"")
--   Result.map(res, function (x) return x + 1 end)
--   -- Returns { isOk = true, res = 2, rest = "" }
function Result.map(pr,fn)
	if pr.isOk then
		return Result.ok(fn(pr.res),pr.rest)
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
-- @param fn: A function(res,rest) return <Result> end
-- @see Parser.andThen
-- @usage It's best to look at Parser.andThen insead.
-- > function isEndOfInput(res, rest)
--     if rest == ""
--     then res
--     else Result.err("Input still remaining: " .. rest)
--   end
-- > Result.andThen(Result.ok("Woot",""),isEndOfInput)
-- { isOk = true, res = "Woot", rest = "" }
-- > Result.andThen(Result.ok("Woot"," Oh no!"),isEndOfInput)
-- { isOk = false, err = "Input still remaining:  Oh no!" }
-- > Result.andThen(Result.err("AlreadyBroken"),isEndOfInput)
-- { isOk = false, err = "AlreadyBroken" }
function Result.andThen(pr, fn)
	if pr.isOk then
		return fn(pr.res,pr.rest)
	else
		return pr
	end
end

--- A parser is actually pretty simple! All it is is a function!
-- A function from an input string to a Result whose responsibility it is to take a string and
-- either:
-- - Return an error because the conditions it needed weren't met OR
-- - Return a result and the remainder of the string that it did not eat.
--
-- This feels pretty silly at first, but the power comes from how giving these functions a name 
-- allows us to start composing them into bigger parsers. This allows us to build small parsing
-- routines and reuse them a lot easier than if we were coding the parsers imperatively iterating
-- over the characters in place. 
--
-- @param fn: The actual parser function from string -> Result
function new(fn)
	if (type(fn) ~= "function") then
		error("Parser.new was not given a function: " .. type(fn))
	end
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
function lazy(fn)
	return new(function (input)
		return fn().parse(input)
	end)
end

--- A parser that always fails regardless of the output
-- @param err: The error string to fail with
function fail(err)
	new(function () return Result.err(err) end)
end

--- Transform a parser to return somethind different when it is run.
-- @param fn: The function to apply to the result that returns a new value
-- @usage 
-- > local doubleNumber = Parser.map(Parser.number(),function (x) return x * 2 end)
-- > doubleNumber.parse("1") 
-- { isOk = true, res = 2, rest = "" }
function map(p, fn)
	return new(function (input)
		return Result.map(p.parse(input),fn)
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
function andThen(p, fn)
	return new(function (input)
		return Result.andThen(p.parse(input), function (res, rest)
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
function matchChar(fn)
	return new(function (input)
		local c = string.sub(input,1,1)
		local rest = string.sub(input,2)
		if c == "" then c = nil end
		local err = fn(c)
		if err == nil then
			return Result.ok(c, rest)
		else
			return Result.err(err)
		end
	end)
end

--- A parser that returns a character. only errors if we are at the end of input
function oneChar()
	return matchChar(function (x) return c ~= nil end)
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
function oneOf(choices)
	if #choices == 0 then
		error("Parser.oneOf must have at least one choice")
	end
	return new(function (input)
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
		return Result.err(
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
function oneOfChars(chars)
	if #chars == 0 then
		error("Parser.oneOfChars must have at least one character")
	end
	return matchChar(function (thisChar)
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
function lit(str)
	return new(function (input)
		if string.sub(input,1,#str) == str then
			return Result.ok(str,string.sub(input,#str+1))
		else
			return Result.err("Got '" .. input .. "'. Expected '" .. str .. "'.")
		end
	end)
end

--- A parser that matches a the head char only. This overlaps a lot with Parser.lit 
-- but gives a nicer error message. 
-- @param c: The character to match
function litChar(c)
	return matchChar(function (thisChar)
		if thisChar ~= c then
			if thisChar == nil then thisChar = "EOF" end
			return "Got char '" .. thisChar .. "'. Expected '" .. c .. "'."
		end
	end)
end

--- A parser that matches a single digit. Returns a number not a string.
function digit()
	return map(
		oneOfChars({"0","1","2","3","4","5","6","7","8","9"}),
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
function optional(parser)
	return new(function (input)
		local out = parser.parse(input)
		if (out.isOk) then
			return out
		else
			return Result.ok(nil, input)
		end
	end)
end

--- Parses with the parser or returns a default value (parsing no input)
-- This carries all the dangers of Parser.optional!
-- > Parser.orDefault(Parser.lit("foo"),"saved").parse("bar")
-- { isOk = true, res = "saved", rest = "bar" }
function orDefault(parser,default)
	map(
		optional(parser),
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
function oneOrMany(parser, sep)
	return new(function (input)
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
			pWithSep = lift2(sep,parser,function (_,r) return r end)
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
			return Result.ok( out, rest )
		else
      return Result.err(err)
		end
	end)
end

--- Parses a number
-- @usage
-- > Parser.number().parse("1337aaa")
-- { isOk = true, res = 1337, rest = "aaa" }
function number()
	return map(
		oneOrMany(digit()),
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
function lift2(p1, p2, fn)
	return andThen(p1, function (r1)
		return map(p2, function (r2)
			return fn(r1,r2)
		end)
	end)
end

function lift3(p1, p2, p3, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return map(p3, function (r3)
				return fn(r1,r2,r3)
			end)
		end)
	end)
end

function lift4(p1, p2, p3, p4, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return map(p4, function (r4)
					return fn(r1,r2,r3,r4)
				end)
			end)
		end)
	end)
end

function lift5(p1, p2, p3, p4, p5, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return andThen(p4, function (r4)
					return map(p5, function (r5)
						return fn(r1,r2,r3,r4,r5)
					end)
				end)
			end)
		end)
	end)
end

function lift6(p1, p2, p3, p4, p5, p6, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return andThen(p4, function (r4)
					return andThen(p5, function (r5)
						return map(p6, function (r6)
							return fn(r1,r2,r3,r4,r5,r6)
						end)
					end)
				end)
			end)
		end)
	end)
end

function lift7(p1, p2, p3, p4, p5, p6, p7, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return andThen(p4, function (r4)
					return andThen(p5, function (r5)
						return andThen(p6, function (r6)
							return map(p7, function (r7)
								return fn(r1,r2,r3,r4,r5,r6,r7)
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

function lift8(p1, p2, p3, p4, p5, p6, p7, p8, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return andThen(p4, function (r4)
					return andThen(p5, function (r5)
						return andThen(p6, function (r6)
							return andThen(p7, function (r7)
								return map(p8, function (r8)
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

function lift9(p1, p2, p3, p4, p5, p6, p7, p8, p9, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return andThen(p4, function (r4)
					return andThen(p5, function (r5)
						return andThen(p6, function (r6)
							return andThen(p7, function (r7)
								return andThen(p8, function (r8)
									return map(p9, function (r9)
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

function lift10(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, fn)
	return andThen(p1, function (r1)
		return andThen(p2, function (r2)
			return andThen(p3, function (r3)
				return andThen(p4, function (r4)
					return andThen(p5, function (r5)
						return andThen(p6, function (r6)
							return andThen(p7, function (r7)
								return andThen(p8, function (r8)
									return andThen(p9, function (r9)
										return map(p10, function (r10)
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