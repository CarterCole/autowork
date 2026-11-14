#!/bin/sh
# autowork installer.
#
#   curl -fsSL https://raw.githubusercontent.com/CarterCole/autowork/main/install.sh | sh
#
# It clones the queue into ~/autowork (or $AUTOWORK_DIR) and tells you what to
# say to your AI agent. It installs nothing else and changes no settings.
set -eu

main() {
  REPO="${AUTOWORK_REPO:-CarterCole/autowork}"
  DIR="${AUTOWORK_DIR:-$HOME/autowork}"

  say() { printf '%s\n' "$*"; }

  if ! command -v git >/dev/null 2>&1; then
    say "autowork needs git. Install it from https://git-scm.com and run this again."
    exit 1
  fi

  if [ -d "$DIR/.git" ]; then
    say "Updating $DIR"
    git -C "$DIR" pull --ff-only --quiet || say "Could not fast-forward $DIR, so it was left as it is."
  elif [ -e "$DIR" ]; then
    say "$DIR already exists and is not an autowork checkout."
    say "Set AUTOWORK_DIR to another folder and run this again."
    exit 1
  else
    say "Cloning $REPO into $DIR"
    git clone --quiet "https://github.com/$REPO.git" "$DIR"
  fi

  if ! command -v gh >/dev/null 2>&1; then
    GH="not installed yet. Your agent will walk you through it, or see https://cli.github.com"
  elif gh auth status >/dev/null 2>&1; then
    GH="installed and logged in"
  else
    GH="installed, not logged in. Run: gh auth login"
  fi

  say ""
  say "autowork is in $DIR"
  say "GitHub CLI: $GH"
  say ""
  say "Next: open that folder in your AI coding agent (VS Code with Copilot,"
  say "Claude Code, Codex, or any other) and tell it:"
  say ""
  say "    Read program.md and follow it."
  say ""
  say "It will check your setup, pick a work item from $REPO,"
  say "do it, and open a pull request from your GitHub account."
}

main "$@"
