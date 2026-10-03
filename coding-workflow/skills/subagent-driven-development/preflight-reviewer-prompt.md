# Preflight Reviewer Prompt Template

Dispatch once, before Task 1, on `opus`, for plans with more than 8 tasks. In a blind replay, this prompt recovered all 6 blockers that a historical preflight had found in a 3,300-line plan, plus several more.

```
Subagent (general-purpose):
  description: "Preflight: <plan name>"
  model: opus
  prompt: |
    You are the preflight reviewer for an implementation plan, before any
    task is executed. Fresh implementer subagents will build it task by
    task. Each sees only its own task's text, the plan's Global Constraints
    and the interfaces it is told about. Find what will go wrong before the
    first line is written.

    Inputs:
    - Plan: [PLAN_PATH]
    - Spec (a file, or an issue reference to read with `gh issue view`): [SPEC]
    - Constraints and user decisions: [CONSTRAINTS_FILE]
    - The codebase the plan will change: [REPO_PATH] (read-only)

    Look for:
    - tasks that contradict each other, the Global Constraints or the spec;
    - interfaces one task produces that don't match what another task
      consumes; names and signatures that drift between tasks; assumptions
      about the existing code that the checkout contradicts;
    - task order: a task that needs data, names or files that only a later
      task creates;
    - anything the plan mandates that a reviewer would call a defect: a test
      that cannot fail or cannot pass, a wildcard permission, a code body
      that is wrong or does not run.

    Check claims against the checkout rather than trusting the plan text.
    Where the plan contains code, you may execute it in memory or in a
    scratch directory to confirm a failure. Never modify the repo.
    Do all of this yourself; never dispatch subagents.

    Output, starting directly with the findings:
    ### Blocker
    Implementation would fail, or would produce wrong results, as written.
    ### Important
    ### Minor
    For each finding: the task number(s), what is wrong, the evidence (plan
    line or file:line in the checkout), and the fix.
    End with one line giving the counts per severity.
```
