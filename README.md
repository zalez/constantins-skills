# constantins-skills

Claude Code skills by [Constantin Gonzalez](https://constantin.glez.de). A
marketplace, so they update themselves once installed.

## Install

Add the marketplace once, then enable only the plugins you want:

```
/plugin marketplace add zalez/constantins-skills
/plugin install agent-config-hygiene@constantins-skills
/plugin install prompting@constantins-skills
```

Plugins are grouped by theme rather than shipped as one bundle, because
Claude Code's `skillOverrides` setting cannot disable individual **plugin**
skills — only whole plugins. Small plugins keep the choice yours.

## Plugins

### agent-config-hygiene

Two skills for the layer that loads into every session and never complains when
it goes wrong.

`/doctor`, Claude Code's built-in checkup, asks whether your config is **used**.
These ask different questions:

| Skill | Question | Invocation |
|---|---|---|
| `consolidating-skill-systems` | Who **owns** each job, when several skill sets claim it? | you type it |
| `verifying-config-references` | Is what the config asserts still **true**? | fires on its own |

**consolidating-skill-systems** — you installed two or more skill sets. Each is
good. Together they fight: three claim "this is broken", two claim "help me think
this through", and which one fires depends on whose description matched rather
than which is best.

The instinct is to merge them into one curated set. Don't — merging means forking
upstreams you do not control, and the fork rots on every release. This skill
routes instead: eight steps from inventory to a routing block in a file you own,
with the contested calls put to you rather than guessed. Its prime directive is
the whole design: **express every decision in a file you own**, so every vendor
keeps auto-updating. `EXAMPLE.md` is a real run across three systems.

Run it when the sets change, not weekly.

**verifying-config-references** — config makes assertions: *this tool exists*,
*these are the skills*. When the world moves and the assertion doesn't, the
config keeps making it, silently, every session. Two classes, both of which
actively mislead rather than merely sit there:

- **Phantom** — instructions naming a tool that isn't installed. A whole imported
  file of guidance for something uninstalled months ago still loads every
  session, and nothing complains, because the *file* exists.
- **Drifted** — a list of names that no longer matches what it enumerates. A
  rename produces total drift in one stroke.

Neither is covered by `/doctor` or the other config cleaners. Everything they
*do* cover — unused extensions, slow hooks, invalid settings, installation
health — this skill deliberately leaves to them.

It ships with a regression test. Build the fixture, run the skill against it, and
compare against `EXPECTED.md` — but write down what you expect *before* reading
that file:

```bash
./agent-config-hygiene/skills/verifying-config-references/test/build-fixture.sh /tmp/fixture
```

The fixture holds two real findings and four traps. The traps are the point: the
most common failure is flagging every *name* in the config instead of every
*dependency*.

### prompting

**delegation-brief-builder** — turns rough ideas into well-structured prompts,
built on one insight: effective delegation transfers **intent, not
instructions**. Tell the AI what success looks like and why it matters, rather
than what steps to take. Detects whether a task needs a quick Intent Prompt or a
full Delegation Brief, then builds it through conversation. The output is
portable — copy-paste ready for any AI tool.

Background: [How to stop engineering prompts and start
delegating](https://constantin.glez.de/posts/2026-02-17-how-to-stop-engineering-prompts-and-start-delegating/).

## Why one skill is typed and the others fire on their own

Invocation choice follows **frequency**.

`verifying-config-references` and `delegation-brief-builder` are model-invoked:
each fires on situations you wouldn't think to name. They pay their description
in context in every session for that.

`consolidating-skill-systems` is user-invoked (`disable-model-invocation: true`):
a once-a-year exercise you arrive at deliberately. It costs **zero** context and
spends your memory instead — which is what this README is for.

One consequence: `disable-model-invocation` is Claude Code-only and isn't in the
[Agent Skills](https://agentskills.io) spec, so that skill can't be packaged as a
`.skill` file or uploaded to claude.ai. Dropping the line would make it portable,
at the cost of paying its description in every session forever. For a
once-a-year skill, the gate is the better trade.

## Status

The two `agent-config-hygiene` skills have been run against real configuration —
the consolidation skill produced the setup described in its `EXAMPLE.md`, and the
verification skill was tested twice against purpose-built fixtures, the second of
which ships as its regression test.

Neither has been run by anyone other than its author, on any configuration other
than the one it was written against. The phrasing aims to be harness-neutral —
"the highest-priority always-loaded instruction file your harness reads" rather
than `CLAUDE.md` — but that has never met a setup shaped differently. Reports of
where it breaks are the most useful thing you can send.

`delegation-brief-builder` has been in use since February 2026 and was previously
published as a standalone `.skill` download.

## License

[BSD 3-Clause](LICENSE).
