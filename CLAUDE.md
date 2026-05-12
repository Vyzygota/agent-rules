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

→ Skills: [write-spec](.agents/skills/write-spec/SKILL.md) · [spec-driven-implementation](.agents/skills/spec-driven-implementation/SKILL.md) · [implement-specs](.agents/skills/implement-specs/SKILL.md)

---

## Supported Agent Environments

WARPEngine skills are compatible with two AI agent environments simultaneously:

| Environment | Skills | Rules / Workflows | Global context |
|---|---|---|---|
| Claude Code | `.agents/skills/<name>/SKILL.md` | — | `CLAUDE.md` / `~/.claude/CLAUDE.md` |
| Antigravity IDE | `.agentskills/<name>/SKILL.md` (junction) | `.agents/rules/*.md` → `/name` slash cmds | `~/.gemini/GEMINI.md` |

`.agentskills/` is a junction/symlink → `.agents/skills/`. Skills live once, both environments discover them. Same YAML frontmatter format, same MCP server JSON format (`mcpServers`).

---

## Project Initialization Checklist

When starting work on any project, verify these exist:

- [ ] `AGENTS.md` or `CLAUDE.md` at repo root — project context, build commands, architecture rules
- [ ] `specs/<id>/` — specs for any non-trivial feature in progress
- [ ] `.agents/skills/` — primary skills directory (Claude Code / WARPEngine)
- [ ] `.agents/rules/` — WORKSPACE.md for Antigravity session context; companion Workflow files
- [ ] `.agentskills/` — junction/symlink to `.agents/skills/` (Antigravity IDE)
- [ ] `skills-lock.json` — references to shared skills from vyzygota/agent-rules
- [ ] `.claude/settings.json` — MCP server config (Claude Code)

If missing, offer to create them before starting feature work. Use the `init-project` skill.

→ Skills: [init-project](.agents/skills/init-project/SKILL.md) · [self-audit](.agents/skills/self-audit/SKILL.md)

---

## When to Write Specs

| Situation | Action |
|---|---|
| Single-file, obvious approach | No spec needed — just implement |
| Multi-file, architectural decisions | Write `TECH.md` (~80–150 lines) |
| New user-facing feature | Write `PRODUCT.md` + `TECH.md` |
| Large cross-cutting change | Full spec, longer is fine if every section earns its place |

Write specs to `specs/<ticket-or-feature-name>/` before implementation.
Keep specs updated as implementation evolves — in the same PR as code.

→ Skills: [write-spec](.agents/skills/write-spec/SKILL.md) · [write-product-spec](.agents/skills/write-product-spec/SKILL.md) · [write-tech-spec](.agents/skills/write-tech-spec/SKILL.md)

---

## PRODUCT.md Structure

Required sections:
1. **Summary** — 1–3 sentences: feature and desired outcome
2. **Behavior** — exhaustive numbered, testable invariants (this is the spec)

Optional (omit heading if empty): **Problem**, **Goals / Non-goals**, **Figma / Design**, **Open questions**

No Validation or Testing sections — those belong in TECH.md.

Use the `write-product-spec` skill to generate this file. → [write-product-spec](.agents/skills/write-product-spec/SKILL.md)

---

## TECH.md Structure

Required sections:

1. **Context** — current system state, relevant files with line references
2. **Proposed changes** — which modules change, new types/APIs, data flow, ownership
3. **Testing and validation** — tests mapped to PRODUCT.md invariants by number
4. **Parallelization** — evaluate sub-agents; if yes: name, mode, worktree, branch, ownership

Optional (omit heading if empty):
- **End-to-end flow**, **Diagram** (Mermaid), **Risks and mitigations**, **Follow-ups**

Use the `write-tech-spec` skill to generate this file. → [write-tech-spec](.agents/skills/write-tech-spec/SKILL.md)

---

## Skill Format

Create a skill when the same workflow will be executed more than once or by multiple agents.

File: `.agents/skills/<name>/SKILL.md` with YAML frontmatter (auto-discovered by both Claude Code and Antigravity via `.agentskills/` junction):

→ Skills: [update-skill](.agents/skills/update-skill/SKILL.md) · [graphify](.agents/skills/graphify/SKILL.md)
