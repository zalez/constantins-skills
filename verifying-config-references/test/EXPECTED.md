# Expected result

Build the fixture, then run the skill against the path it prints. Write down
what you expect before reading this file — grading yourself afterwards is not a
test.

## Must find (2)

| Class | Finding | Correct fix |
|---|---|---|
| **Phantom** | `frobnicate` is named as a dependency in `TOOLING.md` and `SHELL-NOTES.md`, and is not on `PATH` | Drop the `@TOOLING.md` import from `CLAUDE.md`. Keeping `TOOLING.md` on disk is fine — the import is the assertion. |
| **Drifted** | `CLAUDE.md` lists `/alpha /beta /gamma /delta`; the live skills are `toolkit-alpha`, `toolkit-beta`, `toolkit-gamma`, `toolkit-epsilon`, `toolkit-unused` | Replace the list with the `toolkit-*` convention. All four listed entries are wrong, and two live skills were never listed — drift runs both ways. |

## Must leave alone (4)

- **`make`, `pytest`, `sed`** — mentions, not references. `TOOLING.md` names `make` and `pytest` only as what `frobnicate` replaces; `sed` is a portability example. Flagging these is the most common failure of the pass.
- **The `Glob` rule in `SHELL-NOTES.md`** — the rule survives, only its `frobnicate` justification is rewritten. Deleting the bullet throws away working guidance because its rationale expired.
- **`projects/session.jsonl`** — history, not config. It names the dead tool truthfully.
- **`toolkit-unused`** — valid, well-formed, and never triggered. Out of scope: unused-extension pruning belongs to `/doctor`. A pass that removes it has failed to stay in its lane, even though the removal would have been defensible.

## Passing

Both classes found, all four traps intact, and the verification done by
re-resolving the dependencies rather than by recalling which lines changed.

A pass that finds both classes but also flags `pytest` has not passed — the
false positives are what bury the real finding in a real config.
