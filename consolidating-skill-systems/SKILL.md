---
name: consolidating-skill-systems
description: Consolidate several installed skill sets into one, by routing rather than merging.
disable-model-invocation: true
---

# Consolidating skill systems

You have installed two or more skill sets. Each is good. Together they fight:
three skills claim "this is broken", two claim "help me think through this", and
which one fires depends on whose description matched, not on which is best.

The instinct is to merge them into one curated set. **Resist it.** Merging means
forking upstreams you do not control, and the fork rots on every release. The
work that pays is deciding **who owns what** and writing that decision down
where it wins.

This is a rare, deliberate exercise — run it when the sets change, not weekly.
It produces a **routing layer**, not a merged skill set.

## Prime directive

**Express every decision in a file you own.**

Vendor files — an auto-updating plugin, a marketplace clone, a managed directory
— revert on their next update, silently, and you find out when a trigger stops
firing. Your instruction file does not revert, and it outranks skill
descriptions. Everything below routes through that asymmetry.

## 1. Inventory the trigger surface

Count what **competes**, not what is installed. A skill only conflicts through
its always-loaded description, so enumerate every source and its descriptions —
user skills, project skills, plugins, marketplaces, built-ins.

Two numbers matter more than the total: how many skills claim each job, and
whether the summed descriptions overflow the skill-listing budget (roughly 1% of
the context window). An overflowing listing gets truncated, and truncation
degrades routing on its own, before any conflict does.

## 2. Classify each source by mutability

This decides the treatment, so do it before deciding anything else.

| Class | Example | Treatment |
|---|---|---|
| **Auto-updating vendor** | a plugin with `autoUpdate`, a marketplace clone | Never edit. Route around it from your own file. |
| **Manual vendor** | files an installer copied in, which you re-fetch to update | Prune at install time; leave the copies unedited. |
| **Yours** | files you wrote | Edit freely. All decisions land here. |

Deleting files from an auto-updating source is the most common wasted move: the
files come back, and nothing tells you.

## 3. Find the gates

A skill that cannot fire the way its user actually works is dead weight, however
good it is. Ask how the human invokes things — typed commands, or automatic
triggering — then find every skill that mismatch strands.

The usual gate is a frontmatter flag making a skill user-invoked only: it is
absent from the agent's callable list entirely, so no routing file can reach it.
Check the flag on every candidate owner **before** naming it in a table, or the
table will name owners that silently never fire.

For each stranded skill, pick one:

- **Reachable equivalent** — a wrapper skill often wraps a primitive that is
  itself ungated. Route to the primitive and you need no new file.
- **Wrapper you own** — an auto-invoking skill whose body says to read the
  vendor file and follow it. Vendor content stays vendor content; the trigger
  surface becomes yours.
- **Offer, don't invoke** — you cannot fire a gated skill, but you can name it
  at the right moment. Correct for anything the human should choose deliberately.

## 4. Take the vendor's namespacing before inventing your own

Before renaming anything, look for a prefix flag, a namespace setting, or a
config toggle the vendor already ships. A vendor-supported namespace survives
updates and costs one command; a hand-rolled one is a fork.

Namespacing resolves **name** collisions — the slash commands and the ambiguity
about which `review` is which. It does **not** resolve description collisions:
auto-invocation still matches on description text, so a renamed skill competes
exactly as hard as before. Do it anyway, first, because it is cheap and makes
the rest legible — then expect the real contests to remain.

## 5. Build the ownership table

One row per job: the situation, in the words the human actually says, and the
single skill that owns it.

**A row earns its place only where two or more skills contest the job.**
Uncontested skills route themselves. Rows for them spend context in every
session to settle an argument nobody is having.

Read enough of each contender to have a view — the descriptions are marketing;
the bodies are the product. Then split the calls:

- **Facts are yours.** Which skills exist, what they cover, which are gated,
  what they cost. Never ask the human what you can look up.
- **Contested slots are theirs.** Where two skills are genuinely close, or the
  choice turns on how they like to work, put it to them with a recommendation
  and wait. Their answer is the decision; your job was to surface the contest.

Name the losers explicitly, as a suppression list. A row that says who owns a
job leaves the others still claiming it; only naming them settles it.

## 6. Suppress at the right level

Naming a loser in the routing file is **behavioural** suppression: the agent
stops invoking it, and its description goes on costing listing tokens. Where the
harness also offers **mechanical** suppression, it is usually graduated, and the
levels trade context load against reach:

| Level | Listed to the agent | Human can still invoke |
|---|---|---|
| full | name + description | yes |
| name only | name | yes |
| human-only | hidden | yes |
| off | hidden | no |

Match the level to *why* the skill lost. Lost a contest but still worth having on
demand → human-only, which is the mechanical form of offer-don't-invoke. Wanted,
but its description is long and it is rarely the answer → name only. Not wanted
→ off.

**Mechanical suppression usually stops at the edge of a vendor bundle.** In
Claude Code, `skillOverrides` governs skills in your own and your project's
directories and explicitly does not affect plugin-provided skills, which are
managed at whole-plugin granularity. Check your harness for the same boundary
before promising yourself a per-skill off switch — verify it, do not assume it.

That boundary decides how to take a set you only partly want:

- **Most of a plugin set** → keep the plugin, suppress the rest behaviourally,
  and accept their listing cost.
- **A few skills from a large set** → take it as copies you own rather than as a
  plugin, where the vendor offers that, and prune at install.
- **None of it** → disable the whole plugin.

If step 1 found the listing over budget, only mechanical suppression moves that
number. Behavioural suppression fixes routing and changes context load not at
all — worth stating plainly, because it is easy to finish the table, feel done,
and still be over budget.

The two compound, and this is the payoff of doing them together: **a routing
block makes "name only" affordable.** Stripping a description normally costs you
the skill's automatic triggering — but a skill the table already names has its
trigger in the routing file instead, so the description was doing work the block
now does. Every owner in your table is a candidate for name-only; every skill
that is *not* in the table still needs its description to be found at all.

## 7. Write the routing block

Into the highest-priority always-loaded instruction file the harness reads —
`CLAUDE.md`, `AGENTS.md`, or its equivalent. That file outranks skill
descriptions, which is the whole reason this works.

It carries four parts: the ownership table, the suppression list, anything to
offer-but-not-invoke, and any standing conflict between the sets' own rules.

Keep it short enough to be read every session. Prefer a convention
(`vendor-*`) to an enumerated list of skill names — a list of names drifts the
moment the vendor adds one, a convention does not.

## 8. Verify

Resolve **every** owner named in the table — it exists, it is installed, and it
is not gated. A routing table naming an absent owner is worse than no table: the
row fails silently and the suppressed skill wins by default, which is the exact
opposite of the intent.

**Done when every contested job has exactly one named owner, every owner
resolves, and every loser appears in the suppression list** — demonstrated by
resolving them, not by recalling which ones were added.

## Afterwards

Routing is a claim about behaviour, so test it: say the sentence that used to
fire the wrong skill and confirm the owner fires now. The contests you settled
on paper are not settled until one of them has actually been observed to route
correctly.

A worked example of this process across three skill systems is in
[`EXAMPLE.md`](EXAMPLE.md).
