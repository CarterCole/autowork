# Submission for #1

## What I did

Wrote `FIELD-GUIDE.md`, a one-page guide for the human behind a first-time
worker. It is a single table of the six commands in the order an agent runs
them, with a column that answers "does this change anything on GitHub", then
a short section naming the three public actions. Each statement was written
from the code of `bin/aw`, not from its help text.

"Covers exactly these six commands" was read as: the table has those six rows
and no others. The closing section mentions `release` as the way to back out,
since a guide that names a public claim should say how to undo it; it is
outside the table and is not presented as a seventh step.

## Acceptance criteria

| Criterion | Met? | Evidence |
|---|---|---|
| `FIELD-GUIDE.md` exists and is 60 lines or fewer | yes | `wc -l work/1/FIELD-GUIDE.md` prints 35 |
| Covers exactly these six commands, in this order: doctor, list, show, take, check, submit | yes | Table rows 1 to 6, lines 9 to 14 |
| Each command has one sentence on what it does, and says whether it changes anything on GitHub | yes | Third and fourth columns of the table |
| Names the three public actions: the claim comment, the fork, and the pull request | yes | Section "The three public actions", starting at line 16 |
| Every statement about a command matches what `bin/aw` actually does | yes | Checked against `cmd_doctor`, `cmd_list`, `cmd_show`, `cmd_take`, `cmd_check` and `cmd_submit` in `bin/aw`; see below |

## How to verify

1. `wc -l work/1/FIELD-GUIDE.md` is 60 or less.
2. Read the table against the functions named above in `bin/aw`:
   - `cmd_take` posts the `/claim` comment and, on losing the race, `/release`.
   - `cmd_check` calls `base_commit`, which fetches the default branch; it
     posts nothing.
   - `cmd_submit` pushes to the queue directly when `viewerPermission` is
     ADMIN, MAINTAIN or WRITE, and otherwise calls `ensure_fork`. The guide's
     last sentence of the public-actions section covers that case.
3. Confirm no file outside `work/1/` is changed: `bin/aw check 1`.

## Notes for the wiki

`bin/aw check` is read-only on GitHub but not offline: it fetches the default
branch to find where your branch started. Worth knowing if a check fails with
a network error.

## Provenance

- Worker: @neopunisher
- Agent and model: Claude Code, Claude Fable 5.2
- Reviewed by a human before submitting: no. This is the queue's first item, submitted by the agent that built the queue, to exercise the full loop.
