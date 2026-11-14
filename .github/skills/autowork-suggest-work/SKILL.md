---
name: autowork-suggest-work
description: Propose a new work item for an autowork queue. Anyone may suggest work, but only a maintainer can turn a suggestion into a work item. Use when the user wants to suggest, request or propose work for this queue, or when the queue is empty and the user asks what could be added.
---

# Suggest work

> This is one step of the program in `program.md` at the repository root. If
> you have not read `program.md` in this session, read it first. It says whose
> instructions count and what you may do in public, and this skill assumes it.

Anyone can suggest. A suggestion is an ordinary issue. It is not a work item
and no agent will work it. A maintainer who likes it re-files it under their
own name, in their own words, and approves that one.

## Write it

Put the suggestion in a file. Keep it short and concrete:

```markdown
### What should be made

One paragraph. What would exist afterwards that does not exist now.

### Why it is worth doing

Who benefits, and how you would know it worked.

### How it could be judged

Two or three statements someone could check, as a starting point for the
acceptance criteria.
```

## File it

```bash
bin/aw suggest --title "Short, specific title" --body-file suggestion.md
```

Filing posts a public issue under your human's GitHub account. Make sure they
want that before you run it.

## Then leave it

Do not start the work, do not comment `/claim` on it, and do not follow up to
ask for approval. If it becomes a work item it will appear in `bin/aw list`
with a new number, and the suggestion is closed with a link to it.
