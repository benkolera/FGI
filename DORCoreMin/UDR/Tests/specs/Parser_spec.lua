require('Parser')

describe("litChar", function()
	it("should parse a literal", function ()
		local res = Parser.litChar("b").run("booyah")
		assert.are.same(ParserResult.ok("b","ooyah"), res)
	end)
	it("should error on the wrong literal", function ()
		local res = Parser.litChar("o").run("booyah")
		assert.are.same(ParserResult.err("Got char 'b'. Expected 'o'."), res)
	end)
end)

describe("lit", function()
	it("should parse a literal", function ()
		local res = Parser.lit("boo").run("booyah")
		assert.are.same(ParserResult.ok("boo","yah"), res)
	end)
	it("should error on the wrong literal", function ()
		local res = Parser.lit("ooy").run("booyah")
		assert.are.same(ParserResult.err("Got 'booyah'. Expected 'ooy'."), res)
	end)
end)

describe("digit", function()
	it("should parse a digit", function ()
		local res = Parser.digit().run("133t")
		assert.are.same(ParserResult.ok(1,"33t"), res)
	end)
	it("should error on the wrong literal", function ()
		local res = Parser.digit().run("booyah")
		assert.are.same(ParserResult.err("Got char 'b'. Expected one of {0,1,2,3,4,5,6,7,8,9}."), res)
	end)
end)

describe("oneOrMany(digit)", function()
	it("should parse digits but not die trailing non digits", function ()
		local res = Parser.oneOrMany(Parser.digit()).run("133t")
		assert.are.same(ParserResult.ok({1,3,3},"t"), res)
	end)
	it("should error on a nondigit first char", function ()
		local res = Parser.oneOrMany(Parser.digit()).run("booyah")
		assert.are.same(ParserResult.err("Got char 'b'. Expected one of {0,1,2,3,4,5,6,7,8,9}."), res)
	end)
end)

describe("number", function()
	it("should parse digits but not die trailing non digits", function ()
		local res = Parser.number().run("123d12")
		assert.are.same(ParserResult.ok(123,"d12"), res)
	end)
end)

describe("flatMappyThings", function()
	it("flatmap should work", function ()
		local testParser = Parser.digit():flatMap(function (d) 
			if (d == 1) then
				return Parser.litChar('a')
			else
				return Parser.litChar('b')
			end
		end)
		assert.are.same(ParserResult.ok("a",""),testParser.run("1a"))
		assert.are.same(ParserResult.err("Got char 'b'. Expected 'a'."),testParser.run("1b"))
		assert.are.same(ParserResult.ok("b",""),testParser.run("2b"))
		assert.are.same(ParserResult.err("Got char 'a'. Expected 'b'."),testParser.run("5a"))
	end)
	it("lift3 should parse a dice set", function ()
		local res = Parser.lift3(
			Parser.number(),
			Parser.litChar("d"),
			Parser.number(),
			function (num, _, sides)
				return { num = num, sides = sides }
			end
		).run("5d12")
		assert.are.same(ParserResult.ok({ num = 5, sides = 12 },""), res)
	end)
	it("lift{1-5} should do their thing", function ()
		assert.are.same(
			ParserResult.ok({"a","b"}, ""),
			Parser.lift2(
				Parser.litChar("a"),
				Parser.litChar("b"),
				(function (a,b) return {a,b} end)
			).run("ab")
		)
		assert.are.same(
			ParserResult.ok({"a","b","c"}, ""),
			Parser.lift3(
				Parser.litChar("a"),
				Parser.litChar("b"),
				Parser.litChar("c"),
				(function (a,b,c) return {a,b,c} end)
			).run("abc")
		)
		assert.are.same(
			ParserResult.ok({"a","b","c","d"}, ""),
			Parser.lift4(
				Parser.litChar("a"),
				Parser.litChar("b"),
				Parser.litChar("c"),
				Parser.litChar("d"),
				(function (a,b,c,d) return {a,b,c,d} end)
			).run("abcd")
		)
		assert.are.same(
			ParserResult.ok({"a","b","c","d","e"}, ""),
			Parser.lift5(
				Parser.litChar("a"),
				Parser.litChar("b"),
				Parser.litChar("c"),
				Parser.litChar("d"),
				Parser.litChar("e"),
				(function (a,b,c,d,e) return {a,b,c,d,e} end)
			).run("abcde")
		)
	end)
end)

describe("try", function ()
	it("parses input if it matches", function ()
		local p = Parser.optional(Parser.litChar("!"))
		assert.are.same(
			ParserResult.ok("!","woo"),
			p.run("!woo")
		)
	end)
	it("leaves input if it doesn't match", function ()
		local p = Parser.optional(Parser.litChar("!"))
		assert.are.same(
			ParserResult.ok(nil,"woo"),
			p.run("woo")
		)
	end)
end)

describe("oneOf", function ()
	it("should pick the first option", function ()
		assert.are.same(
			ParserResult.ok("a",""),
			Parser.oneOf({
				{desc = "a", parser = Parser.litChar("a") },
				{desc = "num", parser = Parser.number() }
			}).run("a")
		)
	end)
	it("should pick the second option", function ()
		assert.are.same(
			ParserResult.ok(21,""),
			Parser.oneOf({
				{desc = "a", parser = Parser.litChar("a") },
				{desc = "num", parser = Parser.number() }
			}).run("21")
		)
	end)
	it("fail gracefully", function ()
		assert.are.same(
			ParserResult.err("Could not parse zzzzz. Expecting on of {An A:Got char 'z'. Expected 'a'.,A Number:Got char 'z'. Expected one of {0,1,2,3,4,5,6,7,8,9}.}."),
			Parser.oneOf({
				{desc = "An A", parser = Parser.litChar("a") },
				{desc = "A Number", parser = Parser.number() }
			}).run("zzzzz")
		)
	end)
	it("should work with sep", function ()
		assert.are.same(
			ParserResult.ok({1,2,3},""),
			Parser.oneOrMany(Parser.number(),Parser.litChar(",")).run("1,2,3")
		)
	end)
end)

describe("lazy", function ()
	it("should look like a normal parser", function ()
		assert.are.same(
			ParserResult.ok(123,""),
			Parser:lazy(function () return Parser.number() end).run("123")
		)
	end)	
end)

describe("DiceParser", function ()
	it("die should parse d6",function()
		assert.are.same(
			ParserResult.ok({ type = "die", side = 6, exploding = false },""),
			DiceParser.die().run("d6")
		)
	end)	
	it("die should parse d6!",function()
		assert.are.same(
			ParserResult.ok({ type = "die", side = 6, exploding = true },""),
			DiceParser.die().run("d6!")
		)
	end)	
	it("dicePool should parse 5d12!kt7s5",function ()
		assert.are.same(
			ParserResult.ok(
				{ 
					type = "pool", 
					num = 5,
					die = { type = "die", side = 12, exploding = true },
					keep = 1,
					target = 7,
					success = 5
				},
				""
			),
			DiceParser.dicePool().run("5d12!kt7s5")
		)
	end)
	it("expression should parse 3d6!",function ()
		assert.are.same(
			ParserResult.ok(
				{
					type = "pool", 
					num = 3,
					die = { type = "die", side = 6, exploding = true },
					keep = nil,
					target = nil,
					success = nil 
				},
				""
			),
			DiceParser.expression().run("3d6!")
		)
	end)
	it("expression should parse 3d6!",function ()
		assert.are.same(
			ParserResult.ok(
				{
					type = "pool", 
					num = 3,
					die = { type = "die", side = 6, exploding = true },
					keep = nil,
					target = nil,
					success = nil 
				},
				""
			),
			DiceParser.expression().run("3d6!")
		)
	end)
	it("expression should parse add(3d6!,5d12!k)",function ()
		assert.are.same(
			ParserResult.ok(
				{
					type = "poolFn",
					name = "add",
					expressions = {
						{
							type = "pool", 
							num = 3,
							die = { type = "die", side = 6, exploding = true },
							keep = nil,
							target = nil,
							success = nil 
						},
						{
							type = "pool", 
							num = 5,
							die = { type = "die", side = 12, exploding = true },
							keep = 1,
							target = nil,
							success = nil 
						}
					}
				},
				""
			),
			DiceParser.expression().run("add(3d6!,5d12!k)")
		)
	end)
end)