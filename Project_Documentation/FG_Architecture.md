# The FG-Architecture

---

Version 1.0.0

For those of you new to coding for FG (or new to coding &mdash; period) we have put together this primer on how FG &ldquo;works in the background&rdquo;.

<<<<<<< HEAD
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
=======
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
>>>>>>> develop

---

## Introduction

FG consists of a number of components that fit together to provide the gaming experience that we&rsquo;ve all come to know and love. These components are: the **FG-Engine**, **FG-Launcher**, **Rulesets**, **Extensions**, and **Modules**. This article briefly discusses (at a reasonably high-level) each of these components and how they fit together to form the overall FG experience.

Programming (or &ldquo;coding&rdquo;) for FG involves making additions and/or changes to the various components mentioned above.

## Compiled Vs Interpreted Computer Programs

A quick side-note.

There are two basic types of computer languages that computer programs can be written in, known as *Compiled* and *Interpreted*.

With a *compiled* program, the *Source Code* (a text listing of commands to be compiled or interpreted into a computer program that actually runs) needs to be run through a special computer program called a *Compiler*, which, after several steps which we won&rsquo;t go into here, turns the Source Code into what is know as *Executable Code* (sometimes also known as *Machine Code*), which is what actually runs on a computer. Compiled programs are usually smaller and faster to run than interpreted programs, but have the additional step of having to run the Source Code through the Compiler first (which can take some time).

With an *interpreted* program, however, there is no Compiler &mdash; or, more accurately, the Source Code is turned into Executable Code *or the fly* &mdash; it is *interpreted*. Interpreted programs are generally quicker to write, but are slower to run and tend to be a bit larger than compiled programs.

The majority of FG is an interpreted program.

## The FG-Engine

The FG-Engine is what we call the actual program (the *fg.exe* and associated files). It is the program that interprets the code contained within the other components listed above.

We cannot modify the FG-Engine because we cannot access the FG-Engine&rsquo;s source code &mdash; the FG-Engine itself is a compiled program.

So, as we cannot access the FG-Engine&rsquo;s source code, we need to make out additions and modifications elsewhere.

## The FG-Launcher

The FG-Launcher is the first set of screens that we see when we start the FG-Engine &mdash; they are the ones that allow us to select how we are going to use FG: as the GM or as a Player; and which RPG (role-playing game) we are going to play. When we start up FG we are starting the FG-Engine and the FG-Launcher is loaded (and therefore interpreted) for us automatically.

Because the FG-Launcher is interpreted, it is possible to &ldquo;get at&rdquo; it&rsquo;s source code and therefore to make modifications to it &mdash; but there isn't much need or use in doing this, because the FG-Launcher does its job well.

## Rulesets

The FG architecture consists of the FG-Engine on top of which runs a *Ruleset*. A Ruleset contains all the mechanics and automations for playing a given RPG: the die rolling, what constitutes a hit, how the hit points work, how the saving throws work &mdash; how everything works. The 3.5E D&amp;D mechanics are different from (but similar to) the 4E D&amp;D mechanics, which are different from the 5E D&amp;D mechanics, etc, etc, etc. Thus, each of the rules mechanics for a given RPG is collected into a different Ruleset.

One way to think about this architecture is like a game console (X-Box, Play Station, etc) and game DVDs or cartridges: the FG-Engine is the &ldquo;games console&rdquo; and the Rulesets are the &ldquo;game DVDs&rdquo;.

In a way, the FG-Launcher can also be thought of as a Ruleset: it contains not the mechanics to play an RPG but the mechanics to load a selected Ruleset or connect to another person&rsquo;s copy of FG as a Player.

Now because a lot of the mechanics for a lot of different RPGs/Rulesets are the same (or very close) it makes sense to pull those common mechanics out into a separate, common &ldquo;pile&rdquo;, and then load that &ldquo;pile&rdquo; into FG when we load a given Ruleset. This idea is accomplished by using &ldquo;parent&rdquo; and &ldquo;child&rdquo; Rulesets; the common &ldquo;pile&rdquo; for just about all current Rulesets is the *CoreRPG Ruleset*, and any Ruleset which uses the common &ldquo;pile&rdquo; is a &ldquo;child&rdquo; of the CoreRPG Ruleset.

So, the (D&amp;D) 3.5E Ruleset, the 4E Ruleset, and the 5E Ruleset (and others) are all &ldquo;children&rdquo; of the CoreRPG Ruleset, and the CoreRPG Ruleset is the &ldquo;parent&rdquo; of these various Rulesets. When we load/select a child Ruleset in the FG Launcher the parent Ruleset is loaded automatically first, and then any changes to the parent Ruleset specified in the child Ruleset are applied.

It is possible to continue down this chain indefinitely, with child Rulesets having children of their own, and so on. An example of this is the Pathfinder Ruleset: it&rsquo;s very, very close to the 3.5E Ruleset in mechanics, etc, so the Pathfinder Ruleset has been made a &ldquo;child&rdquo; of the 3.5E Ruleset and is loaded on top of the 3.5E Ruleset (which in turn is loaded on top the CoreRPG Ruleset). So we could say that the Pathfinder Ruleset is a &ldquo;grandchild&rdquo; of the CoreRPG Ruleset.

It&rsquo;s important to note at this stage that only one Ruleset is in action at any time (the last one in the &ldquo;Ruleset Stack&rdquo;), even though parent Rulesets are loaded first &mdash; each child-Ruleset adds to and/or modifies its immediate parent-Ruleset.

It is also important to note that the FG-Launcher is NOT a parent Ruleset of any other Ruleset: the very last act that the FG-Launcher performs once we click on the FG-Launcher&rsquo;s Start Button is to unload itself from the FG-Engine, so it is not available to the Ruleset or its parent-Ruleset(s) that we have choose to load.

For our Project, the Rulesets that we are working on is the *DORCoreMinimal Ruleset* (DORCorMin &mdash;a cut-down version of the *DORCore* Ruleset) which is a child-Ruleset of the *CoreRPG* Ruleset; and the *DORDeadlandsClassic* (DORDLC) and *DORDeadlandsHellOnEarthClassic* (DORDLHOEC) Rulesets, which are child-Rulesets of the *DORCore/DORCoreMinimal* Ruleset.

So, to make additions and/or modifications for the Project, we will need copies of the source code of these Rulesets (but only for those Rulesets we are actually making additions/modifications on). These are all available in the Project Repository, except for the *CoreRPG* Ruleset, which can be found in the *FG-Data* Folder under the `rulesets` Folder/Directory by clicking on the `Open data folder` Button towards the top-right of the FG-Launcher. The *CoreRPG* Ruleset is a `PAK` file, which is a simple `ZIP` file &mdash; i.e. copy it to a new folder/directory and &ldquo;un-zip&rdquo; it to access its source code.

**Note:** At the moment the Project is focused on FG-Classic (FGC) and thus the FGC *CoreRPG* Ruleset. We&rsquo;ll be including FG-Unity (FGU) at a future stage of the Project.

## Extensions

So how do Extensions fit in?

Well, an Extension is a modification to a Ruleset. It might be a change of resource (language or graphics), it might add some extra functionality (some &ldquo;house rules&rdquo;) to a Ruleset, or it could be just about anything else. The Project&rsquo;s *DOE: Cosmic Twins* (DOECTW) Extension, for example, adds the &ldquo;Cosmic Twins&rdquo; &ldquo;Bounty Point Sharing&rdquo; House Rule functionality to the DORDLC and DORDLHOEC Rulesets.

Extensions are loaded after the &ldquo;Ruleset Stack&rdquo; is loaded (after the Ruleset and the parent-Ruleset(s)), and more than one Extension may be loaded at once. The order that Extensions are loaded in is arbitrary: it is possible for an Extension Developer to specify when their Extension is loaded relative to any other Extensions (try to be first, try to be last, etc) but there is no guarantee, and most Extension Developers don&rsquo;t bother to specify anyway (although it is considered best practice to do so). It is also possible for an Extension Developer to specify if their Extension should or should not be loaded with others, but again most Extension Developers don&rsquo;t bother to specify (and again, it is considered best practice to do so if required).

Because each Extension modifies the existing computer code or resources, etc, of the loaded Ruleset, if two Extensions try to modify the same thing then only the last Extension in the &ldquo;Extension Stack&rdquo; that effects the thing being modified applies. This is why some Extensions won&rsquo;t work with others and why sometimes two Extensions will &ldquo;break&rdquo; each other &mdash; they&rsquo;re both trying to modify the same thing in the loaded Ruleset. A prime example is trying to load two Theme Extensions at the same time (a no-no): each Theme Extension changes the graphics used by a Ruleset, and as each Theme Extension is trying to replace the same graphics they &ldquo;fight&rdquo; one another and cause problems. The only way to fix problems caused by conflicting Extensions is for the two Extension Developers to work together to come up with a solution; sometimes a solution is not possible, but often one can be found.

So should a Developer use a child-Ruleset or an Extension for their changes?

Well, it depends upon the extent and the scope of the modifications. If the modifications are designed to be used by more than one RPG (such as the DOECTW Extension) then an Extension is the way to go. If the change is relatively minor and doesn&rsquo;t really involve changing the mechanics (eg changing the graphics or other resources used by the Ruleset) then again, an Extension is probably best. If the modification is significant and might really be considered a new RPG, then a child-Ruleset is probably best. But in the end it's really a matter of taste for the Developer.

## Modules

So, finally, how do Modules fit it to the FG-Architecture?

Well, Modules hold information relevant to the RPG setting. Typical Modules might be a Monster Manual, a Spell Grimoire, the plans for a space station, or the details of an Adventure. This information isn&rsquo;t the mechanics of a RPG, but often uses the mechanics. Modules are loaded and unloaded as required by the GM and/or the Players during the FG-session, just like you&rsquo;d open and close an RPG&rsquo;s physical reference books as you look up various information.

So now you should have a good idea of how the various components of FG fit together, which should help you in understanding how and why FG works the way it does.

## Further Information

<<<<<<< HEAD
- [FG-Coding](FG_Coding.md)
=======
- [FG-Coding](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FG_Coding.md)
>>>>>>> develop

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
