# Naming Standards

---

Version 1.0.0

These are the Project&rsquo;s *Naming Standards*, organised in alphabetic order.

<<<<<<< HEAD
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
=======
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
>>>>>>> r0.2

## Interpretations

The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo; in this Document are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

## Examples

If in doubt about anything to do with naming Files please see the existing Files in the various Folders/Directories of the Project for examples.

## Branches

1. All Branches SHALL be named as follows:
	1. SHALL be named in a descriptive manner using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	2. SHALL use [Title Case](https://en.wikipedia.org/wiki/Title_Case) format for their names.
2. If a Hotfix is in response to an Issue, in addition to (1), SHOULD be named after that Issue in a legible and easily understandable manner. 
3. **Release Branches**,in addition to the above, SHALL be named as follows:
	1. SHALL NOT use [Title Case](https://en.wikipedia.org/wiki/Title_Case) format, but instead MUST use [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) for their names.
	2. MUST start with the lower-case letter `r``.
<<<<<<< HEAD
	3. SHALL be followed by a [SemVer](http://semver.org) or a [SemVer+](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/Semantic_Versioning_Plus.md) version number, as appropriate.
=======
	3. SHALL be followed by a [SemVer](http://semver.org) or a [SemVer+](Semantic_Versioning_Plus.md) version number, as appropriate.
>>>>>>> r0.2


## Feature Branch Directories

1. **Feature Branch Directories** SHALL be named as follows:
	1. SHALL be named in descriptive manner using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	2. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

The names of existing Folders/Directories from the `DORCoreMin` Folder/Directory can be used as examples.

## File Names

1. **Button Image** Files SHALL be named as follows:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letters `btn`.
	3. SHALL be followed by a descriptive name of what the Button Image File&rsquo;s purpose is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	4. MUST end with `.png` &mdash; ie MUST be a `PNG` file type.
	5. MUST NOT contain any other `.` characters.
	6. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
2. **Document** Files SHALL be named as follows:
	1. MUST use [Title Case](https://en.wikipedia.org/wiki/Title_Case) format with any space `' '` characters replaced by Underscore `_` characters.
	2. SHALL be as descriptive as possible to what the Document File&rsquo;s purpose is, using only alphanumeric characters and the Underscore character [`0-9`, `A-Z`, `a-z`, `_`].
	3. MUST end with either `.md` or `.pdf` &mdash; ie MUST be either a `MD` or `PDF` file type.
	4. MUST NOT contain any other `.` characters.
	5. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
3. **Font** Files SHALL be named as follows:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `f`.
	3. SHALL be followed by a descriptive name of what the Font File&rsquo;s purpose is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	4. MUST end with either `.fgf` or `.ttf` &mdash; ie MUST be either a `FGF` or `TTF` file type.
	5. MUST NOT contain any other `.` characters.
	6. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
4. **Icon Image** Files SHALL be named as follows:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `i`.
	3. SHALL be followed by a descriptive name of what the Icon Image File&rsquo;s purpose and/or content is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	4. MUST end with `.png` &mdash; ie MUST be a `PNG` file type.
	5. MUST NOT contain any other `.` characters.
	6. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
5. **Lua  (Script)** Files SHALL be named as follows:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letters `ls`.
	3. SHALL be followed by the name of the Lua File&rsquo;s parent Folder/Directory.
	4. SHALL be followed by a descriptive name of what the Lua File&rsquo;s purpose and/or content is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	5. MUST end with `.lua` &mdash; ie MUST be a `Lua` file type.
	6. MUST NOT contain any other `.` characters.
	7. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
6. **Non-Button and Non-Icon Image** Files SHALL be named as follows:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letters `img`.
	3. SHALL be followed by a descriptive name of what the Image File&rsquo;s purpose is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	4. MUST end with `.png` &mdash; ie MUST be a `PNG` file type.
	5. MUST NOT contain any other `.` characters.
	6. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
7. **XML** Files SHALL be named as follows:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `x`.
	3. SHALL be followed by the name of the XML File&rsquo;s parent Folder/Directory.
	4. SHALL be followed by a descriptive name of what the XML File&rsquo;s purpose and/or content is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
	5. MUST end with a `.xml` &mdash; ie MUST be a `XML` file type.
	6. MUST NOT contain any other `.` characters.
	7. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

The file-names of existing files and documents can be used as examples.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
