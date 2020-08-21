# Hello World!

---

Version 1.0.0

## Introduction

For those of you new to coding for FG (or new to coding &mdash; period) we have put together this &ldquo;Hello World!&rdquo; example to help you in contributing to the Project.

A &ldquo;Hello World!&rdquo; program is a computer program that outputs or displays the message &ldquo;Hello World!&rdquo;. Such a program is usually very simple in most programming languages, and is often used to illustrate the basic syntax of a programming language. It is often the first program written by people learning to code. It can also be used as a sanity test to make sure that a computer language is correctly installed, and that the operator understands how to use it.

A typical &ldquo;Hello World!&rdquo; program looks like this C-Language program:

~~~
main( ) {
    printf("Hello World!\n");
}
~~~

However, a &ldquo;Hello World!&rdquo; for FG is a tad more complex, but this example will introduce you to a number of concepts and techniques that we use when we code for FG.

So let&rsquo;s dive in.

## Our FG &ldquo;Hello World!&rdquo; Program

To display &ldquo;Hello World!&rdquo; (without the quotes) in FG we&rsquo;re going to need and decide on a couple of things.

### A &ldquo;Hello World!&rdquo; Extension

The very first thing we need to decide is if we want our &ldquo;Hello World!&rdquo; to be part of a Ruleset (or even a Ruleset it its own right), or if it&rsquo;s better off as an Extension. It&rsquo;s probably better off as an Extension, as we may want to use it to test out other *DORCoreMin* child-Rulesets, etc.

So let&rsquo;s create it as an Extension.

### Set Up Gitkraken For Our New &ldquo;Hello World!&rdquo; Extension

First, we start up GitKraken and make sure we have our local copy of the FGI Repo loaded.

It&rsquo;s always a good idea when starting a new feature, hotfix, or release branch to do a fresh pull from the Project&rsquo;s main repo&rsquo;s development branch, so check out your local `develop` branch (double-click on it in the `GITFLOW` area of the left-hand menu-list), then click on the `Pull` Button located on the top Button-Bar.

When the pull has finished (you&rsquo;ll see a notification box briefly towards the bottom-left corner of the GitKraken window), click on the green `Right Arrow` that will appear when you hover the mouse over the `GITFLOW` entry of the left menu-list, then click the `Feature` Button in the `Start` section of the window that appears.

To name our new feature we&rsquo;ll enter into the now displayed Entrybox the text `HelloWorld` so that the entire Entrybox reads `feature/HelloWorld`.

Make sure the `Latest develop` Radio Button is selected, and then the `Start Feature` Button.

At this point we can minimise, or even close, GitKracken because we won&rsquo;t be needing it for a while.

### The &ldquo;Hello World!&rdquo; Extension&rsquo;s Folder/Directory Structure

Now, normally what we will be doing is using the above to create a new feature inside the *DORCoreMin* Ruleset, and our next step would be to use the Windows&rsquo; *File Explorer* to create a new child-folder/directory under the `DORCoreMin` folder/directory to hold our new feature. But we&rsquo;re creating a new Extension, so we&rsquo;ll create a child-folder/directory under the `FGI` folder/directory instead, and we&rsquo;ll call it `DOCEHelloWorld` &mdash; *then* we&rsquo; create the feature&rsquo;s folder/directory under this new folder/directory. Let&rsquo;s do this now.

Create the `FGI/DOCEHelloWorld` folder/directory, and then the feature folder within the new directory and call it `FGI/DOCEHelloWorld/DOCEHW`.

### The `extension.xml` File

An Extension needs to have a file called `extension.xml` placed directly under the Extension&rsquo;s main folder/directory (this is the equivalent of a Ruleset&rsquo;s `base.xml` file), so make a copy of the `xml_file_template.xml` file (found in the Project&rsquo;s `Support_Files` folder/directory), move the copy to the `FGI/DOCEHelloWorld` folder/directory, rename it `extension.xml`, and then open it in *Notepad++* (or whichever text editor you are using).

Extensions (and Rulesets) need various commands located in the `extension.xml` file (in the `base.xml` file) to work properly. Below is listed the entire contents of our `extension.xml` file. Copy the blow text into your `extension.xml` file; we&rsquo;ll go through it block by block below.

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
		<description>An Extension that displays the text "Hello World!" in a window with a Close Button.</description>
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

Lines 1-12 are the standard boilerplate that every `XML` file for our Project is required to have. We need to add to the `<root>` (line 12) the extra attributes shown.

Lines 13-22 form the *properties* element. These individual tags can be found in the [FG Ruleset Modification Guide](https://www.fantasygrounds.com/modguide/) and the [FG XML And Scripting Reference](https://www.fantasygrounds.com/refdoc/). Most should be self-explanatory.

The *ruleset* block (lines 18-21) is required for *each* Ruleset that we want the Extension to work with. Also available (but not used here) is a *dependency* block, which is used to specify if another Extension is required to be loaded for this Extension to be used.

The *announcement* block is used to display text in the FG Chatbox when FG first starts. Change the `By Matthew J BLACK (Dulux-Oz)` part of this to your own name (or not &mdash; it&rsquo;s up to you). The `\n` is the *new-line* character-code and causes the remaining text to appear on a new line.

Finally, the *base* block tells the FG-Engine to load the Extension&rsquo;s `xDOCEHWFiles.xml` file, which contains all of the other, relevant links to the Extension&rsquo;s files. Normally, for a feature, an *\<includefile>* tag like this would be included in the Ruleset&rsquo;s `base.xml` file.

So now we have our next file which we need to create (the `xDOCEHWFiles.xml` file). But before we do, there&rsquo;s something else we need to do first.

### Create The &ldquo;Hello World!&rdquo; Extension&rsquo;s `icon`.

On line 12 on the `extension.xml` file is the name of a logo: `iHWLogo.png`, and on line 23 there is the name of an *Icon Reference*: `iHWExtensionIcon`. So in addition to a the `xDOCEHWFiles.xml` file we&rsquo;re going to need that icon image and that icon reference (and the icon image that the icon reference &ldquo;points too&rdquo;). Let&rsquo;s organise those now.

First, the `xDOCEHWFiles.xml` file needs to be created, and, to hold this file a new folder/directory is also required: `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/`.

Normally we would also create a corresponding `xDOCEHWIcons.xml` file and `FGI/DOCEHelloWorld/DOCEHW/Icons/` folder/directory as well, but logos are special beasties, and don&rsquo;t follow the normal rules and standards. More on this later.

Create the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, then make a copy of the `FGI/Support_Files/xml_file_template.xml`, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWFiles.xml`. Open up the new file in *Notepad++*, and add the relevant *\<icon>* tag to it, so that the `xDOCEHWFiles.xml` file looks like this:

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
	<icon name="iHWExtensionIcon" file="iHWLogo.png" />
</root>
~~~

Remember to save you work in *Notepad++*.

This is where the logo&rsquo;s icon reference needs to go, and is always the first (relevant) line of the Ruleset&rsquo;s/Extension&rsquo;s `x<feature>XMLFiles.xml` file.

For the actual image file we&rsquo;ll be using, you can use any `PNG` image you like, as long as it&rsquo;s 30 pixels by 30 pixels. Call the image file `iHWLogo.png` and place it in the `FGI/DOCEHelloWorld/` folder/directory &mdash; this is where logo icons should go.

So, after all that we are now ready to do the rest our &ldquo;Hello World!&rdquo; Extension.

### Create The &ldquo;Hello World!&rdquo; Extension&rsquo;s XML Objects

To display &ldquo;Hello World!&rdquo; we&rsquo;re going to need the string `Hello World!`. The best way to use strings such as this is to use a *String Reference*. String references go into a separate `xDOCEHWStrings.xml` file, so make a copy of the `FGI/Support_Files/xml_file_template.xml`, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWStrings.xml`. Add the relevant *\<includefile>* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

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
	<icon name="iHWExtensionIcon" file="iHWLogo.png" />
<!-- XML Files -->
	<includefile source="DOCEHW/XMLFiles/xDOCEHWStrings.xml" />
</root>
~~~

Open up the new `xDOCEHWStrings.xml` file in *Notepad++* and add the relevant *\<string>* tag to it, so that it looks like this:

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

The next thing we need to do is work out how to actually display the `sHelloWorldString` string reference. We&rsquo;ll use a *form* to do this, which in FG is known as a *windowclass*. Windowclasses are also stored in their own file, so make another copy of the `FGI/Support_Files/xml_file_template.xml`, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWWindowClasses.xml`. Add the relevant *\<includefile>* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

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
	<icon name="iHWExtensionIcon" file="iHWLogo.png" />
<!-- XML Files -->
	<includefile source="DOCEHW/XMLFiles/xDOCEHWStrings.xml" />
	<includefile source="DOCEHW/XMLFiles/xDOCEHWWindowClasses.xml" />
</root>
~~~

Open up the new `xDOCEHWWindowClasses.xml` file in *Notepad++* and add the relevant *\<windowclass>* tag to it, so that it looks like this:

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

A form/windowclass needs a whole bunch of sub-elements, which are listed within the \<windowclass> element. For our simple &ldquo;Hello World!&rdquo; Extension we only need a few, which are listed and explained below. Add the following elements to the \<windowclass> element so that it looks like this :

~~~
	<windowclass name="wcHelloWorld">
		<frame>utilitybox3</frame>
		<placement>
			<size width="300" height="100" />
		</placement>
		<sheetdata>
			<windowtitlebar>
				<resource>sHelloWorldTitleString</resource>
			</windowtitlebar>
			<tWindowFrame name="gcYellowFrame">
				<anchored position="insidetop" offset="-100,50" height="25" />
				<frame name="frmWLYellow" />
			</tWindowFrame>
			<tDispStrCtrlMid name="sHelloWorld">
				<anchored to="gcYellowFrame" position="insidetop" offset="5,5" height="15" />
				<static textres="sHelloWorldString" />
			</tDispStrCtrlMid>
			<tButCloseUtilBox />
		</sheetdata>
	</windowclass>
~~~

Remember to save you work in *Notepad++*.

A form/window needs a background image to actually put things on, so we&rsquo;ll use a pre-existing image (a frame) from the (grand)parent *CoreRPG* Ruleset called `utilitybox3` (line 14). The definition for `utilitybox3` can be found in the *CoreRPG* Ruleset in the `/graphics/graphics_frames.xml` file (You&rsquo;ll need to unzip the `CoreRPG.pak` file to see this file, but you won&rsquo;t need to unzip it to use it).

The *\<placement>* tag (lines 15-17) tells FG where to position our form on the screen and how big to make it (all measurements are in pixels &mdash; dots on the screen, and are measured from the top-lefthand corner of the screen (or other object being measured from)). Without a:

~~~
		<placement>
			<position x="[nXPos]" y="[nYPos]" />
		</placement>
~~~

set of tags, the form/window will be centred both horizontally and vertically within the FG Window.

All of the *encapsulated* XML Elements that will appear on the form need to go inside a *\<sheetdata>* tag (lines 18-31).

Forms should have a *title*, and there is a pre-defined title element (with all of the graphics, placement details, etc) called `<windowtitlebar>` (lines 19-21). All we need to do to change the text of our title is to include a `<resource>` tag (line 20) and give it a value of a string resource (we&rsquo;ll create the string resource in a moment).

The `tDispStrCtrlMid` tag (lines 26-29), which we&rsquo;ve called &ldquo;sHelloWorld&rdquo;, is how our &ldquo;Hello World!&rdquo; text from the `sHelloWorldString` string resource we created earlier gets displayed (line 28). The *\<static>* tag simple means that the text of &ldquo;sHelloWorld&rdquo; will not dynamically change, and that we are using a *textres*, or text resource.

The &ldquo;sHelloWorld&rdquo; object needs to know where it should be placed on the screen and how big it should be. The `tDispStrCtrlMid` element already has the font type, font size, and font colour defined for it. The `<anchored>` tag (line 27) says that the &ldquo;sHelloWorld&rdquo; object should have a height of `15` (pixels), be anchored to the &ldquo;gcYellowFrame&rdquo; object (more in a moment), be positioned to the &ldquo;insidetop&rdquo;, and offset from the &ldquo;gcYellowFrame&rdquo; object by `5` and `5.`

The position of our &ldquo;sHelloWorld&rdquo; object is the &ldquo;insidetop&rdquo; of the &ldquo;gcYellowFrame&rdquo; object. There are a number of positions that an object can take relative to another object. &ldquo;insidetop&rdquo; means to measure the position of the &ldquo;sHelloWorld&rdquo; from the centre-top of the &ldquo;gcYellowFrame&rdquo; object. How far to measure is given by the *offset* attribute. When choosing the centre-side of an object to measure from, the orthogonal measurement &mdash; in our case, the horizontal measurement because we&rsquo;re measuring from the centre-top (the vertical) &mdash; is how far *both* of the orthogonal sides are from the orthogonal sides of the object we&rsquo;re anchoring too. When anchoring to a corner, the two values on an *offset* attribute measure the *left/horizontal* (or *right* if anchoring to the right of an object) and the *top/vertical* (or *up* if measuring from the bottom of an object).

So, as far as the position of the &ldquo;sHelloWorld&rdquo; object is concerned, it is horizontally centred on the top of the &ldquo;gcYellowFrame&rdquo; object, is `5` pixels lower down the screen than the top of the &ldquo;gcYellowFrame&rdquo; object, and is `5` pixels in (left and right) from the edges of the &ldquo;gcYellowFrame&rdquo; object. Finally, it is `15` pixels in height.

Incidentally, if ever we were to reposition the &ldquo;gcYellowFrame&rdquo; object the &ldquo;sHelloWorld&rdquo; object would also be repositioned so that it reatined the same *relative* position to the &ldquo;gcYellowFrame&rdquo; object.

So, what&rsquo;s this &ldquo;gcYellowFrame&rdquo; object anyway?

Well, putting black text (the existing font-colour of the &ldquo;sHelloWorld&rdquo; object) on a dark background (the `utilitybox3` frame) makes the text impossible to read. So, to make the text stand out, we could have defined another *\<font>* (font-size, font-style, and font-colour are all defined for a single font reference &mdash; we need a new font reference if we want&rsquo;d to change any one of those attributes) or wh can give the &ldquo;sHelloWorld&rdquo; object a lighter background to sit upon.

We do this by defining a *\<tWindowFrame* named &ldquo;gcYellowFrame&rdquo;. Its main property is to display the &ldquo;frmWLYellow&rdquo; frame, which is a pre-defined frame from the *DORCoreMin* Ruleset.

The &ldquo;gcYellowFrame&rdquo; object also has a position on the screen; without an *to* attribute the refered object becomes the form itself. So the &ldquo;gcYellowFrame&rdquo; object is positioned in the horizontal-centre of the &ldquo;wcHelloWorld&rdquo; form, `-100` pixels in from each edge, `50` pixels down from the top of the form, and has a height of `25` pixels.

Finally, we have added a pre-defined &ldquo;close&rdquo; button (the `<tButCloseUtilBox />` &mdash; line 30) especially created for use with all &ldquo;utilitybox3&rsquo; frames.

Incidentally, the order that the various XML Entities appear in the *\<windowclass>* is the order that they will be displayed on the screen &mdash; if we had defined &ldquo;sHelloWorld&rdquo; *before* &ldquo;gcYellowFrame&rdquo; the yellow box would have been on top of the &ldquo;Hello World!&rdquo; text and so the &ldquo;Hello World!&rdquo; text would have been hidden (not to mention that FG would have thrown an error because &ldquo;Hello World!&rdquo; references &ldquo;gcYellowFrame&rdquo; *before* &ldquo;gcYellowFrame&rdquo; is defined &mdash; this is a common mistake in novice FG-coders).

We still need to define the `sHelloWorldTitleString` string reference, so go back to the `xDOCEHWStrings.xml` file and add (the new) Line 15 so that the file looks like this:

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
	<string name="sHelloWorldTitleString">HELLO WORLD!</string>
	<string name="sSidebarTooltipHWStr">Open the Hello World! Form</string>
</root>
~~~

Remember to save you work in *Notepad++*.

### Getting The &ldquo;Hello World!&rdquo; Form/WindowClass Displayed

Now we have our form/window with all of its included elements. But how do we actually get the form to display. Well, there are two ways: the first is to display the form automatically when FG starts via a script. The second is via a control (ie a Button) on the FG Menu-Bar (or elsewhere). Let&rsquo;s do it both ways, so that our form/window is displayed both when FG starts and when we click the control.

First, the script.

We&rsquo;ll need a `FGI/DOEHelloWorld/DOCEHW/Scripts` folder/directory, so create it now. Then, make a copy of the `FGI/Support_Files/lua_file_template.lua` file, move it to the `FGI/DOCEHelloWorld/DOCEHW/Scripts/` folder/directory, and rename it `lsHelloWorld.lua`. Add the relevant *\<includefile>* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

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
	<icon name="iHWExtensionIcon" file="iHWLogo.png" />
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

The `onInit()` function does one job: it calls the `toggleWindow()` function with two arguments: the name of the Window (form/windowclass) we want to &ldquo;turn on&rdquo; (or turn off &mdash; display or hide), and the name of the *node* in the XML-File database (`db.xml`) which the form is &ldquo;linked to&rdquo; (where it gets and stores its data). Our simple form doesn't use any data, so we leave the second argument of `toggleWindow()` blank (`""`).

`toggleWindow()` itself is located in a &ldquo;package&rdquo; called `Interface`. A package is simple a named collection of Lua functions in a Lua file.

Now, the Button Method.

To display our &ldquo;Hello World!&rdquo; form we&rsquo;ll use a small menu-bar button which we&rsquo;ll place with the other small menu-bar buttons in the top-right corner of the FG window. There already exists a function to create this button: `fpAddMenubarButton()`, found in the `MenubarIcon` package of the *DORCoreMin* Ruleset.

`fpAddMenubarButton()` is called with the command `MenubarIcon.fpAddMenubarButton("<sGameStyle>","<sButtonName>","<sIcon>" ,"[<sColour>],"[<sIconColour>]")` with the following arguments:

- sGameStyle &mdash; the style or genre of the RPG the icon on the button is being used for. There are several style pre-defined in the *DORCoreMin* Ruleset, and there is the ability to add new styles. If in doubt, or to have a single icon for the button, use the argument `Interface.getString("sMenubarStyleFantasyString"` for the style.
	+ The text `Interface.getString("sMenubarStyleFantasyString")` is using the function `getString()` from the `Interface` package with the argument `sMenubarStyleFantasyString` (which is a string reference) to return the text of the string reference. This is the pre-defined game style &ldquo;Fantasy&rdquo;, which is the default style.
- sButtonName &mdash; the name we are giving the button. Always use the same string as the button&rsquo;s &ldquo;tool tip&rdquo; (the reason why is too complex to go into here).
- sIcon &mdash; the image reference to use on the Button.
- sColour &mdash; an optional argument which is the colour (as a Hexadecimal number) of the button&rsquo;s background. Defaults to grey (`FFC0C0C0`).
- sIconColour &mdash; an optional argument which is the colour (as a Hexadecimal number) of the button&rsquo;s icon. Defaults to black (`FF000000`).

So, in the `lsHellowWorld.lua` file, add Line 16 so that the file looks like this:

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
	MenubarIcons.fpAddMenubarButton(Interface.getString("sMenubarStyleFantasyString"),Interface.getString("sSidebarTooltipHWStr"),"iBarHelloWorld");
	return;
end
~~~

Remember to save you work in *Notepad++*.

Note that we use the `Interface.getString()` function to return the string reference `sSidebarTooltipHWStr` for the button&rsquo;s name. We also call the icon reference `iBarHelloWorld`. We&rsquo;ll need to create both of these.

In the `xDOCEHWStrings.xml` file, add Line 16 so that the file looks like this:

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
	<string name="sHelloWorldTitleString">HELLO WORLD!</string>
	<string name="sSidebarTooltipHWStr">Open the Hello World! Form</string>
</root>
~~~

Remember to save you work in *Notepad++*.

We&rsquo;ll (now) need a `FGI/DOEHelloWorld/DOCEHW/Icons` folder/directory, so go ahead and create it. Then, make a copy of the `FGI/Support_Files/xml_file_template.xml` file, move it to the `FGI/DOCEHelloWorld/DOCEHW/XMLFiles/` folder/directory, and rename it `xDOCEHWIcons.xml`. Add the relevant *\<includefile>* tag to the `xDOCEHWFiles.xml` file so that the `xDOCEHWFiles.xml` file looks like this:

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
	<icon name="iHWExtensionIcon" file="iHWLogo.png" />
<!-- XML Files -->
	<includefile source="DOCEHW/XMLFiles/xDOCEHWIcons.xml" />
	<includefile source="DOCEHW/XMLFiles/xDOCEHWStrings.xml" />
	<includefile source="DOCEHW/XMLFiles/xDOCEHWWindowClasses.xml" />
<!-- Lua Script Files -->
	<script name="HelloWorld" file="DOCEHW/Scripts/lsDOCEHWHelloWorld.lua" />
</root>
~~~

Open up the new `xDOCEHWIcons.xml` file in *Notepad++*, and add the relevant *\<string>* tag to it, so that it looks like this:

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
<!-- Non-Overlay Buttons and Icons -->
	<icon name="iBarHelloWorld" file="DOCEHW/Icons/iBarHW.png" />
</root>
~~~

Remember to save you work in *Notepad++*.

Now we just need a small `PNG` file to use as the Button Image. For small menu-bar buttons for use with the DORCoreMin Ruleset (and child-Rulesets) the image should be no bigger than 25 pixels by 25 pixels, white, and in the centre of a transparent background 50 pixels by 50 pixels. Large menu-bar button images should be no bigger than 50 pixels by 50 pixels, white, and in the centre of a transparent background 100 pixels by 100 pixels.

### Testing Our &ldquo;Hello World!&rdquo; Extension

To test our new Extension we need to:

1. Copy the `DORCoreMin` Ruleset (ie the folder/directory) to the FG data folder&rsquo;s/directory&rsquo;s `rulesets` folder/directory. The easiest way to find the FG data folder/directory is to click on the `Open data folder` Button located towards the top-right of the FG-Launcher.
2. Copy the `DOCEHelloWorld` Extension (ie the folder/directory) to the FG data folder&rsquo;s/directory&rsquo;s `extensions` folder/directory.
3. Create a test campaign using the `DORCoreMin` Ruleset and load the `DOCEHelloWorld` Extension into the campaign. Note that if you are using the free version of FG you need to create the test campaign every time you re-start FG &mdash; the paid versions of FG do not have this limitation.
4. See if the *Hello World* form is displayed when FG finally loads.
5. Close the *Hello World* form, and then click on the *Hello World* small menu-bar button and see if the *Hello World* form re-opens.

If everything works correctly then we&rsquo;re done! Otherwise, troubleshoot you&rsquo;re work (most likely a typo somewhere &mdash; use any error messages displayed in the `console.log` file located in the FG data folder/directory).

### Getting Our &ldquo;Hello World!&rdquo; Extension Included Into The &ldquo;Offical&rdquo; Repo

We don&rsquo;t actually want our *Hello World* Extension included in the Project&rsquo;s Official Repository (we&rsquo;d have a whole bunch of copies of the same Extension, all competing with one another), but for a normal feature we need to follow the below procedure to get our work included.

In GitKracken, we need to make sure we have our feature branch checked out, and then we need to make sure that we have the `WIP` (Work In Progress) line at the top of the graph highlighted.

We need to *Stage* and then *Commit* our changes (see the relevant *How To* Documents in the `Project_Documentation`) folder/directory, and then we need to *push* the feature branch to our GitHub repo (which will create the feature branch on out GitHub Repo).

Once that&rsquo;s complete we then we need to file a *Pull Request* with the Project&rsquo;s Official Repo (again, see the relevant *How To* Document).

Eventually your feature will be approved and included in the Project&rsquo;s official repo (first in the `develop` branch, and then in the `master` branch), and at that point you should pull from the official repo and then push to your (on-line) GitHub repo to bring your copy of the Project up to date (once again, see the relevant *How To* Documents).

## A Sample &ldquo;Hello World!&rdquo; Extension

A finalised, working copy of the &ldquo;Hello World!&rdquo; Extension is included in the Project. It is in the `MJB_DOCEHelloWorld` folder/directory (to keep it separate from your working copy). To use it, copy the `MJB_DOCEHelloWorld` folder to your FG data&rsquo;s `extensions` folder/directory, and rename the folder/directory `DOCEHelloWorld`.

---

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
