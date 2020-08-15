# FG-Coding

---

Version 1.0.0

This document discusses the detailsof the various entities that go in to making an FG Ruleset or Extension.

<<<<<<< HEAD
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Interpretations

&lsquo;\<Feature>&rsquo; is used in File Names and in Folder/Directory Names and is a &ldquo;placeholder&rdquo; for, and should be replaced by (as per the Project&rsquo;s [Naming Standards](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/Naming_Standards.md)), the name of the *Feature* that the File and/or Folder/Directory relates too.
=======
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Interpretations

&lsquo;\<Feature>&rsquo; is used in File Names and in Folder/Directory Names and is a &ldquo;placeholder&rdquo; for, and should be replaced by (as per the Project&rsquo;s [Naming Standards](Naming_Standards.md)), the name of the *Feature* that the File and/or Folder/Directory relates too.
>>>>>>> r0.2

## Examples

If in doubt about anything to do with XML Files and their contents, etc, please see the existing XML Files in the `/DORCoreMin/CORE/XMLFiles`, `/DORCoreMin/DORBASE/XMLFiles`, or `/DORCoreMin/UDR/XMLFiles` Folders/Directories for examples.

## Introduction

The &ldquo;guts&rdquo; of FG consists of three major parts:

- XML (computer) code, which defined the &ldquo;look and feel &rdquo; of FG &mdash; the **Where** of FG: where a character sheet (Form) appears on the screen, how big a button might be, etc.
- Lua code (Lua Scripts), which provides for how the various controls (Buttons, Die Fields, etc) &ldquo;do their thing&rdquo; &mdash; the **How** of FG: how to apply a die-roll to an NPC&rsquo;s damage, etc.
- Resources, which are grahical images, sound files, text strings to be displayed, etc &mdash; the **What** of FG: what graphic to display on a Button, what text to display on a Checkbox, etc.

A good understanding of these three parts and how they fit together makes FG coding relatively simple and easy.

This document primarily focuses on the XML Coding part of FG, but does cover the Lua Coding and Resources parts as well. This [Lua Tutorial](http://lua-users.org/wiki/LuaTutorial) covers Lua Coding in much, much more detail.

## A Quick Note On `PAK` &amp; `EXT` Files

FG Rulesets and Extensions are normally &ldquo;zipped up&rdquo; into `PAK` Files or `EXT` Files, respectively, for easy of use, etc. However, the FG-Engine will work perfectly fine dealing with individual XML, Lua, and Resource Files. This means that, for development and testing purposes, we do not have to zip our files into `PAK` or `EXT` files just to do a quick test. When the Project performs a Release is when all the relevant files will be zipped into a `PAK` and/or `EXT` File(s).

Note that the FG-Engine will use a set of individual XML or Lua Files (in a Folder/Directory) *before* it will use a `PAK` or `EXT` File (of the same name as the Folder/Directory).

## A Quick Note On Scope

The &ldquo;Scope&rdquo; of something is what or which areas that something applies to. In terms of our Project, when discussing Code-Files (the XML and Lua Files that contain our computer code) and XML Entites, we talk about &ldquo;Local&rdquo; Scope and &ldquo;Global&rdquo; Scope.

As a general &ldquo;Rule Of Thumb&rdquo; Objects having *Global Scope* are available everywhere &mdash; throughout the entire Ruleset, while Objects having *Local Scope* are only available within the XML Entity or Lua File where they are defined.

## The FG Load Process

Being an interpretive program when FG first loads it Ruleset(s) and Extensions (if any) the following process takes place:

1. The `fg.exe` File, containing the FG-Engine, starts up and loads the FG-Launcher XML/Lua Code.
2. We then select which Ruleset and any Extensions that we would like to use, and then click on the FG-Launcher&rsquo;s *Start* Button.
3. The `base.xml` File of the Ruleset selected in (2) is loaded into the FG-Engine&rsquo;s memory (part of the computer&rsquo;s memory), or the Ruleset&rsquo;s `PAK` File is loaded and then the `base.xml` File is accessed, and then the `base.xml` File is examined line by line, from top to bottom, and each XML Element (each self-contained set of XML Code) is interpreted and acted upon. In particular, the FG-Engine is looking for an `<importruleset source="<sParentRuleset>" />` Tag, which will be one of the first tags in the ` base.xml` File and one of the first &ldquo;commands&rdquo; acted upon.
	1. If such a tag is found (and, typically, it will be, because just about all Rulesets are child-Rulesets of the *CoreRPG* Ruleset or of one of the *CoreRPG* Ruleset&rsquo;s child-Rulsets) the FG-Engine loads the parent-Ruleset specified (while keeping the existing Ruleset in memory) and then restarts the load-process from (3). This &ldquo;loading-loop&rdquo; continues until there is no `<importruleset>` Tag found.
	2. If an `<importruleset>` Tag is not found (when the entire Ruleset-chain has reached the ultimate parent-Ruleset, typically the *CoreRPG* Rulset), the FG-Engine continues on from (4).
4. Once the `<importruleset>` Tag (if any) is dealt with, the FG-Engine than continues acting upon the remaining XML Entities in the `base.xml` File of the last (parent) Ruleset loaded. While it is possible to have an entire Ruleset exist solely within the Ruleset&rsquo;s `base.xml` File, best practice it to break the Ruleset into logical parts and therefore separate XML and Lua Files. Thus, most `base.xml` files consist of little more the `<includefile source="<xXMLFile.xml>" />` Tags and `<script name="<sFGInternalName>" file="lsLuaFile.lua" />` Tags, plus various other Tags dealing with the Ruleset as a whole (i.e the Ruleset&rsquo;s version number, the Ruleset&rsquo;s name, the Ruleset&rsquo;s Author, etc).
5. Each `<includefile>` or `<script>` Tag tells the FG-Engine to load/access that particular XML or Lua File. When the FG-Engine loads/accesses such a file each of its XML Entities or Lua functions are loaded and interpreted, from top to bottom, and any &ldquo;commands&rdquo; are performed, including any `onInit()` functions found in any Globally-scoped Lua Files loaded. Because these files and their &ldquo;commands&rdquo; are loaded and acted upon *in order*, if an XML Element requires something from another XML Element (more on this below), or if the `onInit()` function requires any XML Element, if the required XML Element hasn&rsquo;t been loaded yet, then the load-process will produce an error and probably crash, or at least FG won&rsquo;t work properly. Thus, it is important the order in which we place our `<includefile>` and `<script>` Tags, plus the order of other Tags in included XML files &mdash; *Resource* XML Files should be loaded first, followed by &ldquo;working&rdquo; *XML* Files, followed by Globally-scoped *Lua Script* Files. To help with this, the Project uses an `x<Feature>Files.xml` File for each *Feature*, which acts like the Ruleset&rsquo;s `base.xml` File and contains `<include>` and `<script>` tags for all of the *Resource* and other *XML* Files and Globally-scoped *LUA Script* Files &mdash; in the correct load order &mdash; so as to avoid any errors.
6. Once all of the XML Entities and `onInit()` functions are loaded and dealt with, if this Ruleset is a parent-Ruleset then the entire load-process (from (4)) is repeated for the child-Ruleset. This process continues to loop from (4) to (6) until the original Ruleset we requested to load has finally finished loading.
7. During (4)-(6) the various in-memory XML Entities and Lua Scripts will be &ldquo;updated&rdquo; and &ldquo;modified&rdquo; to reflect any changes required by a child-Rulset on a parent-Ruleset, so that by the time the FG-Engine has finished loading the Ruleset-stack of parent- and child-Rulesets what remains in the FG-Engine&rsquo;s memory is the combined result of all of the parent- and child-Rulesets, in order of priority of child- to parent-Ruleset (i.e. the child-Rulset&rsquo;s XML Entities and Lua Scripts take precedence over the parent-Ruleset&rsquo;s XML Entities and Lua Scripts).
8. The FG-Engine now takes any Extensions which were specified to be loaded and repeats the load-process for (4)-(6) for each one, again &ldquo;updating&rdquo; and &ldquo;modifying&rdquo; any XML Entities and Lua Scripts from (7). Remember that the load order of Extensions is NOT specified (i.e. can occur in *any order*) so we must be careful to note which XML Entities and Lua Scripts each Extension &ldquo;touches&rdquo; to ensure that we don&rsquo;t introduce any conflicts and/or errors.
9. Once all of the Extensions have been loaded and acted upon, FG is then ready to use.  

Note that all of the above occurs on the GM&rsquo;s copy of FG. When each Player connects to the GM&rsquo;s copy of FG, the resulting in-memory XML Entities, Lua Scripts, and &ldquo;Shared&rdquo; Resource Files are downloaded to the Players&rsquo; copy of their running FG-Engine.

Also note, that because of the above, most &ldquo;actions&rdquo; that occur within FG actually take place on the GM&rsquo;s copy of the running FG-Engine: it is typically only the &ldquo;results&rdquo; of those actions that are sent to the Players&rsquo; copies of the running FG-Engine&mdash; although *some* actions do take place on a Player&rsquo;s copy of their FG-Engine &mdash; this, by the way, is known as &ldquo;Distributed Computing&rdquo;.

## Objects &amp; Object-Orientated Programming (OOP)

(A short digression.)

Object-Oriented Programming (OOP) is a method of computer programming where everything is defined as an *Object*.

An Object can be anything. In the real world a car is an Object, as is a house, a person, a tree &mdash; anything. To help us understand this concept, we&rsquo;ll use a car as an example, and call this Object *oCar* (&ldquo;o&rdquo; for &ldquo;Object&rdquo;).

### Why Use OOP?

#### For The Programmer

The primary benefit of OOP to the programmer (among many) is &ldquo;reusability&rdquo;. Each Object is self-contained and self-running. If designed properly, Objects can be reused over and over in program after program (or, in the case of our Project, Ruleset after Ruleset) without adjustment. No required variable declarations, calling routines, linking issues. Theoretically, we should eventually be able to write entire programs (Rulesets) with little or no (extra) code. Just combine Objects, set a few Properties and we&rsquo;re off and running.

#### For The User

In general, programs developed with OOP empower users. No longer linked to required program flow, these independent Objects encourage us to create programs that hand control to the end-user. Each user can customise our program to serve their work or, in our case, gaming environment by selecting Objects in the order appropriate to their task and habits &mdash; not according to a rigid scheme enforced by a menu hierarchy.

We can now see, from the above, that FG is an OOP program (as is MS-Windows, for that matter) &mdash; the Players can click on or drag-and-drop an Object within FG and FG with then react to that Object, performing whatever action is required.

### OOP Concepts

An Object has *Properties* and *Methods*. Properties are &ldquo;facts&rdquo; about the Object, while Methods are what the Object can do, and in computer coding what something can do is usually coded as a &ldquo;Function&rdquo; (or sometimes as a &ldquo;Procedure&rdquo;). Both Properties and Methods (and therefore the Functions that Methods invoke or &ldquo;call&rdquo;) have a *name*.

The Properties of our *oCar* Object are its colour, how many people it can seat, how many wheels it has, if it&rsquo;s manual or automatic transmission, who its manufacture was, which model is it, etc.

The Methods of our *oCar* Object are *move forward (fpMoveForward())*, *turn left (fpTurnLeft())*, *turn right (fpTurnRight())*, *move backwards (fpMoveBackwards())*, *stop (fpStop())*, etc (&ldquo;fp&rdquo; for &ldquo;function/procedure&rdquo;).

Using the OOP method has many advantages, including making programs more logical, easier to code, smaller, easier to maintain, and easier to understand. OOP does this because of three properties of OOP: Encapsulation, Inheritance, and Polymorphism.

#### Encapsulation

*Encapsulation* is the idea that Objects can contain (and be contained by) other Objects.

Our *oCar* Object has doors (*oDoor* Objects), wheels (*oWheel* Objects), seats (*oSeat* Objects), an engine (*oEngine* Object), etc. Instead of defining four separate doors as part of our *oCar* Object, we define a single *oDoor* Object, then &ldquo;encapsulate&rdquo; the *oDoor* Object (four times) within our *oCar* Object. Likewise with the *oSeat* Object, the *oEngine* Object, etc.

These Objects are fully fledged Objects in the own right, with their own Properties and Methods, and may encapsulate other Objects as well.

#### Inheritance

Objects have the ability to inherit Properties and Methods from other Objects. This is critical for re-usability &mdash; the capability to modify an Object to a specific use without having to rewrite it.
 
Now that we have our *oCar* Object, we may want to have an *oPlane* Object. *oPlane* has all of the Properties and Methods of *oCar*, but also has new Properties (how high the plane can fly), new Methods *(up (fpClimb())*, *down (fpDown()))*, and even new encapsulated Objects (*oTail*, *oWings*, etc).

Instead of defining *oPlane* in its entirety, *oPlane* can be defined based on *oCar* &mdash; *oPlane* can be said to have *inherited* the Properties, etc, from *oCar*, and thus *oPlane* can be said to be a &ldquo;child&rdquo; of *oCar*.

Inheritance improves productivity enormously. We should never have to &ldquo;reinvent the wheel&rdquo; using OOP.

#### Polymorphism
 
Objects can override their inherited Properties and Methods.
 
Our *oPlane* Object can redefine the *fpStart()* and *fpStop()* Methods of *oCar*, making them more suitably &mdash; changing these Methods to &ldquo;take off&rdquo; and &ldquo;land&rdquo;, or change its *sColour* Property (&ldquo;s&rdquo; for &ldquo;string&rdquo;) from what it was in *oCar* &mdash; &ldquo;Red&rdquo; &mdash; to &ldquo;Green&rdquo;.
 
Polymorphism (&ldquo;poly&rdquo; = &ldquo;multiple&rdquo;, &ldquo;morph&rdquo; =  &ldquo;shapes&rdquo;) enhances reusability of Objects. We don&rsquo;t have to discard *oCar* as a parent for *oPlane* just because its *fpStart()*, *fpStop()*, and *sColour* Methods and Property don&rsquo;t quite accurately describe our aeroplane.

### Some More OOP Concepts &amp; Terms

When working with Objects there are threemore concepts which are important: Classes, Instances, and Events.

#### Class

A *Class* is a definition of an Object &mdash; the computer code which forms the &ldquo;blueprint&rdquo; of the Object. In our examples the *oCar* Object is defined by the *CarClass* Class.

Many beginners mistake a Class for a program or a function/procedure. A Class is NOT executable code. It is a blueprint only. Just like a real blueprint, you can't live in the house represented by the blueprint until you build it.

A *SubClass* is a &ldquo;child&rdquo; Class derived, through inheritance, from another Class. In our examples the *PlaneClass* Class is the &ldquo;SubClass&rdquo; of the *CarClass* Class.

A *SuperClass* is the &ldquo;parent&rdquo; Class of a SubClass. In our examples the *CarClass* Class is the &ldquo;SuperClass&rdquo; of the *PlaneClass* Class.

In FG Classes are call *WindowClasses* or *Templates*, depending upon where and how they are used.

#### Instance

The actual &ldquo;Object&rdquo; derived from a Class. In our examples the *oCar* and *oPlane* Objects.

We can have multiple instances simultaneously of the same Class.

Instances are the Objects end-users actually see and use. Classes and SubClasses are the programming tools we use to create them.


#### Events

Classes, and therefore Instances, also have *Events*. Events are things that happen to an Object, such as being Clicked on with the mouse (onClick), being double-clicked (onDoubleClick), when being dragged (onDrag) and when being dropped (onDrop), etc.

The name of most Events start with `on`, and most Events (which we are interested in) within an Object have a Method linked to them, so that when the Event occurs &ldquo;something happens&rdquo;.

(End digression.)

## Resources

Resources are graphic files, text strings, fonts, etc &mdash; anything outside of FG that needs to be incorporated into FG. Resources are incorporated into FG via a *Resource Tag* (see below) placed in the appropriate `XML<Feature>Fonts.xml`, `XML<Feature>Frames.xml`,`XML<Feature>Icons.xml`,`XML<Feature>Images.xml`, or `XML<Feature>Strings.xml` File.

## Lua Scripts

The Lua Scripts used in FG come in two forms: Inline Scripts and External File Scripts. Like Resources, Lua Scripts are incorporated into FG via *Script Tags*.

## XML Code

XML is a method of encoding information that uses code-constructs known as *Tags*. A Tag looks like either these:

- `<tag_name>xValue</tag_name>`
- `<tag_name/>`

Both of these are the same: the first one is used when the Tag needs a value of some kind; the second is used when the Tag doesn&rsquo;t require a value. Note that we can use the first form in place of the second and simply omit the value.

Tags (both forms) may also have one or more *Attributes*. A Tag with a single attribute looks like this:

- `<tag_name attribute_name="sAttributeValue">xValue</tag_name>`

Tags may have one or more *child-Tags*. The child-tag(s) form the value of the Tag. A Tag with two child-Tags looks like this:

~~~
<tag_name>
	<child_tag_1>xValue1</child_tag_1>
	<child_tag_2 />
</tag_name>`
~~~

An XML Entity is a self-contained Tag: either a single Tag or a tag and its child-Tags. In the terms of our Project, XML Entities are Classes and/or Objects (depending upon the context where they are used).

XML Coding is simply a matter of creating XML Entities (or reusing existing XML Entities) and stringing them together. There are a number of pre-existing XML Entities available in either the FG-Engine, the *CoreRPG*, or the various features of our Project (primarily in the `DORCoreMin/DORBase/XMLFiles/xDORBaseTemplates.xml` File).

## See Also

<<<<<<< HEAD
- [The FG-Architecture](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/The_FG_Architecture.md)
=======
- [The FG-Architecture](The_FG_Architecture.md)
>>>>>>> r0.2
- [Lua Tutorial](http://lua-users.org/wiki/LuaTutorial)
- [FG Ruleset Modification Guide](https://www.fantasygrounds.com/modguide/)
- [FG XML And Scripting Reference](https://www.fantasygrounds.com/refdoc/)

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
