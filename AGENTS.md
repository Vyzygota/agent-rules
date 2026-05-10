# Global Agent Development Principles

Inspired by Warp's agentic development model (warpdotdev/warp, warpdotdev/common-skills).
Source of truth: https://github.com/vyzygota/agent-rules
Last synced with Warp: 2026-05-10

---

## Philosophy: Spec-Driven Agentic Development

Before writing code, write specs. Before writing specs, understand the problem.
Agent work is most effective when:
1. Anchored to precise specifications (PRODUCT.md + TECH.md)
2. Decomposed into reusable, named skills (.agents/skills/)
3. Reviewed before merging — agent review first, then human
4. Parallelized when subtasks are genuinely independent

Human role: decide what matters, define behavior, review tradeoffs.
Agent role: execute mechanical work, keep specs current, flag ambiguity.

---

## Supported Agent Environments

WARPEngine skills work across two AI agent environments simultaneously:

| Environment | Skills path | Format |
|---|---|---|
| Claude Code | `.agents/skills/<name>/SKILL.md` | YAML frontmatter + markdown |
| Antigravity IDE (Google) | `.agentskills/<name>/SKILL.md` | YAML frontmatter + markdown |

`.agentskills/` is a junction/symlink pointing to `.agents/skills/` — skills live in one place, both environments discover them. MCP config is identical across both (same `mcpServers` JSON format).

---

## Project Initialization Checklist

When starting work on any project, verify these exist:

- [ ] `AGENTS.md` or `CLAUDE.md` at repo root — project context, build commands, architecture rules
- [ ] `specs/<id>/` — specs for any non-trivial feature in progress
- [ ] `.agents/skills/` — primary skills directory (Claude Code / WARPEngine)
- [ ] `.agentskills/` — junction/symlink to `.agents/skills/` (Antigravity IDE)
- [ ] `skills-lock.json` — references to shared skills from vyzygota/agent-rules
- [ ] `.claude/settings.json` — MCP server config (Claude Code)

If missing, offer to create them before starting feature work. Use the `init-project` skill.

---

## When to Write Specs

| Situation | Action |
|---|---|
| Single-file, obvious approach | No spec needed — just implement |
| Multi-file, architectural decisions | Write `TECH.md` (~80–150 lines) |
| New user-facing feature | Write `PRODUCT.md` + `TECH.md` |
| Large cross-cutting change | Full spec, longer is fine if every section earns its place |

---

## PR Workflow

1. Feature branch — never push directly to main
2. Specs and code in same PR
3. Draft PR early, self-review before marking ready
4. Keep specs updated as implementation evolves

---

## Parallelization

Evaluate for every non-trivial feature. In TECH.md specify: agent name, execution mode (local/remote), worktree, branch, file ownership, merge strategy.

---

## AGENTS.md Per Project

Minimum: project name, tech stack, build/test/lint commands, architecture rules, key files.

---

## Warp-Watch Protocol

Run when starting new projects, monthly, or on request. See `warp-watch.md`.
