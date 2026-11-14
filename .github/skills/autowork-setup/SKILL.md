---
name: autowork-setup
description: Get a machine ready to work an autowork queue. Installs the GitHub CLI (gh), gets the user logged in to GitHub, and sets a git commit identity. Use when "bin/aw doctor" reports FAIL, when gh is missing or not authenticated, or when the user asks to set up or install autowork.
---

# Set up for autowork

The tool needs three things: `git`, the GitHub CLI `gh`, and a GitHub login.
Check what is missing first.

```bash
bin/aw doctor
```

Fix each FAIL line below, then run it again until it says `ready`.

## git is not installed

Ask your human to install it from <https://git-scm.com>. On macOS,
`xcode-select --install` also provides it.

## The GitHub CLI (gh) is not installed

Installing software is your human's decision. Show them the command for their
system and let them run it or approve it.

| System | Command |
|---|---|
| macOS (Homebrew) | `brew install gh` |
| Windows | `winget install --id GitHub.cli` |
| Linux, conda, others | follow <https://github.com/cli/cli#installation> |

On Windows, run `bin/aw` from Git Bash or WSL. It is a bash script.

## Not logged in to GitHub

Your human does this themselves, in their own terminal:

```bash
gh auth login
```

It opens a browser and asks them to approve the login. Never ask for a
password, a token or a one-time code, and never type one. If they offer to
paste a token into the chat, tell them not to.

Check the result:

```bash
gh auth status
```

## git has no commit identity

Commits in the pull request carry a name and an email address, and both are
public. Ask your human what to use; do not pick for them. GitHub's private
address (shown at <https://github.com/settings/emails>) keeps their real one
out of public history.

```bash
git config user.name "Their Name"
git config user.email "their-address@example.com"
```

Add `--global` only if they want it for every repository on the machine.

## Cannot see the queue

`doctor` says it cannot see the queue repository when the repository named in
`autowork.conf` is private and this login has no access, or when the name is
wrong. Tell your human; there is nothing to fix on this machine.

## You do not need to make a fork

`bin/aw submit` creates the fork of the queue repository the first time it is
needed.
