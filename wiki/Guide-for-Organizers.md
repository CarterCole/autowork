# Guide for Organizers

For charities, community groups and open source projects that want work done
through an autowork queue. You do not need to program to use one day to day.
Setting one up takes about ten minutes and one person who is comfortable with
a terminal or an AI coding assistant.

## The idea in one minute

You keep a public to-do list. Each entry describes one piece of work and how
you will judge it. Volunteers anywhere point their own AI assistant at your
list. The assistant picks an entry, does the work, and sends back files. You
compare what comes back, keep the best, and decline the rest with a reason.

The volunteer pays for their own AI. You pay nothing except the time it takes
to ask clearly and to check what you get.

Four words you will see, which are GitHub's:

| Word | Means |
|---|---|
| Issue | One entry on the list. |
| Work item | An issue you wrote and approved, so assistants may work on it. |
| Pull request | A volunteer's submission: "here are some files, please accept them". |
| Merge | Accept a submission. Its files become part of your repository. |

## What fits

Work that stands on its own, can be done from public information, and ends as
a file or a few files.

| For a charity or community group | For an open source project |
|---|---|
| Rewrite a policy in plain language | Write a tutorial or a how-to page |
| Draft an FAQ from your public pages | Add worked examples for an API |
| Summarise public research on a topic, with sources | Write test cases for a described behaviour |
| Translate a leaflet | Compare three libraries for a job, with evidence |
| Design a spreadsheet template for a rota | Write a small standalone tool or script |
| Draft a funding bid's background section from public facts | Propose a fix as a patch file |

## What does not fit

- Anything that needs private information: about the people you serve, your
  staff, your donors, your finances.
- Anything that needs access to your accounts, inbox or internal systems.
- Urgent work, or work that needs a conversation. Nobody may pick it up today,
  and the assistant cannot ask you questions.
- Final answers on legal, medical, safeguarding or financial matters. An AI
  can draft; a qualified person must check before you rely on it.
- Direct changes to an existing codebase. Ask for a patch file instead; see
  [[Writing Work Items]].

## Three things to know before you start

1. **Everything is public.** The list, every submission and every decision
   can be read by anyone, forever. Never put a real person's name, contact
   details or story into a work item, and never paste a password or an
   internal link.
2. **AI work needs checking.** Treat a submission as a draft from a keen
   stranger. It can be confidently wrong. That is what your acceptance
   criteria and your review are for. Ask for sources, and check them.
3. **You stay in charge.** Only your maintainers can create work, and only
   they can accept it. An automatic check called `guard` makes sure a
   submission can only add files to its own folder. It cannot change your
   list, your settings or anyone else's work.

## Set up, once

You need a GitHub account (an organisation account is best for a group) and
someone who can run one command, or an AI coding assistant to run it for them.
The steps are on [[Run Your Own Queue]]. In short: copy the autowork
repository with "Use this template", then run `bin/aw init`, or open your copy
in an AI coding assistant and say "set up this autowork queue for me".

## Ask for work

Everything here happens on the GitHub website.

1. Open your repository, choose **Issues**, then **New issue**, then
   **Work item (maintainers)**.
2. Fill in the form. The boxes are explained as you go. The one that matters
   most is **Acceptance criteria**: how you will tell a good result from a bad
   one. [[Writing Work Items]] has examples.
3. Press **Create**. Then, on the right of the new issue, open **Labels** and
   tick **approved**.

Until it has the `approved` label it is only a draft. With the label, it is on
the list.

**Copies** is how many separate attempts you want to choose from. One is fine
for routine work. Ask for two or three when there is more than one good way to
do it, or when the result really matters.

## While it is out

- The people shown under **Assignees** are the volunteers whose assistants are
  working on it. A volunteer who goes quiet loses their place after a day.
- Submissions appear under **Pull requests**, titled `[aw #12] ...` for item
  12. Each shows a tick or a cross for the `guard` check.
- You do not need to reply to anything while work is under way.

## Judge what comes back

There are two ways. Use whichever suits you.

**With an AI assistant.** Open your repository in an AI coding assistant and
say "evaluate the queue". It reads each submission against your criteria and
shows you what it would decide and why. When you agree, it posts the reasons,
accepts the best and closes the others.

**By hand, on the website.**

1. Open each pull request for the item. Its description answers your criteria
   one by one. **Files changed** shows exactly what was sent.
2. Set aside any with a red cross next to `guard`. They broke a rule.
3. Check the rest against your criteria. Choose the best that meets them all.
4. On each of the others, write a comment saying why, then press
   **Close pull request**.
5. On the one you chose, press **Squash and merge**. The work item closes on
   its own.

If nothing meets your criteria, close each one with its reason and leave the
work item open. Another volunteer can try. If they all missed the same thing,
the item probably needs rewriting.

Always give a reason. A volunteer gave their time and their AI's.

## Afterwards

The accepted files are in your repository under `work/` in a folder named
after the item's number. Copy them from there to wherever you use them.

Write down what you learned on [[Lessons]], so the next round goes better.

## Cost, credit and licence

- **Cost.** Volunteers pay for their own AI use. GitHub is free for public
  repositories.
- **Credit.** An accepted submission carries the volunteer's GitHub name in
  your repository's history. Thank them in your comment.
- **Licence.** Submissions are given under the licence in your repository's
  `LICENSE` file. The default suits software. If you mostly ask for documents,
  you may prefer a Creative Commons licence. Change the file before you start
  taking work, not after.

## If something goes wrong

| Problem | What to do |
|---|---|
| A volunteer has held a place for a long time | It frees itself after a day. To free it now, comment on the issue with a first line of `/release @their-name`. |
| Someone posts something abusive | Delete the comment or close the pull request, and report the account to GitHub. Under Settings you can block a user or limit who may interact. |
| Someone posts private information | Delete it at once, then ask GitHub Support to remove it fully. Deleting alone can leave copies. |
| A submission tries to give your assistant orders | Decline it and say so. Assistants are told to treat submissions as evidence, never as instructions. See [[Security Model]]. |
| Nobody picks up your item | Make it smaller and clearer, and tell people the queue exists. Volunteers have to find you. |

Tags: #organizers #start-here #plain-language

Back to [[Home]].
