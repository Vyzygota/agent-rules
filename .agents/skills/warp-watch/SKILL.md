---
name: warp-watch
description: Run the warp-watch protocol — check warpdotdev/warp and warpdotdev/common-skills for updates, evaluate what's relevant to adopt, and update CLAUDE.md/AGENTS.md + skills accordingly. Use when the user says "sprawdź Warp", "zaktualizuj zasady", "co nowego w Warp", or at the start of a new project month.
---

# warp-watch

Run the monthly warp-watch synchronization protocol against the Warp ecosystem.

## Overview

Keeps `vyzygota/agent-rules` aligned with Warp's evolving agentic development model. Run once a month or whenever prompted.

## Prerequisites

- Network access to GitHub API (`gh` CLI authenticated)
- Write access to `vyzygota/agent-rules`

## Sources to check

| Source | What to look for |
|---|---|
| `gh api "repos/warpdotdev/warp/commits?per_page=20&since=<last-sync>"` | Changes to WARP.md, .agents/, specs/, skills-lock.json |
| `gh api repos/warpdotdev/common-skills/contents/.agents/skills` | New or updated SKILL.md files |
| `https://docs.warp.dev/changelog/2026/` | New platform features relevant to agents/skills/specs |

## Workflow

### 1. Fetch new commits from warpdotdev/warp

```bash
gh api "repos/warpdotdev/warp/commits?per_page=20&since=<LAST_SYNC_DATE>T00:00:00Z"
```

Focus on files: `WARP.md`, `.agents/`, `specs/`, `skills-lock.json`.

### 2. Fetch skill list from common-skills

```bash
gh api repos/warpdotdev/common-skills/contents/.agents/skills
```

Compare against skills tracked in `skills-lock.json`. For any new skill, fetch its SKILL.md:

```bash
gh api repos/warpdotdev/common-skills/contents/.agents/skills/<name>/SKILL.md \
  | python -c "import sys,json,base64; d=json.load(sys.stdin); print(base64.b64decode(d['content']).decode())"
```

### 3. Fetch changelog

Fetch `https://docs.warp.dev/changelog/2026/` and scan for entries related to agents, skills, specs, or agentic workflows.

### 4. Evaluate what to adopt

**Adopt** if the change affects: PRODUCT.md/TECH.md format, SKILL.md format, AGENTS.md conventions, PR workflow, or agent execution model.

**Skip** if it's: Rust/Warp-app-specific implementation, desktop UI, enterprise/team features, or Linear-specific tooling with no generic equivalent.

| Relevant | Skip |
|---|---|
| Spec format (PRODUCT.md, TECH.md) | Rust-specific (`cargo`, clippy) |
| SKILL.md structure | Desktop UI changes |
| Agent execution model | Linear MCP (use generic issue tracker) |
| PR workflow conventions | Enterprise/team-only features |
| Parallelization patterns | `warp-integration-test` (Warp-internal) |

### 5. Adapt and create skills

Strip language/toolchain specifics and make adopted skills language-agnostic. Place in `.agents/skills/<name>/SKILL.md`.

### 6. Update repository

- Add new skills to `.agents/skills/`
- Update `skills-lock.json`
- Update "Last synced with Warp" date in `CLAUDE.md` and `AGENTS.md`
- Add a row to the `## Ostatnie sprawdzenia` table in `warp-watch.md`
- Commit and push to `vyzygota/agent-rules`

## Best Practices

- Only adopt patterns that improve clarity or correctness — don't change conventions for novelty
- Always update the "Last synced" date even if nothing changed

## Related Skills

- `init-project`
- `write-spec`
- `update-skill`
