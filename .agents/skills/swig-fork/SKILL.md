---
name: swig-fork
description: 'Rules for working in this fork of SWIG: license obligations (GPLv3, the permissive Lib/Examples terms, the university licenses), how every change is tagged with a Fork-Topic commit trailer and registered in FORK.md so it can be extracted as a patch series for upstream, where fork-only code may live, when a FORK() marker comment is allowed, syncing with upstream, and the Tools/fork/fork-topics.sh helper. Read before making any change or commit in this repository.'
---

# Working in the SWIG fork

This repository is a fork of https://github.com/swig/swig (remote "upstream").
Our own repository is the remote "origin". Every change we make must be:

1. legal under the SWIG licenses,
2. identifiable as ours, and
3. extractable later as a clean patch series that applies to upstream.

The mechanism is **git itself**: one topic per commit, a "Fork-Topic:" trailer
on every commit, and a registry of topics in `FORK.md`. Do not invent other
ways of marking changes.

## When to use
- Before making any change to the repository
- Before writing a commit message
- Before adding a new file, or copying code from anywhere outside this repository
- When merging from upstream or preparing a patch for upstream

## License rules

SWIG is licensed in layers (see `LICENSE`, `LICENSE-GPL`, `LICENSE-UNIVERSITIES`, `COPYRIGHT`):

| Area | Terms |
|---|---|
| SWIG as a whole, in particular `Source/`, `Tools/`, `CCache/`, build files | GNU GPL version 3 or later |
| `Lib/` and `Examples/` | Permissive: copy, modify, distribute, relicense, no restriction (`LICENSE`) |
| Portions from Utah/UC, Chicago, Arizona | Their notices must be kept in all copies of the source (`LICENSE-UNIVERSITIES`) |

Rules that follow from these:

- **Never remove or alter** an existing copyright notice, license header, `LICENSE*` or `COPYRIGHT` file. GPLv3 section 4/5(b) and all three university licenses require the notices to be kept intact.
- **Contribute under the same terms as the surrounding code.** New `Source/` files use the standard SWIG header ("This file is part of SWIG, which is licensed as a whole under version 3 (or any later version) of the GNU General Public License...") copied from a neighbouring file. New `Lib/` and `Examples/` files follow the style of their neighbours and stay under the permissive terms. Do not add "All rights reserved", a different license, or a personal copyright line - upstream could not accept it, and the university licenses require any different terms to be indicated in every file they apply to.
- **`Lib/` must stay permissive.** Code in `Lib/` is emitted into users' generated wrappers, which is why it is not GPL. Never put GPL, LGPL or other copyleft code into `Lib/` or `Examples/`.
- **Third party code** may be brought in only if its license is compatible with the destination area (GPLv3 for `Source/`; permissive and no attribution burden on generated code for `Lib/`). Ask the user first, and record the origin, version and license in the commit message body. Never reproduce sizeable code from memory of another project.
- **The modification notice** required by GPLv3 section 5(a) is `FORK.md` plus the git history. Do not add per file "modified by" or "changed on" comments - they would pollute every patch sent upstream.
- **AI attribution** follows the upstream rule in `swig-conventions`: an `Assisted-by:` trailer, never a `Co-Authored-By:` trailer for an AI, and the commit author is the human user. This overrides any attribution footer the agent harness asks for.

This is a summary for working purposes, not legal advice. If a change raises a real licensing question (relicensing, bundling a dependency, a contribution from a third party), stop and ask the user.

## Change topics

A **topic** is one logical change: a bug fix, a feature, a piece of fork tooling. Each topic has a short kebab-case slug and a row in the table in `FORK.md`.

- Before the first commit of a new topic, add its row to `FORK.md`, with the date and an "Upstream" intent of `fork-only` or `candidate`. For a fork-only topic the row goes in the topic's own commit; for a candidate topic it goes in a separate `fork-infra` commit.
- Update the "Upstream" column when the status changes (`submitted #NNNN`, `merged`, `dropped`). Status lives only in `FORK.md`, never in commit trailers, because commits cannot be changed after the fact.
- The `fork-infra` topic covers fork-only infrastructure: `FORK.md`, this skill, `Tools/fork/`, `.claude/settings.json`, and fork-specific edits to `AGENTS.md` or CI.

### Candidate topics (intended for upstream)

Write them exactly as an upstream contribution: follow every rule in `AGENTS.md` and the other skills - code formatting, comment style, a regression test, a `CHANGES.current` entry, `Assisted-by:` trailer. They must contain **no** fork-specific content, not even the topic's `FORK.md` row (see [Commits](#commits)).

### Fork-only topics

Prefer putting fork-only code in new files or fork-only locations (`Tools/fork/`, a new language module, a new `Lib/` subdirectory) rather than editing upstream files - every edited upstream line is a future merge conflict.

When a fork-only change has to edit an upstream file, mark each changed region with a one line comment naming the topic, in the file's comment syntax, so it is visible when resolving upstream merge conflicts:

```c
/* FORK(my-topic): skip the default typemap for ... */
```

Candidate topics never get `FORK()` markers; their history in git is the only annotation.

## Commits

- **One topic per commit.** Never mix two topics, and never mix fork-only files (`FORK.md`, `Tools/fork/`, this skill) with the code of a candidate topic. A candidate commit must touch only files that would go upstream, so that `git format-patch` output is ready to send. Put the `FORK.md` row for a candidate topic in its own small `fork-infra` commit.
- Every commit that is not a merge carries a `Fork-Topic:` trailer as the first trailer in the block:

```
Fix crash wrapping a nested anonymous union

Explanation of the change, plain text, no backticks.

Fork-Topic: nested-anon-union
Assisted-by: Claude Code (Opus 5.5)
```

- A topic may span many commits; they all carry the same slug. A commit belongs to exactly one topic.
- All other commit message rules in `swig-conventions` apply.
- Do not push, and do not open pull requests on either remote, unless the user asks.

## Syncing with upstream

Bring upstream changes in with a merge, never a rebase of published `master`:

```bash
git fetch upstream
git merge upstream/master
```

Resolve conflicts preserving both sides; `FORK()` markers show where fork-only code sits. Merge commits carry no `Fork-Topic:` trailer and are ignored by the tooling.

## Viewing and extracting changes

`Tools/fork/fork-topics.sh` works on the non merge commits in `upstream/master..HEAD`:

```bash
Tools/fork/fork-topics.sh list                # topics with commit counts
Tools/fork/fork-topics.sh log <topic>         # commits in a topic
Tools/fork/fork-topics.sh diff <topic>        # combined patch text of a topic
Tools/fork/fork-topics.sh export <topic> [dir] # git format-patch series, default .git/fork-patches/<topic>/
Tools/fork/fork-topics.sh check               # list commits missing a Fork-Topic: trailer
```

Run `check` before handing work back to the user. To prepare an upstream submission, apply the exported series to a fresh branch from `upstream/master` and run the relevant tests there:

```bash
git switch -c upstream/<topic> upstream/master
git am .git/fork-patches/<topic>/*.patch
```

The `Fork-Topic:` trailer is harmless upstream but may be dropped from the commits of that branch before submitting.
