# `MD` Document Standards

---

Version 1.0.0

These are the Project&rsquo;s *Documentation Standards* for MD Documents.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Interpretations

The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo; in this and all &ldquo;child&rdquo; Documents are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

## Examples

If in doubt about anything to do with MD Files and their contents, etc, please see the existing MD Files in the `` Folder/Directory for examples.

## General Standards

1. `MD` Documents SHOULD be used in preference to `PDF` Documents.
2. The Project&rsquo;s RECOMMENDED formatting for MD Documents is a sub-set of the [GFM](https://github.github.com/gfm/) Specification.
3. While the full GFM Specification MAY be used, the following &lsquo;commands&rsquo; should be sufficient to cover practically all the formatting requirements for the Project.
4. When two or more &lsquo;formatting commands&rsquo; are listed below that perform the same function, the first one listed is the RECOMMENDED &lsquo;command&rsquo; and the alternatives should only be used if the RECOMMENDED &lsquo;command&rsquo; cannot be used for some reason.
5. All MD Documents SHALL follow the *MD Document Naming Standards* as outlined in the Project&rsquo;s [Naming Standards](Naming_Standards.md) Document.
6. All MD Files SHALL have the appropriate [Boilerplate Statement](../Support_Files/Boilerplate_Statements.md) included within them. When doing so, the [MD\_Document\_With\_Images\_Template.lua](../Support_Files/MD_Document_With_Images_Template.lua) Document or the [MD\_Document\_Without\_Images\_Template.lua](../Support_Files/MD_Document_Without_Images_Template.lua) Document (both located in the Project&rsquo;s `Support_Files` Folder/Directory), as appropriate, MAY be copied and used.
7. All MD Documents SHALL use *Australian English*.
8. All MD Documents MUST start:
	1. With a &ldquo;Level 1 Heading&rdquo; (see below).
	2. Then be followed by a blank line.
	3. Then be followed by three Hyphen characters (`---`) (forming a Line).
	4. Then be followed by a blank line.
	5. Then be followed by the text `Version `. (Note the trailing space character (` `).)
	6. Then be followed by a [SemVer+](Semantic_Versioning_Plus.md) Version Number.
	7. Then be followed by a blank line.
9. As a &lsquo;rule of thumb&rsquo; it is RECOMMENDED to separate all formatting into discrete &lsquo;blocks&rsquo; by a Blank Line, except where noted.

## Headings

1. The Document&rsquo;s Title MUST be a &ldquo;Level 1 Heading&rdquo;, followed by a Blank Line.
2. All other Headings SHALL be proceeded and followed by a Blank Line.
3. No more that six &ldquo;Levels&rdquo; MAY be used.

|Command|Meaning|
|:--|:--|
|# Heading|Level 1 Heading|
|## Heading|Level 2 Heading|
|### Heading|Level 3 Heading|
|#### Heading|Level 4 Heading|
|##### Heading|Level 5 Heading|
|###### Heading|Level 6 Heading|


## Character Formatting

1. Character formatting normally occurs &ldquo;inline&rdquo; so a Blank Line SHOULD NOT be required.

|Command|Meaning|Example
|:-:|:-:|:-:|
|\*Text\*|Emphasis|*Text*|
|\_Text\_|Emphasis|_Text_|
|\*\*Text\*\*|Strong|**Text**|
|\_\_Text\_\_|Strong|__Text__|
|\*\*\*Text\*\*\*|Both|***Text***|
|\_\_\_Text\_\_\_|Both|___Text___|
|\~\~Text\~\~|Strikethrough|~~Text~~|
|\&ldquo;|Left Double Quote|&ldquo;|
|\&lsquo;|Left Single Quote|&lsquo;|
|\&rsquo;|Right Double Quote|&rsquo;|
|\&rdquo;|Right Single Quote|&rdquo;|
|\&mdash;|M-Dash|&mdash;|

## Paragraphs

1. Paragraphs MUST be separated by a Blank Line.

## Lists

1. Lists are made up of individual &ldquo;List Items&rdquo;. Individual List Items SHOULD NOT be separated from each other by a Blank Line, but a List as a whole SHALL be proceeded and followed by a Blank Line.

**Note:** Changing the Bullet or Ordered List delimiter starts a new list.

### Ordered Lists

1. Ordered List Items begin with between one and nine Digits (`0-9`), followed by a Dot (`.`, RECOMMENDED) or a Right Parenthesise (`)`), and then a Space (` `).

For example:

~~~
1. List Item
2. List Item
~~~

Gives:

1. List Item
2. List Item

### Bullet Lists

1. Bullet List Items begin with a Hyphen (`-`, RECOMMENDED), an Asterisk (`*`), or a Plus (`+`), and then a Space (` `).

For example:

~~~
- List Item
- List Item
~~~

Gives:

- List Item
- List Item

#### Nested Lists

1. The Bullet or Number of a Nested List Item MUST be proceeded a number of `TAB` Characters, one for each level of &ldquo;nesting&rdquo;.
2. The Bullets used for the different &ldquo;levels&rdquo; of a Nested List SHOULD alternate between a Hyphen (`-`) character and a Plus (`+`) Character.

For example:

~~~
1. Parent List Item
	1. Nested List Item
		1. Nested List Item
~~~

Gives:

1. Parent List Item
	1. Nested List Item
		1. Nested List Item

And:

~~~
- Parent List Item
	+ Nested List Item
		- Nested List Item
~~~

Gives:

- Parent List Item
	+ Nested List Item
		- Nested List Item

### Task Lists

1. A Task List is a List with the addition of a Left Bracket, a Space, and a Right Bracket (`[ ]`); or a Left Bracket, an `x` and a Right Bracket (`[x]`) between the Bullet Character / Number and the List Item&rsquo;s text.

For example:

~~~
- [ ] Task 1
- [x] Task 2
~~~

Gives:

- [ ] Task 1
- [x] Task 2

## Code Blocks

1. A Code Block is surrounded by three Tilde characters (`~~~`, RECOMMENDED) or three Backtick characters (the character on the same key as the Tilde (`~`)).
2. A Code Block SHALL be proceeded and followed by a Blank Line.

For example (without the Spaces (` `) in between the Tildes (`~`) and/or the Backticks):

```
~ ~ ~
This is an example of a Code Block.
~ ~ ~
```

Gives:

~~~
This is an example of a Code Block.
~~~

And

~~~
` ` `
And so is this.

` ` `
~~~

Gives:

```
And so is this.
```

### Code Spans

1. The text of a Code Span is surrounded by Backtick characters (the character on the same key as the Tilde (`~`)).
2. Code Spans can occur inline so a Blank Line SHOULD NOT be required.

For example:

~~~
This is an example of a `Code Span`.
~~~

Gives:

This is an example of a `Code Span`.

## Quotes

1. A Quote begins with a Right Bracket (`>`) followed by a Space (` `).
2. A Quote SHALL be proceeded and followed by a Blank Line.

For example:

~~~
> This is an example of a Quote.
~~~

Gives:

> This is an example of a Quote.

## Horizontal Line

1. A Horizontal Line is created from three Hyphens (`---`, RECOMMENDED), three Asterisks (`***`), or three Underscores (`___`).
2. A Horizontal Line MUST be proceeded and followed by a Blank Line.

## Special Characters

1. The Backslash character (`\`) is used to &rsquo;turn off&rsquo; the special meaning of all of the GFM formatting characters and turn them back into &lsquo;ordinary characters&rsquo; which will be displayed.
2. A Backslash character (`\`) at the end of the line is a Hard Line Break, as is two Spaces (`  `).
3. All of the Special Characters defined for use with HTML5 (as described by the w3Schools.com reference documents starting at <https://www.w3schools.com/charsets/ref_utf_punctuation.asp>) MAY be used either via the standard `&character;` method (eg `&amp;` = &amp;, RECOMMENDED), the decimal code point method (eg `&#1234;`= &#1234;), or the hexadecimal code point method (eg. `&#X200;` = &#X200;).

## Tables

1. A Table is an arrangement of data with rows and columns, consisting of a single Header Row, a Delimiter Row separating the Header from the Data, and zero or more Data Rows.
2. A Table should be proceeded and followed by a Blank Line.
3. Each Row consists of Cells containing arbitrary text separated by Pipes (`|`).
4. A leading and trailing Pipe (`|`) SHOULD also be used.
5. The Delimiter Row consists of Cells whose only content are a Colon and two Hyphens (`:--`); a Colon, a Hyphen, and a Colon (`:-:`); or two Hyphens and a Colon (`--:`), depending upon if you want the Column Left-Justified, Centred, or Right-Justified, respectively.

For example:

~~~
|Left-Justified Heading|Centred Heading|Right-Justified Heading|
|:--|:-:|--:|
|Row 1, Cell 1|Row 1, Cell 2|Row 1, Cell 3|
|Row 2, Cell 1|Row 2, Cell 2|Row 2, Cell 3|
~~~

Gives:

|Left-Justified Heading|Centred Heading|Right-Justified Heading|
| :-- | :-: | --: |
|Row 1, Cell 1|Row 1, Cell 2|Row 1, Cell 3|
|Row 2, Cell 1|Row 2, Cell 2|Row 2, Cell 3|

### Links

1. An inline Link consists of Link Text enclosed in Brackets (`[Link Text]`) followed by the Link&rsquo;s URL enclosed in Parentheses (`(url)`)
2. An optional Title MAY be included at the end of the Link URL inside the Parentheses.
3. Alternately, the raw URL MUST be included by enclosing it in Angle Brackets (`<url>`).

For example:

~~~
[Link Text](http://url.com &ldquo;Title&rdquo;)
~~~

Or:

~~~
<http://url.com>
~~~

### Images

1. An Image is a Link proceeded by an Exclamation Mark (`!`).
2. An Image MUST be proceeded and followed by a Blank Line.
3. The actual image file SHOULD be stored in the Project&rsquo;s `Support_Files` Folder/Directory.

For example:

~~~
![Image/Alt Text][./images/image.jpg "Title"]
~~~

---

## Attribution

![Creative Commons License](https://i.creativecommons.org/l/by-sa/2.5/au/88x31.png "Creative Commons License")

Some material paraphrased from and originally published by John MacFarlane on GitHub at (https://github.github.com/gfm/) and released under a Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
