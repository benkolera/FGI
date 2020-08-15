# Maintainers

---

Version 1.0.0

## Defining &ldquo;Maintainer&rdquo; And &ldquo;Commit Access&rdquo;

For the purposes of this document, the word *aintainer* means one of the official maintainers of the project&rsquo;s software code and/or manuscript. A maintainer is someone who has commit access: the right to make changes to the copy of the code and/or manuscript that will be used for the project&rsquo;s next official release.

This precise definition is important because, after all, anyone can set up a repository containing a copy of the project&rsquo;s code and manuscripts and allow themselves to commit to that repository; indeed, doing so is a standard development procedure within the Project&rsquo;s version control systems (GitHub). But what really matters for the project&rsquo;s purposes is who has the ability to put changes into the &ldquo;Offical&rdquo; or master copy — that is, the central shared copy into which contributors&rsquo; changes are merged and from which releases are made.

Because in older, pre-Git, centralised version control systems, there was normally only one repository anyway, the term &ldquo;commit access&rdquo; corresponded closely to who was actually using the &ldquo;commit&rdquo; command to put changes into the group&rsquo;s shared repository. These days it corresponds to those who run the &ldquo;push&rdquo; or &ldquo;pull&rdquo; commands to put changes into that repository. It is the same idea either way: the master repository is a social concept, not a technical concept, and the mechanics of how changes get into it are not important here. Open source projects continue to use the term &ldquo;committer&rdquo; in this identifying sense, even though formally speaking the &ldquo;commit&rdquo; command is no longer where the gating happens.

In the FGI Project there are be people who are very invested, and who contribute a lot, but through means other than coding or writing the manuscript. Plenty of people provide legal help, or organise events, or manage the bug tracker, or write documentation, or do any number of other things that are highly valued in the Project. They often may have a level of influence in the community (and familiarity with the community&rsquo;s dynamics) that exceeds that of many &ldquo;committers&rdquo;. That&rsquo;s why the Project uses the term &ldquo;maintainer&rdquo;, to make sure everyone remembers that its not just the programmers and manuscript writers that are important, but that others who are &ldquo;maintainers&rdquo; are just as important, if not more so.

Maintainers are an unavoidable concession to discrimination in a system which is otherwise as non-discriminatory as possible. But &ldquo;discrimination&rdquo; is not meant as a pejorative here. The function maintainers perform is utterly necessary, and the Project could not succeed without them. Quality control requires, well, control. There are always many people who feel competent to make changes to a document or a program, and some smaller number who actually are. The Project cannot rely on people&rsquo;s own judgement; it must impose standards and grant commit access only to those who meet them.

On the other hand, having people who can commit changes directly working side-by-side with people who cannot sets up an obvious power dynamic. That dynamic must be managed so that it does not harm the project.

## Choosing Maintainers

A good basis for choosing maintainers is the Hippocratic Principle: *first, do no harm.*

The most important criterion is not technical skill or even deep familiarity with the code or the manuscripts, but rather that a person show good judgement. Judgement includes knowing what not to take on. Someone might post only small patches or updates, fixing fairly simple problems in the code or issues in the manuscript, but if they&rsquo;re patches apply cleanly, do not contain bugs or spelling or grammatical issues, and are mostly in accord with the Project&rsquo;s commit message and writing and coding conventions, and there are enough patches to show a clear pattern, then an existing Maintainer should propose them for commit access. If at least three people say yes (once the project has moved to the [Consensus-Based Democracy Model]() of governance), and no one objects, then the offer is made. True, there might be no evidence yet that the person is able to solve complex problems in all areas of the codebase, but that is irrelevant: the person has made it clear that they are capable of judging their own abilities, and that is the important thing.

When a new maintainer proposal does provoke a discussion, it is usually not about technical ability, but rather about the person&rsquo;s behaviour in the project&rsquo;s discussion forums. Sometimes someone shows technical skill and an ability to meet the project&rsquo;s formal code and manuscript contribution standards, yet is also consistently belligerent or uncooperative in public forums. That&rsquo;s a serious concern; if the person doesn&rsquo;t seem to shape up over time, even in response to hints, then don&rsquo;t add them as a maintainer no matter how skilled they are. In an open source project, social skills, or the ability to &ldquo;play well in the sandbox&rdquo;, are as important as raw technical ability. Because everything is under version control, the penalty for adding a maintainer we shouldn&rsquo;t have added is not so much the problems it could cause in the code or the manuscripts (review would spot those quickly anyway), but that it might eventually force the project to revoke the person&rsquo;s commit access &mdash; an action that is never pleasant and can sometimes fragment the whole community.

Be careful that maintainership doesn&rsquo;t start to turn into a matter of membership in an exclusive club. The question to keep in everyone&rsquo;s mind should be &ldquo;What will bring the best results for the project?&rdquo; not &ldquo;Will we devalue the social status associated with maintainership by admitting this person?&rdquo; The point of commit access is not to reinforce people&rsquo;s self-worth, it&rsquo;s to allow good changes to enter the code and manuscript with a minimum of fuss. If we have 100 maintainers, 12 of whom make large changes on a regular basis, and the other 88 of whom just fix typos and small bugs a few times a year, that&rsquo;s still better than having only the 12.

## Adding New Maintainers

The [voting system](https://github.com/FGI/tree/master/Project_Documentation/Voting.md) itself is used to add new maintainers. Here is one of the rare instances where, unlike practically all the rest of the Project, [secrecy](https://github.com/FGI/tree/master/Project_Documentation/Secrecy.md) is appropriate. We can&rsquo;t have votes about potential new maintainers posted to a public mailing list, because the candidate&rsquo;s feelings (and reputation) could be hurt. Instead, the FGI Project has a private mailing list to which only existing maintainers can subscribe: an existing maintainer posts to this list, proposing that someone be invited to join. The other maintainers speak their minds freely, knowing the discussion is private. Often there will be no disagreement, and therefore no vote necessary. After waiting a few days to make sure every maintainer has had a chance to respond, the proposer mails the candidate and makes the offer. If there is disagreement, discussion ensues as for any other question, possibly resulting in a vote.

For this process to be open and frank, the mere fact that the discussion is taking place at all should be secret. If the person under consideration knew it was going on, and then were never offered maintainership, they could conclude that they had lost the vote, and would likely feel hurt. Of course, if someone explicitly asks to be considered, then there is no choice but to take up the proposal and explicitly accept or reject them. If the latter, then it will be done as politely as possible, with a clear explanation: &ldquo;We liked your patches, but haven&rsquo;t seen enough of them yet,&rdquo; or &ldquo;We appreciate all the work you did for the conference, but you haven&rsquo;t been very active in the project since then, so we don&rsquo;t feel comfortable making you a maintainer just yet. We hope that this will change over time, though.&rdquo; Remember, what is said could come as a blow, depending on the person&rsquo;s temperament or confidence level. We should try to see it from their point of view as we write the mail.

Because adding a new maintainer is more consequential than most other one-time decisions, some projects have special requirements for the vote. For example, they may require that the proposal receive at least n positive votes and no negative votes, or that a supermajority vote in favor. The exact parameters are not important; the main idea is to get the group to be careful about adding new maintainers. Similar, or even stricter, special requirements can apply to votes to remove a maintainer, though hopefully that will never be necessary.

## Revoking Maintainership

The first thing to be said about revoking maintainership access is: let&rsquo;s try not to be in that situation in the first place. Depending on whose maintainership is being revoked, and why, the discussions around such an action can be very divisive.

Even when not divisive, they will be a time-consuming distraction from productive work. However, if we must do it, the discussion needs to be had privately among the same people who would be in a position to vote for granting that person whatever flavour of maintainership they currently have. The person themseves should not be included. This contradicts our usual injunction against secrecy, but in this case it&rsquo;s necessary. First, no one would be able to speak freely otherwise. Second, if the motion fails, we don&rsquo;t necessarily want the person to know it was ever considered, because that could open up questions (&ldquo;Who was on my side? Who was against me?&rdquo;) that lead to the worst sort of factionalism. In certain rare circumstances, we as a group may want someone to know that revocation of maintainership is or was being considered, as a warning, but this openness should be a decision the group makes. No one should ever, on their own initiative, reveal information from a discussion and ballot that others assumed were secret.

Once someone&rsquo;s maintainership is revoked, that fact is unavoidably public, so let&rsquo;s try to be as tactful as we can in how it is presented to the outside world.

## Partial Maintainers

We use a two-tier model of maintainership access in the FGI Project. The first tier is &ldquo;full maintainer,&rdquo; where Contributors can commit to anywhere in the Project. The second tier is more restrictive, known as &ldquo;partial maintainer&rdquo;, where Contributors are allowed to commit to only parts of the Project, such as only the code, only one of the manuscripts, etc. Within their area those with partial commit access (partial maintainership) have full rein, but outside their area of expertise (their partial commit access / maintainership) their contributions need to be submitted the same as everyone else.

---

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.

## Attribution

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

Material paraphrased from *Producing Open Source Software* (p174) by Karl Fogal. Copyright &copy;2005-2017 Karl Fogel, under the Creative Commons Attribution-ShareAlike (4.0) International (CC BY-SA 4.0) License.

---

![Creative Commons License](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004-2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License.](https://creativecommons.org/licenses/by-sa/4.0/)

All Rights Reserved.
