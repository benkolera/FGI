# Project Roadmap

---

Version 1.1.0

These are the Task that Project has completed and still needs to do. This information MUST be duplicated on the GK Boards (either as one Task per Card or as a Task List on a series of Cards). Who is working on each Task should be recorded on each GK Board/Card.

When a Task is completed the text `- Completed` is placed at the end of the Task. When the entire Task is finished it is moved from the *Still To Do* Section to the *Completed Milestones* Section.

**Note:** Some of these Task may occur in parallel.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.


## Completed Milestones

None so far.

## Still To Do

 A GK Board needs to exist for each of these (combined or separate).

1. Finalise Project Documentation:
	1. Get confirmation from Project&rsquo;s Contributors that they agree with the Project Documentation.
	2. Fix/Complete any Documentation (ongoing, as required).
2. Develop the Universal Die-Roller (UDR) for the DORCoreMinimal (DORCM) Ruleset:
	1. Confirm that every possible Die-Roll has been captured (and documented ([Possible Die-Codes](../Support_Files/Possible_Die-Codes.md))).
	2. Finalise the various Die-Codes (and document).
	3. Confirm the Die-Roll Data Structure(s) (and document).
	4. Develop/Extend the UDR-Parser Routine(s).
	5. Develop the various subroutines to handle the various different types of Die-Rolls:
		1. Modifying Dice.
		2. Sorting Dice.
		3. Exploding Dice.
		4. Exploding-Compounding Dice.
		5. Penetrating Dice.
		6. Re-Rolling Dice.
		7. Re-Rolling Once.
		8. Keep/Drop Dice.
		9. Target Numbers.
		10. Number of Successes/Failures.
		11. Critical Successes/Failures.
		12. Math Functions.
		13. Group Rolls.
		14. Modifying Group Rolls.
		15. Group Roll Target Numbers.
		16. Group Roll Successes/Failures.
		17. Others not yet captured.
	6. Develop new Die Icons.
	7. Confirm the UDR is working via:
		1. Manually via the Virtual Dice and the Die-Boxes.
		2. Die-Codes in the ChatBox.
		3. Manually via the Dice Tower, Virtual Dice, and the Die-Boxes.
3. Develop the Universal Die-Roller Foundry (UDRF):
	1. Create/Extend the Graphic Interface (GUI).
	2. Develop the routine(s) to integrate the GUI with UDR (probably via Die-Codes).
	3. Develop the GUI to integrate the UDRF into other Graphical elements (ie the Character Sheet).
	4. Confirm the UDRF is:
		1. Creating the correct Die-Codes
		2. Populating the UDR Data Structure Correctly.
		3. Rolling the correct Dice.
		4. Manipulating the results from the Die-Roll to give the correct final results.
4. Develop the *Cosmic-Twins* Extension for the Deadlands Classic (DORDLC) and Deadlands Hell On Earth (DORDLHEOC) Rulesets:
	1. Develop the Graphic Interfaces to:
		1. Select and link each Character.
		2. Display the relevant data on each Character Sheet.
	2. Develop the Routines to:
		1. Read and write to the *GlobalRegistry.lua* File.
		2. Perform the required calculation on the Character Sheet *and* in the Global Registry.
		3. Link the resulting data to the GUI elements.
5. Fix the DORDLC *Missing Chips* Bug.
6. Fix the DORDLC *Attribute &lt;6* Bug.
7. Develop the DORDLC *Chip Audit* Feature:
 	1. Develop the Graphic Interfaces to:
		1. Run (a Button) and display the result of the audit.
		2. Run (a Button) to correct the Chip Count.
		3. Run automatically (a Checkbox) the routine to correct the Chip Count.
		4. Will also require:
			1. A PC Count Indicator (NumBox).
			2. A Options Rule Indicator (Checkbox).
			3. Theoretical Total Chip Counts (Numboxes).
			4. Actual Total Chip Counts (Numboxes).
			4. Difference Total Chip Counts (Numboxes).
	2. Develop the routines to:
		1. Gather the &ldquo;beginning&rdquo; data and link to the relevant GUI Elements.
		2. Perform the audit and link the result to the relevant GUI Elements.
		3. Correct the Chip Count if indicated.
8. Develop the DORDLC *Roll Initiative From Character Sheet* Feature.
9. Develop the DORDLC *Items* Functionality (with Sound).
10. Develop the DORDLC *Weapons On Character Sheet* Functionality.
11. Develop the DORDHOE Ruleset (from the DORDLC Ruleset).
	1. Develop the Character Sheet.
	2. Develop the Combat Tracker.
	3. Develop the Items.
12. Develop the *Shadowrun v3 (DORSR3)* Ruleset (from the DORCore (DORC) Ruleset).
	1. Develop the Character Sheet.
	2. Develop the Combat Tracker.
	3. Develop the Items.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
