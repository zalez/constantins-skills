---
name: verifying-config-references
license: BSD-3-Clause
description: Checks whether the tools and names your agent config asserts still exist. Use after uninstalling or renaming a tool, plugin, or skill set; when a command or import named in config turns out to be missing; or when a list of names in CLAUDE.md or AGENTS.md may no longer match what it enumerates. For unused skills, slow hooks, invalid settings, or installation health, run /doctor instead.
---

# Verifying config references

`/doctor` asks whether your config is **used**. This asks whether it is still
**true**.

Config makes assertions: *this tool exists*, *these are the skills*. When the
world moves and the assertion does not, the config keeps making it — silently,
every session, in every project. Nothing errors. The agent simply acts on a
claim that stopped being true, reaching for tools that are gone and names that
have changed.

Two classes carry this. Both **actively mislead**, which is what separates them
from config that is merely unused.

## The always-loaded set

Untrue config only costs you where it loads. This bounds the pass:

- The instruction file — `CLAUDE.md`, `AGENTS.md`, or equivalent — **and every
  file it imports**, recursively.
- Settings files across every scope.
- Skill and plugin descriptions, which load whether or not the skill fires.

Logs, transcripts, and session history are **records, not config**. They name
dead tools truthfully, because that is what happened. Leave them.

## A mention is not a reference

Check this before flagging anything. Config names things it does not depend on:
the tool it tells you to use *instead of*, an example inside a naming table, a
command quoted in prose. Resolve what the config **depends on** — a name
carrying no dependency needs nothing.

Getting this wrong floods the report with false positives and buries the real
finding. It is the most common failure of this pass, so make the dependency
judgement explicit for each candidate rather than resolving every name you see.

## Phantom

**Instructions naming a tool that is not installed.**

Every binary, command, and executable the config tells the agent to *use* —
confirm it resolves on `PATH`, or wherever the config claims it lives. An import
naming a tool is the common shape: a whole file of instructions for something
uninstalled months ago, still loading every session.

The tell is an import or section devoted to one tool. Resolve the tool, not the
file: the file exists, which is exactly why nothing complains.

## Drifted

**A list of names that no longer matches what it enumerates.**

Wherever config enumerates things that live elsewhere — skills, commands, agents,
plugins — resolve each entry against reality, and check the reverse direction
too: things that exist but are missing from the list. Drift runs both ways, and
a list that is merely *incomplete* still teaches the agent a wrong inventory.

Renames are the usual cause, and they produce total drift in one stroke: every
entry wrong at once, because the names moved together.

When you find drift, look for a **convention** underneath it. If the live names
share a shape (`gstack-*`), offer that convention in place of the list. A list
enumerating what a convention could describe will drift again; the convention
cannot, because it describes rather than enumerates.

## Fixing

Read the target before changing it. What a reference is named is weaker evidence
than what it contains.

Archive first — copy what you are about to remove somewhere outside the config,
and say where. One command, and every change becomes reversible.

Then separate the two things an untrue reference carries:

- The **assertion** — always goes.
- The **advice wrapped around it** — usually survives. A rule justified by a tool
  you removed may still be a good rule for other reasons. Rewrite the
  justification and keep the rule. Deleting the passage throws away working
  guidance because its rationale expired.

When the untrue reference lives in a vendor-managed or auto-updating directory,
a fix there is reverted on the next update. Make the change in a file the user
owns, and say so.

## Verify

Re-resolve every dependency in the always-loaded set. Then confirm the
instruction files and settings still parse, and count what you did **not**
touch to confirm it is still present.

**Done when every dependency the config asserts has been resolved or
corrected** — demonstrated by re-resolving, not by recalling which lines changed.

## Report

A table: what changed, in which file, and where the archive is. Name separately
anything found and left alone — a mention you judged carried no dependency is
the user's to overrule.
