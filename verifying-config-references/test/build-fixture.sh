#!/usr/bin/env bash
# Builds a throwaway config root containing both classes this skill detects,
# plus the traps a correct pass must leave alone.
#
#   ./build-fixture.sh /tmp/config-rot-fixture
#
# Then run the skill against the directory it prints.

set -euo pipefail
R="${1:-${TMPDIR:-/tmp}/config-rot-fixture}"
rm -rf "$R"; mkdir -p "$R/skills" "$R/projects"

# PHANTOM: an import whose whole subject is a tool that is not installed.
cat > "$R/CLAUDE.md" <<'EOF'
# Working notes

- Use the `git` CLI for version control.
- Available toolkit skills: `/alpha`, `/beta`, `/gamma`, `/delta`

@TOOLING.md

@SHELL-NOTES.md
EOF

cat > "$R/TOOLING.md" <<'EOF'
# frobnicate
All builds go through `frobnicate`. Run `frobnicate build` instead of `make`,
and `frobnicate test` instead of `pytest`.
EOF

# TRAP: good advice whose justification is the dead tool.
cat > "$R/SHELL-NOTES.md" <<'EOF'
# Shell notes
- Prefer the `Glob` tool over shelling out to `find`, because `frobnicate find`
  strips compound predicates (`-not`, `-exec`).
- `sed -i ''` on macOS, `sed -i` on GNU.
EOF

# DRIFT: live skills renamed under a convention; two exist that were never listed.
for s in toolkit-alpha toolkit-beta toolkit-gamma toolkit-epsilon; do
  mkdir -p "$R/skills/$s"
  printf -- "---\nname: %s\ndescription: live.\n---\n" "$s" > "$R/skills/$s/SKILL.md"
done

# OUT OF SCOPE: valid but unused. Belongs to /doctor, not to this skill.
mkdir -p "$R/skills/toolkit-unused"
printf -- "---\nname: toolkit-unused\ndescription: valid but never triggered.\n---\n" \
  > "$R/skills/toolkit-unused/SKILL.md"

# TRAP: history naming the dead tool truthfully.
printf '{"text":"run frobnicate build"}\n' > "$R/projects/session.jsonl"

echo "$R"
