---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

A plan records the **decisions** an implementer cannot make alone. That means:
- which files;
- which names and signatures;
- which exact values from the spec;
- which tests prove each task;
- how risky each task is.

The implementer is a capable engineer who has not seen this codebase or this spec. Once they know the interface and the test, they write idiomatic bodies on their own.

A plan longer than the code it describes is a **transcript**, not a plan. A transcript gets the code written twice, and its untested code turns into the "plan-mandated" defects that reviewers later have to rule on.

Save the plan to `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`, unless the repo has its own convention.

## 1. Scope and files

If the spec covers independent subsystems, propose one plan per subsystem. Then map every file to create or modify, and give each one a single responsibility. In existing code, follow the established patterns.

Done when every file in the plan has one stated responsibility.

## 2. Header

```markdown
# <Feature> Implementation Plan

> Execute with `subagent-driven-development`.

**Goal:** <one sentence>
**Architecture:** <2–3 sentences>
**Spec:** <path or issue reference for the spec or decision record this plan argues from>

## Global Constraints
<Project-wide requirements copied verbatim from the spec, one per line: exact values, formats, version floors, stated relations between components. Reviewers read every task through this block.>

## User Decisions (already made)
<What the user settled while shaping the work (grilling Q-numbers, ADRs), one per line, so execution never re-asks them.>

## Review Focus
<Up to five inputs or failure modes that the spec implies but no test exercises, ordered by how likely they are to hurt a real user. Each line gets its pinning test in the task that owns the code.>

## Reality Check
<The one run against real data, the live service or the rendered UI that shows the feature works for real: the command (or the steps the user performs) and what success looks like. Wherever the feature writes, sends or deploys, use its dry-run or no-op mode.>
```

## 3. Tasks

A task is the smallest unit with its own test cycle that a reviewer could reject while approving its neighbour. Fold setup, configuration and docs into the task whose deliverable needs them.

````markdown
### Task N: <component>

**Risk:** low | normal | high — <one-line reason>
**Files:** Create `path` · Modify `path:lines` · Test `path`
**Interfaces:** Consumes <exact signatures from earlier tasks> · Produces <exact names and types later tasks rely on>
**Acceptance:** <observable outcomes, one per line>
**Verify:** `<command>` → <the output that means pass>

- [ ] Write the failing test `test_name`: <assertions with the spec's exact values, as code>
- [ ] Run it; expect FAIL because <reason>
- [ ] Implement `fn(arg: Type) -> Type` in `path`. Add one line on the approach where the signature and test leave a choice.
- [ ] Run Verify; expect PASS
- [ ] Commit
````

**Risk** sets the review depth during execution:

| Risk | What it covers | Review |
|---|---|---|
| low | prose and docs, pure renames, copying exact values over | none per task |
| normal | ordinary logic | one task review |
| high | money, data integrity or loss, security, permissions/IAM, privacy, external side effects, a seam several tasks share | task review on the most capable model |

When categories overlap, the higher one wins. A task whose plan text contains a code body is at least normal. A low-risk task with nothing to test (docs, configuration) replaces its test steps with the Verify step.

**A step is unambiguous, not complete.** Each kind of step carries just enough to remove the ambiguity:
- **Test step:** the test name and its assertions as code, with the spec's exact values.
- **Code step:** the exact signature, the file, and the values the spec pins. Include a body only for an algorithm the signature and test leave open, or for exact copy the spec fixes.
- **Verify step:** the command and its expected output.
- **Reference to another task:** point to that task's Interfaces block; never repeat its code.

## 4. Self-review

Check the plan against the spec yourself (no subagent) and fix problems in place:

1. **Coverage.** Every spec requirement maps to a task.
2. **Steps.** Each step admits exactly one reasonable implementation:
   - no "TBD", "handle edge cases" or "tests for the above";
   - no bodies that the signature and test already determine.
3. **Names.** Signatures and types match across tasks.
4. **Tests can fail.** Each test would go red if you removed the behaviour it pins.
5. **Review Focus and Reality Check** are filled in, and each Review Focus line is pinned by a test.
6. **Proportion.** The plan is shorter than the code it describes. If code blocks dominate, replace bodies with signatures and assertions.

Done when all six hold.

## 5. Hand-off

Link the plan and ask the user to review it. Once they confirm, execute it with `subagent-driven-development`.
