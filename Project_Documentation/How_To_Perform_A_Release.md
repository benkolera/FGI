# How To Perform A Release

Version 0.1

[To Be Completed]

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

The equivalent Git CLI Commands are:

~~~
git checkout -b release/v2.3 develop
# Prepare the release
git checkout master
git merge release/v2.3
git push
git checkout develop
git merge release/v2.3
git push
git branch -d release/v2.3
git tag -a 0.1 -m &ldquo;v2.3&rdquo; master
git push --tags
~~~

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
