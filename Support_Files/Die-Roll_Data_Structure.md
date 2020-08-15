# Die-Roll Data Structure

---

Version 1.0.0

This is the data structure that hold a die-roll.


If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## ROLL

~~~
.sType - "roll"
.sDesc - Description
.aDice - {dN,dM,...}
.nMod - Modifier
.aRollCode - {}
.nK - Keep Dice: 0 = All Dice, <0 = Lowest Dice, >0 = Highest Dice, Default = 0
.nP - Pool Dice: 0 = Off, 1 = On, Default 0
.nR - Remaining: 0 = Round Off, <0 = Round Down, >0 = Round Up, Default 0
.nS - Successes: 0 = Off, 1= On, Default 0
.nSN - Success (only valid if nS=1): 0 = Degree of Success, N = Raises, Default 0
.nTN - Target Number: Default 0
.nT - Target (Number): 0 = Off, 1 = Above TN, -1 = Below TN, Default 0
.nX1 - Exploding Code 1: 0 = Off, >0 = Number to Explode On|First Number in Range to Explode On, -1 = Explode on Max Total, <-1 = Explode On Doubles|Triples|etc, Default 0
.nX2 - Exploding Code 2: 0 = Off, >0 = Last Number in Range to Explode On, Default .nX1
.nZ - Non-Standard Die Type: 0=Off, 1=On, 2=dG, set by DieManager.
(Any other fields added as string -> string map, if possible)
~~~

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
