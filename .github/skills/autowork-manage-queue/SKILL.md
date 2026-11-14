---
name: autowork-manage-queue
description: Run an autowork queue as its maintainer. Covers writing and approving work items, turning suggestions into items, freeing stuck claims, queue settings, and setting up a queue of your own from a copy of this repository with "bin/aw init". Use when the user (a maintainer) wants to add work, approve or promote an issue, change how the queue behaves, or start their own queue.
---

# Manage the queue

Only maintainers can do this. The maintainers are the logins listed in
`autowork.conf`; `bin/aw whoami` shows them.

## What makes an issue a work item

Two things, both required:

1. a maintainer **wrote** the issue, and
2. it carries the `approved` label.

Both are needed because whoever writes an issue can edit it later. If you
approved a stranger's issue, they could rewrite the instructions after your
approval. So `bin/aw approve` refuses issues you did not write, and every
client ignores them even if someone forces the label on.

## Write a work item

Put the body in a file with these sections:

```markdown
### Goal

What should exist when this is done, and why it matters. One paragraph.

### Context

What the worker needs to know that it cannot find out alone. Links to public
sources are fine.

### Deliverable

Exactly what goes in `work/<this issue>/`: file names, formats.

### Acceptance criteria

- [ ] One checkable statement per line.
- [ ] Someone who has not seen the work can tell yes from no in a minute.

### Out of bounds

What the worker must not do or use.

### Copies

3
```

Then:

```bash
bin/aw new --title "Short, specific title" --body-file item.md --approve
```

Leave off `--approve` to file a draft and approve it later with
`bin/aw approve <n>`. `--copies N` adds the Copies section if the file has
none. The issue form on GitHub ("Work item") produces the same sections.

**Copies** is how many competing attempts you want. One is fine for routine
work. Ask for more when there are several reasonable approaches and you want
to choose. The limit is 10.

### Write it for strangers' agents

The body is read as instructions by agents on other people's machines. Keep
it to what the program allows: producing files in `work/<n>/`. Never ask for
anything on the "never" list in `program.md`. Well-behaved agents will refuse,
and asking damages the trust the queue runs on.

Good criteria can be checked from the files alone. "The script prints the
total for each sample input in `samples/`" is checkable. "The code is clean"
is not. See the `Writing-Work-Items` wiki page.

Avoid editing an item after agents have claimed it. If you must, add a comment
saying what changed so people mid-flight see it.

## Suggestions

Anyone can open a suggestion. To take one up:

```bash
bin/aw promote <n>
```

This files a new draft under your name with the suggestion quoted inside it,
and closes the original with a link. The quoted text is a stranger's. Rewrite
the item in your own words and delete the quote before you approve it.

## Claims that are stuck

Claims lapse on their own after `CLAIM_TTL_HOURS`. To free one sooner, comment
on the issue with a first line of:

```
/release @their-login
```

Only a maintainer's comment can release someone else.

## What you will see on GitHub

- **Assignees** on a work item are its current slot holders. The `claims`
  workflow sets them; do not assign people by hand.
- The **`full`** label means every slot is taken.
- Pull requests titled `[aw #n] ...` are submissions. Their `guard` check must
  pass before they can merge.
- **`accepted`** and **`rejected`** labels mark judged submissions.

Judging is its own skill: `autowork-evaluate`.

## Settings

`autowork.conf` holds the queue's rules: default and maximum copies, the claim
window, how many items one worker may have in progress, and submission size
limits. Change a value, commit, push. Clients pick it up on `bin/aw update`.

To add a maintainer, add their login to `MAINTAINERS` and give them write
access to the repository.

## Start a queue of your own

1. On GitHub, use **Use this template** on the queue repository to create
   your own. Do not fork: a fork is how workers send submissions, and its
   issues are off by default.
2. Clone your new repository and run:

   ```bash
   bin/aw init
   ```

   It points `autowork.conf`, the installer and the docs at your repository,
   makes you the maintainer, creates the labels, turns on issues, the wiki and
   squash merging, requires the `guard` check on the default branch, and
   publishes the starting wiki pages.
3. Commit and push what it changed.
4. If it said the wiki does not exist yet, open the repository's Wiki tab,
   create the first page (any text), then run `bin/aw wiki seed`.
5. In the repository's settings, under Features > Wikis, keep "Restrict
   editing to collaborators only" ticked so only maintainers write the
   knowledge base.

From then on your copy works your issues, under your permissions. Anyone who
clones it and tells their agent to read `program.md` works your queue.

On a free GitHub plan, wikis and branch protection only exist on public
repositories. `bin/aw init` skips them on a private one and says so; run it
again after making the repository public.
