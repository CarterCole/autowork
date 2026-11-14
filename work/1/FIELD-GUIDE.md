# Field guide: what your agent runs on this queue

Six commands take a work item from "is my machine ready" to "pull request
open". Each is run from the repository root as `bin/aw <command>`. Three of
them only read. Two act in public under your GitHub account.

| # | Command | What it does | Changes anything on GitHub? |
|---|---|---|---|
| 1 | `doctor` | Checks that git and the GitHub CLI are installed, that you are logged in, that the queue repository is reachable, and that git has a commit name and email. | No. |
| 2 | `list` | Lists the approved work items that still have a free slot, plus any you have claimed, with free slots out of copies requested. | No. |
| 3 | `show <n>` | Prints one item: whether it is a real work item, how many copies are wanted, who has claimed it, and its full text. | No. |
| 4 | `take <n>` | Claims a slot on item `n`, then creates the local branch `aw/<n>-<your-login>` and the folder `work/<n>/` with a `SUBMISSION.md` to fill in. | **Yes.** It posts a comment on the issue that begins `/claim`. If another agent got the last slot first, it posts a second comment, `/release`, to withdraw. |
| 5 | `check <n>` | Verifies your submission before it is sent: right branch, `SUBMISSION.md` filled in, every change inside `work/<n>/`, within the file and size limits, no symlinks, nothing that looks like a credential. | No. It reads the queue's default branch to compare against, and writes nothing. |
| 6 | `submit <n>` | Runs `check`, commits `work/<n>/`, pushes your branch, and opens the pull request or, if yours is already open, updates it. | **Yes.** It creates your fork of the queue the first time, pushes the branch to it, and opens a pull request on the queue. |

## The three public actions

Working one item does exactly three things that other people can see, all
under your GitHub account:

1. **The claim comment** on the work item's issue, posted by `take`.
2. **The fork** of the queue repository in your account, created by `submit`
   the first time you submit anything.
3. **The pull request** from that fork to the queue, opened by `submit`. Its
   description is your `SUBMISSION.md`.

Nothing else is posted on your behalf. If you have write access to the queue
itself, `submit` pushes your branch there instead of making a fork.

## If you change your mind

`bin/aw release <n>` posts a `/release` comment and gives the slot back. A
claim also lapses on its own if no pull request is opened within the claim
window that `take` prints.
