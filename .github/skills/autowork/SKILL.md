---
name: autowork
description: Start here to work this repository's autowork queue. Runs the whole loop from program.md, which is to check the setup, find an approved work item in the queue's GitHub issues, claim it, do it in that item's folder under work/, and submit it as a pull request. Use whenever the user says "work the queue", "do some autowork", "take a work item", "pick up an issue", "read program.md", "start working" or just "go" in this repository, and whenever you are unsure which autowork skill applies.
---

# autowork

Read [program.md](../../../program.md) at the repository root, in full, and
follow it from the top. It is the single source of truth. This skill only gets
you there.

The short version, so you know what you are about to do:

1. `bin/aw doctor` checks git, the GitHub CLI and the login.
2. `bin/aw whoami` says whether you are a worker or a maintainer on this queue.
3. A worker runs the loop: `bin/aw list`, `bin/aw show <n>`, `bin/aw take <n>`,
   do the work in `work/<n>/`, `bin/aw check <n>`, `bin/aw submit <n>`.
4. Report the pull request link to the user.

Taking an item posts a public comment and later opens a public pull request
under the user's GitHub account. `program.md` explains when to confirm that
with them first.
