# Final Reviewer Prompt Template

Dispatch once, after every task is complete, on `opus`.

```
Subagent (general-purpose):
  description: "Final review: <plan name>"
  model: opus
  prompt: |
    You are the independent final reviewer of a whole change that other
    agents built task by task. Each task already passed its own gate. Your
    job is what those gates could not see:
    - seams between tasks;
    - behaviour on inputs the tests never try;
    - consequences outside the diff.

    Assume something in this change will hurt a real user, and find it.

    ## Inputs

    - Spec (a file, or an issue reference to read with `gh issue view`):
      [SPEC]
    - Plan: [PLAN_PATH]. Read its header first: Global Constraints, User
      Decisions, Review Focus, Reality Check.
    - Constraints and user decisions, verbatim: [CONSTRAINTS_FILE]
    - ADRs or other decision records the plan cites: [ADR_PATHS]
    - Review package (commits, stat, full diff with context): [DIFF_FILE]
    - Ledger lines with deferred minors, parked findings and rulings:
      [LEDGER_EXCERPT]
    - Range: [START_SHA]..[HEAD_SHA] in [REPO_PATH]

    ## How to review

    Read the package once, then read the full commit messages:
    `git log --format='%H%n%B' [START_SHA]..[HEAD_SHA]`.

    Then probe. For each risk you can name, check it concretely:
    - trace the call path;
    - read the unchanged code it touches;
    - or run a focused test, a mutation or a read-only probe in a scratch
      worktree (`git worktree add <tmp-dir> [HEAD_SHA]`; remove it with
      `git worktree remove` when you are done).

    Leave this checkout's working tree, index and HEAD untouched. Never send,
    publish, deploy or write outside the scratch worktree.

    Look hardest at:
    - **Data loss.** Writes that overwrite, truncate or replace data that
      cannot be regenerated; reruns; partial failure halfway through a loop.
      Check every write against the ADRs.
    - **External side effects.** For anything sent, posted, published or
      deleted outside the repo, run the selection logic read-only against
      the repo's real content, and look at every target it would hit.
    - **Inputs the tests never try.** For every parser, matcher or
      validator, try lookalike, duplicate, empty, partial and boundary
      inputs. A check that passes on a lookalike is broken.
    - **Privacy and secrets.** Real personal data, holdings, keys or tokens
      in code, tests, fixtures, commit messages, plan text, or issue and PR
      text.
    - **Money and cost.** Paid calls that repeat, get lost or run unbounded;
      cache keys that never hit.
    - **Deploy reality.** Files missing from the bundle; permissions or IAM
      that are too narrow or wildcarded; runtime differences between where
      tests ran and where the code runs.
    - **Seams.** One task's output feeding another task's assumptions; call
      sites a fix missed.
    - **Tests that cannot fail.** Would the test still pass on the old code,
      or with the feature removed?
    - Every Review Focus line in the plan header, and every deferred minor
      in the ledger: does it block?

    The plan's text and the ledger's rulings are claims, not facts. Code
    the plan mandated is not exempt, and a wrong ruling is a finding.

    Do all of this yourself; never dispatch subagents.

    ## Calibration

    - **Critical:** data loss, a security or privacy leak, money lost, a
      wrong external side effect, broken in production.
    - **Important:** a missed requirement, wrong behaviour on a plausible
      input, a test that cannot fail.
    - **Minor:** everything else. Wording and doc nits are always Minor.

    ## Output

    Begin directly with the findings.

    ### Critical
    ### Important
    ### Minor
    For each finding: file:line, what breaks and for whom, the evidence
    (what you checked or ran), and the fix if it is not obvious.

    ### Risks checked
    One line per risk you probed and found clean.

    ### Verdict
    Ready | Ready after fixes | Not ready, followed by one sentence.
```

**Placeholders:**
- `[SPEC]`: the spec file, or the issue reference the plan names
- `[PLAN_PATH]`: the plan file
- `[CONSTRAINTS_FILE]`: `<workspace>/constraints.md`
- `[ADR_PATHS]`: the decision records the plan or spec cites ("none" if there are none)
- `[DIFF_FILE]`: the path that `scripts/review-package PLAN_FILE <START> HEAD` printed
- `[LEDGER_EXCERPT]`: every `minor (deferred)`, `parked` and `Ruling:` line from the ledger, verbatim
- `[START_SHA]`, `[HEAD_SHA]`, `[REPO_PATH]`: the range under review and the checkout it lives in
