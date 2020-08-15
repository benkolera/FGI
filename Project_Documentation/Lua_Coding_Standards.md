# Lua Coding Standards

---

Version 1.0.0

These are the Project&rsquo;s *Lua Coding Standards*.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Interpretations

The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo; in this and all &ldquo;child&rdquo; Documents are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

&lsquo;\<Feature>&rsquo; is used in File Names and in Folder/Directory Names and is a &ldquo;placeholder&rdquo; for, and should be replaced by (as per the Project&rsquo;s [Naming Standards](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/Naming_Standards.md)), the name of the *Feature* that the File and/or Folder/Directory relates too.

## Examples

If in doubt about anything to do with Lua Files and their contents, etc, please see the existing Lua Files in the `DORCoreMin/CORE/Scripts/`, `DORCoreMin/DORBASE/Scripts/`, or `DORCoreMin/UDR/Scripts/` Folders/Directories for examples.

## `Lua` File Standards

1. Lua File Scripts SHOULD be used for any script more than 6 lines.
2. Lua File Scripts SHOULD be used for any script that contains more than a single function.
3. All Lua Files SHALL be stored in the appropriate `DORCoreMin/<Feature>/Scripts/` Folder/Directory.
4. All Lua Files must follow the *Lua File Naming Standards* as outlined in the Project&rsquo;s [Naming Standards](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/Naming_Standards.md) Document.
5. All Lua Files MUST have the appropriate [Boilerplate Statement](https://github.com/Dulux-Oz/FGI/master/Support_Files/Boilerplate_Statements.md) included within them. When doing so, the [lua\_file\_template.lua](https://github.com/Dulux-Oz/FGI/master/Support_Files/lua_file_template.lua) File (located in the Project&rsquo;s `Support_Files` Folder/Directory) MAY be copied and used.
6. Globally scoped Script Files MUST be defined by an appropriate `<script />` tag
7. Each globally scoped File Script `<script />` tag SHALL:
	1. Be placed after the text `<!-- Lua Files -->` in the relevant `DORCoreMin/base.xml` or `DORCoreMin/<Feature>/XMLFiles/x<Feature>Files.xml` File.
	2. Be placed on a separate line.
	3. Placed in alphabetical order.
8. Locally scoped file scripts MUST be defined by an appropriate `<script />` tag in the appropriate XML Entity in the relevant XML File.
9. Each locally scoped File Script `<script />` tag SHALL be placed on a separate line.
10. Each locally scoped File Script `<script />` tag MAY have a `name` Attribute
11. Each `name` attribute of a `<script />` tag SHALL:
	1. Use [Title Case](https://en.wikipedia.org/wiki/Title_Case) format.
	2. Be a descriptive name of what the Script File&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].

See also the [XML Coding Standards](https://github.com/Dulux-Oz/FGI/tree/master/XML_Coding_Standards.md).

#### Inline File Scripts

See the [XML Coding Standards](https://github.com/Dulux-Oz/FGI/tree/master/XML_Coding_Standards.md).

## `Lua` Coding Standards

1. Proper indentation SHALL be used, with *4-Character* `TAB` characters being used.
2. Every line of Lua Code MUST end with `;`.
3. All Lua Entity names SHALL:
	1. Use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. Be a descriptive name of what the Lua Entity&rsquo;s purpose is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].
4. All Lua Functions SHALL begin with the text `fp`.
5. All Lua Variables SHALL begin with the letter specified below:
	- Array = `a`
	- Boolean = `b`
	- Character = `s`
	- Numeric = `n`
	- Object = `o`
	- String = `s`
	- Unknown Variable Type (Best To Avoid When Possible) = `xValue` (Preferred) or `x`
6. All Lua Constants SHALL:
	1. Use [Upper Case](https://en.wikipedia.org/wiki/Title_Case) format for their names, with separate words being separated by `_`.
	2. Follow (5) in regards to which letter or text their names SHALL start with.
7. When using a `for...in pairs()` construct the variables `kKey` and `vVaule` SHOULD be used, unless it makes more logical sense to use something else eg. `oNode`.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
