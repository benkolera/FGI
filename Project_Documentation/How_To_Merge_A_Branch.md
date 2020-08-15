# How To Merge A Branch

---

Version 1.0.0

Merging takes the commits on two different branches and combines them. The result would be as if all changes were made in the same place. Luckily, files are automatically merged, unless their are two conflicting set of changes, i.e. commits on the different branches updating the same line in different ways.

Drag and drop one branch onto of another to initiate a merge, or just right click the branch you would like to merge in and select merge from the menu.

If you get confused or frustrated at any time, you can always abort the merge and everything will be shiny again. If you are receiving a merge conflict, GitKraken will display each of the conflicting files on the right and click on each to launch in the merge tool.

![GitKraken Merge Conflict](https://support.gitkraken.com/img/documentation/repositories/merge-conflict.png)

The current branch is on the left, and the branch that you&rsquo;re merging in is shown on the right. For each conflict, you check the box next to the conflicting section to add to the output at the bottom. You can also mouse over the line number and click the green plus that appears to select or deselect specific lines. You can view the output file at the bottom, and you can also edit directly in this window if you need to. Clicking the up and down arrows will move you to the next conflict.

![GitKraken Merge Tool](https://support.gitkraken.com/img/documentation/repositories/merge-tool.gif)

After the conflict is resolved, just save the output, and commit the changes.

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
