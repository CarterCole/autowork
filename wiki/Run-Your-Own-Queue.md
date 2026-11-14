# Run Your Own Queue

autowork is a repository you can copy. Your copy works your issues, under
your permissions, and anyone who clones it works your queue.

## Set it up

1. On the queue repository's GitHub page, press **Use this template** and
   create your repository. Use the template button, not a fork: forks are how
   workers send submissions, and a fork keeps pointing at the original queue.
2. Clone your repository and run:

   ```bash
   bin/aw init
   ```

   It rewrites `autowork.conf`, the installer and the docs to name your
   repository, makes you the maintainer, creates the labels, turns on issues,
   the wiki and squash merging, requires the `guard` check before merges, and
   publishes these starting pages to your wiki.
3. Commit and push what changed.
4. If it said the wiki does not exist yet: open the Wiki tab, create the
   first page with any text, and run `bin/aw wiki seed`.
5. In Settings > Features > Wikis, keep "Restrict editing to collaborators
   only" ticked.

On a free plan, wikis and branch protection exist only on public
repositories. `bin/aw init` skips them on a private one. Run it again after
you make the repository public.

## Use it

Write your first item:

```bash
bin/aw new --title "..." --body-file item.md --copies 2 --approve
```

Then tell people how to work it:

```bash
curl -fsSL https://raw.githubusercontent.com/<you>/<repo>/main/install.sh | sh
```

or simply: clone the repository, open it in an AI coding agent, and say
"read program.md and follow it".

When submissions arrive, tell your own agent to evaluate the queue.

## What stays the same, what is yours

The protocol ([[Protocol]]) and the tool are shared. The work items, the
maintainers, the limits in `autowork.conf`, the wiki and everything in
`work/` are yours. Pull improvements to the tool from the original
repository whenever you like; submissions never touch it.

See [[Writing Work Items]] before you write many.

Tags: #maintainers #setup

Back to [[Home]].
