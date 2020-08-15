# A Coding And Git Glossary

---

Version 1.0.0

Sometimes working with Git and GitKraken (or any version control system) can seem like learning a new language. We&rsquo;ve tried to put the most commonly used terms together here in the glossary to help you out.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

**Branch**

A copy of the Project, under version control but isolated so that changes made to the branch don&rsquo;t affect other branches of the Project, and vice versa, except when changes are deliberately &ldquo;merged&rdquo; from one branch to another (see below). Branches are also known as &ldquo;lines of development&rdquo;.

Branches offer a way to keep different lines of development from interfering with each other. For example, a branch can be used for experimental development that would be too destabilising for the `main` or `develop` branches. Or conversely, a branch can be used as a place to stabilise a new release. During the release process, regular development would continue uninterrupted in the individual `feature_X` and `develop` branches of the repository; meanwhile, on the `release vX.Y.Z-rc.A` branch, no changes are allowed except those approved by the Release Manager(s). This way, making a release needn&rsquo;t interfere with ongoing development work.

**Checkout**

When used in discussion, &ldquo;checkout&rdquo; usually means something like &ldquo;clone&rdquo; (see below). Checkout may also mean the process of obtaining working files from a repository.

**Clone (see also Checkout)**

To obtain one&rsquo;s own development repository by making a copy of the Project&rsquo;s official repository.

**Commit**

To make a change to the Project; more formally, to store a change in the version control database in such a way that it can be incorporated into future releases of the Project. *Commit* can be used as a verb or a noun. For example: &ldquo;I just committed a fix for the server crash bug people have been reporting on Mac OS X. Jay, could you please review the commit and check that I&rsquo;m not misusing the allocator there?&rdquo;

**Commit Message or Log Message**

A bit of commentary attached to each commit, describing the nature and purpose of the commit (both terms are used about equally often). Commit messages are among the most important documents in any project: they are the bridge between the detailed, highly technical meaning of each individual code changes and the more user-visible world of bugfixes, features, and project progress.

Our Project uses a specific format for its Commit Messages, as described in the [Commit Message Template](https://github.com/Dulux-Oz/FGI/master/Support_Files/Commit_Message_Template.md) Document.

**Conflict**

What happens when two people try to make different changes to the same place in the code or text of of document. All version control systems automatically detect conflicts, and notify at least one of the humans involved that their changes conflict with someone else&rsquo;s. It is then up to that human to resolve the conflict, and to communicate that resolution to the version control system.

**Diff**

A textual representation of a change. A diff shows which lines of a file were changed and how, plus a few lines of surrounding context on either side. A Contributor who is already familiar with some file can usually read a diff against that file and understand what the change did, and often even spot bugs.

**Executable Code**

A text listing of commands that have been compiled or interpreted into a computer program that actually runs.

See also Lua Function, Lua Script, Source Code, and XML Object.

**FG Ruleset**

The collection of XML, LUA, Font, Image, Button, Icon, and other files that form the &ldquo;program&rdquo; that contains the &ldquo;game mechanics&rdquo; for the Role-Playing Games (RPGs) we play via the FG Virtual Table-Top Software.

**Function**

See Lua Function.

**GitHub Flavoured Markdown (GFM)**

GitHub Flavoured Markdown, often shortened as GFM, is the dialect of Markdown that is currently supported for user content on GitHub.com and GitHub Enterprise. It is a strict superset of CommonMark.

**Graphical User Interface (GUI)**

Pronounced &ldquo;gooey&rdquo;. It is a a way for a human to interact with a computer and a computer program that includes graphical elements, such as windows, icons, and buttons.

**Lua Function**

A piece of Source code consisting of a name and a series of commands that when turned into Executable Code perform a (typically) single, definable action.

See also Executable Code and Source Code.

**LUA Script**

One or more Lua Functions in a single Lua File.

Also a single Lua Function contained within an XML Element.

See also Lua Function and XML Element.

**Markdown (MD)**

Markdown is a plain text format for writing structured documents, based on conventions for indicating formatting in email and usenet posts. It was developed by John Gruber (with help from Aaron Swartz) and released in 2004. In the next decade, dozens of implementations were developed in many languages. Some extended the original Markdown syntax with conventions for footnotes, tables, and other document elements. Some allowed Markdown documents to be rendered in formats other than HTML. Websites like Reddit, StackOverflow, and GitHub had millions of people using Markdown. And Markdown started to be used beyond the web, to author books, articles, slide shows, letters, and lecture notes.

What distinguishes Markdown from many other lightweight markup syntaxes, which are often easier to write, is its readability.

**Merge or Port**

To move a change from one branch to another. This includes merging from the main branch to some other branch, or vice versa. In fact, those are the most common kinds of merges; it is less common to port a change between two non-main or development branches.

*Merge* has a second, related meaning: it is what Git (and Gitkraken) does when it sees that two Contributors have changed the same file but in non-overlapping ways. Since the two changes do not interfere with each other, when one of the Contributors updates their copy of the file (already containing their own changes), the other person&rsquo;s changes will be automatically merged in. This is very common, especially on projects where multiple people are hacking on the same code. When two different changes do overlap, the result is a *conflict*; see above.

**Object**

See XML Object.

**Overlaying**

The act of naming an XML Object or Lua Function the same as an existing XML Object or Lua Function in a parent FG Ruleset, respectively, so as to replace the details of the XML Object or Lua Function and thus change its functionality (ie what is does and/or how it looks).

See also Lua Function and XML Object.

**Pull (or &ldquo;Update&rdquo;)**

To pull others&rsquo; changes (commits) into your copy of the Project. When pulling changes from the Project&rsquo;s official `develop` branch (see branch), people often say &ldquo;update&rdquo; instead of &ldquo;pull&rdquo;, for example: &ldquo;Hey, I noticed the indexing code is always dropping the last byte. Is this a new bug?&rdquo; &ldquo;Yes, but it was fixed last week — try updating and it should go away.&rdquo;

See also &ldquo;Pull Request&rdquo;.

**Pull Request**

To let others know that there is an update avaliable to be &ldquo;pulled&rdquo; from your server-side repository for inclusion into a given repository; typically the offical repository.

Also used to ask for help to pull something from you server-side repository so that others can have a &ldquo;look-see&rdquo;.


**Push**

To publish a commit to a publicly online repository (typically your own public server-side repository), from which others can incorporate it into their copy of the Project&rsquo;s code and manuscripts. When one says one has pushed a commit, the destination repository is usually implied. Often it is your personal online copy of the Project&rsquo;s `develop` repository, but not always.

**Repository**

A database in which changes are stored and from which they are published.

**Revert or Reversion**

To undo an already-committed change to the Project. The undoing itself is a versioned event, and is usually done by asking the version control system to reverse the change(s) in questions, rather than by manually making the edits and committing them.

**Revision, Change, Changeset, or (again) Commit**

A *revision* is a precisely specified incarnation of the Project at a point in time, or of a particular file or directory in the Project.

When one talks about a file or collection of files without specifying a particular revision, it is generally assumed that one means the most recent revision(s) available.

**Source Code**

A text listing of commands to be compiled or interpreted into a computer program that actually runs.

See Executable Code.

**Tag or Snapshot**

A label for a particular state of the Project at a point in time. Tags are generally used to mark interesting snapshots of the Project. For example, a tag is usually made for each public release, so that one can obtain, directly from the version control system, the exact set of files/revisions comprising that release. Tag names are often things like `v3.4.2`, `Delivery_20130630`, etc.

Also an XML Tag.

See also XML Tag.

**Working Copy or Working Files**

A Contributor&rsquo;s private directory tree containing the Project&rsquo;s source files in a form that allows the developer to edit them. A working copy also contains some version control metadata saying what repository it comes from, what branch it represents, and a few other things. Each developer has their own working copy (typically on their PC), from which they edit, test, commit, pull, push, etc.

**XML Attribute**

One or more XML Attributes may form part of an XML (Opening) Tag and provide further information, etc, about that XML Element. XML Attributes are optional.

See also XML Tag.


**XML Element**

An XML Element consists of an Opening XML Tag, its Attributes, any Content (Value), and a Closing Tag.

See also XL Attribute, XML Tag, and XML Value.

**XML Object / Node**

In terms of our Project and how to &ldquo;code&rdquo; for FG, an XML Object is piece of Source Code consisting of an XML Element that defines &ldquo;something&rdquo; eg typically a GUI element such as a window, a button, or an entrybox.

XML objects can contain (be made up of) other XML Objects, and likewise an XML Object can be contained within other XML Objects.

See also Source Code and XML Element.

**XML Tag**

An XML Tag is &mdash;  either an Opening Tag or Closing Tag &mdash; is used to mark the start or end of an XML Element.

See also XML Element and XML Tag.

**XML Value**

An XML Value is the relevant information (data) that falls between the Starting and Closing XML Tags of an XML Element. The XML Value is optional.

See also XML Element and XML Tag.

---

## Attribution

![Creative Commons License](https://i.creativecommons.org/l/by-sa/2.5/au/88x31.png "Creative Commons License")

Some material paraphrased from and originally published by John MacFarlane on GitHub at (https://github.github.com/gfm/) and released under a Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
