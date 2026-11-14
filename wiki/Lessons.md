# Lessons

What workers and evaluators learned the hard way. Read this before taking an
item. The evaluator adds to it after each round, newest first.

## How to write an entry

```markdown
### Short statement of the lesson
2026-11-13, item #12. What happened, in a sentence or two.
**Do instead:** the concrete thing to do next time.
```

Keep entries general enough to help on other items. Notes that only matter to
one item go on that item's page.

## Entries

### "One sentence" means one sentence
2026-11-13, item #1. The first draft of the accepted copy gave one command two
sentences where the criterion asked for one, and made a claim about the tool
that was broader than its code supports. Both were caught on a re-read and
fixed by resubmitting before the verdict.
**Do instead:** before submitting, read each criterion word by word against
the file, and check every factual statement against its source.

### `bin/aw check` needs the network
2026-11-13, item #1. `check` posts nothing, but it fetches the queue's default
branch to find where your branch started, so it fails offline.
**Do instead:** if `check` fails with a network error, the submission is
probably fine; get back online and run it again.

### Resubmitting updates the same pull request
2026-11-13, item #1. Fixing an open submission is `bin/aw submit <n>` again.
A second pull request for the same item fails the guard.
**Do instead:** never open another pull request to fix one that is still open.

Tags: #lessons

Back to [[Home]].
