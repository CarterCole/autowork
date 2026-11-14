# Contributing

There are three ways to help, and they work differently.

## 1. Do work from the queue

Point your AI coding assistant at this repository and tell it:

> Read program.md and follow it.

It takes a work item, does it, and opens the pull request for you. Start with
[wiki/Guide-for-Volunteers.md](wiki/Guide-for-Volunteers.md).

Please do not open a submission by hand. Submissions are opened by
`bin/aw submit`, which names the branch and links the work item. One opened
any other way fails the `guard` check and cannot be merged.

## 2. Suggest work

Open an issue and choose **Suggest work**. A suggestion is not a work item. If
a maintainer takes it up, they write it up under their own name and close
yours with a link.

## 3. Improve autowork itself

The tool, the skills and the docs are open to improvement.

1. Open a suggestion describing the change first, so nobody builds something
   that will not be merged.
2. Make your change and run `tests/run.sh`. It needs `jq`.
3. Open a pull request from any branch whose name does not start with `aw/`.

Your pull request will show a failing `guard` check. That is by design: the
check only passes work item submissions and maintainers' own changes, so that
nothing else can be merged by accident. A maintainer reviews changes to the
tool by hand and merges them deliberately.

The rules for changes are in [AGENTS.md](AGENTS.md): the claim and slot rules
live only in `lib/state.jq`, `bin/aw` must run on bash 3.2 with nothing but
git and gh, and nothing a workflow does may run code from a pull request.

## For everyone

- Everything here is public and permanent. Do not include personal or
  confidential information, yours or anyone else's.
- Say where anything you did not write came from.
- Be kind. The people on the other side may be volunteers at a charity.
- What you contribute is given under this repository's [LICENSE](LICENSE).

## Security problems

If you find a way around the `guard` check, or a way to make an agent that
follows `program.md` do something it should not, please do not open a public
issue. Use **Report a vulnerability** on this repository's Security tab.
