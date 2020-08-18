# Hello World!

---

Version 1.0.0

## Introduction

For those of you new to coding for FG (or new to coding &mdash; period) we have put together this &ldquo;Hello World!&rdquo; example to help you in contributing to the Project.

A &ldquo;Hello World!&rdquo; program is a computer program that outputs or displays the message &ldquo;Hello World!&rdquo;. Such a program is usually very simple in most programming languages, and is often used to illustrate the basic syntax of a programming language. It is often the first program written by people learning to code. It can also be used as a sanity test to make sure that a computer language is correctly installed, and that the operator understands how to use it.

A typical &ldquo;Hello World!&rdquo; program looks like this C-Language program:

~~~
main( ) {
    printf("hello, world\n");
}
~~~

However, a &ldquo;Hello World!&rdquo; for FG is a tad more complex, but this example will introduce you to a number of concepts and techniques that we use when we code for FG.

So let&rsquo;s dive in.

## Our FG &ldquo;Hello World!&rdquo; Program

To display &ldquo;Hello World!&rdquo; (without the quotes) in FG we&rsquo;re going to need and decide on a couple of things.

### A &ldquo;Hello World!&rdquo; Extension

The very first thing we need to decide is if we want our &ldquo;Hello World!&rdquo; to be part of a Ruleset (or even a Ruleset it its own right), or if it&rsquo;s better off as an Extension. It&rsquo;s probably better off as an Extension, as we may want to use it to test out other Rulesets, etc.

So let&rsquo;s create it as an Extension.

### Set-Up Gitkraken For Our New &ldquo;Hello World!&rdquo; Extension

First, we start up GitKraken and make sure we have the FGI Repo loaded.

Its always a good idea when starting a new feature, hotfix, or release branch to do a fresh pull from the Project&rsquo;s main repo&rsquo; development branch, so check out your local `develop` branch (double-click on it in the `GITFLOW` area of the left-hand menu-list), then click on the `Pull` Button located on the top Button-Bar.

When the pull has finished (you&rsquo; see a notification box briefly in the bottom-left of GitKraken), click on the `Right Arrow` that will appear when you hover the mouse over the `GITFLOW` entry of the left menu-list, then click the `Feature` Button in the `Start` section of the window that appears.

To name our new feature we&rsquo;ll enter into the now displayed Entrybox the text `HelloWorld` so that the entire Entrybox reads `feature/HelloWorld`.

Click on the `Latest develop` Radio Button, and then the `Start Feature` Button.

At this point we can minimise, or even close, GitKracken because we won&rsquo;t be needing it for awhile.

### The &ldquo;Hello World!&rdquo; Extension&rsquo;s Folder/Directory Structure

Now, normally what we will be doing is using the above to create a new feature inside the *DORCoreMin* Ruleset, and our next step would be to use the Windows *File Explorer* create a new child-folder/directory under the `DORCoreMin` folder/directory to hold our new feature. But we&rsquo;re creating a new Extension, so we&rsquo;ll create a child-folder/directory under the `FGI` folder/directory instead, and we&rsquo;ll call it `DOCEHelloWorld` &mdash; *then* we&rsquo; create the feature&rsquo;s folder/directory under this new folder/directory. Let&rsquo;s do this now.

Create the `FGI/DOCEHelloWorld` folder/directory, and then the feature folder with the new directory and call it `FGI/DOCEHelloWorld/DOCEHW`.

### The `extension.xml` File

An Extension needs to have a file called `extension.xml` placed directly under the Extension&rsquo;s main folder/directory (this is the equivalent of a Ruleset&rsquo;s `base.xml` file), so make a copy of the `xml_file_template.xml` file (found in the Project&rsquo;s `Support_Files` folder/directory), move the copy to the `DOCEHelloWorld` folder/directory, and rename it `extension.xml`, and then open it in *Notepad++ (or whichever text editor you are using).

Extensions (and Rulesets) need various commands located in the `extension.xml` file (`base.xml` file) to work properly. Below is listed the entire content of our `extension.xml` file; we&rsquo;ll go through it block by block below.

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root version="3.3" logo="iHWLogo.png">
	<properties>
		<name>DOCE: Hello World Extension (DOCEHW) v1.0.0</name>
		<version>1.0.0</version>
		<author>Copyright ©2004-2020 Peregrine I.T. Pty Ltd.</author>
		<description>An Extension that displays the text "Hello World!" is a window with a Close Button.</description>
		<ruleset>
			<name>DORCoreMin</name>
			<minrelease>1.0.0</minrelease>
		</ruleset>
	</properties>
	<announcement text="DOCE: Hello World Extension (DOCEHW) v1.0.0\nAn Extension that displays the text 'Hello World!' in a window with a Close Button.\nFor Fantasy Grounds Classic v3.3.11+, the DORCoreMin Ruleset, and selected child Rulesets.\nBy Matthew J BLACK (Dulux-Oz).\nCopyright ©2004-2020 Peregrine I.T. Pty Ltd.\nAll Rights Reserved." font="emotefont" icon="iHWExtensionIcon" />
	<base>
		<includefile source="DOCEHW/XMLFiles/xDOCEHWFiles.xml" />
	</base>
</root>
~~~

Remember to save you work in *Notepad++*.

Lines 1-12 are the standard boilerplate that every `XML` files for our Project is required to have. We need to add to the `<root>` (line 12) the extra attributes shown.

Lines 13-22 form the *properties* element. These individual tags can be found in the [FG Ruleset Modification Guide](https://www.fantasygrounds.com/modguide/) and the [FG XML And Scripting Reference](https://www.fantasygrounds.com/refdoc/). Most should be self-explanatory.

The *ruleset* block (lines 18-21) is required for *each* Ruleset that we want the Extension to work with. Also available (but not used here) is a *dependency* block, which is used to specify if another Extension is required to be loaded for this Extension to be used.

The *announcement* block is used to display text in the FG Chat Box when FG first starts. Change the `By Matthew J BLACK (Dulux-Oz)` part of this to your own name (or not &mdash; its up to you). The `\n` is the *new-line* character-code and cause the remaining text to appear on a new line.

Finally, the *base* block tells the FG-Engine to load the Extension&rsquo;s `xDOCEHWFiles.xml` file, which contains all of the other, relevant links to the Extension&rsquo;s files. Normally, for a feature, an *includefile* line like this would be included in the Ruleset&rsquo;s `base.xml` file.

So now we have our next file which we need to create. But before we do, there&rsquo;s something else we need to do first.

### Create The &ldquo;Hello World!&rdquo; Extension&rsquo;s `icon`.

On line 12 on the `extension.xml` file is the name of a logo: `hw_logo.png`, and on line 23 there is the name of an *Icon Reference*: `iHWExtensionIcon`. So in addition to a the `xDOCEHWFiles.xml` file we&rsquo;re going to need that icon image and that icon reference (and the icon image that the icon reference &ldquo;points too&rdquo;). Let&rsquo;s organise those now.

First, the `xDOCEHWFiles.xml` file needs to be created, and, to hold this file a new folder/directory is also required: `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/`.

Normally we would also create a corresponding `xDOCEHWIcons.xml` file and `FGI/DOCEHelloWorld/DOCEHW/Icons/` folder/directory as well, but logos are special beasties, and don't follow the normal rules and standards. More on this later.

Create the folder/directory, then make a copy of the `FGI/Support_Files/xml_file_template.xml`, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWFiles.xml`. Open up the new file in *Notepad++*, and add the relevant *includefile* tag to it, so that the `xDOCEHWFiles.xml` file looks like this:

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root>
	<icon name="iHWExtensionIcon" file="hw_logo.png" />
</root>
~~~

Remember to save you work in *Notepad++*.

This is where the logo&rsquo;s icon refernce needs to go, and is always the first line of the Ruleset&rsquo;s/Extension&rsquo;s `x<feature>XMLFiles.xml` file.

For the actual image file we&rsquo;ll be using, you can use any `PNG` image you like, as long as it&rsquo; 30 pixels by 30 pixels. Call the image file `iHWLogo.png` and place it in the `FGI/DOCEHelloWorld/` folder/directory &mdash; this is where logo icons should go.

So, after all that we are now ready to the rest our &ldquo;Hello World!&rdquo; Extension.

### Create &ldquo;Hello World!&rdquo; Extension&rsquo;s XML Objects

To display &ldquo;Hello World!&rdquo; we&rsquo;re going to need the string `Hello World!`. The best way to use strings such as this is to use a *String Reference*. String references go into a separate `xDOCEHWStrings.xml` file, so make a copy of the `FGI/Support_Files/xml_file_template.xml`, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWStrings.xml`. Add the relevant *includefile* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root>
	<icon name="iHWExtensionIcon" file="hw_logo.png" />
<!-- XML Files -->
	<includefile source="DOCEHW/XMLFiles/xDOCEHWStrings.xml" />
</root>
~~~

Open up the new `xDOCEHWStrings.xml` file in *Notepad++*, and add the relevant *string* tag to it, so that it looks like this:

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root>
<!-- Non-Overlay Strings -->
	<string name="sHelloWorldString">Hello World!</string>
</root>
~~~

Remember to save you work in *Notepad++*.

The next thing we need to do is work out how to actually display the `sHelloWorldString` string reference. We&rsquo;ll use a *form* to do this, which in FG is known as a *windowclass*. Windowclasses are also stored in their own file, so make another copy of the `FGI/Support_Files/xml_file_template.xml`, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWWindowClasses.xml`. Add the relevant *includefile* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root>
	<icon name="iHWExtensionIcon" file="hw_logo.png" />
<!-- XML Files -->
	<includefile source="DOCEHW/XMLFiles/xDOCEHWStrings.xml" />
	<includefile source="DOCEHW/XMLFiles/xDOCEHWWindowClasses.xml" />
</root>
~~~

Open up the new `xDOCEHWWindowClasses.xml` file in *Notepad++*, and add the relevant *string* tag to it, so that it looks like this:

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root>
<!-- Non-Overlay WindowClasses -->
	<windowclass name="wcHelloWorld">
	</windowclass>
</root>

~~~

Remember to save you work in *Notepad++*.

As you can see, we&rsquo;ll name our new form/windowclass `wcHelloWorld`, as per the Project&rsquo;s Standards.

A form/windowclass needs a whole bunch of sub-elements, which are listed with the resources listed above. For our simple &ldquo;Hello World!&rdquo; Extension we only need a few, which are listed and explained below. Add the following elements to the Our final `wcHelloWorld` form /windowclass so that it looks like this :

~~~
	<windowclass name="wcHelloWorld">
		<frame>utilitybox3</frame>
		<placement>
			<size width="285" height="265" />
		</placement>




	</windowclass>
~~~

Remember to save you work in *Notepad++*.

A form/window needs a background image to actually put things on, so we&rsquo;ll use a pre-existing image (a frame) from the (grand)parent *CoreRPG* Ruleset called `utilitybox3`. The definition for `utilitybox3` can be found in the *CoreRPG* Ruleset in the `/graphics/graphics_frames.xml` file (You&rsquo;ll need to unzip the `CoreRPG.pak`) file to see this file, but you won't need to unzip it to use it).



The *placement* tag tells FG where to position our form on the screen and how big to make it (all measurements are in pixels &mdash; dots on the screen, and are measured from the top-lefthand corner of the screen (or other object being measured from). Without a:

~~~
		<placement>
			<position x="[nXPos]" y="[nYPos]" />
		</placement>
		<sheetdata>
			<windowtitlebar>
				<resource>sHelloWorldTitleString</resource>
			</windowtitlebar>
			<tDispStrCtrlMid name="sGraphTopLabel">
				<anchored to="sGraphCentreLabel" position="above" />
				<static textres="sHelloWorldString" />
			</tDispStrCtrlMid>
~~~

set of tags, the form/window will be centred both horizontally and vertically within the FG Window.













Now we have our form/window with all of its included the elements. But how do we actually get the form to display. Well, there are two ways: the first is to display the form automatically when FG starts via a script. The second is via a control (ie a Button) on the FG Menu-Bar (or elsewhere). Let&rsquo;s do it both ways, so that our form/window is displayed both when FG starts and when we click the control.

First, the script.

We&rsquo;ll need a `FGI/DOEHelloWorld/DOCEHW/Scripts` folder/directory, so create it now. Then, make a copy of the `FGI/Support_Files/lua_file_template.lua`, move it to the `FGI/DOCEHelloWorld/DOCEHW/Scripts/` folder/directory, and rename it `lsHelloWorld.lua`. Add the relevant *includefile* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

~~~
<?xml version="1.0" encoding="iso-8859-1"?>
<!--
	Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
	Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
	Copyright to other material within this Manuscript may be held by other Individuals and/or Entities.
	Nothing in or from this XML File in printed, electronic and/or any other form may be used, copied,
		transmitted or otherwise manipulated in ANY way without the explicit written consent of
		PEREGRINE I.T. Pty Ltd or, where applicable, any and all other Copyright holders.
	Please see the accompanying License for full details.
	All rights reserved.
-->
<root>
	<icon name="iHWExtensionIcon" file="hw_logo.png" />
<!-- XML Files -->
	<includefile source="DOCEHW/XMLFiles/xDOCEHWStrings.xml" />
	<includefile source="DOCEHW/XMLFiles/xDOCEHWWindowClasses.xml" />
<!-- Lua Script Files -->
	<script name="HelloWorld" file="DOCEHW/Scripts/lsHelloWorld.lua" />
</root>
~~~


Open up the new `lsHellowWorld.lua` file in *Notepad++*, change Line 11, and add the Lua code below, so that the file looks like this:

~~~
--
-- Copyright ©2004-2020 PEREGRINE I.T. Pty Ltd except where explicitly stated otherwise.
-- Fantasy Grounds is Copyright ©2004-2020 SmiteWorks USA LLC.
-- Copyright to other material within this file may be held by other Individuals and/or Entities.
-- Nothing in or from this LUA file in printed,electronic and/or any other form may be used,copied,
--	transmitted or otherwise manipulated in ANY way without the explicit written consent of
--	PEREGRINE I.T. Pty Ltd or,where applicable,any and all other Copyright holders.
-- Please see the accompanying License for full details.
-- All rights reserved.
--
-- Called By: xDOCEHWFiles.xml
--

function onInit()
	Interface.toggleWindow("wcHelloWorld","");
	return;
end
~~~

Remember to save you work in *Notepad++*.

Now, when FG starts, the `lsHellowWorld.lua` file will be loaded (via the `xDOCEHWFiles.xml` file, via the `extension.xml` file), and the `onInit()` function will be run.

Now, the Button Method.





---

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
