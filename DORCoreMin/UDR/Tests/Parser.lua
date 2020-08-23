local function id(x)
	return x	
end
local function const(x,y)
	return x	
end

ParserResult = { isOk = false }
function ParserResult:new(o)
	self.__index = self
	setmetatable(o, self)
	return o
end
function ParserResult.err(e) 
	return ParserResult:new({err = e})
end
function ParserResult.ok(res,rest) 
	return ParserResult:new({isOk = true, res = res, rest=rest})
end
function ParserResult:map(fn)
	if self.isOk then
		return ParserResult.ok(fn(self.res),self.rest)
	else
		return self
	end
end

Parser = { run = nil } 
function Parser:new(fn)
	local o = { run = fn } 
	self.__index = self
	setmetatable(o, self)
	return o
end
function Parser:lazy(fn)
	return Parser:new(function (input)
		return fn().run(input)
	end)
end
function Parser:map(fn)
	return Parser:new(function (input)
		return self.run(input):map(fn)
	end)	
end
function Parser:flatMap(fn)
	return Parser:new(function (input)
		local res = self.run(input):map(fn)
		if res.isOk then
			return res.res.run(res.rest)
		else
			return res
		end
	end)
end

function Parser.matchChar(fn)
	return Parser:new(function (input)
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

function Parser.oneOf(choices)
	if #choices == 0 then
		error("Parser.oneOf must have at least one choice")
	end
	return Parser:new(function (input)
		local strChars = ""
		local isFirst = true
		for i=1, #choices do
			local choice = choices[i]
			local desc = choice.desc
			local parser = choice.parser or choice
			local res = parser.run(input)
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

function Parser.oneOfChars(chars)
	if #chars == 0 then
		error("Parser.oneOfChars must have at least one character")
	end
	-- Yes, this could be implemented in terms of oneOf, but it's better to have this specialised
	-- concise error
	return Parser.matchChar(function (thisChar)
		local strChars = ""
		local isFirst = true
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
	end)
end

function Parser.lit(str)
	return Parser:new(function (input)
		if string.sub(input,1,#str) == str then
			return ParserResult.ok(str,string.sub(input,#str+1))
		else
			return ParserResult.err("Got '" .. input .. "'. Expected '" .. str .. "'.")
		end
	end)
end

function Parser.litChar(c)
	return Parser.matchChar(function (thisChar)
		if thisChar ~= c then
			if thisChar == nil then thisChar = "EOF" end
			return "Got char '" .. thisChar .. "'. Expected '" .. c .. "'."
		end
	end)
end

function Parser.digit()
	return Parser.oneOfChars({"0","1","2","3","4","5","6","7","8","9"}):map(
		function (d)
			return tonumber(d)
		end
	)
end

-- Use this with caution! Backtracking in a parser can be a horrible performance
-- issue! But it's often easier to reason about trying a combinator rather than 
-- looking ahead. For our little dice codes, we should be fine with this!
function Parser.optional(parser)
	return Parser:new(function (input)
		local out = parser.run(input)
		if (out.isOk) then
			return out 
		else
			-- This is the dangerous part! Because we consume no input, we break the
			-- invariant that each parser consumes some input or errors, meaning we
			-- can't guarantee termination of the parser anymore. So please use this 
			-- sparingly.
			return ParserResult.ok(nil, input)
		end
	end)
end

function Parser.oneOrMany(parser, sep)
	return Parser:new(function (input)
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
				newRes = parser.run(rest)
				first = false
			else
				newRes = pWithSep.run(rest)
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



function Parser.number()
	return Parser.oneOrMany(Parser.digit()):map(function (digits)
		local out = 0
		for i=#digits, 1, -1 do
			out = out + (digits[i]*10^(#digits-i))
		end
		return out
	end)
end

function Parser.lift2(parser1, parser2, fn)
	return parser1:flatMap( function (r1)
		return parser2:map( function (r2)
			return fn(r1,r2)
		end)
	end)
end

function Parser.lift3(parser1, parser2, parser3, fn)
	return parser1:flatMap( function (r1)
		return parser2:flatMap( function (r2)
			return parser3:map( function (r3)
				return fn(r1,r2,r3)
			end)
		end)
	end)
end

function Parser.lift4(parser1, parser2, parser3, parser4, fn)
	return parser1:flatMap( function (r1)
		return parser2:flatMap( function (r2)
			return parser3:flatMap( function (r3)
				return parser4:map( function (r4)
					return fn(r1,r2,r3,r4)
				end)
			end)
		end)
	end)
end

function Parser.lift5(parser1, parser2, parser3, parser4, parser5, fn)
	return parser1:flatMap( function (r1)
		return parser2:flatMap( function (r2)
			return parser3:flatMap( function (r3)
				return parser4:flatMap( function (r4)
					return parser5:map( function (r5)
						return fn(r1,r2,r3,r4,r5)
					end)
				end)
			end)
		end)
	end)
end

function Parser.orDefault(parser,default)
	Parser.optional(parser):map( function (r) 
		if r == nil then
			return default
		else
			return r
		end
	end)
end

DiceParser = {}

-- TODO: Where should modifiers go?
-- TODO: What about our other arithmetic?

function DiceParser.die()
	return Parser.lift3(
		Parser.litChar('d'),
		Parser.number(), -- TODO: Allow expressions?
		Parser.optional(Parser.litChar("!")):map( function (e) return e ~= nil end ),
		function (_,side,exploding) return { type = "die", side = side, exploding = exploding } end
	) 
end

function DiceParser.keep()
	-- TODO: Allow keep lowest and keep highest
	return Parser.litChar("k"):flatMap(function (_)
		-- TODO: Allow expressions for the kn val?
		return Parser.optional(Parser.number()):map(function (n)
			if n == nil then
				return 1
			else
				return n
			end
		end)
	end)
end

function DiceParser.target()
	return Parser.litChar("t"):flatMap(function (_)
		return Parser.number() -- TODO: Allow expressions for the kn val?
	end)
end

function DiceParser.success()
	return Parser.litChar("s"):flatMap(function (_)
		return Parser.number() -- TODO: Allow expressions for the kn val?
	end)
end

function DiceParser.dicePool()
	return Parser.lift5(
		Parser.number(),
		DiceParser.die(),
		Parser.optional(DiceParser.keep()),
		Parser.optional(DiceParser.target()),
		Parser.optional(DiceParser.success()),
		function (n,d,k,t,s)
			return { type = "pool", num = n, die = d, keep = k, target = t, success = s }	
		end
	)
end

function DiceParser.poolFn()
	return Parser.lift4(
		Parser.oneOf({Parser.lit("add"),Parser.lit("sub")}),
		Parser.litChar("("),
		Parser.oneOrMany(DiceParser.dicePool(),Parser.litChar(",")),
		Parser.litChar(")"),
		function (fnName,_,exprs,_)
			return { type = "poolFn", name = fnName, expressions = exprs }
		end
	)
end

function DiceParser.expression()
	return Parser.oneOf(
		-- We use the lazy combinator to tie the knot of our recursive parser
		-- Without the laziness we'd stack overflow just constructing the parser

		-- We go out of our way here to make this right-recursive by making sure 
		-- none of these top level constructs start with the same character. 
		-- This means that we wont match roll20, but it'll be much easier on us
		-- and should still meet our needs
		{ 
			{ desc = "dicePool", parser = Parser:lazy(DiceParser.dicePool) },
			{ desc = "poolFn", parser = Parser:lazy(DiceParser.poolFn) },
		}
	)
end