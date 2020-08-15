# How To Pull From A Repository

---

Version 1.0.0

## Fetching

If pushing is how we take commits from our local repository and update our public server-side repository, *pulling* and *fetching* is how we take updates from the Project&rsquo;s official repository (or any remote repository, really) and get them into our local repository.

### Fetch All

![GitKraken Pull Options](https://support.gitkraken.com/img/documentation/repositories/pull-options.png)

Fetching gets updates from remote branches, but does not update any files in your working directory. Updates will appear in the graph, and also update any branches on the left to show how many commits you are ahead or behind.

When you&rsquo;re behind the remote repository, it means that there are commits on the remote branch which have not been incorporated into the local repository and you can *fast-forward* your local branch. Being ahead of the remote branch means that there are local commits that have not yet been pushed to the remote repository.

![GitKraken Fetch](https://support.gitkraken.com/img/documentation/repositories/fetch.png)

It is possible to be both ahead of and behind a remote, in fact it&rsquo;s quite common for more active repositories. However if you are both ahead and behind a remote, you would not be able to perform a *fast-forward* as the branches have *diverged* It is possible to adjust this by performing a *rebase* onto the remote.

GitKraken automatically fetches updates from your remote repositories every minute by default. You can change this setting if you would like in your `Preferences => General` menu.

### Fast-Forwarding

Fast forwarding moves the currently checked out commit to one that was added later, replaying all commits in between in the order which they happened.

To fast-forward your currently checked out commit, you can right click on the branch that has newer commits added to it, and select the `Fast-Forward` option from the menu.

## Pulling

Pulling will first perform a fetch and then incorporate any commits in the remote repository into the local copy. The next three options determine how the new commits are integrated with other commits currently on our branch.

In the below figure we have 2 commits made locally, and 2 that have been made on the remote repository.

![GitKraken Pull](https://support.gitkraken.com/img/documentation/repositories/ahead-behind.png)

The remote commits display on the graph because they have been fetched,
but have not been incorporated into the local repository.

### Pull (Fast-Forward If Possible)

This option will fetch any updates on the remote branch, then it will attempt to *fast-forward* the local branch. If a *fast-forward* is not possible, a *merge* will be performed. This is the default option for new GitKraken users.

![GitKraken Pull Example](https://support.gitkraken.com/img/documentation/repositories/example-pull-ff.png)

A fast-forward was not possible, so the remote branch was merged into the local branch.

### Pull (Fast-Forward Only)

This option will fetch any updates and then attempt a *fast-forward*. If a *fast-forward* is not possible, GitKraken will not make any changes to the local repository.

In the above example, a fast-forward is not possible as there are new commits added to both branches.

### Pull (Rebase)

This option will stash all commits on this branch, pull in new commits from the remote, and then will replay your commits. This has the added benefit of maintaining all commits in a single line, as opposed to creating branches which are then merged back together.

![GitKraken Rebase](https://support.gitkraken.com/img/documentation/repositories/example-pull-rebase.png)

The remote commits were pulled in, then the local commits were moved on top of them.

You should remember the golden rule of rebasing *&ldquo;Never rebase while you&rsquo;re on a public branch&rdquo;*, which is covered in the GitKraken.com blog post on this topic.

### Setting A Default Pull Option

You can set the default option that this button uses by clicking the down arrow to the right, and clicking on the circle button by each option. You can always override this default setting by clicking on the down arrow and selecting your desired option.

The equivalent Git CLI Commands are:

~~~
git fetch https://github.com/UGE-PRG/FGI.git master
git checkout master
git merge FETCH_HEAD
git fetch https://github.com/UGE-PRG/FGI.git develop
git checkout develop
git merge FETCH_HEAD
~~~

---

<<<<<<< HEAD
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
=======
If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.
>>>>>>> r0.2

## Attribution

![Creative Commons License](https://i.creativecommons.org/l/by-sa/2.5/au/88x31.png "Creative Commons License")

Material paraphrased from and originally published by Atlassian (https://www.atlassian.com/git/tutorials) and released under a [Creative Commons Attribution 2.5 Australia (CC BY 2.5 AU) License](http://creativecommons.org/licenses/by/2.5/au/).

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
