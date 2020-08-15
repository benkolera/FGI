# GitKraken Basics

---

Version 1.0.0

---

From left to right, GitKraken displays a left reference panel, centre graph, and right staging panel when working with a repository.

![GitKraken Display](https://support.gitkraken.com/img/documentation/getting-started/interface-slim.png)

## Toolbar

The toolbar available at the top of app houses some of the most commonly used actions when working with local and remote repositories.

![Undo Icon](https://support.gitkraken.com/img/documentation/icons/gk-undo-icon.svg) **Undo**: Many actions performed in GitKraken can be undone if you didn&rsquo;t mean to do them. If an action is undoable, the Undo button will be a solid colour.

![Redo Icon](https://support.gitkraken.com/img/documentation/icons/gk-redo-icon.svg) **Redo**: What if you undid something, only to realise that you didn&rsquo;t want to undo it at all? GitKraken also has a Redo button so you can undo your undos.

![Pull Icon](https://support.gitkraken.com/img/documentation/icons/gk-pull-icon.svg) **Pull**: Pull changes from your remote repo(s) with this button. See the button next to the icon? Click that to customise the type of pull you want to perform:

- Fetch All
- Pull (fast-forward if possible)
- Pull (fast-forward only): equivalent of `git fetch git merge --ff-only` in the CLI
- Pull (rebase): equivalent of `git fetch git rebase` in the CLI

*Tip:* If you find yourself repeatedly performing the same push actions, you can set the default push type by clicking the circle icon to the left of your desired push type. The current default selection will appear as a green circle icon.

![Push Icon](https://support.gitkraken.com/img/documentation/icons/gk-push-icon.svg) **Push**: Push changes to the remote repo as set in your `origin`.

![Branch Icon](https://support.gitkraken.com/img/documentation/icons/gk-branch-icon.svg) **Branch**: Create a branch on your current local repo.

![Stash Icon](https://support.gitkraken.com/img/documentation/icons/gk-stash-icon.svg) **Stash**: Stash your work-in-process (// WIP) changes.

![Pop Stash Icon](https://support.gitkraken.com/img/documentation/icons/gk-pop-stash-icon.svg) **Pop Stash**: Ready to restore your // WIP? Pop that stash and carry on as you were.

![Boards](https://support.gitkraken.com/img/documentation/icons/gk-pop-stash-icon.svg) **Boards**: Go to the GK-Boards for the Project/Repo to track Issues, To Do Lists, Pull Requests, etc.

![Timelines](https://support.gitkraken.com/img/documentation/icons/gk-pop-stash-icon.svg) **Timelines**: Go to the GK Timelines for the Project.

*Note:* You can toggle toolbar labels by navigating to `Preferences => UI Preferences` and toggling the `Show toolbar icon labels` checkbox.

## Left Reference Panel

Referred to as the left &ldquo;ref&rdquo; panel, GitKraken shows the properties below specific to your repository. The panel and each pane can be collapsed or expanded as needed.

![GitFlow Icon](https://support.gitkraken.com/img/documentation/icons/gk-local-icon.svg) **GitFlow**: References to local branches when using the GitFlow Workflow (independantly or as part of a larger FGI-Workflow &mdash; as this Project does) — pointers to specific commits allowing work to be separated.

![Local Icon](https://support.gitkraken.com/img/documentation/icons/gk-local-icon.svg) **Local**: References to local branches — pointers to specific commits allowing work to be separated.

![Remote Icon](https://support.gitkraken.com/img/documentation/icons/gk-remote-icon.svg) **Remote**: References to remote branches.

![PR Icon](https://support.gitkraken.com/img/documentation/icons/gk-pull-request-icon.svg) **Pull Requests**: Active requests for merging one branch into another. With GitHub new PRs can be created directly from GitKraken. Any active requests will also be shown here.

![Tags Icon](https://support.gitkraken.com/img/documentation/icons/gk-tag-icon.svg) **Tags**: Kind-of like freeze tag, these represent active pointers to commits but never move.

![Stashes Icon](https://support.gitkraken.com/img/documentation/icons/gk-stash-icon.svg) **Stashes**: Stored file changes in the working copy.

![Submodules Icon](https://support.gitkraken.com/img/documentation/icons/gk-submodules-icon.svg) **Submodules**: A Git repository in a subdirectory of the current repository.

## Commit Panel (Right Staging Panel)

![GitKraken Right Panel](https://support.gitkraken.com/img/documentation/getting-started/right-stage.png)

Next we have the right staging panel. This is where files and their changes from your working directory are added to the staging area in preparation for and execution of a commit.

The three parts in order of operations on the staging panel are:

1. Unstaged Files — Watched files in your working directory that have changed since the last commit. Files can be new, renamed, deleted, or modified in some way to appear here.
2. Staged Files — Files manually added to the index that are ready to commit. Individual lines or hunks of code/documentation or all of the changes can be added.
3. Commit Message — recording staged changes to the repository. Follow the [Commit Message Template]() to ensure that your Commit Messages are clear and easier to understand.
	- Summary: The brief but meaningful message supporting your commit. This text will appear in the graph. Be specific for users including yourself to know what happened!
	- Description: The extended message to provide more details behind the changes. The more detail the better.
	- Don&rsquo;t forget to &ldquo;Signed-off-by&rdquo; your commit (as the last line of the Description):
		- Example: Signed-off-by: Matthew J Black &mdash; <matthew@peregrineit.net> 

Also, here is a quick colour guide for the file symbols:

![GitKraken Staging Icons](https://support.gitkraken.com/img/documentation/getting-started/symbol-guide.png)

This panel can also be fixed on the bottom of the window. Just click the &ldquo;down arrow&rdquo; icon in the upper right corner of the Commit Panel.

## The Graph

The graph in GitKraken is the core of your repo. It&rsquo;s where the commits of your hard work post-staging can be seen, along with how the project develops over time.

![GitKraken Graph](https://support.gitkraken.com/img/documentation/getting-started/graph.png)

Each row of the graph represents one commit, and the top is always for the latest changes. An interactive //WIP (Work-In-Progress) node will show if the working directory has changed since the last commit.

Branches on the left side of the graph are pointers to specific commits, and each vertical column represents a branch currently available on the repository. Columns can intersect through merge commits as shown in the graph legend. As also shown, multiple branches can be at the same place of a single commit and can be both local and remote.

![GitKraken Graph Legend](https://support.gitkraken.com/img/documentation/getting-started/graph-elements.png)

For a given vertical track, you can read from bottom to top, and right to left to see how changes are introduced into a focused branch.

---
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Attribution

![Creative Commons License](https://i.creativecommons.org/l/by-sa/2.5/au/88x31.png "Creative Commons License")

Material paraphrased from and originally published by Atlassian (https://www.atlassian.com/git/tutorials) and released under a [Creative Commons Attribution 2.5 Australia (CC BY 2.5 AU) License](http://creativecommons.org/licenses/by/2.5/au/).

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
