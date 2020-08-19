# Possible Die-Codes

---

Version 1.1.0

A Dice-Roll is made up on one or more Die-Codes. These are the possible Die-Codes identified so far. More may need to be identified.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](../Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

---

## Interpretations

The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo; in this and all &ldquo;child&rdquo; Documents are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

## Conventions

- &ldquo;==&rdquo; is shorthand for &ldquo;is equivalent to&rdquo; or &ldquo;is the same as&rdquo;.
- `M`, `N`, `X`, `Y` are *Integer* Numbers (ie [`0-9`]).
- `A` is a *Real* Numbers (ie [`1-9`]`.`[`0-9`]).
- `dX` and `dY` are *Die-Types* (ie number of sides on the Die).
- `dF` is a *Fate Die*.
	+ A Die whose results are `-1`, `0`, or `+1`.
- `a`, `c`, `d`, `ddh`, `ddl`, `f`, `h`, `h!`, `k`, `kh`, `kl`, `m`, `mt`, `o`, `p`, `r`, `rr`, `s`, `{`, `}`, `,`, `(`, `)`, `=`, `+`, `-`, `*`, `/`, `%`, `^`, `**`, `<`, `>`, `!`, `!!`, `!!!`, and `%` are *Codes*.
- The *Less Than* `<` and *Greater Than* `>` Operators are *always* read &ldquo;less than or equal to&rdquo; and &ldquo;greater than or equal to&rdquo;, respectively.
- Dies which are *Exploded* are coloured *Purple*.
- Dies which are *Crits*, *Successes*, or *Raises* are coloured *Green*.
- Dies which are *Crit-Fails* or which are not kept are coloured *Red*.
- Note that new coloured Die Icons should be created to help further differentiate the different Dies in the Results.

## Invoking Dice-Rolls

Dice-Rolls can be invoked:

- From the *Chat Window* by typing:
	- `/die NdX <Message>`
	- `/roll NdX <Message>`
	- `/tower NdX` &mdash; These are &ldquo;secret&rdquo; rolls; only the GM can see the results.
	- A space MUST (` `) separate a `<Message>` from a Die-Code. This allows the use of the Die-Codes in a `<Message>` without the need to &ldquo;escape&rdquo; the code &mdash; its already been escaped by the space (` `).
- Manually by Drag-&amp;-Dropping the Die to the *Chat Window* or the *Dice Tower* (Dice Tower rolls are &ldquo;secret&rdquo; rolls; only the GM can see the results). Use the four *Die-Mod Boxes* below the *Chat Window* to set the various Die-Codes and Modifiers.
- By Clicking a Button / Double-Clicking a Die-Field / Dragging a Die Field to the *Chat Window*. Use the four *Die-Mod Boxes* below the *Chat Window* to set the various Die-Codes and Modifiers, or create a Dice-Roll with the *Universal Dice-Roll Foundry* (UDRF) and use it on the Character/NPC Sheet (if the Ruleset allows for this).
	
## Die-Code Operators

These are the Die-Code operators. Think of them the same as mathematical operators.

**Dice-Groups:** `{}`

- Allows separate individual Dice-Rolls to be performed as a Group.
- The individual Dice-Rolls are separated by a `,`.
- Dice-Groups have their own set of Dice-Group Modifiers which perform actions across the whole Group.
- Each sub-Roll expression within a Grouped Roll must contain elements of the same type:
	+ &ldquo;Sum Rolls&rdquo;", which can be Basic Rolls or nested Group Rolls.
	+ &ldqup;Success Rolls&rdqup;, which are Rolls that return *Success* and *Raises*.
- Example: `{4d6,3d8}k` &mdash; roll `4d6` and `3d8` and keep the highest.
- Savage Worlds games use this, where important characters roll a &ldquo;wild die&rdquo; in parallel with their main die and choose the highest roll (`{[Main Die],[Wild Die]k}`).
- Dice-Group Modifiers are Die-Code Modifiers that can change the behaviour or outcome of Dice-Group Rolls. Grouped Rolls can have multiple modifiers applied to a Dice-Group Roll to allow for complex dice expressions.

**Parentheses:** `()`

**Operators:** `+`, `-`, `*`, `/`, `%`, `^`, `**`

**Functions:** `abs()`, `ceil()`, `floor()`, `round()`

**Compare Point:** `<N`, `>N`, `=N`

- `=` is the default and can be left off.
- What the Dice-Roll is being compared to (ie a Target Number), and how the comparison is to be made.
- Compare Points should appear at the end of a Dice-Roll, after other Die-Code Modifiers.
- Compare Points in the Die-Code Section below are marked with the symbol `&`.

## Precedence

Dice-Rolls are basically mathematical formula, and as such the individual Die-Codes within a Dice-Roll have a *Precedence* &mdash; the order that the various Die-Codes need to be performed in. Here is the Die-Code precedence list, in order:

1. Dice-Groups (`{}`).
	- A set of Die-Codes forming one or more sub-Dice-Rolls within a Dice-Roll.`
2. Parenthesis (`()`).
    - A way to group parts of a Die-Code so as to change the precedence &mdash; just like parenthesis in mathematical equations.
3. Functions:
	- `abs(A)` &mdash; The *absolute value* of the number entered (`abs(-0.5)` == `0.5`).
	- `ceil(A)` &mdash; The *lowest* Integer *greater than* the number entered (`ceil(0.5)` == `1`).
	- `floor(A)` &mdash; The *highest* Integer *lower than* the number entered (`floor(0.5)` == `0`).
	- `round(A)` &mdash; The Integer *closest* to the number entered (`round(0.5)` == `1`, `round(0.4)` == `0`).
4. Exponentials (&ldquo;pwers of&rdquo;) (`^`, `**`).
5. Multiples (`*`,`/`,`%`).
	- `%` == Modulus: The Integer remaining after a division (`9%4` == `1`).
6. Additions (`+`,`-`).

## Die-Code Modifiers

Die-Code Modifiers, which modify the result of a part of the Die-Code, are not to be confused with Die Modifiers (eg `+3`) whcih modify the result of a Die Roll.

Die-Code Modifiers are applied in the following order:

1. Determine if the Dice-Roll is a Pool-Dice-Roll (`p`).
2. Exploding (`!`) / Hackmaster Exploding (`h!`)
	1. These two codes are mutually exclusive within a Dice-Roll, but permisable as separate sub-Rolls or a Dice-Group.
3. Re-rolls (`rr`)
4. Drop/Keep Dice (`k`,`kh`,`kl`, `dd`,`ddh`,`ddl`)
5. Target Number (`<N`, `>N` ,`N`)
6. Raises (`r`)
7. Crit (`c`)
8. Crit-Fail (`f`)
9. Sorting (`s`,`a`)

## Die-Codes

These are the individual Die-Codes identified so far, along with some example formula and, where necessary, a brief description and/or explanation.

**Basic Dice-Roll:** `NdX`, `NdX+M`, `1dX` == `dX`

- Roll an `X`-sided Die `N` times, add all the individual die together, and report the total (first code); Roll an `X`-sided Die `N` times, add all the individual die together, add `M` to the total, and report the final total (second code).
- All Die-Code Operators can be used.

**Compute Dice:** `(N+M)d(X+Y)`, `d(X/Y)` == `d(round(X/Y))`

- Add `X` and `Y` together and roll ,  Add `N` and `M` together and roll that many `X` added to `Y` -sided dice, add the the individual die together, and report the total.
- All Die-Code Operators can be used.

**Crits(`&`):** `dXc<N`, `dXc>N`, `dXcN` == `dXc=N` `dXcX` == `dXc`
	
- Report a Crit (Critical Hit) on a roll less than or equal to `N` (first code); on a roll greater than or equal to `N` (second code); or on a roll equal to `N` (third code).
- Can have multiple `c`&rsquo;s in a Dice-Roll.

**Crit-Fail(`&`):** `dXf<N`, `dXf>N`, `dXfN` == `dXf=N` `dXf1` == `dXf`

- Report a Crit-Fail (Critical Failure) on a roll less than or equal to `N`; on a roll greater than or equal to `N`; or on a roll equal to `N`.
- Can have multiple `f`&rsquo;s in a Dice-Roll.

**Drop/Keep:** `dXkN` == `dXkhN`, `dXddN` == `dXddlN`, `dXklN`, `dXddhN`, `dXk1` == `dXk`, `dXdd1` == `dXdd`, `dXkl1` == `dXkl`, `dXddh1` == `dXddh`

- Keep the `N` (highest) dice; Drop the `N` (lowest) dice; Keep the `N` lowest dice; Drop the `N` highest dice.
- **Do Not** allow `N` < `0`.

**Exploding Dice:** `dX!`, `dX!N`, `dX<!`, `dX!X` == `dX!`

- If the die comes up `X`, explode it (roll another `dX` and add it to the total of the die that caused the explosion); If the die comes up equal to or greater than `N` explode it; If the die comes up less than or equal to.
- Exploded dice also qulify to be exploded again &mdash; thus there is no maximum total for an exploded die.
- **Do Not** allow `dX!N` where `N` < `1` &mdash; this will cause an *Infinite Loop*.
- **Do Not** allow `dX<!N` where 'N' > 'X' &mdash; this will cause an *Infinite Loop*.

**Explode Doubles:** `NdX!!`

- Explode any die that comes up the same as any other die (ie Doubles).
- `N` MUST > `2`.

**Explode Triples:** `NdX!!!`

- Explode any die that comes up the same as any two other die (ie Triples).
- `N` MUST > `3`.
- Can also explode on quads, quins, etc, by adding more `!` symbols. Note that `N` MUST be greater than or equal to the number of `!` symbols.
- A practical limit might be `!!!!!`.

**Games Workshop Roll:** `dXg`

- Used primarily by games from Games Workshop
- When `X` is a multi-digit number, and the digits are all the same (ie `X` == `MN` == `NNNN...N`), then roll `M` losts of `N`-sided die, and treat the last die as the &ldquo;Units&rdquo; of the Result, the second last die as the &ldquo;Tens&rdquo; of the Result, the third last die as the &ldquo;Thousands&rdquo; of the Result, etc.
- Example 01: `d66g` == [`11-16`,`21-26`,`31-36`,`41-46`,`51-56`,`61-66`].
- Example 01: `d10000` == `d0000g` == `d10`+`d10*10`+`d10*100`+`d10*1,000` == [`1-10,000`].

**Hackmaster Exploding Dice:** `dXh!`

- HackMaster (and some other systems) use a special style of exploding dice where the additional rolls for each dice have `1` subtracted from the roll. A die can explode multiple times but the modifier is only ever `-1` to each additional die.
- See Also *Exploding Dice*

**Matched Dice: (Doubles, Triples, Quads, etc)** `MdXm`, `MdXmN`, `MdXmt`, `MdXmtN`

- Display the die that match one or more other die.
- `m` displays the matches but does not change the result of the Die-Roll.
- `mt` returns the number of matches, regardless of the number of die that match.
- `M` MUST be > `2`.
- `N` MUST be > `2` and < 'M'.
- Example 01: `2d6m` will return the total of the roll and group the matched rolls with coloured dice (REQUIRED: More Dice Icons).
- Example 02: `2d6mt` will return the number of matches (`0` or `1`).
- Example 03: `20d6mt` will return the number of matches (`0`, `1`, `2`, `3`, `4`, `5`, or `6`).
- Example 04: `6d6mt3` will return the number of matches if there are three of any result (Triples).
- Example 05: `5d6mt3>4` will return the number of matches if there are three of them (Triples) and the matching numbers are `4` or greater.

**Null Roll:** `0d0`

**Percentage Roll:** `d%` == `d100` == `d00g`

- See also *Games Workshop Roll*

**Pool Dice:** `p`

- A Pool-Dice-Roll is when each die in the roll is treated as a separate roll (ie not added together).
- The `p` code should be the first in the Dice-Roll, but does not have to be.
- Example game systems that use Pool Dice are *Shadowrun*, *Deadlands Classic*, and *Deadlands Hell On Earth Classic*.

**Raises(`&`):** `rN`, `r1` == `r`

- Raises are how many `N`&rsquo;s over the Target Number the roll is.
- MUST be used with a `<N` or `>N` Target Number.
- A result that is above
- Example 01: A roll of `2d10>5s3` results in a `12`. This is *2 Raises*: the first Raise at `8` (one lot of `3` over the Target Number of `5`), the second Raise at `11` (the second lot of `3` over `5`).
- Example 02: A roll of `2d10<18s4` results in a `13`. This is a single *Raise* (one lot of `4` below the Target Number of `18`).
- Example 03: A roll of `2d10>5s3` results in a `7`. This is a *Success*, but not a *Raise* (the roll is greater than the target number of `5`, but less than one lot of `3` over the target number ie `8`).

**Re-roll:** `dXrr<N`, `dXrr>N`, `dXrrN` == `dXrr=N`, `dXrr1` == `dXrr`

- Re-roll any individual dice which comes up less than or equal to `N`; re-roll any individual dice which comes up greater than or equal to `N`; re-roll any individual dice which comes up equal to `N`;
- Re-rolls can also qualify to be re-rolled.
- Can have multiple `rr`&rsquo;s.

**Re-roll Once:** `dXo<N`, `dXo>N`, `dXoN` == `dXo=N`, `dXo=1` == `dXo`

- Re-roll any individual die which comes up less than or equal to `N`; re-roll any individual die which comes up greater than or equal to `N`; re-roll any individual die which comes up equal to `N`;
- Re-rolls do not qualify to be re-rolled.
- Can have multiple `rr`&rsquo;s.

**Sorting:** `dXs` == Sort Descenting, `dXa` == Sort Ascending

**Target Number(`&`):** `dX<N`, `dX>N`, `dXN` == `dX=N`

- Report if the die comes up less than or equal to `N`, Report if the die comes up greater than or equal to `N`, Report in the die comes up equal to `N`.

## Die-Group Codes

**Drop/Keep:** `{}kN` == `{}khN`, `{}ddN` == `{}ddlN`, `{}klN`, `{}ddhN`, `{}k1` == `{}k`, `{}dd1` == `{}dd`, `{}kl1` == `{}kl`, `{}ddh1` == `{}ddh`

- To apply a Keep or Drop modifier across multiple types of dice wrap the roll in a group.
- With a single Sub-Roll in the Group, the Drop/Keep Code is applied across all Rolls.
- To choose the best or worse sub-Roll multiple sub-Rolls are used. In this case, the Drop/Keep operation is applied to the final result of each sub-Roll.
- Example 01: `{4d6+3d8}k5` &mdash; Roll `4` lots of `d6` and `3` lots of `d8`, keep the highest `5` die out of the 7 die rolled, and report the sum of those `5` die.
- Example 02: `{4d12+3d8,5d20+3,5d8-1,20d4}d2` &mdash; Roll each of the four sub-Rolls and total them to get four individual totals. Drop the two lowest results, add the remaining two totals, and report the final result.

**Raises(`&`):** `rN`, `r1` == `r`

- Raises for Grouped Rolls work exactly the same as they do for non-Grouped Rolls.
- As with Grouped Roll Target Numbers, multiple Raises are reported (see Grouped Roll target Numbers, below).

**Target Number(`&`):** `{}<N`, `{}>N`, `{}N` == `{}=N`

- A Grouped Roll with multiple sub-Rolls, the success check is applied to the result of each sub-Roll expression.
- A Grouped Roll with a single sub-Roll is redundant.
- Example 01: `{4d8+3d12,5d20+3,5d10+1}>20` &mdash; Roll each of the three sub-Rolls and total them to get three individual totals. Count one success for each sub-Roll total of 20 or more.
- Example 02: `{3d8+3}>20` == `3d8+3>20`

## Some Example Dice-Rolls

### Deadlands Classic

Roll a ToHit roll: `p[Fightin' Aptitude]d[Nimbleness Trait Die's Number Of Sides]!k>5+[Opponent's Fightin' Aptitude]r5`

- Roll a number of *Pool Nimbleness Trait Die* equal to the character&rsquo;s *Fightin&rsquo; Aptitude*, explode any die that comes up the maximum, keep the highest die rolled, compare the kept die against a Target Number equal to the *Opponent&rsquo;s Fightin&rsquo; Aptitude*+5, and report the *Success* / Number of *Raises Of 5*.
- With a Nimbleness of `4d12` and a Fightin&rsquo; Aptitude of `6`, and with the opponent having a Fightin&rsquo; Aptitude of `3`, the above Dice-Roll becomes `p6d12!k>8r5`

Roll a Melee damage roll (using a club which has a damage code of `2d6`): `{p[Strength Trait]d[Strength Trait Die's Number Of Sides]!k}+2d6!`

- Roll a number of *Pool Strength Trait Die* equal to the character&rsquo;s *Strength Trait*, explode any die that comes up the maximum, keep the highest die rolled of this Die Group, then add to the kept die the result of `2` *Exploding* 6-sided die (`d6`), and report the total.
- With a Strength of `3d8` the above Dice-Roll becomes `{p3d8!k}+2d6`


### Star Frontiers Alpha Hawks

Roll a ToHit roll: `d%<({[STR],[DEX]}k)/2)`

- Roll `d%` and if the roll is less than or equal to the maximum of the charater&rsquo;s *Strength* and *Dexterity* report a *Success* &mdash; `{[STR],[DEX]}k` == Keep (ie return) the highest of the character&rsquo;s Strength and Dexterity`.

Roll a Melee damage roll: `d5+<Punch Score>`

- Roll a `d5` and add the character&rsquo;s *Punch Score*.

### Shadowrun v3

Roll a ToHit roll: `p<Martial Arts Skill>d6!>4`

- Roll a number of *Pool* 6-sided die (`d6`) equal to the character&rsquo;s *Martial Arts Skill*, explode each one on an individual result of `6` (the maximum), comparing each individual die (exploded or not) to a Target Number of `4`, and thus report the number of &ldquo;Successes&rdquo; (the number of die that roll more than or equal to `4`).
- Yes, the `!` is somewhat redundant, because if a die explodes it would have rolled over `4` anyway. Almost all *Shadowrun* die explode, no matter what the Tager Number is.
- With a Martial Arts Skill of 7 the above roll becomes `p7d6!>4`.

---

See also [Dice Roll Reference](https://roll20.zendesk.com/hc/en-us/articles/360037773133-Dice-Reference)

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
