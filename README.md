# agent-config-hygiene

Two skills for the layer that loads into every session and never complains when
it goes wrong.

Coding agents accumulate configuration: instruction files, skills from several
vendors, plugins, hooks. None of it errors when it rots. It just quietly steers
the agent toward tools that are gone, names that changed, and jobs three skills
all claim to own.

`/doctor` — Claude Code's built-in checkup — asks whether your config is **used**.
These two ask different questions:

| Skill | Question | Invocation |
|---|---|---|
| [`consolidating-skill-systems`](consolidating-skill-systems/) | Who **owns** each job, when several skill sets claim it? | user-invoked |
| [`verifying-config-references`](verifying-config-references/) | Is what the config asserts still **true**? | model-invoked |

## consolidating-skill-systems

You installed two or more skill sets. Each is good. Together they fight: three
claim "this is broken", two claim "help me think this through", and which one
fires depends on whose description matched rather than which is best.

The instinct is to merge them into one curated set. Don't — merging means
forking upstreams you do not control, and the fork rots on every release. This
skill routes instead: eight steps from inventory to a routing block in a file
you own, with the contested calls put to you rather than guessed.

The prime directive is the whole design: **express every decision in a file you
own**, so all three vendors keep auto-updating.

[`EXAMPLE.md`](consolidating-skill-systems/EXAMPLE.md) is a real run across three
systems — 100+ skills, a listing 4.5× over budget, six invocation-gated skills,
one vendor flag that renamed 37 skills in a single command.

**Run it when the sets change, not weekly.**

## verifying-config-references

Config makes assertions: *this tool exists*, *these are the skills*. When the
world moves and the assertion doesn't, the config keeps making it — silently,
every session.

Two classes, both of which actively mislead rather than merely sit there:

- **Phantom** — instructions naming a tool that isn't installed. A whole imported
  file of guidance for something uninstalled months ago still loads every
  session, and nothing complains because the *file* exists.
- **Drifted** — a list of names that no longer matches what it enumerates. A
  rename produces total drift in one stroke.

Neither is covered by `/doctor`, `config-gc`, or anything else we could find.
Everything they *do* cover — unused extensions, slow hooks, invalid settings,
installation health — this skill deliberately leaves to them.

It ships with a regression test. Build the fixture, run the skill against it, and
compare with [`EXPECTED.md`](verifying-config-references/test/EXPECTED.md) — but
write down what you expect *before* reading that file:

```bash
./verifying-config-references/test/build-fixture.sh /tmp/fixture
```

The fixture contains two real findings and four traps. The traps are the point:
the most common failure is flagging every *name* in the config instead of every
*dependency*.

## Install

Symlink, so `git pull` keeps you current — Claude Code follows symlinks from the
skills directory:

```bash
git clone <this-repo> ~/dev/agent-config-hygiene
ln -s ~/dev/agent-config-hygiene/consolidating-skill-systems ~/.claude/skills/
ln -s ~/dev/agent-config-hygiene/verifying-config-references ~/.claude/skills/
```

Or copy the two directories into `~/.claude/skills/` if you'd rather pin them.

## Why one is typed and one fires on its own

The invocation choice follows **frequency**, and the pair demonstrates both ends
of it.

`verifying-config-references` is model-invoked: rot is exactly what you don't
notice yourself, so the agent has to raise it. It pays ~100 tokens of context in
every session for that.

`consolidating-skill-systems` is user-invoked (`disable-model-invocation: true`):
a once-a-year exercise you arrive at deliberately. It costs **zero** context and
spends cognitive load instead — you have to remember it exists, which is what a
README is for.

One consequence worth knowing: `disable-model-invocation` is Claude Code-only and
isn't in the [Agent Skills](https://agentskills.io) spec, so
`consolidating-skill-systems` cannot be packaged as a `.skill` file or uploaded
to claude.ai. Dropping that one line would make it portable, at the cost of
paying its description in every session forever. For a once-a-year skill, the
gate is the better trade.

## Status

Both skills have been run against real configuration. The consolidation skill
produced the setup described in its `EXAMPLE.md`; the verification skill was
tested twice against purpose-built fixtures, and the second run is the one that
ships as its regression test.

Neither has been run by anyone other than its author, on any configuration other
than the one it was written against. The phrasing aims to be harness-neutral —
"the highest-priority always-loaded instruction file your harness reads" rather
than `CLAUDE.md` — but that has never met a setup shaped differently.

Reports of where it breaks are the most useful thing you can send back.

## License

Not yet chosen — add one before sharing beyond individuals, since without it the
default is all-rights-reserved and nobody can legitimately reuse these.
