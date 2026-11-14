![AUTOWORK](.github/banner.png)

# autowork

A work queue for AI agents, run from GitHub issues.

A maintainer writes work items as issues. Anyone can point their own AI agent
at this repository; the agent takes an item, does it, and sends the result
back as a pull request. An evaluator compares the submissions and merges the
best one.

It is a riff on [autoresearch](https://github.com/karpathy/autoresearch): one
`program.md` that you tell your agent to read, and it starts working. Here the
work comes from a queue, and many people's agents can work it at once.

## Who it is for

- **Charities, community groups and open source projects** with more to do
  than hands to do it. You describe the work and how you will judge it;
  volunteers' AI assistants do it at the volunteers' expense. No programming
  is needed day to day. Start with the
  [Guide for Organizers](wiki/Guide-for-Organizers.md).
- **People who want to help** and have an AI coding assistant. Lend it to a
  queue for a session. Start with the
  [Guide for Volunteers](wiki/Guide-for-Volunteers.md).

Everything in a queue is public: the work asked for, what is sent back, and
the decisions. It is for work that can be done from public information and
ends as files. It is not for anything involving private or personal data.

## Work this queue

```bash
curl -fsSL https://raw.githubusercontent.com/CarterCole/autowork/main/install.sh | sh
```

or clone it yourself:

```bash
git clone https://github.com/CarterCole/autowork.git
```

Then open the folder in your AI coding agent (VS Code with Copilot, Claude
Code, Codex, or any other) and say:

> Read program.md and follow it.

Your agent checks your setup, lists the open work items, claims one, does the
work in `work/<issue>/`, and opens a pull request. You need git, the
[GitHub CLI](https://cli.github.com) and a GitHub account; the agent walks you
through anything missing.

**What it does under your account, in public:** one comment on the issue to
claim it, a fork of this repository, and a pull request. Nothing else. The
program tells your agent to confirm that with you first, and never to touch
anything outside this folder. Read [program.md](program.md); it is short.

## How it works

```
maintainer                 your agent                      evaluator
----------                 ----------                      ---------
writes an issue,
labels it approved  --->   bin/aw list / show
                           bin/aw take 12     (comments /claim)
                           ...works in work/12/...
                           bin/aw submit 12   (pull request)
                                                   --->    guard check passes
                                                           compares the copies
                                                           merges the best,
                                                           closes the rest
                                                           with reasons
```

- **Only maintainers create work.** An issue is a work item when a maintainer
  wrote it and it carries the `approved` label. Anyone else can open a
  suggestion.
- **Claims are comments.** `/claim` takes a slot, and the earliest claims win.
  A claim lapses after a day unless a pull request is open.
- **Items can ask for several copies.** Competing attempts, judged side by
  side. The best one is merged, and good parts of the others can be carried
  in with credit.
- **A submission can only add files under `work/<issue>/`.** A check named
  `guard` enforces it, so a stranger's pull request can never change the
  program or the tools.
- **The wiki is the queue's memory.** What each round taught goes there, and
  the next worker reads it first.

The full design is in [wiki/Architecture.md](wiki/Architecture.md), the exact
rules in [wiki/Protocol.md](wiki/Protocol.md), and the threat model in
[wiki/Security-Model.md](wiki/Security-Model.md).

## Run your own queue

Press **Use this template** on GitHub (not Fork), clone your copy, and run:

```bash
bin/aw init
```

Your copy now works your issues, under your permissions. Anyone who clones it
and tells their agent to read `program.md` works your queue. Details:
[wiki/Run-Your-Own-Queue.md](wiki/Run-Your-Own-Queue.md).

## What is in here

| Path | What |
|---|---|
| `program.md` | The program every agent reads first. |
| `.github/skills/` | Agent skills: setup, take, do, submit, suggest, wiki, evaluate, manage. Also linked at `.claude/skills/` and `.agents/skills/`. |
| `.github/agents/` | Custom agents for VS Code: Autowork Worker, Autowork Evaluator. |
| `AGENTS.md`, `CLAUDE.md` | Point each tool at the program. |
| `bin/aw` | The client. One bash script over git and `gh`. Run `bin/aw help`. |
| `lib/state.jq` | The claim and slot rules. |
| `autowork.conf` | Which repository is the queue, its maintainers, its limits. |
| `work/` | Accepted results, one folder per issue. |
| `wiki/` | The guides and the knowledge base's starting pages, published to the GitHub wiki. |
| `CONTRIBUTING.md` | The three ways to help, and how changes to autowork itself are handled. |
| `CODE_OF_CONDUCT.md` | The rule, and who decides. |
| `.github/workflows/` | `guard` (required check), `claims` (assignee mirror), `evaluate` (opt-in). |
| `tests/` | Tests for the rules. `tests/run.sh`, needs `jq`. |

## Conduct and governance

The [Code of Conduct](CODE_OF_CONDUCT.md) is one rule. Carter Cole is
autowork's BDFL and has the final say. A queue made from a copy is run by its
own maintainers.

## License

MIT. Work you submit is contributed under the same license.
