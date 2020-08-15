# `XML` Coding Standards

---

Version 1.0.0

These are the Project&rsquo;s *XML Coding Standards*.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Interpretations

The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo; in this and all &ldquo;child&rdquo; Documents are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

&lsquo;\<Feature>&rsquo; is used in File Names and in Folder/Directory Names and is a &ldquo;placeholder&rdquo; for, and should be replaced by (as per the Project&rsquo;s [Naming Standards](Naming_Standards.md)), the name of the *Feature* that the File and/or Folder/Directory relates too.

All references to various HTML Entity Templates (Classes) should also be interpreted to include any and all &ldquo;child&rdquo; (derived) Templates.

## Examples

If in doubt about anything to do with XML Files and their contents, etc, please see the existing XML Files in the `/DORCoreMin/CORE/XMLFiles`, `/DORCoreMin/DORBASE/XMLFiles`, or `/DORCoreMin/UDR/XMLFiles` Folders/Directories for examples.

## `XML` File Standards

1. All XML Files SHALL be stored in the appropriate `DORCoreMin/<Feature>/XMLFiles` Folder/Directory.
2. All XML Files must follow the *XML File Naming Standards* as outlined in the Project&rsquo;s [Naming Standards](Naming_Standards.md) Document.
3. All XML Files MUST have the appropriate [Boilerplate Statement](../Support_Files/Boilerplate_Statements.md) included within them. When doing so, the [xml\_file\_template.xml](../Support_Files/xml_file_template.xml) File (located in the Project&rsquo;s `Support_Files` Folder/Directory) MAY be copied and used.
4. Each *Feature* SHALL have the following XML File created for them in the `DORCoreMin/<Feature>/XMLFiles/` Folder/Directory:
	1. x\<Feature>Files.xml
5. Each `x<Feature>Files.xml` File SHALL have an appropriate `<includefile />` tag added to the `DORCoreMin/base.xml` File.
6. Each *Feature* MAY have the following XML Files created for them in the `DORCoreMin/<Feature>/XMLFiles/` Folder/Directory, if there are any relevant XML Objects included with the *Feature*:
	1. x\<Feature>Fonts.xml
	2. x\<Feature>Frames.xml
	3. x\<Feature>Icons.xml
	4. x\<Feature>Panels.xml
	5. x\<Feature>Strings.xml
	6. x\<Feature>WindowClasses.xml
7. Each of the XML Files listed in (4) and (6) SHALL have the appropriate comment lines included, unless the file does not contain any of the relevant XML Objects:
	1. x\<Feature>Files.xml:
		1. `<!-- XML Files -->`
		2. `<!-- Lua Script Files -->`
	2. x\<Feature>Fonts.xml:
		1. `<!-- Overlay Fonts -->`
		2. `<!-- Non-Overlay Fonts -->`
	3. x\<Feature>Frames.xml
		1. `<!-- Overlay Frames -->`
		2. `<!-- Non-Overlay Frames -->`
	4. x\<Feature>Icons.xml
		1. `<!-- Overlay Buttons and Icons -->`
		2. `<!-- Non-Overlay Buttons and Icons -->`
	5. x\<Feature>Panels.xml
		1. `<!-- Overlay Panels -->`
		2. `<!-- Non-Overlay Panels -->`
	6. x\<Feature>Strings.xml
		1. `<!-- Overlay Strings -->`
		2. `<!-- Non-Overlay Strings -->`
	7. x\<Feature>Templates.xml
		1. `<!-- Overlay Templates -->`
		2. `<!-- Buttons -->`
		3. `<!-- Checkbox Controls -->`
		4. `<!-- Checkbox Fields -->`
		5. `<!-- Comboboxes -->`
		6. `<!-- Die Fields -->`
		7. `<!-- Formatted Text Fields -->`
		8. `<!-- Generic Controls -->`
		9. `<!-- Number Controls -->`
		10. `<!-- Number Fields -->`
		11. `<!-- Scrollbars -->`
		12. `<!-- String Controls -->`
		13. `<!-- String Fields -->`
		14. `<!-- Subwindows -->`
		15. `<!-- Windowlists -->`
		16. `<!-- Window Reference Field -->`
	8. x\<Feature>WindowClasses.xml
		1. `<!-- Overlay WindowClasses -->`
		2. `<!-- Non-Overlay WindowClasses -->`
8. The `x<Feature>WindowClasses.xml` File MAY have a more &lsquo;descriptive&rsquo; name than as in (6-6). If so, this XML File MUST be named such that the &lsquo;descriptive&rsquo; part of the name is placed between the `x<Feature>` and the `Windowclasess.xml` parts of the file name.
9. The `x<Feature>WindowClasses.xml` File MAY be broken up into a two or more &ldquo;functional areas&rdquo;. If so, each resulting file MUST be named as in (8).
10. Other XML Files MAY (and probably will) be required. Such files SHALL:
	1. Be named (as per the Project&rsquo;s [Naming Standards](Naming_Standards.md)) logically.
	2. Contain logically grouped XML Objects.
	3. Contain *Comments* as per and similar to (7).
11. Each XML File (not including the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Files.xml` File) SHALL have an appropriate `<includefile />` tag added to the appropriate `/DORCoreMin/<Feature>/XMLFiles/x<Feature>Files.xml` File.

## `XML` Coding Standards

1. Proper indentation SHALL be used, with *4-Character* `TAB` characters being used.
2. All HTML Entity `name` attributes SHALL:
	1. Use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. Be a descriptive name of what the HTML Entity&rsquo;s purpose is, using only alphanumeric characters [`0-9`,`A-Z`,`a-z`].

### Buttons

#### Button References

1. If the Button Reference is an &ldquo;Overlay Button Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseIcons.xml` File.
		2. After the text `<!-- Overlay Buttons and Icons -->` and before the text `<!-- Non-Overlay Buttons and Icons -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Icons.xml` File.
		2. After the text `<!-- Overlay Buttons and Icons -->` and before the text `<!-- Non-Overlay Buttons and Icons -->`.
	3. In alphabetical order.
2. If the Button Reference is not an &ldquo;Overlay Button Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseIcons.xml` File.
		2. After the text `<!-- Non-Overlay Buttons and Icons -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Icons.xml` File.
		2. After the text `<!-- Non-Overlay Buttons and Icons -->`.
	3. In alphabetical order.
3. Unless &ldquo;overlaying&rdquo; an existing Button (Icon) Reference the name of the Button Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the text `iBtn`.
	3. SHALL be followed by a descriptive name of what the Button&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.
	
#### Button Tags

1. All Buttons SHOULD be defined as a &ldquo;Button Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<button>` tags SHOULD have a `name.
3. All `<button>` tag `name` attributes SHALL start with the text `bc`.

### Checkboxes

1. All Checkboxes SHOULD be defined as a &ldquo;Checkbox Control Template&rdquo; or a &ldquo;Checkbox Field Template&rdquo; unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<buttonc_checkbox>` tags and `<button_checkbox>` tags SHOULD have a `name` attribute.
3. All `<buttonc_checkbox>` tag `name` attributes SHALL start with the text `cbc`.
4. All `<button_checkbox>` tag `name` attributes SHALL start with the character `cb`.

### Comboboxes

1. All Comboboxes SHOULD be defined as a &ldquo;Combobox Template&rdquo; unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<combobox>` tags SHOULD have a `name` attribute.
3. All `<combobox>` tag `name` attributes SHALL start with the character `s`.

### Dice

1. All Die SHOULD be defined as a &ldquo;Die Template&rdquo; unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<diefield>` tags SHOULD have a `name` attribute.
3. All `<diefield>` tag `name` attributes SHALL start with the character `d`.

### File References

See *Scripts* and *XML File References*, below.

### Fonts

1. If the Font Reference is an &ldquo;Overlay Font Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseFonts.xml` File.
		2. After the text `<!-- Overlay Fonts -->` and before the text `<!-- Non-Overlay Fonts -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Fonts.xml` File.
		2. After the text `<!-- Overlay Fonts -->` and before the text `<!-- Non-Overlay Fonts -->`.
	3. Be placed in alphabetical order.
2. If the Font Reference is not an &ldquo;Overlay Font Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseFonts.xml` File.
		2. After the text `<!-- Non-Overlay Fonts -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Fonts.xml` File.
		2. After the text `<!-- Non-Overlay Fonts -->`.
	3. Be placed in alphabetical order.
3. Unless &ldquo;overlaying&rdquo; an existing Font Reference the name of the Font Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the text `fnt`.
	3. SHALL be followed by a descriptive name of what the Font&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

### Frames

#### Frame References

1. If the Frame Reference is an &ldquo;Overlay Frame Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseFrames.xml` File.
		2. After the text `<!-- Overlay Frames -->` and before the text `<!-- Non-Overlay Frames -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Frames.xml` File.
		2. After the text `<!-- Overlay Frames -->` and before the text `<!-- Non-Overlay Frames -->`.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each Frame Reference.
2. If the Frame Reference is not an &ldquo;Overlay Frame Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseFrames.xml` File.
		2. After the text `<!-- Non-Overlay Frames -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Frames.xml` File.
		2. After the text `<!-- Non-Overlay Frames -->`.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each Frame Reference.
3. Unless &ldquo;overlaying&rdquo; an existing Frame Reference the name of the Frame Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the text `frm`.
	3. SHALL be followed by a descriptive name of what the Frame&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

#### Frame Tags

1. All Frames SHOULD be defined as a &ldquo;Frame Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<framedef>` tags SHOULD have a `name.
3. All `<framedef>` tag `name` attributes SHALL start with the text `frm`.

### Generic Control Tags

1. All Generic Control SHOULD be defined as a &ldquo;Generic Control Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<genericcontrol>` tags SHOULD have a `name`.
3. All `<genericcontrol>` tag `name` attributes SHALL start with the text `gc`.


### Icons

1. If the Icon Reference is an &ldquo;Overlay Icon Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseIcons.xml` File.
		2. After the text `<!-- Overlay Buttons and Icons -->` and before the text `<!-- Non-Overlay Buttons and Icons -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Icons.xml` File.
		2. After the text `<!-- Overlay Buttons and Icons -->` and before the text `<!-- Non-Overlay Buttons and Icons -->`.
	3. Be placed in alphabetical order.
1. If the Icon Reference is not an &ldquo;Overlay Icon Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseIcons.xml` File.
		2. After the text `<!-- Non-Overlay Buttons and Icons -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Icons.xml` File.
		2. After the text `<!-- Non-Overlay Buttons and Icons -->`.
	3. Be placed in alphabetical order.
3. Unless &ldquo;overlaying&rdquo; an existing Icon Reference the name of the Icon Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `i`.
	3. SHALL be followed by a descriptive name of what the Icon&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

### Images

1. If the Image Reference is an &ldquo;Overlay Image Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseImages.xml` File.
		2. After the text `<!-- Overlay Images -->` and before the text `<!-- Non-Overlay Images -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Images.xml` File.
		2. After the text `<!-- Overlay Images -->` and before the text `<!-- Non-Overlay Images -->`.
	3. In alphabetical order.
2. If the Image Reference is not an &ldquo;Overlay Image Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseImages.xml` File.
		2. After the text `<!-- Non-Overlay Images -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Images.xml` File.
		2. After the text `<!-- Non-Overlay Images -->`.
	3. In alphabetical order.
3. Unless &ldquo;overlaying&rdquo; an existing Image Reference the name of the Image Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the text `img`.
	3. SHALL be followed by a descriptive name of what the Image&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

#### Image Tags

Images are &ldquo;Generic Controls&rdquo; and so have a `<genericcontrol>` Tag.

See *Geneic Controls* above.

### Lua File References

See *Scripts->File Scripts* below.

### Numbers

1. All Numbers SHOULD be defined as either &ldquo;Number Control Template&rdquo; or a &ldquo;Number Field Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<numbercontrol>` tags and `<numberfield>` tags SHOULD have a `name`.
3. All `<numbercontrol>` tag `name` attributes SHALL start with the text `nc`.
4. All `<numberfield>` tag `name` attributes SHALL start with the text `n`.

### Panels

1. If the Panel Reference is an &ldquo;Overlay Panel Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBasePanels.xml` File.
		2. After the text `<!-- Overlay Panels -->` and before the text `<!-- Non-Overlay Panels -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Panels.xml` File.
		2. After the text `<!-- Overlay Panels -->` and before the text `<!-- Non-Overlay Panels -->`.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each Panel Reference.
2. If the Panel Reference is not an &ldquo;Overlay Panel Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBasePanels.xml` File.
		2. After the text `<!-- Non-Overlay Panels -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Panels.xml` File.
		2. After the text `<!-- Non-Overlay Panels -->`.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each Panel Reference.
3. Unless &ldquo;overlaying&rdquo; an existing Panel Reference the name of the Panel Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `p`.
	3. SHALL be followed by a descriptive name of what the Panel&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

### Scripts

#### File Scripts

See the [Lua Coding Standards](https://github.com/Dulux-Oz/FGI/tree/tree/master/Lua_Coding_Standards.md).

#### Inline Scripts

1. Inline Scripts SHOULD be used only for scripts that are 6 lines or less and contain only a single function.
2. The &ldquo;code&rdquo; of the inline script SHALL:
	1. Start on a new line immediately following the opening `<script>` tag.
	2. End on a line immediately followed by the closing `<script>` tag on its own line.

See also the [Lua Coding Standards](https://github.com/Dulux-Oz/FGI/tree/tree/master/Lua_Coding_Standards.md).

### Radiobuttons

Radiobuttons are Checkboxes.

See *Checkboxes* for details.

### Scrollbars

1. All Scrollbars SHOULD be defined as a &ldquo;Scrollbar Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<scrollbar>` tagss SHOULD have a `name`.
3. All `<scrollbar>` tag `name` attributes SHALL start with the text `sb`.

### Strings

#### String References

1. If the String Reference is an &ldquo;Overlay String Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseStrings.xml` File.
		2. After the text `<!-- Overlay Strings -->` and before the text `<!-- Non-Overlay Strings -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Strings.xml` File.
		2. After the text `<!-- Overlay Strings -->` and before the text `<!-- Non-Overlay Strings -->`.
	3. Be placed in alphabetical order.
2. If the String Reference is not an &ldquo;Overlay String Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseStrings.xml` File.
		2. After the text `<!-- Non-Overlay Strings -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Strings.xml` File.
		2. After the text `<!-- Non-Overlay Strings -->`.
	3. Be placed in alphabetical order.
3. Unless &ldquo;overlaying&rdquo; an existing String Reference the name of the Image Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `s`.
	3. SHALL be followed by a descriptive name of what the Panel&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. SHALL be followed by the text `String`.
	5. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

#### String Tags

1. All Strings (Text) SHOULD be defined as a &ldquo;Formatted Text Field Template&rdquo;, a &ldquo;String Control Template&rdquo;, or a &ldquo;String Field Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<stringcontrol>` tags and all `<stringfield>` tags SHOULD have a `name` attribute.
3. All `<stringcontrol>` tag and `<stringfield>` tag `name` attributes SHALL start with the character `s`.
4. Some `<stringcontrol>` tags and `<stringfield>` tags MAY start with other characters, eg Scientific Numbers start with the text `sn`.

### Subwindows

1. All Subwindows SHOULD be defined as a &ldquo;Subwindow Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<subwindow>` tags SHOULD have a `name` attribute.
3. All `<subwindow>` tag `name` attributes SHALL start with the character `sw`.

### Templates

1. If the Template is an &ldquo;Overlay Template Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseTemplates.xml` File.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Templates.xml` File.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each Template.
2. If the Panel Reference is not an &ldquo;Overlay Panel Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORBaseTemplates.xml` File.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>Templates.xml` File.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each Panel Reference.
3. Unless &ldquo;overlaying&rdquo; an existing Panel Reference the name of the Template:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the lower-case letter `t`.
	3. SHALL be followed by a descriptive name of what the Template&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

#### Buttons

Button Templates SHALL be placed after the text `<!-- Buttons -->` and before the text `<!-- Checkbox Controls -->`.

#### Checkbox Controls

Checkbox Control Templates SHALL be placed after the text `<!-- Checkbox Controls -->` and before the text `<!-- Checkbox Fields -->`.

#### Checkbox Fields

Checkbox Fields Templates SHALL be placed after the text `<!-- Checkbox Fields -->` and before the text `<!-- Comboboxes -->`.

#### Comboboxes

Comboboxes Templates SHALL be placed after the text `<!-- Comboboxes -->` and before the text `<!-- Die Fields -->`.

#### Die Fields

Die Field Templates SHALL be placed after the text `<!-- Die Fields -->` and before the text `<!-- Formatted Text Fields -->`.

#### Formatted Text Fields

Formatted Text Field Templates SHALL be placed after the text `<!-- Formatted Text Fields -->` and before the text `<!-- Generic Controls -->`.

#### Generic Controls

Generic Control Templates SHALL be placed after the text `<!-- Generic Controls -->` and before the text `<!-- Number Controls -->`.

#### Number Controls

Number Control Templates SHALL be placed after the text `<!-- Number Controls -->` and before the text `<!-- Number Fields -->`.

#### Number Fields

Number Field Templates SHALL be placed after the text `<!-- Number Fields -->` and before the text `<!-- Scrollbars -->`.

#### Overlay Templates

Overlay Templates SHALL be placed after the text `<!-- Overlay Templates -->` and before the text `<!-- Buttons -->`.

#### Scrollbars

Scrollbar Templates SHALL be placed after the text `<!-- Scrollbars -->` and before the text `<!-- String Controls -->`.

#### String Controls

String Control Templates SHALL be placed after the text `<!-- String Controls -->` and before the text `<!-- String Fields -->`.

#### String Fields

String Field Templates SHALL be placed after the text `<!-- String Fields -->` and before the text `<!-- Subwindows -->`.

#### Subwindows

Subwindow Templates SHALL be placed after the text `<!-- Subwindows -->` and before the text `<!-- Windowlists -->`.

#### Windowlists

Windowlist Templates SHALL be placed after the text `<!-- Windowlists -->` and before the text `<!-- Window Reference Fields -->`.

#### Window References

Window Reference Templates SHALL be placed after the text `<!-- Window References -->.

### Windowlists

1. All Windowlists SHOULD be defined as a &ldquo;Windowlist Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<windowlist>` tags SHOULD have a `name` attribute.
3. All `<windowlist>` tag `name` attributes SHALL start with the character `wl`.

### Window References

1. All Window References (Links) SHOULD be defined as a &ldquo;Window Reference Template&rdquo;, unless used as a &ldquo;one-off&rdquo; or &ldquo;standard&rdquo; HTML Entity.
2. All `<link>` tags SHOULD have a `name` attribute.
3. All `<link>` tag `name` attributes SHALL start with the text `ref`.

### WindowClasses

1. If the WindowClass Reference is an &ldquo;Overlay WindowClass Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORWindowClasses.xml` File.
		2. After the text `<!-- Overlay WindowClasses -->` and before the text `<!-- Non-Overlay WindowClasses -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>WindowClasses.xml` File, or in a *Windowclss.xml* File variation as outlined in `XML File Standards` (7) and (8).
		2. After the text `<!-- Overlay WindowClasses -->` and before the text `<!-- Non-Overlay WindowClasses -->`.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each WindowClass Reference.
2. If the WindowClass Reference is not an &ldquo;Overlay WindowClass Reference&rdquo;, it SHALL:
	1. If being used in more that one *Feature*, be placed:
		1. In the `DORCoreMin/DORBase/XMLFiles/xDORWindowClasses.xml` File.
		2. After the text `<!-- Non-Overlay WindowClasses -->`.
	2. If being used in only one *Feature*, be placed:
		1. In the `DORCoreMin/<Feature>/XMLFiles/x<Feature>WindowClasses.xml` File, or in a *Windowclss.xml* File variation as outlined in `XML File Standards` (7) and (8).
		2. After the text `<!-- Non-Overlay WindowClasses -->`.
	3. Be placed in alphabetical order.
	4. Be placed with a Blank Line separating each WindowClass Reference.
3. Unless &ldquo;overlaying&rdquo; an existing WindowClass Reference the name of the WindowClass Reference:
	1. MUST use a [Dromedary (Camel) Case](https://en.wikipedia.org/wiki/Camel_case) format.
	2. MUST start with the text `wc`.
	3. SHALL be followed by a descriptive name of what the WindowClass&rsquo;s purpose is, using only alphanumeric characters [`0-9`, `A-Z`, `a-z`].
	4. Abbreviations, in whole or in part, MAY be used, provided that they are clearly understandable.

### XML File References

1. All `<includefile />` tags SHALL be placed:
	1. After the text `<!-- XML Files -->` and before the text `<!-- Lua Files -->` in the relevant `DORCoreMin/base.xml` or `DORCoreMin/<Feature>/XMLFiles/x<Feature>Files.xml` File.
	1. Be placed on a separate line.
	3. In alphabetical order.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
