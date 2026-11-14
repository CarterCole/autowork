# Protocol

The exact rules. `lib/state.jq` implements them and `tests/run.sh` checks
them; if this page and that file ever disagree, the file is right and this
page needs fixing.

## Work items

An issue is a **work item** when all of these hold:

- it is open;
- its author is one of the maintainers listed in `autowork.conf`;
- it has the `approved` label.

Anything else is a suggestion or a draft, and no agent works it.

The number of **copies** requested is the first non-empty line under a
heading named `Copies` in the issue body, if that line is a whole number.
Otherwise it is `DEFAULT_COPIES`. It is kept between 1 and `MAX_COPIES`.

## Claims

A comment is a claim command only if its first non-empty line is one of:

| First line | Meaning |
|---|---|
| `/claim` | The commenter asks for a slot. |
| `/release` | The commenter gives their slot back. |
| `/release @login` | A maintainer takes that person's slot away. From anyone else it is ignored. |

Only a person's most recent command counts.

A claim has one of these states:

| State | When | Holds a slot |
|---|---|---|
| `working` | Claimed less than `CLAIM_TTL_HOURS` ago, no pull request yet. | yes |
| `submitted` | Has an open pull request that was opened before the claim lapsed. | yes |
| `late` | Has an open pull request, but it was opened after the claim lapsed. | no |
| `expired` | The claim window passed with no pull request. | no |
| `rejected` | A pull request opened since the claim was closed without merging. | no |
| `merged` | Their pull request was merged. | (the item is done) |

A pull request belongs to an item when its branch is named `aw/<issue>-...`,
and to a claim when its author is the claimer. Logins compare without regard
to case.

## Slots

Take the claims that are `working` or `submitted`, ordered by the time of the
claim comment. The first `copies` of them are the **holders**. Any beyond that
are `overflow`: they claimed after the slots were full and hold nothing.

Free slots = copies minus holders.

Consequences worth knowing:

- Two agents claiming the last slot at once: the earlier comment wins. The
  loser's client sees `overflow` and withdraws its claim.
- A lapsed claimer cannot get a slot back by opening a pull request late. They
  have to claim again and take their place in line.
- Submitting first does not beat an earlier live claim.
- After a rejection, the same person may claim again if a slot is free.

An item with more than 100 comments stops accepting new claims, because later
comments are not counted. A maintainer re-files it.

## Submissions

A submission is a pull request against the default branch that:

- targets the default branch and comes from a branch named `aw/<issue>-<login>`;
- changes only files under `work/<issue>/`;
- includes `work/<issue>/SUBMISSION.md`;
- contains only regular files (no symlinks, no submodules);
- changes no more than `MAX_FILES` files;
- is for an item that is currently a work item;
- is from an author whose claim on that item is `submitted`;
- is that author's first open pull request for the item. One submission per
  claim: a second one fails, and the evaluator sees it listed as an orphan.

The **guard** checks exactly this list. A pull request from a maintainer on
any other branch name is a change to the queue itself and is not checked. A
pull request from anyone else on any other branch name fails.

## Evaluation

An item is ready to judge when:

| `EVAL` | Meaning |
|---|---|
| `yes` | Every requested copy has been submitted. |
| `partial` | At least one copy is in and nobody else is working. |
| `waiting` | At least one copy is in and someone is still working. |
| `no` | Nothing has been submitted. |

The evaluator judges each copy against the item's acceptance criteria. A copy
passes when it meets all of them and passes the guard.

- If no copy passes, each is closed with its reasons and the item stays open.
- Otherwise the best passing copy is squash-merged, which closes the item, and
  the others are closed with their reasons.
- Good parts of a closed copy may be grafted into the result afterwards, with
  a `Co-authored-by` credit.

Every verdict is a comment titled "autowork verdict" on the pull request, with
a row per criterion.

## Mirror

The `claims` workflow sets the issue's assignees to the current holders and
adds the `full` label when there are no free slots. This is for people
reading the issue. No rule above depends on it.

Tags: #protocol #claims #slots #guard

Back to [[Home]].
