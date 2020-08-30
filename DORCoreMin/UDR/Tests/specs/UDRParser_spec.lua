describe("lsParser", function()
	require("testlib.require")
	requireFGModule("Parser","lsUDRParser")

	describe("litChar", function()
		it("should parse a literal", function ()
			local res = Parser.litChar("b").parse("booyah")
			assert.are.same(Parser.Result.ok("b","ooyah"), res)
		end)
		it("should error on the wrong literal", function ()
			local res = Parser.litChar("o").parse("booyah")
			assert.are.same(Parser.Result.err("Got char 'b'. Expected 'o'."), res)
		end)
	end)

	describe("lit", function()
		it("should parse a literal", function ()
			local res = Parser.lit("boo").parse("booyah")
			assert.are.same(Parser.Result.ok("boo","yah"), res)
		end)
		it("should error on the wrong literal", function ()
			local res = Parser.lit("ooy").parse("booyah")
			assert.are.same(Parser.Result.err("Got 'booyah'. Expected 'ooy'."), res)
		end)
	end)

	describe("digit", function()
		it("should parse a digit", function ()
			local res = Parser.digit().parse("133t")
			assert.are.same(Parser.Result.ok(1,"33t"), res)
		end)
		it("should error on the wrong literal", function ()
			local res = Parser.digit().parse("booyah")
			assert.are.same(Parser.Result.err("Got char 'b'. Expected one of {0,1,2,3,4,5,6,7,8,9}."), res)
		end)
	end)

	describe("oneOrMany(digit)", function()
		it("should parse digits but not die trailing non digits", function ()
			local res = Parser.oneOrMany(Parser.digit()).parse("133t")
			assert.are.same(Parser.Result.ok({1,3,3},"t"), res)
		end)
		it("should error on a nondigit first char", function ()
			local res = Parser.oneOrMany(Parser.digit()).parse("booyah")
			assert.are.same(Parser.Result.err("Got char 'b'. Expected one of {0,1,2,3,4,5,6,7,8,9}."), res)
		end)
	end)

	describe("chainOperandsl", function ()
		it("should chain operands left associatively",function ()
			assert.are.same(
				Parser.Result.ok({"+",{"+",1,2},3},"rest"),
				Parser.chainOperandsl(
					Parser.number(),
					Parser.map(
						Parser.litChar("+"), 
						function (_)
							return function (t1,t2) 
								return { "+", t1, t2 } 
							end 
						end
					)
				).parse("1+2+3rest")
			)
		end)
	end)

	describe("number", function()
		it("should parse digits but not die trailing non digits", function ()
			local res = Parser.number().parse("123d12")
			assert.are.same(Parser.Result.ok(123,"d12"), res)
		end)
	end)

	describe("chaining functions", function()
		it("andThen should work", function ()
			local testParser = Parser.andThen(Parser.digit(), function (d) 
				if (d == 1) then
					return Parser.litChar('a')
				else
					return Parser.litChar('b')
				end
			end)
			assert.are.same(Parser.Result.ok("a",""),testParser.parse("1a"))
			assert.are.same(Parser.Result.err("Got char 'b'. Expected 'a'."),testParser.parse("1b"))
			assert.are.same(Parser.Result.ok("b",""),testParser.parse("2b"))
			assert.are.same(Parser.Result.err("Got char 'a'. Expected 'b'."),testParser.parse("5a"))
		end)
		it("lift3 should parse a dice set", function ()
			local res = Parser.lift3(
				Parser.number(),
				Parser.litChar("d"),
				Parser.number(),
				function (num, _, sides)
					return { num = num, sides = sides }
				end
			).parse("5d12")
			assert.are.same(Parser.Result.ok({ num = 5, sides = 12 },""), res)
		end)
		it("lift{1-5} should do their thing", function ()
			assert.are.same(
				Parser.Result.ok({"a","b"}, ""),
				Parser.lift2(
					Parser.litChar("a"),
					Parser.litChar("b"),
					(function (a,b) return {a,b} end)
				).parse("ab")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c"}, ""),
				Parser.lift3(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					(function (a,b,c) return {a,b,c} end)
				).parse("abc")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d"}, ""),
				Parser.lift4(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					(function (a,b,c,d) return {a,b,c,d} end)
				).parse("abcd")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d","e"}, ""),
				Parser.lift5(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					Parser.litChar("e"),
					(function (a,b,c,d,e) return {a,b,c,d,e} end)
				).parse("abcde")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d","e","f"}, ""),
				Parser.lift6(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					Parser.litChar("e"),
					Parser.litChar("f"),
					(function (a,b,c,d,e,f) return {a,b,c,d,e,f} end)
				).parse("abcdef")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d","e","f","g"}, ""),
				Parser.lift7(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					Parser.litChar("e"),
					Parser.litChar("f"),
					Parser.litChar("g"),
					(function (a,b,c,d,e,f,g) return {a,b,c,d,e,f,g} end)
				).parse("abcdefg")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d","e","f","g","h"}, ""),
				Parser.lift8(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					Parser.litChar("e"),
					Parser.litChar("f"),
					Parser.litChar("g"),
					Parser.litChar("h"),
					(function (a,b,c,d,e,f,g,h) return {a,b,c,d,e,f,g,h} end)
				).parse("abcdefgh")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d","e","f","g","h","i"}, ""),
				Parser.lift9(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					Parser.litChar("e"),
					Parser.litChar("f"),
					Parser.litChar("g"),
					Parser.litChar("h"),
					Parser.litChar("i"),
					(function (a,b,c,d,e,f,g,h,i) return {a,b,c,d,e,f,g,h,i} end)
				).parse("abcdefghi")
			)
			assert.are.same(
				Parser.Result.ok({"a","b","c","d","e","f","g","h","i","j"}, ""),
				Parser.lift10(
					Parser.litChar("a"),
					Parser.litChar("b"),
					Parser.litChar("c"),
					Parser.litChar("d"),
					Parser.litChar("e"),
					Parser.litChar("f"),
					Parser.litChar("g"),
					Parser.litChar("h"),
					Parser.litChar("i"),
					Parser.litChar("j"),
					(function (a,b,c,d,e,f,g,h,i,j) return {a,b,c,d,e,f,g,h,i,j} end)
				).parse("abcdefghij")
			)
		end)
	end)

	describe("optional", function ()
		it("parses input if it matches", function ()
			local p = Parser.optional(Parser.litChar("!"))
			assert.are.same(
				Parser.Result.ok("!","woo"),
				p.parse("!woo")
			)
		end)
		it("leaves input if it doesn't match", function ()
			local p = Parser.optional(Parser.litChar("!"))
			assert.are.same(
				Parser.Result.ok(nil,"woo"),
				p.parse("woo")
			)
		end)
	end)

	describe("oneOf", function ()
		it("should pick the first option", function ()
			assert.are.same(
				Parser.Result.ok("a",""),
				Parser.oneOf({
					{desc = "a", parser = Parser.litChar("a") },
					{desc = "num", parser = Parser.number() }
				}).parse("a")
			)
		end)
		it("should pick the second option", function ()
			assert.are.same(
				Parser.Result.ok(21,""),
				Parser.oneOf({
					{desc = "a", parser = Parser.litChar("a") },
					{desc = "num", parser = Parser.number() }
				}).parse("21")
			)
		end)
		it("fail gracefully", function ()
			assert.are.same(
				Parser.Result.err("Could not parse zzzzz. Expecting on of {An A:Got char 'z'. Expected 'a'.,A Number:Got char 'z'. Expected one of {0,1,2,3,4,5,6,7,8,9}.}."),
				Parser.oneOf({
					{desc = "An A", parser = Parser.litChar("a") },
					{desc = "A Number", parser = Parser.number() }
				}).parse("zzzzz")
			)
		end)
		it("should work with sep", function ()
			assert.are.same(
				Parser.Result.ok({1,2,3},""),
				Parser.oneOrMany(Parser.number(),Parser.litChar(",")).parse("1,2,3")
			)
		end)
	end)

	describe("lazy", function ()
		it("should look like a normal parser", function ()
			assert.are.same(
				Parser.Result.ok(123,""),
				Parser.lazy(function () return Parser.number() end).parse("123")
			)
		end)	
	end)

end)