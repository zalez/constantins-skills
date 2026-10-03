---
name: subagent-driven-development
description: Use when executing a written implementation plan with independent tasks in the current session
---

# Subagent-Driven Development

You are the **controller**. You execute a plan by giving each task to a fresh implementer subagent and reviewing it in proportion to its **risk**. The run ends with one **independent final review** of everything the run changed. You dispatch, rule and keep the ledger; subagents write the code.

Why this shape:
- A reviewer who did not write the code catches what its author rationalises away. In past runs the final review found a defect that would have shipped on more than half of all branches, including bugs the controller had looked at and called harmless.
- Per-task reviews of low-risk work almost never found anything, so that is where effort is saved.

**Model tiers.** Set the model explicitly on every dispatch:
- *most capable* = `opus`;
- *mid-tier* = `sonnet`;
- *one tier up* from the top tier = a fresh agent on the same tier.

**Scripts** are in this skill's `scripts/` directory. Call them by full path.

## Rulings, not stalls

Run the whole plan without check-ins. Decide conflicts, ambiguities and plan defects yourself. The spec is the authority; the plan argues from it. Before ruling on anything, consult the plan's Global Constraints and User Decisions. Record each decision as `Ruling: <decision> — <why> — <cost if wrong>`.

Stop and ask only for:
- an irreversible or destructive operation;
- a security-sensitive action;
- a side effect beyond this repo that you would normally ask about first (push to a shared branch, merge, publish, deploy, send);
- a plan so broken that every path forward is a guess.

## The ledger

`<workspace>/progress.md` is the recovery map. After a compaction, trust it and `git log` over your memory. It records state only, one event per line, in these forms. Append with `cat >> progress.md <<'EOF'`.

```
# SDD ledger — plan: <plan path>
START <sha7>
Ruling: <decision> — <why> — <cost if wrong>
Task N: dispatch (base <sha7>, agent <id>, model <m>)
Task N: minor (deferred): <one line>
Task N: fix round R (<X> addressed, <Y> open; commits <a7>..<b7>)
Task N: parked — <finding> — Ruling: <why the code stands>
Task N: complete (commits <base7>..<head7>, <review clean | K parked | low risk, no review>)
Final review: <verdict>; fix wave <a7>..<b7>
Reality check: <pass | fail> — <evidence>
```

BASE is always the sha in the task's `dispatch` line, never `HEAD~1`.

**Resuming:**
- A task with a `complete` line is done.
- A task with only `dispatch` or `fix round` lines is mid-flight: resume it at the next step.
- A `Final review` or `Reality check` line means that stage is done.

**Older plans:**
- A ledger without a START line uses the base of Task 1's first line.
- A task without a Risk line is normal risk.

## Setup

1. Run `scripts/sdd-workspace PLAN_FILE`; it prints the workspace. If a ledger there names this plan, resume from it. Otherwise create it with the identity line and `START <sha of HEAD>`.
2. Read the plan and its spec. The spec may be a file or an issue reference; if neither is reachable, add a ledger note that rulings are provisional.
3. Write the plan's Global Constraints and User Decisions, verbatim, to `<workspace>/constraints.md`. Every implementer and reviewer gets this file.
4. **Preflight.** Look for:
   - tasks that contradict each other, the constraints or the spec;
   - anything the plan mandates that a reviewer would call a defect: a test that cannot fail, a wildcard permission, a code body that is wrong.

   For plans with more than 8 tasks, dispatch [preflight-reviewer-prompt.md](preflight-reviewer-prompt.md) on `opus`. Otherwise do the check yourself. Rule on every finding before Task 1.

Done when the ledger has its START line, `constraints.md` exists, and every preflight finding has a ruling.

## Per task

Run tasks one at a time.

1. **Brief.** Run `scripts/task-brief PLAN_FILE N`, then append `Task N: dispatch (base <HEAD sha7>, …)` once you know the agent id.
2. **Dispatch the implementer** with [implementer-prompt.md](implementer-prompt.md). Give it:
   - the brief path;
   - `constraints.md`;
   - interfaces and rulings from earlier tasks that the brief cannot know;
   - the report path `<workspace>/task-N-report.md`.

   Use `sonnet`, or `opus` for high-risk tasks. Batch several small edits of the same shape into one dispatch.
3. **Handle the report.**

   | Status | What you do |
   |---|---|
   | DONE | Review it |
   | DONE_WITH_CONCERNS | Read the concerns first |
   | NEEDS_CONTEXT | Answer from the constraints and earlier rulings, then resume the implementer |
   | BLOCKED | Change something (context, model, task split, or a ruling) before retrying |

   A subagent that returns without a status or verdict is re-dispatched once, fresh. A second failure becomes a ruling.
4. **Review by risk.** Start from the plan's Risk line.
   - When the categories overlap, the higher one wins.
   - A task whose plan text contains a code body is at least normal.
   - Raise the risk if the diff touches more than the plan said.

   | Risk | Review |
   |---|---|
   | low | No task review. Read the diff stat and the verify output. Log anything odd as `Task N: minor (deferred): …`. |
   | normal | Run `scripts/review-package PLAN_FILE BASE HEAD`, then dispatch [task-reviewer-prompt.md](task-reviewer-prompt.md) on `sonnet` with the brief, report, package and `constraints.md`. |
   | high | The same review on `opus`. |

5. **Fix loop.** These findings enter the loop:
   - a Spec ❌;
   - any Critical or Important finding;
   - a ⚠️ "cannot verify from diff" item that you confirm as a real gap.

   Everything else:
   - Resolve every ⚠️ item yourself before completing the task.
   - Minors go to the ledger as deferred.
   - A finding against the plan's own text is yours to rule on first: code the plan mandated is not exempt from review.

   To run a round:
   - Resume the implementer (its agent id is in the `dispatch` line) with the findings verbatim.
   - Check the fix range with [re-review-prompt.md](re-review-prompt.md). For a one-line fix, read the fix diff yourself and confirm each finding is gone.
   - Log the round in the ledger.

   Round 3 goes to a fresh implementer one tier up. If findings remain after round 3, adjudicate each one: park it with a ruling, or rule on the smallest change that unblocks later work. Never fix code yourself.
6. **Complete.** Append the `complete` line.

## Final review

Run it always, whatever the task risks were.

1. Run `scripts/review-package PLAN_FILE <START> HEAD`.
2. Dispatch [final-reviewer-prompt.md](final-reviewer-prompt.md) on `opus`. Give it:
   - the spec;
   - the plan;
   - any ADRs the plan cites;
   - `constraints.md`;
   - the package;
   - every `minor (deferred)`, `parked` and `Ruling:` line from the ledger.
3. If it reports Critical or Important findings:
   - Write them to `<workspace>/final-fix-brief.md`.
   - Dispatch **one** fresh `opus` implementer with that file as its brief and `final-fix-report.md` as its report.
   - Run one re-review of the fix range with the same brief.
4. Adjudicate whatever remains, then append the `Final review` line.

## Reality check

Run the plan's Reality Check against real data, the live service or the rendered UI; the built-in `run` skill drives an app. If the plan has none, choose one that fits the feature.

- Wherever the feature writes, sends, publishes or deploys, use its dry-run or no-op mode, and inspect what it *would* do.
- If the check needs the user (credentials, a deploy, a device), give them the exact steps and wait.
- If it fails, the failure goes through one fix dispatch and re-review as a Critical finding, and then the check runs again. A second failure goes to the user as open.

Append the `Reality check` line.

## Finish

Report to the user:
- what was built, one line per task;
- the final review's verdict;
- the Reality Check result;
- **Rulings I made**: every `Ruling:` line from the ledger, in order, each with its cost if wrong;
- deferred minors left unfixed;
- any lesson about your own process.

Then delete the workspace (`rm -rf <workspace>`). Ask before pushing, merging or opening a PR.
