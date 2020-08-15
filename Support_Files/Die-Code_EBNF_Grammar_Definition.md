# EBNF Grammar Definition Of A Die-Code

---

Version 0.1

This is the EBNF Grammer [ISO:14977](https://www.iso.org/standard/26153.html) Definition of a Die-Code.

<<<<<<< HEAD
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](../Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
=======
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
>>>>>>> develop

## EBNF Definition (ISO:14977) Of The Grammar Of A Dice Roll

DieCode = [PoolCode],DieRolls,{GlobalDieModifiers},[SortCode];

DieRolls = DieRoll,{LocalDieModifiers},

GroupRoll = "{",Roll,{",",Roll},"}"|Roll,{GroupRollMods};

Roll = DFunc,{RollMods},{GroupRollMods};

RFunc = (FuncName,"(",RExpression,&rdquo;)&rdquo;)|RExpression;

RExpression = RTerm,{AddOp,RTerm};

RTerm = RFactor,{MultOp,RFactor};

RFactor = RExponent,(ExpOp,RExponent);

RExponent = "(",RExpression,&rdquo;)"|DFunc;

DFunc = (FuncName,"(",Expression,&rdquo;)&rdquo;)|Expression;

Expression = Term,{AddOp,Term};

Term = Factor,{MultOp,Factor};

Factor = Exponent,(ExpOp,Exponent);

Exponent = "(",Expression,&rdquo;)"|NFunc|Die;

Die = ["-"],[NFunc],DCode,NFunc|SpecialDie|d66Roll;

d66Roll = NFunc,d66Code;

RollMods = [Exploding],[Reroll]

GroupRollMods = [Crit],[Success],[KeepDrop]

Crit = CritCode,ComparePoint,{CritCode,ComparePoint};

Exploding = "!",[PenetrationCode],[ComparePoint]|"!!",{"!"};

KeepDrop = KeepCode,[HighLowCode],[NFunc];

Reroll = RerollCode|RerollOnceCode,[ComparePoint],{RerollCode|RerollOnceCode,[ComparePoint]};

Success = [FailCode],ComparePoint,[Raises];

Raises = RaiseCode,[NFunc];

ComparePoint = [CompareOP],NFunc;

NFunc = (FuncName,"(",NExpression,&rdquo;)&rdquo;)|NExpression;

NExpression = NTerm,{AddOp,NTerm};

NTerm = NFactor,{MultOp,NFactor};

NFactor = NExponent,(ExpOp,NExponent);

NExponent = "(",NExpression,&rdquo;)"|Number;

Number = ["-"],Digit,{Digit};

Digit = "0"|NDigit;

AddOp = "+"|"-";

CompareOp = "<"|"="|">";

CritCode = "c"|"cs"|"cf"|"C"|"CS"|"CF";

DCode = "d"|"D";

ExpOp = "**"|"^";

FailCode = "f"|"F";

FuncName = "floor"|"FLOOR"|"ceil"|"CEIL"|"round"|"ROUND"|"abs"|"ABS";

GroupSeperator = ",";

HighLowCode = "h"|"H"|"l"|"L";

KeepCode = "d"|"D"|"k"|"K";

MultOp = "*"|"/"|"%";

NDigit = "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9";

PenetrationCode = "p"|"P";

PoolCode = "p"|"P";

RaiseCode = "s"|"S";

RerollCode = "r"|"R";

RerollOnceCode = "ro"|"RO";

SortCode = "sa"|"SA"|"sd"|"SD";

SpecialDie = "f"|"F"|"%";

Space = " ";

d66Code = "g"|"G";

**Notes:**

- OtherChar "!" = Exploding Dice
- SpecialDie "f"|"F" = Fudge Die
- SpecialDie "g"|"G" = Games Workshop d66
- SpecialDie "%" = "100"
- MultOp "x"|"X" = "*"
- PoolCode = Roll Pool Dice
- Keep "k"|"K"|"+k"|"+K" = Keep Highest Die ie "+k1"
- Keep ("k"|"K"|"+k"|"+K&rdquo;),Number = Keep Highest Number Dice ie "+kN"
- Keep "-k"|"-K" = Keep Lowest Die ie "-k1"
- Keep ("-k"|"-K&rdquo;),Number = Keep Lowest Number Dice ie "-kN"
- Keep "h"|"H"|"+h"|"+H" = Keep Highest Die ie "+k1"
- Keep ("h"|"H"|"+h"|"+H&rdquo;),Number = Keep Highest Number Dice ie "+kN"
- Keep "-h"|"-H" = Discard Highest Die ie "-k(M-1)" where "M" is as "MdB"
- Keep ("-h"|"-H&rdquo;),Number = Discard Highest Number Dice ie "-k(M-N)" where "M" is as "MdB"
- Keep "l"|"L"|"+l"|"+L" = Keep Lowest Die ie "-k1"
- Keep ("l"|"L"|"+l"|"+L&rdquo;),Number = Keep Lowest Number Dice ie "-kN"
- Keep "-l"|"-L" = Discard Lowest Die ie "+k(M-1)" where "M" is as "MdB"
- Keep ("-l"|"-L&rdquo;),Number = Discard Lowest Number Dice ie "+k(M-N)" where "M" is as "MdB"
- Remainder "r"|"R"|"=r"|"=R" = Round Off
- Remainder "+r"|"+R" = Round Up
- Remainder "-r"|"-R" = Round Down
- TN ("t"|"T"|"+t"|"+T&rdquo;),Number = Roll Equal To Or Above Target Number
- TN ("-t"|"-T&rdquo;),Number = Roll Equal To Or Under Target Number
- TN ("t"|"T"|"+t"|"+T&rdquo;),Number,SuccessCode,["0"] = Report Degree of Success When Rolling Equal To Or Above Target Number ie Difference Between Roll & TN; RollResult-N
- TN ("-t"|"-T",Number,SuccessCode,["0"] = Report Degree of Success When Rolling Equal To Or Under Target Number ie Difference Between Roll & TN; N-RollResult
- TN ("t"|"T"|"+t"|"+T&rdquo;),Number,SuccessCode,Number = Report Number of Successes and "Raises" When Rolling Equal To Or Above Target Number
- TN ("-t"|"-T",Number,SuccessCode,Number = Report Number of Successes and "Raises" ("Lowers?&rdquo;) When Rolling Equal To Or Under Target Number
- fpDieCodeParse() returns the following sTypes:
	+ n = Number
	+ d = Dice
	+ a = Add/Minus
	+ m = Multiply/Divide

---
![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
