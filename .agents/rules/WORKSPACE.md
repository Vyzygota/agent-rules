# WARPEngine — agent-rules Workspace

@../../AGENTS.md

## Workspace Purpose

This is the canonical WARPEngine skill library. Every skill here is propagated to all vyzygota projects via `skills-lock.json`. Changes to skills in this repo affect every downstream project on next sync.

## Agent Mode

- **Planning mode** — for new skills, structural changes, or spec work (spec → SKILL.md → commit)
- **Fast mode** — for updating existing skills, fixing self-audit drift, or single-file edits

## First Action Each Session

Run `/self-audit` before any other work. It checks repo structure, rebuilds the knowledge graph if stale, and flags whether `warp-watch` is due.

## Key Invariants

1. Skills live in `.agents/skills/<name>/SKILL.md` — one source, never duplicate
2. `.agentskills/` is a junction → `.agents/skills/` — never copy SKILL.md manually
3. Every new skill must be added to `skills-lock.json` AND `README.md`
4. `CLAUDE.md` and `AGENTS.md` stay in sync on philosophy and checklist sections
5. `warp-watch` runs every 2 weeks — check `warp-watch.md` for last sync date

## Skills Available

All skills in `.agents/skills/` are auto-discovered via the `.agentskills/` junction.
Key invocations: `/self-audit`, `/warp-watch`, `/init-project`, `/write-spec`, `/graphify`
