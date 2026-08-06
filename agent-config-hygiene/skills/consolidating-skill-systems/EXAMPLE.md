# Worked example — three skill systems

A real run, condensed. The numbers are what made each decision, so they are kept.

## The starting position

| System | Shape | Skills |
|---|---|---|
| Superpowers | Plugin, `autoUpdate: true`, plus a SessionStart hook injecting a "you must invoke a skill" preamble | 16 |
| gstack | Skills symlinked from a repo, each a thin layer over a `gstack` binary and its state directory | 57 |
| Matt Pocock's | Not installed yet; installable either as a managed plugin or as editable copies | 35 |

Over 100 skills once combined. Three claimed "something is broken"; two claimed
"I have an idea"; two claimed "review this diff".

## 1. Inventory

The skill listing summed to **~9,000 estimated tokens**, against a budget of
roughly 1% of the context window.

That first estimate of the budget was wrong by 5×: it assumed a 200k window on a
harness that had 1M, turning "comfortably at budget" into "4.5× over" and briefly
reframing the whole exercise around a crisis that did not exist. Two lessons,
both cheap:

- **Read the budget from the harness, not from memory.** `/context` reports the
  listing's share of the window directly. One command would have caught it.
- **Ask the overflow question anyway.** It simply was not the finding here. The
  real cost sat in memory files at more than four times the listing — visible on
  the line above it in the same output, and missed for a whole session because
  nobody looked.

## 2. Mutability

- **gstack** — one skill was 2,543 lines with 21 calls to its binary. Not
  mergeable at any price: strip the binary calls and the skill is gone.
- **Superpowers** — auto-updating from a fork that tracks its own upstream.
  Editable in principle, revert-prone in practice.
- **Matt's** — the only set whose installer copies editable files. Pruning is
  free here, and only here.

This killed the merge plan outright. Two of the three could not be merged, and
the third was already offering the thing for free.

## 3. Gates

Six of Matt's skills carried `disable-model-invocation: true` — including two
that had already been named as owners. They were absent from the callable list
entirely.

Resolutions, one per available strategy:

- `grill-with-docs` turned out to be a one-line wrapper over `grilling` plus
  `domain-modeling`, both ungated → **routed to the primitives**, no new file.
- `wayfinder` had 12 KB of unique content and no equivalent → **wrapper owned by
  the user**, delegating to the unedited vendor file.
- `handoff`, `wait-what` → **offer, don't invoke**. Both are deliberate human
  choices anyway.

## 4. Namespacing

gstack shipped a `--prefix` flag. One command renamed 37 skills to `gstack-*`,
and the choice persisted in gstack's own config, so it survives every future
upgrade. `review` immediately stopped shadowing the built-in review command.

Description collisions survived untouched, exactly as expected: `gstack-investigate`
still claimed "reports errors, stack traces, unexpected behavior" after the rename.

## 5. Ownership table

21 rows, 7 suppressions. Contested slots that went to the human, each with a
recommendation attached: which debugger owns "it's broken", which reviewer owns
a diff, and how to resolve a standing contradiction between the user's
plan-mode-by-default rule and three Superpowers skills that forbid plan mode.

Rows deliberately **not** added: roughly fifteen jobs where only one skill
claimed the work. They route themselves.

Two contests were invisible until the tables were laid side by side — a plan
executor competing with a second plan executor from the same vendor, and two
different stores for the same "capture a lesson" job.

## 6. Suppression level

All five suppressed skills were **plugin** skills, so mechanical suppression was
unavailable — `skillOverrides` does not reach inside a plugin. They were routed
around behaviourally and kept costing their descriptions.

The 15 unused skills that *were* in the user's own directory could be turned off
mechanically, and that is where the listing actually shrank: ~9,000 → ~6,800 est.
tokens. The justification was disuse — one invocation across 186 sessions — not
the budget emergency step 1 had wrongly diagnosed. Right call, wrong reason
attached to it at the time.

The largest remaining block belonged to a system whose usage counters the rename
had just reset, leaving it honestly "not yet judgeable" rather than cleanly
resolved.

The lesson the table alone would have hidden, and which stands whether or not the
listing is near its budget: **settling every contest changes context load not at
all.** Routing and cost are separate problems that happen to share a table.

## 7. Routing block

61 lines in the user's global instruction file: table, suppression list,
offer-don't-invoke list, plan-mode exception.

It replaced an enumerated list of gstack skill names that had gone stale the
moment the rename ran — replaced with the `gstack-*` convention, which cannot
drift.

## Outcome

- 68 skill directories, one owner per contested job, zero vendor files edited
- All three systems still auto-update
- Two wrapper skills owned by the user
- Every owner verified to resolve

The whole consolidation was one vendor flag, one decision table, and one block
of text in a file the user owns.
