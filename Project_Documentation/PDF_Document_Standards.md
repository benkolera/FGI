# `PDF` Document Standards

---

Version 1.0.0

These are the Project&rsquo;s *Documentation Standards* for PDF Documents.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Interpretations

The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo; in this and all &ldquo;child&rdquo; Documents are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

## Examples

If in doubt about anything to do with PDF Files and their contents, etc, please see the existing PDF Files in the `Project_Documentation` Folder/Directory for examples.

## General Standards

1. `MD` Documents SHOULD be used in preference to `PDF` Documents.
2. All PDF Documents SHALL follow the *PDF Document Naming Standards* as outlined in the Project&rsquo;s [Naming Standards](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/Naming_Standards.md) Document.
3. All non-Project-generated PDF Documents obtained from other sources SHALL be renamed as per (1).
4. All non-Project-generated PDF Documents SHALL NOT have their contents modified.
5. All of the remaining *`PDF` Document Standards* SHALL NOT apply to non-Project-generated PDF Documents.
6. All Project-generated PDF Documents SHALL have the appropriate [Boilerplate Statement](https://github.com/Dulux-Oz/FGI/master/Support_Files/Boilerplate_Statements.md) included within them. When doing so, the [OO\_Word\_Document\_With\_Images\_Template.lua](https://github.com/Dulux-Oz/FGI/master/Support_Files/OO_Word_Document_With_Images_Template.lua) File or the [OO\_Word\_Document\_Without\_Images\_Template.lua](https://github.com/Dulux-Oz/FGI/master/Support_Files/OO_Word_Document_Without_Images_Template.lua) File,as appropriate, MAY be copied and used, and then converted to a `PDF` Document.
7. All Project-generated PDF Documents SHALL use *Australian English*.

## Page Dimensions

1. The *A4* Page Size MUST be used for all Project-generated PDF Documents.
2. Each Page SHALL have a *20 millimetre* spacing at the Top, Bottom, Left, and Right sides.
3. Each Page SHALL have a *Header* and a *Footer* as specified below.

## Header

1. A Header MUST appear at the top of each Page of a Project-generated PDF Document.
2. The text of each Header SHALL:
	1. Be in *10-point Regular Ariel* font.
	2. Use *Single-Line Spacing*.
	3. Be *horizontally-centred*.
3. The text of each Header MUST NOT be *Bold*, *Italicised*, *Underlined*, or any combination thereof.
4. The text of each Header SHALL consist of:
	1. The *Document&rsquo;s Name*, with spaces (` `) and not underscores (`_`), if appropriate, on the first line.
	2. Followed by the text `Version: `. on the second line. (Note the trailing space character (` `).)
	3. Followed by a [SemVer+](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/Semantic_Versioning_Plus.md) Version Number, also on the second line.
	
For example:

~~~
PDF Document Standards
Version 1.0.0
~~~

## Footer

1. A Footer MUST appear at the bottom of each Page of a Project-generated PDF Document.
2. The text of each Footer SHALL:
	1. Be in *10-point Regular Ariel* font.
	2. All be on one line.
	3. Use *Single-Line Spacing*.
	4. Be *horizontally-centred*.
3. The text of each Footer MUST NOT be *Bold*, *Italicised*, *Underlined*, or any combination thereof.
4. Each Footer SHALL consist of:
	1. The text `Page `. (Note the trailing space character (` `).)
	2. Followed by the Page Number.
	3. Followed by the text ` Of `. (Note the leading and trailing space characters (` `).)
	4. Followed by a Document&rsquo;s Total Number Of Pages.
	
For example:

~~~
Page 1 Of 1
~~~


## Headings

1. All Headings of all Project-generated PDF Documents MUST use the *Regular Ariel* font.
2. All Headings MUST NOT be *Bold*, *Italicised*, *Underlined*, or any combination thereof.
3. The text of each Heading SHALL use *Single-Line Spacing*.
4. The Document&rsquo;s Title MUST:
	1. Be in *28-point* size.
	2. Be in the *horizontal-centre* of the document.
	3. Have a spacing above the text of *4 millimetres*.
	4. Have a spacing below the text of *2 millimetres*.
5. All other Headings SHALL:
	1. Be *left-justified*.
6. The next &ldquo;Heading Level&rdquo; &mdash; &ldquo;Level 1 Heading&rdquo; &mdash; SHALL:
	1. Be in *18-point* size.
	2. Have a spacing above the text of *4 millimetres*.
	3. Have a spacing below the text of *2 millimetres*.
7. The next &ldquo;Heading Level&rdquo; &mdash; &ldquo;Level 2 Heading&rdquo; &mdash; SHALL:
	1. Be in *16-point* size.
	2. Have a spacing above the text of *3 millimetres*.
	3. Have a spacing below the text of *2 millimetres*.
8. All other Headings SHALL:
	1. Have a spacing above the text of *2 millimetres*.
	2. Have a spacing below the text of *1 millimetre*.
9. The next &ldquo;Heading Level&rdquo; &mdash; &ldquo;Level 3 Heading&rdquo; &mdash; SHALL:
	1. Be in *14-point* size.
10. The next &ldquo;Heading Level&rdquo; &mdash; &ldquo;Level 4 Heading&rdquo; &mdash; SHALL:
	1. Be in *12-point* size.
11. The next &ldquo;Heading Level&rdquo; &mdash; &ldquo;Level 5 Heading&rdquo; &mdash; SHALL:
	1. Be in *10-point* size.
12. No more that five &ldquo;Levels&rdquo; MAY be used.

## Paragraphs

1. All Paragraphs of all Project-generated PDF Documents SHALL use:
	1. *1 millimetre* spacing above and below each paragraph.
	2. *Justified* alignment.
	3. A First-Line Indent of *12 millimetres*.

## Character Formatting

1. All &ldquo;Body Text&rdquo; of all Project-generated PDF Documents SHALL:
	1. Use *12-point Regular Times New Roman* font.
	2. Use *1.15 Line Spacing*.

## Images

1. All Images of all Project-generated PDF Documents SHALL:
	1. Be *horizontally-centred* on the page.
	2. Have a Caption below the Image as specified below.

## Tables

1. All Tables of all Project-generated PDF Documents SHALL:
	1. Be *horizontally-centred* on the page.
	2. Have a Caption below the Table as specified below.

## Captions

1. All Captions of all Project-generated PDF Documents SHALL:
	1. Be in *10-point Regular Ariel* font.
	2. Use *Single-Line Spacing*.
	3. Be *horizontally-centred*.
2. The text of each Caption MUST NOT be *Bold*, *Italicised*, *Underlined*, or any combination thereof.
3. Table Captions SHALL consist of:
	1. The text `Table `. (Note the trailing space character (` `).)
	2. Followed by an increasing *Integer Number*, beginning with `1` for the first Table.
	3. Followed by the text `: `. (Note the leading and trailing space characters (` `).)
	4. Followed by a *Title*.
4. Image Captions SHALL consist of:
	1. The text `Image `. (Note the trailing space character (` `).)
	2. Followed by an increasing *Integer Number*, beginning with `1` for the first Image.
	3. Followed by the text `: `. (Note the leading and trailing space characters (` `).)
	4. Followed by a *Title*.

For example:

~~~
Table 27: Example Table
~~~

~~~
Image 3: Example Image
~~~

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
